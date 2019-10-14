<%@ page import="com.weavernorth.tuanche.orgsyn.TcConsumer" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page"/>
<%@ include file="/systeminfo/init_wev8.jsp" %>

<%


    String myType = request.getParameter("myType");
    if ("1".equals(myType)) {
        new TcConsumer().synHrmDepartment();
    } else if ("2".equals(myType)) {
        new TcConsumer().hrmJobTitles();
    } else if ("3".equals(myType)) {
        new TcConsumer().synHrmResource();
    }
%>