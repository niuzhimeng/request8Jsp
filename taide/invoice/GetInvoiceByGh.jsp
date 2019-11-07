<%@ page import="com.alibaba.fastjson.JSONArray" %>
<%@ page import="com.alibaba.fastjson.JSONObject" %>
<%@ page import="com.weavernorth.taide.util.TaiDeOkHttpUtils" %>
<%@ page import="org.apache.commons.codec.binary.Base64" %>
<%@ page import="weaver.conn.RecordSet" %>
<%@ page import="weaver.general.BaseBean" %>
<%@ page import="javax.crypto.Mac" %>
<%@ page import="javax.crypto.spec.SecretKeySpec" %>
<%@ page import="java.nio.charset.StandardCharsets" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>

<%
    // 获取发票信息url
    String getInvoiceUrl = "http://101.124.7.184:8111/rest/openApi/invoice/dii";
    // 授权id
    String appSecId = "d4bf814c02abb801a2a2b6742a6d140a";
    String appSecKey = "116837c1750110f87f285feb2148ad2c";
    String appId = "BXSDK";
    String enterpriseId = "000001";
    RecordSet recordSet = new RecordSet();
    BaseBean baseBean = new BaseBean();
    try {
        baseBean.writeLog("获取发票信息开始========================");
        int uid = user.getUID();
        recordSet.executeQuery("select workcode from hrmresource where id = " + uid);
        recordSet.next();
        // 员工工号
        String userId = recordSet.getString("workcode");

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
                "&globalInfo={\"appId\":\"" + appId + "\",\"version\":\"v1.0\",\"interfaceCode\":\"SELECT_INVOICE_LIST\",\"enterpriseCode\":\"null\"}" +
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
        globalInfoObject.put("interfaceCode", "SELECT_INVOICE_LIST");
        paramObject.put("globalInfo", globalInfoObject);

        paramObject.put("data", dataObject);

        baseBean.writeLog("发送param： " + paramObject.toJSONString());

        // 调用接口
        String returnInvoice = TaiDeOkHttpUtils.post(getInvoiceUrl, paramObject.toJSONString());
        baseBean.writeLog("获取发票接口返回： " + returnInvoice);
        JSONObject returnObject = JSONObject.parseObject(returnInvoice);
        JSONObject returnInfo = returnObject.getJSONObject("returnInfo");
        if (!"0000".equals(returnInfo.getString("returnCode"))) {
            baseBean.writeLog("获取发票信息错误： " + returnObject.toJSONString());
        }

        JSONArray invoiceArray = returnObject.getJSONArray("invoice");

        // 删除旧信息
        recordSet.executeUpdate("delete from uf_fpinfo where userId = '" + userId + "' and enterpriseId = '" + enterpriseId + "'");
        recordSet.executeUpdate("delete from uf_fpseinfo where userId = '" + userId + "' and enterpriseId = '" + enterpriseId + "'");

        // 插入新的发票信息
        insert(invoiceArray, userId, enterpriseId);

    } catch (Exception e) {
        baseBean.writeLog("发票接口异常： " + e);
    }

%>

