db = require '../database'
FirstStepTask = require '../models/firstStepTask'
QuizStepTask = require '../models/quizStepTask'

module.exports.getFirstStepTasks = (next) ->
  FIRST_STEP_ID = 1
  resp = yield db.getTasks FIRST_STEP_ID
  rows = resp[0]
  tasks = []
  for row in rows
    task = new FirstStepTask row.id, row.name, row.displayNumber, row.weight, row.htmlCode, row.cssCode, row.toDo, row.active
    tasks.push task

  console.log tasks
  yield this.render 'firstStepTasks', { tasks: tasks }

module.exports.getQuizTasks = (next) ->
  QUIZ_STEP_ID = 2
  resp = yield db.getTasks QUIZ_STEP_ID
  rows = resp[0]
  tasks = []
  for row in rows
    task = new QuizStepTask row.id, row.name, row.displayNumber, row.weight, row.answares, row.deprecatedSelectors, row.htmlCode, row.active
    tasks.push task

  yield this.render 'quizStepTasks', { tasks: tasks }

module.exports.addFirstStepTask = (next) ->
  task = {}
  yield this.render 'firstStepEditTask', { task: task }

module.exports.addQuizStepTask = (next) ->
  task = {}
  yield this.render 'quizStepEditTask', { task: task }

module.exports.editFirstStepTask = (next) ->
  resp = yield db.getTask this.params.taskId
  rows = resp[0]
  if not rows.length
    this.throw 'No such task', 404
  task = new FirstStepTask rows[0].id, rows[0].name, rows[0].displayNumber, rows[0].weight, rows[0].htmlCode, rows[0].cssCode, rows[0].toDo, rows[0].active

  yield this.render 'firstStepEditTask', { task: task }

module.exports.editQuizStepTask = (next) ->
  resp = yield db.getTask this.params.taskId
  rows = resp[0]
  if not rows.length
    this.throw 'No such task', 404
  task = new QuizStepTask rows[0].id, rows[0].name, rows[0].displayNumber, rows[0].weight, rows[0].answares, rows[0].deprecatedSelectors, rows[0].htmlCode, rows[0].active
  console.log task
  yield this.render 'quizStepEditTask', { task: task }

module.exports.saveFirstStepTask = (next) ->
  taskName = this.request.body.taskName
  displayNumber = this.request.body.displayNumber
  weight = this.request.body.weight
  theTask = this.request.body.theTask
  htmlCode = this.request.body.htmlCode
  cssCode = this.request.body.cssCode

  resp = yield db.addFirstStepTask(taskName, displayNumber, weight, htmlCode, cssCode, theTask)

  task = new FirstStepTask resp[0].insertId, taskName, displayNumber, weight, htmlCode, cssCode, theTask

  this.body = 
    status: 'ok'
    task: task

module.exports.saveQuizStepTask = (next) ->
  taskName = this.request.body.taskName
  displayNumber = this.request.body.displayNumber
  weight = this.request.body.weight
  answares = this.request.body.answares
  htmlCode = this.request.body.htmlCode
  deprecatedSelectors = this.request.body.deprecatedSelectors
  active = true

  resp = yield db.addQuizStepTask(taskName, displayNumber, weight, answares, deprecatedSelectors, htmlCode)

  task = new QuizStepTask resp[0].insertId, taskName, displayNumber, weight, htmlCode, answares, deprecatedSelectors, 
  console.log task

  this.body = 
    status: 'ok'
    task: task

module.exports.updateFirstStepTask = (next) ->
  taskId = this.params.taskId
  taskName = this.request.body.taskName
  displayNumber = this.request.body.displayNumber
  weight = this.request.body.weight
  theTask = this.request.body.theTask
  htmlCode = this.request.body.htmlCode
  cssCode = this.request.body.cssCode

  yield db.updateFirstStepTask(taskId, taskName, displayNumber, weight, htmlCode, cssCode, theTask)

  this.body = 
    status: 'ok'

module.exports.updateQuizStepTask = (next) ->
  taskId = this.params.taskId
  taskName = this.request.body.taskName
  displayNumber = this.request.body.displayNumber
  weight = this.request.body.weight
  deprecatedSelectors = this.request.body.deprecatedSelectors
  htmlCode = this.request.body.htmlCode
  answares = this.request.body.answares

  yield db.updateQuizStepTask(taskId, taskName, displayNumber, weight, answares, deprecatedSelectors, htmlCode)

  this.body = 
    status: 'ok'

module.exports.removeTask = (next) ->
  taskId = this.request.body.taskId

  yield db.removeTask taskId

  this.body =
    status: 'ok'

module.exports.activateTask = (next) ->
  taskId = this.request.body.taskId
  active = if this.request.body.active is 'true' then true else false

  try
    yield db.activateTask taskId, active
    this.body =
      status: 'ok'
      message: 'Active state has been changed'
  catch error
    this.response.status = 500
    this.body = 
      status: 'error'
      message: 'Error occured'

