<%@ page import="com.weavernorth.taide.kaoQin.jcoTimed.timedTask.WuLiaoTimed" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>


<%

    BaseBean baseBean = new BaseBean();
    try {
        new WuLiaoTimed().execute();
        out.clear();
        out.print("物料数据推送完成。" + TimeUtil.getCurrentTimeString());

    } catch (Exception e) {
        baseBean.writeLog("RFC获取物料数据异常： " + e);
    }


%>

