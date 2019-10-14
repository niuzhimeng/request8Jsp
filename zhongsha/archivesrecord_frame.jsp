
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.general.BaseBean" %>
<%@ page import="weaver.conn.RecordSet" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="RecordSetCT" class="weaver.conn.RecordSet" scope="page" />
<%@ taglib uri="/browserTag" prefix="brow"%>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="PageUtil" class="com.weavernorth.OA2archives.util.PageUtil" scope="page"/>

<HTML><HEAD>
	<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css></HEAD>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<script language=javascript src="/js/ecology8/docs/docExt_wev8.js"></script>
<script language=javascript src="/js/ecology8/docs/docSearchInit_wev8.js"></script>
<%
	int userId = user.getUID();
	String flowTitle = Util.null2String(request.getParameter("flowTitle2"));

	int subCompanyId = user.getUserSubCompany1();

	//流程标题
	String chinesetitle = Util.null2String(request.getParameter("chinesetitle"));
	//流程编号
	String  workcode = Util.null2String(request.getParameter("workcode"));
	//归档开始日期
	String startdate = Util.null2String(request.getParameter("startdate"));
	//归档结束日期
	String enddate = Util.null2String(request.getParameter("enddate"));
	//归档是否成功  0 成功  1失败 2未上传
	String isover = Util.null2String(request.getParameter("isover"));
	String creatertype = Util.null2String(request.getParameter("creatertype"));
	//接收的部门
	String department = Util.null2String(request.getParameter("department"));
	//归档报表类型查询对应关系表中的数据id
	String workflowid = Util.null2String(request.getParameter("workflowid"));
	String departmentStr = "";

	//归档人
	String sender  = Util.null2String(request.getParameter("sender"));
	//归档是否成功
	String isover1 = Util.null2String(request.getParameter("isover1"));
	String sqlwhere = " where 1=1 " ;

	//流程标题
	if (!chinesetitle.equals("")) {
		sqlwhere += " and c_chinese_title like '%" + chinesetitle + "%' ";
	}
	//归档人
	if (!sender.equals("")) {
		sqlwhere += " and c_archive_owner = '" + sender + "' ";
	}
	if (!department.equals("")) {
		sqlwhere += " and c_archive_org = '" + department + "' ";
	}
	if (!startdate.equals("")) {
		sqlwhere += " and c_archive_date &gt;= '" + startdate + "' ";
	}
	if (!enddate.equals("")) {
		sqlwhere += " and c_archive_date &lt;= '" + enddate + "' ";
	}
	if (!"".equals(isover)) {
		sqlwhere += " and upload_status = '" + isover + "'";
	}
	if (!"".equals(workcode)) {
		sqlwhere += " and object_name like '%" + workcode + "%'";
	}




//int pagenum=Util.getIntValue(request.getParameter("pagenum"),1);
//int	perpage=10;
%>

<%
	String imagefilename = "/images/hdMaintenance_wev8.gif";
//搜索:车辆信息
	String titlename = "流程信息归档查询";
	String needfav ="1";
	String needhelp ="";

%>
<BODY>

<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
	RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:doSearch(),_self} " ;//搜索
	RCMenuHeight += RCMenuHeightStep ;
	RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",archivesrecord_frame.jsp,_self} " ;//返回
	RCMenuHeight += RCMenuHeightStep ;


	//增加右键导出功能
	RCMenu += "{"+ SystemEnv.getHtmlLabelName(17416, user.getLanguage()) + ",javascript:exportExcel(),_top}";
	RCMenuHeight += RCMenuHeightStep;


%>
<%!
	//根据建模表单->归档报表类型查询对应关系表，获取流程类型名称
	public String getWorkflowType(String ids){
		RecordSet rs = new RecordSet();
		StringBuilder result = new StringBuilder();
		for (String id : ids.split(",")){
			rs.executeSql("select wfname from uf_dagdlx where id ="+id);
			if(rs.next()){
			    result.append(rs.getString("wfname")).append(",");
			}
		}
		return result.toString();
	}
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<table id="topTitle" cellpadding="0" cellspacing="0" >
	<tr>
		<td class="rightSearchSpan">
			<input type="text" class="searchInput" value="<%=flowTitle%>" id="flowTitle" name="flowTitle"/>
			&nbsp;&nbsp;<!-- 高级搜索 -->
			<span id="advancedSearch" class="advancedSearch"><%=SystemEnv.getHtmlLabelName(21995, user.getLanguage())%></span>&nbsp;&nbsp;
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span><!-- 菜单 -->
		</td>
	</tr>
