$ = require 'jquery'
_ = require 'lodash'
require 'jquery-ui'
statusPopup = require('./statusPopup')()

# # Validates fields in the sign in form
# validate = ->
#   fields = [].slice.call arguments, 0
#   valid = true

#   # Sets error class to parent of an invalid element
#   # and shows appropriate message
#   showError = (element, error) ->
#     errorElement = $('<span>').text error
#     element.parent 'div'
#       .addClass 'error'
#       .append errorElement

#   for field in fields
#     if not field.val().trim()
#       showError(field, 'This field is required')
#       valid = false

#   valid

# # Removes all validation errors
# removeValidationErrors = (form) ->
#   errors = form.find('.error').removeClass('error').find 'span'

#   if errors
#     for error in errors
#       error.remove()

intervalId = undefined

$('.sign-in').on 'submit', (event) ->
  event.preventDefault()
  
  #removeValidationErrors $(this)
  serverErrorElement = $('.server-error').empty()

  # if not validate $('input[name=username]'), $('input[name=password]')
  #   return

  $.ajax {
    url: $(this).attr('action'),
    method: 'POST',
    data: $(this).serialize()
  }
    .done ->
      location.href = '/'
    .fail (xhr) ->
      serverErrorElement.text xhr.responseJSON.error

initRemoveConfirmDialog = ->
  dialog = $('#removeConfirmationDialog').dialog {
    autoOpen: false,
    modal: true,
    minWidth: 400,
    resizable: false
  }

removeConfirmationDialog = initRemoveConfirmDialog()


addUser = (form) ->
  # removeValidationErrors $(form)
  # valid = validate($('#username'), $('#password'), $('#firstName'), $('#lastName'))
  # if not valid
  #   return

  $.ajax {
    url: $(form).attr('action'),
    method: 'POST',
    data: $(form).serialize()
  }
    .done (resp) ->
      tableBody = $('.users-list').find 'tbody'
      item = $('<tr />')
      editBtn = $('<button class="edit-btn edit-user">')
      removeBtn = $('<button class="remove-btn remove-user">')
      activeCheckbox = $('<input type="checkbox" name="active" checked="checked" class="ativate-user">')

      editBtn.append '<i class="fa fa-pencil-square-o">'
      removeBtn.append '<i class="fa fa-trash">'

      activeCheckbox.on 'click', ->
        activateUser.call this

      removeBtn.on 'click', (event) ->
        item = $(event.currentTarget).parents('tr')
        showRemoveUserDialog item

      item.attr('data-id', resp.user.id)
      item.append $('<td class="username"/>').text resp.user.username
      item.append $('<td class="firstname"/>').text resp.user.firstName
      item.append $('<td class="lastname"/>').text resp.user.lastName
      item.append $('<td class="roles"/>').text resp.user.role.name
      item.append $('<td />').append activeCheckbox
      item.append $('<td />').append(editBtn).append removeBtn
      tableBody.append item

      initEditUserDialog()
    .fail ->
      console.log "Error occured while saving user"

loadRoles = (callback) ->
  dialog = $(this)
  console.log dialog
  $.get '/roles'
    .done (resp) ->
      select = dialog.find '.roles'
      select.empty()
      for role in resp.roles
        option = $('<option />').val(role.id).text(role.name)
        select.append option
      if typeof callback is 'function'
        callback()
    .fail ->
      console.log 'Error loading roles'

# Inits popup for adding new user
initAddUserDialog = ->
  dialog = $('#addUserPopup').dialog {
    autoOpen: false,
    modal: true,
    title: 'Add user',
    resizable: false,
    buttons: {
      "Add": ->
        addUser $(this).find('form')
        $(this).dialog 'close'
      ,
      Close: ->
        $(this).dialog 'close'
    }
    open: ->
      loadRoles.call this
    ,
    close: ->
      form[0].reset()
  }

  form = dialog.find 'form'
  form.on 'submit', (event) ->
    event.preventDefault()
    addUser this

  # Open add user popup
  $('.add-new-user').on 'click', (event) ->
    dialog.dialog 'open'

