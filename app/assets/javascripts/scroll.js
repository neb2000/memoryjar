function EasyPeasyParallax() {
  scrollPos = $(this).scrollTop();
  $('#bannertext').css({
   'margin-top': (scrollPos/5)+"px",
  });
  $('#banner').css({
    'opacity': Math.max(1-(scrollPos/400), 0)
  });
}

$(document).ready(function() {
  $(window).scroll(function() {
    if (!('ontouchstart' in window))
		  EasyPeasyParallax();
	});
  
  $(".scroll").click(function(event){
    $('html, body').animate({
        scrollTop: $( $.attr(this, 'href') ).offset().top
    }, 500);
    return false;
  });

});