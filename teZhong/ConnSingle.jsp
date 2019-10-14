<%@ page import="weaver.conn.RecordSet" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<script type="text/javascript">
    window.onload = function () {
        document.getElementById("loginForm").submit();
    }
</script>

<%
    String ssoUrl = request.getParameter("url");
    int uid = user.getUID();

    RecordSet recordSet = new RecordSet();
    recordSet.executeQuery("select * from hrmresource where id = " + uid);
    String lastName = "";
    if (recordSet.next()) {
        lastName = recordSet.getString("lastname");
    } else {
        out.clear();
        out.print("当前用户不存在");
        return;
    }

%>

<html>
<body>
<form id="loginForm"
      action="<%=ssoUrl%>"
      method="post" style="display:none">

    <input type="hidden" id="username" name="username" value="123"/>
    <input type="hidden" id="password" name="password" value="456"/>
    <input type="hidden" id="execution" name="execution" value="789"/>

</form>
</body>
</html>