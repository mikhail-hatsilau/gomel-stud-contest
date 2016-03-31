Task = require './task'

class QuizStepTask extends Task
  constructor: (id, name, displayNumber, weight, @answares, @deprecatedSelectors, @htmlCode, active = true) ->
    super id, name, displayNumber, weight, active

module.exports = QuizStepTask

