utils = require '../utils'

module.exports.post = (next) ->
  yield next

  requestBody = this.request.body
  html = requestBody.htmlContent || ''
  css = requestBody.cssContent || ''
  script = requestBody.scriptContent || ''

  path = utils.saveFile html, css, script, this.req.user.id, this.req.user.username, requestBody.taskId

  this.body =
    status: 'ok'
    filePath: path

module.exports.postAdmin = (next) ->
  yield next

  requestBody = this.request.body
  html = requestBody.htmlContent || ''
  css = requestBody.cssContent || ''
  script = requestBody.scriptContent || ''

  path = utils.saveFileAdmin html, css, script, this.req.user.id, this.req.user.username

  this.body =
    status: 'ok'
    filePath: path
