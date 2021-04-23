<%@ page import="com.alibaba.fastjson.JSONArray" %>
<%@ page import="com.alibaba.fastjson.JSONObject" %>
<%@ page import="weaver.conn.RecordSet" %>
<%@ page import="weaver.general.BaseBean" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Map" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%
    BaseBean baseBean = new BaseBean();
    baseBean.writeLog("资金安排执行报表金额校验MoneyCheckBack.jsp ======================= Start ");
    String myJson = request.getParameter("myJson");
    baseBean.writeLog("资金安排执行报表金额校验 接收前台参数: " + myJson);
    RecordSet recordSet = new RecordSet();
    JSONObject returnJsonObj = new JSONObject();
    try {
        JSONObject jsonObject = JSONObject.parseObject(myJson);
        String zjapxh = jsonObject.getString("zjapxh");// 资金安排序号
        JSONArray mx1Array = jsonObject.getJSONArray("mx1Array");
        // 交易编号 - 金额
        Map<String, String> map = new HashMap<String, String>();
        for (Object o : mx1Array) {
            JSONObject obj = (JSONObject) o;
            map.put(obj.getString("jybhVal"), obj.getString("jeVal"));
        }

        StringBuilder stringBuilder = new StringBuilder();
        recordSet.executeQuery("select b.* from uf_zxbb a inner join uf_zxbb_dt1 b on a.id = b.mainid where a.zjapxh = ?", zjapxh);
        while (recordSet.next()) {
            String jybh = recordSet.getString("jybh"); // 交易编号
            double je = recordSet.getDouble("je") < 0 ? 0 : recordSet.getDouble("je"); // 金额
            double doubleValue = Util.getDoubleValue(map.get(jybh), 0); // 表单金额
            baseBean.writeLog("表单金额: " + doubleValue + ", 数据库金额： " + je);
            if (doubleValue > je) {
                stringBuilder.append("交易编号： ").append(jybh).append(", 金额不得增大").append("<br>");
            }
        }
        if (stringBuilder.length() > 0) {
            returnJsonObj.put("myState", false);
            returnJsonObj.put("message", stringBuilder.toString());
        } else {
            returnJsonObj.put("myState", true);
            returnJsonObj.put("message", "校验通过");
        }

    } catch (Exception e) {
        baseBean.writeLog("资金安排执行报表金额校验ERR： " + e);
    }

    baseBean.writeLog("资金安排执行报表金额校验 ======================= End ");
    out.clear();
    out.print(returnJsonObj.toJSONString());

%>