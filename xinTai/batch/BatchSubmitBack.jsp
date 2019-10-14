<%@ page import="weaver.conn.RecordSet" %>
<%@ page import="weaver.general.BaseBean" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<%
    BaseBean baseBean = new BaseBean();
    RecordSet recordSet = new RecordSet();

    String idsStr = request.getParameter("idsStr");
    String[] ids = idsStr.split(",");

   String returnStr = "";
    for (String id : ids) {
        recordSet.executeUpdate("update uf_patchDown set tszt = 1 where id = " + id);
    }


    out.clear();
    out.print("推送成功 N 条， 失败 N 条。");

%>




