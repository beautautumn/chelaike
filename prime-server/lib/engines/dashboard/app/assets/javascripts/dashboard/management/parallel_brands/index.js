$(document).ready(function() {
  $("#parallel-brand-new-button").on("click", function(e) {
    $("#parallel-brand-new-modal").modal("show");
  });
  $("#cancel-button").on("click", function(e) {
    $("#parallel-brand-new-modal").modal("hide");
  });
});
