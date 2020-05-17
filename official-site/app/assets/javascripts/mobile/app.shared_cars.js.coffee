class App.SharedCars
  constructor: () ->
    @fetching = false
    @page = 2
    @container = $(".tc-cars-list-with-seller-container")
    @lastScrollY = @container.offset().top
    @innerHeight
    @params = $.deparam() || {}

  render: () ->
    window.setTimeout(this.handleScroll, 100)
    @setEvents()
    @removeBottomPadding()

  fetchContent: () =>
    return if @fetching || @end

    @fetching = true
    $(".tc-cars-loading").removeClass("hide")
    query = @params.query
    seller_id = @params.seller_id

    $.ajax({
      type: "get",
      url: "/cars/snippet/",
      data: {
        page: @page,
        query: query,
        seller_id: seller_id
      },
      dataType: "html",
      success: (data) =>
        $(".tc-cars-loading").addClass("hide")
        if data.trim().length == 0
          @end = true
        else
          $(".tc-cars-list").append(data)
          @page += 1
          @fetching = false
    })

  handleScroll: () =>
    currentScrollY = -@container.offset().top
    if @lastScrollY == currentScrollY
      window.setTimeout(this.handleScroll, 100)
      return
    else
      @lastScrollY = currentScrollY

    @innerHeight = window.innerHeight

    if @innerHeight + @lastScrollY + 200 > @container.height()
      this.fetchContent()
    window.setTimeout(this.handleScroll, 100)
  # 移除底部padding
  removeBottomPadding: ->
    $(".weui-tab__bd").css("padding-bottom", "0")

  setEvents: () ->
    # 分享列表销售员二维码图
    $("#seller-wechat-qrcode").on "click", (e) ->
      e.preventDefault()
      $("#seller-qrcode-modal").fadeIn()

    $("#seller-qrcode-modal").on "click", (e) ->
      e.preventDefault()
      $("#seller-qrcode-modal").fadeOut()

$(document).ready ->
  return unless $(".cars.shared_index").length > 0
  shared_cars = new App.SharedCars
  shared_cars.render()
