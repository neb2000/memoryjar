$ ->
  $(window).scroll ->
    scrollPos = $(this).scrollTop()  unless "ontouchstart" of window
    $("#banner-text").css "margin-top": (scrollPos / 5) + "px"
    $("#banner").css opacity: Math.max(1 - (scrollPos / 400), 0)

  $(".scroll").click (e) ->
    $("html, body").animate
      scrollTop: $($.attr(this, "href")).offset().top
    , 500
    false