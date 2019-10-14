<%@ page import="weaver.conn.RecordSet" %>
<%@ page import="weaver.general.BaseBean" %>
<%@ page import="weaver.general.TimeUtil" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%
    BaseBean baseBean = new BaseBean();
    try {
        String message = request.getParameter("message");
        baseBean.writeLog("Background.jsp接收到的参数： " + TimeUtil.getCurrentTimeString() + ", " + message);

        String[] split = message.split(",");
        RecordSet recordSet = new RecordSet();
        String sql = "select * from formtable_main_47 where dh = '" + split[0] + "' and fhjs = '" + split[1] + "' and ysfs = '" + split[2] + "'";
        baseBean.writeLog("Background.jsp 查询sql： "+ sql);
        recordSet.executeQuery(sql);

        // 可用预算
        String kyys = "";
        // 审批中预算
        String spzys = "";
        // 已用预算
        String yyys = "";
        if (recordSet.next()) {
            kyys = recordSet.getString("shr");
            spzys = recordSet.getString("shdh");
            yyys = recordSet.getString("jmllk");
        }
        String returns = kyys + "," + spzys + "," + yyys;

        out.clear();
        out.print(returns);
    } catch (Exception e) {
        baseBean.writeLog("Background.jsp带出信息异常： " + TimeUtil.getCurrentTimeString() + ", " + e);
    }
%>