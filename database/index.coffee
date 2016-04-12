mysql = require 'mysql-co'
config = require 'config'
co = require 'co'

USERS_TABLE = 'Users'
QUIZ_TABLE = "Quiz"
ROLES_TABLE = "Roles"
MARKS_TABLE = "Marks"
TASKS_TABLE = "Tasks"
FIRST_STEP_TABLE = "FirstStep"

FIRST_STEP_ID = 1
QUIZ_STEP_ID = 2

options = config.get('dbConfig')
connection = null

module.exports.createConnection = ->
  connection = mysql.createConnection options

module.exports.getUser = (username) ->
  QUERY = "SELECT * FROM #{USERS_TABLE} WHERE username = ?;"
  connection.query QUERY, [username]

module.exports.getUserPromise = (username) ->
  QUERY = "SELECT #{USERS_TABLE}.id, username, password, firstName, lastName, active, #{ROLES_TABLE}.id AS roleId, #{ROLES_TABLE}.name AS roleName " +
  "FROM #{USERS_TABLE} INNER JOIN #{ROLES_TABLE} ON role = #{ROLES_TABLE}.id AND #{USERS_TABLE}.username = ?;"
  co ->
    yield connection.query QUERY, [username]

module.exports.getUserById = (id) ->
  QUERY = "SELECT #{USERS_TABLE}.id, username, firstName, lastName, active, #{ROLES_TABLE}.id AS roleId, #{ROLES_TABLE}.name AS roleName " +
  "FROM #{USERS_TABLE} INNER JOIN #{ROLES_TABLE} ON role = #{ROLES_TABLE}.id AND #{USERS_TABLE}.id = ?;"
  connection.query QUERY, [id]

module.exports.getUserByIdPromise = (id) ->
  QUERY = "SELECT #{USERS_TABLE}.id, username, firstName, lastName, active, #{ROLES_TABLE}.id AS roleId, #{ROLES_TABLE}.name AS roleName " +
  "FROM #{USERS_TABLE} INNER JOIN #{ROLES_TABLE} ON role = #{ROLES_TABLE}.id AND #{USERS_TABLE}.id = ?;"
  co ->
    yield connection.query QUERY, [id]

module.exports.getRole = (id) ->
  QUERY = "SELECT * FROM #{ROLES_TABLE} WHERE id=?;"
  connection.query QUERY, [id]

module.exports.getRoles = ->
  QUERY = "SELECT * FROM #{ROLES_TABLE};"
  connection.query QUERY

module.exports.getAllUsers = ->
  QUERY = "SELECT * FROM #{USERS_TABLE};"
  connection.query QUERY

module.exports.getAllStudents = ->
  QUERY = "SELECT * FROM #{USERS_TABLE} WHERE role = " +
  "(SELECT id FROM #{ROLES_TABLE} WHERE name = 'student');"
  connection.query QUERY

module.exports.getParticipants = ->
  QUERY = "SELECT * FROM #{USERS_TABLE} WHERE role = (SELECT id FROM #{ROLES_TABLE} WHERE name = 'student');"
  connection.query QUERY

module.exports.getQuizResults = (userId, taskId) ->
  co ->
    QUERY = "SELECT * FROM #{QUIZ_TABLE} WHERE stud_id = ? AND task = ?;"
    yield connection.query QUERY, [userId, taskId]

module.exports.saveQuizResults = (result, id) ->
  co ->
    QUERY = "INSERT INTO #{QUIZ_TABLE} (stud_id, task, time, selector) VALUE (?,?,?,?);"
    yield connection.query QUERY, [id, result.taskId, result.time, result.selector]

module.exports.updateQuizResults = (result, userId) ->
  co ->
    QUERY = "UPDATE #{QUIZ_TABLE} set time = ?, selector = ? WHERE stud_id = ? AND task = ?;"
    yield connection.query QUERY, [result.time, result.selector, userId, result.taskId]

module.exports.getRoles = ->
  QUERY = "SELECT * FROM #{ROLES_TABLE};"
  connection.query QUERY

module.exports.saveUser = (username, firstName, lastName, roleId, password) ->
  QUERY = "INSERT INTO #{USERS_TABLE} (username, password, firstName, lastName, role) VALUE (?,?,?,?,?)"
  connection.query QUERY, [username, password, firstName, lastName, roleId]

module.exports.removeUser = (id) ->
  QUERY = "DELETE FROM #{USERS_TABLE} WHERE id=?"
  connection.query QUERY, [id]

