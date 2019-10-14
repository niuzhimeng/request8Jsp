<%@ page import="com.weavernorth.huaLian.TimedSynHrm" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>

<%
    new TimedSynHrm().execute();
    response.sendRedirect("/formmode/search/CustomSearchBySimple.jsp?customid=1");
%>



