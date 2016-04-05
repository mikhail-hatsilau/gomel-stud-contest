db = require '../database'
QuizStepTask = require '../models/quizStepTask'

# TIME_LIMIT_OPTION = 'timeLimit'
# WAITING_TIME_OPTION = 'quizWaitingTime'

QUIZ_STEP_ID = 2

module.exports.get = (next) ->
  # if not this.session.passedForm or this.session.passedQuiz
  #   this.throw 'Forbidden', 403
  yield this.render 'quiz'

module.exports.quiz = (next) ->
  taskId = this.params.taskId
  userId = this.session.user.id

  # resp = yield db.quizResultsOfStudent taskId, userId

  # if resp[0].length
  #   this.response.status = 403
  #   this.body = 
  #     status: 'error'
  #     message: 'You have already passed this task!'
  #   return

  resp = yield db.getTaskById taskId
  rows = resp[0]

  if not rows.length 
    this.response.status = 404
    this.body =
      status: 'error'
      message: 'No such task'
    return

  # resp = yield db.getSettingsByName TIME_LIMIT_OPTION
  # settingsRows = resp[0]

  this.body = 
    taskId: rows[0].id
    deprecatedSelectors: rows[0].deprecatedSelectors
    answares: rows[0].answares
    htmlCode: rows[0].htmlCode

module.exports.ready = (next) ->
  yield this.render 'readyQuiz'

module.exports.quizTasks = (next) ->
  # QUIZ_STEP_ID = 2
  resp = yield db.getActiveTasks QUIZ_STEP_ID
  rows = resp[0]

  tasks = for row in rows
    task = new QuizStepTask(
      row.id,
      row.name,
      row.displayNumber,
      row.weight,
      row.answares,
      row.deprecatedSelectors,
      row.htmlCode
    )

  this.body = 
    tasks: tasks

module.exports.clear = (next) ->
  try
    yield db.clearQuizResults()
    this.body =
      status: 'ok'
      message: 'Quiz results were cleared'
  catch error
    console.log error
    this.response.status = 500
    this.body = 
      status: 'error'
      message: 'Error occured while clearing quiz results'

# module.exports.settings = (next) ->
#   resp = yield db.getSettings()
#   rows = resp[0]

#   # useTimeLimit = false
#   # time = rows[0].value

#   # resp = yield

#   # if time isnt null
#   #   useTimeLimit = true

#   yield this.render 'settings', {
#     settings: rows
#   }

# module.exports.saveSettings = (next) ->
#   activeTimeLimit = if this.request.body["active_#{TIME_LIMIT_OPTION}"] is 'true' then true else false
#   timeLimit = this.request.body[TIME_LIMIT_OPTION]
#   activeWaitingTime = if this.request.body["active_#{WAITING_TIME_OPTION}"] is 'true' then true else false
#   waitingTime = this.request.body[WAITING_TIME_OPTION]

#   yield db.updateSettings TIME_LIMIT_OPTION, timeLimit, activeTimeLimit
#   yield db.updateSettings WAITING_TIME_OPTION, waitingTime, activeWaitingTime

#   this.redirect '/'

# module.exports.finishQuiz = (next) ->
#   if this.session.passedQuiz
#     this.throw 'You have already passed the quiz!', 403

#   this.session.passedQuiz = true

#   this.body =-
#     status: 'ok'

module.exports.quizTaskComplete = (next) ->
  yield this.render 'quizTaskComplete'

