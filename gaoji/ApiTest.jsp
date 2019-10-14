<%@ page import="weaver.formmode.setup.ModeRightInfo" %>
<%@ page import="weaver.general.BaseBean" %>
<%@ page import="java.io.BufferedReader" %>
<%@ page import="java.io.IOException" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea" %>
<%@ taglib uri="/WEB-INF/tld/browser.tld" prefix="brow" %>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page"/>
<script type="text/javascript" src="/js/select/script/jquery-1.8.3.min_wev8.js"></script>


<%
    String json = getPostData(request.getReader());
    String id = request.getParameter("id");
    out.clear();
    out.print("url上的参数：" + id + ",  body里面的：" + json);
%>

<%!
    private static String getPostData(BufferedReader reader) throws IOException {
        StringBuilder stringBuilder = new StringBuilder();
        String str;
        while ((str = reader.readLine()) != null) {
            stringBuilder.append(str);
        }
        return new String(stringBuilder);
    }
%>
<%--<script src="/workflow/request/testJsp/cw.js"></script>--%>
<%--<script src="/js/shauter_wev8.js"></script>--%>
<%--<script type="text/javascript">--%>
<%--jQuery(document).ready(function () {--%>
<%--jQuery("#field10148").bindPropertyChange(function () {--%>
<%--var fycdzt = jQuery("#field10148").val();--%>
<%--//发送请求--%>
<%--$.post("/workflow/request/gaoji/FycdztUnionFycdcm.jsp", {--%>
<%--"fycdzt": fycdzt--%>
<%--}, function (data) {--%>
<%--var data = data.replace(/\s+/g, "");--%>
<%--if (data == 'true') {--%>
<%--changeFieldShowattr("10149", "2", "0", -1);//修改字段属性--%>
<%--} else {--%>
<%--changeFieldShowattr("10149", "3", "0", -1);--%>
<%--}--%>
<%--});--%>
<%--});--%>
<%--})--%>
<%--</script>--%>


<script type="text/javascript">
    var id = 5;
    $(function () {
        $("#field7030").val(id);
        $("#field7030span").html('显示值');
    })
</script>





