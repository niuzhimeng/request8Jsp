
<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.systeminfo.SystemEnv" %>
<%@ page import="weaver.hrm.HrmUserVarify" %>
<%@ page import="weaver.hrm.User" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="RequestLogIdUpdate" class="weaver.workflow.request.RequestLogIdUpdate" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />

<%
User user = HrmUserVarify.getUser (request , response) ;
if(user == null)  return ;

int workflowRequestLogId = Util.getIntValue(request.getParameter("workflowRequestLogId"),0);
String isSignMustInput= Util.null2String(request.getParameter("isSignMustInput"));
int formSignatureWidth = Util.getIntValue(request.getParameter("formSignatureWidth"),0);
int formSignatureHeight = Util.getIntValue(request.getParameter("formSignatureHeight"),0);
String isFromHtmlModel = Util.null2String(request.getParameter("isFromHtmlModel"));
String isFromWorkFlowSignUP= Util.null2String(request.getParameter("isFromWorkFlowSignUP"));
String opener="";
if(isFromWorkFlowSignUP.equals("1")){
	opener="opener.";
}

// 操作的用户信息

int userid=user.getUID();                   //当前用户id
String logintype = user.getLogintype();     //当前用户类型  1: 类别用户  2:外部用户
String username = "";

if(logintype.equals("1"))
	username = Util.toScreen(ResourceComInfo.getResourcename(""+userid),user.getLanguage()) ;
if(logintype.equals("2"))
	username = Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(""+userid),user.getLanguage());

   		boolean isSuccess  = RecordSet.executeProc("sysPhrase_selectByHrmId",""+userid); 
   		String workflowPhrases[] = new String[RecordSet.getCounts()];
   		int x = 0 ;
   		if (isSuccess) {
   			while (RecordSet.next()){
   				workflowPhrases[x] = Util.null2String(RecordSet.getString("phraseShort"));
   				x ++ ;
   			}
   		}

			if(workflowRequestLogId<=0){
				int intRecordId=RequestLogIdUpdate.getRequestLogNewId();
            	boolean bSuccess=false;
            	if("oracle".equalsIgnoreCase(RecordSet.getDBType())){
            		bSuccess=RecordSet.executeSql("insert into Workflow_FormSignRemark(requestLogId,remark) values("+intRecordId+",empty_clob())");
            	}else{
            		bSuccess=RecordSet.executeSql("insert into Workflow_FormSignRemark(requestLogId,remark) values("+intRecordId+",'')");
            	}
				if(bSuccess){
					workflowRequestLogId=intRecordId;
				}
			}
%>
		   <script  language="javascript">
		   <%=opener%>document.frmmain.workflowRequestLogId.value=<%=workflowRequestLogId%>;
			</script>

<%@ include file="/workflow/request/iWebRevisionConf.jsp" %>
<%
    String temStr = request.getRequestURI();
    temStr=temStr.substring(0,temStr.lastIndexOf("/")+1);

	String revisionServerUrl=temStr+revisionServerName;;
	String revisionClientUrl=temStr+revisionClientName;

	int RecordID=workflowRequestLogId;
	String UserName=username;
	String Consult_Enabled="1";

    String strInputList="";
	if(workflowPhrases.length>0){
		for (int i= 0 ; i <workflowPhrases.length;i++) {
			String workflowPhrase = workflowPhrases[i] ;
			if(workflowPhrase!=null&&!workflowPhrase.trim().equals("")){
				strInputList+=workflowPhrase+"\\r\\n";
			}
		}
		strInputList = Util.toScreenForJsBase(strInputList);
	}
%>

<script language=javascript>
// window.setInterval(function(){
	//if(window.console)console.log(document.frmmain.Consult.OpinionText);
// <%if(isSignMustInput.equals("1")){%>
//	if(!document.frmmain.Consult.DocEmpty || document.frmmain.Consult.OpinionText != ""){
//		$GetEle("remarkSpan").innerHTML = "";
//	}else{
		//$GetEle("remarkSpan").innerHTML = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>";
//	}
// <%}%>
//},1000);
//初始化名称为Consult的控件对象

