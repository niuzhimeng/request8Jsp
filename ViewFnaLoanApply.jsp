<%@ page import="java.math.*" %>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page"/>
<jsp:useBean id="ProjectInfoComInfo" class="weaver.proj.Maint.ProjectInfoComInfo" scope="page"/>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/workflow/request/WorkflowViewRequestTitle.jsp" %>
<form name="frmmain" method="post" action="FnaLoanApplyOperation.jsp" enctype="multipart/form-data">
    <%@ include file="/workflow/request/WorkflowViewRequestBody.jsp" %>

<%

session.setAttribute(requestid+"_fieldids",fieldids);                  //字段队列     
session.setAttribute(requestid+"_fieldorders",fieldorders);            //字段显示顺序队列 (单据文件不需要)         
session.setAttribute(requestid+"_languageids",languageids);            //字段显示的语言(单据文件不需要)       
session.setAttribute(requestid+"_fieldlabels",fieldlabels);            //单据的字段的label队列 
      
session.setAttribute(requestid+"_fieldhtmltypes",fieldhtmltypes);      //单据的字段的html type队列        
session.setAttribute(requestid+"_fieldtypes",fieldtypes);              //单据的字段的type队列
session.setAttribute(requestid+"_fieldnames",fieldnames);              //单据的字段的表字段名队列
session.setAttribute(requestid+"_fieldvalues",fieldvalues);            //字段的值 

session.setAttribute(requestid+"_fieldviewtypes",fieldviewtypes);      //单据是否是detail表的字段1:是 0:否(如果是,将不显示)     
session.setAttribute(requestid+"_isfieldids",isfieldids);              //字段队列
session.setAttribute(requestid+"_isviews",isviews);                    //字段是否显示队列

  
%>
 
<jsp:include page="/workflow/request/ViewFnaLoanApplyAssistant.jsp" flush="true">
    <jsp:param name="requestid" value="<%=requestid%>" />
    <jsp:param name="requestlevel" value="<%=requestlevel%>" />
    <jsp:param name="requestmark" value="<%=requestmark%>" />
    <jsp:param name="creater" value="<%=creater%>" />
    <jsp:param name="creatertype" value="<%=creatertype%>" />
    <jsp:param name="deleted" value="<%=deleted%>" />
    <jsp:param name="billid" value="<%=billid%>" />
    <jsp:param name="workflowid" value="<%=workflowid%>" />
    <jsp:param name="formid" value="<%=formid%>" />
    <jsp:param name="nodeid" value="<%=nodeid%>" />
    <jsp:param name="nodetype" value="<%=nodetype%>" />
</jsp:include>    