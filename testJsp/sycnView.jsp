<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.conn.RecordSet" %>
<jsp:useBean id="baseBean" class="weaver.general.BaseBean" scope="page"/>
<jsp:useBean id="MouldStatusCominfo" class="weaver.systeminfo.MouldStatusCominfo" scope="page"/>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<%

    RecordSet rs = new RecordSet();
    rs.executeSql("select * from HR_OA_SENDLOG ORDER BY UPDATE_TIME DESC");
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
    <meta charset="UTF-8">
    <title></title>
    <script src="/js/ecology8/jquery_wev8.js"></script>
    <link rel="stylesheet" type="text/css" href="css/H-ui.min.css"/>
    <link rel="stylesheet" type="text/css" href="css/H-ui.css"/>
    <link rel="stylesheet" type="text/css" href="css/H-ui.ie.css"/>
    <link rel="stylesheet" type="text/css" href="css/H-ui.reset.css"/>
</head>

<body>
<form id="sendFrom">
    <table style="width: 100%" class="table table-border table-bordered radius">
        <tr>
            <td colspan="4" style="text-align: center;font-size: 20px;">
                <input class="btn btn-primary radius"  type="button" onclick = "sendForm(1)"  value="同步部门数据">
                <input class="btn btn-primary radius"  type="button" onclick = "sendForm(2)"  value="同步人员数据">
                <input class="btn btn-primary radius"  type="button" onclick = "sendForm(3)"  value="同步岗位数据">
                <input class="btn btn-primary radius"  type="button" onclick = "sendForm(4)"  value="同步考勤补助">
                <input class="btn btn-primary radius"  type="button" onclick = "sendForm(5)"  value="同步CRM订单">
                <input class="btn btn-primary radius"  type="button" onclick = "sendForm(6)"  value="测试001">
            </td>
        </tr>
    </table>
</form>
<table style="width: 100%" class="table table-border table-bordered radius">
    <tr>
        <td>同步表名</td>
        <td>同步时间</td>
        <td>同步数量</td>
        <td>同步日志</td>
    </tr>
    <%

    while(rs.next()){
        out.print("<tr>\n" +
            "        <td>"+rs.getString("table_name")+"</td>\n" +
            "        <td>"+rs.getString("update_time")+"</td>\n" +
            "        <td>"+rs.getString("lognum")+"</td>\n" +
            "        <td>"+rs.getString("memos")+"</td>\n" +
            "    </tr>");
    }
    %>
</table>

<script type="text/javascript">

    function sendForm(type) {
        alert("同步时间可能有点长，请耐心等待");
        jQuery.ajax({
            url:"sycnAction.jsp",
            type:"post",
            dataType: "json",
            data:{"type":type}
        });
    }
</script>
</body>
</html>