</table>
<div class="advancedSearchDiv" id="advancedSearchDiv" style="display:hide;overflow: auto" >
	<form id="frmmain" NAME="frmmain" STYLE="margin-bottom:0" action="" method=post>
		<iframe id="selectChange" frameborder=0 scrolling=no src=""  style="display:none"></iframe>
		<input type="hidden" name="flowTitle2" value="<%=flowTitle%>">
		<wea:layout type="4col">
			<wea:group context="" attributes="{groupDisplay:none}">
				<wea:item>流程类型</wea:item>
				<%--<wea:item>--%>
					<%--<select class=inputstyle name=modeType id="modeType" style='height:25px;'>--%>
						<%--<option value="0" <%if(modeType.equals("0")){%>selected <%}%>>公文类型</option>--%>
						<%--<option value="1" <%if(modeType.equals("1")){%>selected <%}%>>合同类型</option>--%>
						<%--&lt;%&ndash;<option value="2" <%if(modeType.equals("2")){%>selected <%}%>>预结算类型</option>&ndash;%&gt;--%>
						<%--<option value="3" <%if(modeType.equals("3")){%>selected <%}%>>服务采购类型</option>--%>
						<%--<option value="4" <%if(modeType.equals("4")){%>selected <%}%>>MOC类型</option>--%>
						<%--<option value="5" <%if(modeType.equals("5")){%>selected <%}%>>授权管理类型</option>--%>
					<%--</select>--%>
				<%--</wea:item>--%>

				<wea:item>
					<brow:browser viewType="0" name="workflowid"
								  browserOnClick="" browserValue='<%=workflowid%>'
								  browserUrl="/systeminfo/BrowserMain.jsp?url=/interface/MultiCommonBrowser.jsp?type=browser.gdlx"
								  hasInput="true" isSingle="false" hasBrowser="true" isMustInput='1' width="300px"
								  browserSpanValue='<%=getWorkflowType(workflowid)%>' completeUrl="/data.jsp"
					></brow:browser>
				</wea:item>

				<wea:item>流程名称</wea:item>
				<wea:item>
					<INPUT type="text" class=Inputstyle name="chinesetitle" value="<%=chinesetitle%>">
				</wea:item>
				<wea:item>流程编号</wea:item>
				<wea:item>
					<INPUT type="text" class=Inputstyle name="workcode" value="<%=workcode%>">
				</wea:item>
				<wea:item>归档人</wea:item>
				<wea:item>
					<brow:browser viewType="0" name="sender" id="sender" browserValue='<%=sender%>'
								  browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp"
								  hasInput="true"  width="150px" isSingle="false" hasBrowser ='true' isMustInput='1'
								  completeUrl="/data.jsp"
								  browserSpanValue='<%=sender.length()>0?Util.toScreen(ResourceComInfo.getMulResourcename(sender),user.getLanguage()):""%>'>
					</brow:browser>
				</wea:item>
				<wea:item>归档部门</wea:item>
				<wea:item>
					<brow:browser viewType="0" name="department" id="department" browserValue='<%=department%>'
								  browserurl="/systeminfo/BrowserMain.jsp?mouldID=hrm&url=/hrm/company/DepartmentBrowser.jsp?selectedids="
								  hasInput="true" width="150px" isSingle="false" hasBrowser = "true" isMustInput='1'
								  completeUrl="/data.jsp?type=4"
								  browserSpanValue='<%=department.length()>0?Util.toScreen(DepartmentComInfo.getDepartmentNames(department),user.getLanguage()):""%>'>
					</brow:browser>
				</wea:item>

				<wea:item>归档日期</wea:item>
				<wea:item>
					<%=SystemEnv.getHtmlLabelName(348,user.getLanguage())%>&nbsp;&nbsp;<!-- 从 -->
					<input id="startdate" name="startdate" value="<%=startdate%>" type="hidden" class=wuiDate  ></input>
					<%=SystemEnv.getHtmlLabelName(349,user.getLanguage())%>&nbsp;&nbsp;<!-- 到 -->
					<input id="enddate" name="enddate" value="<%=enddate%>" type="hidden" class=wuiDate />
				</wea:item>

				<wea:item>归档是否成功</wea:item>
				<wea:item>
					<select class=inputstyle name=isover id="isover" style='height:25px;'>
						<option value="" ></option>
						<option value="0" <%if(isover.equals("0")){%>selected <%}%>>归档成功</option>
						<option value="1" <%if(isover.equals("1")){%>selected <%}%>>归档失败</option>
						<option value="2" <%if(isover.equals("2")){%>selected <%}%>>未归档</option>
					</select>
				</wea:item>
			</wea:group>
			<wea:group context="">
				<wea:item type="toolbar">
					<input type="submit" class="e8_btn_submit" value="<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%>" id="searchBtn"/><!-- 搜索 -->
					<input type="button" value="<%=SystemEnv.getHtmlLabelName(2022,user.getLanguage())%>" class="e8_btn_cancel" onclick="resetCondtion();"/><!-- 重置 -->
					<input type="button" value="<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%>" class="e8_btn_cancel" id="cancel"/><!-- 取消 -->
				</wea:item>
			</wea:group>
		</wea:layout>
	</form>
