<%@ page language="java" contentType="text/html; charset=GBK" %>
<script language="javascript">
jQuery(document).ready(function(){
		//��ϸ1����
    jQuery("button[name='addbutton0']").bind("click",function(){
		bindfee(1); 
    });
	bindfee(2);
});

function _get_indexnum0(){
	var indexnum0 = -1;
	var _xm_array = jQuery("input[name^='field"+dt1_subject+"_']");
	for(var i0=0;i0<_xm_array.length;i0++){
		try{
			var _iptName = jQuery(_xm_array[i0]).attr("name");
			var _iptNameArray = _iptName.split("_");
			if(_iptNameArray.length==2){
				var _idx = parseInt(_iptNameArray[1]);
				if(!isNaN(_idx) && _idx>=0 && jQuery("#field"+dt1_subject+"_"+_idx).length==1){
					indexnum0 = indexnum0+1;
			    }
			}
		}catch(e){}
	}
	return indexnum0;
}

function _getIndexno_bindPropertyChange_byObj(__obj){
	//alert("_getIndexno_bindPropertyChange_byObj __obj="+__obj);
	var __indexno = "";
	try{
		if(__obj!=null){
			var __id = __obj.id;
			if(__id!=null){
				__indexno = _getIndexno_bindPropertyChange_byId(__id);
			}else{
				__id = __obj.name;
				if(__id!=null){
					__indexno = _getIndexno_bindPropertyChange_byId(__id);
				}
			}
		}
	}catch(ex001){}
	return __indexno;
}

function _getIndexno_bindPropertyChange_byId(__id){
	//alert("_getIndexno_bindPropertyChange_byId __id="+__id);
	/*
	alert("dt1_subject="+dt1_subject);
	alert("dt1_budgetperiod="+dt1_budgetperiod);
	alert("dt1_organizationid="+dt1_organizationid);
	alert("dt1_organizationtype="+dt1_organizationtype);
	alert("dt1_applyamount="+dt1_applyamount);
	*/
	var __indexno = "";
	if(__indexno==null||__indexno==""){
		try{
			__indexno = __id.split("field"+dt1_subject+"_")[1].replace("browser", "");
		}catch(ex001){}
	}
	if(__indexno==null||__indexno==""){
		try{
			__indexno = __id.split("field"+dt1_budgetperiod+"_")[1].replace("browser", "");
		}catch(ex001){}
	}
	if(__indexno==null||__indexno==""){
		try{
			__indexno = __id.split("field"+dt1_organizationid+"_")[1].replace("browser", "");
		}catch(ex001){}
	}
	if(__indexno==null||__indexno==""){
		try{
			__indexno = __id.split("disfield"+dt1_organizationtype+"_")[1].replace("browser", "");
		}catch(ex001){}
	}
	if(__indexno==null||__indexno==""){
		try{
			__indexno = __id.split("field"+dt1_organizationtype+"_")[1].replace("browser", "");
		}catch(ex001){}
	}
	if(__indexno==null||__indexno==""){
		try{
			__indexno = __id.split("field"+dt1_applyamount+"_")[1].replace("browser", "");
		}catch(ex001){}
	}
	//alert("_getIndexno_bindPropertyChange_byId __indexno="+__indexno);
	return __indexno;
}

function _fna_FnaSubmitRequestJs_showBrowser2_onOrgTypeChange(__indexno){
	//alert("_fna_FnaSubmitRequestJs_showBrowser2_onOrgTypeChange __indexno="+__indexno);
	var _orgType = "";
	if(jQuery("#disfield"+dt1_organizationtype+"_"+__indexno).length){
		_orgType = jQuery("#disfield"+dt1_organizationtype+"_"+__indexno).val();
	}else if(jQuery("#field"+dt1_organizationtype+"_"+__indexno).length){
		_orgType = jQuery("#field"+dt1_organizationtype+"_"+__indexno).val();
	}else{
		_orgType = jQuery("input[name='field"+dt1_organizationtype+"_"+__indexno+"']").val();
	}
	if(_orgType=='0'){
		onShowBrowser2(dt1_organizationid+'_'+__indexno,'/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp','/hrm/resource/HrmResource.jsp?id=','1',jQuery("#field"+dt1_organizationid+"_"+__indexno).attr("viewtype"));
	}else if(_orgType=='1'){
		onShowBrowser2(dt1_organizationid+'_'+__indexno,'/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp','/hrm/company/HrmDepartmentDsp.jsp?id=','4',jQuery("#field"+dt1_organizationid+"_"+__indexno).attr("viewtype"));
	}else if(_orgType=='2'){
		onShowBrowser2(dt1_organizationid+'_'+__indexno,'/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser.jsp','/hrm/company/HrmSubCompanyDsp.jsp?id=','164',jQuery("#field"+dt1_organizationid+"_"+__indexno).attr("viewtype"));
	}
}

