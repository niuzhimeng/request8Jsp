<%@ page import="org.apache.commons.codec.binary.Base64" %>
<%@ page import="weaver.conn.RecordSet" %>
<%@ page import="weaver.general.BaseBean" %>
<%@ page import="java.nio.charset.StandardCharsets" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<%
    BaseBean baseBean = new BaseBean();
    // 企业id
    String enterpriseId = request.getParameter("enterpriseId");
    String uid = request.getParameter("myUserId");
    // 票夹页面url
    String getInvoiceUrl = "https://wx.5ifapiao.com/bxsdktd/rest/bxsdk/web/authorize?data=";
    // 授权id
    String appSecId = "d4bf814c02abb801a2a2b6742a6d140a";

    try {

        RecordSet recordSet = new RecordSet();
        recordSet.executeQuery("select workcode from hrmresource where id = " + uid);
        recordSet.next();
        // 员工工号
        String userId = recordSet.getString("workcode");

        String myData = "{\"appSecId\":\"" + appSecId + "\",\"userId\":\"" + userId + "\",\"enterpriseId\":\"" + enterpriseId + "\"}";
        baseBean.writeLog("myData=========== " + myData);

        Base64 base64 = new Base64();
        String baseData = new String(base64.encode(myData.getBytes()), StandardCharsets.UTF_8);
        baseBean.writeLog("base64加密后Data===========" + baseData);

        String sendUrl = getInvoiceUrl + baseData;
        baseBean.writeLog("访问票夹页面url： " + sendUrl);

        out.clear();
        out.print(sendUrl);
    } catch (Exception e) {
        baseBean.writeLog("发票接口异常： " + e);
    }

%>