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
    // 物资采购预选供应商流程 明细1中“物资编码”列前6位 与 明细2中“供应商名称”查询是否存在
    BaseBean baseBean = new BaseBean();
    String myJson = request.getParameter("myJson");
    baseBean.writeLog("物资采购预选供应商流程CheckStart===========接收json=" + myJson);
    try {
        // 查询表中供应商1 - 物资N
        Map<String, List<String>> listMap = new HashMap<String, List<String>>();
        RecordSet recordSet = new RecordSet();
        recordSet.executeQuery("select gysmc, wlz from uf_CRM_gyswlgxb");
        while (recordSet.next()) {
            String gysmc = recordSet.getString("gysmc");
            String wlz = recordSet.getString("wlz");
            if (listMap.containsKey(gysmc)) {
                listMap.get(gysmc).add(wlz);
            } else {
                List<String> list = new ArrayList<String>();
                list.add(wlz);
                listMap.put(gysmc, list);
            }
        }
        baseBean.writeLog("listMap: " + JSONObject.toJSONString(listMap));

        JSONObject jsonObject = JSONObject.parseObject(myJson);

        // 物资信息
        List<String> allWzList = new ArrayList<String>();
        JSONArray mx1Array = jsonObject.getJSONArray("mx1Array");
        for (int i = 0; i < mx1Array.size(); i++) {
            JSONObject jsob = mx1Array.getJSONObject(i);
            allWzList.add(jsob.getString("wzbm1Val"));
        }

        baseBean.writeLog("物资信息：" + JSONObject.toJSONString(allWzList));

        // 供应商是否包含物资 校验开始
        StringBuilder returnBuilder = new StringBuilder();
        StringBuilder sonBuilder = new StringBuilder();
        // 所有供应商
        JSONArray mx2Array = jsonObject.getJSONArray("mx2Array");
        for (int i = 0; i < mx2Array.size(); i++) {
            JSONObject jsob = mx2Array.getJSONObject(i);
            String gysmc2Val = jsob.getString("gysmc2Val");
            List<String> wzList = listMap.get(gysmc2Val);
            for (String wzStr : allWzList) {
                if (wzList == null || !wzList.contains(wzStr)) {
                    // 该供应商不包含该物料
                    sonBuilder.append("供应商: ").append(gysmc2Val).append(", 与: ").append(wzStr)
                            .append(", 不存在关系。").append("\r\n").append("</br>");
                }
            }
        }
        String returnStr;
        if (sonBuilder.length() > 0) {
            out.clear();
            returnStr = returnBuilder.append(sonBuilder).append("</br>").append("请提交关系流程.").toString();
        } else {
            returnStr = "true";
        }
        baseBean.writeLog("校验返回信息： " + returnStr);
        out.print(returnStr);
    } catch (Exception e) {
        baseBean.writeLog("物资采购预选供应商流程CheckErr: " + e);
    }


%>
