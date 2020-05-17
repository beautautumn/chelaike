class App.Home
  constructor: () ->

  setQueryValue: (query, field, value) ->
    delete query[field]
    query[field] = value if value? && value != ""

  render: ->
    $(document).on "click", "a[data-value]", (event) =>
      link = $(event.target)
      value = link.attr("data-value")
      field = link.closest("[data-field]").attr("data-field")
      range = value.split("-")
      query = $.deparam().query || {}
      if ["show_price_cents", "age"].includes(field)
        this.setQueryValue(query, "#{field}_gteq", range[0])
        this.setQueryValue(query, "#{field}_lteq", range[1])
      else
        this.setQueryValue(query, "#{field}_eq", value)
      window.location = "/cars?" + $.param({ query: query })

$(document).ready ->
  return unless $(".home.index").length > 0
  home = new App.Home
  home.render()
