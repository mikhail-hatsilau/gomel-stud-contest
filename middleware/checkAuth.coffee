module.exports = (next) ->
  # if not this.session.user
  #   this.throw 'Forbidden', 403
  # yield next
  if this.isAuthenticated()
    yield next
  else
    this.redirect '/'
