<%@ page import="weaver.conn.RecordSet" %>
<%@ page import="java.security.MessageDigest" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>

<%
    // 单点宏景HR
    BaseBean baseBean = new BaseBean();
    RecordSet recordSet = new RecordSet();
    baseBean.writeLog("单点宏景HR接口执行--------------> " + TimeUtil.getCurrentTimeString());
    baseBean.writeLog("uid--------------> " + user.getUID());
    recordSet.execute("select certificatenum from hrmresource where id = " + user.getUID());
    // 身份证号码
    String certificatenum = "";
    if (recordSet.next()) {
        certificatenum = recordSet.getString("certificatenum");
        baseBean.writeLog("身份证号码certificatenum--->> " + certificatenum);
    }
    // 时间戳
    String strSysDatetime = String.valueOf(System.currentTimeMillis() / 1000);
    // 经过MD5加密的字符串
    String verify = getMD5OfStr(certificatenum + "OAHJ" + strSysDatetime);

    String url = "http://hr.bmec.net/templates/attestation/sso/ssologon.jsp?verify=" + verify + "&userName=" + certificatenum + "&strSysDatetime=" + strSysDatetime;
    baseBean.writeLog("单点宏景HR接口访问url： " + url);
    response.sendRedirect(url);

%>

<%!
    private static String getMD5OfStr(String unencodeStr) {
        StringBuilder md5StrBuff = new StringBuilder();
        try {
            MessageDigest messageDigest = MessageDigest.getInstance("MD5");
            messageDigest.reset();
            messageDigest.update(unencodeStr.getBytes("utf-8"));
            byte[] byteArray = messageDigest.digest();
            for (byte b : byteArray) {
                if (Integer.toHexString(0xFF & b).length() == 1)
                    md5StrBuff.append("0").append(Integer.toHexString(0xFF & b));
                else {
                    md5StrBuff.append(Integer.toHexString(0xFF & b));
                }
            }
        } catch (Exception e) {
            new BaseBean().writeLog("getMD5OfStr异常： " + e);
        }
        return md5StrBuff.toString();
    }

%>



















