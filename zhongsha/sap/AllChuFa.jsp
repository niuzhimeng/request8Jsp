<%@ page import="com.weavernorth.zhongsha.crmsap.timed.GetGdtz" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<%
    String myType = request.getParameter("myType");
    if ("0".equals(myType)) {
        new GetGdtz().execute();
    }


%>