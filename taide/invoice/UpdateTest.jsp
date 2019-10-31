<%@ page import="com.alibaba.fastjson.JSONArray" %>
<%@ page import="com.alibaba.fastjson.JSONObject" %>
<%@ page import="com.weavernorth.taide.util.TaiDeOkHttpUtils" %>
<%@ page import="org.apache.commons.codec.binary.Base64" %>
<%@ page import="weaver.conn.RecordSet" %>
<%@ page import="weaver.general.BaseBean" %>
<%@ page import="javax.crypto.Mac" %>
<%@ page import="javax.crypto.spec.SecretKeySpec" %>
<%@ page import="java.nio.charset.StandardCharsets" %>
<%@ page import="weaver.general.TimeUtil" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<%
    // 更新发票信息url
    String getInvoiceUrl = "http://101.124.7.184:8051/rest/openApi/invoice/dii";

    // 授权id
    String appSecId = "d4bf814c02abb801a2a2b6742a6d140a";
    String appSecKey = "116837c1750110f87f285feb2148ad2c";
    String appId = "BXSDK";
    String userId = "1111";
    RecordSet recordSet = new RecordSet();
    BaseBean baseBean = new BaseBean();
    try {
        baseBean.writeLog("更新发票信息开始========================");
        Base64 base64 = new Base64();

        JSONArray dataArrayObject = new JSONArray();

        JSONObject dataObject = new JSONObject(true);

        dataObject.put("uuid", "89cd8d859063452d9d85da02559a67c6");
        dataObject.put("reimburseSerialNo", "123123"); // 流程编号
        dataObject.put("reimburseSource", "2"); // 单据来源
        dataObject.put("reimburseState", "2"); // 0：未报销 2：报销中 3：已报销
        dataObject.put("userId", userId);

        dataObject.put("certificateNumber", "0");
        dataObject.put("isDeductible", "Y"); //  是否可抵扣
        dataObject.put("reimburseDate", TimeUtil.getCurrentDateString().replace("-", ""));

        dataArrayObject.add(dataObject);

        String myDataStr = dataArrayObject.toJSONString().replaceAll("\\s*", "");

        baseBean.writeLog("myDataStr======= " + myDataStr);

        String srcStr = "POST/rest/openApi/invoice/dii?" +
                "authorize={\"appSecId\":\"" + appSecId + "\"}" +
                "&globalInfo={\"appId\":\"" + appId + "\",\"version\":\"v1.0\",\"interfaceCode\":\"REIMBURSE_UPDATE\",\"enterpriseCode\":\"null\"}" +
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
        globalInfoObject.put("interfaceCode", "REIMBURSE_UPDATE");
        paramObject.put("globalInfo", globalInfoObject);

        paramObject.put("data", dataArrayObject);

        baseBean.writeLog("发送param： " + paramObject.toJSONString());

        // 调用接口
        String returnInvoice = TaiDeOkHttpUtils.post(getInvoiceUrl, paramObject.toJSONString());
        baseBean.writeLog("更新发票接口返回： " + returnInvoice);

        JSONObject returnObject = JSONObject.parseObject(returnInvoice);
        JSONObject returnInfo = returnObject.getJSONObject("returnInfo");
        if (!"9995".equals(returnInfo.getString("returnCode"))) {
            baseBean.writeLog("发票状态更新异常： " + returnObject.toJSONString());
        }


    } catch (Exception e) {
        baseBean.writeLog("发票接口异常： " + e);
    }

%>
