<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="weaver.general.Util"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="java.util.*,weaver.hrm.appdetach.*"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" /> 

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="BaseBean" class="weaver.general.BaseBean" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="CompanyComInfo" class="weaver.hrm.company.CompanyComInfo" scope="page" />
<jsp:useBean id="departmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="AccountType" class="weaver.general.AccountType" scope="page" />
<jsp:useBean id="LicenseCheckLogin" class="weaver.login.LicenseCheckLogin" scope="page" />
<jsp:useBean id="synchrmresource" class="com.shunxinkonggu.sap.sycn.SyncHrmResource" scope="page"/>

<HTML>
<HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css>

<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>

<script language="javascript" src="/js/weaver_wev8.js"></script>
<script type="text/javascript" src="/appres/hrm/js/mfcommon_wev8.js"></script>
<script language=javascript src="/js/ecology8/hrm/HrmSearchInit_wev8.js"></script>
<style>
.checkbox {
	display: none
}
</style>
</HEAD>
<%
	//BaseBean.writeLog("向日志ecology文件写内容");
	LicenseCheckLogin.checkOnlineUser();//检测用户在线情况
	/*if (!HrmUserVarify.checkUserRight("Gongzd:ChaXun", user) ) { //权限判断   没有权限
		将该页面作为权限资源，需要在数据库中执行如下语句，并将具有该页面访问权限的角色添加此权限
		insert into SystemRights (id,rightdesc,righttype) values (-10001,'排班计划查询','0') 
		insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (-10001,7,'排班计划查询','排班计划查询')   
		insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (-10001,8,'Gongzd ChaXun','Gongzd ChaXun') 
		insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (-20001,'排班计划查询','Gongzd:ChaXun',-10001) 
		
		response.sendRedirect("/notice/noright.jsp"); 
		return;
	}*/
	//获取用户当前使用语言
	Integer lg=(Integer)user.getLanguage();
	weaver.general.AccountType.langId.set(lg);
	
	//搜索框 样式
	String imagefilename = "/images/hdReport_wev8.gif";
	String titlename = "组织人员同步";
	String needfav ="1";
	String needhelp ="";
	
	//获取搜索条件值
	String tongbfw = Util.null2String(request.getParameter("tongbfw"));   //同步类型
	int currentuser = user.getUID();//当前用户ID
	int thwidth = 1280;
		
%>
<script type="text/javascript">

	var common = new MFCommon();
	jQuery(document).ready(function(){
	//parent.setTabObjName("工资单查询");
	});

	//用户下线
	function forcedOffline(id){
		window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(81904,user.getLanguage())%>", function(){
			jQuery.ajax({
				url:"/js/hrm/getdata.jsp?cmd=userOffline&uid="+id,
				type:"post",
				async:false,
				complete:function(xhr,status){
						_table.reLoad();
				}
			});
		});
	}
</script>
<BODY>
<div id="tabDiv"><!-- 提示显示可收缩菜单 -->
	<span class="toggleLeft" id="toggleLeft" title="<%=SystemEnv.getHtmlLabelName(32814,user.getLanguage()) %>"><%=SystemEnv.getHtmlLabelName(20536,user.getLanguage()) %></span>
</div>

<div id="dialog">
 <div id='colShow'></div>
</div>

	<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
	<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
	<%
		RCMenu += "{"+"同步"+",javascript:onBtnSearchClick(),_self} " ;
		//System.out.println("RCMenu="+RCMenu); //右上角搜索按钮
		RCMenuHeight += RCMenuHeightStep ;
	%>
	<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %> 
	<FORM id=report name=report action=SynchronizedataResult.jsp method=post>
		<table id="topTitle" cellpadding="0" cellspacing="0">
			<tr>
				<td></td>
					<td class="rightSearchSpan" style="text-align:right;">
					<span id="advancedSearch" class="advancedSearch">手动同步</span>
					</td> 
			</tr>
		</table>
		<div class="advancedSearchDiv" id="advancedSearchDiv" ><!-- 默认隐藏搜索条件 -->
					
			<wea:layout type="2col">
			
				<!-- 搜索条件 -->
				<wea:group context="选择同步范围">
				    <wea:item>选择同步范围</wea:item>
				    <wea:item>
				    	<select name="tongbfw">
				    		<option value="" ></option>
				    		<option value="1" <% if(tongbfw.equals("1")) {%>selected<%}%> >分部</option>
				    		<option value="2" <% if(tongbfw.equals("2")) {%>selected<%}%> >部门</option>
				    		<option value="3" <% if(tongbfw.equals("3")) {%>selected<%}%> >职务类别</option>
				    		<option value="4" <% if(tongbfw.equals("4")) {%>selected<%}%> >职务</option>
				    		<option value="5" <% if(tongbfw.equals("5")) {%>selected<%}%> >岗位</option>
				    		<option value="6" <% if(tongbfw.equals("6")) {%>selected<%}%> >人员</option>
				    		<option value="7" <% if(tongbfw.equals("7")) {%>selected<%}%> >全部</option>
				    	</select>
				    </wea:item>
				    
				</wea:group>
				<!-- 搜索条件 -->

				<!-- 查询   重置  取消 按钮 -->
				<wea:group context="">
					<wea:item type="toolbar">
						<input type="button" value="同步" class="e8_btn_top_first" onclick="onBtnSearchClick();"/>
						<!-- <input type="button" value="<%=SystemEnv.getHtmlLabelName(31129,user.getLanguage())%>" class="e8_btn_cancel" id="cancel"/> ---->
					</wea:item>
				</wea:group>
				<!-- 查询  重置  取消 按钮 -->
				
			</wea:layout>
		</div>
	</FORM>

    <%
    	String logcontent = "请选择同步范围进行同步!";
 
		if(tongbfw.equals("1")){
			logcontent = synchrmresource.synSubcompany();
		}
		else if(tongbfw.equals("2")){
			logcontent = synchrmresource.synDepartment();
		}
		else if(tongbfw.equals("3")){
			logcontent = synchrmresource.synJobGroups();
		}
		else if(tongbfw.equals("4")){
			logcontent = synchrmresource.synActivities();
		}
		else if(tongbfw.equals("5")){
			logcontent = synchrmresource.synJobtitle();
		}
		else if(tongbfw.equals("6")){
			logcontent = synchrmresource.synHrmresource();
		}
		
		else if(tongbfw.equals("7")){
			synchrmresource.synSubcompany();
			logcontent += synchrmresource.synDepartment();
			logcontent += synchrmresource.synJobGroups();
			logcontent += synchrmresource.synActivities();
			logcontent += synchrmresource.synJobtitle();
			logcontent += synchrmresource.synHrmresource();
			logcontent += "分部 部门 职务类别 职务 岗位 人员 同步完成！";
		}
	
    %>