module.exports.quizResults = ->
  QUERY = "SELECT #{QUIZ_TABLE}.stud_id, #{QUIZ_TABLE}.task, " +
  "#{QUIZ_TABLE}.time, #{QUIZ_TABLE}.selector " +
  "FROM #{QUIZ_TABLE};"
  connection.query QUERY

module.exports.quizResultsOfStudent = (taskId, userId) ->
  QUERY = "SELECT * FROM #{QUIZ_TABLE} WHERE stud_id = ? AND task = ?;"
  connection.query QUERY, [userId, taskId]

module.exports.firstStepResults = ->
  QUERY = "SELECT * FROM #{FIRST_STEP_TABLE};"
  connection.query QUERY

module.exports.commonResults = (userId) ->
  # QUERY = "SELECT #{USERS_TABLE}.id as userId, #{USERS_TABLE}.firstName, #{USERS_TABLE}.lastName, " +
  # "#{MARKS_TABLE}.task, #{MARKS_TABLE}.mark " +
  # "FROM #{USERS_TABLE} LEFT JOIN #{MARKS_TABLE} ON #{USERS_TABLE}.id=#{MARKS_TABLE}.user_id AND #{MARKS_TABLE}.step = ? " +
  # "WHERE #{USERS_TABLE}.role = (SELECT id FROM #{ROLES_TABLE} WHERE name = 'student');"
  QUERY = "SELECT * FROM #{MARKS_TABLE} WHERE user_id = ?"
  connection.query QUERY, [userId]

module.exports.getUserResults = (userId, taskId) ->
  QUERY = "SELECT * FROM #{MARKS_TABLE} WHERE user_id = ? AND task_id = ?;"
  connection.query QUERY, [userId, taskId]

module.exports.changeResultOfCurrentUser = (userId, taskId, value) ->
  QUERY = "UPDATE #{MARKS_TABLE} SET mark = ? WHERE user_id = ? AND task_id = ?;"
  connection.query QUERY, [value, userId, taskId]

module.exports.createResultForUser = (userId, taskId, value) ->
  QUERY = "INSERT INTO #{MARKS_TABLE} (user_id, task_id, mark) VALUE (?,?,?);"
  connection.query QUERY, [userId, taskId, value]

module.exports.clearQuizResults = ->
  QUERY = "DELETE FROM #{QUIZ_TABLE};"
  yield connection.query QUERY

module.exports.saveFirstStepResults = (userId, taskId, time, htmlCode, cssCode, path) ->
  QUERY = "INSERT INTO #{FIRST_STEP_TABLE} (user_id, task, time, htmlCode, cssCode, path) VALUE (?,?,?,?,?,?);"
  connection.query QUERY, [userId, taskId, time, htmlCode, cssCode, path]

module.exports.getFirstStepTaskResults = (userId, taskNumber) ->
  QUERY = "SELECT * FROM #{FIRST_STEP_TABLE} " +
  "WHERE user_id = ? AND task = ?;"
  connection.query QUERY, [userId, taskNumber]

module.exports.updateActiveState = (userId, active) ->
  QUERY = "UPDATE #{USERS_TABLE} SET active = ? WHERE id = ?;"
  connection.query QUERY, [active, userId]

module.exports.updateUser = (userId, username, firstName, lastName, roleId) ->
  QUERY = "UPDATE #{USERS_TABLE} SET username = ?, firstName = ?, lastName = ?, role = ? WHERE id = ?;"
  connection.query QUERY, [username, firstName, lastName, roleId, userId]

module.exports.getTasks = (stepId) ->
  QUERY = "SELECT * FROM #{TASKS_TABLE} WHERE step_id = ?;"
  connection.query QUERY, [stepId]

module.exports.getActiveTasks = (stepId) ->
  QUERY = "SELECT * FROM #{TASKS_TABLE} WHERE step_id = ? AND active = true;"
  connection.query QUERY, [stepId]

module.exports.getActiveTasksPromise = (stepId) ->
  QUERY = "SELECT * FROM #{TASKS_TABLE} WHERE step_id = ? AND active = true;"
  co ->
    yield connection.query QUERY, [stepId]

module.exports.getAllTasks = ->
  QUERY = "SELECT * FROM #{TASKS_TABLE};"
  connection.query QUERY

