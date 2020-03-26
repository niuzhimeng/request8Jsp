<%@ page import="com.weavernorth.zhongsha.crmsap.timed.CreateReport" %>
<%@ page import="weaver.general.Util" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<%
    String myType = Util.null2String(request.getParameter("myType")).trim();
    if ("0".equals(myType)) {
        new CreateReport().execute();
    }

%>