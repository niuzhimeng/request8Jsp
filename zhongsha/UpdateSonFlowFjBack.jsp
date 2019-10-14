<%@ page import="weaver.conn.RecordSet" %>
<%@ page import="weaver.general.BaseBean" %>
<%@ page import="weaver.general.Util" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%

    BaseBean baseBean = new BaseBean();
    RecordSet recordSet = new RecordSet();
    baseBean.writeLog("UpdateSonFlowFjBack.jsp ======================= Start ");
    // 子流程id
    String requestId = request.getParameter("requestId");
    String mainTableName = request.getParameter("mainTableName");
    String sonTableName = request.getParameter("sonTableName");
    String mainFj = request.getParameter("mainFj");
    String sonFj = request.getParameter("sonFj");

    baseBean.writeLog("UpdateSonFlowFjBack.jsp 接收前台参数: " + requestId + "");

    String returnStr;
    // 主流程id
    String mainRequestId = getMainRequestId(requestId);

    recordSet.executeQuery("select " + sonFj + " from " + sonTableName + " where requestid = " + requestId);
    recordSet.next();
    if (!"".equals(recordSet.getString(sonFj))) {
        // 已更新过，防止页面刷新
        returnStr = "1";
    } else if (!"".equals(mainRequestId)) {
        recordSet.executeQuery("select " + mainFj + " from " + mainTableName + " where requestid = " + mainRequestId);
        recordSet.next();
        // 流程表单pdfId
        String pdfId = recordSet.getString(mainFj);

        // 更新子流程表单
        String updateSql = "update " + sonTableName + " set " + sonFj + " = '" + pdfId + "' where requestid = " + requestId;
        baseBean.writeLog("更新子流程附件字段sql： " + updateSql);
        recordSet.executeUpdate(updateSql);
        returnStr = "0";
    } else {
        // 手动新建流程，防止页面刷新
        returnStr = "1";
    }


    baseBean.writeLog("UpdateSonFlowFjBack.jsp ======================= End ");
    out.clear();
    out.print(returnStr);

%>

<%!
    /**
     * 根据子流程id  获取 主流程id
     * @param subRequestId 子流程id
     * @return 主流程id
     */
    public String getMainRequestId(String subRequestId) {
        String mainrequestid = "";
        if (!"".equals(subRequestId)) {
            String sel = "select mainrequestid  from workflow_subwfrequest where subrequestid = '" + subRequestId + "'";
            RecordSet rs = new RecordSet();
            rs.executeSql(sel);
            if (rs.next()) {
                mainrequestid = Util.null2String(rs.getString("mainrequestid"));
            }
        }
        return mainrequestid;
    }
%>