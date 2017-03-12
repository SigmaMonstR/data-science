(function ($) {
  $(document).ready(function(){
    
    var position = $(window).scrollTop(),
        background = $('.scroll')[0].scrollHeight;

    // fade in .navbar
    $(function () {
        $(window).scroll(function () {
            var scroll = $(window).scrollTop();
            if (scroll < position - 30 && scroll > background){
                $('#navbar').fadeIn('fast');
            } else if (scroll < background) {
                $('#navbar').fadeIn('fast');
            } else if (scroll > position + 30) {
                $('#navbar').fadeOut('fast');
            }
            position = scroll;
        });

    
    });

});
  }(jQuery));