function initializtion(){

  document.frmmain.Consult.WebUrl = "<%=revisionServerUrl%>";           //WebUrl:系统服务器路径，与服务器交互操作，如打开签章信息
  document.frmmain.Consult.RecordID = "<%=RecordID%>";           //RecordID:本文档记录编号

  document.frmmain.Consult.FieldName = "Consult";                //FieldName:签章窗体可以根据实际情况再增加，只需要修改控件属性 FieldName 的值就可以
  document.frmmain.Consult.UserName = "<%=UserName%>";           //UserName:签名用户名称
  document.frmmain.Consult.WebSetMsgByName("USERID","<%=user.getUID()%>");          //USERID:签名用户id
  document.frmmain.Consult.Enabled = "<%=Consult_Enabled%>";     //Enabled:是否允许修改，0:不允许 1:允许  默认值:1 
  document.frmmain.Consult.PenColor = "#FF0000";                	//PenColor:笔的颜色，采用网页色彩值  默认值:#000000 
  document.frmmain.Consult.BorderStyle = "0";                    //BorderStyle:边框，0:无边框 1:有边框  默认值:1 
  document.frmmain.Consult.EditType = "0";                       //EditType:默认签章类型，0:签名 1:文字  默认值:0 
  document.frmmain.Consult.ShowPage = "0";                       //ShowPage:设置默认显示页面，0:电子印章,1:网页签批,2:文字批注  默认值:0 
  document.frmmain.Consult.InputText = "";                       //InputText:设置署名信息，  为空字符串则默认信息[用户名+时间]内容 
  document.frmmain.Consult.PenWidth = "1";                        //PenWidth:笔的宽度，值:1 2 3 4 5   默认值:2 
  document.frmmain.Consult.FontSize = "14";                      //FontSize:文字大小，默认值:11
  document.frmmain.Consult.ShowMenu = "0";
  document.frmmain.Consult.SignatureType = "<%=SignatureType%>";                  //SignatureType:签章来源类型，0表示从服务器数据库中读取签章，1表示从硬件密钥盘中读取签章，2表示从本地读取签章，并与ImageName(本地签章路径)属性相结合使用  默认值:0}
  document.frmmain.Consult.InputList = "<%=strInputList%>"; //InputList:设置文字批注信息列表 
  document.frmmain.Consult.ShowUserListMenu = "true";			//签批用户列表是否显示，"true"为显示

  document.frmmain.Consult.CASignType = "<%=CASignType%>";//默认为不启用数字签名
  document.frmmain.Consult.SetFieldByName("DocEmptyJuggle",<%=DocEmptyJuggle%>);
}

function LoadSignature(){

	enableAllmenu();

    initializtion();                                              //js方式设置控件属性

    document.frmmain.Consult.LoadSignature();                              //调用签章数据信息
    document.frmmain.Consult.ImgWidth="<%=formSignatureWidth%>";
    document.frmmain.Consult.ImgHeight="<%=formSignatureHeight%>";

	displayAllmenu();

	return true;
}

if (window.addEventListener){
    window.addEventListener("load", LoadSignature, false);
}else if (window.attachEvent){
    window.attachEvent("onload", LoadSignature);
}else{
    window.onload=LoadSignature;
}

//作用：切换读取签章的来源方式  针对签章窗体Consult
function chgReadSignatureType(){
  if (document.frmmain.Consult.SignatureType=="1"){
    document.frmmain.Consult.SignatureType="0";
    alert("<%=SystemEnv.getHtmlLabelName(21436,user.getLanguage())%>");
  }else{
    document.frmmain.Consult.SignatureType="1";
    alert("<%=SystemEnv.getHtmlLabelName(21437,user.getLanguage())%>");
  }
}

var isDocEmpty=0;

/**
 * 目标字符串是否为空

 */
function isEmptyString(str) {
	if (str == null || str == undefined || str == "") {
		return true;
	}
	
	return false;
}
//作用：保存签章数据信息  
//保存流程：先保存签章数据信息，成功后再提交到DocumentSave，保存表单基本信息