//������ϸ1
function bindfee(value){
    var indexnum0 = 0;
	var indexnum0 = _get_indexnum0();
	/*
    if(document.getElementById("indexnum0")){
		indexnum0 = document.getElementById("indexnum0").value * 1.0 - 1;
    }
    */
    if(indexnum0>=0){
		if(value==1){ //��ǰ��ӵ���
			//��ʼ����Ŀ
			try{
			    jQuery("#field"+dt1_subject+"_"+indexnum0).bindPropertyChange(function(targetobj){
					var __indexno = _getIndexno_bindPropertyChange_byObj(targetobj);
			    	getFnaInfoData(__indexno);
				});
			}catch(ex10){}
			//��ʼ����������
			try{
			    jQuery("#field"+dt1_budgetperiod+"_"+indexnum0).bindPropertyChange(function(targetobj){
					var __indexno = _getIndexno_bindPropertyChange_byObj(targetobj);
			    	getFnaInfoData(__indexno);
				});
			}catch(ex10){}
			try{
			    jQuery("#field"+dt1_organizationid+"_"+indexnum0).bindPropertyChange(function(targetobj){
					var __indexno = _getIndexno_bindPropertyChange_byObj(targetobj);
			    	getFnaInfoData(__indexno);
				});
			}catch(ex10){}
			//��ʼ����������
		    jQuery("#field"+dt1_organizationtype+"_"+indexnum0).bind("change",function(){
				var __indexno = _getIndexno_bindPropertyChange_byObj(this);
				jQuery("#field"+dt1_organizationid+"_"+__indexno).val("");
				jQuery("#field"+dt1_organizationid+"_"+__indexno+"span").html("");
			});
			
			//��ʼ��������λ
			jQuery("#field"+dt1_organizationid+"_"+indexnum0).prev().unbind('click').removeAttr('onclick').click(function(){
				var __indexno = _getIndexno_bindPropertyChange_byObj(this);
				_fna_FnaSubmitRequestJs_showBrowser2_onOrgTypeChange(__indexno);
			});
		}else if(value==2){//��ʼ��
	    	for(var i=0;i<=indexnum0;i++){
	    		//��ʼ��Ԥ��
				getFnaInfoData(i);
				//��ʼ����Ŀ
				jQuery("#field"+dt1_subject+"_"+i).attr("indexno",i);
				try{
				    jQuery("#field"+dt1_subject+"_"+i).bindPropertyChange(function(targetobj){
						var __indexno = _getIndexno_bindPropertyChange_byObj(targetobj);
				    	getFnaInfoData(__indexno);
					});
				}catch(ex10){}
				//��ʼ����������
				jQuery("#field"+dt1_budgetperiod+"_"+i).attr("indexno",i);
				try{
				    jQuery("#field"+dt1_budgetperiod+"_"+i).bindPropertyChange(function(targetobj){
						var __indexno = _getIndexno_bindPropertyChange_byObj(targetobj);
				    	getFnaInfoData(__indexno);
					});
				}catch(ex10){}

				jQuery("#field"+dt1_organizationid+"_"+i).attr("indexno",i);
				try{
				    jQuery("#field"+dt1_organizationid+"_"+i).bindPropertyChange(function(targetobj){
						var __indexno = _getIndexno_bindPropertyChange_byObj(targetobj);
				    	getFnaInfoData(__indexno);
					});
				}catch(ex10){}
				
		    	//��ʼ����������
	        	jQuery("#field"+dt1_organizationtype+"_"+i).attr("indexno",i);
			    jQuery("#field"+dt1_organizationtype+"_"+i).bind("change",function(){
					var __indexno = _getIndexno_bindPropertyChange_byObj(this);
					jQuery("#field"+dt1_organizationid+"_"+__indexno).val("");
					jQuery("#field"+dt1_organizationid+"_"+__indexno+"span").html("");
				});
				//��ʼ��������λ
				var orgtype = "";
				if(jQuery("#disfield"+dt1_organizationtype+"_"+i).length){
					orgtype = jQuery("#disfield"+dt1_organizationtype+"_"+i).val();
				}else if(jQuery("#field"+dt1_organizationtype+"_"+i).length){
					orgtype = jQuery("#field"+dt1_organizationtype+"_"+i).val();
				}else{
					orgtype = jQuery("input[name='field"+dt1_organizationtype+"_"+i+"']").val();
				}
				var orgid = "";
				orgid = jQuery("#field"+dt1_organizationid+"_"+i).val();
				if(jQuery("#field"+dt1_organizationid+"_"+i).length){
					orgid = jQuery("#field"+dt1_organizationid+"_"+i).val();
				}else{
					orgid = jQuery("input[name='field"+dt1_organizationid+"_"+i+"']").val();
				}
				jQuery("#field"+dt1_organizationid+"_"+i+"span").html(getOrgSpan(orgtype,orgid));
				jQuery("#field"+dt1_organizationid+"_"+i).prev().attr("indexno",i);
				jQuery("#field"+dt1_organizationid+"_"+i).prev().unbind('click').removeAttr('onclick').click(function(){
					var __indexno = _getIndexno_bindPropertyChange_byObj(this);
					_fna_FnaSubmitRequestJs_showBrowser2_onOrgTypeChange(__indexno);
				});
			}
		}
	}
}

