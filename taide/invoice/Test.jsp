<%@ page import="com.alibaba.fastjson.JSONObject" %>
<%@ page import="com.weavernorth.taide.util.TaiDeOkHttpUtils" %>
<%@ page import="org.apache.commons.codec.binary.Base64" %>
<%@ page import="weaver.general.BaseBean" %>
<%@ page import="javax.crypto.Mac" %>
<%@ page import="javax.crypto.spec.SecretKeySpec" %>
<%@ page import="java.nio.charset.StandardCharsets" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<%
    // 获取发票信息url
    String getInvoiceUrl = "http://101.124.7.184:8051/rest/openApi/invoice/dii";

    // 授权id
    String appSecId = "d4bf814c02abb801a2a2b6742a6d140a";
    String appSecKey = "116837c1750110f87f285feb2148ad2c";
    String appId = "BXSDK";
    String userId = "1111";
    String enterpriseId = "000001";

    BaseBean baseBean = new BaseBean();
    try {
        baseBean.writeLog("获取发票信息开始========================");
        Base64 base64 = new Base64();

        JSONObject dataObject = new JSONObject(true);
        dataObject.put("enterpriseId", enterpriseId);
        dataObject.put("userId", userId);
        dataObject.put("invoiceTime", "");
        dataObject.put("reimburseState", "0");
        dataObject.put("invoiceTypeCode", "");

        dataObject.put("page", "");
        dataObject.put("rows", "");

        String myDataStr = dataObject.toJSONString().replaceAll("\\s*", "");

        baseBean.writeLog("myDataStr======= " + myDataStr);

        String srcStr = "POST/rest/openApi/invoice/dii?" +
                "authorize={\"appSecId\":\"" + appSecId + "\"}" +
                "&globalInfo={\"appId\":\"" + appId + "\",\"version\":\"v1.0\",\"interfaceCode\":\"INVOICE_LIST_QUERY\",\"enterpriseCode\":\"null\"}" +
                "&data=" + new String(base64.encode(myDataStr.getBytes()), StandardCharsets.UTF_8);
        baseBean.writeLog("srcStr1: " + srcStr);

        SecretKeySpec keySpec = new SecretKeySpec(appSecKey.getBytes(StandardCharsets.UTF_8), "HmacSHA1");
        Mac mac = Mac.getInstance("HmacSHA1");
        mac.init(keySpec);
        byte[] signBytes = mac.doFinal(srcStr.getBytes(StandardCharsets.UTF_8));

        String appSec = new String(base64.encode(signBytes), StandardCharsets.UTF_8);
        baseBean.writeLog("appSec======================= " + appSec);

        JSONObject paramObject = new JSONObject(true);

        JSONObject authorizeObject = new JSONObject(true);
        authorizeObject.put("appSecId", appSecId);
        authorizeObject.put("appSec", appSec);
        paramObject.put("authorize", authorizeObject);

        JSONObject globalInfoObject = new JSONObject(true);
        globalInfoObject.put("appId", appId);
        globalInfoObject.put("version", "v1.0");
        globalInfoObject.put("interfaceCode", "INVOICE_LIST_QUERY");
        paramObject.put("globalInfo", globalInfoObject);

        paramObject.put("data", dataObject);

        baseBean.writeLog("发送param： " + paramObject.toJSONString());

        String returnInvoice = TaiDeOkHttpUtils.post(getInvoiceUrl, paramObject.toJSONString());
        out.clear();
        out.print("发票返回： " + returnInvoice);
    } catch (Exception e) {
        baseBean.writeLog("发票接口异常： " + e);
    }

%>