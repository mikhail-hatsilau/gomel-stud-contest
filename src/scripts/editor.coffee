$ = require 'jquery'
ace = require 'brace'
_ = require 'lodash'
require 'brace/mode/html'
require 'brace/mode/css'
require('./dividers')()

codeRunner = $('.js-run')
editor = $('.editor')
time = 0
intervalId = undefined

editorHtml = ace.edit 'editorHtml'
editorHtml.getSession().setMode 'ace/mode/html'
editorHtml.session.setOptions { tabSize: 2, useSoftTabs: false }

editorCss = ace.edit 'editorCss'
editorCss.getSession().setMode 'ace/mode/css'
editorCss.session.setOptions { tabSize: 2, useSoftTabs: false }

setLocalStorage = (key, value) ->
  localStorage.setItem key, value

getLocalStorage = (key) ->
  localStorage.getItem key

clearLocalStorageItem = (key) ->
  localStorage.removeItem key

taskId = -1
taskNumber = getLocalStorage('taskNumber') || 1

savePage = ->
  $.ajax({
    url: "/save/",
    method: 'POST',
    data: {
      htmlContent: editorHtml.getValue(),
      cssContent: editorCss.getValue(),
      taskId: taskId
    }
  }).done (resp) ->
    jsResult = $('.js-result')
    jsResult.load ->
      form = $(this).contents().find 'form'
      form.on 'submit', (event) ->
        submitFrameForm.call this, $(this).attr 'action'
        event.preventDefault()
        event.stopImmediatePropagation()

    setLocalStorage 'htmlCode', editorHtml.getValue()
    setLocalStorage 'cssCode', editorCss.getValue()

    jsResult.attr 'src', resp.filePath

editorHtml.on 'change', _.debounce(savePage, 2000)
editorCss.on 'change', _.debounce(savePage, 2000)


# Fills editors and popup with new task information
showTask = (task) ->
  console.log task
  htmlCode = getLocalStorage('htmlCode') || task.htmlCode
  cssCode = getLocalStorage('cssCode') || task.cssCode
  editorHtml.setValue htmlCode, -1
  editorCss.setValue cssCode, -1
  toDoBlock = $('.to-do-block')
  toDoBlock.empty()
  toDoBlock.html task.toDo
  $('.js-result').attr 'src', ''
  time = getLocalStorage('firstStepStartTime') || 0
  timer = $('.timer')
  intervalId = setInterval(->
    setLocalStorage 'firstStepStartTime', ++time
    timer.text parseTime(time)
  , 1000)

# Loads new task from the server
loadTask = ->
  $.get "/next/#{taskNumber}"
    .done (resp) ->
      nextTaskBtn = $('.next-task')

      if resp.nextTaskExists
        nextTaskBtn.show()
      else
        nextTaskBtn.hide()

      taskId = resp.task.id
      taskNumber = resp.task.displayNumber

      setLocalStorage 'taskNumber', taskNumber
      taskNumber++

      task =
        htmlCode: resp.task.htmlCode
        cssCode: resp.task.cssCode
        toDo: resp.task.toDo

      showTask(task)
    .fail (xhr) ->
      console.log 'Error occured'

saveTaskResults = () ->
  $.post '/saveTaskResults', { 
    taskId: taskId,
    time: time,
    htmlCode: editorHtml.getValue(),
    cssCode: editorCss.getValue()
  }
    .done ->
      clearLocalStorageItem 'htmlCode'
      clearLocalStorageItem 'cssCode'
      clearLocalStorageItem 'firstStepStartTime'
      clearInterval intervalId
      loadTask()
    .error ->
      console.log 'Error while saving task results'

# startQuiz = ->
#   clearLocalStorageItem 'taskNumber'
#   location.href = '/quiz'

parseTime = (time) ->
  minutes = parseInt time / 60
  seconds = time - minutes * 60

  if minutes < 10 then stringMinutes = "0#{minutes}" else stringMinutes = minutes
  if seconds < 10 then stringSeconds = "0#{seconds}" else stringSeconds = seconds

  stringMinutes + ':' + stringSeconds

# Submitting user's form inside the frame
submitFrameForm = (action) ->
  that = this
  $.ajax {
    url: action,
    method: 'POST',
    data: $(this).serialize()
  }
    .done (resp) ->
      # QUIZ_ROUTE = '/quiz'
      waitTime = 30
      body = $(that).parent 'body'
      contentBlock = $('<div class="frame-info"/>')
      timerElement = $('<div class="timer"/>')
      contentBlock.append $('<div class="message"/>').text(resp.message)
      contentBlock.append timerElement
      body.empty()
      body.append contentBlock
      saveTaskResults()
      clearLocalStorageItem 'taskNumber'
      timerElement.text parseTime(waitTime)
      waitRedirectInterval = setInterval( ->
        timerElement.text parseTime(--waitTime)
        if waitTime is 0
          clearInterval waitRedirectInterval
          location.replace '/'
      , 1000)

    .error (xhr) ->
      $(that).find('.error').remove()
      for error in xhr.responseJSON
        for own key, value of error
          errorDiv = $('<div>').addClass 'error'
          $(that).append errorDiv.text value
  
loadTask()

$('.next-task').on 'click', ->
  saveTaskResults()

editor.on 'editorResize', ->
  editorHtml.resize()
  editorCss.resize()



