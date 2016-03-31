$ = require 'jquery'
ace = require 'brace'
_ = require 'lodash'
require 'brace/mode/html'
require 'brace/mode/css'
require('./dividers')()

htmlEditorElement = $('#htmlEditor')
cssEditorElement = $('#cssEditor')
editor = $('.editor')

saveChanges = (params) ->
  params = 
    htmlContent: editorHtml.getValue()

  if editorCss
    params.cssContent = editorCss.getValue()

  $.post '/saveAdmin', params
    .done (resp) ->
      $('iframe').attr('src', resp.filePath)
    .fail ->
      console.log 'Error occured'

htmlCodeChanged = (event) ->
  saveChanges()

cssCodeChanged = (event) ->
  saveChanges()

if htmlEditorElement.length
  htmlCode = htmlEditorElement.text()
  editorHtml = ace.edit 'htmlEditor'
  editorHtml.on 'change', _.debounce(htmlCodeChanged, 2000)
  editorHtml.getSession().setMode 'ace/mode/html'
  editorHtml.setValue htmlCode, -1

if cssEditorElement.length
  cssCode = cssEditorElement.text()
  editorCss = ace.edit 'cssEditor'
  editorCss.on 'change', _.debounce(cssCodeChanged, 2000)
  editorCss.getSession().setMode 'ace/mode/css'
  editorCss.setValue cssCode, -1

submitEditTaskForm = (form, options, url) -> 
  options.taskName = form.find('input[name="name"]').val()
  options.displayNumber = form.find('input[name="displayNumber"]').val()
  options.weight = form.find('input[name="displayNumber"]').val()

  $.ajax {
    url: form.attr('action'),
    data: options,
    method: 'POST'
  }
    .done (resp) ->
      location.href = url
    .fail ->
      console.log 'Error occured'

$('.firststep-task-edit-form').on 'submit', (event) ->
  event.preventDefault()
  targetForm = $(event.currentTarget)

  options = 
    theTask: targetForm.find('textarea[name="theTask"]').val()
    htmlCode: editorHtml.getValue()
    cssCode: editorCss.getValue()

  submitEditTaskForm targetForm, options, '/firstStepTasks'

$('.quiz-task-edit-form').on 'submit', (event) ->
  event.preventDefault()
  targetForm = $(event.currentTarget)

  options = 
    deprecatedSelectors: targetForm.find('input[name="deprecatedSelectors"]').val()
    answares: targetForm.find('input[name="answares"]').val()
    htmlCode: editorHtml.getValue()

  submitEditTaskForm targetForm, options, '/quizStepTasks'

editor.on 'editorResize', ->
  console.log 'resize'
  editorHtml.resize()
  if editorCss
    editorCss.resize()

