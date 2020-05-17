(($, window) ->

  Plugin= (element, carId) ->
    @element = element
    @id = carId
    @page = 0
    @loading = false
    @end = false
    @init()

  Plugin.prototype.init = ->
    $(".tc-public-praises-modal").infinite().on "infinite", =>
      @load()

    @element.on "click", =>
      @show()

    $(document).on "click", "a.toggle-praise-detail", (event)->
      link = $(event.target)
      content = link.closest(".tc-public-praise-content")
      content.find(".praise-default-part").toggleClass("show")
      content.find(".praise-more-part").toggleClass("hidden")
      content.find("a.toggle-praise-detail").toggleClass("open")

    @load()

  Plugin.prototype.show = ->
    $("#publicPraisesModal").popup()
    window.history.pushState({}, "", "#publicPraisesModal")
    carName = document.title
    document.title = "全部口碑"
    @enabledGoTop()
    $(window).one "popstate", ->
      document.title = carName
      $(".tc-go-top").fadeOut().off "click"
      $.closePicker()
      $.closePopup()

  Plugin.prototype.enabledGoTop = ->
    btn = $(".tc-go-top")
    $(".tc-public-praises-modal").scroll ->
      scrollTop = $(".tc-public-praises-modal").scrollTop()
      if scrollTop > 400
        btn.fadeIn()
      else
        btn.fadeOut()
    btn.on "click", ->
      $('.tc-public-praises-modal').animate({scrollTop:'0'}, 400, 'swing')

  Plugin.prototype.render = (data) ->
    tpl= $.t7.compile("""
      <div class="tc-public-praise-content">
        <div class="header">
          <img src="{{logo}}" alt="avatar" class="avatar">
          <div class="nick-name">{{username}}</div>
          <div class="public-date">{{content.content.date}}</div>
        </div>
        <div class="praise-default-part show">
          <div class="weui-flex praise-abstract">
            <div class="label">
              <span>满意</span>
            </div>
            <div class="weui-flex__item desc">{{content.content.body[0][1]}}</div>
          </div>
          <div class="weui-flex praise-abstract">
            <div class="label">
              <span>不满意</span>
            </div>
            <div class="weui-flex__item desc">{{content.content.body[1][1]}}</div>
          </div>
        </div>
        <div class="praise-more-part hidden">
          <div class="praise-item-desc">
            {{#content.content.body}}
              <p>{{0}}{{1}}</p>
            {{/content.content.body}}
          </div>
          {{#content.addition}}
            <div class="praise-append">
              <div>{{date}}追加</div>
              {{#body}}
                <p>{{0}}{{1}}</p>
              {{/body}}
            </div>
          {{/content.addition}}
        </div>
        <div class="tc-auto-car-right"></div>
        <div class="footer">
          <a href="javascript:;" class="toggle-praise-detail"></a>
        </div>
      </div>
    """)
    container = $(".tc-public-praise-container")
    for item in data
      do (item) ->
        container.append tpl(item)

  Plugin.prototype.load = ->
    return if @loading || @end
    @loading = true
    @page += 1
    $.get("/cars/#{@id}/praises?page=#{@page}").done(
      (response) =>
        if response.length == 0
          @end = true
          $(".tc-public-praises-modal").destroyInfinite()
          $(".tc-public-praises-modal .weui-loadmore").fadeOut()
        else
          @render(response)
          @loading = false
    )


  $.fn.publicPraisesModal = (carId) ->
    return @each(
      =>
        initSign = "plungin_publicPraisesModal"
        @data(initSign, new Plugin(@, carId)) unless @data(initSign)
    )
)(jQuery, window)
