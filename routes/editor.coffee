utils = require '../utils'
db = require '../database'
FirstStepTask = require '../models/firstStepTask'

module.exports.get = (next) ->
  if this.session.passedQuiz
    this.throw 'Forbidden', 403
  yield this.render 'editor', { editorPage: true }

module.exports.save = (next) ->
  taskId = this.request.body.taskId
  time = this.request.body.time / 1000
  htmlCode = this.request.body.htmlCode
  cssCode = this.request.body.cssCode

  pathToFile = utils.getFilePath this.session.user.id, this.session.user.username, taskId
  yield db.saveFirstStepResults this.session.user.id, taskId, time, htmlCode, cssCode, pathToFile

  this.body = {
    status: 'ok'
  }

module.exports.next = (next) ->
  FIRST_STEP_ID = 1
  taskNumber = parseInt this.params.task

  resp = yield db.getTaskByDisplayNumber taskNumber, FIRST_STEP_ID
  rows = resp[0]

  if not rows.length
    this.throw 'No such task', 404

  task = new FirstStepTask(
    rows[0].id,
    rows[0].name,
    rows[0].displayNumber,
    rows[0].weight,
    rows[0].htmlCode,
    rows[0].cssCode,
    rows[0].toDo
  )

  resp = yield db.getTaskByDisplayNumber taskNumber + 1, FIRST_STEP_ID
  rows = resp[0]

  this.body = {
    task: task
    next: !!rows.length
  }
