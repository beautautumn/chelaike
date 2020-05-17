$(document).ready(function() {
  $(".vin-input").on("focusin", function(e) {
    var id = e.currentTarget.dataset.id;
    $('#' + id).addClass('bigger')
  });
  $(".vin-input").on("focusout", function(e) {
    var id = e.currentTarget.dataset.id;
    $('#' + id).removeClass('bigger')
  });
});
