<%@ page import="weaver.conn.RecordSet" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>


<%
    // 接收流程返回状态
    // 状态码 (0 成功, 1 失败)
    String code = request.getParameter("code");
    // 状态描述
    String message = request.getParameter("message");
    // 流程唯一标识
    String requestId = request.getParameter("requestId");

    // OA流程表名
    String tableName = "";
    RecordSet recordSet = new RecordSet();
    recordSet.executeQuery("SELECT tablename FROM workflow_bill WHERE id = (SELECT billformid FROM workflow_form WHERE requestid = " + requestId + ")");
    if (recordSet.next()) {
        tableName = recordSet.getString("tablename");
    }

    // 更新OA流程表单
    recordSet.executeUpdate("update " + tableName + " set code = '" + code + "', message = '" + message + "' where requestid = '" + requestId + "'");

%>