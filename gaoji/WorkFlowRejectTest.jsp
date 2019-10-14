<%@ page import="weaver.workflow.webservices.WorkflowRequestInfo" %>
<%@ page import="weaver.workflow.webservices.WorkflowServiceImpl" %>
<%@ page import="weaver.general.BaseBean" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea" %>
<%@ taglib uri="/WEB-INF/tld/browser.tld" prefix="brow" %>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page"/>
<script type="text/javascript" src="/js/select/script/jquery-1.8.3.min_wev8.js"></script>

<%

    BaseBean baseBean = new BaseBean();
    WorkflowServiceImpl workflowService = new WorkflowServiceImpl();
    WorkflowRequestInfo workflowRequestInfo = new WorkflowRequestInfo();

    String requestid = "544";
    int createrid = 149;
    String result = workflowService.submitWorkflowRequest(workflowRequestInfo, Integer.parseInt(requestid.trim()), createrid, "reject", "no");
    baseBean.writeLog("归档结果================： " + result);
    out.clear();
    out.print("归档结果================： " + result);

%>






