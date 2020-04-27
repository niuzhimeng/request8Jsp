//sinochem js start by ssu 2017-1-9 00:42:522
/**
 * {js修改字段的显示属性}
 * @param actionfieldid  字段id  eg:7890
 * @param showattrvalue  -1/1/2/3=没有设置联动，恢复原值和恢复原显示属性/编辑/必填/只读
 * @param isdetail      0 / 1 = 主表 / 明细表
 * @param rownum        明细表字段序列  0~n
 */
function changeFieldShowattr(actionfieldid,showattrvalue,isdetail,rownum){
    setTimeout(function(){
    	_changeFieldShowattr(actionfieldid,showattrvalue,isdetail,rownum);
        }, 1000);
}  

function _changeFieldShowattr(actionfieldid,showattrvalue,isdetail,rownum){
	
	
	//初始化动作准备  构造原始的操作字段的显示属性dom元素 放入操作字段之后-001
	if(isdetail=="0"){//主表
		if (jQuery("#oldfieldview"+actionfieldid).length > 0 ) {
			
		}else{
			var oldfieldview_html = "<input type=\"hidden\" id=\"oldfieldview"+actionfieldid+"\" name=\"oldfieldview"+actionfieldid+"\" _readonly=\"0\" value=\"2\">";
			jQuery("#field"+actionfieldid).after(oldfieldview_html);
		}
	}else{
		if (jQuery("#oldfieldview"+actionfieldid+"_"+rownum).length > 0 ) {
			
		}else{
			var oldfieldview_html = "<input type=\"hidden\" id=\"oldfieldview"+actionfieldid+"_"+rownum+"\" name=\"oldfieldview"+actionfieldid+"_"+rownum+"\" _readonly=\"0\" value=\"2\">";
			jQuery("#field"+actionfieldid+"_"+rownum).after(oldfieldview_html);
		}
	}
	
	//构造操作的字符串-002
	var returnvalues = actionfieldid+"_"+isdetail+"$"+showattrvalue;
	
	
	//执行主逻辑-003
	len = document.forms[0].elements.length;
	if(window.console) { console.log("len = "+len)};
	try{
	if(returnvalues!=""){
        if(window.console) { console.log("rownum = "+rownum+" isdetail="+isdetail+" returnvalues = "+returnvalues);}
        var fieldarray=returnvalues.split("&");
    
        for(n=0;n<fieldarray.length;n++){
            var fieldattrs=fieldarray[n].split("$");
            var fieldids=fieldattrs[0];
            var fieldattr=fieldattrs[1];
            var fieldidarray=fieldids.split(",");
            if(fieldattr==-1){ // 没有设置联动，恢复原值和恢复原显示属性
                for(i=0;i<len;i++){
                    for(j=0;j<fieldidarray.length;j++){
                        var tfieldidarray=fieldidarray[j].split("_");
                        if (tfieldidarray[1]==isdetail){
                            if(rownum>-1){  // 明细字段
                                if(document.forms[0].elements[i].name=='field'+tfieldidarray[0]+"_"+rownum&&$GetEle('oldfieldview'+tfieldidarray[0]+"_"+rownum)){
                                    isedit=$GetEle('oldfieldview'+tfieldidarray[0]+"_"+rownum).value;
                                    if($GetEle('field'+tfieldidarray[0]+"_"+rownum+"span")){
                                        var checkstr_=$GetEle("needcheck").value+",";
                                        
                                        if(isedit==3){
                                   
                                            document.forms[0].elements[i].setAttribute('viewtype','1');
                                            if(document.forms[0].elements[i].value==""&&$GetEle('field'+tfieldidarray[0]+"_"+rownum+"span").innerHTML.indexOf("/images/BacoError_wev8.gif")<=0) $GetEle('field'+tfieldidarray[0]+"_"+rownum+"span").innerHTML="<IMG src='/images/BacoError_wev8.gif' align=absMiddle>";
                                            
                                            try{
                                                if(document.forms[0].elements[i].value==""&&$GetEle('field_lable'+tfieldidarray[0]+"_"+rownum+"span").innerHTML.indexOf("/images/BacoError_wev8.gif")<=0){
                                                    $GetEle('field_lable'+tfieldidarray[0]+"_"+rownum+"span").innerHTML="<IMG src='/images/BacoError_wev8.gif' align=absMiddle>";
                                                    $GetEle('field'+tfieldidarray[0]+"_"+rownum+"span").innerHTML="";
                                                }
                                            }catch(e){}
                                            if(!!$GetEle('field'+tfieldidarray[0]+"_"+rownum+"spanimg")){
                                                if(document.forms[0].elements[i].value==""){
                                                    $GetEle('field'+tfieldidarray[0]+"_"+rownum+"spanimg").innerHTML="<IMG src='/images/BacoError_wev8.gif' align=absMiddle>";
                                                    $GetEle('field'+tfieldidarray[0]+"_"+rownum+"span").innerHTML="";
                                                }
                                            }
                                            //多行文本带编辑器
                                            try{
                                                if(jQuery("#field"+'field'+tfieldidarray[0]+"_"+rownum).find("iframe").length > 0){
                                                      if(!!UE.getEditor('field'+tfieldidarray[0]+"_"+rownum)){
                                                         var content = UE.getEditor('field'+tfieldidarray[0]+"_"+rownum).getContent();
                                                         if(jQuery.trim(content)==""){
                                                            $GetEle('field'+tfieldidarray[0]+"_"+rownum+"span").innerHTML="<IMG src='/images/BacoError_wev8.gif' align=absMiddle>";
                                                         }
                                                      }
                                                }
                                            }catch(e){
                                                //alert(e);
                                            }
                                            setFieldReadOnly(tfieldidarray[0]+"_"+rownum,false,fieldattr);
                                            if(checkstr_.indexOf("field"+tfieldidarray[0]+"_"+rownum+",")<0) $GetEle("needcheck").value=checkstr_+"field"+tfieldidarray[0]+"_"+rownum;
                                        }
                                        if(isedit==2){
                                            
                                            document.forms[0].elements[i].setAttribute('viewtype','0');
                                            if($GetEle('field'+tfieldidarray[0]+"_"+rownum+"span").innerHTML.indexOf("/images/BacoError_wev8.gif")>-1) $GetEle('field'+tfieldidarray[0]+"_"+rownum+"span").innerHTML="";
                                            try{
                                                if($GetEle('field_lable'+tfieldidarray[0]+"_"+rownum+"span").innerHTML.indexOf("/images/BacoError_wev8.gif")>-1){
                                                    $GetEle('field_lable'+tfieldidarray[0]+"_"+rownum+"span").innerHTML="";
                                                }
                                            }catch(e){}
                                            if(!!$GetEle('field'+tfieldidarray[0]+"_"+rownum+"spanimg")){
                                                if(document.forms[0].elements[i].value==""){
                                                    $GetEle('field'+tfieldidarray[0]+"_"+rownum+"spanimg").innerHTML="";
                                                    $GetEle('field'+tfieldidarray[0]+"_"+rownum+"span").innerHTML="";
                                                }
                                            }
                                            
                                            setFieldReadOnly(tfieldidarray[0]+"_"+rownum ,false,fieldattr);
                                            $GetEle("needcheck").value=checkstr_.replace(new RegExp("field"+tfieldidarray[0]+"_"+rownum+",","g"),"");
                                        }
                                        
                                        
                                    }else{
                                        
                                        if($GetEle('field_'+tfieldidarray[0]+"_"+rownum+"span")){

                                            if(document.getElementById("fsUploadProgress"+tfieldidarray[0]+"_"+rownum)){
                                                clearSWFUploadRequired(tfieldidarray[0]+"_"+rownum);//add by td78113
                                                jQuery("#field"+tfieldidarray[0]+"_"+rownum+"_remind").attr("title","");
                                            }
                                            jQuery("#oldfieldview"+tfieldidarray[0]+"_"+rownum).attr("_readonly","1");
                                            if(jQuery("#oldfieldview"+tfieldidarray[0]+"_"+rownum).length==0){
                                                jQuery("input[name='oldfieldview"+tfieldidarray[0]+"_"+rownum+"']").attr("_readonly","1");
                                                jQuery("input[name='oldfieldview"+tfieldidarray[0]+"_"+rownum+"']").attr("id","oldfieldview"+tfieldidarray[0]+"_"+rownum+"");
                                            }
                                            
                                            //判断附件字段
                                            /////////////////
                                            if(isedit==3) {
                                                 if($GetEle('field_'+tfieldidarray[0]+"_"+rownum+"span")){
                                                     setFieldReadOnly(tfieldidarray[0]+"_"+rownum+"",false,fieldattr);
                                                     addSWFUploadRequired(tfieldidarray[0]+"_"+rownum);//add by td78113
                                                     jQuery("#field"+tfieldidarray[0]+"_"+rownum+"_remind").attr("title",SystemEnv.getHtmlNoteName(4062));
                                                     
                                                     uploadAttachmentDisd(tfieldidarray[0]+"_"+rownum);
                                                     jQuery(".progressCancel1").attr("class","progressCancel");
                                                     jQuery('#field_'+tfieldidarray[0]+"_"+rownum+"span").css("display","inline-block");
                                                     if(isEmptyfsUpdaload(tfieldidarray[0]+"_"+rownum)){
                                                         jQuery("#field_"+tfieldidarray[0]+"_"+rownum+"span").css("display","inline-block");
                                                         $GetEle("field_"+tfieldidarray[0]+"_"+rownum+"span").innerHTML=SystemEnv.getHtmlNoteName(97);
                                                     }else{
                                                         $GetEle("field_"+tfieldidarray[0]+"_"+rownum+"span").innerHTML="";
                                                     }
                                                     
                                                     var checkstr_=$GetEle("needcheck").value+",";
                                                     if(checkstr_.indexOf("field"+tfieldidarray[0]+"_"+rownum+",")<0) $GetEle("needcheck").value=checkstr_+"field"+tfieldidarray[0]+"_"+rownum;
                                                     jQuery("#field"+tfieldidarray[0]+"_"+rownum).attr("viewtype","1");
                                                 }
                                             }
                                            if(isedit==2) {
                                                if($GetEle('field_'+tfieldidarray[0]+"_"+rownum+"span")){
                                                    setFieldReadOnly(tfieldidarray[0]+"_"+rownum+"",false,fieldattr);
                                                    jQuery("#field_"+tfieldidarray[0]+"_"+rownum+"span").css("display","none");
                                                    jQuery("#field"+tfieldidarray[0]+"_"+rownum+"_remind").attr("title",SystemEnv.getHtmlNoteName(4062));
                                                    //jQuery("#field_"+tfieldidarray[0]+"span").innerHTML("");
                                                    if(document.getElementById("fsUploadProgress"+tfieldidarray[0]+"_"+rownum)){
                                                        clearSWFUploadRequired(tfieldidarray[0]+"_"+rownum);//add by td78113
                                                        uploadAttachmentDisd(tfieldidarray[0]+"_"+rownum);
                                                    }
                                                    try{
                                                        var checkstr__=$GetEle("needcheck").value+",";
                                                        document.all("needcheck").value=checkstr__.replace(new RegExp("field"+tfieldidarray[0]+"_"+rownum+",","g"),"");
                                                        //document.forms[0].elements[i].viewtype="0";
                                                        jQuery("#field"+tfieldidarray[0]+"_"+rownum).attr("viewtype","0");
                                                    }catch(e){
                                                    }
                                                }
                                            }
                                            /////////////////
                                            
                                        }
       
                                        if(document.all('field'+tfieldidarray[0]+"_"+rownum)!=null && document.all('field'+tfieldidarray[0]+"_"+rownum).type=="checkbox"){//check框
                                            document.forms[0].elements[i].setAttribute('viewtype','0');
                                            if(isedit==3){
                                                document.forms[0].elements[i].setAttribute('viewtype','1');
                                            }
                                            setFieldReadOnly(tfieldidarray[0]+"_"+rownum ,false,fieldattr);
                                            document.all('field'+tfieldidarray[0]+"_"+rownum).onclick=null;
                                        }
                                    }
                                }
                            }else{     // 主字段
                      
                                if(document.forms[0].elements[i].name=='field'+tfieldidarray[0]&&$GetEle('oldfieldview'+tfieldidarray[0])){
                                    isedit=$GetEle('oldfieldview'+tfieldidarray[0]).value;
                                    if($GetEle('field'+tfieldidarray[0]+"span")){
                                        var checkstr_=$GetEle("needcheck").value+",";
                                        if(document.getElementById("fsUploadProgress"+tfieldidarray[0])){
                                            clearSWFUploadRequired(tfieldidarray[0]);//add by td78113
                                            uploadAttachmentDisd(tfieldidarray[0]);
                                        }
                                        if(isedit==3) {
                                            document.forms[0].elements[i].setAttribute('viewtype','1');
                                            if(document.forms[0].elements[i].value=="") {
                                                $GetEle('field'+tfieldidarray[0]+"span").innerHTML="<IMG src='/images/BacoError_wev8.gif' align=absMiddle>";
                                                if(jQuery("#field"+tfieldidarray[0]+"__").length>0){
                                                    $GetEle('field'+tfieldidarray[0]+"span").innerHTML = "";
                                                    $GetEle('field'+tfieldidarray[0]+"spanimg").innerHTML="<IMG src='/images/BacoError_wev8.gif' align=absMiddle>";
                                                }
                                                jQuery('#field_'+tfieldidarray[0]+"span").css("display","inline-block");
                                            }
                                            //判断附件字段
                                            if(document.getElementById("fsUploadProgress"+tfieldidarray[0])){
                                                addSWFUploadRequired(tfieldidarray[0]);//add by td78113
                                                if(document.getElementById("fsUploadProgress"+tfieldidarray[0]).children.length>0){
                                                    if(isEmptyfsUpdaload(tfieldidarray[0]))
                                                        //document.all('field'+tfieldidarray[0]+"span").innerHTML="";
                                                        $GetEle("field_"+tfieldidarray[0]+"span").innerHTML="";
                                                }
                                                
                                                uploadAttachmentDisd(tfieldidarray[0]);
                                            }
                                            
                                            try{
                                                if(document.forms[0].elements[i].value==""){
                                                    $GetEle('field_lable'+tfieldidarray[0]+"span").innerHTML="<IMG src='/images/BacoError_wev8.gif' align=absMiddle>";
                                                    $GetEle('field'+tfieldidarray[0]+"span").innerHTML="";
                                                    jQuery('#field_'+tfieldidarray[0]+"span").css("display","none");
                                                }
                                            }catch(e){}
                                            //多行文本 带编辑器
                                            if(jQuery("#field"+tfieldidarray[0]).find("iframe").length > 0){
                                                  if(!!UE.getEditor('field'+tfieldidarray[0])){
                                                     var content = UE.getEditor('field'+tfieldidarray[0]).getContent();
                                                     if(jQuery.trim(content)==""){
                                                        $GetEle('field'+tfieldidarray[0]+"span").innerHTML="<IMG src='/images/BacoError_wev8.gif' align=absMiddle>";
                                                     }
                                                  }
                                            }
                                            setFieldReadOnly(tfieldidarray[0]+"",false,fieldattr);
                                            if(checkstr_.indexOf("field"+tfieldidarray[0]+",")<0) $GetEle("needcheck").value=checkstr_+"field"+tfieldidarray[0];
                                        }
                                        if(isedit==2) {
                                            document.forms[0].elements[i].setAttribute('viewtype','0');
                                            if($GetEle('field'+tfieldidarray[0]+"span") && $GetEle('field'+tfieldidarray[0]+"span").innerHTML.indexOf("/images/BacoError_wev8.gif")>-1) $GetEle('field'+tfieldidarray[0]+"span").innerHTML="";
                                            if($GetEle('field'+tfieldidarray[0]+"spanimg") && $GetEle('field'+tfieldidarray[0]+"spanimg").innerHTML.indexOf("/images/BacoError_wev8.gif")>-1) $GetEle('field'+tfieldidarray[0]+"spanimg").innerHTML="";
                                            
                                            try{
                                                if($GetEle('field_lable'+tfieldidarray[0]+"span").innerHTML.indexOf("/images/BacoError_wev8.gif")>-1){
                                                    $GetEle('field_lable'+tfieldidarray[0]+"span").innerHTML="";
                                                }
                                                jQuery('#field_'+tfieldidarray[0]+"span").css("display","none");
                                            }catch(e){}
                                            if(jQuery("#field"+tfieldidarray[0]).find("iframe").length > 0){
                                                  if(!!UE.getEditor('field'+tfieldidarray[0])){
                                                     UE.getEditor('field'+tfieldidarray[0]).setEnabled();
                                                  }
                                            }
                                            
                                            setFieldReadOnly(tfieldidarray[0]+"",false,fieldattr);
                                            $GetEle("needcheck").value=checkstr_.replace(new RegExp("field"+tfieldidarray[0]+",","g"),"");
                                        }
                                    }else if($GetEle('field_'+tfieldidarray[0]+"span")){//判断附件字段
                                        jQuery("#oldfieldview"+tfieldidarray[0]).attr("_readonly","1");
                                        if(jQuery("#oldfieldview"+tfieldidarray[0]).length==0){
                                            jQuery("input[name='oldfieldview"+tfieldidarray[0]+"']").attr("_readonly","1");
                                            jQuery("input[name='oldfieldview"+tfieldidarray[0]+"']").attr("id","oldfieldview"+tfieldidarray[0]+"");
                                        }
                                        /////////////////
                                        if(isedit==3) {
                                             if($GetEle('field_'+tfieldidarray[0]+"span")){
                                                 setFieldReadOnly(tfieldidarray[0]+"",false,fieldattr);
                                                 addSWFUploadRequired(tfieldidarray[0]);//add by td78113
                                                 jQuery(".progressCancel1").attr("class","progressCancel");
                                                 jQuery('#field_'+tfieldidarray[0]+"span").css("display","inline-block");
                                                 if(isEmptyfsUpdaload(tfieldidarray[0])){
                                                     jQuery("#field_"+tfieldidarray[0]+"span").css("display","inline-block");
                                                     $GetEle("field_"+tfieldidarray[0]+"span").innerHTML=SystemEnv.getHtmlNoteName(97);
                                                 }else{
                                                     $GetEle("field_"+tfieldidarray[0]+"span").innerHTML="";
                                                 }
                                                 var checkstr_=$GetEle("needcheck").value+",";
                                                 if(checkstr_.indexOf("field"+tfieldidarray[0]+",")<0) $GetEle("needcheck").value=checkstr_+"field"+tfieldidarray[0];
                                                 jQuery("#field"+tfieldidarray[0]).attr("viewtype","1");
                                                 
                                                 uploadAttachmentDisd(tfieldidarray[0]);
                                             }
                                         }
                                        if(isedit==2) {
                                            if($GetEle('field_'+tfieldidarray[0]+"span")){
                                                setFieldReadOnly(tfieldidarray[0]+"",false,fieldattr);
                                                jQuery("#field_"+tfieldidarray[0]+"span").css("display","none");
                                                //jQuery("#field_"+tfieldidarray[0]+"span").innerHTML("");
                                                if(document.getElementById("fsUploadProgress"+tfieldidarray[0])){
                                                    clearSWFUploadRequired(tfieldidarray[0]);//add by td78113
                                                    
                                                    uploadAttachmentDisd(tfieldidarray[0]);
                                                }
                                                try{
                                                    var checkstr__=$GetEle("needcheck").value+",";
                                                    document.all("needcheck").value=checkstr__.replace(new RegExp("field"+tfieldidarray[0]+",","g"),"");
                                                    //document.forms[0].elements[i].viewtype="0";
                                                    jQuery("#field"+tfieldidarray[0]).attr("viewtype","0");
                                                }catch(e){
                                                }
                                            }
                                        }
                                        /////////////////
                                    }else{
                                        if(document.all('field'+tfieldidarray[0])!=null && document.all('field'+tfieldidarray[0]).type=="checkbox"){//check框
                                            document.forms[0].elements[i].setAttribute('viewtype','0');
                                            if(isedit==3){
                                                document.forms[0].elements[i].setAttribute('viewtype','1');
                                            }
                                            setFieldReadOnly(tfieldidarray[0]+"",false,fieldattr);
                                            document.all('field'+tfieldidarray[0]).onclick=null;
                                        }
                                    }
                                    
                                }
                                if (jQuery("#outfield"+tfieldidarray[0]+"div").length > 0) {
                                     var _isMustInput = jQuery("#field"+tfieldidarray[0]).attr('_isMustInput');
                                     if (!!_isMustInput) {
                                         jQuery("#field"+tfieldidarray[0]).attr('isMustInput', _isMustInput);
                                         jQuery("#field"+tfieldidarray[0]).removeAttr('_isMustInput');
                                     } else {
                                        jQuery("#field"+tfieldidarray[0]).removeAttr('isMustInput');
                                     }
                                }
                            }
                        }
                    }
                }
            }
            if(fieldattr==1){// 为编辑，显示属性设为编辑
                try {
                for(i=0;i<len;i++){
                    for(j=0;j<fieldidarray.length;j++){
                        var tfieldidarray=fieldidarray[j].split("_");
                        if (tfieldidarray[1]==isdetail){
                            if(rownum>-1){  // 明细字段
                                if(document.forms[0].elements[i].name=='field'+tfieldidarray[0]+"_"+rownum&&$GetEle('oldfieldview'+tfieldidarray[0]+"_"+rownum)){
                                    isedit=$GetEle('oldfieldview'+tfieldidarray[0]+"_"+rownum).value;
                                    if(isedit>1&&$GetEle('field'+tfieldidarray[0]+"_"+rownum+"span")){
                                        var checkstr_=$GetEle("needcheck").value+",";
                                        if($GetEle('field'+tfieldidarray[0]+"_"+rownum+"span").innerHTML.indexOf("/images/BacoError_wev8.gif")>-1) $GetEle('field'+tfieldidarray[0]+"_"+rownum+"span").innerHTML="";
                                        
                                        try{
                                            if($GetEle('field_lable'+tfieldidarray[0]+"_"+rownum+"span").innerHTML.indexOf("/images/BacoError_wev8.gif")>-1){
                                                $GetEle('field_lable'+tfieldidarray[0]+"_"+rownum+"span").innerHTML="";
                                            }
                                        }catch(e){}
                                        $GetEle("needcheck").value=checkstr_.replace(new RegExp("field"+tfieldidarray[0]+"_"+rownum+",","g"),"");
                                        document.forms[0].elements[i].setAttribute('viewtype','0');
                                        
                                    }else{
                                        if(document.all('field'+tfieldidarray[0]+"_"+rownum)!=null && document.all('field'+tfieldidarray[0]+"_"+rownum).type=="checkbox"){//check框
                                            document.forms[0].elements[i].setAttribute('viewtype','0');
                                            //readyOnlyStyle(document.all('field'+tfieldidarray[0]+"_"+rownum),false);
                                            document.all('field'+tfieldidarray[0]+"_"+rownum).onclick=null;
                                        }
                                    }
                                    setFieldReadOnly(tfieldidarray[0]+"_"+rownum,false,fieldattr);
                                    if($GetEle('field_'+tfieldidarray[0]+"_"+rownum+"span")){
                                        jQuery("#field_"+tfieldidarray[0]+"_"+rownum+"span").css("display","none");     
                                        jQuery("#field"+tfieldidarray[0]+"_"+rownum+"_remind").attr("title",SystemEnv.getHtmlNoteName(4062));
                                        if(document.getElementById("fsUploadProgress"+tfieldidarray[0]+"_"+rownum)){
                                            clearSWFUploadRequired(tfieldidarray[0]+"_"+rownum);//add by td78113
                                            uploadAttachmentDisd(tfieldidarray[0]+"_"+rownum);
                                        }
                                        //将附件删除按钮显示
                                        jQuery("#field"+tfieldidarray[0]+"_"+rownum+"_tab").find("div[id^='fieldCancleChange1']").each(function(){
                                                jQuery(this).attr("id","fieldCancleChange");
                                            });
                                        try{
                                            var checkstr__=$GetEle("needcheck").value+",";
                                            document.all("needcheck").value=checkstr__.replace(new RegExp("field"+tfieldidarray[0]+"_"+rownum+",","g"),"");
                                            jQuery("#field"+tfieldidarray[0]+"_"+rownum).attr("viewtype","0");
                                        }catch(e){
                                        }
                                    }
                                }
                            }else{     // 主字段
                                if(document.forms[0].elements[i].name=='field'+tfieldidarray[0]&&$GetEle('oldfieldview'+tfieldidarray[0])){
                                    isedit=$GetEle('oldfieldview'+tfieldidarray[0]).value;
                                    if(isedit>1&&$GetEle('field_'+tfieldidarray[0]+"span")){
                                        jQuery('#field_'+tfieldidarray[0]+"span").css("display","none");
                                        //判断附件字段
                                        if(document.getElementById("fsUploadProgress"+tfieldidarray[0])){
                                            clearSWFUploadRequired(tfieldidarray[0]);//add by td78113
                                            
                                            uploadAttachmentDisd(tfieldidarray[0]);
                                        }
                                    }
                                    if(isedit>1&&($GetEle('field'+tfieldidarray[0]+"span")||$GetEle('field'+tfieldidarray[0]+"spanimg"))){
                                        var checkstr_=$GetEle("needcheck").value+",";
                                        //判断附件字段
                                        if(document.getElementById("fsUploadProgress"+tfieldidarray[0])){
                                            clearSWFUploadRequired(tfieldidarray[0]);//add by td78113
                                            
                                            uploadAttachmentDisd(tfieldidarray[0]);
                                        }
                                        if($GetEle('field'+tfieldidarray[0]+"span").innerHTML.indexOf("/images/BacoError_wev8.gif")>-1) $GetEle('field'+tfieldidarray[0]+"span").innerHTML="";
                                        if(!!$GetEle('field'+tfieldidarray[0]+"spanimg")){
                                            if($GetEle('field'+tfieldidarray[0]+"spanimg").innerHTML.indexOf("/images/BacoError_wev8.gif")>-1) $GetEle('field'+tfieldidarray[0]+"spanimg").innerHTML="";
                                        }
                                        try{
                                            if($GetEle('field_lable'+tfieldidarray[0]+"span").innerHTML.indexOf("/images/BacoError_wev8.gif")>-1){
                                                $GetEle('field_lable'+tfieldidarray[0]+"span").innerHTML="";
                                            }
                                        }catch(e){}
                                        $GetEle("needcheck").value=checkstr_.replace(new RegExp("field"+tfieldidarray[0]+",","g"),"");
                                        document.forms[0].elements[i].setAttribute('viewtype','0');
                                    }else{
                                        if(document.all('field'+tfieldidarray[0])!=null && document.all('field'+tfieldidarray[0]).type=="checkbox"){//check框
                                            document.forms[0].elements[i].setAttribute('viewtype','0');
                                            //readyOnlyStyle(document.all('field'+tfieldidarray[0]),false);
                                            document.all('field'+tfieldidarray[0]).onclick=null;
                                        }
                                    }
                                    setFieldReadOnly(tfieldidarray[0]+"",false,fieldattr);
                                    try{
                                        var checkstr__=$GetEle("needcheck").value+",";
                                        document.all("needcheck").value=checkstr__.replace(new RegExp("field"+tfieldidarray[0]+",","g"),"");
                                        document.forms[0].elements[i].viewtype="0";
                                        jQuery("#field"+tfieldidarray[0]).attr("viewtype","0");
                                        jQuery(".progressCancel1").attr("class","progressCancel");
                                    }catch(e){
                                    }
                                }
                                 if (jQuery("#outfield"+tfieldidarray[0]+"div").length > 0) {
                                    var _isMustInput = jQuery("#field"+tfieldidarray[0]).attr('_isMustInput');
                                     if (!!_isMustInput) {
                                         jQuery("#field"+tfieldidarray[0]).attr('isMustInput', _isMustInput);
                                         jQuery("#field"+tfieldidarray[0]).removeAttr('_isMustInput');
                                     } else {
                                        jQuery("#field"+tfieldidarray[0]).removeAttr('isMustInput');
                                     }
                                }
                            }
                        }
                    }
                }
                }
                catch(err){
                    console.log("异常错误06-21(编辑)："+err.message);
                }
            }
            if(fieldattr==2) {// 为必填，显示属性设为编辑
                try{
                for (i = 0; i < len; i++) {
                    for (j = 0; j < fieldidarray.length; j++) {
                        var tfieldidarray = fieldidarray[j].split("_");
                        if (tfieldidarray[1] == isdetail) {
                            if (rownum > -1) {  // 明细字段
                                if (document.forms[0].elements[i].name == 'field' + tfieldidarray[0] + "_" + rownum && $GetEle('oldfieldview' + tfieldidarray[0] + "_" + rownum)) {
                                    isedit = $GetEle('oldfieldview' + tfieldidarray[0] + "_" + rownum).value;
                                    if (isedit > 1 && $GetEle('field' + tfieldidarray[0] + "_" + rownum + "span")) {
                                        if (document.forms[0].elements[i].value == "" && $GetEle('field' + tfieldidarray[0] + "_" + rownum + "span").innerHTML.indexOf("/images/BacoError_wev8.gif") <= 0) $GetEle('field' + tfieldidarray[0] + "_" + rownum + "span").innerHTML = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>";
                                        try {
                                            if (document.forms[0].elements[i].value == "" && $GetEle('field_lable' + tfieldidarray[0] + "_" + rownum + "span").innerHTML.indexOf("/images/BacoError_wev8.gif") <= 0) {
                                                $GetEle('field_lable' + tfieldidarray[0] + "_" + rownum + "span").innerHTML = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>";
                                                $GetEle('field' + tfieldidarray[0] + "_" + rownum + "span").innerHTML = "";
                                            }
                                        } catch (e) {
                                        }
                                        var checkstr_ = $GetEle("needcheck").value + ",";
                                        if (checkstr_.indexOf("field" + tfieldidarray[0] + "_" + rownum + ",") < 0) {
                                            $GetEle("needcheck").value = checkstr_ + "field" + tfieldidarray[0] + "_" + rownum;
                                        }
                                        document.forms[0].elements[i].setAttribute('viewtype', '1');
                                    } else {
                                        if (document.all('field' + tfieldidarray[0] + "_" + rownum) != null && document.all('field' + tfieldidarray[0] + "_" + rownum).type == "checkbox") {//check框
                                            document.forms[0].elements[i].setAttribute('viewtype', '1');
                                            //readyOnlyStyle(document.all('field'+tfieldidarray[0]+"_"+rownum),false);
                                            document.all('field' + tfieldidarray[0] + "_" + rownum).onclick = null;
                                        }
                                    }
                                    setFieldReadOnly(tfieldidarray[0] + "_" + rownum, false, fieldattr);

                                    //判断附件字段
                                    if (document.getElementById("fsUploadProgress" + tfieldidarray[0] + "_" + rownum)) {
                                        setFieldReadOnly(tfieldidarray[0] + "_" + rownum + "", false, fieldattr);
                                        addSWFUploadRequired(tfieldidarray[0] + "_" + rownum);//add by td78113
                                        //document.all('field'+tfieldidarray[0]+"span").innerHTML="<IMG src='/images/BacoError_wev8.gif' align=absMiddle>";
                                        //alert("field_"+tfieldidarray[0]+"span");
                                        //jQuery(".progressCancel1").attr("class","progressCancel");
                                        //if(document.getElementById("fsUploadProgress"+tfieldidarray[0]).children.length>0){
                                        jQuery("#field" + tfieldidarray[0] + "_" + rownum + "_remind").attr("title", SystemEnv.getHtmlNoteName(4062));
                                        if (isEmptyfsUpdaload(tfieldidarray[0] + "_" + rownum)) {
                                            //document.all('field'+tfieldidarray[0]+"span").innerHTML="";
                                            var checkstr_ = $GetEle("needcheck").value + ",";

                                            jQuery("#field_" + tfieldidarray[0] + "_" + rownum + "span").css("display", "inline-block");
                                            $GetEle("field_" + tfieldidarray[0] + "_" + rownum + "span").innerHTML = SystemEnv.getHtmlNoteName(97);
                                            if (checkstr_.indexOf("field" + tfieldidarray[0] + "_" + rownum + ",") < 0) $GetEle("needcheck").value = checkstr_ + "field" + tfieldidarray[0] + "_" + rownum;
                                        } else {
                                            $GetEle("field_" + tfieldidarray[0] + "_" + rownum + "span").innerHTML = "";
                                        }
                                        //将附件删除按钮显示
                                        jQuery("#field" + tfieldidarray[0] + "_" + rownum + "_tab").find("div[id^='fieldCancleChange1']").each(function () {
                                            jQuery(this).attr("id", "fieldCancleChange");
                                        });
                                        jQuery("#field" + tfieldidarray[0] + "_" + rownum).attr("viewtype", "1");

                                        uploadAttachmentDisd(tfieldidarray[0] + "_" + rownum);
                                    }
                                }
                            } else {     // 主字段
                                if (document.forms[0].elements[i].name == 'field' + tfieldidarray[0] && $GetEle('oldfieldview' + tfieldidarray[0])) {
                                    //必填时 主表字段如果没有值则增加叹号标识
                                    isedit = $GetEle('oldfieldview' + tfieldidarray[0]).value;

                                    if (isedit > 1 && $GetEle('field_' + tfieldidarray[0] + "span")) {
                                        jQuery('#field_' + tfieldidarray[0] + "span").css("display", "inline-block");
                                    }
                                    if (isedit > 1 && $GetEle('field' + tfieldidarray[0] + "span")) {
                                        if (!!$GetEle('field' + tfieldidarray[0] + "spanimg") && $GetEle('field' + tfieldidarray[0] + "span").innerHTML == "") {
                                            //alert(tfieldidarray[0]);
                                            $GetEle('field' + tfieldidarray[0] + "spanimg").innerHTML = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>";
                                            $GetEle('field' + tfieldidarray[0] + "span").innerHTML = "";
                                        }

                                        if (!!$GetEle('field_lable' + tfieldidarray[0]) && $GetEle('field_lable' + tfieldidarray[0]).value == "") {
                                            $GetEle('field_lable' + tfieldidarray[0] + "span").innerHTML = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>";
                                            $GetEle('field' + tfieldidarray[0] + "span").innerHTML = "";
                                        }
                                        setFieldReadOnly(tfieldidarray[0] + "", false, fieldattr);
                                        //提交校验必填
                                        var checkstr_ = $GetEle("needcheck").value + ",";

                                        if (checkstr_.indexOf("field" + tfieldidarray[0] + ",") < 0) {
                                            $GetEle("needcheck").value = checkstr_ + "field" + tfieldidarray[0];
                                        }

                                    }

                                    try {
                                        if ($GetEle('field_lable' + tfieldidarray[0] + "span")) {
                                            if ($GetEle('field_lable' + tfieldidarray[0] + "").value == '') {
                                                $GetEle('field_lable' + tfieldidarray[0] + "span").innerHTML = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>";
                                            }
                                        }
                                    } catch (e) {
                                    }
                                    //判断附件字段
                                    if (document.getElementById("fsUploadProgress" + tfieldidarray[0])) {
                                        setFieldReadOnly(tfieldidarray[0] + "", false, fieldattr);
                                        addSWFUploadRequired(tfieldidarray[0]);//add by td78113
                                        //document.all('field'+tfieldidarray[0]+"span").innerHTML="<IMG src='/images/BacoError_wev8.gif' align=absMiddle>";
                                        //alert("field_"+tfieldidarray[0]+"span");
                                        jQuery(".progressCancel1").attr("class", "progressCancel");
                                        //if(document.getElementById("fsUploadProgress"+tfieldidarray[0]).children.length>0){
                                        if (isEmptyfsUpdaload(tfieldidarray[0])) {
                                            //document.all('field'+tfieldidarray[0]+"span").innerHTML="";
                                            var checkstr_ = $GetEle("needcheck").value + ",";
                                            $GetEle("field_" + tfieldidarray[0] + "span").innerHTML = SystemEnv.getHtmlNoteName(97);
                                            if (checkstr_.indexOf("field" + tfieldidarray[0] + ",") < 0) $GetEle("needcheck").value = checkstr_ + "field" + tfieldidarray[0];
                                        } else {
                                            $GetEle("field_" + tfieldidarray[0] + "span").innerHTML = "";
                                        }
                                        //alert(jQuery("#field"+tfieldidarray[0]).attr("viewtype"));
                                        jQuery("#field" + tfieldidarray[0]).attr("viewtype", "1");
                                        //alert(jQuery("#field"+tfieldidarray[0]).attr("viewtype"));
                                        //}

                                        uploadAttachmentDisd(tfieldidarray[0]);
                                    }
                                }
                                if (jQuery("#outfield" + tfieldidarray[0] + "div").length > 0) {
                                    var isMustInput = jQuery("#field" + tfieldidarray[0]).attr('isMustInput');
                                    if (!!isMustInput) {
                                        jQuery("#field" + tfieldidarray[0]).attr('_isMustInput', isMustInput);
                                    }
                                    jQuery("#field" + tfieldidarray[0]).attr('isMustInput', 2);
                                }
                            }
                        }
                    }
                }
            }catch (err1){
                console.log(err1.message);
            }
                }

            if(fieldattr==3){//为只读，显示属性设为编辑
                for(i=0;i<len;i++){
                    for(j=0;j<fieldidarray.length;j++){
                        var tfieldidarray=fieldidarray[j].split("_");
                        if (tfieldidarray[1]==isdetail){
                            if(rownum>-1){  //明细字段
                                if(document.forms[0].elements[i].name=='field'+tfieldidarray[0]+"_"+rownum&&$GetEle('oldfieldview'+tfieldidarray[0]+"_"+rownum)){
                                    if($GetEle('field'+tfieldidarray[0]+"_"+rownum+"span")){
                                        var checkstr_=$GetEle("needcheck").value+",";
                                        if($GetEle('field'+tfieldidarray[0]+"_"+rownum+"span")){
                                            if($GetEle('field'+tfieldidarray[0]+"_"+rownum+"span").innerHTML.indexOf("/images/BacoError_wev8.gif")>-1){
                                                $GetEle('field'+tfieldidarray[0]+"_"+rownum+"span").innerHTML="";
                                            }
                                        }
                                        setFieldReadOnly(tfieldidarray[0]+"_"+rownum,true,fieldattr);
                                        try{
                                            if($GetEle('field_lable'+tfieldidarray[0]+"_"+rownum+"span").innerHTML.indexOf("/images/BacoError_wev8.gif")>-1){
                                                $GetEle('field_lable'+tfieldidarray[0]+"_"+rownum+"span").innerHTML="";
                                            }
                                        }catch(e){
                                        }
                                        $GetEle("needcheck").value = checkstr_.replace(new RegExp("field"+tfieldidarray[0]+"_"+rownum+",","g"),"");
                                        document.forms[0].elements[i].viewtype="0";
                                    }else{
                                        //check框
                                        if(document.all('field'+tfieldidarray[0]+"_"+rownum)!=null && document.all('field'+tfieldidarray[0]+"_"+rownum).type=="checkbox"){
                                            //readyOnlyStyle(document.all('field'+tfieldidarray[0]+"_"+rownum),true);
                                            var checked=document.all('field'+tfieldidarray[0]+"_"+rownum).checked;
                                            document.forms[0].elements[i].viewtype="0";
                                            document.all('field'+tfieldidarray[0]+"_"+rownum).onclick=function(){
                                                this.checked=checked;
                                            }
                                        }
                                    }
                                    
                                    //判断附件字段
                                    if($GetEle('field_'+tfieldidarray[0]+"_"+rownum+"span")){
                                        jQuery('#field_'+tfieldidarray[0]+"_"+rownum+"span").css("display","none");
                                        $GetEle("field_"+tfieldidarray[0]+"_"+rownum+"span").innerHTML="";
                                        jQuery("#field"+tfieldidarray[0]+"_"+rownum+"_remind").attr("title","");
                                    }
                                    try{
                                        //if(jQuery("#field"+tfieldidarray[0]+"_tab").length>0){
                                        //  attachmentDisd(tfieldidarray[0],true);
                                        //}
                                        if(document.getElementById("fsUploadProgress"+tfieldidarray[0]+"_"+rownum)){
                                            jQuery("#field"+tfieldidarray[0]+"_"+rownum).attr("viewtype","0");                      
                                            //将附件删除按钮隐藏
                                            jQuery("#field"+tfieldidarray[0]+"_"+rownum+"_tab").find("div[id^='fieldCancleChange']").each(function(){
                                                jQuery(this).attr("id","fieldCancleChange1");
                                            });
                                            var req=$GetEle("oUpload_"+tfieldidarray[0]+"_"+rownum+"_linkrequired");
                                            if(req)req.value="false";
                                            attachmentDisd(tfieldidarray[0]+"_"+rownum,true);
                                            jQuery('#field_'+tfieldidarray[0]+"_"+rownum+"span").css("display","none");
                                            
                                            jQuery("#oldfieldview"+tfieldidarray[0]+"_"+rownum).attr("_readonly","1");
                                            if(jQuery("#oldfieldview"+tfieldidarray[0]+"_"+rownum).length==0){
                                                jQuery("input[name='oldfieldview"+tfieldidarray[0]+"_"+rownum+"']").attr("_readonly","1");
                                                jQuery("input[name='oldfieldview"+tfieldidarray[0]+"_"+rownum+"']").attr("id","oldfieldview"+tfieldidarray[0]+"_"+rownum+"");
                                            }
                                        }
                                        
                                    }catch(e){
                                        //alert(e.message);
                                    }
                                    try{
                                        var checkstr_ = $GetEle("needcheck").value +",";    
                                        $GetEle("needcheck").value = checkstr_.replace(new RegExp("field"+tfieldidarray[0]+"_"+rownum+",","g"),"");
                                        //document.forms[0].elements[i].viewtype="0";

                                    }catch(e){
                                    }
                                }
                            }else{     //主字段
                                if(document.forms[0].elements[i].name=='field'+tfieldidarray[0]&&$GetEle('oldfieldview'+tfieldidarray[0])){
                                    isedit=$GetEle('oldfieldview'+tfieldidarray[0]).value;
                                    if(isedit>1&&$GetEle('field_'+tfieldidarray[0]+"span")){
                                        jQuery('#field_'+tfieldidarray[0]+"span").css("display","none");
                                    }
                                    if(isedit>1&&$GetEle('field'+tfieldidarray[0]+"span")){
                                       //去除必填标识
                                        if(!!$GetEle('field'+tfieldidarray[0]+"spanimg")){
                                             $GetEle('field'+tfieldidarray[0]+"spanimg").innerHTML="";
                                        }
                           
                                        if(!!$GetEle('field'+tfieldidarray[0]+"span")){
                                            if($GetEle('field'+tfieldidarray[0]+"span").innerHTML.indexOf("/images/BacoError_wev8.gif")>-1){
                                                $GetEle('field'+tfieldidarray[0]+"span").innerHTML="";
                                            }
                                        }

                                         try{
                                            if($GetEle('field_lable'+tfieldidarray[0]+"span")){
                                                if($GetEle('field_lable'+tfieldidarray[0]+"span").innerHTML.indexOf("/images/BacoError_wev8.gif")>-1){
                                                    $GetEle('field_lable'+tfieldidarray[0]+"span").innerHTML="";
                                                }
                                            }
                                        }catch(e){}
                                        
                                    }
                                    setFieldReadOnly(tfieldidarray[0],true,fieldattr);
                                    //判断附件字段
                                    try{
                                        //if(jQuery("#field"+tfieldidarray[0]+"_tab").length>0){
                                        //  attachmentDisd(tfieldidarray[0],true);
                                        //}
                                        if(document.getElementById("fsUploadProgress"+tfieldidarray[0])){
                                            jQuery("#field"+tfieldidarray[0]).attr("viewtype","0");
                                            jQuery(".progressCancel").attr("class","progressCancel1");
                                            var req=$GetEle("oUpload_"+tfieldidarray[0]+"_linkrequired");
                                            if(req)req.value="false";
                                            attachmentDisd(tfieldidarray[0],true);
                                            jQuery("#oldfieldview"+tfieldidarray[0]).attr("_readonly","1");
                                            if(jQuery("#oldfieldview"+tfieldidarray[0]).length==0){
                                                jQuery("input[name='oldfieldview"+tfieldidarray[0]+"']").attr("_readonly","1");
                                                jQuery("input[name='oldfieldview"+tfieldidarray[0]+"']").attr("id","oldfieldview"+tfieldidarray[0]+"");
                                            }
                                        }
                                    }catch(e){
                                        //alert(e.message);
                                    }

                                    try{
                                        var checkstr_ = $GetEle("needcheck").value +",";    
                                        $GetEle("needcheck").value = checkstr_.replace(new RegExp("field"+tfieldidarray[0]+",","g"),"");
                                        //document.forms[0].elements[i].viewtype="0";

                                    }catch(e){
                                    }
                                }
                                if (jQuery("#outfield"+tfieldidarray[0]+"div").length > 0) {
                                    var _isMustInput = jQuery("#field"+tfieldidarray[0]).attr('_isMustInput');
                                     if (!!_isMustInput) {
                                         jQuery("#field"+tfieldidarray[0]).attr('isMustInput', _isMustInput);
                                         jQuery("#field"+tfieldidarray[0]).removeAttr('_isMustInput');
                                     } else {
                                        jQuery("#field"+tfieldidarray[0]).removeAttr('isMustInput');
                                     }
                                }
                            } 
                        }
                    }
                }
            }
        }
	}
	}catch(e){}
}