</div>

<%
	String tableString = "";
		RecordSet rs = new RecordSet();
		StringBuilder wfid = new StringBuilder();
		if(workflowid.equals("")){  //根据归档报表类型查询对应关系表查询真正的流程id，为空查询全部
			rs.executeSql("select wfid from uf_dagdlx where wfname='全部'");
			if(rs.next()){
				wfid.append(rs.getString("wfid"));
			}
		}else{  //不为空按条件进行查询
			String[] idArray = workflowid.split(",");
			for(String id : idArray){
				rs.executeSql("select wfid from uf_dagdlx where id="+id);
				if(rs.next()){
					wfid.append(rs.getString("wfid")).append(",");
				}
			}
			//去掉末尾","
			wfid = new StringBuilder(wfid.substring(0,wfid.lastIndexOf(",")));
		}

	
//	sqlwhere +=" and t2.currentnodetype='3'  and t2.requestid = t1.requestid and t2.requestid=t3.requestid and t3.isremark=4";
	sqlwhere +=" and t2.currentnodetype='3'  and t2.requestid = t1.requestid and t2.requestid=t3.requestid and t3.isremark=4 and t2.workflowid in ("+wfid.toString()+")";

	String strPageId="wn_oa2emc_document_and_wn_oa2emc_contract";
	String backfields = "  id,requestid,c_doc_code,object_name,c_issue_num,c_chinese_title,c_archive_org,c_archive_owner,receivedate,upload_status,workflowid ";
	String fromSql  = " from (\n" +
			" select distinct t1.id as id,t1.requestid as requestid,null as c_doc_code, t1.object_name as object_name,t1.c_issue_num as c_issue_num,t1.c_chinese_title as c_chinese_title,t1.c_archive_org as c_archive_org,t1.c_archive_owner as c_archive_owner,t3.receivedate as receivedate,t1.upload_status as upload_status,t2.workflowid from   wn_oa2emc_document t1,workflow_requestbase t2,workflow_currentoperator t3 "+sqlwhere+"\n" +
			" union\n" +
			" select distinct  t1.id as id ,t1.requestid as requestid,t1.c_doc_code as c_doc_code,t1.object_name as object_name,null as c_issue_num,t1.c_chinese_title as c_chinese_title,t1.c_resp_dept as c_archive_org,t1.c_archive_owne as c_archive_owner,t3.receivedate as receivedate,t1.upload_status as upload_status,t2.workflowid from wn_oa2emc_contract  t1,workflow_requestbase t2,workflow_currentoperator t3 "+sqlwhere+"\n" +
			" ) A";
	String orderby = " id" ;
	//String groupby = " ";
	//out.print("select "+ backfields +" "+fromSql+" "+sqlwhere+" order by"+orderby);
	tableString =" <table  tabletype=\"none\" pageId=\""+strPageId+"\" pagesize=\""+PageIdConst.getPageSize(strPageId,user.getUID())+"\" >"+
			"		<sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\" sqlwhere=\""+Util.toHtmlForSplitPage(" 1=1")+"\"  sqlorderby=\""+orderby+"\"  sqlprimarykey=\"id\" sqlsortway=\"desc\" sqlis=\"false\"/>"+
			"		<head>"+
			"			<col width=\"25%\"   text=\""+"流程名称"+"\" column=\"c_chinese_title\" orderkey=\"c_chinese_title\" otherpara=\"column:requestid\" href=\"/workflow/request/ViewRequest.jsp\" linkkey=\"requestid\" linkvaluecolumn=\"requestid\"\n/>"+
			"			<col width=\"0%\"   text=\""+"requestid"+"\" column=\"requestid\" />"+
			"			<col width=\"17%\"   text=\""+"流程类型"+"\" column=\"workflowid\" orderkey=\"workflowid\" transmethod=\"weaver.workflow.workflow.WorkflowComInfo.getWorkflowname\" />"+
			"			<col width=\"17%\"   text=\""+"流程编号"+"\" column=\"object_name\" orderkey=\"object_name\" />"+
			"			<col width=\"17%\"   text=\""+"归档人"+"\" column=\"c_archive_owner\"  orderkey=\"c_archive_owner\" transmethod=\"weaver.hrm.resource.ResourceComInfo.getResourcename\"  linkvaluecolumn=\"c_archive_owner\"  linkkey=\"id\" href=\"/hrm/HrmTab.jsp?_fromURL=HrmResource\" target=\"_fullwindow\" />"+
			"			<col width=\"12%\"   text=\""+"归档部门"+"\" column=\"c_archive_org\" orderkey=\"c_archive_org\" transmethod=\"weaver.hrm.company.DepartmentComInfo.getDepartmentname\" href=\"/hrm/HrmTab.jsp?_fromURL=HrmDepartmentDsp\"  linkkey=\"id\" target=\"_fullwindow\" />"+
			"			<col width=\"12%\"   text=\""+"归档日期"+"\" column=\"receivedate\" orderkey=\"receivedate\"  />"+
			"			<col width=\"12%\"   text=\""+"归档是否成功"+"\" column=\"upload_status\" orderkey=\"upload_status\" transmethod=\"com.weavernorth.OA2archives.util.PageUtil.getIsSuccess\" />"+
			"		</head>"+
			"</table>";


