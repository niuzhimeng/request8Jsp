<%@ page import="weaver.conn.RecordSet" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<jsp:useBean id="RequestManager" class="weaver.workflow.request.RequestManager" scope="page"/>
<jsp:useBean id="flowDocss" class="weaver.workflow.request.RequestDoc" scope="session"/>
<jsp:useBean id="DocComInfo" class="weaver.docs.docs.DocComInfo" scope="page"/>
<jsp:useBean id="Doccoder" class="weaver.docs.docs.DocCoder" scope="page"/>
<%@ include file="/systeminfo/init_wev8.jsp" %>

<%
    BaseBean baseBean = new BaseBean();
    RecordSet recordSet = new RecordSet();
    baseBean.writeLog("OA_SSO_GEPS 接口执行--------------> " + TimeUtil.getCurrentTimeString());

    // 生成唯一ticket
    String ticket = UUID.randomUUID().toString().replace("-", "");

    // 插入或更新单点记录表
    RecordSet insertSet = new RecordSet();
    recordSet.executeQuery("select id from uf_sso_geps where userid = " + user.getUID());
    if (recordSet.next()) {
        insertSet.executeUpdate("update uf_sso_geps set ticket = ? where userid = ?", ticket, user.getUID());
    } else {
        insertSet.executeUpdate("insert into uf_sso_geps(userid, ticket) values(?,?)", user.getUID(), ticket);
    }

    String url = "http://219.143.196.153:8888/Services/Identification/Server/login.ashx?sso=1&ssoProvider=TicketSSO&service=%2findex.aspx&ticket=" + ticket;
    baseBean.writeLog("OA_SSO_GEPS 访问url： " + url);
    response.sendRedirect(url);
%>



