# Edits user information
editUser = (form) ->
  $.ajax {
    url: form.attr('action'),
    method: 'POST',
    data: form.serialize()
  }
    .done (resp) ->
      usersTableBody = $('.users-list').find 'tbody'
      userRow = usersTableBody.find "tr[data-id=#{resp.user.id}]"
      userRow.find('.username').text resp.user.username
      userRow.find('.firstname').text resp.user.firstName
      userRow.find('.lastname').text resp.user.lastName
      userRow.find('.roles').text resp.user.role.name
    .fail ->
      console.log "Error occured"

fillEditUserPopup = (dialog) ->
  rolesLoadedCallback = =>
    userId = $(this).parents('tr').data 'id'

    $.get "/users/#{userId}"
    .done (resp) ->
      setDataToInputs resp.user
    .fail ->
      console.log 'Error occured'

  setDataToInputs = (user) ->
    username = dialog.find '.edit-username'
    firstName = dialog.find '.edit-firstname'
    lastName = dialog.find '.edit-lastname'
    roles = dialog.find '.roles'
    userId = dialog.find '.user-id'
    active = dialog.find '.edit-active'

    username.val user.username
    firstName.val user.firstName
    lastName.val user.lastName
    roles.val user.role.id
    userId.val user.id
    active.val user.active

  loadRoles.call dialog, rolesLoadedCallback

initEditUserDialog = ->
  dialog = $('#editUserPopup').dialog {
    autoOpen: false,
    modal: true,
    title: 'Edit user',
    resizable: false,
    buttons: {
      "Save": ->
        editUser $(this).find('form')
        $(this).dialog 'close'
      ,
      Close: ->
        $(this).dialog 'close'
    },
    close: ->
      form[0].reset()
  }

  form = dialog.find 'form'
  form.on 'submit', (event) ->
    event.preventDefault()
    editUser this

  # Open add user popup
  $('.edit-user').on 'click', (event) ->
    fillEditUserPopup.call this, dialog
    dialog.dialog 'open'

# Removes user
removeUser = (item) ->
  $.ajax {
    url: '/removeUser',
    method: 'POST',
    data: {
      id: item.data('id')
    }
  }
    .done (resp) ->
      item.remove()
    .fail ->
      console.log "Error occured while deleting user"

showRemoveUserDialog = (item) ->
  removeConfirmationDialog.dialog 'option', 'title', 'Remove user'
  removeConfirmationDialog.dialog 'option', 'buttons', [
    {
      text: 'Remove user',
      click: ->
        removeUser item
        $(this).dialog 'close'
    },
    {
      text: 'Close',
      click: ->
        $(this).dialog 'close'
    }
  ]
  removeConfirmationDialog.dialog 'open'
  false

$('.remove-user').on 'click', (event) ->
  item = $(event.currentTarget).parents('tr')
  showRemoveUserDialog item

if $('#addUserPopup')
  initAddUserDialog()

if $('#editUserPopup')
  initEditUserDialog()

activateUser = ->
  $.ajax {
    url: '/activateUser',
    method: 'POST',
    data: {
      userId: $(this).parents('tr').data('id'),
      active: $(this).prop('checked')
    }
  }
    .done (resp) ->
      statusPopup.showSuccessPopup resp.message
    .fail ->
      console.log 'Error occured while activating user'
      statusPopup.showErrorPopup 'Error'

$('.ativate-user').on 'click', (event) ->
 activateUser.call this

# Parse seconds according to the format (mm:ss)
parseTime = (time) ->
  minutes = parseInt time / 60
  if minutes < 10 then minutes = '0' + minutes
  seconds = parseInt time - minutes * 60
  if seconds < 10 then seconds = '0' + seconds
  minutes + ':' + seconds

convertTimeToSeconds = (time) ->
  time = time || '00:00'
  parts = time.split ':'
  minutes = parseInt parts[0], 10
  seconds = parseInt parts[1], 10
  minutes * 60 + seconds

# Quiz board page
allTasks = undefined
currentTasks = undefined

setTimer = ->
  clearInterval intervalId
  adminTimerElement = $('.admin-timer').find('span')
  adminTimerElement.text '00:00'
  time = 0
  timeLimit = $('.quiz-task-time').find('input').val()
  intervalId = setInterval(->
    adminTimerElement.text parseTime(++time)
    if time >= timeLimit
      stopTask()
      
  , 1000)

