<!DOCTYPE html>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea" %>
<%@ taglib uri="/WEB-INF/tld/browser.tld" prefix="brow" %>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page"/>
<%@ page import="ln.TimeUtil" %>
<%@ page import="java.nio.charset.Charset" %>
<%@ page import="java.security.MessageDigest" %>
<%@ page import="java.security.NoSuchAlgorithmException" %>
<%@ page import="weaver.conn.RecordSet" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>

<%
    BaseBean baseBean = new BaseBean();
    RecordSet recordSet = new RecordSet();
    recordSet.execute("select * from hrmresource where id = " + user.getUID());
    String key = "OANC";
    String usercode = "";
    if(recordSet.next()){
        usercode = recordSet.getString("workcode");
    }

    String timestamp = TimeUtil.getTimeString(new Date()).replace("-", "").replace(":", "").replaceAll("\\s*", "").substring(0, 12);
    String authid = MD5(usercode + timestamp + key);

    String url = "http://10.31.1.31:802/portalsso/PortalSsoServlet?usercode=" + usercode + "&timestamp=" + timestamp + "&authid=" + authid;
    baseBean.writeLog("OA_SSO_NC 网报 URL->" + url);

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
        ins.update(content.getBytes(Charset.forName("UTF-8")));
        char[] hexDigits = {'0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'a', 'b', 'c', 'd', 'e', 'f'};
        byte[] tmp = ins.digest();
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

