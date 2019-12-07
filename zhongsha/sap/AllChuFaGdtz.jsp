<%@ page import="com.weavernorth.zhongsha.crmsap.timed.PushGdtz" %>
<%@ page import="weaver.general.Util" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<%
    String myType = Util.null2String(request.getParameter("myType")).trim();
    if (!"".equals(myType)) {
        new PushGdtz().execute();
    }

%>