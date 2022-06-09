// JScript File

    var XMLHttp; 
    var requestURL = 'http://localhost:1455/AjaxComboBox/frmRemote.aspx?SearchText='; 
    var is_ie = (navigator.userAgent.indexOf('MSIE') >= 0) ? 1 : 0; 
    var is_ie5 = (navigator.appVersion.indexOf("MSIE 5.5")!=-1) ? 1 : 0; 
    var is_opera = ((navigator.userAgent.indexOf("Opera6")!=-1)||(navigator.userAgent.indexOf("Opera/6")!=-1)) ? 1 : 0; 
    
    var count=0;
    var is_netscape = (navigator.userAgent.indexOf('Netscape') >= 0) ? 1 : 0; 
    var _Combo;

    function FillCombo(combo,txt)
    {
        _Combo=combo;
        var url = requestURL + txt ;
                       
        XMLHttp = GetXmlHttpObject(stateChangeHandler);
        XMLHttp.open('GET',url,true);
        XMLHttp.send(null);
    }
    
    function GetXmlHttpObject(handler)
    {
         var objXmlHttp = null;
         if (is_ie)
         { 
          var strObjName = (is_ie5) ? 'Microsoft.XMLHTTP' : 'Msxml2.XMLHTTP'; 
          try
          { 
                objXmlHttp = new ActiveXObject(strObjName); 
                objXmlHttp.onreadystatechange = handler; 
           } 
            catch(e)
            { 
               alert('IE detected, but object could not be created. Verify that active scripting and activeX controls are enabled'); 
                return; 
            } 
          } 
         else if (is_opera)
         { 
           alert('Opera detected. The page may not behave as expected.'); 
            return; 
          } 
          else
          { 
            objXmlHttp = new XMLHttpRequest(); 
            objXmlHttp.onload = handler; 
            objXmlHttp.onerror = handler; 
          } 
          return objXmlHttp; 
     } 
     
     function stateChangeHandler() 
    {   
        
        if(XMLHttp.readyState==4 || XMLHttp.readyState == 'complete')
        { 
            var str = XMLHttp.responseText;    
            if (XMLHttp.responseXML.documentElement != null)
            {   
                //alert(_Combo.options[_Combo.selectedIndex].text); 
                FillComboBox(XMLHttp.responseXML.documentElement);
            }
            else
            {
                alert("No Match");
            }                         
         }   
    }
    
    
    
    function FillComboBox(Node)
    {
    
         var NodeList;  
         NodeList = _Combo;
        
         var TextNodeList = Node.getElementsByTagName('Text'); 
         var IdNodeList = Node.getElementsByTagName('Id');     
        
         var textName; 
         var valueName;
          
        for (var count = NodeList.options.length-1; count >-1; count--)
        {
            NodeList.options[count] = null;            
        }        
        
        for (var count = 0; count < TextNodeList.length; count++)
        {
           
            textName = GetInnerText(TextNodeList[count]);  
            valueName = GetInnerText(IdNodeList[count]); 
            TempOption = new Option( textName, valueName,  false, false);
            NodeList.options[NodeList.length] = TempOption; 
            NodeList.size= NodeList.options.length;
            NodeList.style.display='block';
        } 
        if(TextNodeList.length==0)
        {
            NodeList.style.display='none';          
        }
    }

     
    
    function GetInnerText (node)
    {
        return (node.textContent || node.innerText || node.text) ;
    }

    
    
   