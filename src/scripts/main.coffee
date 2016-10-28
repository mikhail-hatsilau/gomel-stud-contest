$ = window.jQuery = require 'jquery'
_ = require 'lodash'
require 'jquery-ui'
statusPopup = require('./statusPopup')()
$(->

  intervalId = undefined

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

  filterTimeValues = (rows) ->
    for row in rows
      total = 0
      timeColumns = $(row).find 'td.time'
      for column in timeColumns
        elementWithTime = $(column).find('.sort-item')
        total += +elementWithTime.text()
        elementWithTime.text parseTime(elementWithTime.text())
      $(row)
        .find '.total'
        .find '.sort-item'
        .text parseTime total

  (->
    if $('.quiz-results').length
      rows = $('.quiz-results').find('tbody').find 'tr'
      filterTimeValues rows
    if $('.first-step-results').length
      rows = $('.first-step-results').find('tbody').find 'tr'
      filterTimeValues rows
    if $('.time-spent-markup').length
      timeElement = $('.time-spent-markup').find 'span'
      timeElement.text parseTime(parseInt(timeElement.text()))
  )()

  $('.sign-in').on 'submit', (event) ->
    event.preventDefault()

    serverErrorElement = $('.server-error').empty()

    $.ajax {
      url: $(this).attr('action'),
      method: 'POST',
      data: $(this).serialize()
    }
      .done ->
        location.href = '/'
      .fail (xhr) ->
        serverErrorElement.text xhr.responseJSON.message

  initRemoveConfirmDialog = ->
    dialog = $('#removeConfirmationDialog').dialog {
      autoOpen: false,
      modal: true,
      minWidth: 400,
      resizable: false
    }

  initLoginDialog = ->
    dialog = $('#login-popup').dialog {
      autoOpen: false,
      modal: true,
      width: 344,
      resizable: false,
      dialogClass: 'login-dialog'
    }

  removeConfirmationDialog = initRemoveConfirmDialog()
  loginDialog = initLoginDialog()

  $('.btn-login').on 'click', ->
    loginDialog.dialog 'open'

  $(document).on 'click', (event) ->
    $('.dropdown-menu').slideUp()

  $('a[data-toggle="dropdown"]').on 'click', (event) ->
    dropdownMenu = $(this).next '.dropdown-menu'
    dropdownMenu.slideToggle()
    event.stopPropagation()

  addUser = (form) ->
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
    $('.stop-quiz-task').prop 'disabled', true
    if not currentTasks.length
      $('.start-quiz-btn').prop 'disabled', true
      localStorage.removeItem 'currentQuizTask'
    else
      $('.start-quiz-btn').prop 'disabled', false
      localStorage.setItem 'currentQuizTask', currentTasks[0].id

  $('.init-quiz').on 'click', (event) ->
    users.length = 0

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

      stopTask()

  $('.start-quiz-btn').on 'click', ->
    that = this
    timeLimit = $('.quiz-task-time').find('input').val()
    task = currentTasks.shift()
    socketIo.emit 'next task', {
      timeLimit: timeLimit,
      task: task
    }, ->
      localStorage.setItem 'currentQuizTask', task.id
      $('.current-task').find('span').text task.name
      # $('.next-quiz-task').prop 'disabled', false
      $('.stop-quiz-task').prop 'disabled', false
      $(that).prop 'disabled', true
      # if not allTasks.length
      #   $('.next-quiz-task').prop 'disabled', true
      setTimeout setTimer, 500

  $('.stop-quiz-task').on 'click', ->
    socketIo.emit 'stop task', null, ->
      stopTask()

  clearQuiz = ->
    $.post '/clearQuiz'
      .done (resp) ->
        statusPopup.showSuccessPopup resp.message
        localStorage.removeItem 'currentQuizTask'
        $('.quiz-results')
          .find 'tbody'
          .empty()
        $('.start-quiz-btn').prop 'disabled', true
        $('.stop-quiz-task').prop 'disabled', true
      .fail ->
        console.log 'Error ocured'
        statusPopup.showErrorPopup 'Results were not cleared'

  $('.clear-quiz-results').on 'click', ->
    removeConfirmationDialog.dialog 'option', 'title', 'Clear quiz results'
    removeConfirmationDialog.dialog 'option', 'buttons', [
      {
        text: 'Clear',
        click: ->
          clearQuiz()
          $(this).dialog 'close'
      },
      {
        text: 'Close',
        click: ->
          $(this).dialog 'close'
      }
    ]
    removeConfirmationDialog.dialog 'open'

  # saveResults function sends ajax for saving marks.
  # Also it hides inputs, shows spans and calculates total
  saveResults = (parent) ->
    editElement = $(parent).find 'input'
    if editElement.length is 0 then return
    participant = editElement.parents('tr')
    textElement = editElement.siblings 'span'
    value = +editElement.val()
    taskId = editElement.parent('td').data 'taskid'
    stepId = editElement.parent('td').data 'stepid'
    if not (value is +textElement.text())
      userId = participant.data 'id'
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
    stepTotalMarkElement = participant.find(".sum[data-stepid=#{stepId}]").find 'span'
    totalMarkElement = participant.find('.total-mark').find 'span'
    elementsWithMarkOfCurrentStep = participant.find(".task[data-stepid=#{stepId}]").find('span')

    stepTotalMark = 0
    for element in elementsWithMarkOfCurrentStep
      stepTotalMark += +$(element).text()
    stepTotalMarkElement.text stepTotalMark

    allStepsTotalElements = participant.find(".sum").find "span"
    totalMark = 0
    for element in allStepsTotalElements
      totalMark += +$(element).text()
    totalMarkElement.text totalMark
    editElement.remove()
    textElement.show()

  # Common results. Save results when user clicks outside of the field with mark
  $('.total-results'). on 'click', (event) ->
    saveResults this

  editMarkCallback = (event) ->
    if $(this)[0] is $(event.target)[0] or $(event.target)[0] is $(this).find('span')[0]
      saveResults $(event.currentTarget).parents '.total-results'
      textElement = $(event.currentTarget).find('span')
      textElement.hide()
      $(event.currentTarget).append $('<input type="text" />').val textElement.text()
    event.stopPropagation()

  # Common results. Show input when user clicks on span with mark
  $('.js-mark').on 'click', editMarkCallback

  # Result sorting
  $('.sort').on 'click', (event) ->
    timeRegExp = /\d{2}:\d{2}/
    ascendingOrder = (a, b) ->
      sortColumnA = $(a).find('td')[colNumber]
      sortColumnB = $(b).find('td')[colNumber]
      value1 = $(sortColumnA).find('.sort-item').text()
      value2 = $(sortColumnB).find('.sort-item').text()
      if timeRegExp.test value1
        value1 = convertTimeToSeconds value1
        value2 = convertTimeToSeconds value2
      else
        value1 = parseInt value1
        value2 = parseInt value2
      value1 - value2

    descendingOrder = (a, b) ->
      sortColumnA = $(a).find('td')[colNumber]
      sortColumnB = $(b).find('td')[colNumber]
      value1 = $(sortColumnA).find('.sort-item').text()
      value2 = $(sortColumnB).find('.sort-item').text()
      if timeRegExp.test value1
        value1 = convertTimeToSeconds value1
        value2 = convertTimeToSeconds value2
      else
        value1 = parseInt value1
        value2 = parseInt value2
      value2 - value1

    colNumber = +$(this).data 'col'
    sorted = $(this).data('sorted') || false
    table = $(this).parents 'table'
    rows = table.find('tbody').find 'tr'
    rows.detach()
    if sorted
      rows.sort descendingOrder
      $(this).data 'sorted', false
      if $(this).hasClass 'ascending'
        $(this).removeClass 'ascending'
      $(this).addClass 'descending'
    else
      rows.sort ascendingOrder
      $(this).data 'sorted', true
      if $(this).hasClass 'descending'
        $(this).removeClass 'descending'
      $(this).addClass 'ascending'

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

  $('.edit-mark').find('input').on 'blur', (event) ->
    userInfoElement = $(this).parents '.user-task-info'
    userId = userInfoElement.data 'userid'
    taskId = userInfoElement.data 'taskid'

    $.post '/saveResults', {
      userId: userId,
      taskId: taskId,
      value: $(this).val()
    }
      .error ->
        console.log 'Error occured'


  $('.start-first-step').on 'click', ->
    socketIo.emit 'start step1', null, ->
      statusPopup.showSuccessPopup "First step is seccesfully started"

  FAIL_SYMBOL = '--'

  users = []

  getTotalTime = (resultsOfUser) ->
    totalTime = resultsOfUser.reduce((sum, current)->
      sum += parseInt current.time
    , 0)

  addUserBoard = (user) ->
    participantsTable = $('.participants-list')
    participantsList = participantsTable.find 'tbody'
    if participantsList.find("tr[data-id=#{user.id}]").length
      return
    participant = $('<tr class="participant" data-id=' + user.id + ' />')
    participant.append $('<td />').text(user.firstName + ' ' + user.lastName)

    totalTimeOfUser = getTotalTime(user.results)
    participant.append $('<td class="total" />').text parseTime(totalTimeOfUser)
    participant.attr 'data-total', totalTimeOfUser
    participant.appendTo participantsList

  addUserResultsTable = (user) ->
    resultsTable = $('.quiz-results')
    if resultsTable.find("tr[data-id=#{user.id}]").length
      return
    participant = $("<tr data-id=#{user.id} />")

    participant.append $('<td />').text(user.firstName + ' ' + user.lastName)

    for task in allTasks
      participant
        .append("<td data-taskid=#{task.id} class='time'/>")
        .append("<td data-taskid=#{task.id} class='selector'/>")
        .append("<td data-taskid=#{task.id} class='selector-length'/>")

    participant.append $('<td class="total"/>')

    resultsTable
      .find('tbody')
      .append participant

  socketIo.on 'add user', (data) ->
    user = data.user
    user.results = data.results

    if $('.participants-list').length
      addUserBoard(user)

    if $('.quiz-results').length
      addUserResultsTable(user)

  updateBoard = (data) ->
    participantsList = $('.participants-list').find 'tbody'
    participantsRows = participantsList.find 'tr'
    participant = participantsList.find 'tr[data-id=' + data.user.id + ']'
    taskResult = participant.find 'td.task-result'
    # columns = participant.find('td').toArray()
    # task = participant.find "td[data-taskid= #{data.results.taskId}]"
    # task.empty()
    time = $('<div class="time"/>')
    selectorLength = $('<div class="selector-length"/>')

    if not data.results.passed
      time.text '--'
      # time.data 'limit', data.results.time
      selectorLength.text ''
      participant.css 'background-color', '#f44336'
      setTimeout( ->
        participant.css 'background-color', ''
      , 500)
    else
      time.text parseTime(parseInt(data.results.time))
      selectorLength.text data.results.selector.length
      participant.css 'background-color', '#b2ff59'
      setTimeout( ->
        participant.css 'background-color', ''
      , 500)

    taskResult.append(time).append(selectorLength)

    totalTimeOfUser = (+participant.attr('data-total') - data.results.timeLimit) + parseInt(data.results.time)
    participant.find('.total').text parseTime(totalTimeOfUser)
    participant.attr 'data-total', totalTimeOfUser

    participantsRows.sort (a, b) ->
      totalTimeA = $(a).attr 'data-total'
      totalTimeB = $(b).attr 'data-total'
      parseInt(totalTimeA) - parseInt(totalTimeB)

    participantsRows.detach().appendTo participantsList

  updateResultsTable = (data) ->
    total = 0
    resultsTable = $('.quiz-results')
    participant = resultsTable.find "tr[data-id=#{data.user.id}]"
    columns = participant.find 'td.time'

    participant
      .find "td.time[data-taskid=#{data.results.taskId}]"
      .empty()
      .append $('<span class="sort-item"/>').text(parseTime(parseInt(data.results.time)))

    participant
      .find "td.selector[data-taskid=#{data.results.taskId}]"
      .attr "title", data.results.selector
      .empty()
      .text data.results.selector

    participant
      .find "td.selector-length[data-taskid=#{data.results.taskId}]"
      .empty()
      .append $('<span class="sort-item"/>').text(data.results.selector.length)

    for column in columns
      time = $(column)
        .find '.sort-item'
        .text()
      if time.length
        total += convertTimeToSeconds time

    participant
      .find '.total'
      .empty()
      .append $('<span class="sort-item"/>').text(parseTime(total))


  # Event from the server. When user passes one test of the quiz this function is called
  # and adds results to the list
  socketIo.on 'test passed', (data) ->
    if $('.participants-list').length
      updateBoard(data)

    if $('.quiz-results').length
      updateResultsTable(data)



  socketIo.on 'init', ->
    localStorage.clear()
    location.replace '/readyQuiz'

  socketIo.on 'init board', ->
    $('.participants-list')
      .find '.task-name'
      .remove()

    $('.participants-list')
      .find 'tbody'
      .empty()

  socketIo.on 'next task board', (data) ->
    task = data.task
    timeLimit = +data.timeLimit
    participantsList = $('.participants-list')
    elementNameOfCurrentTask = participantsList.find '.task-name'
    if not elementNameOfCurrentTask.length
      participantsList
        .find 'th:first-child'
        .after $('<th class="task-name"/>').text(task.name)
    else
      elementNameOfCurrentTask.text task.name

    currentTaskResult = participantsList.find '.task-result'
    if not currentTaskResult.length
      participantsList
        .find 'tr'
        .find 'td:first-child'
        .after $('<td class="task-result"/>')
    else
      currentTaskResult.empty()

    usersRows = participantsList
      .find 'tbody'
      .find 'tr'

    for userRow in usersRows
      total = $(userRow).attr('data-total')
      $(userRow)
        .attr 'data-total', +total + timeLimit


  socketIo.on 'next', (data) ->
    localStorage.setItem 'timeLimit', data.time
    localStorage.setItem 'quizTaskId', data.taskId
    localStorage.removeItem 'quizTime'
    location.replace '/quiz'

  socketIo.on 'start first step', ->
    localStorage.clear()
    location.replace '/editor'
)
