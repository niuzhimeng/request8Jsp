<%@ page import="com.weavernorth.taide.kaoQin.kqyc.timedTask.TimedKqyc" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page"/>
<%@ include file="/systeminfo/init_wev8.jsp" %>


<%
    // 考勤异常
    new TimedKqyc().execute();
    out.print("考勤异常同步完成。" + TimeUtil.getCurrentTimeString());
%>