$ = require 'jquery'

module.exports = ->
  popup = $('<div class="status-popup" />')
  iconElement = $('<div class="icon"/>')
  messageElement = $('<div class="message"/>')
  popup
    .append iconElement
    .append messageElement
  popup.appendTo 'body'

  showPopup = (message) ->
    messageElement.text message
    popup.slideDown()
    setTimeout( ->
      popup.slideUp()
    , 3000)

  {
    showSuccessPopup: (message) ->
      iconElement
        .empty()
        .append $('<i class="fa fa-check"/>')
      showPopup message
    ,
    showErrorPopup: (message) ->
      iconElement
        .empty()
        .append $('<i class="fa fa-remove"/>')
      messageElement.text message
      showPopup message
  }
