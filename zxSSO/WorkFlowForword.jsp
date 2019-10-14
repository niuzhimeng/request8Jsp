<%@ page import="weaver.workflow.webservices.WorkflowServiceImpl" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page"/>
<%@ include file="/systeminfo/init_wev8.jsp" %>

<%
    // 流程转发
    WorkflowServiceImpl workflowService = new WorkflowServiceImpl();
    workflowService.forwardWorkflowRequest(1323, "149", "ok", 150, "");// 流程id，接收人，签字意见，发送人
%>