stopTask = ->
  clearInterval intervalId
  # $('.admin-timer').find('span').text '00:00'
  $('.stop-quiz-task').prop 'disabled', true
  if not currentTasks.length
    $('.start-quiz-btn').prop 'disabled', true
    localStorage.removeItem 'currentQuizTask'
  else
    $('.start-quiz-btn').prop 'disabled', false
    localStorage.setItem 'currentQuizTask', currentTasks[0].id

emitNextTaskEvent = (data, callback) ->
  socketIo.emit 'next task', data, ->
    localStorage.setItem 'currentQuizTask', data.taskId
    callback()

fillQuizBoardTable = ->
  board = $('.participants-list')
  headRow = board.find('thead').find('tr').empty()

  headRow.append $('<th />').text('Participant')

  for task in allTasks
    headRow.append $('<th />').text(task.name)

  headRow.append $('<th />').text('Total time')

$('.init-quiz').on 'click', (event) ->
  users.length = 0
  $('.participants-list')
    .find 'tbody'
    .empty()
  socketIo.emit 'init quiz', null, (tasks) ->
    savedTaskId = localStorage.getItem('currentQuizTask')
    if savedTaskId isnt null
      taskIndex = _.findIndex tasks, { id: +savedTaskId }
      task = tasks[taskIndex]
      currentTasks = _.filter tasks, (element) ->
        element.displayNumber >= task.displayNumber
    else 
      currentTasks = tasks

    $('.current-task').find('span').text currentTasks[0].name
    allTasks = tasks

    fillQuizBoardTable()
    stopTask()

$('.start-quiz-btn').on 'click', ->
  that = this
  timeLimit = $('.quiz-task-time').find('input').val()
  task = currentTasks.shift()
  emitNextTaskEvent({
    timeLimit: timeLimit,
    taskId: task.id
  },  ->
    $('.current-task').find('span').text task.name
    # $('.next-quiz-task').prop 'disabled', false
    $('.stop-quiz-task').prop 'disabled', false
    $(that).prop 'disabled', true
    # if not allTasks.length
    #   $('.next-quiz-task').prop 'disabled', true
    setTimeout setTimer, 500
  )

$('.stop-quiz-task').on 'click', ->
  socketIo.emit 'stop task', null, ->
    # $('.start-quiz-btn').prop 'disabled', false
    stopTask()
    # $('.next-quiz-task').prop 'disabled', true

# $('.next-quiz-task').on 'click', ->
#   timeLimit = $('.quiz-task-time').find('input').val()
#   task = allTasks.shift()

#   emitNextTaskEvent({
#     timeLimit: timeLimit,
#     taskId: task.id
#   }, ->
#     $('.stop-quiz-task').prop 'disabled', false
#     setTimeout setTimer, 500
#   )

#   $('.current-task').find('span').text task.name

#   if not allTasks.length
#     $(this).prop 'disabled', true

$('.clear-quiz-results').on 'click', ->
  $.post '/clearQuiz'
    .done (resp) ->
      console.log resp.message
      statusPopup.showSuccessPopup resp.message
      localStorage.removeItem 'currentQuizTask'
    .fail ->
      console.log 'Error ocured'
      statusPopup.showErrorPopup 'Results were not cleared'

# saveResults function sends ajax for saving marks.
# Also it hides inputs, shows spans and calculates total
saveResults = (parent) ->
  editElement = $(parent).find 'input'
  if editElement.length is 0 then return
  participant = editElement.parents('tr')
  textElement = editElement.siblings 'span'
  value = +editElement.val()
  if not (value is +textElement.text())
    userId = participant.data 'id'
    taskId = editElement.parent('td').data 'taskid'
    $.ajax {
      url: '/saveResults',
      method: 'POST',
      data: {
        userId: userId
        taskId: taskId,
        value: value
      }
    }
      .fail ->
        console.log 'Error occured while saving results'
  textElement.text value
  totalTextElementStep1 = participant.find('.step1-sum').find 'span'
  totalTextElementStep2 = participant.find('.step2-sum').find 'span'
  totalMarkElement = participant.find('.total-mark').find 'span'
  elementsWithMarkStep1 = participant.find('.step1-task').find('span')
  elementsWithMarkStep2 = participant.find('.step2-task').find('span')
  console.log participant
  totalMarkStep1 = 0
  totalMarkStep2 = 0
  for element in elementsWithMarkStep1
    totalMarkStep1 += +$(element).text()
  for element in elementsWithMarkStep2
    totalMarkStep2 += +$(element).text()
  totalTextElementStep1.text totalMarkStep1
  totalTextElementStep2.text totalMarkStep2
  totalMarkElement.text totalMarkStep1 + totalMarkStep2
  editElement.remove()
  textElement.show()

