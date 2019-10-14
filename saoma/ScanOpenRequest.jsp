
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.TimeUtil"%><%--xwj for td2551 20050822--%>
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="WorkTypeComInfo" class="weaver.workflow.workflow.WorkTypeComInfo" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rsCheck" class="weaver.conn.RecordSet" scope="page" /><%--xwj for td2551 20050902--%>
<jsp:useBean id="rsCheck_" class="weaver.conn.RecordSet" scope="page" /><%--xwj for td2551 200509022--%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@page import="org.apache.commons.lang.StringEscapeUtils"%>
<%@ page import="weaver.workflow.workflow.WorkflowBillComInfo" %>
<%@ page import="weaver.workflow.workflow.WorkflowComInfo" %>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type="text/css" rel="STYLESHEET">
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></SCRIPT>
<style type="text/css">
#rangetypespan{
 height:20px!important;
 overflow: hidden;
}
</style>
</HEAD>

<%
String sql="";
String requestmark = Util.null2String(request.getParameter("requestmark"));
if(!requestmark.equals("")){//客户要求根据requestid进行查询
	sql = "select * from workflow_requestbase where requestid='"+StringEscapeUtils.escapeSql(requestmark)+"'";
	RecordSet.executeSql(sql);
	if(RecordSet.next()){
		//主流程id
		String requestid = Util.null2String(RecordSet.getString("requestid"));
		String workflowid = Util.null2String(RecordSet.getString("workflowid"));
		//打开主流程
%>
		<script language="javascript">
		window.open("/workflow/request/ViewRequest.jsp?requestid=<%=requestid %>&isovertime=0&isscan=1");
		</script>
 
<%	
	}
}
%>

 

<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(18461,user.getLanguage());
String needfav ="1";
String needhelp ="";

%>

<body>

<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>

<%
RCMenu += "{查询,javascript:doSearch(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>

<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
 
<FORM id=weaver name=weaver method=post action="ScanOpenRequest.jsp">
<input type="hidden" name="src" id="src">
	<wea:layout>
		<wea:group context="扫描查询">
		<wea:item attributes="{'isTableList':'true'}">	
			<table  id="table" class="ListStyle"  width="100%">
		     <tr >
		       <td height="44" class="fieldName" width="160px"> 
		       流程编号
		       </td>
		       <td	class="field" colspan="3">
			      <input type="text"  name="requestmark" id ="requestmark"  value="" onkeypress="javascript:enterKey()" />  
  				</td>
		     </tr>
		   </table>	
		</wea:item>	
		</wea:group>
	</wea:layout>
</FORM>
</body>
<script language="javascript">
//给流程编号输入框设置光标焦点
document.getElementById("requestmark").focus();

//提交表单查询
function doSearch(){

	document.weaver.submit();
}

//监控回车键，是回车，就提交表单
function enterKey(){	
	if (event.keyCode == 13){
		doSearch();
	}
}

</script> 
<SCRIPT language="javascript" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
<SCRIPT language="javascript" src="/js/selectDateTime_wev8.js"></script>
</html>
