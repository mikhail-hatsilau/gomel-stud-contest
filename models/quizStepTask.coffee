Task = require './task'

class QuizStepTask extends Task
  constructor: (id, name, displayNumber, weight, @answares, @deprecatedSelectors, @htmlCode) ->
    super id, name, displayNumber, weight


module.exports = QuizStepTask

