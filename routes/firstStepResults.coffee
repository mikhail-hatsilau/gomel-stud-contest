db = require '../database'
utils = require '../utils'
_ = require 'lodash'
User = require '../models/user'
FirstStepTask = require '../models/firstStepTask'

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
  rows = resp[0]

  yield this.render 'resultsMarkup', {
    editorPage: true,
    taskInfo: rows[0]
  }
