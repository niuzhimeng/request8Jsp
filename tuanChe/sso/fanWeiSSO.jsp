<%@ page import="com.google.gson.JsonObject" %>
<%@ page import="com.google.gson.JsonParser" %>
<%@ page import="org.apache.commons.codec.binary.Hex" %>
<%@ page import="weaver.conn.RecordSet" %>
<%@ page import="weaver.integration.util.HTTPUtil" %>
<%@ page import="java.security.MessageDigest" %>
<%@ page import="java.security.NoSuchAlgorithmException" %>
<%@ page import="java.util.HashMap" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page"/>
<%@ include file="/systeminfo/init_wev8.jsp" %>

<%
    //    String url = "http://sso.ceshi113.com/sign/redirect"; //测试  http://t.haina.tuanche.net/?xxl_sso_sessionid=c97bbfd6-473c-4cee-9225-4b44528ad00a
    String redUrl = "http://t.haina.tuanche.net/?xxl_sso_sessionid="; //测试
    String url = "http://t.innersso.tuanche.net/login/token";
    // String url = "https://sso.fxiaoke.com/sign/redirect"; // 正式
    BaseBean baseBean = new BaseBean();
    RecordSet recordSet = new RecordSet();
    try {
        baseBean.writeLog("uid--------------> " + user.getUID());
        recordSet.execute("select email from hrmresource where id = " + user.getUID());
        String email = "";
        if (recordSet.next()) {
            email = recordSet.getString("email");

        }
        String currentTime = String.valueOf(System.currentTimeMillis());
        baseBean.writeLog("nowTime--->> " + currentTime);
        baseBean.writeLog("email--->> " + email);
//        email=***@tuanche.com&timestamp=1231454556456456
        String str = "email=" + email + "&timestamp=" + currentTime;
        String signStr = securityCon(str);
        // 拼接入参
        Map<String, String> object = new HashMap<String, String>();
        object.put("timestamp", currentTime);
        object.put("email", email); // 唯一标识
        object.put("sign", signStr);

//        Map<String, String> map = new HashMap<String, String>();
//        map.put("ea", "61159");
//        map.put("code", object.toString());
//        baseBean.writeLog("单点协同平台系统发送map： " + map);
        String returns = HTTPUtil.doPost(url, object);
        baseBean.writeLog("单点协同平台系统返回： " + returns);
        JsonObject jsonObject = new JsonParser().parse(returns).getAsJsonObject();
        String code = jsonObject.getAsJsonObject("responseHeader").get("status").toString();
        if ("200".equals(code)) {
            String sessionID = jsonObject.getAsJsonObject("response").get("result").getAsJsonObject().get("sessionId").toString().replace("\"", "");
            redUrl = redUrl + sessionID;
            response.sendRedirect(redUrl);
        } else {
            out.clear();
            out.print(returns);
        }
    } catch (Exception e) {
        baseBean.writeLog("单点协同平台系统异常： " + System.currentTimeMillis() + " " + e);
    }

%>

<%!

    /***
     * 加密
     * @param input
     * @return
     */
    public static String securityCon(String input) {
        try {
            // 拿到一个MD5转换器（如果想要SHA1参数换成”SHA1”）
            MessageDigest messageDigest = MessageDigest.getInstance("MD5");
            // 输入的字符串转换成字节数组
            byte[] inputByteArray = input.getBytes();
            // inputByteArray是输入字符串转换得到的字节数组
            messageDigest.update(inputByteArray);
            byte[] resultByteArray = messageDigest.digest();
            //将byte[]转为16进制字符串
            return Hex.encodeHexString(resultByteArray);
        } catch (NoSuchAlgorithmException var4) {
            var4.printStackTrace();
            return null;
        }
    }


%>