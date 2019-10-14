<%@ page import="weaver.conn.RecordSet" %>
<%@ page import="java.awt.*" %>
<%@ page import="weaver.workflow.webservices.WorkflowServiceImpl" %>
<%@ page import="weaver.workflow.webservices.WorkflowRequestInfo" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<jsp:useBean id="RequestManager" class="weaver.workflow.request.RequestManager" scope="page"/>
<jsp:useBean id="flowDocss" class="weaver.workflow.request.RequestDoc" scope="session"/>
<jsp:useBean id="DocComInfo" class="weaver.docs.docs.DocComInfo" scope="page"/>
<jsp:useBean id="Doccoder" class="weaver.docs.docs.DocCoder" scope="page"/>
<%@ include file="/systeminfo/init_wev8.jsp" %>



<%
    WorkflowServiceImpl workflowService = new WorkflowServiceImpl();
    WorkflowRequestInfo workflowRequestInfo = new WorkflowRequestInfo();
    String result = workflowService.submitWorkflowRequest(workflowRequestInfo, 515, 150, "submit", "ok");
    out.clear();
    out.print("退回结果================： " + result);

%>



