koa = require 'koa'
serve = require 'koa-static'
koaBody = do require 'koa-body'
json = require 'koa-json'
validate = require 'koa-validate'
path = require 'path'
config = require 'config'
router = require './routes'
views = require 'koa-views'
http = require 'http'
socket = require 'socket.io'
cookie = require 'cookie'
db = require './database'
QuizStepTask = require './models/quizStepTask'

app = koa()
httpServer = http.createServer app.callback()
io = socket httpServer

app.use json()
app.use koaBody
app.use validate()
app.keys = ['contest']

app.use(views path.join(__dirname, '/views') , {
  extension: 'jade'
})

app.use (next) ->
  try
    yield next
  catch error
    console.log error
    this.status = error.status || 500
    yield this.render 'error', {
      errorStatus: error.status,
      errorMessage: error.message
    }

app.use (next) ->
  this.state.user = this.session.user
  yield next

router(app)

app.use serve(path.join __dirname, '/dist' )

db.createConnection()

getTasks = (rows) ->
  tasks = for row in rows
    task = new QuizStepTask(
      row.id,
      row.name,
      row.displayNumber,
      row.weight,
      row.answares,
      row.deprecatedSelectors,
      row.htmlCode,
      row.active
    )

  tasks.sort (a, b) ->
    a.displayNumber - b.displayNumber

  tasks

io.use (socket, next) ->
  handShakeData = socket.request
  if handShakeData.headers.cookie && handShakeData.headers.cookie.indexOf('koa:sess') > -1
    cookieData = cookie.parse(handShakeData.headers.cookie)['koa:sess']
    parsedUser = JSON.parse(new Buffer(cookieData, 'base64'))
    handShakeData.user = parsedUser.user
    next()
  else
    next(new Error('Not authorized'))

io.on 'connection', (socket) ->
  if socket.request.user.role.name is 'admin'
    socket.join 'admin room'
  else
    socket.join 'students room'

  socket.on 'init quiz', (data, callback) ->
    QUIZ_STEP_ID = 2
    db.getActiveTasksPromise QUIZ_STEP_ID
      .then (resp) ->
        # db.clearQuizResults()
        tasks = getTasks resp[0]
        io.to('students room').emit 'init'
        callback tasks

  socket.on 'ready', ->
    socket.join 'ready room'
    io.to('admin room').emit 'add user', socket.request.user

  # socket.on 'begin', (time, callback) ->
  #   # io.to 'ready room'
  #   #   .emit 'start quiz', time * 60
   
        
  #       callback tasks
  #   io.to('ready room').emit 'next', {
  #     time: time,
  #     taskId: tasks[0].id
  #   }

  socket.on 'next task', (data, callback) ->
    # io.to 'ready room'
    #   .emit 'next', time * 1000
    io.to 'ready room'
      .emit 'next', {
        time: data.timeLimit,
        taskId: data.taskId
      }

    callback()

  socket.on 'pass test', (data) ->
    data.user = socket.request.user
    io.to('admin room').emit 'test passed', data
    db.getQuizResults socket.request.user.id, data.taskId
      .then (resp) ->
        rows = resp[0]
        if rows.length
          if data.time < rows[0].time
            db.updateQuizResults data, socket.request.user.id
        else
          db.saveQuizResults data, socket.request.user.id

  socket.on 'stop task', (data, callback) ->
    io.to('students room').emit 'stop'
    console.log callback
    callback()

  socket.on 'start step1', ->
    io.to('students room').emit 'start first step'
  
httpServer.listen config.get('port')
