<%@ page import="com.google.gson.Gson" %>
<%@ page import="weaver.conn.RecordSet" %>
<%@ page import="weaver.general.BaseBean" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.math.BigDecimal" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<%
    String tableName = "formtable_main_76"; //主流程表名

    String type = request.getParameter("type");
    BaseBean baseBean = new BaseBean();
    Gson gson = new Gson();
    if ("fuZhi".equals(type)) {
        baseBean.writeLog("赋值执行===================");
        String tbrId = request.getParameter("tbrId");
        List<Map<String, String>> list = new ArrayList<Map<String, String>>();
        RecordSet recordSet1 = new RecordSet();
        recordSet1.executeQuery("select  top(1) * from " + tableName + " where tbr = '" + tbrId + "' order by rq desc");
        if (recordSet1.next()) {
            String mainId = recordSet1.getString("id");
            String sql = "select d.* from " + tableName + "_dt1 d  left join " + tableName + " m on m.id = d.mainid where m.id = '" + mainId + "'";
            // String sql = "SELECT d.*,h.lastname FROM " + tableName + "_dt1 d LEFT JOIN " + tableName + " m ON m.id = d.mainid LEFT JOIN hrmresource h ON d.xm = h.id WHERE m.id = '" + mainId + "'";
            baseBean.writeLog("查询sql： " + sql);

            RecordSet recordSet = new RecordSet();
            recordSet.executeQuery(sql);
            int row = 0;
            while (recordSet.next()) {
                Map<String, String> map = new HashMap<String, String>();
                map.put("ejbm", recordSet.getString("ejbm"));//二级部门
                map.put("ejbmChina", recordSet.getString("ejbmChina"));//二级部门中文
                map.put("sjbm", recordSet.getString("sjbm"));//三级部门
                map.put("sjbmChina", recordSet.getString("sjbmChina"));//三级部门中文
                map.put("xm", recordSet.getString("xm"));//姓名

                map.put("xmChina", recordSet.getString("xmChina"));//姓名中文
                map.put("gh", recordSet.getString("gh"));//工号
                map.put("rylb", recordSet.getString("rylb"));//人工类别
                map.put("bmgg", recordSet.getString("bmgg"));//部门公共
                map.put("xmbh", recordSet.getString("xmbh"));//项目编号
                map.put("xmbhChina", recordSet.getString("xmbhChina"));//项目编号

                map.put("xmmc", recordSet.getString("xmmc"));//项目名称
                map.put("ywfx", recordSet.getString("ywfx"));//业务方向
                map.put("gsqzzj", recordSet.getString("gsqzzj"));//工时权重总计
                map.put("sm", recordSet.getString("sm"));//说明
                map.put("xmjl", recordSet.getString("xmjl"));//项目经理

                map.put("xmjlChina", recordSet.getString("xmjlChina"));//项目经理中文

                list.add(map);
                row++;
            }

            Map<String, Object> mapAll = new HashMap<String, Object>();
            mapAll.put("row", row);
            mapAll.put("data", list);
            baseBean.writeLog("拼装好的json： " + gson.toJson(mapAll));
            out.clear();
            out.print(gson.toJson(mapAll));
        }
    } else if ("check".equals(type)) {
        baseBean.writeLog("校验执行===================");
        String allStr = request.getParameter("allStr");
        baseBean.writeLog("接收到的str： " + allStr);
        Map<Integer, Double> map = new HashMap<Integer, Double>();
        String[] lines = allStr.split("#");
        for (String obj : lines) {
            String[] split = obj.split(",");
            int xm = Integer.parseInt(split[0]);//姓名
            double gs = Double.parseDouble(split[1]);//工时
            if (map.containsKey(xm)) {
                map.put(xm, add(map.get(xm), gs));
            } else {
                map.put(xm, gs);
            }
        }

        RecordSet recordSet = new RecordSet();
        StringBuilder builder = new StringBuilder();
        for (Map.Entry<Integer, Double> entity : map.entrySet()) {
            if (entity.getValue() != 1) {
                recordSet.executeQuery("select lastname from hrmresource where id = '" + entity.getKey() + "'");
                if (recordSet.next()) {
                    builder.append("员工：").append(recordSet.getString("lastname")).append("，工时总和不为1。<br>");
                }
            }
            baseBean.writeLog("姓名： " + entity.getKey() + ",       工时： " + entity.getValue());
        }
        baseBean.writeLog("拼接的stringbuilder: " + builder.toString());
        if (builder.length() > 0) {
            out.clear();
            out.print(builder.toString());
            return;
        }
        out.clear();
        out.print("true");
    }

%>

<%!
    private Double add(Double a, Double b) {
        BigDecimal decimalA = new BigDecimal(a.toString());
        BigDecimal decimalB = new BigDecimal(b.toString());
        return decimalA.add(decimalB).doubleValue();
    }
%>





