<%@ page import="weaver.conn.RecordSet" %>
<%@ page import="weaver.general.BaseBean" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="com.google.gson.Gson" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>


<%
    String params = request.getParameter("params");
    Gson gson = new Gson();
    BaseBean baseBean = new BaseBean();
    baseBean.writeLog("BaoXiaoBack.jsp.jsp 收到id： " + params);

    String[] splits = params.split(",");
    StringBuilder newParams = new StringBuilder();
    for (String split : splits) {
        newParams.append("'").append(split).append("',");
    }
    newParams.deleteCharAt(newParams.length() - 1);

    RecordSet recordSet = new RecordSet();
    String selectSql = "select * from uf_fapiao_dt1 where fpmainid in (" + newParams.toString() + ")";
    baseBean.writeLog("查询sql： " + selectSql);
    recordSet.executeQuery(selectSql);
    List<Map<String, String>> mapList = new ArrayList<Map<String, String>>();
    while (recordSet.next()) {
        Map<String, String> map = new HashMap<String, String>();
        map.put("mxname", recordSet.getString("mxname"));
        map.put("fpmainid", recordSet.getString("fpmainid"));
        mapList.add(map);
    }
    out.clear();
    out.print(gson.toJson(mapList));
%>