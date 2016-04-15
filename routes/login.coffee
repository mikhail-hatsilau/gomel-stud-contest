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

