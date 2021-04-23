<%@ page import="weaver.conn.RecordSet" %>
<%@ page import="java.nio.charset.Charset" %>
<%@ page import="java.security.MessageDigest" %>
<%@ page import="java.security.NoSuchAlgorithmException" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<%@ include file="/systeminfo/init_wev8.jsp" %>

<%
    BaseBean baseBean = new BaseBean();
    RecordSet recordSet = new RecordSet();
    baseBean.writeLog("OA_SSO_GEPS_2021 接口执行--------------> " + TimeUtil.getCurrentTimeString() +
            ", 登录名： " + user.getLoginid());

    String loginId = "";
    String certificatenum = "";
    recordSet.executeQuery("select * from hrmresource where id = " + user.getUID());
    if (recordSet.next()) {
        loginId = recordSet.getString("loginid");
        certificatenum = recordSet.getString("certificatenum");
    }
    long currentTimeMillis = System.currentTimeMillis();
    String sign = certificatenum.toLowerCase() + currentTimeMillis + loginId.toLowerCase() + "bjsz";
    baseBean.writeLog("sign加密前：" + sign);

    String url = "http://219.142.102.252:8888/Services/Identification/Server/login.ashx?sso=1&ssoProvider=GPMOAJCSSOProvider&IdCard=" + certificatenum +
            "&timeStr=" + currentTimeMillis + "&loginId=" + loginId + "&sign=" + MD5(sign) + "&LoginFlag=custom&service=%7e%2fServices%2fIdentification%2flogin.ashx";
    baseBean.writeLog("OA_SSO_GEPS_2021单点访问url： " + url);
    response.sendRedirect(url);
%>

<%!
    public String MD5(String content) {
        MessageDigest ins = null;
        try {
            ins = MessageDigest.getInstance("MD5");
        } catch (NoSuchAlgorithmException e) {
            e.printStackTrace();
        }
        if (ins != null) {
            ins.update(content.getBytes(Charset.forName("UTF-8")));
        }
        char[] hexDigits = {'0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'a', 'b', 'c', 'd', 'e', 'f'};
        byte[] tmp = new byte[0];
        if (ins != null) {
            tmp = ins.digest();
        }
        char[] str = new char[16 * 2];
        int k = 0;
        for (int i = 0; i < 16; i++) {
            byte byte0 = tmp[i];
            str[k++] = hexDigits[byte0 >>> 4 & 0xf];
            str[k++] = hexDigits[byte0 & 0xf];
        }
        return new String(str);
    }
%>

















