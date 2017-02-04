$ = window.jQuery = require 'jquery'
require 'jquery-ui'
ace = require 'brace'
_ = require 'lodash'
require 'brace/mode/html'
require 'brace/mode/css'
require('./dividers')()

editor = $('.editor')
time = 0
intervalId = undefined

editorHtml = ace.edit 'editorHtml'
editorHtml.getSession().setMode 'ace/mode/html'
editorHtml.session.setOptions { tabSize: 2, useSoftTabs: false }
editorHtml.setHighlightActiveLine(false);

editorCss = ace.edit 'editorCss'
editorCss.getSession().setMode 'ace/mode/css'
editorCss.session.setOptions { tabSize: 2, useSoftTabs: false }
editorCss.setHighlightActiveLine(false);

setLocalStorage = (key, value) ->
  localStorage.setItem key, value

getLocalStorage = (key) ->
  localStorage.getItem key

clearLocalStorageItem = (key) ->
  localStorage.removeItem key


initTaskDialog = ->
  dialog = $('#task-dialog').dialog {
    autoOpen: false,
    modal: true,
    width: 824,
    resizable: false,
    draggable: false,
    dialogClass: 'task-dialog'
  }

initInfoDialog = ->
  dialog = $('#info-dialog').dialog {
    autoOpen: false,
    modal: true,
    width: 600,
    resizable: false,
    draggable: false,
    dialogClass: 'redirect-info-dialog'
  }

taskDialog = initTaskDialog()
infoDialog = initInfoDialog();

tasks = []
activeTask = getLocalStorage('activeTask')

showOrHideNextButton = ->
  $nextTaskButton = $('.next-task')
  activeTaskIndex = tasks.indexOf activeTask
  if tasks.length - 1 == activeTaskIndex
    $nextTaskButton.hide()
  else
    $nextTaskButton.show()

showOrHidePrevButton = ->
  $prevTaskButton = $('.prev-task')
  activeTaskIndex = tasks.indexOf(activeTask)
  if activeTaskIndex == 0
    $prevTaskButton.hide()
  else
    $prevTaskButton.show()

showFinishButton = ->
  $finishButton = $('.finish-button')
  activeTaskIndex = tasks.indexOf(activeTask)
  if tasks.length - 1 == activeTaskIndex
    $finishButton.show()
  else
    $finishButton.hide()

# Loads new task from the server
loadTask =  (task) ->
  $.get "/next/#{task}"
    .done (resp) ->
      activeTask = resp.task.id
      setLocalStorage('activeTask', activeTask)
      showTask(resp.task)
    .fail (xhr) ->
      console.log 'Error occured'


init = ->
  $.get "/initFirstStep"
    .done (resp) ->
      tasks = resp.tasksIds
      loadTask(activeTask || tasks[0])
    .fail (xhr) ->
      console.log 'Error occured'

savePage = ->
  $.ajax({
    url: "/save/",
    method: 'POST',
    data: {
      htmlContent: editorHtml.getValue(),
      cssContent: editorCss.getValue(),
      taskId: activeTask
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

parseTime = (time) ->
  minutes = parseInt time / 60
  seconds = time - minutes * 60

  if minutes < 10 then stringMinutes = "0#{minutes}" else stringMinutes = minutes
  if seconds < 10 then stringSeconds = "0#{seconds}" else stringSeconds = seconds

  stringMinutes + ':' + stringSeconds

startTimer = (initTime) ->
  time = getLocalStorage('firstStepStartTime') || initTime || 0
  timer = $('.timer')
  intervalId = setInterval(->
    setLocalStorage 'firstStepStartTime', ++time
    timer.text parseTime(time)
  , 1000)

# Fills editors and popup with new task information
showTask = (task) ->
  htmlCode = getLocalStorage('htmlCode') || task.htmlCode
  cssCode = getLocalStorage('cssCode') || task.cssCode
  editorHtml.setValue htmlCode, -1
  editorCss.setValue cssCode, -1
  toDoBlock = $('.to-do-section')
  toDoBlock.empty()
  toDoBlock.html task.toDo
  $('.task-dialog .ui-dialog-title').text task.name
  $('.js-result').attr 'src', ''

  showOrHideNextButton()
  showOrHidePrevButton()
  showFinishButton()

  startTimer(task.initTime)


saveTaskResults = (taskToLoad) ->
  $.post '/saveTaskResults', {
    taskId: activeTask,
    time: time,
    htmlCode: editorHtml.getValue(),
    cssCode: editorCss.getValue()
  }
    .done ->
      clearLocalStorageItem 'htmlCode'
      clearLocalStorageItem 'cssCode'
      clearLocalStorageItem 'firstStepStartTime'
      clearLocalStorageItem 'activeTask'
      clearInterval intervalId

      if taskToLoad
        loadTask taskToLoad
    .error ->
      console.log 'Error while saving task results'

countDown = () ->
  $timeElement = $('.time-to-redirect')
  time = 30
  setInterval(() ->
    $timeElement.text("#{time--} seconds");

    if time == 0
      location.replace '/'
  , 1000)

init()

$('.next-task').on 'click', ->
  activeTaskIndex = tasks.indexOf(activeTask);
  saveTaskResults(tasks[activeTaskIndex + 1])

$('.prev-task').on 'click', ->
  activeTaskIndex = tasks.indexOf(activeTask);
  saveTaskResults(tasks[activeTaskIndex - 1])

$('.finish-button').on 'click', ->
  saveTaskResults()
  $('.redirect-info-dialog .ui-dialog-title').text 'Finish'
  infoDialog.dialog 'open'
  countDown()

$('.show-task').on 'click', ->
  taskDialog.dialog 'open'

editor.on 'editorResize', ->
  editorHtml.resize()
  editorCss.resize()
