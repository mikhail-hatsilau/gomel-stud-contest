router = do require 'koa-router'
session = require 'koa-session'
checkAuth = require '../middleware/checkAuth'
adminAccess = require '../middleware/adminAccess'

module.exports = (app) ->
  app
  .use router.routes()
  .use router.allowedMethods()

  router.use session(app)

  router.get '/', require('./frontPage').get
  router.get '/login', require('./login').get
  router.post '/login', require('./login').post
  router.get '/logout', checkAuth, require('./logout')
  router.get '/editor', checkAuth, require('./editor').get
  router.post '/save', checkAuth, require('./savePage').post
  router.post '/saveAdmin', checkAuth, adminAccess, require('./savePage').postAdmin
  router.post '/pass', checkAuth, require('./passForm').post
  router.get '/quiz', checkAuth, require('./quiz').get
  router.post '/endQuiz', checkAuth, require('./endQuiz')
  router.get '/results', checkAuth, require('./results')
  router.post '/saveResults', checkAuth, adminAccess, require('./results').save
  router.get '/users', checkAuth, adminAccess, require('./users').getAll
  router.get '/users/:userId', checkAuth, adminAccess, require('./users').getUser
  router.get '/roles', checkAuth, adminAccess, require('./roles')
  router.post '/addUser', checkAuth, adminAccess, require('./actionsWithUser').add
  router.post '/removeUser', checkAuth, adminAccess, require('./removeuser')
  router.get '/quizBoard', checkAuth, adminAccess, require('./quizBoard')
  router.get '/quizResults', checkAuth, adminAccess, require('./quizResults')
  router.get '/firstStepResults', checkAuth, adminAccess, require('./firstStepResults').results
  router.get '/saveFile/:userId/:taskId', checkAuth, adminAccess, require('./saveFile')
  router.get '/next/:task', checkAuth, require('./editor').next
  router.post '/saveTaskResults', checkAuth, require('./editor').save
  router.get '/showMarkup/:userId/:taskNumber', checkAuth, adminAccess, require('./firstStepResults').showMarkup
  router.post '/activateUser', checkAuth, adminAccess, require('./actionsWithUser').activate
  router.post '/editUser', checkAuth, adminAccess, require('./actionsWithUser').edit
  router.get '/firstStepTasks', checkAuth, adminAccess, require('./tasks').getFirstStepTasks
  router.get '/quizStepTasks', checkAuth, adminAccess, require('./tasks').getQuizTasks
  router.get '/editFirstStepTask/:taskId', checkAuth, adminAccess, require('./tasks').editFirstStepTask
  router.get '/addFirstStepTask', checkAuth, adminAccess, require('./tasks').addFirstStepTask
  router.get '/editQuizStepTask/:taskId', checkAuth, adminAccess, require('./tasks').editQuizStepTask
  router.get '/addQuizStepTask', checkAuth, adminAccess, require('./tasks').addQuizStepTask
  router.post '/saveQuizStepTask', checkAuth, adminAccess, require('./tasks').saveQuizStepTask
  router.post '/saveFirstStepTask', checkAuth, adminAccess, require('./tasks').saveFirstStepTask
  router.post '/saveQuizStepTask/:taskId', checkAuth, adminAccess, require('./tasks').updateQuizStepTask
  router.post '/saveFirstStepTask/:taskId', checkAuth, adminAccess, require('./tasks').updateFirstStepTask
  router.post '/removeTask', checkAuth, adminAccess, require('./tasks').removeTask
  router.post '/activateTask', checkAuth, adminAccess, require('./tasks').activateTask
  router.get '/quizTasks/:taskNumber', checkAuth, require('./quiz').quiz
  router.get '/total', checkAuth, adminAccess, require('./results').total