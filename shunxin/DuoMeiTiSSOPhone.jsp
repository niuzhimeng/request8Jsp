<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>

<%
    BaseBean baseBean = new BaseBean();
    try {
        String loginid = user.getLoginid();
        //正式地址
        String zsUrl = "http://media.shunxinholdings.com/Medium-app/index.html?type=1&username=" + loginid;
        baseBean.writeLog("手机端单点多媒体系统url： " + zsUrl);
        zsUrl = "http://www.baidu.com";
        response.sendRedirect(zsUrl);
    } catch (Exception e) {
        baseBean.writeLog("手机端单点多媒体系统异常： " + e);
    }
%>