<%!
    private void insert(JSONArray invoiceArray, String userId, String enterpriseId) {
        RecordSet mainSet = new RecordSet();
        RecordSet detailSet = new RecordSet();
        BaseBean baseBean = new BaseBean();
        try {
            String insertSql = "insert into uf_fpinfo(uuid, invoiceTypeCode, invoiceCode, invoiceNo, invoiceDate, " +
                    "totalAmount,invoiceAmount,taxAmount,isCanceled,reimburseState, " +
                    "checkState, isDeductible, transferTax, reimbursableAmount, userId, " +
                    "enterpriseId, salerName, buyerName, currencyTypeCode, currencyTypeName," +
                    "reimburseLineTotalAmount, invoiceTypeName) " +
                    "values (?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?)";

            String insertDetailSql = "insert into uf_fpseinfo(uuid, goodsName, model, unit, invoiceNo, " +
                    "invoiceCode,unitPrice,noTaxAmount,taxRate,taxAmount, " +
                    "detailNo, expenseItem, plateNo, type, trafficDateStart, " +
                    "trafficDateEnd, reimbursedetailamount, userId, enterpriseId, detailReimbursableAmount," +
                    "detailTransferTax)" +
                    "values (?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?)";
            int size = invoiceArray.size();
            baseBean.writeLog("返回发票总数： " + size);
            for (int i = 0; i < size; i++) {
                String uuid = invoiceArray.getJSONObject(i).getString("uuid");
                String invoiceNo = invoiceArray.getJSONObject(i).getString("invoiceNo");
                String invoiceCode = invoiceArray.getJSONObject(i).getString("invoiceCode");
                String isDeductible = invoiceArray.getJSONObject(i).getString("isDeductible");
                mainSet.executeUpdate(insertSql,
                        uuid,
                        invoiceArray.getJSONObject(i).getString("invoiceTypeCode"),
                        invoiceArray.getJSONObject(i).getString("invoiceCode"),
                        invoiceNo,
                        invoiceCode,

                        invoiceArray.getJSONObject(i).getString("totalAmount"),
                        invoiceArray.getJSONObject(i).getString("invoiceAmount"),
                        invoiceArray.getJSONObject(i).getString("taxAmount"),
                        invoiceArray.getJSONObject(i).getString("isCanceled"),
                        invoiceArray.getJSONObject(i).getString("reimburseState"),

                        invoiceArray.getJSONObject(i).getString("checkState"),
                        isDeductible,
                        invoiceArray.getJSONObject(i).getString("inputtaxamount"),
                        invoiceArray.getJSONObject(i).getString("reimbursableAmount"),
                        userId,

                        enterpriseId,
                        invoiceArray.getJSONObject(i).getString("salerName"),
                        invoiceArray.getJSONObject(i).getString("buyerName"),
                        invoiceArray.getJSONObject(i).getString("currencyTypeCode"),
                        invoiceArray.getJSONObject(i).getString("currencyTypeName"),

                        invoiceArray.getJSONObject(i).getString("reimburseLineTotalAmount"),
                        invoiceArray.getJSONObject(i).getString("invoiceTypeName")
                );
                // 插入明细
                JSONArray detailList = invoiceArray.getJSONObject(i).getJSONArray("detailList");
                if (detailList == null || !"Y".equalsIgnoreCase(isDeductible)) {
                    continue;
                } else {
                    for (int j = 0; j < detailList.size(); j++) {
                        detailSet.executeUpdate(insertDetailSql,
                                uuid,
                                detailList.getJSONObject(j).getString("goodsName"),
                                detailList.getJSONObject(j).getString("model"),
                                detailList.getJSONObject(j).getString("unit"),
                                invoiceNo,

                                invoiceCode,
                                detailList.getJSONObject(j).getString("unitPrice"),
                                detailList.getJSONObject(j).getString("noTaxAmount"),
                                detailList.getJSONObject(j).getString("taxRate"),
                                detailList.getJSONObject(j).getString("taxAmount"),

                                detailList.getJSONObject(j).getString("detailNo"),
                                detailList.getJSONObject(j).getString("expenseItem"),
                                detailList.getJSONObject(j).getString("plateNo"),
                                detailList.getJSONObject(j).getString("type"),
                                detailList.getJSONObject(j).getString("trafficDateStart"),

                                detailList.getJSONObject(j).getString("trafficDateEnd"),
                                detailList.getJSONObject(j).getString("reimbursedetailamount"),
                                userId,
                                enterpriseId,
                                detailList.getJSONObject(j).getString("detailReimbursableAmount"),

                                detailList.getJSONObject(j).getString("detailTransferTax")
                        );
                    }
                }
            }
        } catch (Exception e) {
            baseBean.writeLog("插入发票信息异常： " + e);
        }
    }
%>