function SaveSignature(){
//开启表单签章后不应校验必填
<%if(isSignMustInput.equals("1")){%>
	//判断签批区域是否为空内容 （检测范围包含当签章类型为文字时的输入内容）
    if(document.frmmain.Consult.DocEmpty && document.frmmain.Consult.OpinionText == ""){
        isDocEmpty=1;
        return false;
    }
<%}%>

  if (document.frmmain.Consult.Modify){                    //判断签章数据信息是否有改动

//    if(document.frmmain.Consult.SaveAsJpgEx('iWebRevision_abcd_wev8.jpg','All', 'Remote')){
//	  <%=opener%>document.frmmain.workflowRequestLogId.value=document.frmmain.Consult.WebGetMsgByName("RECORDID");
//	  document.frmmain.Consult.RecordID=document.frmmain.Consult.WebGetMsgByName("RECORDID");
      if (!document.frmmain.Consult.SaveSignature()){        //保存签章数据信息
          return false;
      }
//	}else {
//		return false;
//	}

  }
  <%=opener%>document.frmmain.workflowRequestLogId.value=document.frmmain.Consult.WebGetMsgByName("RECORDID");
  document.frmmain.Consult.RecordID=document.frmmain.Consult.WebGetMsgByName("RECORDID");
  return true;
}
//作用：保存签章数据信息  
//点击保存按钮时调用，不验证签章是否为空

function SaveSignature_save() {

	if (document.frmmain.Consult.Modify){                    //判断签章数据信息是否有改动

	//  if(document.frmmain.Consult.SaveAsJpgEx('iWebRevision_abcd_wev8.jpg','All', 'Remote')){
	//	  <%=opener%>document.frmmain.workflowRequestLogId.value=document.frmmain.Consult.WebGetMsgByName("RECORDID");
	//	  document.frmmain.Consult.RecordID=document.frmmain.Consult.WebGetMsgByName("RECORDID");
	    if (!document.frmmain.Consult.SaveSignature()){        //保存签章数据信息
	        return false;
	    }
	//	}else {
	//		return false;
	//	}	
	}
	<%=opener%>document.frmmain.workflowRequestLogId.value=document.frmmain.Consult.WebGetMsgByName("RECORDID");
	document.frmmain.Consult.RecordID=document.frmmain.Consult.WebGetMsgByName("RECORDID");
	return true;
}

jQuery(".ViewForm").bind('click',function(){
   if(document.frmmain.Consult.DocEmpty && document.frmmain.Consult.OpinionText == ""){
      jQuery(".signaturebyhand").css("display","none");
      jQuery("#remarkShadowDiv").css("display","");
      jQuery("#signrighttool").css("display","none");
      jQuery("#signtabtoolbar").css("display","none");
   }
});
<%
	//System.err.println("select remark from workflow_formsignremark where requestLogId = " + RecordID);
	RecordSet.executeSql("select remark from workflow_formsignremark where requestLogId = " + RecordID);
    if(RecordSet.next()){
    //	System.err.println("remark:"+RecordSet.getString("remark"));
    	if(null!=RecordSet.getString("remark")&&!"".equals(RecordSet.getString("remark").trim())){
    		%>
    		  jQuery(document).ready(function(){
    		  		jQuery("#remarkShadowDiv1").trigger("click");
    		  });
    		<%
    	}
    }
%>
</script>
<style type="text/css">
  #consulttab{
    height: 110px;
  }
  #tooltab {
    border:#ccc 1px solid;
  }
  #tooltab a,#tooltab span{
  	FONT-SIZE: 9pt;
  	COLOR: #999; 
  	FONT-FAMILY: "宋体";
  	cursor:pointer;
  	TEXT-DECORATION: none;
  	margin-right:15px;
  }
  #tooltab img{
    cursor: pointer;
  }
  #DivID {
  	border:0px solid #cccccc;
  	border-right:0px;
  	border-top:0px;
  }
  #Consult{
    margin:0px 0px;
  }
