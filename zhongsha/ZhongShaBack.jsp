<%@ page import="weaver.conn.RecordSet" %>
<%@ page import="weaver.general.BaseBean" %>
<%@ page import="weaver.general.Util" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%
    BaseBean baseBean = new BaseBean();
    baseBean.writeLog("ZhongShaBack.jsp ======================= Start ");
    String parameter = request.getParameter("message");
    baseBean.writeLog("ZhongShaBack.jsp 接收前台参数: " + parameter);
    String[] split = parameter.split(",");
    // 金额
    String je = split[0];
    // 合同类型
    String htlx = split[1];

    String selectSql = "select sqxemx, spjb, gljypd from uf_dbnhtsqxemx where htlb='" + htlx + "' and isnull (zx,0)<'" + je + "' and '" + je + "'<=isnull(zd,999999999999)";
    baseBean.writeLog("ZhongShaBack.jsp 查询sql： " + selectSql);
    RecordSet recordSet = new RecordSet();
    recordSet.executeQuery(selectSql);

    // 授权限额明细
    String sqxemx = "";
    // 审批级别
    String spjb = "";
    // 是否关联交易
    String gljypd = "";
    if (recordSet.next()) {
        sqxemx = Util.null2String(recordSet.getString("sqxemx"));
        spjb = Util.null2String(recordSet.getString("spjb"));
        gljypd = Util.null2String(recordSet.getString("gljypd"));
    }

    baseBean.writeLog("ZhongShaBack.jsp ======================= End ");
    out.clear();
    out.print(sqxemx + "," + spjb + "," + gljypd);

%>