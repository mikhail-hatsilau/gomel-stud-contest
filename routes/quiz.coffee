db = require '../database'

module.exports.get = (next) ->
  if not this.session.passedForm or this.session.passedQuiz
    this.throw 'Forbidden', 403
  yield this.render 'quiz'

module.exports.quiz = (next) ->
  QUIZ_STEP_ID = 2
  taskNumber = this.params.taskNumber

  resp = yield db.getTaskByDisplayNumber taskNumber, QUIZ_STEP_ID
  rows = resp[0]

  this.body = 
    taskId: rows[0].id
    deprecatedSelectors: rows[0].deprecatedSelectors
    answares: rows[0].answares
    htmlCode: rows[0].htmlCode

