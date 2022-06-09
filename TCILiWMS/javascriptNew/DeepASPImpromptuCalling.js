//////////////////////////////////////////////////////////////////////////////////////
//  Developer Name: BHANU PRAKASH INTURI                                        /////
//  Dated: 05/22/2013                                                           /////
//                                                                              /////
//  Browser compatiblity: IE 5-8, FF 5-10.0, safari 6.0, opera, IPad           /////
/////////////////////////////////////////////////////////////////////////////////////

function ShowImpromptu(caption, message, buttons, focus, callBackFunction) 
{
	if(callBackFunction != null && callBackFunction!= "" && callBackFunction!= "null")
	{
        var initials ={html:'',submit: callBackFunction,buttons: buttons,focus: focus};
        //var initials ={init: {html:'Loading...',buttons: { }},ALERT00: {html:'',submit: callBackFunction,buttons: buttons,focus: focus}}
    }
    else
    {
         var initials ={html:'',buttons: buttons,focus: focus}
       //var initials = {init: {html:'',buttons: { }},ALERT00: {html:'',buttons: buttons,focus: focus}}
    }
    var captionDIV = $('<div id="ajaxspinner"></div><div id="promptcaption"></div>');
//    var captionDIV = $('<div id="ajaxspinner"></div><div id="promptcaption"></div>');
    $.prompt(message, initials);    
    captionDIV.prependTo('#jqi');
    $("#promptcaption").html(caption);
    
	///If you are using the ajax toolkit modalpopup then uncomment it.
	//$("#jqibox").css('position','absolute');
    //$("#jqibox").css('z-index','10002');	
	
	return false;
}


function ShowCustomPromptAlert(caption, message, callBackFunction,width) 
{
	
	var state = 'ALR000';
	$jqi = $('#jqi');
	$jqi.width(width);
	$jqi.css({
		marginLeft: (($jqi.outerWidth()/2)*-1)
	});
	$.prompt.getStateContent(state).find('.jqimessage').html(message);
	
	if (caption.length > 0) 
	{
		$("#statecaption").html(caption);		
	}	
	$.prompt.goToState(state);
	
	///If you are using the ajax toolkit modalpopup then uncomment it.
	//$("#jqibox").css('position','absolute');
    //$("#jqibox").css('z-index','10002');	
	return false;	
}

function show()
{
    // set the placement and width of the dialog box
	$jqi = $('#jqi');
	$jqi.width(widepx);
	$jqi.css({
		marginLeft: (($jqi.outerWidth()/2)*-1)
	});
	
	$.prompt.getStateContent(state).find('.jqimessage').html(msgtext1);
	// if caption contains a paren, assume the message id has been included in the text of the caption, such as "...(ICL014)"		
	$("#statecaption").html(caption);
	
	var currstate
	currstate = $.prompt.getCurrentStateName()
	if (currstate != state) 
	{
		$.prompt.goToState(state);
	}
	return false;
}