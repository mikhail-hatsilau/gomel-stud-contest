db = require '../database'
User = require '../models/user'
Role = require '../models/role'
FirstStepTask = require '../models/firstStepTask'
QuizStepTask = require '../models/quizStepTask'
Step = require '../models/step'
Task = require '../models/task'

module.exports.marks = (next) ->
  resp = yield db.getAllStudents()
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

  resp = yield db.getAllSteps()
  steps = for row in resp[0]
    step = new Step row.id, row.name

  for step in steps
    resp = yield db.getActiveTasks step.id
    tasks = for row in resp[0]
      if row.answares is null and step.name isnt 'HomeStep'
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
      else if row.answares isnt null
        task = new QuizStepTask(
          row.id,
          row.name,
          row.displayNumber,
          row.weight,
          row.answares,
          row.deprecatedSelectors,
          row.htmlCode,
          row.active
        )
      else
        task = new Task(
          row.id,
          row.name,
          row.displayNumber,
          row.weight,
          row.active
        )
    tasks.sort (a, b) ->
      a.displayNumber - b.displayNumber
    step.tasks = tasks

  yield this.render 'total', {
    users: users,
    steps: steps
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
