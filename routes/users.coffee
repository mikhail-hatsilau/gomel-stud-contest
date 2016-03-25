db = require '../database'
Role = require '../models/role'
User = require '../models/user'
_ = require 'lodash'

module.exports.getAll = (next) ->
  usersResp = yield db.getAllUsers()
  usersRows = usersResp[0]
  rolesResp = yield db.getRoles()
  rolesRows = rolesResp[0]

  roles = []
  users = []

  for row in rolesRows
    roles.push(new Role(row.id, row.name))

  for row in usersRows
    role = _.find roles, { id: row.role }
    user = new User row.id, row.username, row.firstName, row.lastName, row.active, role
    users.push user

  yield this.render 'users', { users: users }

module.exports.getUser = (next) ->
  userId = this.params.userId

  resp = yield db.getUserById userId
  userRow = resp[0]

  user =
    id: userRow[0].id
    username: userRow[0].username
    firstName: userRow[0].firstName
    lastName: userRow[0].lastName
    active: !!userRow[0].active
    role:
      id: userRow[0].roleId
      name: userRow[0].roleName

  this.body = 
    user: user
