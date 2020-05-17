$(document).ready(function() {
  $('input[name="start_date"], input[name="end_date"]').daterangepicker({
    locale: {
      format: 'YYYY-MM-DD'
    },
    singleDatePicker: true,
    showDropdowns: true
  });
});
