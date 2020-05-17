class App.InspectionReport
  constructor: () ->

  render: ->
    $('.collapse-uploader').hide()
    $('.upload-input').attr 'disabled', true
    $('.link-label').on 'click', ->
      $('.collapse-uploader').hide()
      $('.collapse-link').show()
      $(".link-input").attr 'disabled', false
      $('.upload-input').attr 'disabled', true
      return

    $('.photo-label').on 'click', (event) ->
      $('.collapse-link').hide()
      $('.collapse-uploader').show()
      $('.upload-input').attr 'disabled', false
      $(".link-input").attr 'disabled', true
      return

    $('.pdf-label').on 'click', (event) ->
      $('.collapse-link').hide()
      $('.collapse-uploader').show()
      $('.upload-input').attr 'disabled', false
      $(".link-input").attr 'disabled', true
      return
    if ($("#pdf").length > 0)
      $(".pdf-label").addClass("disabled")
      $("#pdf-input").attr 'disabled', true
    else
      $(".pdf-label").removeClass("disabled")

$(document).ready ->
  return unless $(".inspection_report.index").length > 0
  cl = new App.InspectionReport
  cl.render()
