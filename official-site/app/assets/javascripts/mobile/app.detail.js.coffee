class App.Detail
  constructor: () ->

  createEnquiry: () ->
    phone = $("#enquiry_phone").val()
    name = $("#enquiry_name").val()
    car_id = $("#enquiry_car_id").val()
    $.ajax
      url: "/enquiries"
      type: "post"
      dataType: "json"
      data: enquiry: { name: name, car_id: car_id, phone: phone }
      success: (response) ->
        $("#low-price-modal").fadeOut()
        $.toast("询价信息提交成功", "text")

  render: () ->
    @swiper()
    @setEvents()

    carId = $("#id").val()
    # 分期试算
    options = {
      name: $(".tc-car-title").text().trim(),
      price: if $(".tc-price b").length > 0 then parseFloat($(".tc-price b").html().trim())*10000 else 0
    }
    $(".tc-loan .open-popup").loanCostComputer(options)
    # 整备内容
    $(document).on "click", ".tc-car-detail-part>.nav-more>a", ->
      $("#prepareDetailModal").popup();
      window.history.pushState({}, "", "#prepareDetailModal")
      document.title = "整备详情"
      $(window).one "popstate", ->
        document.title = options.name
        $.closePicker()
        $.closePopup()
    # 过户历史
    $(document).on "click", "#transferHistoryDetail", ->
      $("#transferHistoryDialog").css("display","block")
    $(document).on "click", "#transferHistoryMask", ->
      $("#transferHistoryDialog").css("display","none")
    $(document).on "click", "#closeTHDialog", ->
      $("#transferHistoryDialog").css("display","none")
    # 全部口碑
    $(".tc-car-detail-part>.title>.praise-detail").publicPraisesModal(carId)

  swiper: () ->
    carImagesSwiper = new Swiper('.car-detail-images-swiper .swiper-container',
      direction: 'horizontal',
      loop: true,
      effect: 'coverflow',
      spaceBetween: -15,
      autoplay: 2500,
      centeredSlides: true,
      autoplayDisableOnInteraction: false,
      slidesPerView: 1,
      pagination: ".swiper-pagination",
      paginationType: "fraction"
      onClick: (swiper, event)->
        console.log [swiper, event]
        $(".tc-gallery").fadeIn()
        unless @gallerySwiper
          @gallerySwiper = new Swiper('.tc-gallery .swiper-container',
            direction: 'horizontal',
            centeredSlides: true,
            autoplayDisableOnInteraction: false,
            slidesPerView: 1,
            pagination: ".tc-gallery-page-info",
            paginationType: "fraction",
            zoom : true,
            )
        @gallerySwiper.slideTo(swiper.realIndex)
      )
    $(".tc-gallery").on "click", ->
      $(".tc-gallery").fadeOut()

  setEvents: () ->
    $("#low-price-confirm").on "click", (e) =>
      e.preventDefault()
      input_phone = $("#enquiry_phone").val()
      validate = input_phone.match(/^\d{11}$/)
      if validate
        $("#low-price-modal").fadeOut()
        @createEnquiry()
      else
        $("#low-price-modal").fadeOut()
        $.toast("请填写正确的手机号！", "text")

    $("#ask-low-price").on "click", ->
      $("#low-price-modal").fadeIn()

    $(".weui-mask").on "click", ->
      $("#low-price-modal").fadeOut()

    $("#seller-wechat-qrcode").on "click", (e) ->
      e.preventDefault()
      $("#seller-qrcode-modal").fadeIn()

    $("#seller-qrcode-modal").on "click", (e) ->
      e.preventDefault()
      $("#seller-qrcode-modal").fadeOut()

    $("#detail-collect").on "click", ->
      $.ajax
        url: '/cars/' + $(this).attr("data-id") + '/like'
        type: 'put'
        context: this
        success: (response) ->
          return unless response.data.liked?
          if response.data.liked == true
            $.toast("收藏成功!", "text")
            $(this).children("#detail-collect-image").attr("class", "collect-image-checked")
            text_ele = $(this).children("#detail-collect-text")
            text_ele.attr("class", "collect-text-checked")
            text_ele.text("已收藏")
          else
            $.toast("已取消收藏", "text")
            $(this).children("#detail-collect-image").attr("class", "collect-image")
            $(this).children("#detail-collect-text").attr("class", "collect-text")
            text_ele = $(this).children("#detail-collect-text")
            text_ele.attr("class", "collect-text")
            text_ele.text("收藏")

$(document).ready ->
  return unless $(".car-detail").length > 0
  detail = new App.Detail
  detail.render()
