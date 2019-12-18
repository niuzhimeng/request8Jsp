<%@ page import="weaver.conn.RecordSet" %>
<%@ page import="weaver.general.BaseBean" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<%
    BaseBean baseBean = new BaseBean();
    RecordSet recordSet = new RecordSet();
    recordSet.executeQuery("select * from hrmresource where id = 149");
    recordSet.next();

    out.clear();
    out.print("recordSet.getString(\"birthday\"): " + recordSet.getDouble("birthday"));
    out.print("".equals(recordSet.getString("birthday")));

%>