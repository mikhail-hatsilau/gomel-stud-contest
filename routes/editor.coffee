_ = require 'lodash'
utils = require '../utils'
db = require '../database'
FirstStepTask = require '../models/firstStepTask'

FIRST_STEP_ID = 1

module.exports.get = (next) ->
  yield this.render 'editor', { contentClass: 'editor-page' }

module.exports.save = (next) ->
  taskId = this.request.body.taskId
  time = this.request.body.time
  htmlCode = this.request.body.htmlCode
  cssCode = this.request.body.cssCode

  resp = yield db.getFirstStepTaskResults this.req.user.id, taskId
  resultRows = resp[0]

  if resultRows.length
    yield db.updateFirstStepResult this.req.user.id, taskId, time, htmlCode, cssCode
  else
    pathToFile = utils.getFilePath this.req.user.id, this.req.user.username, taskId
    yield db.saveFirstStepResults this.req.user.id, taskId, time, htmlCode, cssCode, pathToFile

  this.body = {
    status: 'ok'
  }

module.exports.init = () ->
  resp = yield db.getActiveTasks FIRST_STEP_ID
  rows = resp[0]

  if not rows.length
    this.response.status = 404
    this.body =
      status: 'error'
      message: 'No tasks'

  rows = _.sortBy(rows, ['displayNumber']);

  this.body =
    tasksIds: rows.map((task) -> task.id)

module.exports.next = () ->
  taskId = parseInt this.params.taskId

  resp = yield db.getTaskById taskId
  rows = resp[0]

  task = _.merge({}, rows[0]);

  resp = yield db.getFirstStepTaskResults(this.req.user.id, taskId)
  resultRows = resp[0]

  if resultRows.length
    task.htmlCode = resultRows[0].htmlCode
    task.cssCode = resultRows[0].cssCode
    task.initTime = resultRows[0].time

  this.body =
    task: task

module.exports.prev = () ->
  taskId = parseInt this.params.taskId

  resp = yield db.getFirstStepTaskResults this.req.user.id, taskId

  taskResult = resp[0][0]

  resp = yield db.getTaskById taskId

  task = _.merge({}, resp[0][0])
  task.htmlCode = taskResult.htmlCode
  task.cssCode = taskResult.cssCode
  task.initTime = taskResult.time

  this.body =
    task: task

module.exports.passForm = (next) ->
  QUIZ_WAIT_TIME_OPTION = 'quizWaitingTime'
  yield next
  requestBody = this.request.body
  this.checkBody('firstName').notEmpty().isAlpha()
  this.checkBody('lastName').notEmpty().isAlpha()

  if this.errors
    this.status = 400
    this.body = this.errors
  else
    currentUser = this.req.user
    this.session.passedForm = true
    if requestBody.firstName is currentUser.firstName and
    requestBody.lastName is currentUser.lastName
      this.body =
        status: 'ok'
        message: 'You successfully passed the form. You will be redirected to the home page in 30 seconds.'
    else
      this.status = 403
      this.body = [{error: 'No such user!'}]
