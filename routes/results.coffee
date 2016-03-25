db = require '../database'
User = require '../models/user'
Role = require '../models/role'
FirstStepTask = require '../models/firstStepTask'
QuizStepTask = require '../models/quizStepTask'

module.exports = (next) ->
  yield this.render 'results'

module.exports.total = (next) ->
  FIRST_STEP_ID = 1
  QUIZ_STEP_ID = 2

  resp = yield db.getAllUsers()
  rows = resp[0]

  users = []

  for row in rows
    role = new Role row.roleId, row.roleName
    user = new User(
      row.id,
      row.username,
      row.firstName,
      row.lastName,
      row.active,
      role
    )

    user.tasksMarks = {}
    resp = yield db.commonResults user.id
    marksRows = resp[0]

    for markRow in marksRows
      user.tasksMarks[markRow.task_id] = markRow.mark

    users.push user

  tasks = {}
  tasks.step1 = []
  tasks.step2 = []

  resp = yield db.getTasks FIRST_STEP_ID
  rows = resp[0]

  for row in rows
    task = new FirstStepTask(
      row.id,
      row.name,
      row.displayNumber,
      row.weight, 
      row.htmlCode,
      row.cssCode,
      row.toDo, 
      row.active
    )
    tasks.step1.push task

  resp = yield db.getTasks QUIZ_STEP_ID
  rows = resp[0]

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
    tasks.step2.push task

  console.log tasks.step1[0]
  yield this.render 'total', {
    users: users,
    tasks: tasks 
  }

module.exports.save = (next) ->
  userId = this.request.body.userId
  taskId = this.request.body.taskId
  value = this.request.body.value

  resp = yield db.getUserResults userId, taskId

  if resp[0].length is 0
    yield db.createResultForUser userId, taskId, value
  else
    yield db.changeResultOfCurrentUser userId, taskId, value

  this.body =
    status: 'ok'
