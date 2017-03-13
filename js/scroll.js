(function ($) {
  $(document).ready(function(){

    var background = $('.scroll')[0].scrollHeight;

    /* affix sidebar */
    $('#featured-nav').affix({
      offset: {
        top: function () {
            return background;
        }
      }
    });

    /* activate scrollspy menu */
    $('body').scrollspy({
      target: '#sidebar',
      offset: 90
    });

    // Refresh scrollspy
    $('[data-spy="scroll"]').each(function(){
        var $spy = $(this).scrollspy('refresh');
    }); 

    /* smooth scrolling sections */
    $('a[href*=\\#]:not([href=\\#])').click(function() {
        if (location.pathname.replace(/^\//,'') == this.pathname.replace(/^\//,'') && location.hostname == this.hostname) {
          var target = $(this.hash);
          target = target.length ? target : $('[name=' + this.hash.slice(1) +']');
          if (target.length) {
            $('html,body').animate({
              scrollTop: target.offset().top - 70
            }, 1000);
            return false;
          }
        }
    });

});
  }(jQuery));

