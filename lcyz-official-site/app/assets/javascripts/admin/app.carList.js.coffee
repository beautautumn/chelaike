class App.CarList
  constructor: () ->

  render: ->
    params = $.deparam()

    # 绑定查询参数
    if params.query
      query = params.query
      brand_name = query.brand_name_eq

      @loadSeries(brand_name, query.series_name_eq) if brand_name
      for k, v of query
        $("[name='query[#{k}]']").val(v)
    # 品牌选择
    instance = @
    $("[name='query[brand_name_eq]']").on "change", (event)->
      instance.loadSeries(this.value)
    # 绑定排序参数
    order_field = params.order_field
    order_by = params.order_by
    $("button[name=#{order_field}]").removeClass("btn-default").addClass("btn-info")
    # 排序触发
    $(document).on "click", ".tc-dashboard-car-list-toolbar button", ->
      params.order_field = this.name
      params.order_by = if params.order_by == "desc" then "asc" else "desc"
      window.location = "/admin/cars?" + $.param(params)
    # 设置展示与否
    $(document).on "click", "button[data-sellable]", ->
      id = this.dataset.carId
      sellable = this.dataset.sellable
      $.post("/admin/cars/#{id}/sellable", { sellable: sellable }).done(
        (response) ->
          currSellable = response.data.sellable
          $("button[data-car-id=#{id}][data-sellable=false]")
            .removeClass("btn-default btn-danger")
            .addClass(if currSellable then "btn-default" else "btn-danger")
          $("button[data-car-id=#{id}][data-sellable=true]")
            .removeClass("btn-default btn-danger")
            .addClass(if currSellable then "btn-danger" else "btn-default")
      )
    # 显示移动端二维码
    $("a.mobile-car-detail-preview").popover({
      html: true,
      trigger: 'focus',
      placement: 'auto left',
      content: () ->
        $(this).children().html('')
        url = $(this).attr('data-qrcode')
        id = $(this).attr('id')

        qrcode = new QRCode(id,
          width: 128
          height: 128)
        qrcode.clear()
        qrcode.makeCode url

        qr_canvas = $(this).find("canvas")
        qr_image = $(this).find("img")

        img = $('<img style="height: 200px; width: 200px">')
        img_src = $(this).children('img').attr('src')

        $(this).children().remove()

        if img_src == undefined
          qr_canvas
        else
          img.attr 'src', img_src
    })

  loadSeries: (brand_name, defaultValue = "") ->
    $.get("/admin/cars/series?brand_name=#{brand_name}").done(
      (response) ->
        return unless response.data
        selector = $("select[name='query[series_name_eq]']")
        selector.html("<option value='' selected>车系</option>")
        $.each response.data, (i, item) ->
          selector.append $("<option>", { value: item.name, text: item.name })
        selector.val(defaultValue)
    )

$(document).ready ->
  return unless $(".cars.index").length > 0
  cl = new App.CarList
  cl.render()
