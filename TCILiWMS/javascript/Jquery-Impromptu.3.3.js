/*
* jQuery Impromptu
* By: Trent Richardson [http://trentrichardson.com]
* Version 3.3
* Last Modified: 02/01/2012
*
* Copyright 2011 Trent Richardson
* Dual licensed under the MIT and GPL licenses.
* http://trentrichardson.com/Impromptu/GPL-LICENSE.txt
* http://trentrichardson.com/Impromptu/MIT-LICENSE.txt
*
*/
 
(function($) {
$.prompt = function(message, options) {
$.prompt.options = $.extend({},$.prompt.defaults,options);
$.prompt.currentPrefix = $.prompt.options.prefix;
$.prompt.currentStateName = "";

var ie6 = ($.browser.msie && $.browser.version < 7);
var $body = $(document.body);
var $window = $(window);

$.prompt.options.classes = $.trim($.prompt.options.classes);
if($.prompt.options.classes != '')
$.prompt.options.classes = ' '+ $.prompt.options.classes;

//build the box and fade
var msgbox = '<div class="'+ $.prompt.options.prefix +'box'+ $.prompt.options.classes +'" id="'+ $.prompt.options.prefix +'box">';
if($.prompt.options.useiframe && (($('object, applet').length > 0) || ie6)) {
msgbox += '<iframe src="javascript:false;" style="display:block;position:absolute;z-index:-1;" class="'+ $.prompt.options.prefix +'fade" id="'+ $.prompt.options.prefix +'fade"></iframe>';
} else {
if(ie6) {
$('select').css('visibility','hidden');
}
msgbox +='<div class="'+ $.prompt.options.prefix +'fade" id="'+ $.prompt.options.prefix +'fade"></div>';
}
msgbox += '<div class="'+ $.prompt.options.prefix +'" id="'+ $.prompt.options.prefix +'"><div class="'+ $.prompt.options.prefix +'container"><div class="';
msgbox += $.prompt.options.prefix +'close">X</div><div id="'+ $.prompt.options.prefix +'states"></div>';
msgbox += '</div></div></div>';

$.prompt.jqib = $(msgbox).appendTo($body);
$.prompt.jqi = $.prompt.jqib.children('#'+ $.prompt.options.prefix);
$.prompt.jqif = $.prompt.jqib.children('#'+ $.prompt.options.prefix +'fade');

//if a string was passed, convert to a single state
if(message.constructor == String){
message = {
state0: {
html: message,
buttons: $.prompt.options.buttons,
focus: $.prompt.options.focus,
submit: $.prompt.options.submit
}
};
}

//build the states
var states = "";

$.each(message,function(statename,stateobj){
stateobj = $.extend({},$.prompt.defaults.state,stateobj);
message[statename] = stateobj;

var arrow = "";
if(stateobj.position.arrow !== null)
arrow = '<div class="'+ $.prompt.options.prefix + 'arrow '+ $.prompt.options.prefix + 'arrow'+ stateobj.position.arrow +'"></div>';

states += '<div id="'+ $.prompt.options.prefix +'_state_'+ statename +'" class="'+ $.prompt.options.prefix + '_state" style="display:none;">'+ arrow +'<div class="'+ $.prompt.options.prefix +'message">' + stateobj.html +'</div><div class="'+ $.prompt.options.prefix +'buttons">';

$.each(stateobj.buttons, function(k, v){
if(typeof v == 'object')
states += '<button name="' + $.prompt.options.prefix + '_' + statename + '_button' + v.title.replace(/[^a-z0-9]+/gi,'') + '" id="' + $.prompt.options.prefix + '_' + statename + '_button' + v.title.replace(/[^a-z0-9]+/gi,'') + '" value="' + v.value + '">' + v.title + '</button>';
else states += '<button name="' + $.prompt.options.prefix + '_' + statename + '_button' + k + '" id="' + $.prompt.options.prefix + '_' + statename + '_button' + k + '" value="' + v + '">' + k + '</button>';
});
states += '</div></div>';
});

//insert the states...
$.prompt.states = message;
$.prompt.jqi.find('#'+ $.prompt.options.prefix +'states').html(states).children('.'+ $.prompt.options.prefix +'_state:first').css('display','block');
$.prompt.jqi.find('.'+ $.prompt.options.prefix +'buttons:empty').css('display','none');

//Events
$.each(message,function(statename,stateobj){
var $state = $.prompt.jqi.find('#'+ $.prompt.options.prefix +'_state_'+ statename);

if($.prompt.currentStateName === "")
$.prompt.currentStateName = statename;

$state.children('.'+ $.prompt.options.prefix +'buttons').children('button').click(function(){
var msg = $state.children('.'+ $.prompt.options.prefix +'message');
var clicked = stateobj.buttons[$(this).text()];
if(clicked == undefined){
for(var i in stateobj.buttons)
if(stateobj.buttons[i].title == $(this).text())
clicked = stateobj.buttons[i].value;
}

if(typeof clicked == 'object')
clicked = clicked.value;
var forminputs = {};

//collect all form element values from all states
$.each($.prompt.jqi.find('#'+ $.prompt.options.prefix +'states :input').serializeArray(),function(i,obj){
if (forminputs[obj.name] === undefined) {
forminputs[obj.name] = obj.value;
} else if (typeof forminputs[obj.name] == Array || typeof forminputs[obj.name] == 'object') {
forminputs[obj.name].push(obj.value);
} else {
forminputs[obj.name] = [forminputs[obj.name],obj.value];
}
});

var close = stateobj.submit(clicked,msg,forminputs);
if(close === undefined || close) {
removePrompt(true,clicked,msg,forminputs);
}
});
$state.find('.'+ $.prompt.options.prefix +'buttons button:eq('+ stateobj.focus +')').addClass($.prompt.options.prefix +'defaultbutton');

});

var fadeClicked = function(){
if($.prompt.options.persistent){
var offset = ($.prompt.options.top.toString().indexOf('%') >= 0? ($window.height()*(parseInt($.prompt.options.top,10)/100)) : parseInt($.prompt.options.top,10)),
top = parseInt($.prompt.jqi.css('top').replace('px',''),10) - offset;

//$window.scrollTop(top);
$('html,body').animate({ scrollTop: top }, 'fast', function(){
var i = 0;
$.prompt.jqib.addClass($.prompt.options.prefix +'warning');
var intervalid = setInterval(function(){
$.prompt.jqib.toggleClass($.prompt.options.prefix +'warning');
if(i++ > 1){
clearInterval(intervalid);
$.prompt.jqib.removeClass($.prompt.options.prefix +'warning');
}
}, 100);
});
}
else {
removePrompt();
}
};

var keyPressEventHandler = function(e){
var key = (window.event) ? event.keyCode : e.keyCode; // MSIE or Firefox?

//escape key closes
if(key==27) {
fadeClicked();
}

//constrain tabs
if (key == 9){
var $inputels = $(':input:enabled:visible',$.prompt.jqib);
var fwd = !e.shiftKey && e.target == $inputels[$inputels.length-1];
var back = e.shiftKey && e.target == $inputels[0];
if (fwd || back) {
setTimeout(function(){
if (!$inputels)
return;
var el = $inputels[back===true ? $inputels.length-1 : 0];

if (el)
el.focus();
},10);
return false;
}
}
};

var removePrompt = function(callCallback, clicked, msg, formvals){
$.prompt.jqi.remove();
$window.unbind('resize',$.prompt.position);
$.prompt.jqif.fadeOut($.prompt.options.overlayspeed,function(){
$.prompt.jqif.unbind('click',fadeClicked);
$.prompt.jqif.remove();
if(callCallback) {
$.prompt.options.callback(clicked,msg,formvals);
}
$.prompt.jqib.unbind('keypress',keyPressEventHandler);
$.prompt.jqib.remove();
if(ie6 && !$.prompt.options.useiframe) {
$('select').css('visibility','visible');
}
});
};

$.prompt.position();
$.prompt.style();

$.prompt.jqif.click(fadeClicked);
$window.resize($.prompt.position);
$.prompt.jqib.bind("keydown keypress",keyPressEventHandler);
$.prompt.jqi.find('.'+ $.prompt.options.prefix +'close').click(removePrompt);

//Show it
$.prompt.jqif.fadeIn($.prompt.options.overlayspeed);
$.prompt.jqi[$.prompt.options.show]($.prompt.options.promptspeed,$.prompt.options.loaded);
$.prompt.jqi.find('#'+ $.prompt.options.prefix +'states .'+ $.prompt.options.prefix +'_state:first .'+ $.prompt.options.prefix +'defaultbutton').focus();

if($.prompt.options.timeout > 0)
setTimeout($.prompt.close,$.prompt.options.timeout);

return $.prompt.jqib;
};

$.prompt.defaults = {
prefix:'jqi',
classes: '',
buttons: {
Ok: true
},
loaded: function(){},
submit: function(){
return true;
},
callback: function(){},
opacity: 0.6,
zIndex: 999,
overlayspeed: 'slow',
promptspeed: 'fast',
    show: 'fadeIn',//'promptDropIn',
focus: 0,
useiframe: false,
top: '40%', // CHANGED FROM 15% TO 40% TO CENTER THE SCREEN BY BHANU PRAKASH INTURI ON 22-MAY-2013
persistent: true,
timeout: 0,
state: {
html: '',
buttons: {
Ok: true
},
focus: 0,
position: {
container: null,
x: null,
y: null,
arrow: null
},
submit: function(){
return true;
}
}
};

$.prompt.currentPrefix = $.prompt.defaults.prefix;

$.prompt.currentStateName = "";

$.prompt.setDefaults = function(o) {
$.prompt.defaults = $.extend({}, $.prompt.defaults, o);
};

$.prompt.setStateDefaults = function(o) {
$.prompt.defaults.state = $.extend({}, $.prompt.defaults.state, o);
};

$.prompt.position = function(){
var $window = $(window),
bodyHeight = $(document.body).outerHeight(true),
windowHeight = $(window).height(),
documentHeight = $(document).height(),
height = bodyHeight > windowHeight ? bodyHeight : windowHeight,
top = parseInt($window.scrollTop(),10) + ($.prompt.options.top.toString().indexOf('%') >= 0? (windowHeight*(parseInt($.prompt.options.top,10)/100)) : parseInt($.prompt.options.top,10));
height = height > documentHeight? height : documentHeight;

$.prompt.jqib.css({
position: "absolute",
height: height,
width: "100%",
top: 0,
left: 0,
right: 0,
bottom: 0
});
$.prompt.jqif.css({
position: "absolute",
height: height,
width: "100%",
top: 0,
left: 0,
right: 0,
bottom: 0
});

if($.prompt.states[$.prompt.currentStateName].position.container !== null){
var pos = $.prompt.states[$.prompt.currentStateName].position,
offset = $(pos.container).offset();

$.prompt.jqi.css({
position: "absolute"
});
$.prompt.jqi.animate({
top: offset.top + pos.y,
left: offset.left + pos.x,
marginLeft: 0,
width: (pos.width !== undefined)? pos.width : null
});
top = (offset.top + pos.y) - ($.prompt.options.top.toString().indexOf('%') >= 0? (windowHeight*(parseInt($.prompt.options.top,10)/100)) : parseInt($.prompt.options.top,10));
$('html,body').animate({ scrollTop: top }, 'slow', 'swing', function(){});
}
else{
$.prompt.jqi.css({
position: "absolute",
top: top,
left: $window.width()/2,
marginLeft: (($.prompt.jqi.outerWidth()/2)*-1)
});
}

};

$.prompt.style = function(){
$.prompt.jqif.css({
zIndex: $.prompt.options.zIndex,
display: "none",
opacity: $.prompt.options.opacity
});
$.prompt.jqi.css({
zIndex: $.prompt.options.zIndex+1,
display: "none"
});
$.prompt.jqib.css({
zIndex: $.prompt.options.zIndex
});
};

$.prompt.getStateContent = function(state) {
return $('#'+ $.prompt.currentPrefix +'_state_'+ state);
};

$.prompt.getCurrentState = function() {
return $('.'+ $.prompt.currentPrefix +'_state:visible');
};

$.prompt.getCurrentStateName = function() {
var stateid = $.prompt.getCurrentState().attr('id');

return stateid.replace($.prompt.currentPrefix +'_state_','');
};

$.prompt.goToState = function(state, callback) {
$.prompt.currentStateName = state;

$('.'+ $.prompt.currentPrefix +'_state').slideUp('slow')
.find('.'+ $.prompt.currentPrefix +'arrow').fadeToggle();

$('#'+ $.prompt.currentPrefix +'_state_'+ state).slideDown('slow',function(){
$(this).find('.'+ $.prompt.currentPrefix +'defaultbutton').focus()
.find('.'+ $.prompt.currentPrefix +'arrow').fadeToggle('slow');
if (typeof callback == 'function')
callback();
});

$.prompt.position();
};

$.prompt.nextState = function(callback) {
var $next = $('#'+ $.prompt.currentPrefix +'_state_'+ $.prompt.currentStateName).next();
$.prompt.goToState( $next.attr('id').replace($.prompt.currentPrefix +'_state_','') );
};

$.prompt.prevState = function(callback) {
var $prev = $('#'+ $.prompt.currentPrefix +'_state_'+ $.prompt.currentStateName).prev();
$.prompt.goToState( $prev.attr('id').replace($.prompt.currentPrefix +'_state_','') );
};

$.prompt.close = function() {
$('#'+ $.prompt.currentPrefix +'box').fadeOut('fast',function(){
         $(this).remove();
});
};

$.fn.extend({
prompt: function(options){
if(options == undefined)
options = {};
if(options.withDataAndEvents == undefined)
options.withDataAndEvents = false;

$.prompt($(this).clone(options.withDataAndEvents).html(),options);
},
promptDropIn: function(speed, callback){
var $t = $(this);

if($t.css("display") == "none"){
var eltop = $t.css('top');
$t.css({ top: $(window).scrollTop(), display: 'block' }).animate({ top: eltop },speed,'swing',callback);
}
}

});

})(jQuery);






