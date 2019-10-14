<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.BaseBean" %>
<%@ page import="weaver.general.TimeUtil" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>

<%
    BaseBean baseBean = new BaseBean();
    baseBean.writeLog("门户打开oa待办 Start============ " + TimeUtil.getCurrentTimeString());

    int uid = user.getUID();
    String requestId = request.getParameter("requestId");
    baseBean.writeLog("收到uid： " + uid);
    baseBean.writeLog("收到requestId： " + requestId);
    String workFlowUrl = "/workflow/request/ViewRequest.jsp?requestid=" + requestId;
    baseBean.writeLog("workFlowUrl=============: " + workFlowUrl);
    response.sendRedirect(workFlowUrl);


%>
