<%@ page import="com.google.gson.JsonObject" %>
<%@ page import="com.google.gson.JsonParser" %>
<%@ page import="weaver.conn.RecordSet" %>
<%@ page import="weaver.integration.util.HTTPUtil" %>
<%@ page import="javax.crypto.Cipher" %>
<%@ page import="javax.crypto.spec.SecretKeySpec" %>
<%@ page import="java.nio.charset.StandardCharsets" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page"/>
<%@ include file="/systeminfo/init_wev8.jsp" %>

<%
    //String url = "http://sso.ceshi113.com/sign/redirect"; //测试
    String url = "https://sso.fxiaoke.com/sign/redirect"; // 正式
    BaseBean baseBean = new BaseBean();
    RecordSet recordSet = new RecordSet();
    try {
        baseBean.writeLog("uid--------------> " + user.getUID());
        recordSet.execute("select workcode from hrmresource where id = " + user.getUID());
        String usercode = "";
        if (recordSet.next()) {
            usercode = recordSet.getString("workcode");
            baseBean.writeLog("workcode--->> " + usercode);
        }

        String currentTime = String.valueOf(System.currentTimeMillis());

        String appId = "FSAID_1317049";
        String sign = encryptComm(currentTime + usercode + appId, "ayfO9anPjkTiWz1V");

        // 拼接入参
        JsonObject object = new JsonObject();
        object.addProperty("timeStamp", currentTime);
        object.addProperty("account", usercode); // 唯一标识
        object.addProperty("appId", appId); // 应用id
        object.addProperty("sign", sign);

        Map<String, String> map = new HashMap<String, String>();
        map.put("ea", "tuanchenet");
        map.put("code", object.toString());

        baseBean.writeLog("单点逍客系统发送map： " + map);
        String returns = HTTPUtil.doPost(url, map);

        baseBean.writeLog("单点逍客系统返回： " + returns);

        JsonObject jsonObject = new JsonParser().parse(returns).getAsJsonObject();
        String code = jsonObject.get("code").isJsonNull() ? "" : jsonObject.get("code").getAsString();
        if ("200".equalsIgnoreCase(code)) {
            String realUrl = jsonObject.get("data").isJsonNull() ? "" : jsonObject.get("data").getAsString();
            response.sendRedirect(realUrl);
        } else {
            out.clear();
            out.print(returns);
        }
    } catch (Exception e) {
        baseBean.writeLog("单点逍客系统异常： " + TimeUtil.getCurrentTimeString() + " " + e);
    }

%>

<%!


    /**
     * AES-ECB加密模式
     * @return
     */
    private String encryptComm(String srcStr, String sKey) throws Exception {
        byte[] raw = sKey.getBytes(StandardCharsets.UTF_8);
        byte[] sSrc = srcStr.getBytes(StandardCharsets.UTF_8);
        SecretKeySpec skeySpec = new SecretKeySpec(raw, "AES");
        Cipher cipher = Cipher.getInstance("AES/ECB/PKCS5Padding");//"算法/模式/补码方式"
        cipher.init(Cipher.ENCRYPT_MODE, skeySpec);
        byte[] encrypted = cipher.doFinal(sSrc);
        //此处使用BASE64做转码功能，同时能起到2次加密的作用。
        return parseByte2HexStr(encrypted);
    }

    /**
     * 将二进制转换成16进制
     * @param buf
     * @return
     */
    private static String parseByte2HexStr(byte[] buf) {
        StringBuilder strb = new StringBuilder();
        for (byte b : buf) {
            String index = Integer.toHexString(b & 0xFF);
            if (index.length() == 1) {
                index = '0' + index;
            }
            strb.append(index.toUpperCase());
        }
        return strb.toString();
    }


%>