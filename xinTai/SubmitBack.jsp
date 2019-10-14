<%@ page import="weaver.conn.RecordSet" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>

<%
    BaseBean baseBean = new BaseBean();

    int uid = user.getUID();
    try {
        RecordSet recordSet = new RecordSet();
        recordSet.executeQuery("select * from uf_pltj where modedatacreater = '" + uid + "'");
        while (recordSet.next()) {
            baseBean.writeLog("批量提交=============== " + recordSet.getString("myId"));
        }

        recordSet.execute("delete from uf_pltj where modedatacreater = '" + uid + "'");
    } catch (Exception e) {
        baseBean.writeLog("SubmitBack.jsp批量提交 异常： " + e);
    }


%>

<h2>批量提交完成，成功<%=uid%>条</h2>




