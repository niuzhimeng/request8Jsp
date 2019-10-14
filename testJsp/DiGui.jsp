<%@ page import="com.google.gson.Gson" %>
<%@ page import="weaver.conn.RecordSet" %>
<%@ page import="weaver.general.BaseBean" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.List" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%
    List<String> idList = new ArrayList<>();
    String depId = request.getParameter("id");
    StringBuilder builder = new StringBuilder();
    RecordSet recordSet = new RecordSet();
    try {
        getAllSon(depId, idList);
        idList.add(depId);//添加当前部门
        for (String id : idList) {
            builder.append(id).append(",");
        }
        String idStr = builder.toString();
        idStr = idStr.substring(0, idStr.length() - 1);
        out.clear();
        out.print("导出完成: " + idStr);
        recordSet.executeQuery("select count(1) myCount from hrmresource where departmentid in(" + idStr + ")");
        if (recordSet.next()) {
            String myCount = recordSet.getString("myCount");
            out.print("总数: " + myCount);
        }
    } catch (Exception e) {
        out.clear();
        out.print(e);
    }


%>

<%!
    /**
     * 递归获取所有下级部门id
     * @param id 父级id
     * @param idList 所有子部门id集合
     */
    private List<String> getAllSon(String id, List<String> idList) {
        RecordSet recordSet = new RecordSet();
        recordSet.executeQuery("select id from HrmDepartment where supdepid = '" + id + "'");
        while (recordSet.next()) {
            idList.add(recordSet.getString("id"));
            getAllSon(recordSet.getString("id"), idList);
        }
        new BaseBean().writeLog("当前list： " + new Gson().toJson(idList));
        return idList;
    }
%>
