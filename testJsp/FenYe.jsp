<%@ page language="java" import="java.util.*" pageEncoding="UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.*" %>
<%@ page import="weaver.conn.RecordSet" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea" %>
<%@ taglib uri="/browserTag" prefix="brow" %>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<html>
<head>
    <link href="/css/Weaver_wev8.css" type="text/css" rel="stylesheet">
    <link href="/js/ecology8/selectbox/css/jquery.selectbox_wev8.css" type="text/css" rel="stylesheet">
    <script language="javascript" src="/js/ecology8/selectbox/js/jquery.selectbox-0.2_wev8.js"></script>
    <script language="javascript" src="/js/browser/WorkFlowBrowser_wev8.js"></script>
    <script language="javascript" src="/js/datetime_wev8.js"></script>
    <script language="javascript" src="/js/selectDateTime_wev8.js"></script>
    <script language="javascript" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
    <SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
</head>
<body>
<!-- 条件页面内容 -->
<div>
    <wea:layout type="4col" attributes="{'expandAllGroup':'true'}">
        <wea:group context="数据列表">
            <wea:item attributes="{'isTableList':'true','colspan':'full'}">
                <%
                    int perpage = 10;
                    String backfields = "h.*";
                    String fromSql = " hrmresource h ";
                    String sqlWhere = "1=1";
                    String tableString = "" +
                            "<table instanceid=\"CptCapitalAssortmentTable\"  tabletype=\"none\"  pagesize=\"" + perpage + "\"  >" +
                            "<sql backfields=\"" + backfields + "\" sqlform=\"" + fromSql + "\" sqlprimarykey=\"id\" sqlsortway=\"asc\" sqldistinct=\"true\" sqlwhere = \"" + sqlWhere + "\"/>" +
                            "<head>" +
                            "<col width=\"50px\"  text=\"id\" column=\"id\" align=\"center\" />" +
                            "<col width=\"80px\"  text=\"姓名\"   column=\"lastname\" />" +
                            "<col width=\"100px\"  text=\"登录名\" column=\"loginid\" />" +
                            "<col width=\"80px\"  text=\"安全级别\" column=\"seclevel\" />" +
                            "<col width=\"80px\"  text=\"创建日期\" column=\"createdate\" />" +
//                                    "<col width=\"80px\"  text=\"累计售出（套）\" column=\"ljsct\"   transmethod='weaver.fna.general.FnaSplitPageTransmethod.fmtAmount' />"+
//                                    "<col width=\"80px\"  text=\"累计售出（平米）\" column=\"ljscpm\"  transmethod=\"weaver.fna.general.FnaSplitPageTransmethod.fmtAmount\"  />"+
//                                    "<col width=\"80px\"  text=\"累计回款（万元）\" column=\"ljhk\" transmethod=\"weaver.fna.general.FnaSplitPageTransmethod.fmtAmount\"  />"+
//                                    "<col width=\"100px\"  text=\"余额房数量（套）\" column=\"yefslt\"  />"+
//                                    "<col width=\"100px\"  text=\"余额房数量（平米）\" column=\"yefslpm\"  transmethod=\"weaver.fna.general.FnaSplitPageTransmethod.fmtAmount\"  />"+
//                                    "<col width=\"80px\"  text=\"售出率（套）\" column=\"sclt\"  />"+
//                                    "<col width=\"80px\"  text=\"售出率（平米）\" column=\"sclpm\"  transmethod=\"weaver.fna.general.FnaSplitPageTransmethod.fmtAmount\"  />"+
//                                    "<col width=\"80px\"  text=\"待回款（万元）\" column=\"dhk\"  transmethod=\"weaver.fna.general.FnaSplitPageTransmethod.fmtAmount\"  />"+
//                                    "<col width=\"100px\"  text=\"售出均价（万元/平米）\" column=\"scjj\"   transmethod='weaver.proj.util.ProjectTransUtil.getPrjTaskNameByStatus' />"+
//                                    "<col width=\"100px\"  text=\"待售均价（万元/平米）\" column=\"dsjj\"   transmethod='weaver.proj.util.ProjectTransUtil.getPrjTaskNameByStatus' />"+
//                                    "<col width=\"110px\"  text=\"签约状况-自售（套/平米）\" column=\"qyzkzs\"  transmethod='weaver.proj.util.ProjectTransUtil.getPrjTaskNameByStatus' />"+
//                                    "<col width=\"120px\"  text=\"签约状况-非自售（套/平米）\" column=\"qyzkfzs\"  transmethod='weaver.proj.util.ProjectTransUtil.getPrjTaskNameByStatus' />"+

                            "</head>" +
                            "</table>";
                %>
                <div id="SplitPageTag" style="width: 100%;">
                    <wea:SplitPageTag tableString='<%=tableString %>' mode="run"/>
                </div>
            </wea:item>
        </wea:group>
    </wea:layout>
</div>
</body>
</html>


