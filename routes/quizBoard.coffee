db = require '../database'
utils = require '../utils'
QuizStepTask = require '../models/quizStepTask'
User = require '../models/user'
Role = require '../models/role'

module.exports = (next) ->
  QUIZ_STEP_ID = 2
  resp = yield db.getTasks QUIZ_STEP_ID
  rows = resp[0]
  allTasks = []
  users = []

  for row in rows
    task = new QuizStepTask(
      row.id,
      row.name,
      row.displayNumber,
      row.weight,
      row.answares,
      row.deprecatedSelectors,
      row.htmlCode,
      row.active,
    )
    allTasks.push task

  allTasks.sort (a, b) ->
    a.displayNumber - b.displayNumber

  resp  = yield db.getAllStudents()
  rows = resp[0]

  roleResp = yield db.getRole rows[0].role
  roleRows = roleResp[0]
  role = new Role roleRows[0].id, roleRows[0].name

  for row in rows
    user = new User(
      row.id,
      row.username,
      row.firstName,
      row.lastName,
      row.active,
      role
    )
    users.push user

  yield this.render 'quizBoard', { 
    allTasks: allTasks,
    users: users
  }
