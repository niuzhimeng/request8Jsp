<%@ page import="com.alibaba.fastjson.JSONObject" %>
<%@ page import="weaver.conn.RecordSet" %>
<%@ page import="weaver.general.BaseBean" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>

<%
    // 供应商CRM注册信息提交 + 字段变化 校验是否重复

    BaseBean baseBean = new BaseBean();
    int uid = user.getUID();
    String workflowid = request.getParameter("workflowid");
    String requestid = request.getParameter("requestid");
    try {
        RecordSet recordSet = new RecordSet();
        boolean state = true;
        String selSql = "select requestid from workflow_requestbase where creater = " + uid + " and workflowid = " + workflowid +
                " and currentnodetype != 3 ";
        if (requestid != null && !"".equals(requestid)) {
            selSql += "and requestid != " + requestid;
        }
        recordSet.executeQuery(selSql);
        baseBean.writeLog("流程重复发起校验查询sql： " + selSql);
        baseBean.writeLog("查询到的数量： " + recordSet.getCounts());
        if (recordSet.getCounts() >= 1) {
            state = false;
        }
        JSONObject jsonObject = new JSONObject();
        jsonObject.put("state", state);

        out.clear();
        out.print(jsonObject);
    } catch (Exception e) {
        baseBean.writeLog("流程重复发起校验 WorkCreateRepeatCheckBack.jsp 异常: " + e);
    }


%>
