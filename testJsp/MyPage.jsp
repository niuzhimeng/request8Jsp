<%@ page import="weaver.general.BaseBean" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea" %>
<jsp:useBean id="RequestManager" class="weaver.workflow.request.RequestManager" scope="page"/>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="flowDocss" class="weaver.workflow.request.RequestDoc" scope="session"/>
<jsp:useBean id="DocComInfo" class="weaver.docs.docs.DocComInfo" scope="page"/>
<jsp:useBean id="Doccoder" class="weaver.docs.docs.DocCoder" scope="page"/>
<script type="text/javascript">
    $(function () {
        window.top.Dialog.confirm("流程创建成功!</br>是否跳转到流程界⾯下载本次询价的清单!", function () {
            window.top.Dialog.alert("确认")
        }, function () {
            window.top.Dialog.alert("取消操作!");
        });
    })

</script>

<%
    String requestid = request.getParameter("requestid");
    String cgyy = request.getParameter("xm");
    new BaseBean().writeLog("==============================xm: " + cgyy);
    response.sendRedirect("http://localhost:8080/formmode/search/CustomSearchBySimple.jsp?customid=2&xb=-1");

%>


