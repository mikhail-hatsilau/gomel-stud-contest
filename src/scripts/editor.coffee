$ = require 'jquery'
ace = require 'brace'
_ = require 'lodash'
require 'brace/mode/html'
require 'brace/mode/css'
require('./dividers')()

codeRunner = $('.js-run')
editor = $('.editor')
startTime = 0

editorHtml = ace.edit 'editorHtml'
editorHtml.getSession().setMode 'ace/mode/html'

editorCss = ace.edit 'editorCss'
editorCss.getSession().setMode 'ace/mode/css'

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
  startTime = new Date().getTime()

# Loads new task from the server
loadTask = ->
  $.get "/next/#{taskNumber}"
    .done (resp) ->
      nextTaskBtn = $('.next-task')

      if resp.next
        nextTaskBtn.show()
      else
        nextTaskBtn.hide()

      setLocalStorage 'taskNumber', taskNumber

      taskId = resp.task.id

      task =
        htmlCode: resp.task.htmlCode
        cssCode: resp.task.cssCode
        toDo: resp.task.toDo
      showTask(task)
    .fail () ->
      console.log arguments

saveTaskResults = () ->
  time = new Date().getTime() - startTime

  $.post '/saveTaskResults', { 
    taskId: taskId,
    time: time,
    htmlCode: editorHtml.getValue(),
    cssCode: editorCss.getValue()
  }
    .done ->
      taskNumber++
      clearLocalStorageItem 'htmlCode'
      clearLocalStorageItem 'cssCode'
      loadTask()
    .error ->
      console.log 'Error while saving task results'

startQuiz = ->
  localStorage.removeItem 'taskNumber'
  location.href = '/quiz'

# Submitting user's form inside the frame
submitFrameForm = (action) ->
  that = this
  $.ajax {
    url: action,
    method: 'POST',
    data: $(this).serialize()
  }
    .done (resp) ->
      QUIZ_ROUTE = '/quiz'
      body = $(that).parent 'body'
      body.empty()
      body.append resp
      saveTaskResults()
      socketIo.emit 'ready to start'

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

socketIo.on 'start quiz', ->
  startQuiz()




