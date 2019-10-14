<%@ page import="weaver.hrm.HrmUserVarify" %>
<%@ page import="weaver.hrm.User" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<script type="text/javascript" src="/js/select/script/jquery-1.8.3.min_wev8.js"></script>

<%
    User user = HrmUserVarify.getUser(request, response);
    String Frusername = user.getLoginid();
    String frPwd = user.getPwd();
%>

<script type="text/javascript">

    function pushFanRuan() {
        var username = "<%=Frusername%>";
        var frPwd = "<%=frPwd%>";

        alert(frPwd)
    }

    pushFanRuan();
</script>





