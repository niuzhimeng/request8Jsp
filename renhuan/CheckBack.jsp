<%@ page import="weaver.conn.RecordSet" %>
<%@ page import="weaver.general.BaseBean" %>
<%@ page import="weaver.general.TimeUtil" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<%
    BaseBean baseBean = new BaseBean();
    RecordSet recordSet = new RecordSet();

    baseBean.writeLog("发票验重开始=============== " + TimeUtil.getCurrentTimeString());
    String allStr = request.getParameter("allStr");
    baseBean.writeLog("收到的 allStr： " + allStr);
    String[] splits = allStr.split(",");
    StringBuilder myWhere = new StringBuilder();
    for (String s : splits) {
        myWhere.append("'").append(s).append("',");
    }
    myWhere.deleteCharAt(myWhere.length() - 1);

    String sql = "select * from uf_difpcc where fph in (" + myWhere.toString() + ")";
    baseBean.writeLog("查询sql： " + sql);
    recordSet.executeQuery(sql);

    StringBuilder returnBuilder = new StringBuilder();
    while (recordSet.next()) {
        returnBuilder.append(recordSet.getString("fph")).append(", ");
    }
    out.clear();
    if (returnBuilder.length() > 0) {

        out.print("发票号码： " + returnBuilder.toString() + " 重复。");
    } else {
        out.print("true");
    }

    baseBean.writeLog("发票验重结束  =============== " + TimeUtil.getCurrentTimeString());


%>










