mime = require 'mime'
utils = require '../utils'
db = require '../database'


module.exports = (next) ->
  yield next
  userId = this.params.userId
  taskId = this.params.taskId

  resp = yield db.getUserById userId
  rows = resp[0]

  filePath = utils.getFilePath userId, rows[0].username, taskId
  fileName = utils.getFileName filePath

  mimeType = mime.lookup filePath

  fileStream = utils.getFileStream filePath

  this.set "Content-disposition", "attachment; filename=#{fileName}"
  this.set "Content-type", mimeType
  this.body = fileStream
