class App.Contact
  constructor: (@el, @city, @street, @companyName) ->

  render: ->
    map = new BMap.Map(@el)
    point = new BMap.Point(116.331398,39.897445)
    map.centerAndZoom(point,16)
    myGeo = new BMap.Geocoder

    pointAddress = (point) =>
      if point
        map.centerAndZoom(point, 16)
        marker = new BMap.Marker(point)
        map.addOverlay(marker)

        companyInfoWindow = new BMapLib.SearchInfoWindow(map, null, {
          title  : @companyName,    # 标题
          width  : 200,             # 宽度
          panel  : "panel",         # 检索结果面板
          enableAutoPan : true,     # 自动平移
          searchTypes   :[
            BMAPLIB_TAB_TO_HERE,  # 到这里去
            BMAPLIB_TAB_SEARCH,   # 周边检索
          ]
        })
        companyInfoWindow.open(marker)
        marker.addEventListener "click", ->
          companyInfoWindow.open(marker)

    myGeo.getPoint(@street, pointAddress, @city)


$(document).ready ->
  return unless $(".contact.index").length > 0
  contact = new App.Contact "shop_address_map", $("#city").val(), $("#street").val(), $("#companyName").val()
  contact.render()
