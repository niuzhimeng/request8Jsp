<%@ page import="weaver.conn.RecordSet" %>
<%@ page import="weaver.general.BaseBean" %>
<%@ page import="weaver.integration.util.HTTPUtil" %>
<%@ page import="com.google.gson.JsonParser" %>
<%@ page import="com.google.gson.JsonObject" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%
    // 研发ip
    String ip = "plm.tidepharm.com";
    String appKey = "C0218";
    String appSecret = "oUHEeSeSm8LR20zaiVt9A";
    BaseBean baseBean = new BaseBean();
    RecordSet recordSet = new RecordSet();
    try {
        recordSet.executeQuery("select workcode from hrmresource where id = " + user.getUID());
        recordSet.next();
        String workCode = recordSet.getString("workcode");
        baseBean.writeLog("单点研发系统 Start =========== " + workCode + " " + TimeUtil.getCurrentTimeString());

        // 获取token
        String getTokenUrl = "http://" + ip + "/8thManage/rest/token/getToken?appKey=" + appKey + "&appSecret=" + appSecret;
        baseBean.writeLog("获取token访问地址： " + getTokenUrl);
        String tokenStr = HTTPUtil.doGet(getTokenUrl);
        baseBean.writeLog("调用获取token接口返回：" + tokenStr);
        JsonObject tokenObject = new JsonParser().parse(tokenStr).getAsJsonObject();

        String errCode = tokenObject.get("errcode").getAsString();
        if (!"0".equalsIgnoreCase(errCode)) {
            out.clear();
            out.print("获取token失败： " + tokenObject);
            return;
        }
        String token = tokenObject.get("token").getAsString();

        // 调用接口加密
        String encryptUrl = "http://" + ip + "/8thManage/rest/sso/getEncryptSSOName?accesstoken=" + token + "&ssoName=" + workCode;
        baseBean.writeLog("加密接口访问地址： " + encryptUrl);
        String encryptStr = HTTPUtil.doGet(encryptUrl);
        baseBean.writeLog("调用加密接口返回： " + encryptStr);
        JsonObject encryptObject = new JsonParser().parse(encryptStr).getAsJsonObject();

        String errCode1 = encryptObject.get("errcode").getAsString();
        if (!"0".equalsIgnoreCase(errCode1)) {
            out.clear();
            out.print("获取token失败： " + tokenObject);
            return;
        }
        String encryptSSOName = encryptObject.get("encryptSSOName").getAsString();

        String ssoUrl = "http://" + ip + "/8thManage/index.jsp?encryptSSOName=" + encryptSSOName;
        baseBean.writeLog("跳转url： " + ssoUrl);
        response.sendRedirect(ssoUrl);
    } catch (Exception e) {
        baseBean.writeLog("单点研发系统 Err: " + e);
    }
%>