//������Ա/����/�ֲ�id��ö�Ӧ����
function getOrgSpan(orgtype,orgid){
	var orgSpan = "";
	jQuery.ajax({
		url : "/workflow/request/GetOrgNameById.jsp",
		type : "post",
		async : false,
		processData : false,
		data : "orgtype="+orgtype+"&orgid="+orgid,
		dataType : "html",
		success: function do4Success(msg){ 
			orgSpan = jQuery.trim(msg);
			if(orgtype=="0"){
				orgSpan = "<a onclick='pointerXY(event);' href='javascript:openhrm("+orgid+");'>"+orgSpan+"</A>";
			}
			if(orgtype=="1"){
				orgSpan = "<A href='/hrm/company/HrmDepartmentDsp.jsp?id="+orgid+"' target=_new>"+orgSpan+"</A>";
			}
			if(orgtype=="2"){
				orgSpan = "<A href='/hrm/company/HrmSubCompanyDsp.jsp?id="+orgid+"' target=_new>"+orgSpan+"</A>";
			}
		}
	});	
	return orgSpan;
}
 
//���� ��Ŀ���������͡�������λ���������� �õ�Ԥ����Ϣ
function getFnaInfoData(indexno){
	if((indexno==null||indexno=="")&&((indexno+"")!="0")){
		return;
	}
	var budgetfeetype = "";
	if(jQuery("#field"+dt1_subject+"_"+indexno).length){
		budgetfeetype = jQuery("#field"+dt1_subject+"_"+indexno).val();
	}else{
		budgetfeetype = jQuery("input[name='field"+dt1_subject+"_"+indexno+"']").val();
	};
    if(budgetfeetype==""){
        return;
	}
	var orgtype = "";
	if(jQuery("#disfield"+dt1_organizationtype+"_"+indexno).length){
		orgtype = jQuery("#disfield"+dt1_organizationtype+"_"+indexno).val();
	}else if(jQuery("#field"+dt1_organizationtype+"_"+indexno).length){
		orgtype = jQuery("#field"+dt1_organizationtype+"_"+indexno).val();
	}else{
		orgtype = jQuery("input[name='field"+dt1_organizationtype+"_"+indexno+"']").val();
	};
    if(orgtype==""){
    	return;
	}
	var orgid = "";
	if(jQuery("#field"+dt1_organizationid+"_"+indexno).length){
		orgid = jQuery("#field"+dt1_organizationid+"_"+indexno).val();
	}else{
		orgid = jQuery("input[name='field"+dt1_organizationid+"_"+indexno+"']").val();
	};
    if(orgid==""){
        return;
	}
	var applydate = "";
	if(jQuery("#field"+dt1_budgetperiod+"_"+indexno).length){
		applydate = jQuery("#field"+dt1_budgetperiod+"_"+indexno).val();
	}else{
		applydate = jQuery("input[name='field"+dt1_budgetperiod+"_"+indexno+"']").val();
	};
    if(applydate==""){
        return;
	}
	jQuery.ajax({
		url : "/workflow/request/FnaBudgetInfoAjax.jsp",
		type : "post",
		async : false,
		processData : false,
		data : "budgetfeetype="+budgetfeetype+"&orgtype="+orgtype+"&orgid="+orgid+"&applydate="+applydate,
		dataType : "html",
		success: function do4Success(msg){
	        var fnainfos = jQuery.trim(msg).split("|");
	        if(jQuery("#field"+dt1_hrmremain+"_"+indexno+"span").length){
	        	var values = fnainfos[0].split(",");
	        	var tempmsg = "����Ԥ�㣺"+values[0]+"<br><font color=red>�ѷ������ã�"+values[1]+"</font><br><font color=green>�����з��ã�"+values[2]+"</font><br>";
	        	jQuery("#field"+dt1_hrmremain+"_"+indexno+"span").html(tempmsg); 
	        }
	        if(jQuery("#field"+dt1_deptremain+"_"+indexno+"span").length){
	        	var values = fnainfos[1].split(",");
	        	var tempmsg = "����Ԥ�㣺"+values[0]+"<br><font color=red>�ѷ������ã�"+values[1]+"</font><br><font color=green>�����з��ã�"+values[2]+"</font><br>";
	        	if(false && values.length>=4){
	        		tempmsg += "�ѷ���Ԥ�㣺"+values[3];
	        	}
	        	jQuery("#field"+dt1_deptremain+"_"+indexno+"span").html(tempmsg); 
	        }
	        if(jQuery("#field"+dt1_subcomremain+"_"+indexno+"span").length){
	        	var values = fnainfos[2].split(",");
	        	var tempmsg = "����Ԥ�㣺"+values[0]+"<br><font color=red>�ѷ������ã�"+values[1]+"</font><br><font color=green>�����з��ã�"+values[2]+"</font><br>";
	        	if(false && values.length>=4){
	        		tempmsg += "�ѷ���Ԥ�㣺"+values[3];
	        	}
	        	jQuery("#field"+dt1_subcomremain+"_"+indexno+"span").html(tempmsg); 
	        }
		}
	});	
}