<!-- 表头调整 -->
<DIV id="_cloneWeaverTableDiv">
<TABLE style="table-layout: fixed;" class="ListStyle" cellSpacing="0" 
cellPadding="0">
  <COLGROUP>
  
  <COL style="display: none;" _display="none">
  <COL style="width: <%=thwidth %>px;" width="1%" _itemid="34" _systemid="7506">
  
  </COLGROUP>
  <THEAD>
  <TR class="HeaderForXtalbe">
  
    <TH style="height: 30px; overflow: hidden; border-right-color: transparent; border-right-width: 1px; border-right-style: solid; display: none; white-space: nowrap; word-break: keep-all; text-overflow: ellipsis;" 
    title="" align="left"></TH>
    <TH style="width: <%=thwidth %>px; height: 30px; overflow: hidden; border-right-color: transparent; border-right-width: 1px; border-right-style: solid; white-space: nowrap; word-break: keep-all; text-overflow: ellipsis; background-color: rgb(248, 248, 248);" 
    title="" align="left" _itemid="34" _systemid="7506">同步结果：</TH>
    
   </TR>
   </THEAD>
   </TABLE>
</DIV>

<!-- 结果内容调整 -->
<DIV style="background: rgb(255, 255, 255); padding: 0px; width: <%=thwidth %>%;" id="_xTable" class="_xTableSplit" valign="top">
 <DIV style="width: 100%;"><!-- 修改表格宽度 -->
 <DIV class="xTable_info xTable_infoTop"></DIV>
 <DIV hideFocus="" style="overflow: scroll; overflow-x: hidden; overflow-y: scroll; max-height: 502px;" 
class="table" tabIndex="5004">
<TABLE style="width: 100%; table-layout: fixed;" class="ListStyle" 
cellSpacing="0"><!-- 修改表格宽度 -->
  <COLGROUP>
  
  <COL style="display: none;" _display="none">
  <COL style="width: <%=thwidth %>px;" width="1%" _itemid="34" _systemid="7506">
  
  </COLGROUP>
  <THEAD style="display: none;">
  <TR class="HeaderForXtalbe">
  
    <TH style="height: 30px; overflow: hidden; display: none; white-space: nowrap; word-break: keep-all; text-overflow: ellipsis;" 
    title="" align="left"></TH>
    <TH style="width: <%=thwidth %>px; height: 30px; overflow: hidden; white-space: nowrap; word-break: keep-all; text-overflow: ellipsis;" 
    title="" align="left" _itemid="34" _systemid="7506">--</TH>
    
    </TR>
  </THEAD>
  <TBODY>
					
  <TR style="vertical-align: middle;">
    <TD style="width: 5%; height: 30px; display: none;">&nbsp;<INPUT style="display: none;" value="3" type="checkbox" checkboxId="3"></TD>
    
    <TD style="height: 30px; overflow: hidden; vertical-align: middle; white-space: nowrap; word-break: keep-all; text-overflow: ellipsis;" 
    title="同步结果" align="left">
    <%=logcontent %>
    </TD>
    
    </TR>

	  <TR style="height: 1px !important;" class="Spacing">
    <TD class="paddingLeft0Table" colSpan="6">
      <DIV class="intervalDivClass"></DIV>
	</TD>
  </TR></TBODY></TABLE>
  </DIV>
 </DIV>
</DIV>
	
<script type="text/javascript">
	
		//判断字符串是否为空
		function isNullOrEmpty(strVal) {
			if (strVal == '' || strVal == null || strVal == undefined) {
				return true;
			} else {
				return false;
			}
		}

		//提交
		function onBtnSearchClick() {
			report.submit();
		}

		function showColDialog(){
		 	var  dialog = new top.Dialog();
		   	dialog.currentWindow = window;
		   	dialog.okLabel = "<%=SystemEnv.getHtmlLabelName(30986,user.getLanguage())%>";
		   	dialog.cancelLabel = "<%=SystemEnv.getHtmlLabelName(31129,user.getLanguage())%>";
		   	dialog.Drag = true;
		   	dialog.Title = "<%=SystemEnv.getHtmlLabelName(32535,user.getLanguage())%>"; 
		   	dialog.Width = 600;
		   	dialog.Height = 400;
		   	dialog.URL = "/showCol.jsp";
			dialog.show();
		}

		//默认显示高级搜索内容
		<%if(tongbfw.equals("")){%>
			setTimeout(function (){
				var advancedSearchOuterDiv = jQuery("#advancedSearchOuterDiv");
				advancedSearchOuterDiv.show();
			   }, 500);
		<%}%>
		
</script>

</BODY>
</HTML>