window.App ||= {}

App.init = ->
  interval = null
  pay_interval = null

  $('#LoginModal').on 'shown.bs.modal', (event) ->
    query_token = ->
      console.log token
      $.ajax
        type: 'GET'
        url: '/wechats/login_loop_query'
        data: { token: $("#token").val() }
        dataType: 'json'
        success: (data) ->
          if data["status"] == 200
            window.location.reload()
            clearTimeout(interval)
          else
            interval = setTimeout(query_token, 3000)
          return
      return

    query_token()
  $('#LoginModal').on 'hidden.bs.modal', (event) ->
    clearTimeout(interval)

  # modal 显示支付二维码时轮训后端是否接收到付款回调
  $('#wechatPayModal').on 'shown.bs.modal', (event) ->
    pay_query_token = ->
      console.log token
      $.ajax
        type: 'GET'
        url: '/pay/pay_result_query'
        data: { token: $("#pay_token").val() }
        dataType: 'json'
        success: (data) ->
          if data["status"] == 200
            window.location.reload()
            clearTimeout(interval)
          else
            pay_interval = setTimeout(pay_query_token, 3000)
          return
      return

    pay_query_token()

  # 付款二维码 modal 关闭时取消轮训
  $('#wechatPayModal').on 'hidden.bs.modal', (event) ->
    clearTimeout(pay_interval)

  $(document).on "mouseover", "[data-behavior~=show_all_brands]", ->
    $("#all_brands_panel").removeClass("hidden")

  $(document).on "mouseleave", "[data-behavior~=show_all_brands]", ->
    hideCallBack = ->
      panel = $("#all_brands_panel")
      panel.addClass("hidden") unless panel[0].cancelHideSign
      panel[0].cancelHideSign = false
    setTimeout hideCallBack, 500

  $(document).on "mouseover", "#all_brands_panel", ->
    $("#all_brands_panel")[0].cancelHideSign = true

  $(document).on "mouseleave", "#all_brands_panel", ->
    $(this).addClass("hidden")

$(document).ready ->
  App.init()
  $('[data-toggle="tooltip"]').tooltip()
  $('[data-toggle="praisesAverageScore"]').praisesAverageScore()
