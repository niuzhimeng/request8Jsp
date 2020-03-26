<%@ page import="weaver.general.BaseBean" %>
<%@ page import="weaver.workflow.webservices.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<%
    //流程id
    String workFlowId = "77";
    //流程创建人id
    String createrId = "150";

    BaseBean baseBean = new BaseBean();
    try {
        WorkflowRequestTableField[] mainField = new WorkflowRequestTableField[15]; //主表行对象

        int i = 0;
        mainField[i] = new WorkflowRequestTableField();
        mainField[i].setFieldName("shdh");// 字段名
        mainField[i].setFieldValue("15776701949"); // 字段值
        mainField[i].setView(true); //字段是否可见
        mainField[i].setEdit(true); //字段是否可编辑

        i++;
        mainField[i] = new WorkflowRequestTableField();
        mainField[i].setFieldName("fhdz");
        mainField[i].setFieldValue("发货地址");
        mainField[i].setView(true);
        mainField[i].setEdit(true);

        i++;
        mainField[i] = new WorkflowRequestTableField();
        mainField[i].setFieldName("dh");
        mainField[i].setFieldValue("单号");
        mainField[i].setView(true);
        mainField[i].setEdit(true);

        i++;
        mainField[i] = new WorkflowRequestTableField();
        mainField[i].setFieldName("htzwfj");
        mainField[i].setFieldType("http:一个文档.docx");
        mainField[i].setFieldValue("http://47.94.241.183/041.doc");
        mainField[i].setView(true);
        mainField[i].setEdit(true);

        WorkflowRequestTableRecord[] mainRecord = new WorkflowRequestTableRecord[1];// 主字段只有一行数据
        mainRecord[0] = new WorkflowRequestTableRecord();
        mainRecord[0].setWorkflowRequestTableFields(mainField);

        WorkflowMainTableInfo workflowMainTableInfo = new WorkflowMainTableInfo();
        workflowMainTableInfo.setRequestRecords(mainRecord);

        //==========================================明细字段
        WorkflowDetailTableInfo detailTableInfos[] = new WorkflowDetailTableInfo[1];// 明细表数组

        // ==================================== 明细表1start
        WorkflowRequestTableRecord[] detailRecord = new WorkflowRequestTableRecord[10];//明细表对象

//        JsonObject asJsonObject;
//        for (int j = 0; j < size; j++) {
//            asJsonObject = array.get(j).getAsJsonObject();
//            WorkflowRequestTableField[] detailField1 = new WorkflowRequestTableField[2]; // 行对象，每行2个字段
//            i = 0;
//            detailField1[i] = new WorkflowRequestTableField();
//            detailField1[i].setFieldName("ck");
//            detailField1[i].setFieldValue(asJsonObject.get("ck").getAsString());
//            detailField1[i].setView(true);
//            detailField1[i].setEdit(true);
//
//            i++;
//            detailField1[i] = new WorkflowRequestTableField();
//            detailField1[i].setFieldName("cpmc");
//            detailField1[i].setFieldValue(asJsonObject.get("cpmc").getAsString());
//            detailField1[i].setView(true);
//            detailField1[i].setEdit(true);
//
//            detailRecord[j] = new WorkflowRequestTableRecord();
//            detailRecord[j].setWorkflowRequestTableFields(detailField1);
//        }
        detailTableInfos[0] = new WorkflowDetailTableInfo();
        detailTableInfos[0].setWorkflowRequestTableRecords(detailRecord);

        //====================================流程基本信息录入
        WorkflowBaseInfo workflowBaseInfo = new WorkflowBaseInfo();
        workflowBaseInfo.setWorkflowId(workFlowId);// 流程id

        WorkflowRequestInfo workflowRequestInfo = new WorkflowRequestInfo();// 流程基本信息
        workflowRequestInfo.setCreatorId(createrId);// 创建人id
        workflowRequestInfo.setRequestLevel("0");// 0 正常，1重要，2紧急
        workflowRequestInfo.setRequestName("创建流程测试" + com.weaver.general.TimeUtil.getOnlyCurrentTimeString());// 流程标题
        workflowRequestInfo.setWorkflowBaseInfo(workflowBaseInfo);
        workflowRequestInfo.setWorkflowMainTableInfo(workflowMainTableInfo);// 添加主表字段数据
        //workflowRequestInfo.setWorkflowDetailTableInfos(detailTableInfos);// 添加明细表字段数据

        //创建流程的类
        WorkflowServiceImpl workflowService = new WorkflowServiceImpl();
        String s = workflowService.submitWorkflowRequest(workflowRequestInfo, 3170, Integer.parseInt(createrId), "submit", "ok");
        out.clear();
        out.print("提交结果： " + s);

    } catch (Exception e) {
        baseBean.writeLog("对公付款创建流程异常： " + e);
    }


%>

