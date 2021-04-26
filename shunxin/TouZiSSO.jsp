<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.BaseBean" %>
<%@ page import="weaver.general.MD5" %>
<%
    BaseBean baseBean = new BaseBean();
    MD5 md5 = new MD5();

    String zsUrl = "http://123.124.150.227:8332/gw/base/api/autoLogin";
    try {
        String loginId = user.getLoginid();
        String auth = md5.getMD5ofStr(loginId);
        baseBean.writeLog("loginId----->" + loginId + "   加密串----->" + auth);

        String realUrl = zsUrl + "?username=" + loginId + "&auth=" + auth;
        baseBean.writeLog("单点投资系统访问url： " + realUrl);
        response.sendRedirect(realUrl);


    } catch (Exception e) {
        baseBean.writeLog("单点投资系统异常： " + e);
    }
%>