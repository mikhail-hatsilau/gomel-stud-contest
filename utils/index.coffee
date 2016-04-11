fs = require 'fs'
mkdirp = require 'mkdirp'
sha1 = require 'sha1'
path = require 'path'

DIST_DIR = "dist/"
RESULTS_DIR = "dist/results/"
ADMIN_EDITOR_DIR = "dist/adminResults"

getFileStructure = (html, css, script) ->
  fileStructure = "
    <!DOCTYPE html>
    <html>
      <head>
        <style type='text/css'>
          #{css}
        </style>
      </head>
      <body>
        #{html}
        <script>
          #{script}
        </script>
      </body>
    </html>"
  fileStructure

module.exports.saveFile = (html, css, script, uid, username, taskNumber) ->
  DIR = RESULTS_DIR + uid + '_' + username

  mkdirp.sync DIR
  fs.writeFileSync "#{DIR}/task_#{taskNumber}.html", getFileStructure(html, css, script)

  "/results/#{uid}_#{username}/task_#{taskNumber}.html"

module.exports.saveFileAdmin = (html, css, script, uid, username) ->
  mkdirp.sync ADMIN_EDITOR_DIR
  fs.writeFileSync "#{ADMIN_EDITOR_DIR}/#{uid}_#{username}.html", getFileStructure(html, css, script)

  "/adminResults/#{uid}_#{username}.html"

module.exports.readTaskFile = (taskNumber) ->
  PATH = "src/tasks/task_#{taskNumber}.task"

  if not fs.existsSync PATH
    return null

  fs.readFileSync PATH, 'utf8'

module.exports.getFilePath = (userId, username, taskId) ->
  dirOfUser = "#{userId}_#{username}"
  taskFileName = "task_#{taskId}.html"
  dir = path.join "/results/" , dirOfUser
  path.join dir, taskFileName

module.exports.getFileName = (pathToFile) ->
  path.basename pathToFile

module.exports.getFileStream = (file) ->
  fs.createReadStream path.join(DIST_DIR, file)

module.exports.encryptPass = (password) ->
  sha1 password
