db = require '../database'
User = require '../models/user'
Role = require '../models/role'
passport = require 'koa-passport'

module.exports.get = (next) ->
  yield this.render('login')

sendLoginError = (status, message) ->
  this.status = status
  this.body = {
    error: message
  }

module.exports.post = (next) ->
  # username = this.request.body.username
  # password = this.request.body.password

  # resp = yield db.getUser(username)
  # rows = resp[0]

  # if rows.length
  #   if User.checkPassword rows[0].password, password
  #     if rows[0].active
  #       resp = yield db.getRole(rows[0].role)
  #       roleRows = resp[0]
  #       role = new Role roleRows[0].id, roleRows[0].name
  #       user = new User rows[0].id, rows[0].username, rows[0].firstName, rows[0].lastName, rows[0].active, role
  #       this.session.user = user
  #       this.body = {}
  #     else
  #       sendLoginError.apply this, [403, 'The account is not active!']
  #   else
  #     sendLoginError.apply this, [403, 'Wrong password!']
  # else
  ctx = this
  yield passport.authenticate('local', (error, user, info) ->
    if error then ctx.throw error
    if not user
      ctx.status = 401
      ctx.body =
        status: 'error'
        message: info.message
    else
      yield ctx.login user
      ctx.body = 
        status: 'ok'
  ).call(this, next)

