class App.CarList
  constructor: () ->
    @params = $.deparam() || {}

  dealWithQuery: () ->
    return null unless @params.query?
    query = @params.query
    dealedQuery = {}
    for key, value of query
      continue if !value? || value == ""
      lastUnderlineIndex = key.lastIndexOf("_")
      field = key.substr(0, lastUnderlineIndex)
      compare = key.substr(lastUnderlineIndex + 1)
      if compare == "eq"
        dealedQuery[field] = value
      else if compare == "gteq"
        dealedQuery[field] = ["", ""] unless dealedQuery[field]?
        dealedQuery[field][0] = value
      else if compare == "lteq"
        dealedQuery[field] = ["", ""] unless dealedQuery[field]?
        dealedQuery[field][1] = value
    return dealedQuery

  matchQuery: () ->
    query = this.dealWithQuery()
    return unless query
    for key, value of query
      finalValue = if $.type(value) == "array" then value.join("-") else value
      # select
      selects = $("select[data-field=\"#{key}\"]")
      if selects.length > 0
        selects.val(finalValue)
        continue

      # link
      $("[data-field=\"#{key}\"]").find("[data-value]").removeClass("active")
      links = $("[data-field=\"#{key}\"]").find("[data-value=\"#{finalValue}\"]")
      if links.length > 0
        links.addClass("active")
      else if $.type(value) == "array"
        # form input
        form = $("form[data-field=\"#{key}\"]")
        scalage = parseInt(form.attr("data-scalage"))
        beginValue = if value[0] == "" then "" else parseInt(value[0])/scalage
        endValue = if value[1] == "" then "" else parseInt(value[1])/scalage
        form.children("[data-begin]").val(beginValue.toString())
        form.children("[data-end]").val(endValue.toString())

        if key == "show_price_cents" or key == 'age'
          if key == "show_price_cents"
            unit = "万"
          else if key == "age"
            unit = "年"

          if beginValue != "" and endValue != ""
            label = "#{beginValue}-#{endValue}#{unit}"
          else if beginValue != ""
            label = "#{beginValue}#{unit}以上"
          else if endValue != ""
            if key == "show_price_cents"
              label = "#{endValue}万以下"
            else if key == "age"
              label = "#{endValue}年内"

          $(".#{key}_links").append("<a href='javascript:;' class='active'>#{label}</a>")

  matchOrder: () ->
    field = @params.order_field
    field = "id" if !field || field == ""
    order = @params.order_by
    order = "desc" if !order || order == ""
    link = $("a[data-order-field=" + field + "]")
    link.closest("li").addClass("active")
    if link.children("span").length > 0
      link.attr("data-order-by", if order == "desc" then "asc" else "desc")
      link.children("span").addClass("glyphicon-arrow-" + if order == "desc" then "up" else "down")

  setQueryValue: (query, field, value) ->
    delete query[field]
    query[field] = value if value? && value != ""

  bindAction: () ->
    $(document).on "click", "a[data-value]", (event) =>
      link = $(event.target)
      value = link.attr("data-value")
      field = link.closest("[data-field]").attr("data-field")
      range = value.split("-")
      query = @params.query || {}
      if ["show_price_cents", "age"].indexOf(field) > -1
        this.setQueryValue(query, "#{field}_gteq", range[0])
        this.setQueryValue(query, "#{field}_lteq", range[1])
      else
        this.setQueryValue(query, "#{field}_eq", value)
      # 级联特殊处理
      if field == "brand_name"
        this.setQueryValue(query, "series_name_eq", "")
      this.fireQuery(query)

    $(document).on "click", "form[data-field] > button", (event) =>
      button = $(event.target)
      form = button.closest("[data-field]")
      field = form.attr("data-field")
      scalage = parseInt(form.attr("data-scalage"))
      beginValue = parseFloat($(form).children("[data-begin]").val())*scalage
      endValue = parseFloat($(form).children("[data-end]").val())*scalage
      beginValue = if isNaN(beginValue) then "" else beginValue.toString()
      endValue = if isNaN(endValue) then "" else endValue.toString()
      query = @params.query || {}
      this.setQueryValue(query, "#{field}_gteq", beginValue)
      this.setQueryValue(query, "#{field}_lteq", endValue)
      this.fireQuery(query)

    $(document).on "change", "select[data-field]", (event) =>
      select = $(event.target)
      value = select.val()
      field = select.attr("data-field")
      range = value.split("-")
      query = @params.query || {}
      if ["mileage", "displacement"].indexOf(field) > -1
        this.setQueryValue(query, "#{field}_gteq", range[0])
        this.setQueryValue(query, "#{field}_lteq", range[1])
      else
        this.setQueryValue(query, "#{field}_eq", value)
      this.fireQuery(query)

    $(document).on "click", "a[data-order-field]", (event) =>
      field = $(event.target).attr("data-order-field")
      order = $(event.target).attr("data-order-by")
      this.setQueryValue(@params, "order_field", field)
      this.setQueryValue(@params, "order_by", order)
      delete @params.page
      window.location = "/cars?" + $.param(@params)

  fireQuery: (query) ->
    window.location = "/cars?" + $.param({ query: query })

  render: ->
    this.matchQuery()

    this.matchOrder()

    this.bindAction()


$(document).ready ->
  return unless $(".cars.index").length > 0
  list = new App.CarList
  list.render()
