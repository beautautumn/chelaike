(($, window, document) ->
  pluginName = 'filterSelector'
  defaults = {}

  Plugin = (element, options) ->
    @element = element
    @options = $.extend {}, defaults, options
    @_defaults = defaults
    @_name = pluginName
    @init()
    return @

  Plugin.prototype.init = ->
    self = @
    $template = $('''<div class='filter-selector'>
        <div class="overlay"></div>
        <ul class="filter-list">
        </ul>
      </div>''')
    filterListHtml = ''
    $.each(
      @options.filters
      (index, filter) ->
        elementClass = "#{if (index is self.options.selected) then 'filter-list-item selected' else 'filter-list-item'}"
        filterListHtml += ("<li class=" + "'#{elementClass}'" + " data-index=#{index}>#{filter}<i class='fa fa-check'></i></li>")
    )
    $('.filter-list', $template).html filterListHtml
    @template = $template
    $('body').append $template
    $(@element).on 'click', ->
      if $(@).hasClass 'selected'
        self.closeSelector()
      else
        $(@).addClass 'selected'
        $('.overlay', $template).css 'top', $(@).parent().offset().top + 39
        $('.filter-list', $template).css 'top', $(@).parent().offset().top + 39
        $template.css 'display', 'block'
        _.delay(
          ->
            $('.weui-tab__bd').addClass 'hide-sroll'
          100
        )
        $('.filter-list', $template).css 'display', 'block'

    $('.overlay', $template).on 'click', ->
      self.closeSelector()
    $('.filter-list-item', $template).on 'click', ->
      index = $(@).data 'index'
      $('.filter-list-item', $template).removeClass 'selected'
      $(@).addClass 'selected'
      self.options.onSelect index, self.options.filters[index]
      self.closeSelector()

  Plugin.prototype.closeSelector = ->
    $(@element).removeClass 'selected'
    @template.css 'display', 'none'
    $('.weui-tab__bd').removeClass 'hide-sroll'

  $.fn[pluginName] = (options) ->
    @each(
      ->
        $.data(@, 'plugin_' + pluginName, new Plugin(@, options)) if (!$.data(@, 'plugin_' + pluginName))
    )
)($, window, document)
