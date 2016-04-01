db = require '../database'
utils = require '../utils'
QuizStepTask = require '../models/quizStepTask'
User = require '../models/user'
Role = require '../models/role'

module.exports = (next) ->
  QUIZ_STEP_ID = 2
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
      row.active,
    )

  allTasks.sort (a, b) ->
    a.displayNumber - b.displayNumber

  resp  = yield db.getAllStudents()
  rows = resp[0]

  roleResp = yield db.getRole rows[0].role
  roleRows = roleResp[0]
  role = new Role roleRows[0].id, roleRows[0].name

  users = for row in rows
    user = new User(
      row.id,
      row.username,
      row.firstName,
      row.lastName,
      row.active,
      role
    )

  yield this.render 'quizBoard', { 
    allTasks: allTasks,
    users: users
  }
