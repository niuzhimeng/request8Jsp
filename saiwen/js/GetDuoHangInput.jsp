<%@ page import="weaver.conn.RecordSet" %>
<%@ page import="org.dom4j.Element" %>
<%@ page import="org.dom4j.DocumentHelper" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<%
    RecordSet recordSet = new RecordSet();
    recordSet.executeQuery("select * from formtable_main_47 where requestid = 3164");
    recordSet.next();
    String wby = recordSet.getString("wby");
    Element root = DocumentHelper.createElement("GLVoucherList");
    Element SupplierList = root.addElement("VoucherList");
    SupplierList.addElement("GLVoucherHead").setText(wby);

    out.clear();
    out.print(root.asXML());
%>