# Common results. Save results when user clicks outside of the field with mark
$('.total-results'). on 'click', (event) ->
  saveResults this
  
editMarkCallback = (event) ->
  console.log $(event.target)
  if $(this)[0] is $(event.target)[0] or $(event.target)[0] is $(this).find('span')[0]
    saveResults $(event.currentTarget).parents '.total-results'
    textElement = $(event.currentTarget).find('span')
    textElement.hide()
    $(event.currentTarget).append $('<input type="text" />').val textElement.text()
  event.stopPropagation()

# Common results. Show input when user clicks on span with mark
$('.js-mark').on 'click', editMarkCallback

# Result sorting
$('.js-sort').on 'click', (event) ->
  ascendingOrder = (a, b) ->
    sortColumnA = $(a).find('td')[colNumber]
    sortColumnB = $(b).find('td')[colNumber]
    +$(sortColumnA).find('.sort-item').text() - (+$(sortColumnB).find('.sort-item').text())

  descendingOrder = (a, b) ->
    sortColumnA = $(a).find('td')[colNumber]
    sortColumnB = $(b).find('td')[colNumber]
    +$(sortColumnB).find('.sort-item').text() - (+$(sortColumnA).find('.sort-item').text())

  colNumber = +$(this).parent().data 'col'
  sorted = $(this).parent().data('sorted') || false 
  table = $(this).parents 'table'
  rows = table.find('tbody').find 'tr'
  rows.detach()
  if sorted
    rows.sort descendingOrder
    $(this).parent().data 'sorted', false
  else
    rows.sort ascendingOrder
    $(this).parent().data 'sorted', true

  table.find('tbody').append rows

removeTask = (item, url) ->
  $.post url, {
    taskId: item.data('id')
  } 
    .done ->
      item.remove()
    .fail ->
      console.log 'Error occured'

showRemoveTaskPopup = (item, url) ->
  removeConfirmationDialog.dialog 'option', 'title', 'Remove task'
  removeConfirmationDialog.dialog 'option', 'buttons', [
    {
      text: 'Remove task',
      click: ->
        removeTask(item, url)
        $(this).dialog 'close'
    },
    {
      text: 'Close',
      click: ->
        $(this).dialog 'close'
    }
  ]
  removeConfirmationDialog.dialog 'open'

$('.remove-task').on 'click', (event) ->
  item = $(event.currentTarget).parents('tr')
  showRemoveTaskPopup item, '/removeTask'

$('.active-task').on 'click', (event) ->
  targetCheckbox = $(event.currentTarget)
  taskId = targetCheckbox.parents('tr').data('id')
  $.post "/activateTask", {
    taskId: taskId,
    active: targetCheckbox.prop('checked')
  }
    .done (resp) ->
      statusPopup.showSuccessPopup resp.message
    .fail ->
      console.log 'Error occured'
      statusPopup.showErrorPopup 'Error'

# $('.save-settings').find('input[type="checkbox"]').on 'click', (event) ->
#   state = $(this).prop 'checked'
#   parentBlock = $(this).parents 'div'
#   if state
#     parentBlock.next().show()
#     parentBlock.next().find('input').prop 'required', true
#   else
#     parentBlock.next().hide()
#     parentBlock.next().find('input').prop 'required', false

# Drag block with task
# $('.to-do-block').on 'mousedown', (event) ->
#   self = this
#   startX = event.pageX
#   startY = event.pageY
#   currentPosition.left = currentPosition.left + (event.pageX - currentPosition.left)
#   currentPosition.top = currentPosition.top + (event.pageY - currentPosition.top)
#   $(document).on 'mousemove', (event) ->
#     x = event.pageX
#     y = event.pageY

#     $(self).css {
#       'left': currentPosition.left + (x - currentPosition.left),
#       'top': currentPosition.top + (y - currentPosition.top)
#     }

