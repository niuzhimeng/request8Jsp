<%@ page import="com.alibaba.fastjson.JSONObject" %>
<%@ page import="weaver.conn.RecordSet" %>
<%@ page import="javax.crypto.Cipher" %>
<%@ page import="javax.crypto.spec.SecretKeySpec" %>
<%@ page import="java.io.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>

<%
    // 分享销客单点登录
    BaseBean baseBean = new BaseBean();
    baseBean.writeLog("单点纷享销客Start===========================");
    String endUrl = "";
    try {
        // 测试地址
        String testUrl = "http://sso.ceshi113.com/sign/redirect";
        // 正式地址
        String formalUrl = "http://sso.fxiaoke.com/sign/redirect";

        String ea = "61126";
        String appId = "FSAID_1314644";
        String skey = "fo5$VJ3zEa#Zb&yM";
        long timeStamp = System.currentTimeMillis();

        int uid = user.getUID();
        // 手机号
        String mobile = "";
        RecordSet recordSet = new RecordSet();
        recordSet.executeQuery("select mobile from hrmresource where id = " + uid);
        if (recordSet.next()) {
            mobile = recordSet.getString("mobile");
        }
        baseBean.writeLog("当前人手机号==== " + mobile);

        String sign = encryptComm(timeStamp + mobile + appId, skey);
        JSONObject jsonObject = new JSONObject();
        jsonObject.put("timeStamp", timeStamp);
        jsonObject.put("account", mobile);
        jsonObject.put("appId", appId);
        jsonObject.put("sign", sign);

        String codeStr = jsonObject.toJSONString();

        endUrl = testUrl + "?ea=" + ea + "&code=" + codeStr;

        baseBean.writeLog("销客跳转地址： " + endUrl);
        String returnJson = sendPost(testUrl, ea, codeStr);
        baseBean.writeLog("post请求返回： " + returnJson);

        JSONObject returnObject = JSONObject.parseObject(returnJson);
        String returnCode = returnObject.getString("code");
        baseBean.writeLog("returnCode: " + returnCode);
        if ("200".equals(returnCode)) {
            response.sendRedirect(returnObject.getString("data"));
        } else {
            out.clear();
            out.print(returnObject);
            return;
        }

    } catch (Exception e) {
        baseBean.writeLog("单点销客系统异常： " + e);
    }

%>

<%!
    /**
     * AES-ECB
     * @return
     */
    public static String encryptComm(String srcStr, String sKey) throws Exception {
        byte[] raw = sKey.getBytes("utf-8");
        byte[] sSrc = srcStr.getBytes("utf-8");
        SecretKeySpec skeySpec = new SecretKeySpec(raw, "AES");
        Cipher cipher = Cipher.getInstance("AES/ECB/PKCS5Padding");
        cipher.init(Cipher.ENCRYPT_MODE, skeySpec);
        byte[] encrypted = cipher.doFinal(sSrc);
        return parseByte2HexStr(encrypted);
    }

    /**
     * 16
     * @param buf
     * @return
     */
    public static String parseByte2HexStr(byte buf[]) {
        StringBuffer strb = new StringBuffer();
        for (int idx = 0; idx < buf.length; idx++) {
            String index = Integer.toHexString(buf[idx] & 0xFF);
            if (index.length() == 1) {
                index = '0' + index;
            }
            strb.append(index.toUpperCase());
        }
        return strb.toString();
    }

    private String sendPost(String url, String ea, String code) {
        BaseBean baseBean = new BaseBean();
        BufferedReader reader = null;
        StringBuilder response = new StringBuilder();
        try {
            URL httpUrl = new URL(url);
            //建立连接
            HttpURLConnection conn = (HttpURLConnection) httpUrl.openConnection();
            conn.setRequestMethod("POST");
            conn.setUseCaches(false);//设置不要缓存
            conn.setInstanceFollowRedirects(true);
            conn.setDoOutput(true);
            conn.setConnectTimeout(9000);
            conn.setReadTimeout(9000);
            conn.setDoInput(true);
            conn.setRequestProperty("Content-Type", "application/x-www-form-urlencoded");

            DataOutputStream out = new DataOutputStream(conn.getOutputStream());
            String content = "ea=" + URLEncoder.encode(ea, "UTF-8");
            content += "&code=" + URLEncoder.encode(code, "UTF-8");

            out.writeBytes(content);

            out.flush();
            out.close();

            conn.connect();
            //读取响应
            reader = new BufferedReader(new InputStreamReader(conn.getInputStream()));
            String lines;
            while ((lines = reader.readLine()) != null) {
                lines = new String(lines.getBytes(), "utf-8");
                response.append(lines);
            }
            // 断开连接
            conn.disconnect();
        } catch (Exception e) {
            baseBean.writeLog("佳杰点单sendPost异常： " + e);
        } finally {
            try {
                if (reader != null) {
                    reader.close();
                }
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
        return response.toString();
    }
%>
