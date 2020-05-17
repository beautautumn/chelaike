class App.Cars
  constructor: () ->
    @fetching = false
    @end = false
    @page = 1
    @container = $(".tc-cars-list-container")
    @lastScrollY = @container.offset().top
    @innerHeight
    @params = $.deparam() || {}

  fetchContent: () =>
    return if @fetching || @end
    @fetching = true
    $(".tc-cars-loading").removeClass("hide")

    $.ajax({
      type: "get",
      url: "/cars/snippet/",
      data: $.extend({}, @params, { page: @page + 1 }),
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
    return unless $(".tc-cars-loading").data("patch-load")
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


  render: ->
    window.setTimeout(this.handleScroll, 100)
    @renderSearchBar()
    @renderFilter()
    @hideMenuItems()
    @setEvents()

  # 搜索栏
  renderSearchBar: ->
    searchText = "请输入品牌或车型车系"
    query = @params.query
    if query? && query.name_cont?
      searchText = query.name_cont
    $("#searchInput").attr("placeholder", searchText)
    $("#searchText>span").html(searchText)
    $('#searchBar').on "submit", ->
      value = $("#searchInput").val()
      window.location = "/cars?query[name_cont]=" + value
      return false;

  # 根据搜索条件显示菜单
  renderFilter: ->
    query = @params.query
    order_by = @params.order_by
    order_field = @params.order_field
    if query? && query.brand_name_eq?
      $(".filter-dropdown.brand").children("span").first().text(query.brand_name_eq)

    if order_field?
      if order_field == "id" && order_by == "desc"
        $(".filter-dropdown.order").children("span").first().text("最新发布")
      if order_field == "show_price_cents" && order_by == "asc"
        $(".filter-dropdown.order").children("span").first().text("价格最低")
      if order_field == "show_price_cents" && order_by == "desc"
        $(".filter-dropdown.order").children("span").first().text("价格最高")
      if order_field == "age" && order_by == "asc"
        $(".filter-dropdown.order").children("span").first().text("车龄最短")
      if order_field == "mileage" && order_by == "asc"
        $(".filter-dropdown.order").children("span").first().text("里程最少")
      $('.filters .brand').css('corlor', 'red')

    brand_name = @params.query && @params.query.brand_name_eq
    series_name = @params.query && @params.query.series_name_eq
    filterLabel = series_name  || brand_name || "品牌"
    $(".filters .brand > span:first-child").html(filterLabel)
    $('.filters .brand').brandSelector({
      brand: brand_name
      style: series_name
      onSelect: (brand, style) =>
        query = @params.query || {}
        setParam = (params, field, value) ->
          if value then params[field] = value else delete params[field]
        setParam(query, "brand_name_eq", brand)
        setParam(query, "series_name_eq", style)
        window.location = "/cars?" + $.param($.extend(@params, { query: query }))
    })

    orders = [
      {name: "默认排序"},
      {name: "价格最低", field: "show_price_cents", orderBy: "asc"},
      {name: "价格最高", field: "show_price_cents", orderBy: "desc"},
      {name: "车龄最短", field: "age", orderBy: "asc"},
      {name: "里程最少", field: "mileage", orderBy: "asc"},
      {name: "最新发布", field: "id", orderBy: "desc"},
    ]
    orderIndex = orders.findIndex (elem) =>
      elem.field == @params.order_field && elem.orderBy == @params.order_by
    orderIndex = 0 if orderIndex == -1
    $(".filters .order > span:first-child").html(orders[orderIndex].name) if orderIndex > 0

    $('.filters .order').filterSelector({
      filters: orders.map (elem) -> elem.name
      selected: orderIndex
      onSelect: (index, text) =>
        order = orders[index]
        if order.field
          @params.order_field = order.field
          @params.order_by = order.orderBy
        else
          delete @params.order_field
          delete @params.order_by
        window.location = "/cars?" + $.param(@params)
    })

    priceRanges = [
      {name: "不限"},
      {name: "10万及以下", end: "10000000"},
      {name: "10-20万", begin: "10000000", end: "20000000"},
      {name: "20-30万", begin: "20000000", end: "30000000"},
      {name: "30-50万", begin: "30000000", end: "50000000"},
      {name: "50-100万", begin: "50000000", end: "100000000"},
      {name: "100万以上", begin: "100000000"},
    ]
    priceRangeIndex = priceRanges.findIndex (elem) =>
      query = @params.query || {}
      elem.begin == query.show_price_cents_gteq && elem.end == query.show_price_cents_lteq
    priceRangeIndex = 0 if priceRangeIndex == -1
    $(".filters .price > span:first-child").html(priceRanges[priceRangeIndex].name) if priceRangeIndex > 0

    $('.filters .price').filterSelector({
      filters: priceRanges.map (elem) -> elem.name
      selected: if priceRangeIndex == -1 then 0 else priceRangeIndex
      onSelect: (index, text) =>
        priceRange = priceRanges[index]
        query = @params.query || {}
        if priceRange.begin
          query.show_price_cents_gteq = priceRange.begin
        else
          delete query.show_price_cents_gteq
        if priceRange.end
          query.show_price_cents_lteq = priceRange.end
        else
          delete query.show_price_cents_lteq
        window.location = "/cars?" + $.param($.extend(@params, { query: query }))
    })
    $('.filters .filter-item').on 'click', ->
      if $(@).hasClass 'brand'
        $('.filters .order').data('plugin_filterSelector').closeSelector()
        $('.filters .price').data('plugin_filterSelector').closeSelector()
      else if $(@).hasClass 'order'
        $('.filters .brand').data('plugin_brandSelector').closeSelector()
        $('.filters .price').data('plugin_filterSelector').closeSelector()
      else
        $('.filters .order').data('plugin_filterSelector').closeSelector()
        $('.filters .brand').data('plugin_brandSelector').closeSelector()


  # 初始化页面时隐藏下拉菜单
  hideMenuItems: ->
    $("ul").hide()

  setEvents: ->
    # 切换布局
    $(".list-grid-toggle").on "click", ->
      if $(".toggle-icon").hasClass("list-icon")
        $(".toggle-icon").removeClass("list-icon")
        $(".toggle-icon").addClass("card-icon")
        $(".tc-cars-list").removeClass("list-view")
        $(".tc-cars-list").addClass("card-view")
      else
        $(".toggle-icon").removeClass("card-icon")
        $(".toggle-icon").addClass("list-icon")
        $(".tc-cars-list").removeClass("card-view")
        $(".tc-cars-list").addClass("list-view")

    # 显示下拉菜单
    $(".filter-dropdown").on "tap", ->
      $("ul").hide()
      $(this).children(".dropdown-items").show()

    # 获取菜单选项
    $(document).on "tap", "[data-field]", (event) =>
      item = $(event.target)
      value = item.attr("data-value")
      field = $(item.closest("[data-field]")[0]).attr("data-field")
      query = @params.query || {}
      if field == "brand_name_eq"
        query["brand_name_eq"] = value
      if field == "order"
        @params.order_field = value
        @params.order_by = item.attr("data-by")
      if field == "price"
        price_range = item.attr("data-value").split("-")
        if price_range[0]?
          query["show_price_cents_gteq"] = price_range[0] * 1000000
        if price_range[1]?
          query["show_price_cents_lteq"] = price_range[1] * 1000000

      @params.query = query

      window.location = "/cars?" + $.param(@params)

$(document).ready ->
  return unless $(".cars.index").length > 0
  cars = new App.Cars
  cars.render()
