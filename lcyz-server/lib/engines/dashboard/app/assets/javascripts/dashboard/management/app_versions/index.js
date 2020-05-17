$(document).ready(function() {
  $("#app-version-new-button").on("click", function(e) {
    $("#app-version-new-modal").modal("show");
  });

  $("#app-version-new-companies-select").dropdown();
});
