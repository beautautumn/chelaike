$(document).ready(function() {
  $("#ad-new-button").on("click", function(e) {
    $("#ad-new-modal").modal("show");
  });
  $("#cancel-button").on("click", function(e) {
    $("#ad-new-modal").modal("hide");
  });
});
