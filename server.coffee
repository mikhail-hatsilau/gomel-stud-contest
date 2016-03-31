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
  tasks = []
  for row in rows
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
    tasks.push task

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
  # socket.on 'ready to start', ->
  #   socket.join 'ready room'
  #   socket.broadcast.emit 'add user', socket.request.user

  socket.on 'init quiz', ->
    socket.broadcast.emit 'init'

  socket.on 'begin', (time, callback) ->
    QUIZ_STEP_ID = 2
    # io.to 'ready room'
    #   .emit 'start quiz', time * 60
    db.getActiveTasksPromise QUIZ_STEP_ID
      .then (resp) ->
        db.clearQuizResults()
        tasks = getTasks resp[0]
        socket.broadcast.emit 'next', {
          time: time,
          taskId: tasks[0].id
        }
        callback tasks

  socket.on 'next task', (data) ->
    # io.to 'ready room'
    #   .emit 'next', time * 1000
    socket.broadcast.emit 'next', {
      time: data.timeLimit,
      taskId: data.taskId
    }

  socket.on 'pass test', (data) ->
    data.user = socket.request.user
    socket.broadcast.emit 'test passed', data
    db.saveQuizResults data, socket.request.user.id
  
httpServer.listen config.get('port')
