<%@ page import="weaver.general.BaseBean" %>
<%@ page import="org.apache.commons.codec.binary.Base64" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<%
    BaseBean baseBean = new BaseBean();
    // 票夹页面url
    String getInvoiceUrl = "http://101.124.7.184:8051/rest/bxsdk/web/authorize?data=";
    // 授权id
    String appSecId = "d4bf814c02abb801a2a2b6742a6d140a";
    try {
        // 员工号
        String userId = "1111";
        // 企业id
        String enterpriseId = "000001";

        String myData = "{\"appSecId\":\"" + appSecId + "\",\"userId\":\"" + userId + "\",\"enterpriseId\":\"" + enterpriseId + "\"}";
        baseBean.writeLog("myData=========== " + myData);

        String baseData = new Base64().encodeToString(myData.getBytes());
        baseBean.writeLog("baseData===========" + baseData);

        String sendUrl = getInvoiceUrl + baseData;
        baseBean.writeLog("访问票夹页面url： " + sendUrl);

        response.sendRedirect(sendUrl);
    } catch (Exception e) {
        baseBean.writeLog("发票接口异常： " + e);
    }

%>