//�Ƿ���Ԥ�����
function ifopencontrol(){
	  var returnval = false;
		jQuery.ajax({
			url : "/fna/budget/FnaControlAjax.jsp",
			type : "post",
			async : false,
			processData : false,
			dataType : "html",
			success: function do4Success(msg){
				if("true"==msg.trim()){
					returnval = true;
				}
			}
		});	
	  return returnval;
}

//Ԥ���Ƿ񳬳�
//budgetfeetypeid ��Ŀ=dt1_subject ��������=dt1_organizationtype ������λ=dt1_organizationid ���÷�������=dt1_budgetperiod ������=dt1_applyamount 
function fnaifover(){
	var returnval = "3";
	var temprequestid = "0";
	if(jQuery("#requestid").length){
		temprequestid = jQuery("#requestid").val();
	}
	var indexnum0 = _get_indexnum0();
	var poststr = "";
	for(var i=0;i<=indexnum0;i++){
		try{
			if(jQuery("#field"+dt1_subject+"_"+i).length){
			    var budgetfeetype = jQuery("#field"+dt1_subject+"_"+i).val();//��Ŀ dt1_subject
			    if(budgetfeetype==""){
				    return false;
				}
			    var orgtype = "";//�������� dt1_organizationtypevar orgtype = "";
				if(jQuery("#disfield"+dt1_organizationtype+"_"+i).length){
					orgtype = jQuery("#disfield"+dt1_organizationtype+"_"+i).val();
				}else if(jQuery("#field"+dt1_organizationtype+"_"+i).length){
					orgtype = jQuery("#field"+dt1_organizationtype+"_"+i).val();
				}else{
					orgtype = jQuery("input[name='field"+dt1_organizationtype+"_"+i+"']").val();
				};
			    if(orgtype==""){
				    return false;
				}
			    var orgid = jQuery("#field"+dt1_organizationid+"_"+i).val();//������λ dt1_organizationid
			    if(orgid==""){
				    return false;
				}
			    var applydate = jQuery("#field"+dt1_budgetperiod+"_"+i).val();//�������� dt1_budgetperiod
			    if(applydate==""){
				    return false;
				}
			    var applyamount = jQuery("#field"+dt1_applyamount+"_"+i).val();//ʵ����� dt1_applyamount
			    if(applyamount==""){
				    return false;
				}
			    poststr += "|"+budgetfeetype+","+ orgtype+","+ orgid+","+ applydate+","+applyamount
		    }
		}catch(e){
		}
	}
	if(poststr!=""){
		poststr =poststr.substr(1);
	}else{
		return "11111";
	}
	jQuery.ajax({
		url : "/fna/budget/FnaBudgetIfOverAjax.jsp",
		type : "post",
		async : false,
		processData : false,
		data : "poststr="+poststr+"&requestid="+temprequestid,
		dataType : "html",
		success: function do4Success(msg){
			//0 ok  1 ����������Ԥ����! 2Ԥ�������״̬Ϊ���رա�/δ��Ч�����̲����ύ����! 3 error �����ύ
			var tempreturnval = msg.trim();
			if(tempreturnval=="0"){
				returnval = "0";
			}
			if(tempreturnval=="1"){
				returnval = "1";
			}
			if(tempreturnval=="2"){
				//alert("Ԥ�������״̬Ϊ�رգ����̲����ύ����!");
				returnval = "2";
			}				
		}
	});	
	return returnval;
}
</script>