 function OpenModelPopup()
    { 
        //document.getElementById ('tdDisplayName').innerHTML='';
        //document.getElementById ('txtName').value='';
        document.getElementById ('ModalPopupDiv').style.visibility='visible';
        document.getElementById ('ModalPopupDiv').style.display='';
        document.getElementById ('ModalPopupDiv').style.top= Math.round ((document.documentElement.clientHeight/2)+ document.documentElement.scrollTop)-100 + 'px';
        document.getElementById ('ModalPopupDiv').style.left='400px';
        
        document.getElementById ('MaskedDiv').style.display='';
        document.getElementById ('MaskedDiv').style.visibility='visible';
        document.getElementById ('MaskedDiv').style.top='0px';
        document.getElementById ('MaskedDiv').style.left='0px';
        document.getElementById ('MaskedDiv').style.width=  document.documentElement.clientWidth + 'px';
        document.getElementById ('MaskedDiv').style.height= document.documentElement.clientHeight+ 'px';
    }
    function CloseModelPopup()
    {        
        document.getElementById ('MaskedDiv').style.display='none';
        document.getElementById ('ModalPopupDiv').style.display='none';
    }

    function OpenViewModelPopup() {
        //document.getElementById ('tdDisplayName').innerHTML='';
        //document.getElementById ('txtName').value='';
        document.getElementById('ViewModalPopupDiv').style.visibility = 'visible';
        document.getElementById('ViewModalPopupDiv').style.display = '';
        document.getElementById('ViewModalPopupDiv').style.top = Math.round((document.documentElement.clientHeight / 2) + document.documentElement.scrollTop) - 100 + 'px';
        document.getElementById('ViewModalPopupDiv').style.left = '400px';

        document.getElementById('ViewMaskedDiv').style.display = '';
        document.getElementById('ViewMaskedDiv').style.visibility = 'visible';
        document.getElementById('ViewMaskedDiv').style.top = '0px';
        document.getElementById('ViewMaskedDiv').style.left = '0px';
        document.getElementById('ViewMaskedDiv').style.width = document.documentElement.clientWidth + 'px';
        document.getElementById('ViewMaskedDiv').style.height = document.documentElement.clientHeight + 'px';
    }
    function CloseViewModelPopup() {
        document.getElementById('ViewMaskedDiv').style.display = 'none';
        document.getElementById('ViewModalPopupDiv').style.display = 'none';
    }
//     function Submit()
//    {
//        if(document.getElementById ('txtName').value!='')
//        {
//            document.getElementById ('MaskedDiv').style.display='none';
//            document.getElementById ('ModalPopupDiv').style.display='none';
//            document.getElementById ('tdDisplayName').innerHTML='<H1> Hi ' + document.getElementById ('txtName').value +' !</H1>';
//        }
//        else 
//        {
//            alert ('Please enter your name');
//        }
//    }