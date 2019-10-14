<%@ page import="weaver.conn.RecordSet" %>
<%@ page import="weaver.general.BaseBean" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page"/>

<%
    String id = request.getParameter("id");
    new BaseBean().writeLog("BaoXiaoBack.jsp 收到id： " + id);
    RecordSet recordSet = new RecordSet();
    recordSet.executeQuery("select SUPFCCID from FNACOSTCENTER where id = " + id);
    int ccid = 0;
    if (recordSet.next()) {
        ccid = recordSet.getInt("SUPFCCID");
    }
    out.clear();
    out.print(ccid);
%>