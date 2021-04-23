<%@ page import="com.alibaba.fastjson.JSONObject" %>
<%@ page import="weaver.conn.RecordSet" %>
<%@ page import="weaver.general.BaseBean" %>
<%@ page import="weaver.general.Util" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%
    BaseBean baseBean = new BaseBean();
    baseBean.writeLog("资金安排执行报表金额校验MoneyCheckBack.jsp ======================= Start ");
    double jeVal = Util.getDoubleValue(request.getParameter("jeVal"), 0);
    String dhVal = request.getParameter("dhVal");
    baseBean.writeLog("资金安排执行报表金额校验 单号" + dhVal + ", 金额：" + jeVal);

    RecordSet recordSet = new RecordSet();
    JSONObject returnJsonObj = new JSONObject();
    try {
        StringBuilder stringBuilder = new StringBuilder();
        recordSet.executeQuery("select * from uf_tdlb  where dh = ?", dhVal);
        if (recordSet.next()) {
            double je = recordSet.getDouble("je") < 0 ? 0 : recordSet.getDouble("je"); // 金额
            baseBean.writeLog("表单金额: " + jeVal + ", 数据库金额： " + je);
            if (jeVal > je) {
                stringBuilder.append("单号： ").append(dhVal).append(", 金额不得增大").append("<br>");
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