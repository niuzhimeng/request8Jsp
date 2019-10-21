<%@ page import="weaver.conn.RecordSet" %>
<%@ page import="weaver.general.BaseBean" %>
<%@ page import="weaver.general.TimeUtil" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.net.URLEncoder" %>
<%@ page import="java.util.UUID" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>

<%
    BaseBean baseBean = new BaseBean();
    RecordSet recordSet = new RecordSet();
    baseBean.writeLog("市政OpenToDoFlow.jsp 执行开始： " + TimeUtil.getCurrentTimeString());
    // 广联达地址
    String bsUrl = "http://219.143.196.153:8888/Services/Identification/Server/login.ashx?sso=1&ssoProvider=TicketSSO&service=";

    // 流程访问路径
    String flowUrl = Util.null2String(request.getParameter("flowUrl"));
    baseBean.writeLog("flowUrl: " + flowUrl);

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

    // 流程
    String flowUrlEnd = bsUrl + URLEncoder.encode(flowUrl, "utf-8") + "&ticket=" + ticket;
    baseBean.writeLog("OpenToDoFlow.jsp跳转URL： " + flowUrlEnd);
    response.sendRedirect(flowUrlEnd);

    baseBean.writeLog("市政OpenToDoFlow.jsp 执行结束： " + TimeUtil.getCurrentTimeString());

%>


