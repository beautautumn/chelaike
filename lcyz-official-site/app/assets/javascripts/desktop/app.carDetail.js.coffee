class App.CarDetail
  constructor: () ->

  costCompute: ->
    dp = parseFloat($('#instalmentComputeModal .down-payments-select').val())
    lp = JSON.parse($('#instalmentComputeModal .loan-periods-select').val())
    price = parseFloat($("#instalmentComputeModal .price-value").val())
    price = 0 if isNaN(price)
    firstPayment = 0
    monthlyPayment = 0
    if dp && lp && price > 0
      curLP = lp.period
      curMonthRate = lp.rate / 1200
      firstPayment = Math.round(price * dp / 100)
      monthlyPayment = Math.round((price - firstPayment) * curMonthRate * Math.pow(1 + curMonthRate, curLP) / (Math.pow(1 + curMonthRate, curLP) - 1))

    $("#instalmentComputeModal .first-pay-value").html(@formatNumber(firstPayment))
    $("#instalmentComputeModal .monthly-pay-value").html(@formatNumber(monthlyPayment))

  formatNumber: (num) ->
    return num.toString().replace(/(\d)(?=(\d\d\d)+(?!\d))/g, "$1,")

  render: ->
    $('.slider-for').slick({
      lazyLoad: 'ondemand',
      slidesToShow: 1,
      slidesToScroll: 1,
      fade: true,
      asNavFor: '.slider-nav'
    })
    $('.slider-nav').slick({
      lazyLoad: 'ondemand',
      slidesToShow: 4,
      slidesToScroll: 1,
      asNavFor: '.slider-for',
      focusOnSelect: true,
      prevArrow: "<span class='slider-chevron-left'></span>",
      nextArrow: "<span class='slider-chevron-right'></span>",
    })
    $('.tc-viewer').slick({
      lazyLoad: 'ondemand',
      slidesToShow: 1,
      slidesToScroll: 1,
      fade: true,
      prevArrow: "<button class='left'>a</button>",
      nextArrow: "<button class='right'>b</button>",
    })

    $('#carImgViewModal').on 'show.bs.modal', (event) ->
      link = $(event.relatedTarget)
      $('.tc-viewer').slick('slickGoTo', parseInt(link.attr("data-index")))

    $('#wechatPayModal').on 'show.bs.modal', (event) ->
      imageUrl = $(event.relatedTarget).attr("data-image-url")
      $("#wechatPayModal .image").html("<img src='#{imageUrl}'>")

    $('#instalmentComputeModal').on 'show.bs.modal', (event) => @costCompute()

    $('#instalmentComputeModal .price-value').keyup => @costCompute()

    $('#instalmentComputeModal .down-payments-select').change => @costCompute()

    $('#instalmentComputeModal .loan-periods-select').change => @costCompute()

    # 显示完整报告二维码
    $("a.bought-button").popover({
      html: true,
      trigger: 'focus',
      placement: 'auto top',
      content: () ->
        url = $(this).data("qr-url")
        id = $(this).attr('id')

        qrcode = new QRCode(id,
          width: 128
          height: 128)
        qrcode.clear()
        qrcode.makeCode url
        $(this).children().hide()

        img = $('<img id = "paid_qr_code" style="height: 200px; width: 200px">')
        return img
    })

    $('a#report_paid_maintenancerecord').on 'shown.bs.popover', ->
      src = $(this).find('img:first')[0].src
      $('#paid_qr_code').attr 'src', src
      return
    $('a#report_paid_insurancerecord').on 'shown.bs.popover', ->
      src = $(this).find('img:first')[0].src
      $('#paid_qr_code').attr 'src', src
      return

$(document).ready ->
  return unless $(".cars.show").length > 0
  detail = new App.CarDetail
  detail.render()
