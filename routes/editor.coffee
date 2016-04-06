utils = require '../utils'
db = require '../database'
FirstStepTask = require '../models/firstStepTask'

module.exports.get = (next) ->
  # if this.session.passedQuiz
  #   this.throw 'Forbidden', 403
  yield this.render 'editor', { editorPage: true }

module.exports.save = (next) ->
  taskId = this.request.body.taskId
  time = this.request.body.time
  htmlCode = this.request.body.htmlCode
  cssCode = this.request.body.cssCode

  pathToFile = utils.getFilePath this.req.user.id, this.req.user.username, taskId
  yield db.saveFirstStepResults this.req.user.id, taskId, time, htmlCode, cssCode, pathToFile

  this.body = {
    status: 'ok'
  }

module.exports.next = (next) ->
  FIRST_STEP_ID = 1
  taskNumber = parseInt this.params.task

  resp = yield db.getActiveTaskByDisplayNumber taskNumber, FIRST_STEP_ID
  rows = resp[0]

  if not rows.length
    this.response.status = 404
    this.body = 
      status: 'error'
      message: 'No such task'
    return

  # loop
  #   resp = yield db.getTaskByDisplayNumber taskNumber, FIRST_STEP_ID
  #   rows = resp[0]
  #   taskNumber++
  #   break if not rows.length or rows[0].active

  task = new FirstStepTask(
    rows[0].id,
    rows[0].name,
    rows[0].displayNumber,
    rows[0].weight,
    rows[0].htmlCode,
    rows[0].cssCode,
    rows[0].toDo,
    rows[0].active
  )

  # if not task.active
  #   this.response.status = 403
  #   this.body = 
  #     status: 'Error'
  #     message: 'Next task is not opened yet'
  #   return 

  this.body =
    task: task
    nextTaskExists: !!rows[1]

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
