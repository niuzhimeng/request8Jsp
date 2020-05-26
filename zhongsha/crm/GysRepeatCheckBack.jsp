<%@ page import="com.alibaba.fastjson.JSONObject" %>
<%@ page import="weaver.conn.RecordSet" %>
<%@ page import="weaver.general.BaseBean" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%
    // 供应商CRM注册信息提交 + 字段变化 校验是否重复
    BaseBean baseBean = new BaseBean();
    JSONObject jsonObject = new JSONObject();
    String gysmc = request.getParameter("gysmc");
    String xydm = request.getParameter("xydm");
    try {
        RecordSet recordSet = new RecordSet();
        boolean state = true;
        if (gysmc != null && !"".equals(gysmc)) {
            recordSet.executeQuery("select 1 from uf_crm_gysxx where gysmc = '" + gysmc + "'");
            if (recordSet.next()) {
                state = false;
            }
        }

        if (xydm != null && !"".equals(xydm)) {
            recordSet.executeQuery("select 1 from uf_crm_gysxx where tyshxydm = '" + xydm + "'");
            if (recordSet.next()) {
                state = false;
            }
        }

        jsonObject.put("state", state);

        out.clear();
        out.print(jsonObject);
    } catch (Exception e) {
        baseBean.writeLog("供应商CRM注册信息流程GysRepeatCheckBack.jsp异常: " + e);
    }


%>
