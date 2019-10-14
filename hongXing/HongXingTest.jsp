<%@ page import="org.apache.commons.lang.StringUtils" %>
<%@ page import="weaver.conn.RecordSet" %>
<%@ page import="weaver.formmode.setup.ModeRightInfo" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea" %>
<%@ taglib uri="/WEB-INF/tld/browser.tld" prefix="brow" %>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page"/>
<script type="text/javascript" src="/js/select/script/jquery-1.8.3.min_wev8.js"></script>
<%@ include file="/systeminfo/init_wev8.jsp" %>

<%
    String id = request.getParameter("id");
    RecordSet maxSet = new RecordSet();
    maxSet.executeSql("select max(id) id from UF_XSFP");

    int maxId = 0;
    if (maxSet.next()) {
        maxId = maxSet.getInt("id");
    }
    //设置权限
    ModeRightInfo modeRightInfo = new ModeRightInfo();
    modeRightInfo.setNewRight(true);
    modeRightInfo.editModeDataShare(1, 243, Integer.parseInt(id));//创建人id， 模块id， 该条数据id
%>





