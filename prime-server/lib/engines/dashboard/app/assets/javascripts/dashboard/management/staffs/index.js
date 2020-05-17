$(document).ready(function() {
  $("#staff-new-button").on("click", function(e) {
    $("#staff-new-modal").modal("show");
  });

  $("#staff-new-manager-select").dropdown();
});
