db = require '../database'
QuizStepTask = require '../models/quizStepTask'

QUIZ_STEP_ID = 2

module.exports.get = (next) ->
  yield this.render 'quiz'

module.exports.quiz = (next) ->
  taskId = this.params.taskId
  userId = this.req.user.id

  resp = yield db.getTaskById taskId
  rows = resp[0]

  if not rows.length 
    this.response.status = 404
    this.body =
      status: 'error'
      message: 'No such task'
    return

  this.body = 
    taskId: rows[0].id
    deprecatedSelectors: rows[0].deprecatedSelectors
    answares: rows[0].answares
    htmlCode: rows[0].htmlCode

module.exports.ready = (next) ->
  yield this.render 'readyQuiz'

module.exports.quizTasks = (next) ->
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

module.exports.quizTaskComplete = (next) ->
  yield this.render 'quizTaskComplete'

