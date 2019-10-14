<%@ page import="com.alibaba.fastjson.JSONArray" %>

<%@ page import="com.alibaba.fastjson.JSONObject" %>
<%@ page import="com.weaver.general.BaseBean" %>
<%@ page import="com.weaver.general.Util" %>
<%@ page import="weaver.conn.RecordSet" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Map" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<%
    BaseBean baseBean = new BaseBean();
    RecordSet recordSet = new RecordSet();

    baseBean.writeLog("差旅费用报销申请流程_wdd 后台=====================Start");
    try {
        String myJson = request.getParameter("myJson");
        baseBean.writeLog("myJson: " + myJson);
        JSONObject fastJsonObj = JSONObject.parseObject(myJson);
        String gwjb = fastJsonObj.getString("gwjb");
        if ("".equals(gwjb)) {
            out.clear();
            out.print("【岗位级别】不能为空！");
            return;
        }

        recordSet.executeQuery("select * from  uf_ccmddbt where gwjb = '" + gwjb + "'");
        Map<String, Map<String, Double>> firstMap = new HashMap<String, Map<String, Double>>();
        while (recordSet.next()) {
            Map<String, Double> secondMap = new HashMap<String, Double>();
            secondMap.put("zsf", recordSet.getDouble("zsf"));
            secondMap.put("cf", recordSet.getDouble("cf"));
            secondMap.put("jtbt", recordSet.getDouble("jtbt"));
            firstMap.put(recordSet.getString("ccmdd"), secondMap);
        }
        baseBean.writeLog("拼接好的费用标准map： " + JSONObject.toJSONString(firstMap));

        // 循环明细表
        StringBuilder stringBuilder = new StringBuilder();
        JSONArray mxDataArray = fastJsonObj.getJSONArray("mxData");
        for (Object element : mxDataArray) {
            JSONObject jsonObj = (JSONObject) element;
            String mddVal = Util.null2String(jsonObj.getString("mddVal")); // 目的地
            baseBean.writeLog("mddVal: " + mddVal);
            int myNumber = jsonObj.getIntValue("myNumber"); // 行号
            double cctsVal = jsonObj.getDoubleValue("cctsVal"); // 出差天数
            double zsfVal = jsonObj.getDoubleValue("zsfVal"); // 住宿费
            double cfVal = jsonObj.getDoubleValue("cfVal"); // 餐费
            double jtbtVal = jsonObj.getDoubleValue("jtbtVal"); // 交通补贴

            if ("".equals(mddVal)) {
                out.clear();
                out.print("【目的地】不能为空！");
                return;
            }
            Map<String, Double> standardMap = firstMap.get(mddVal);
            StringBuilder sonBuilder = new StringBuilder();
            sonBuilder.append("第 ").append(myNumber).append(" 行，");
            // 住宿费判断
            double zsfBz = standardMap.get("zsf") * cctsVal;
            if (zsfBz < zsfVal) {
                sonBuilder.append("住宿费标准为： ").append(zsfBz).append(", 当前数据不合规。\r\n");
            }

            // 餐费判断
            double cfBz = standardMap.get("cf") * cctsVal;
            if (cfBz < cfVal) {
                sonBuilder.append("餐费标准为： ").append(cfBz).append(", 当前数据不合规。\r\n");
            }

            // 交通补贴判断
            double jtbtBz = standardMap.get("jtbt") * cctsVal;
            if (jtbtBz < jtbtVal) {
                sonBuilder.append("交通补贴标准为： ").append(jtbtBz).append(", 当前数据不合规.");
            }
            if (sonBuilder.toString().length() > 10) {
                sonBuilder.append("</br>");
                stringBuilder.append(sonBuilder);
            }

        }
        baseBean.writeLog("差旅返回stringBuilder: " + stringBuilder.toString());
        baseBean.writeLog("差旅费用报销申请流程_wdd 后台End");
        out.clear();
        if (stringBuilder.length() <= 12) {
            out.print("true");
        } else {
            out.print(stringBuilder.toString());
        }
    } catch (Exception e) {
        baseBean.writeLog("差旅费用报销申请流程_wdd 后台Err: " + e);
        out.print("差旅费用报销申请流程_wdd 后台Err: " + e);
    }


%>