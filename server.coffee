koa = require 'koa'
serve = require 'koa-static'
koaBody = do require 'koa-bodyparser'
passport = require 'koa-passport'
json = require 'koa-json'
validate = require 'koa-validate'
path = require 'path'
config = require 'config'
router = require './routes'
views = require 'koa-views'
http = require 'http'
socket = require 'socket.io'
cookie = require 'cookie'
session = require 'koa-session'
db = require './database'

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

db.createConnection()

require './auth'
app.use passport.initialize()
app.use passport.session()

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
  this.state.user = this.req.user
  yield next

router(app)

app.use serve(path.join __dirname, '/dist' )

io.use (socket, next) ->
  handShakeData = socket.request
  if handShakeData.headers.cookie && handShakeData.headers.cookie.indexOf('koa:sess') > -1
    cookieData = cookie.parse(handShakeData.headers.cookie)['koa:sess']
    parsedUser = JSON.parse(new Buffer(cookieData, 'base64'))
    if parsedUser.passport.user is undefined
      next new Error('Not authorized')
      return
    handShakeData.user = parsedUser.passport.user
    next()
  else
    next new Error('Not authorized')

require('./socket')(io)

app.use (next) ->
  yield this.render 'error', {
    errorStatus: 404,
    errorMessage: 'The page not found'
  }

httpServer.listen config.get('port')
