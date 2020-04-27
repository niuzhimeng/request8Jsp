<%@ page import="com.alibaba.fastjson.JSONArray" %>
<%@ page import="com.alibaba.fastjson.JSONObject" %>
<%@ page import="weaver.conn.RecordSet" %>
<%@ page import="weaver.general.BaseBean" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%
    // 物资采购预选供应商流程 获取明细表中的供应商
    BaseBean baseBean = new BaseBean();
    String requestId = request.getParameter("yxlc");
    String tableName = request.getParameter("yxTableName");
    String gysFiled = request.getParameter("gysFiled");
    String gysFiledStr = request.getParameter("gysFiledStr");
    baseBean.writeLog("物资采购预选供应商流程CheckStart===========接收json=" + requestId);
    try {
        int i = tableName.lastIndexOf("_");
        String mainName = tableName.substring(0, i);

        RecordSet recordSet = new RecordSet();
        recordSet.executeQuery("select dt." + gysFiled + ", dt." + gysFiledStr + " from " + tableName + " dt left join " + mainName + " ma on ma.id = dt.mainid " +
                " where ma.requestId = '" + requestId + "' order by dt.id");
        List<String> gysList = new ArrayList<String>();
        while (recordSet.next()) {
            String xzgys = recordSet.getString(gysFiled);
            String gysmc1 = recordSet.getString(gysFiledStr);
            if (!"".equals(xzgys)) {
                gysList.add(xzgys + "," + gysmc1);
            }
        }
        JSONObject jsonObject = new JSONObject();
        jsonObject.put("gysArray", gysList);

        out.clear();
        out.print(jsonObject);
    } catch (Exception e) {
        baseBean.writeLog("物资采购预选供应商流程CheckErr: " + e);
    }


%>
