db = require '../database'
User = require '../models/user'
Role = require '../models/role'

module.exports.add = (next) ->
  username = this.request.body.username
  password = this.request.body.password
  firstName = this.request.body.firstName
  lastName = this.request.body.lastName
  roleId = this.request.body.role
  active = true

  resp = yield db.getUser username
  userRows = resp[0]
  if userRows.length
    this.throw 'Username is already used'
  saveResp = yield db.saveUser(username, firstName, lastName, roleId, User.getEncryptedPassword password)
  roleResp = yield db.getRole roleId
  roleRows = roleResp[0]
  role = new Role roleRows[0].id, roleRows[0].name

  user = new User saveResp[0].insertId, username, firstName, lastName, active, role

  this.body =
    status: 'ok'
    user: user

module.exports.edit = (next) ->
  userId = this.request.body.userId
  username = this.request.body.username
  firstName = this.request.body.firstName
  lastName = this.request.body.lastName
  password = this.request.body.password
  roleId = this.request.body.role
  active = this.request.body.active is 'true'

  hashedPassword = undefined

  if password
    hashedPassword = User.getEncryptedPassword password

  yield db.updateUser userId, username, hashedPassword, firstName, lastName, roleId
  roleResp = yield db.getRole roleId
  roleRows = roleResp[0]
  role = new Role roleRows[0].id, roleRows[0].name

  this.body =
    status: 'ok'
    user: new User userId, username, firstName, lastName, active, role

module.exports.activate = (next) ->
  active = this.request.body.active is 'true'
  userId = this.request.body.userId
  try
    yield db.updateActiveState userId, active
    this.body =
      status: 'ok'
      message: 'Active state has been changed'
  catch error
    this.response.status = 500
    this.body =
      status: 'error'
      message: 'Error occured while changing active state'
