<%@ page import="weaver.conn.RecordSet" %>
<%@ page import="org.apache.commons.lang.StringUtils" %>
<%@ page import="org.apache.axis.client.Service" %>
<%@ page import="org.apache.axis.client.Call" %>
<%@ page import="org.apache.axis.encoding.XMLType" %>
<%@ page import="javax.xml.rpc.ParameterMode" %>
<%@ page import="org.dom4j.Document" %>
<%@ page import="org.dom4j.DocumentHelper" %>
<%@ page import="org.dom4j.Element" %>
<%@ page import="weaver.general.BaseBean" %>
<%@ page import="weaver.general.TimeUtil" %>
<%@ page import="java.util.Calendar" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="ln.LN" %>
<%@ page import="weaver.general.StaticObj" %>
<%@ page import="weaver.hrm.User" %>
<%@ page import="weaver.hrm.OnLineMonitor" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="weaver.systeminfo.SysMaintenanceLog" %>
<%@ page import="weaver.systeminfo.template.UserTemplate" %>
<%@ page import="java.nio.charset.StandardCharsets" %>
<%@ page import="java.util.Enumeration" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>


<%
    BaseBean baseBean = new BaseBean();
    baseBean.writeLog("网关单点oa Start============ " + TimeUtil.getCurrentTimeString());
    try {
        String dnName = request.getHeader("dnname");
        baseBean.writeLog("接收到dnName: " + dnName);
        if (dnName == null) {
            dnName = "";
        } else {
            dnName = new String(request.getHeader("dnname").getBytes("ISO8859-1"), StandardCharsets.UTF_8);
        }

        baseBean.writeLog("转码后dnName: " + dnName);
        String clientIp = request.getHeader("clientip");
        int start = dnName.indexOf("E=") + 2;
        int end = dnName.indexOf(",", start);

        baseBean.writeLog("clientIp: " + clientIp);
        baseBean.writeLog("start: " + start);
        baseBean.writeLog("end: " + end);
        Enumeration names = request.getHeaderNames();//取得全部头信息
        while (names.hasMoreElements()) {//以此取出头信息
            String headerName = (String) names.nextElement();
            String headerValue = request.getHeader(headerName);//取出头信息内容
            baseBean.writeLog("headerName: " + headerName);
            baseBean.writeLog("headerValue: " + headerValue);
        }
        out.clear();
        out.print("成功访问============");

    } catch (Exception e) {
        baseBean.writeLog("网关单点OA异常： " + e);
    }

    baseBean.writeLog("网关单点oa End============  " + TimeUtil.getCurrentDateString());

%>

<%!
    /**
     * 获取日志信息
     */
    private String getLogMessage(String uid) {
        String message = "";
        RecordSet rs = new RecordSet();
        String sqltmp = "";
        if (rs.getDBType().equals("oracle")) {
            sqltmp = "select * from (select * from SysMaintenanceLog where relatedid = " + uid + " and operatetype='6' and operateitem='60' order by id desc ) where rownum=1 ";
        } else if (rs.getDBType().equals("db2")) {
            sqltmp = "select * from SysMaintenanceLog where relatedid = " + uid + " and operatetype='6' and operateitem='60' order by id desc fetch first 1 rows only ";
        } else if (rs.getDBType().equals("mysql")) {
            sqltmp = "SELECT t2.* FROM (SELECT * FROM SysMaintenanceLog WHERE relatedid = " + uid + " and  operatetype='6' AND operateitem='60' ORDER BY id DESC) t2  LIMIT 1 ,1";
        } else {
            sqltmp = "select top 1 * from SysMaintenanceLog where relatedid = " + uid + " and operatetype='6' and operateitem='60' order by id desc";
        }

        rs.executeSql(sqltmp);
        if (rs.next()) {
            message = rs.getString("clientaddress") + " " + rs.getString("operatedate") + " " + rs.getString("operatetime");
        }

        return message;
    }

    /**
     * 判断浏览器是否为IE
     *
     * @param request
     * @return
     */
    private String getisIE(HttpServletRequest request) {
        String isIE = "true";
        String agent = request.getHeader("User-Agent").toLowerCase();
        if (!agent.contains("rv:11") && !agent.contains("msie")) {
            isIE = "false";
        }
        if (agent.contains("rv:11") || agent.indexOf("msie") > -1) {
            isIE = "true";
        }
        return isIE;
    }
%>