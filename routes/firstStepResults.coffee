db = require '../database'
utils = require '../utils'
_ = require 'lodash'
User = require '../models/user'
FirstStepTask = require '../models/firstStepTask'
Role = require '../models/role'

module.exports.results = (next) ->
  FIRST_STEP_ID = 1
  resp = yield db.firstStepResults()
  rows = resp[0]
  users = []

  for row in rows
    index = _.findIndex users, { id: row.user_id }

    if index is -1
      resp = yield db.getUserById row.user_id
      usersRows = resp[0]

      role =
        id: usersRows[0].roleId
        name: usersRows[0].roleName

      user = new User(
        usersRows[0].id,
        usersRows[0].username,
        usersRows[0].firstName,
        usersRows[0].lastName,
        usersRows[0].active,
        role
      )
      user.tasks = {}
      users.push user
    else
      user = users[index]

    resp = yield db.getTask row.task
    taskRows = resp[0]

    taskInfo = {}
    task = new FirstStepTask(
      taskRows[0].id,
      taskRows[0].name,
      taskRows[0].displayNumber,
      taskRows[0].weight,
      taskRows[0].htmlCode,
      taskRows[0].cssCode,
      taskRows[0].toDo,
      taskRows[0].active
    )

    taskInfo.task = task
    taskInfo.time = row.time

    user.tasks[task.id] = taskInfo

  resp = yield db.getActiveTasks FIRST_STEP_ID
  rows = resp[0]

  rows.sort (a, b) ->
    a.displayNumber - b.displayNumber

  allTasks = rows.map (element) ->
    {
      id: element.id
      name: element.name
    }

  yield this.render 'firstStepResults', {
    users: users,
    allTasks: allTasks
  }

module.exports.showMarkup = (next) ->
  userId = this.params.userId
  taskNumber = this.params.taskNumber

  resp = yield db.getFirstStepTaskResults userId, taskNumber
  result = resp[0][0]

  resp = yield db.getUserById userId
  userRow = resp[0][0]

  resp = yield db.getTask result.task
  taskRow = resp[0][0]
  task = new FirstStepTask(
    taskRow.id,
    taskRow.name,
    taskRow.displayNumber,
    taskRow.weight,
    taskRow.htmlCode,
    taskRow.cssCode,
    taskRow.toDo,
    taskRow.active
  )

  role = new Role userRow.rolId, userRow.roleName
  user = new User(
    userRow.id,
    userRow.username,
    userRow.firstName,
    userRow.lastName,
    userRow.active,
    role
  )

  console.log user

  yield this.render 'resultsMarkup', {
    task: task,
    userInfo: user,
    result: result,
    contentClass: 'editor-page'
  }
