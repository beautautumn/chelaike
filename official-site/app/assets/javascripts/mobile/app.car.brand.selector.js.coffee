(($, window, document) ->
  pluginName = 'brandSelector'
  defaults = {}
  $.fn.scrollTo = (options) ->
    defaults =
      toT: 90
      durTime: 500
      delay: 30
      callback: null
    opts = $.extend({},defaults, options)
    timer = null
    _this = @
    curTop = _this.scrollTop()
    subTop = opts.toT - curTop
    index = 0
    dur = Math.round(opts.durTime / opts.delay)
    smoothScroll = (t) ->
      index++
      per = Math.round(subTop / dur)
      if index >= dur
        _this.scrollTop t
        window.clearInterval timer
        if opts.callback and typeof opts.callback == 'function'
          opts.callback()
        return
      else
        _this.scrollTop(curTop + index * per)
    timer = window.setInterval(
      ->
        smoothScroll opts.toT
      opts.delay
    )

  Plugin = (element, options) ->
    @element = element
    @options = $.extend {}, defaults, options
    @data = []
    @series = []
    @selectedBrand = @options.brand
    @selectedStyle = @options.style
    @alphaPositionMap = {}
    @alphaTimer = null
    @hotBrands = []
    @_defaults = defaults
    @_name = pluginName
    self = @
    $.get('/cars/brand_and_series').done(
      (response) ->
        self.series = response.series
        data = [{key: "#", type: "letter", text: "热门品牌"}]
        alphas = ["#"]
        brands = []
        hotBrands = []
        dataSet = _.map(
          response.brands
          (collection) ->
            collection.first_letter = collection.first_letter.toUpperCase() if collection.first_letter?
            unless /^[A-Z]$/.test collection.first_letter
              collection.first_letter = '#'
            collection
        )
        _.each _.sortBy(dataSet, 'first_letter'), (item) ->
          if item.is_hot
            botBrand = _.extend {}, item
            botBrand.first_letter = '#'
            hotBrands.push botBrand
          brands.push _.extend(item, {is_hot: false})
        self.hotBrands = hotBrands
        self.selectedBrand = self.hotBrands[0].name if self.hotBrands and _.isEmpty(self.options.brand)
        _.each hotBrands.concat(brands), (item, index) ->
          unless _.includes alphas, item.first_letter
            if item.first_letter
              alphas.push item.first_letter
              data.push(
                key: item.first_letter
                text: item.first_letter
                type: 'letter'
              )
          data.push item
        self.brands = data
        self.alphas = alphas
        self.init()
    )
    return @

  Plugin.prototype.init = ->
    self = @
    $template = $('''<div class='brand-selector'>
        <div class="alpha-tint"></div>
        <div class="selector-wrapper">
          <ul class="brand-list"></ul>
          <ul class="style-list"></ul>
          <ul class="alpha-list"></ul>
        </div>
      </div>''')
    brandsHtml = '<li class="brand-list-item" data-brand="">ALL 不限品牌</li>'
    brandSelected = false
    _.each @brands, (brand) ->
      if brand.type is 'letter'
        brandsHtml += "<li class='brand-list-item-alpha' data-alpha-index=#{brand.key}>#{brand.text}</li>"
      else
        brandsHtml += "<li class='brand-list-item " + "#{if (self.selectedBrand is brand.name and !brandSelected) then 'selected' else ''}" + "' data-brand=#{brand.name}>#{brand.name}</li>"
      brandSelected = true if self.selectedBrand is brand.name
      null
    $('.brand-list', $template).html brandsHtml
    alphaHtml = ""
    _.each @alphas, (value) ->
      alphaHtml += "<li class='alpha-list-item' data-alpha=#{value}>#{value}</li>"
    @template = $template
    $('.alpha-list', $template).html alphaHtml
    $('body').append $template
    @refreshStyleList()
    $(@element).on 'click', ->
      if $(@).hasClass 'selected'
        self.closeSelector()
      else
        $('.selector-wrapper', $template).css 'top', $(@).parent().offset().top + 39
        $(@).addClass 'selected'
        $template.css 'display', 'block'
        _.delay(
          ->
            $('.weui-tab__bd').addClass 'hide-sroll'
          100
        )
        $('.brand-list', $template).css 'display', 'block'
        $('.style-list', $template).css 'display', 'block'
        $('.alpha-list', $template).css 'display', 'block'
        if self.options.brand
          self.selectedBrand = self.options.brand
        else
          self.selectedBrand = self.hotBrands[0].name if self.hotBrands
        self.goToBrand self.selectedBrand
        self.selectedStyle = self.options.style
        $('.alpha-list-item', $template).each ->
          self.alphaPositionMap[$(@).data('alpha')] =
            from: $(@).offset().top
            to: $(@).offset().top + 14

    $('.brand-list-item', $template).on 'click', ->
      selectedBrand = $(@).data('brand')
      self.selectedStyle = null if selectedBrand isnt self.selectedBrand
      self.selectedBrand = selectedBrand
      $('.selected', $('.brand-list')).removeClass 'selected'
      $(@).addClass 'selected'
      self.refreshStyleList()
      if _.isEmpty self.selectedBrand
        self.selectedStyle = null
        self.closeSelector()
        self.onSetData()

    $template.delegate '.style-list-item', 'click', ->
      self.selectedStyle = $(@).data('style')
      $('.selected', $('.style-list')).removeClass 'selected'
      $(@).addClass 'selected'
      self.closeSelector()
      self.onSetData()

    prevPageY = 0
    $('.alpha-list', $template).on 'touchstart MSPointerDown pointerdown', (e) ->
      e.preventDefault()
      e.stopPropagation()
      if e.targetTouches
        prevPageY = e.targetTouches[0].pageY
        self.goToPostion prevPageY
        $(@).addClass 'touching'
    $('.alpha-list', $template).on 'touchmove MSPointerMove pointermove', (e) ->
      e.preventDefault()
      e.stopPropagation()
      if e.targetTouches
        currentPageY = e.targetTouches[0].pageY
        if Math.abs(currentPageY - prevPageY) > 12
          prevPageY = currentPageY
          self.goToPostion(currentPageY)
    $('.alpha-list', $template).on 'touchend MSPointerUp pointerup', ->
      $(@).removeClass 'touching'

  Plugin.prototype.refreshStyleList = ->
    self = @
    seriesHtml = if @selectedBrand then "<li class='style-list-item " + "#{if (_.isEmpty(self.selectedStyle) && !_.isEmpty(self.options.brand)) then 'selected' else ''}"+ "' data-style=''>不限车系<i class='fa fa-check'></i></li>" else ''
    _.each _.filter(@series, _.matches({brand_name: @selectedBrand})), (sery) ->
      seriesHtml += ("<li class='style-list-item " + "#{if self.selectedStyle is sery.name then 'selected' else ''}"+ "' data-style=#{sery.name}>#{sery.name}<i class='fa fa-check'></i></li>")
    $('.style-list', @template).html seriesHtml

  Plugin.prototype.onSetData = ->
    @options.brand = @selectedBrand or null
    @options.style = @selectedStyle or null
    @options.onSelect @options.brand, @options.style

  Plugin.prototype.goToPostion = (pageY) ->
    self = @
    alphaShow = false
    _.each @alphaPositionMap, (postion, alpha) ->
      if (pageY >= postion.from and pageY < postion.to and !alphaShow)
        alphaShow = true
        $target = $(".brand-list-item-alpha[data-alpha-index=#{alpha}]")[0]
        $alphaTint = $('.alpha-tint', @template)
        clearTimeout self.alphaTimer
        $alphaTint.html(alpha).show()
        self.alphaTimer = window.setTimeout(
          ->
            $alphaTint.hide()
          1000
        )
        $('.brand-list').scrollTo({
          toT: if alpha is '#' then 0 else $target.offsetTop
          durTime: 100
        }) if $target

  Plugin.prototype.goToBrand = (brand) ->
    $target = $(".brand-list-item[data-brand=#{brand}]")[0]
    isHot = !_.isEmpty(_.find(@hotBrands, {name: brand}))
    $('.brand-list').scrollTo({
      toT: if ($target and !isHot) then $target.offsetTop else 0
      durTime: 100
    }) if $target


  Plugin.prototype.closeSelector = ->
    @template.css 'display', 'none'
    $(@element).removeClass 'selected'
    $('.weui-tab__bd').removeClass 'hide-sroll'

  $.fn[pluginName] = (options) ->
    return @each(
      ->
        $.data(@, 'plugin_' + pluginName, new Plugin(@, options)) if (!$.data(@, 'plugin_' + pluginName))
    )
)($, window, document)
