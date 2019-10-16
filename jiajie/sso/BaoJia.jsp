<%@ page import="weaver.conn.RecordSet" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>

<%
    // 报价系统单点登录
    BaseBean baseBean = new BaseBean();
    baseBean.writeLog("单点报价系统Start===========================");
    try {
        // 测试地址
        String testUrl = "http://172.30.10.121:8180/home.seam";
        // 正式地址
        String formalUrl = "http://sso.fxiaoke.com/sign/redirect";
        String key = "test123456";

        long timestamp = System.currentTimeMillis();
        int uid = user.getUID();
        // 手机号
        String mobile = "";
        RecordSet recordSet = new RecordSet();
        recordSet.executeQuery("select mobile from hrmresource where id = " + uid);
        if (recordSet.next()) {
            mobile = recordSet.getString("mobile");
        }
        baseBean.writeLog("当前人手机号==== " + mobile);

        MD5 md5 = new MD5();
        String authid = md5.getMD5ofStr(mobile + timestamp + key);

        String endUrl = testUrl + "?usercode=" + mobile + "&timestamp=" + timestamp + "&authid=" + authid;
        baseBean.writeLog("报价系统跳转地址： " + endUrl);

        response.sendRedirect(endUrl);
    } catch (Exception e) {
        baseBean.writeLog("单点报价系统异常： " + e);
    }

%>