</style>
<%
String isIE = (String)session.getAttribute("browser_isie");
if ("true".equals(isIE)) {
%>
   <div id="consultdiv" style="width:100%;height:<%=formSignatureHeight-1%>px;">
          <table id="tooltab" height="30px" cellspacing="0" cellpadding="0" align="center" style="width:inherit ;padding:0px;background:rgb(240, 240, 238);margin-left:5px;<%if(isFromHtmlModel.equals("0")){%>display:none;<%}%>">
          <tbody >
          <tr  height='30px'>
            <td style="vertical-align: middle;">			  
			  <img src="/images/sign/opensign_wev8.png" style="vertical-align: middle;" onClick="if (!Consult.OpenSignature()){alert(Consult.Status);}">
			  <a title="" onClick="if (!Consult.OpenSignature()){alert(Consult.Status);}" style="vertical-align: middle;">
			  	<%=SystemEnv.getHtmlLabelName(21431,user.getLanguage())%>
			  </a>
			  
			  <img src="/images/sign/filesign_wev8.png" style="vertical-align: middle;" onclick="if (Consult.EditType==0){Consult.EditType=1;}else{Consult.EditType=0;};">
			  <a onclick="if (Consult.EditType==0){Consult.EditType=1;}else{Consult.EditType=0;};" style="vertical-align: middle;">
			  	<%=SystemEnv.getHtmlLabelName(21441,user.getLanguage())%>
			  </a>
			  
			  <img src="/images/sign/signlist_wev8.png" style="vertical-align: middle;" onClick="Consult.ShowSignature();">
			  <a title="" onClick="Consult.ShowSignature();" style="vertical-align: middle;">
			  	<%=SystemEnv.getHtmlLabelName(21432,user.getLanguage())%>
			  </a>
			  
			  <img src="/images/sign/cancel_wev8.png" style="vertical-align: middle;" onclick="Consult.Clear();">
			  <a onclick="Consult.Clear();" style="vertical-align: middle;">
			  	<%=SystemEnv.getHtmlLabelName(21433,user.getLanguage())%>
			  </a>
			  
			  <img src="/images/sign/cancelbox_wev8.png" style="vertical-align: middle;" onclick="Consult.ClearAll();">
			  <a onclick="Consult.ClearAll();" style="vertical-align: middle;">
			  	<%=SystemEnv.getHtmlLabelName(21434,user.getLanguage())%>
			  </a>
			  
			  <img src="/images/sign/trigger_wev8.png" style="vertical-align: middle;" onclick="chgReadSignatureType();">
			  <a onclick="chgReadSignatureType();" style="vertical-align: middle;">
			  <%=SystemEnv.getHtmlLabelName(21435,user.getLanguage())%>
			  </a>
            </td>
          </tr>
          </tbody>
          </table>

          <table  id="consulttab" width="<%=formSignatureWidth%>px" height="<%=formSignatureHeight%>px"  cellspacing="0" cellpadding="0" align="left">
          <tbody >
          <tr>
            <td id="formSignatureTd" style="border: 1px solid #ccc;border-top: 0px;">
				<script>
				var str = '';
				str += '<div id="DivID" style="height:<%=formSignatureHeight%>px;width:100%;" >';
				str += '<OBJECT id="Consult" width="<%=formSignatureWidth%>px" height="<%=formSignatureHeight-2%>px" classid="<%=revisionClassId%>" codebase="<%=revisionClientUrl%>" >';
				str += '</object>';
				str += '</div>';
				document.write(str);
				</script>
            </td>
          </tr>
          </tbody>
          </table>
       </div>
<%
} else {
%>
<table style="border: 1px solid #ccc;border-right:0px;border-top:0px;" width="<%=formSignatureWidth%>px" height="<%=formSignatureHeight+1%>px"  cellspacing="0" cellpadding="0" align="left">
    <tr  height='100%'>
    	<td height="100%" width="100%" align="center" style="color:red;font-size:14px;">
			 <%=SystemEnv.getHtmlLabelName(124846,user.getLanguage())%> 
        </td>
    </tr>
</table>

<%
}
%>
              <span id="remarkSpan">
<%
	if(isSignMustInput.equals("1")){
%>
     <!-- 
			  <img src="/images/BacoError_wev8.gif" align=absmiddle>
	 -->
<%
	}
%>
              </span>
          <input type=hidden name="remark" value="">
          
<script type="text/javascript">
   //判断IE浏览器是否安装金格插件

   jQuery(window).bind("load",function(){
   	   if(JinGeController() == false&&jQuery.browser.msie){
   	   	  alert("<%=SystemEnv.getHtmlLabelName(84531,user.getLanguage())%>");
   	   }
   });
   
   function JinGeController(){
     try{
     	if(eval("document.frmmain.Consult.DocEmpty") == undefined){
     	   return false;
     	}else{
     	   return true;
     	}
     }catch(e){
     	return false;
     }
   }
</script>