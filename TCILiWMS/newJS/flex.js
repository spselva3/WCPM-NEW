// Flex Admin Custom JavaScript Document

//Sidebar Toggle
$("#sidebar-toggle").click(function (e) {
    e.preventDefault();
    $(".navbar-side").toggleClass("collapsed");
    $("#page-wrapper").toggleClass("collapsed");
});

//Portlet Icon Toggle
$(".portlet-widgets .fa-chevron-down, .portlet-widgets .fa-chevron-up").click(function () {
    $(this).toggleClass("fa-chevron-down fa-chevron-up");
});

//Portlet Refresh Icon
(function ($) {

    $.fn.extend({

        addTemporaryClass: function (className, duration) {
            var elements = this;
            setTimeout(function () {
                elements.removeClass(className);
            }, duration);

            return this.each(function () {
                $(this).addClass(className);
            });
        }
    });

})(jQuery);

$(".portlet-widgets .fa-refresh").click(function () {
    $(this).addTemporaryClass("fa-spin fa-spinner", 2000);
});

//Slim Scroll
$(function () {
    $('#messageScroll, #alertScroll, #taskScroll').slimScroll({
        height: '200px',
        alwaysVisible: true,
        disableFadeOut: true,
        touchScrollStep: 50
    });
});

//Google Analytics Tracking (Not Included in Download)
  (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
  (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
  m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
  })(window,document,'script','//www.google-analytics.com/analytics.js','ga');

  ga('create', 'UA-38417733-22', 'startbootstrap.com');
  ga('send', 'pageview');
