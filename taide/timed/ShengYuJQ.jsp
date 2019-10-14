<%@ page import="com.weavernorth.taide.kaoQin.syjq04.timedTask.TimedSyjq" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page"/>
<%@ include file="/systeminfo/init_wev8.jsp" %>


<%
    // 剩余假期
    new TimedSyjq().execute();
    out.print("剩余假期同步完成。" + TimeUtil.getCurrentTimeString());
%>