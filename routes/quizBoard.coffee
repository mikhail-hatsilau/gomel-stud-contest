db = require '../database'
utils = require '../utils'
QuizStepTask = require '../models/quizStepTask'

module.exports = (next) ->
  QUIZ_STEP_ID = 2
  resp = yield db.getTasks QUIZ_STEP_ID
  rows = resp[0]
  allTasks = []

  for row in rows
    task = new QuizStepTask(
      row.id,
      row.name,
      row.displayNumber,
      row.weight,
      row.answares,
      row.deprecatedSelectors,
      row.htmlCode
    )
    allTasks.push task

  allTasks.sort (a, b) ->
    a.displayNumber - b.displayNumber

  yield this.render 'quizBoard', { allTasks: allTasks }
