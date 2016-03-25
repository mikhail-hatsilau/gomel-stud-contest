utils = require '../utils'

class User
  constructor: (@id, @username, @firstName, @lastName, @active, @role) ->

  @checkPassword: (passwordFromDb, password) ->
    encryptedPassword = utils.encryptPass password
    encryptedPassword is passwordFromDb

  @getEncryptedPassword: (password) ->
    utils.encryptPass password

module.exports = User
