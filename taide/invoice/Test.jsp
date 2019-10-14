<%@ page import="weaver.conn.RecordSet" %>
<%@ page import="weaver.general.BaseBean" %>
<%@ page import="javax.crypto.spec.SecretKeySpec" %>
<%@ page import="javax.crypto.Mac" %>
<%@ page import="org.apache.commons.codec.binary.Base64" %>
<%@ page import="com.weavernorth.taide.util.TaiDeOkHttpUtils" %>
<%@ page import="java.nio.charset.StandardCharsets" %>
<%@ page import="weaver.integration.util.HTTPUtil" %>
<%@ page import="java.util.HashMap" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<%
    // 获取发票信息url
    String getInvoiceUrl = "http://101.124.7.184:8051/rest/openApi/invoice/dii";

    // 授权id
    String appSecId = "d4bf814c02abb801a2a2b6742a6d140a";
    String appSecKey = "116837c1750110f87f285feb2148ad2c";
    BaseBean baseBean = new BaseBean();
    try {
        // 员工号
        String userId = "1111";
        // 企业id
        String enterpriseId = "00001";

        String myData = "{\n" +
                "\t\"enterpriseId\": \"00001\",\n" +
                "\t\"userId\": \"13200001111\",\n" +
                "\t\"invoiceTime\": \"201710\",\n" +
                "\t\"reimburseState \": \"0\",\n" +
                "\t\"invoiceTypeCode\": \"01\",\n" +
                "\t\"page\": \"1\",\n" +
                "\t\"rows\": \"20\"\n" +
                "}";

        String srcStr = "POST/rest/invoice/dii?" +
                "authorize={\"appSecId\":\"" + appSecId + "\"}" +
                "&globalInfo={ \"appId\":\"BXSDK\", \"version\":\"v1.0\", \"interfaceCode\":\"INVOICE_LIST_QUERY\"}" +
                "&data=" + new String(Base64.encodeBase64(myData.getBytes(StandardCharsets.UTF_8)));
        SecretKeySpec keySpec = new SecretKeySpec(appSecKey.getBytes(StandardCharsets.UTF_8), "HmacSHA1");
        Mac mac = Mac.getInstance("HmacSHA1");
        mac.init(keySpec);
        byte[] signBytes = mac.doFinal(srcStr.getBytes(StandardCharsets.UTF_8));
        String appSec = new String(Base64.encodeBase64(signBytes));

        baseBean.writeLog("44===============");
        String getParam = "{\n" +
                "\t\"authorize\": {\n" +
                "\t\t\"appSecId\": \"" + appSecId + "\",\n" +
                "\t\t\"appSec \": \"" + appSec + "\",\n" +
                "\t\t\"interfaceCode\": \"INVOICE_LIST_QUERY\"\n" +
                "\t},\n" +
                "\t\"globalInfo\": {\n" +
                "\t\t\"appId\": \"BXSDK\",\n" +
                "\t\t\"version\": \"v1.0\",\n" +
                "\t\t\"interfaceCode\": \"INVOICE_LIST_QUERY\"\n" +
                "\t},\n" +
                "\t\"data\": {\n" +
                "\t\t\"enterpriseId\": \"00001\",\n" +
                "\t\t\"userId\": \"" + userId + "\",\n" +
                "\t\t\"invoiceTime\": \"201710\",\n" +
                "\t\t\"reimburseState \": \"0\",\n" +
                "\t\t\"invoiceTypeCode\": \"01\",\n" +
                "\t\t\"page\": \"\",\n" +
                "\t\t\"rows\": \"\"\n" +
                "\t}\n" +
                "}";
        String returnInvoice = TaiDeOkHttpUtils.post(getInvoiceUrl, getParam);
        out.clear();
        out.print("发票返回： " + returnInvoice);
    } catch (Exception e) {
        baseBean.writeLog("发票接口异常： " + e);
    }

%>