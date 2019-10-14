<%@ page import="weaver.conn.RecordSet" %>
<%@ page import="java.time.LocalDate" %>
<%@ page import="weaver.workflow.webservices.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<%
    //    RecordSet recordSet = new RecordSet();
    Integer workflowId = 77;
//    recordSet.executeQuery("select activeVersionID from workflow_base where id = " + workflowId);
//    if (recordSet.next()) {
//        int activeVersionID = recordSet.getInt("activeVersionID");
//        if (activeVersionID > 0) {
//            workflowId = activeVersionID;
//        }
//    }
//    out.clear();
//    out.print("最新版本流程id： " + workflowId);

    WorkflowRequestTableField[] mainField = new WorkflowRequestTableField[15]; //主表行对象

    int i = 0;
    mainField[i] = new WorkflowRequestTableField();
    mainField[i].setFieldName("shdh");// 字段名
    mainField[i].setFieldValue("收货电弧"); // 店铺名称
    mainField[i].setView(true); //字段是否可见
    mainField[i].setEdit(true); //字段是否可编辑

    WorkflowRequestTableRecord[] mainRecord = new WorkflowRequestTableRecord[1];// 主字段只有一行数据
    mainRecord[0] = new WorkflowRequestTableRecord();
    mainRecord[0].setWorkflowRequestTableFields(mainField);

    WorkflowMainTableInfo workflowMainTableInfo = new WorkflowMainTableInfo();
    workflowMainTableInfo.setRequestRecords(mainRecord);

    //====================================流程基本信息录入
    WorkflowBaseInfo workflowBaseInfo = new WorkflowBaseInfo();
    workflowBaseInfo.setWorkflowId(workflowId.toString());// 流程id

    WorkflowRequestInfo workflowRequestInfo = new WorkflowRequestInfo();// 流程基本信息
    workflowRequestInfo.setCreatorId("149");// 创建人id
    workflowRequestInfo.setRequestLevel("0");// 0 正常，1重要，2紧急
    workflowRequestInfo.setRequestName("ZC-04开业补贴申请" + "-张益源-" + LocalDate.now());// 流程标题
    workflowRequestInfo.setWorkflowBaseInfo(workflowBaseInfo);
    workflowRequestInfo.setWorkflowMainTableInfo(workflowMainTableInfo);// 添加主表字段数据
    workflowRequestInfo.setIsnextflow("0");

    //创建流程的类
    WorkflowServiceImpl service = new WorkflowServiceImpl();
    String requestId = service.doCreateWorkflowRequest(workflowRequestInfo, 149);
    out.clear();
    out.print("流程id： " + requestId);
%>

