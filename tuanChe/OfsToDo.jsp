<%@ page import="weaver.conn.RecordSet" %>
<%@ page import="weaver.ofs.webservices.OfsTodoDataWebServiceImpl" %>
<%@ page import="com.google.gson.JsonObject" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.general.BaseBean" %>
<%@ page import="weaver.general.TimeUtil" %>
<%@ page import="java.net.URLEncoder" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%
    BaseBean baseBean = new BaseBean();
    baseBean.writeLog("OfsToDo.jsp 执行开始： " + TimeUtil.getCurrentTimeString());
    String bsUrl = "http://tcoa.tuanche.net/beisen/beisen.php?request_type=pc&return_url=";

    // 北森消息路径
    String messageUrl = "http://www.italent.cn/u/115735067/Home#widget%2Fitalent%3FiTalentFrameType%3Diframe%26iTalentFrame%3Dhttp%253A%252F%252Fwww.italent.cn%252F115735067%252FItalentIframeHome%2523more%252Fmessages%253FisRead%253D2%2526messageType%253D2%2526messageSubNav%253D1%2526messageType%253D2%26messageType%3D2";

    // 流程访问路径
    String flowUrl = Util.null2String(request.getParameter("flowUrl"));
    baseBean.writeLog("flowUrl: " + flowUrl);
    baseBean.writeLog("flowUrl 长度: " + flowUrl.replace("-", "").length());

    if (flowUrl.replace("-", "").length() == 32) {
        // 消息
        RecordSet recordSet = new RecordSet();
        //recordSet.execute("update ofs_todo_data set viewtype = 1 where flowid = '" + flowId + "'"); // 变为已读

        recordSet.executeQuery("select * from ofs_todo_data where flowid = '" + flowUrl + "'");
        JsonObject jsonObject = new JsonObject();
        if (recordSet.next()) {
            // 异构系统标识
            jsonObject.addProperty("syscode", Util.null2String(recordSet.getString("syscode")));
            // flowid
            jsonObject.addProperty("flowid", flowUrl);
            // 标题（需要与之前的待办相同，否则不好使）
            jsonObject.addProperty("requestname", Util.null2String(recordSet.getString("requestname")));
            // 流程类型名称
            jsonObject.addProperty("workflowname", Util.null2String(recordSet.getString("workflowname")));
            // 步骤名称（节点名称）
            jsonObject.addProperty("nodename", Util.null2String(recordSet.getString("nodename")));
            // 接收人（原值）
            jsonObject.addProperty("receiver", Util.null2String(recordSet.getString("receiver")));
        }
        // 直接变为已办
        OfsTodoDataWebServiceImpl ofsTodoDataWebService = new OfsTodoDataWebServiceImpl();
        ofsTodoDataWebService.processDoneRequestByJson(jsonObject.toString());

        // 跳转固定消息页面
        response.sendRedirect(messageUrl);

    } else {
        // 流程
        String flowUrlEnd = bsUrl + URLEncoder.encode(flowUrl, "utf-8");
        baseBean.writeLog("流程跳转URL： " + flowUrlEnd);
        response.sendRedirect(flowUrlEnd);
    }
    baseBean.writeLog("OfsToDo.jsp 执行结束： " + TimeUtil.getCurrentTimeString());

%>


