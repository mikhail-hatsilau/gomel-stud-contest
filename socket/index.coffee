db = require '../database'
QuizStepTask = require '../models/quizStepTask'

getTasks = (rows) ->
  tasks = for row in rows
    task = new QuizStepTask(
      row.id,
      row.name,
      row.displayNumber,
      row.weight,
      row.answares,
      row.deprecatedSelectors,
      row.htmlCode,
      row.active
    )

  tasks.sort (a, b) ->
    a.displayNumber - b.displayNumber

  tasks

module.exports = (io) ->
  io.on 'connection', (socket) ->
    if socket.request.user.role.name is 'admin'
      socket.join 'admin room'
    else
      socket.join 'students room'

    socket.on 'init quiz', (data, callback) ->
      QUIZ_STEP_ID = 2
      db.getActiveTasksPromise QUIZ_STEP_ID
        .then (resp) ->
          tasks = getTasks resp[0]
          io.to('admin room').emit 'init board'
          io.to('students room').emit 'init'
          callback tasks

    socket.on 'ready', ->
      socket.join 'ready room'

      db.getQuizStepResultsOfUser socket.request.user.id
        .then (resp) ->
          rows = resp[0]
          io.to('admin room').emit 'add user', {
            user: socket.request.user,
            results: rows
          }

    socket.on 'next task', (data, callback) ->
      io.to 'ready room'
        .emit 'next', {
          time: data.timeLimit,
          taskId: data.task.id
        }

      io.to 'admin room'
        .emit 'next task board', {
          task: data.task,
          timeLimit: data.timeLimit
        }

      callback()

    socket.on 'pass test', (data) ->
      io.to('admin room').emit 'test passed', {
        results: data,
        user: socket.request.user
      }
      db.getQuizResults socket.request.user.id, data.taskId
        .then (resp) ->
          rows = resp[0]
          if rows.length
            if data.time < rows[0].time
              db.updateQuizResults data, socket.request.user.id
          else
            db.saveQuizResults data, socket.request.user.id

    socket.on 'stop task', (data, callback) ->
      io.to('students room').emit 'stop'
      callback()

    socket.on 'start step1', (data, callback)->
      io.to('students room').emit 'start first step'
      db.clearFirstStep()
      callback()
