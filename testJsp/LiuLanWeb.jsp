<%@ page import="weaver.conn.RecordSet" %>
<%@ page import="weaver.general.BaseBean" %>
<%@ page language="java" contentType="text/html; charset=gbk" %>
<jsp:useBean id="RequestManager" class="weaver.workflow.request.RequestManager" scope="page"/>
<jsp:useBean id="flowDocss" class="weaver.workflow.request.RequestDoc" scope="session"/>
<jsp:useBean id="DocComInfo" class="weaver.docs.docs.DocComInfo" scope="page"/>
<jsp:useBean id="Doccoder" class="weaver.docs.docs.DocCoder" scope="page"/>

<%
    BaseBean baseBean = new BaseBean();
    String requestid = request.getParameter("requestid");
    RecordSet recordSet = new RecordSet();
    recordSet.execute("select glzd from formtable_main_17 where requestId = '" + requestid + "'");
    String glzd = "";
    if (recordSet.next()) {
        glzd = recordSet.getString("glzd");
    }
    String url = "/formmode/search/CustomSearchBySimple.jsp?customid=5&glj=" + glzd;
    baseBean.writeLog("接收到的requestid： " + requestid);
    baseBean.writeLog("转发请求的url=====： " + url);
    response.sendRedirect(url);
%>