module.exports.addFirstStepTask = (taskName, displayNumber, weight, htmlCode, cssCode, toDo) ->
  QUERY = "INSERT INTO #{TASKS_TABLE} (name, displayNumber, weight, step_id, htmlCode, cssCode, toDo) " +
  "VALUE(?,?,?,#{FIRST_STEP_ID},?,?,?);"
  connection.query QUERY, [taskName, displayNumber, weight, htmlCode, cssCode, toDo]

module.exports.addQuizStepTask = (taskName, displayNumber, weight, answares, deprecatedSelectors, htmlCode) ->
  QUERY = "INSERT INTO #{TASKS_TABLE} (name, displayNumber, weight, step_id, htmlCode, answares, deprecatedSelectors) " +
  "VALUE(?,?,?,#{QUIZ_STEP_ID},?,?,?);"
  connection.query QUERY, [taskName, displayNumber, weight, htmlCode, answares, deprecatedSelectors]

module.exports.getQuizStepResultsOfUser = (userId) ->
  QUERY = "SELECT * FROM #{QUIZ_TABLE} WHERE stud_id = ?;"
  co ->
    yield connection.query QUERY, [userId]

module.exports.getTask = (taskId) ->
  QUERY = "SELECT * FROM #{TASKS_TABLE} WHERE id = ?;"
  connection.query QUERY, [taskId]

module.exports.getTaskByDisplayNumber = (displayNumber, stepId) ->
  QUERY = "SELECT * FROM #{TASKS_TABLE} WHERE displayNumber = ? AND step_id = ?;"
  connection.query QUERY, [displayNumber, stepId]

module.exports.getActiveTaskByDisplayNumber = (displayNumber, stepId) ->
  QUERY = "SELECT * FROM #{TASKS_TABLE} WHERE displayNumber >= ? AND step_id = ? AND active = true;"
  connection.query QUERY, [displayNumber, stepId]

module.exports.getTaskById = (taskId) ->
  QUERY = "SELECT * FROM #{TASKS_TABLE} WHERE id = ?;"
  connection.query QUERY, [taskId]
#
# module.exports.getTaskByIdPromise = (taskId) ->
#   QUERY = "SELECT * FROM #{TASKS_TABLE} WHERE id = ?;"
#   co ->
#     connection.query QUERY, [taskId]

module.exports.updateFirstStepTask = (taskId, name, displayNumber, weight, htmlCode, cssCode, toDo) ->
  QUERY = "UPDATE #{TASKS_TABLE} SET name = ?, displayNumber = ?, weight = ?, htmlCode = ?, cssCode = ?, toDo = ? " +
  "WHERE id = ?;"
  connection.query QUERY, [name, displayNumber, weight, htmlCode, cssCode, toDo, taskId]

module.exports.updateQuizStepTask = (taskId, name, displayNumber, weight, answares, deprecatedSelectors, htmlCode) ->
  QUERY = "UPDATE #{TASKS_TABLE} SET name = ?, displayNumber = ?, weight = ?, answares = ?, deprecatedSelectors = ?, htmlCode = ? " +
  "WHERE id = ?;"
  connection.query QUERY, [name, displayNumber, weight, answares, deprecatedSelectors, htmlCode, taskId]

module.exports.removeTask = (taskId) ->
  QUERY = "DELETE FROM #{TASKS_TABLE} WHERE id = ?;"
  connection.query QUERY, [taskId]

module.exports.activateTask = (taskId, active) ->
  QUERY = "UPDATE #{TASKS_TABLE} SET active = ? WHERE id = ?;"
  connection.query QUERY, [active, taskId]

module.exports.clearFirstStep = ->
  QUERY = "DELETE FROM #{FIRST_STEP_TABLE};"
  co ->
    yield connection.query QUERY
# module.exports.getSettings = ->
#   QUERY = "SELECT * FROM #{SETTINGS_TABLE};"
#   connection.query QUERY

# module.exports.getSettingsByName = (name) ->
#   QUERY = "SELECT * FROM #{SETTINGS_TABLE} WHERE name = ?;"
#   connection.query QUERY, [name]

# module.exports.getSettingsByNameWithPromise = (name) ->
#   QUERY = "SELECT * FROM #{SETTINGS_TABLE} WHERE name = ?;"
#   co ->
#     yield connection.query QUERY, [name]

# module.exports.updateSettings = (name, value, active) ->
#   QUERY = "UPDATE #{SETTINGS_TABLE} SET value = ?, active = ? WHERE name = ?;"
#   connection.query QUERY, [value, active, name]

module.exports.closeConnection = ->
  connection.end()
