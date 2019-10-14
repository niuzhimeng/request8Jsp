<!DOCTYPE html>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea" %>
<%@ taglib uri="/WEB-INF/tld/browser.tld" prefix="brow" %>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page"/>
<%@ page import="ln.TimeUtil" %>
<%@ page import="weaver.conn.RecordSet" %>
<%@ page import="java.nio.charset.Charset" %>
<%@ page import="java.security.MessageDigest" %>
<%@ page import="java.security.NoSuchAlgorithmException" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>

<%
    /**
     * 时尚控股 - OA单点预算
     */
    String baseUrl = "http://114.113.152.248/app/sskg/oauth/callback.jsp";
    String key = "leBVrtFWGCqVBpPbbv6gTDmzkMWzFeBOL+ZDXH3zZu0NFopXCbO3zkLdpom6lYWHB8bFuPH2t70VSDWvSxYIecyooLypqVqNf7k08lGObvJbDFY+chf7afgw2GOzvbTfxib7vNVqU3NrQYbja2XLjVVNmGvnPHBmVNyXFZLGdLK07Xlrb2GoiL40R4ZqxsaEjo0M0asXx4tovr96mS3c9ZsHkpAeu3C66rReOxwtW+01NiZySEmG0WD88U3GipK7HWTA5xUMTRyRqNeT4h67VlNQ2KxXy0ACzJiQSUnhIQGqsvqWT89W1vbZyfu5PsXwOPzs6d2uorLUHfrl0dqWedO+FHuSAV5DfiTF4KHzJoGuCkRGjHIc2G12Q4X14k5phgHu2SF0sSZDTn4GFl2Syenc0GTUH27+Y8Hr7Mhjns4O35yUjjrcFxts4FupVl5iD97PxMfO3kIaZEdWcpigYxA+0yCybI7sFqpfQO9B69q9dqmt0TXvqQXZJ6F+Qh77h4Sp";



    BaseBean baseBean = new BaseBean();
    RecordSet recordSet = new RecordSet();
    baseBean.writeLog("uid--------------> " + user.getUID());
    recordSet.execute("select * from hrmresource where id = " + user.getUID());
    String lastname = "";
    String usercode = "";
    if (recordSet.next()) {
        usercode = recordSet.getString("workcode");
        lastname = recordSet.getString("lastname").replaceAll("\\s*", "").toLowerCase();
        baseBean.writeLog("workcode--->> " + usercode);
    }
    String timestamp = String.valueOf(System.currentTimeMillis() / 1000);
    String authid = MD5(usercode + lastname + timestamp + key);

    String url = baseUrl + "?usercode=" + usercode + "&timestamp=" + timestamp + "&authid=" + authid;
    baseBean.writeLog("OA_SSO_NC URL->" + url);

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

