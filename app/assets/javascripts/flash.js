$('document').ready(function() {
  setTimeout(function() {
    $('#flash').fadeOut(500, function() {
      $(this).remove();
    });
  }, 2000);
});
