<%@ page import="weaver.conn.RecordSet" %>
<%@ page import="weaver.ofs.webservices.OfsTodoDataWebServiceImpl" %>
<%@ page import="com.google.gson.JsonObject" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%

    String flowId = request.getParameter("flowId");

    RecordSet recordSet = new RecordSet();
    //recordSet.execute("update ofs_todo_data set viewtype = 1 where flowid = '" + flowId + "'"); // 变为已读

    // 拼接待办json
    JsonObject jsonObject = new JsonObject();
    // 异构系统标识
    jsonObject.addProperty("syscode", "localhost");
    // flowid
    jsonObject.addProperty("flowid", "flowid1");
    // 标题（需要与之前的待办相同，否则不好使）
    jsonObject.addProperty("requestname", "创建待办测试流程1322");
    // 流程类型名称
    jsonObject.addProperty("workflowname", "测试类");
    // 步骤名称（节点名称）
    jsonObject.addProperty("nodename", "领导审批");
    // 接收人（原值）
    jsonObject.addProperty("receiver", "100018");

    // 直接变为已办
    OfsTodoDataWebServiceImpl ofsTodoDataWebService = new OfsTodoDataWebServiceImpl();
    ofsTodoDataWebService.processDoneRequestByJson(jsonObject.toString());

    //response.sendRedirect("http://www.baidu.com");


%>