#   $(document).on 'mouseup', ->
#     console.log 'mouseup'
#     $(document).unbind 'mousemove'
#     $(document).unbind 'mouseup'


# Event from the server. When user is ready to start quiz this function adds
# user to the list of ready users

$('.start-first-step').on 'click', ->
  socketIo.emit 'start step1'

# tasks = undefined
# if $('.participants-list').length
#   $.get '/quizTasks'
#     .done (resp) ->
#       tasks = resp.tasks

FAIL_SYMBOL = '--'

users = []

getTotalTime = (resultsOfUser) ->
  totalTime = resultsOfUser.reduce((sum, current)->
    sum += parseInt current.time
  , 0)
  totalTime

socketIo.on 'add user', (data) ->
  console.log 'add'
  user = data.user
  user.results = data.results
  users.push user
  participantsTable = $('.participants-list')
  participantsList = participantsTable.find 'tbody'
  if participantsList.find("tr[data-id=#{user.id}]").length
    return
  participant = $('<tr class="participant" data-id=' + user.id + ' />')
  participant.append $('<td />').text(user.firstName + ' ' + user.lastName)
  for task in allTasks
    participant.append $("<td data-taskid=#{task.id}/>")
  participant.append $('<td class="total" />').text parseTime(getTotalTime(user.results))
  participant.appendTo participantsList

  for result in user.results
    passedTaskColumn = participant.find "td[data-taskid=#{result.task}]"
    if result.selector.length
      passedTaskColumn
        .append $('<span class="time"/>').text(parseTime(result.time))
        .append $('<span class="selector-length"/>').text(result.selector.length)
    else 
      passedTaskColumn.text FAIL_SYMBOL

# Event from the server. When user passes one test of the quiz this function is called
# and adds results to the list
socketIo.on 'test passed', (data) ->
  userIndex = _.findIndex users, { id: data.user.id }
  user = users[userIndex]
  resultIndex = _.findIndex user.results, { task: data.results.taskId }
  console.log resultIndex
  if resultIndex isnt -1
    user.results[resultIndex] = data.results
  else
    user.results.push data.results
  participantsList = $('.participants-list').find 'tbody'
  participantsRows = participantsList.find 'tr'
  participant = participantsList.find 'tr[data-id=' + user.id + ']'
  columns = participant.find('td').toArray()
  task = participant.find "td[data-taskid= #{data.results.taskId}]"
  task.empty()
  time = $('<span class="time"/>')
  selectorLength = $('<span class="selector-length"/>')

  if not data.results.passed
    time.text '--'
    time.data 'limit', data.results.time
    selectorLength.text ''
    participant.css 'background-color', '#f44336'
    setTimeout( ->
      participant.css 'background-color', ''
    , 500)
  else
    time.text parseTime(data.results.time)
    selectorLength.text data.results.selector.length
    participant.css 'background-color', '#b2ff59'
    setTimeout( ->
      participant.css 'background-color', ''
    , 500)

  task.append(time).append(selectorLength)

  # columns.splice(0, 1)
  # columns.splice(-1, 1)

  # totalTime = columns.reduce((sum, current)->
  #   timeCell = $(current).find('.time')
  #   if timeCell.text() is FAIL_SYMBOL
  #     sum += +timeCell.data 'limit'
  #   else
  #     sum += convertTimeToSeconds(timeCell.text())
  # , 0)

  participant.find('.total').text parseTime(getTotalTime(user.results))

  participantsRows.sort (a, b) ->
    totalTimeA = $(a).find '.total'
    totalTimeB = $(b).find '.total'
    convertTimeToSeconds(totalTimeA.text()) - convertTimeToSeconds(totalTimeB.text())

  participantsRows.detach().appendTo participantsList

socketIo.on 'init', ->
  localStorage.clear()
  # socketIo.emit 'ready'
  location.replace '/readyQuiz'

socketIo.on 'next', (data) ->
  localStorage.setItem 'timeLimit', data.time
  localStorage.setItem 'quizTaskId', data.taskId
  localStorage.removeItem 'quizTime'
  location.replace '/quiz'

socketIo.on 'start first step', ->
  localStorage.clear()
  location.replace '/editor'
