<%@ page import="weaver.workflow.workflow.WfForceOver" %>
<%@ page import="java.util.ArrayList" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<%
    // 流程强制归档
    ArrayList<String> list = new ArrayList<>();
    list.add("2489");

    WfForceOver wfForceOver = new WfForceOver();
    wfForceOver.doForceOver(list, request, response);

    out.clear();
    out.print("归档完成： ");


%>