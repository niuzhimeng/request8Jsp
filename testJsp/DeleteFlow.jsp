<%@ page import="weaver.mobile.webservices.workflow.WorkflowServiceImpl" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<%
    WorkflowServiceImpl workflowService = new WorkflowServiceImpl();
    boolean b = workflowService.deleteRequest(1375, 1);// int 请求id,int 用户id(随便填)
    out.clear();
    out.print("删除结果： " + b);


%>