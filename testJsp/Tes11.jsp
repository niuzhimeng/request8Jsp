<%@ page import="weaver.general.BaseBean" %>
<%@ page import="java.io.BufferedReader" %>
<%@ page import="java.io.IOException" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<jsp:useBean id="RequestManager" class="weaver.workflow.request.RequestManager" scope="page"/>
<jsp:useBean id="flowDocss" class="weaver.workflow.request.RequestDoc" scope="session"/>
<jsp:useBean id="DocComInfo" class="weaver.docs.docs.DocComInfo" scope="page"/>
<jsp:useBean id="Doccoder" class="weaver.docs.docs.DocCoder" scope="page"/>


<%
    BaseBean baseBean = new BaseBean();
    String name = getPostData(request.getReader());
    baseBean.writeLog("reader接收： " + name);
    out.clear();
    out.print("{\n" +
            "\t\"name\": \"牛智萌啊\"\n" +
            "}");

%>

<%!
    private static String getPostData(BufferedReader reader) throws IOException {
        StringBuilder sb = new StringBuilder();
        String str;
        while ((str = reader.readLine()) != null) {
            sb.append(str);
        }
        return new String(sb);
    }
%>





