<%@ page import="weaver.workflow.workflow.WfForceOver" %>
<%@ page import="java.util.ArrayList" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<jsp:useBean id="RequestManager" class="weaver.workflow.request.RequestManager" scope="page"/>
<jsp:useBean id="flowDocss" class="weaver.workflow.request.RequestDoc" scope="session"/>
<jsp:useBean id="DocComInfo" class="weaver.docs.docs.DocComInfo" scope="page"/>
<jsp:useBean id="Doccoder" class="weaver.docs.docs.DocCoder" scope="page"/>

<%
    // 流程强制归档
    WfForceOver wfForceOver = new WfForceOver();

    // 流程id的集合
    ArrayList<String> list = new ArrayList<>();
    list.add("1328");
    list.add("1329");

    wfForceOver.doForceOver(list, request, response);

%>






