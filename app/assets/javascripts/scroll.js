function EasyPeasyParallax() {
  scrollPos = $(this).scrollTop();
  $('#bannertext').css({
   'margin-top': (scrollPos/4)+"px",
   'opacity': Math.max(1-(scrollPos/300), 0)
  });
}

$(document).ready(function() {
  $(document).on('touchmove', function() {
    EasyPeasyParallax();
  });
  $(window).scroll(function() {
		EasyPeasyParallax();
	});
  
  
  $(".scroll").click(function(event){
    event.preventDefault();
    //calculate destination place
    var dest=0;
    if($(this.hash).offset().top > $(document).height()-$(window).height()){
        dest=$(document).height()-$(window).height();
    }else{
        dest=$(this.hash).offset().top;
    }
    //go to destination
    $('html,body').animate({scrollTop:dest}, 500);
  });

});