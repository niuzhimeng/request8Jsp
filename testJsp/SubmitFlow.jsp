<%@ page import="weaver.workflow.webservices.WorkflowRequestInfo" %>
<%@ page import="weaver.workflow.webservices.WorkflowServiceImpl" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<%
    WorkflowServiceImpl workflowService = new WorkflowServiceImpl();
    String s = workflowService.submitWorkflowRequest(new WorkflowRequestInfo(), 1402, 150, "submit", "ok");
    out.clear();
    out.print("提交结果： " + s);
%>


<script type="text/javascript">
    jQuery(document).ready(function () {
            checkCustomize = function () {
                window.top.Dialog.alert('该流程不允许手动提交');
                return false;
            }
        })
</script>
