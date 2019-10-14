<%@ page import="com.weavernorth.taide.kaoQin.jcoTimed.timedTask.GongYingShangTimed" %>
<%@ page import="com.weavernorth.taide.kaoQin.jcoTimed.timedTask.WuLiaoTimed" %>
<%@ page import="com.weavernorth.taide.kaoQin.kqmx.timedTask.TimedKqmx" %>
<%@ page import="com.weavernorth.taide.kaoQin.kqyc.timedTask.TimedKqyc" %>
<%@ page import="com.weavernorth.taide.kaoQin.pbsj05.timedTask.TimedPbsj" %>
<%@ page import="com.weavernorth.taide.kaoQin.sksj.timedTask.SendSksjToSapTimed14" %>
<%@ page import="com.weavernorth.taide.kaoQin.syjq04.timedTask.TimedSyjq" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page"/>
<%@ include file="/systeminfo/init_wev8.jsp" %>


<%
    String myType = request.getParameter("myType");
    if ("1".equals(myType)) {
        new TimedKqmx().execute();
        out.clear();
        out.print("考勤明细同步完成。" + TimeUtil.getCurrentTimeString());
    } else if ("2".equals(myType)) {
        new TimedKqyc().execute();
        out.clear();
        out.print("考勤异常同步完成。" + TimeUtil.getCurrentTimeString());
    } else if ("3".equals(myType)) {
        new TimedPbsj().execute();
        out.clear();
        out.print("排班数据同步完成。" + TimeUtil.getCurrentTimeString());
    } else if ("4".equals(myType)) {
        new TimedSyjq().execute();
        out.clear();
        out.print("剩余假期同步完成。" + TimeUtil.getCurrentTimeString());
    } else if ("5".equals(myType)) {
        new SendSksjToSapTimed14().execute();
        out.clear();
        out.print("刷卡数据推送完成。" + TimeUtil.getCurrentTimeString());
    } else if ("6".equals(myType)) {
        new WuLiaoTimed().execute();
        out.clear();
        out.print("物料数据推送完成。" + TimeUtil.getCurrentTimeString());
    } else if ("7".equals(myType)) {
        new GongYingShangTimed().execute();
        out.clear();
        out.print("供应商数据推送完成。" + TimeUtil.getCurrentTimeString());
    }


%>