<%@ page import="com.weavernorth.jiajie.timed.TriggerSonFlowHtdq" %>
<%@ page import="com.weavernorth.jiajie.timed.TriggerSonFlowSyq" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%
    String id = request.getParameter("id");
    String str = "id: " + id + ", ";
    if ("1".equals(id)) {
        TriggerSonFlowSyq triggerSonFlowSyq = new TriggerSonFlowSyq();
        triggerSonFlowSyq.execute();
        str += "触发TriggerSonFlowSyq";
    } else if ("2".equals(id)) {
        new TriggerSonFlowHtdq().execute();
        str += "触发TriggerSonFlowHtdq";
    }
    out.clear();
    out.print(str);

%>


















