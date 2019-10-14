<%@ page import="weaver.conn.RecordSetDataSource" %>
<%@ page import="java.nio.charset.Charset" %>
<%@ page import="java.security.MessageDigest" %>
<%@ page import="java.security.NoSuchAlgorithmException" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>

<%
    // 单点中选系统
    String myKey = "WzFeBOL+ZDXH3zZu0NFopXCbO3";
    BaseBean baseBean = new BaseBean();
    RecordSetDataSource recordSet = new RecordSetDataSource("orcl");
    recordSet.execute("select * from cus_fielddata where id = " + user.getUID());
    String LoginName = "";
    if (recordSet.next()) {
        LoginName = recordSet.getString("field7"); // 人员自定义字段
    }

    String Timestamp = String.valueOf(System.currentTimeMillis() / 1000);
    String Sign = MD5(LoginName + Timestamp + myKey);

    String url = "http://zs.4008863456.com/hx/service/LoginSystem?LoginName=" + LoginName + "&Timestamp=" + Timestamp + "&Sign=" + Sign;
    baseBean.writeLog(TimeUtil.getCurrentTimeString() + " 单点中选系统访问url： " + url);
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
        return new String(str).toUpperCase();
    }

%>





