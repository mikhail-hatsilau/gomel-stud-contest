Task = require './task'

class FirstStepTask extends Task
  constructor: (id, name, displayNumber, weight, @htmlCode, @cssCode, @toDo, @active) ->
    super id, name, displayNumber, weight

module.exports = FirstStepTask
