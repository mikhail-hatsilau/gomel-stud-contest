$ = require 'jquery'

module.exports = ->
  
  # Dividers. 
  bar = $('.bar')
  editorHtmlDomElement = $('.editor:first-of-type')
  editorCssDomElement = $('.editor:last-of-type')
  MIN_SIZE = 5
  editorsBlock = $('.editors')
  resultsBlock = $('.results')
  editor = $('.editor')

  $('.horizontal-divider')
    .mousedown (event) ->
      that = this
      startY = event.pageY
      startPosition = $(this).position()
      editorsHeight = editorsBlock.height()
      editorHtmlHeight = editorHtmlDomElement.height() * 100 / editorsHeight
      editorCssHeight = editorCssDomElement.height() * 100 / editorsHeight
      $(document).mouseup (event) ->

        $(this).off 'mousemove'
        $(this).off 'mouseup'

      $(document).mousemove (event) ->
        offset = event.pageY - startY
        offsetPer = offset * 100 / editorsHeight

        newHeightHtmlEditor = editorHtmlHeight + offsetPer
        newHeightCssEditor = editorCssHeight - offsetPer

        if newHeightHtmlEditor <= MIN_SIZE or newHeightCssEditor <= MIN_SIZE
          return

        editorHtmlDomElement.css('height', newHeightHtmlEditor + '%')
        editorCssDomElement.css('height', newHeightCssEditor + '%')

        newTopPosition = startPosition.top * 100 / editorsHeight + offsetPer

        $(that).css('top', newTopPosition + '%')

        editor.trigger 'editorResize'
          

  $('.vertical-divider')
    .mousedown (event) ->
      that = this
      startX = event.pageX
      startPosition = $(this).position()
      barWidth = bar.width()
      editorsBlockWidth = editorsBlock.width() * 100 / barWidth
      resultsBlockWidth = resultsBlock.width() * 100 / barWidth
      $overlayer = $('<div>').addClass 'overlayer'
      resultsBlock.append $overlayer

      $(document).mouseup (event) ->
        $(this).off 'mousemove'
        $(this).off 'mouseup'

        $overlayer.remove()

      $(document).mousemove (event) ->
        offset = event.pageX - startX
        offsetPer = offset * 100 / barWidth
        newEditorsWidth = editorsBlockWidth + offsetPer
        newResultsWidth = resultsBlockWidth - offsetPer

        if newEditorsWidth <= MIN_SIZE or newResultsWidth <= MIN_SIZE
          return

        resultsBlock.css('width', newResultsWidth + '%')
        editorsBlock.css('width', newEditorsWidth + '%')

        newLeftPosition = startPosition.left * 100 / barWidth + offsetPer

        $(that).css('left', newLeftPosition + '%')

        editor.trigger 'editorResize'
