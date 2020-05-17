class App.Pay
  buy: () ->
    token = $("#pay-data").data 'token'
    car_detail_url = $("#pay-data").data 'redirect'

    if window.localStorage.getItem('paid') == "true"
      window.location.href = car_detail_url
      window.localStorage.removeItem 'paid'

    $.ajax
      url: '/pay/pay'
      type: 'post'
      data: { token: token }
      success: (charge) ->
        pingpp.createPayment charge, (result, err) ->
          if result == 'success'
            window.localStorage.setItem 'paid', true
            window.location.href = charge.metadata.record_url
            # 只有微信公众账号 wx_pub 支付成功的结果会在这里返回，其他的支付结果都会跳转到 extra 中对应的 URL。
          else if result == 'fail'
            alert err.extra
            window.location.href = car_detail_url
            # charge 不正确或者微信公众账号支付失败时会在此处返回
          else if result == 'cancel'
            window.location.href = car_detail_url
            # 微信公众账号支付取消支付

  render: ->
    this.buy()

$(document).ready ->
  return unless $(".pay.index").length > 0
  pay = new App.Pay
  pay.render()
