<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.conn.RecordSet" %>
<%@ page import="weaver.general.MD5" %>
<%
    BaseBean baseBean = new BaseBean();
    MD5 md5 = new MD5();
    RecordSet rs = new RecordSet();
    //正式地址
    String zsUrl = "http://49.4.115.229:8212/gw/base/api/autoLogin";
    //测试地址
    String csUrl = "http://49.4.115.229:9212/gw/base/api/autoLogin";
    try {
        if ("sysadmin".equals(user.getLoginid())) {
            response.sendRedirect(csUrl + "?username=admin&auth=21232F297A57A5A743894A0E4A801FC3");
        }
        String auth = "";
        baseBean.writeLog(csUrl);
        String workcode = user.getLoginid();
        if (!"".equals(workcode)) {
            auth = md5.getMD5ofStr(workcode);
            baseBean.writeLog("workcode----->" + workcode + "   加密串----->" + auth);
            if (!"".equals(auth)) {
                String realUrl = csUrl + "?username=" + workcode + "&auth=" + auth;
                baseBean.writeLog(realUrl);
                response.sendRedirect(realUrl);
            } else {
                out.clear();
            }
        }
    } catch (Exception e) {
        baseBean.writeLog("单点多媒体系统异常： " + e);
    }
%>