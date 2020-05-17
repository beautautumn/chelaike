class App.Session
  constructor: () ->

  render: ->
    $("html").removeAttr("style")
    $("body").removeAttr("style")

$(document).ready ->
  return unless $(".sessions.new").length > 0
  contact = new App.Session
  contact.render()
