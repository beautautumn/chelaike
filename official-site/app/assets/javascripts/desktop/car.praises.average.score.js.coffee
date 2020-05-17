(($) ->
  $.fn.praisesAverageScore = (options) ->
    return @each(
      ->
        $(@).addClass 'public-praises-average-score'
        $(@).html "<span style='width:#{parseFloat($(@).attr('data-average-score')) * 100 / 5}%;'></span>"
    )
)(jQuery)