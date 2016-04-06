module.exports = (next) ->
  yield next
  this.logout()
  this.redirect '/'
