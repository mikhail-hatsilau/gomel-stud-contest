Task = require './task'

class FirstStepTask extends Task
  constructor: (id, name, displayNumber, weight, @htmlCode, @cssCode, @toDo, active = true) ->
    super id, name, displayNumber, weight, active

module.exports = FirstStepTask
