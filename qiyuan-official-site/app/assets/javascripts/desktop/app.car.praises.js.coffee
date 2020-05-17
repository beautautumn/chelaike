class App.CarPraises
  constructor: () ->

  render: ->
    $(".praise-detail > .detail-toggle-button > .toggle-button-down").click ->
      $(@).css("display", "none")
      $(@).next().css("display", "block")
      $(@).parent().parent().children(".detail-item-toggle").css("display", "block")

    $(".praise-detail > .detail-toggle-button > .toggle-button-up").click ->
      $(@).css("display", "none")
      $(@).prev().css("display", "block")
      $(@).parent().parent().children(".detail-item-toggle").css("display", "none")

$(document).ready ->
  return unless $(".cars.public_praises").length > 0
  carPraises = new App.CarPraises
  carPraises.render()
