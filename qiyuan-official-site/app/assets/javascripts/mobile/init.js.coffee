window.App ||= {}

App.init = ->
  # 车辆列表-收藏
  $(document).on "click", "[data-behavior~=toggle-like]", ->
    $.ajax
      url: '/cars/' + $(this).attr("data-id") + '/like'
      type: 'put'
      context: this
      success: (response) ->
        if response.data.liked == true
          $("[data-id='" + $(this).attr("data-id") + "']").find(".fav_button").addClass("liked")
          $.toast("收藏成功!", "text")
        else
          $("[data-id='" + $(this).attr("data-id") + "']").find(".fav_button").removeClass("liked")
          $.toast("已取消收藏", "text")

$(document).ready ->
  App.init()
