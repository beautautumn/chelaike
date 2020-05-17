class App.CarConfigurations
  constructor: () ->

  render: ->
    $("#addDownPayment").on "click", ->
      template = $('''<li class="list-group-item">
        <input type="text" name="car_configuration[down_payments][]" id="car_configuration_down_payments_" value="" placeholder="首付比例">
        <a href="javascript:;">X</a>
      </li>''')
      $(".down-payments").append template

    $(document).on "click", ".down-payments a", (event)->
      $(event.target).parent().remove()

    $("#addPeriodAndRate").on "click", ->
      template = $('''<li class="list-group-item">
        <input type="text" name="car_configuration[loan_periods][][period]" id="car_configuration_loan_periods__period" value="" placeholder="贷款期限">
        <input type="text" name="car_configuration[loan_periods][][rate]" id="car_configuration_loan_periods__rate" value="" placeholder="贷款利率">
        <a href="javascript:;">X</a>
      </li>''')
      $(".loan-periods").append template

    $(document).on "click", ".loan-periods a", (event)->
      $(event.target).parent().remove()

$(document).ready ->
  return unless $(".car_configurations.show").length > 0
  cc = new App.CarConfigurations
  cc.render()
