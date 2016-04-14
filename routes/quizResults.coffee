db = require '../database'
_ = require 'lodash'
utils = require '../utils'
User = require '../models/user'
Role = require '../models/role'
QuizStepTask = require '../models/quizStepTask'

module.exports = (next) ->
  QUIZ_STEP_ID = 2
  resp = yield db.quizResults()
  rows = resp[0]

  users = []

  for row in rows
    index = _.findIndex(users, { id: row.stud_id })
    if index is -1
      resp = yield db.getUserById row.stud_id
      usersRows = resp[0]
      role = new Role usersRows[0].roleId, usersRows[0].roleName
      user = new User usersRows[0].id, usersRows[0].username, usersRows[0].firstName, usersRows[0].lastName, usersRows[0].active, role
      user.tasks = {}
      users.push user
    else
      user = users[index]

    resp = yield db.getTask row.task
    tasksRows = resp[0]
    task = new QuizStepTask(
      tasksRows[0].id,
      tasksRows[0].name,
      tasksRows[0].displayNumber,
      tasksRows[0].weight,
      tasksRows[0].answares,
      tasksRows[0].deprecatedSelectors,
      tasksRows[0].htmlCode,
      tasksRows[0].active
    )

    taskInfo = {}
    taskInfo.task = task
    taskInfo.time = row.time
    taskInfo.selector = row.selector

    user.tasks[task.id] = taskInfo

  resp = yield db.getActiveTasks QUIZ_STEP_ID
  rows = resp[0]

  allTasks = for row in rows
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

  allTasks.sort (a, b) ->
    a.displayNumber - b.displayNumber

  yield this.render 'quizResults', {
    users: users,
    allTasks: allTasks
  }
