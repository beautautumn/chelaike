(($, window) ->
  defaults = {
    name: "",
    price: 0
  }

  Plugin= (element, options) ->
    @element = element
    @options = $.extend defaults, options
    @downPayments = []
    @loanPeriodRate = []
    @dpText = ""
    @lpText = ""
    @firstPayment = 0
    @monthlyPayment = 0
    @price = @options.price

    $.get('/cars/loan_data').done(
      (response) =>
        @downPayments = response.down_payments.map(
          (item) ->
            return { text: item + "%", value: item }
        )
        @loanPeriodRate = response.loan_periods.map(
          (item) ->
            item.text = item.period + "个月"
            return item
        )
        @init()
        if window.location.hash == "#prepareDetailModal"
          @show()
    )

  Plugin.prototype.init = ->
    template= $('''<div id="loanCostComputeModal" class="weui-popup__container">
      <div class="weui-popup__overlay"></div>
      <div class="weui-popup__modal">
        <div class="tc-loan-rate-computer">
          <div class="car-title"></div>
          <div class="weui-cells weui-cells_form">
            <div class="weui-cell">
              <div class="weui-cell__hd">车辆售价（元）</div>
              <div class="weui-cell__bd car-price">
                <input class="weui-input" type="text" value="">
              </div>
            </div>
            <div class="weui-cell">
              <div class="weui-cell__hd">首付比例（%）</div>
              <div class="weui-cell__bd">
                <input class="weui-input" type="text" value="" id="downPayments" readonly>
              </div>
              <div class="arrow"></div>
            </div>
            <div class="weui-cell">
              <div class="weui-cell__hd">贷款期限（月）</div>
              <div class="weui-cell__bd">
                <input class="weui-input" type="text" value="" id="loanPeriod" readonly>
              </div>
              <div class="arrow"></div>
            </div>
            <div class="weui-cell">
              <div class="weui-flex__item">
                <div class="compute-item-label">首付（元）</div>
                <div class="compute-result first-pay">92640</div>
              </div>
              <div class="split-border"> </div>
              <div class="weui-flex__item right-item">
                <div class="compute-item-label">月供（元）</div>
                <div class="compute-result monthly-pay">19094</div>
              </div>
            </div>
          </div>
          <div class="loan-rate-computer-tip">
            *此结果仅供参考,具体贷款方案要视您的银行征信情况而定
          </div>
        </div>
      </div>
    </div>''')
    $('.car-price>input', template).val(@options.price)
    $('.car-title', template).html(@options.name)
    $('body').append template

    @element.on "click", =>
      @show()

    $(".car-price>input").change =>
      price = parseFloat($(".car-price>input").val())
      @price = if isNaN(price) then 0 else price
      @costCompute()

    @dpText = if @downPayments.length > 0 then @downPayments[0].text else ""
    $("#downPayments").val @dpText
    $("#downPayments").picker({
      cols: [{
        textAlign: "center",
        values: @downPayments.map (item) -> item.text
      }],
      onChange: (p, v) =>
        @dpText = v[0]
        @costCompute()
    })
    @lpText = if @loanPeriodRate.length > 0 then @loanPeriodRate[0].text else ""
    $("#loanPeriod").val @lpText
    $("#loanPeriod").picker({
      cols: [{
        textAlign: "center",
        values: @loanPeriodRate.map (item) -> item.text
      }],
      onChange: (p, v) =>
        @lpText = v[0]
        @costCompute()
    })
    @costCompute()

  Plugin.prototype.show = ->
    $("#loanCostComputeModal").popup()
    window.history.pushState({}, "", "#prepareDetailModal")
    carName = @options.name
    document.title = "分期试算"
    $(window).one "popstate", ->
      document.title = carName
      $.closePicker()
      $.closePopup()

  Plugin.prototype.costCompute = ->
    dp = @downPayments.find (item) => item.text == @dpText
    lp = @loanPeriodRate.find (item) => item.text == @lpText
    if dp && lp && @price > 0
      curDP = dp.value
      curLP = lp.period
      curMonthRate = lp.rate/1200
      @firstPayment = Math.round(@price*curDP/100)
      @monthlyPayment = Math.round((@price-@firstPayment)*curMonthRate*Math.pow(1+curMonthRate, curLP)/(Math.pow(1+curMonthRate, curLP)-1))
    else
      @firstPayment = 0
      @monthlyPayment = 0
    $("#loanCostComputeModal .first-pay").html @formatNumber(@firstPayment)
    $("#loanCostComputeModal .monthly-pay").html @formatNumber(@monthlyPayment)

  Plugin.prototype.formatNumber = (num)->
    return num.toString().replace(/(\d)(?=(\d\d\d)+(?!\d))/g, "$1,")

  $.fn.loanCostComputer = (options) ->
    return @each(
      =>
        initSign = "plungin_loanCostComputer"
        @data(initSign, new Plugin(@, options)) unless @data(initSign)
    )
)(jQuery, window)