%>
<wea:SplitPageTag isShowTopInfo="true"  tableString='<%=tableString%>'  mode="run" />

<script language=vbs>
sub getStartDate()
	returndate = window.showModalDialog("/systeminfo/Calendar.jsp",,"dialogHeight:320px;dialogwidth:275px")
	document.all("startdatespan").innerHtml= returndate
	document.all("startdate").value=returndate
end sub

sub getEndDate()
	returndate = window.showModalDialog("/systeminfo/Calendar.jsp",,"dialogHeight:320px;dialogwidth:275px")
	document.all("enddatespan").innerHtml= returndate
	document.all("enddate").value=returndate
end sub
</script>
<script language=javascript>
    var diag_vote;
    function doSearch(){
        document.frmmain.action="archivesrecord_frame.jsp";
        document.frmmain.submit();
    }
    function doDel(){
        if(isdel()){
            document.frmmain.submit();
        }
    }
    function onBtnSearchClick(){
        document.frmmain.flowTitle2.value = jQuery("#flowTitle").val();
        document.frmmain.chinesetitle.value = jQuery("#flowTitle").val();
        jQuery("#frmmain").submit();
    }
    function closeDlgARfsh(){
        diag_vote.close();
        doSearch();
    }

    function exportExcel(){
        _xtable_getAllExcel();
    }
</script>
</body>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" src="/js/selectDateTime_wev8.js"></script>
</html>
