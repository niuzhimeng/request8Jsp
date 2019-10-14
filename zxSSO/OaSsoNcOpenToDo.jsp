<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page"/>
<%@ page import="weaver.conn.RecordSet" %>
<%@ page import="weaver.hrm.HrmUserVarify" %>
<%@ page import="weaver.hrm.User" %>
<%@ page import="weaver.general.BaseBean" %>


<%
    response.setHeader("cache-control", "no-cache");
    response.setHeader("pragma", "no-cache");
    response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");
    //流程id
    String flowId = request.getParameter("flowid");
    BaseBean baseBean = new BaseBean();
    RecordSet recordSet = new RecordSet();
    User user = HrmUserVarify.getUser (request , response) ;
    recordSet.execute("select * from hrmresource where id = " + user.getUID());
    String usercode = "";
    if (recordSet.next()) {
        usercode = recordSet.getString("workcode");
    }
    String url = "http://10.31.1.31:802/portalsso/OpenPortalMsgServlet?usercode=" + usercode + "&msgid=" + flowId;
    baseBean.writeLog("OA_SSO_NC 单点打开待办 URL->" + url);

    response.sendRedirect(url);
%>



