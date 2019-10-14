<%@ page import="weaver.general.BaseBean" %>
<%@ page import="weaver.conn.RecordSet" %>
<%@ page import="com.google.gson.*" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="com.weaver.general.TimeUtil" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<%
    BaseBean baseBean = new BaseBean();
    RecordSet recordSet = new RecordSet();
    try {
        String myJson = request.getParameter("myJson");
        Gson gson = new Gson();
        baseBean.writeLog("抵押登记入库流程生成编号后台=====================Start");
        baseBean.writeLog("myJson: " + myJson);
        String currentDate = TimeUtil.getCurrentDateString().replace("-", "");

        // 编号 - 代字，当前编号
        Map<String, String> bhMap = new HashMap<String, String>();
        // 查询后台编号信息
        recordSet.executeQuery("select * from uf_dywlx");
        while (recordSet.next()) {
            bhMap.put(recordSet.getString("bm"), recordSet.getString("dz") + "," + recordSet.getString("dqbh"));
        }
        baseBean.writeLog("编号信息map：" + gson.toJson(bhMap));

        // 返回集合 - 生成的编号
        StringBuilder stringBuilder = new StringBuilder();
        String[] splits = myJson.split(",");
        baseBean.writeLog("splits: " + gson.toJson(splits));
        for (String str : splits) {
            if (str != null && !"".equals(str)) {
                String[] split = bhMap.get(str).split(",");
                int currentBh = Integer.parseInt(split[1]) + 1;
                // 补0
                String format = String.format("%03d", currentBh);
                // 更新map
                bhMap.put(str, split[0] + "," + currentBh);
                stringBuilder.append(split[0]).append(currentDate).append(format).append(",");
            } else {
                stringBuilder.append(",");
            }
        }
        stringBuilder.deleteCharAt(stringBuilder.length() - 1);

        baseBean.writeLog("返回的list：" + gson.toJson(stringBuilder.toString()));
        out.clear();
        out.print(stringBuilder.toString());
    } catch (Exception e) {
        baseBean.writeLog("抵押登记入库流程生成编号后台异常： " + e);
    }
    baseBean.writeLog("抵押登记入库流程生成编号后台=====================End");


%>












