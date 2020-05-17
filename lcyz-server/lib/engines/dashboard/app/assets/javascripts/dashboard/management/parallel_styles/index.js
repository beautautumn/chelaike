$(document).ready(function() {
  $("#parallel-style-new-button").on("click", function(e) {
    $("#parallel-style-new-modal").modal("show");
  });
  $("#cancel-button").on("click", function(e) {
    $("#parallel-style-new-modal").modal("hide");
  });
});
