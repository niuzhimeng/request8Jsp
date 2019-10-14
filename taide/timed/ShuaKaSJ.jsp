<%@ page import="com.weavernorth.taide.kaoQin.sksj.timedTask.SendSksjToSapTimed14" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page"/>
<%@ include file="/systeminfo/init_wev8.jsp" %>


<%
    new SendSksjToSapTimed14().execute();
    out.print("刷卡数据推送完成。" + TimeUtil.getCurrentTimeString());
%>