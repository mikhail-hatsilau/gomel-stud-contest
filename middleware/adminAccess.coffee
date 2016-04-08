module.exports = (next) ->
  if this.req.user.role.name isnt 'admin'
    this.throw 'Access denied', 401
  yield next
