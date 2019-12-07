<%@ page import="com.alibaba.fastjson.JSONArray" %>
<%@ page import="com.alibaba.fastjson.JSONObject" %>
<%@ page import="weaver.conn.RecordSet" %>
<%@ page import="weaver.general.BaseBean" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Map" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%
    // 询比价流程
    BaseBean baseBean = new BaseBean();
    String myJson = request.getParameter("myJson");
    baseBean.writeLog("询比价流程Start===========接收json=" + myJson);
    try {
        // 查询供应商-sap状态
        Map<String, String> gysState = new HashMap<String, String>();
        RecordSet recordSet = new RecordSet();
        recordSet.executeQuery("select id, sapzt from uf_crm_gysxx");
        while (recordSet.next()) {
            gysState.put(recordSet.getString("id"), recordSet.getString("sapzt"));
        }

        // 供应商id- name
        Map<String, String> gysIdName = new HashMap<String, String>();
        recordSet.executeQuery("select id, gysmc from uf_crm_gysxx");
        while (recordSet.next()) {
            gysIdName.put(recordSet.getString("id"), recordSet.getString("gysmc"));
        }

        JSONObject jsonObject = JSONObject.parseObject(myJson);
        JSONArray zbgysArray = jsonObject.getJSONArray("mx6Array");
        StringBuilder stringBuilder = new StringBuilder();
        int size = zbgysArray.size();
        for (int i = 0; i < size; i++) {
            JSONObject jsob = zbgysArray.getJSONObject(i);
            String gysStr = jsob.getString("zbgys6Val");
            if (!"0".equals(gysState.get(gysStr))) {
                stringBuilder.append("请对: ").append(gysIdName.get(gysStr)).append(", 提交sap准入流程。").append("\r\n").append("</br>");
            }
        }
        JSONObject returnObject = new JSONObject();
        if (stringBuilder.length() > 0) {
            returnObject.put("state", false);
            returnObject.put("msg", stringBuilder.toString());
        } else {
            returnObject.put("state", true);
            returnObject.put("msg", "success");
        }
        baseBean.writeLog("返回正常信息： " + returnObject.toJSONString());
        out.clear();
        out.print(returnObject.toJSONString());
    } catch (Exception e) {
        baseBean.writeLog("询比价流程-物资类Err: " + e);
    }


%>
