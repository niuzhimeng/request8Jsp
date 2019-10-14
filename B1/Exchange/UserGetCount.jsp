<%@ page import="org.apache.axis.client.Call" %>
<%@ page import="org.apache.axis.client.Service" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea" %>
<%@ taglib uri="/WEB-INF/tld/browser.tld" prefix="brow" %>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page"/>
<jsp:useBean id="baseBean" class="weaver.general.BaseBean" scope="page"/>
<script type="text/javascript" src="/js/select/script/jquery-1.8.3.min_wev8.js"></script>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%
    String workCode = request.getParameter("workCode");
    try {
        String endpoint = "http://124.23.6.1:7888/tscp_jhx/tscpdxp/khdaipservice";
        Service service = new Service();
        Call call = (Call) service.createCall();
        call.setTargetEndpointAddress(endpoint);
        call.setProperty(org.apache.axis.client.Call.SEND_TYPE_ATTR, Boolean.FALSE);
        call.setProperty(org.apache.axis.AxisEngine.PROP_DOMULTIREFS, Boolean.FALSE);
        call.setSOAPVersion(org.apache.axis.soap.SOAPConstants.SOAP11_CONSTANTS);
        call.setOperationName(new javax.xml.namespace.QName("", "getUnhandledNumByOperId"));
        String requestXml = (String) call.invoke(new Object[]{workCode});

        new BaseBean().writeLog("交换接口返回xml： " + requestXml);
        //requestXml = requestXml.replace("<?xml version=1.0 encoding=UTF-8?>", "");
        out.print(requestXml);
    } catch (Exception e) {
       out.print(e);
    }

%>




