<%@ page import="weaver.general.BaseBean" %>
<%@ page import="weaver.general.TimeUtil" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page"/>



<%

    BaseBean baseBean = new BaseBean();
    String parameter = request.getParameter("loginid");
    baseBean.writeLog("n接到参数： " + TimeUtil.getCurrentTimeString() + ", " + parameter);


%>



<%

    String parameter1 = request.getParameter("loginid");
    baseBean.writeLog("n接到参数1： " + TimeUtil.getCurrentTimeString() + ", " + parameter);


%>

