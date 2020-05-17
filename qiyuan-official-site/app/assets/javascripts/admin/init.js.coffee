window.App ||= {}

App.init = ->
  o = $.AdminLTE.options
  if o.sidebarPushMenu
    $.AdminLTE.pushMenu.activate o.sidebarToggleSelector
  $.AdminLTE.layout.activate()

  $(".input-group.date").datetimepicker({
    format: "YYYY-MM-DD"
  })

$(document).ready ->
  App.init()
