<%@ page import="com.weavernorth.zhongsha.crmsap.timed.GetGdtz" %>
<%@ page import="weaver.general.Util" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<%
    String myType = request.getParameter("myType");
    String myVersion = Util.null2String(request.getParameter("myVersion"));
    request.getParameter("");
    if ("0".equals(myType)) {
        GetGdtz getGdtz = new GetGdtz();
        getGdtz.setVersion(myVersion);
        getGdtz.execute();
    }


%>