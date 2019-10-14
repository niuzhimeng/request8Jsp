<%@ page import="weaver.conn.RecordSet" %>
<%@ page import="weaver.general.BaseBean" %>
<%@ page import="weaver.general.TimeUtil" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<%
    BaseBean baseBean = new BaseBean();
    RecordSet recordSet = new RecordSet();

    baseBean.writeLog("扫码后台节点执行==============" + TimeUtil.getCurrentTimeString());
    String requestId = request.getParameter("requestId");
    recordSet.executeQuery("select workflowid from workflow_requestbase where requestid = " + requestId);
    recordSet.next();
    // 流程id
    String workflowId = recordSet.getString("workflowid");

    // 查询建模表, 获取节点id
    recordSet.executeQuery("select * from uf_worknode where workid = " + workflowId);
    recordSet.next();
    int nodeId = recordSet.getInt("nodeid");

    baseBean.writeLog("workflowid : " + workflowId + ", nodeid: " + nodeId);
    String sql = "select requestid from workflow_requestbase where requestid = '" + requestId + "'" +
            " and currentnodeid = " + nodeId;
    baseBean.writeLog("扫码确认jsp执行sql： " + sql);

    recordSet.executeQuery(sql);
    String flag = "false";
    if (recordSet.next()) {
        flag = "true";
    }

    out.clear();
    out.print(flag);

%>




