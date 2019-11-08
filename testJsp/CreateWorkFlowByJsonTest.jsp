<%@ page import="com.alibaba.fastjson.JSONArray" %>
<%@ page import="com.alibaba.fastjson.JSONObject" %>
<%@ page import="weaver.general.BaseBean" %>
<%@ page import="weaver.general.TimeUtil" %>
<%@ page import="weaver.workflow.webservices.*" %>
<%@ page import="java.io.BufferedReader" %>
<%@ page import="java.io.IOException" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<%
    /**
     * http接收jsp
     */
    BaseBean baseBean = new BaseBean();
    String json = getPostData(request.getReader());
    // 流程id
    String workFlowId = "";
    String creatorId = "";

    baseBean.writeLog("创建流程收到的json===========》 " + json);

    try {
        // 解析json
        JSONObject jsonObject = JSONObject.parseObject(json);


        JSONArray userList = jsonObject.getJSONArray("userList");
        int size = userList.size();
        baseBean.writeLog("接收数组长度： " + size);

        WorkflowRequestTableField[] mainField = new WorkflowRequestTableField[10]; //主表行对象

        int i = 0;
        mainField[i] = new WorkflowRequestTableField();
        mainField[i].setFieldName("sqxm");// 字段名
        mainField[i].setFieldValue(creatorId); // 申请人
        mainField[i].setView(true); //字段是否可见
        mainField[i].setEdit(true); //字段是否可编辑

        i++;
        mainField[i] = new WorkflowRequestTableField();
        mainField[i].setFieldName("sqrbm");
        mainField[i].setFieldValue(""); // 申请人部门
        mainField[i].setView(true);
        mainField[i].setEdit(true);

        i++;
        mainField[i] = new WorkflowRequestTableField();
        mainField[i].setFieldName("sqrq");
        mainField[i].setFieldValue(""); // 申请日期
        mainField[i].setView(true);
        mainField[i].setEdit(true);

        i++;
        mainField[i] = new WorkflowRequestTableField();
        mainField[i].setFieldName("sqgh");
        mainField[i].setFieldValue(""); // 申请工号
        mainField[i].setView(true);
        mainField[i].setEdit(true);

        WorkflowRequestTableRecord[] mainRecord = new WorkflowRequestTableRecord[1];// 主字段只有一行数据
        mainRecord[0] = new WorkflowRequestTableRecord();
        mainRecord[0].setWorkflowRequestTableFields(mainField);

        WorkflowMainTableInfo workflowMainTableInfo = new WorkflowMainTableInfo();
        workflowMainTableInfo.setRequestRecords(mainRecord);

        //==========================================明细字段
        WorkflowDetailTableInfo[] detailTableInfos = new WorkflowDetailTableInfo[1];// 明细表数组

        WorkflowRequestTableRecord[] detailRecord = new WorkflowRequestTableRecord[size];//明细表行数组
        // ==================================== 明细表1start
        for (int j = 0; j < size; j++) {
            WorkflowRequestTableField[] detailField1 = new WorkflowRequestTableField[12]; // 明细表列数组，每行12个字段
            i = 0;
            detailField1[i] = new WorkflowRequestTableField();
            detailField1[i].setFieldName("BANFN");
            detailField1[i].setFieldValue(""); // 采购申请号
            detailField1[i].setView(true);
            detailField1[i].setEdit(true);

            i++;
            detailField1[i] = new WorkflowRequestTableField();
            detailField1[i].setFieldName("BNFPO");
            detailField1[i].setFieldValue(""); // 行项目
            detailField1[i].setView(true);
            detailField1[i].setEdit(true);

            i++;
            detailField1[i] = new WorkflowRequestTableField();
            detailField1[i].setFieldName("KNTTP");
            detailField1[i].setFieldValue(""); // 科目分配类别
            detailField1[i].setView(true);
            detailField1[i].setEdit(true);

            i++;
            detailField1[i] = new WorkflowRequestTableField();
            detailField1[i].setFieldName("MATNR");
            detailField1[i].setFieldValue(""); // 物料编码
            detailField1[i].setView(true);
            detailField1[i].setEdit(true);


            detailRecord[j] = new WorkflowRequestTableRecord();
            detailRecord[j].setWorkflowRequestTableFields(detailField1);
        }
        detailTableInfos[0] = new WorkflowDetailTableInfo();
        detailTableInfos[0].setWorkflowRequestTableRecords(detailRecord);

        //====================================流程基本信息录入
        WorkflowBaseInfo workflowBaseInfo = new WorkflowBaseInfo();
        workflowBaseInfo.setWorkflowId(workFlowId);// 流程id

        WorkflowRequestInfo workflowRequestInfo = new WorkflowRequestInfo();// 流程基本信息
        workflowRequestInfo.setCreatorId(creatorId);// 创建人id
        workflowRequestInfo.setRequestLevel("0");// 0 正常，1重要，2紧急
        workflowRequestInfo.setRequestName("08-SAP采购申请单-" + TimeUtil.getCurrentTimeString());// 流程标题
        workflowRequestInfo.setWorkflowBaseInfo(workflowBaseInfo);
        workflowRequestInfo.setWorkflowMainTableInfo(workflowMainTableInfo);// 添加主表字段数据
        workflowRequestInfo.setWorkflowDetailTableInfos(detailTableInfos);// 添加明细表字段数据
        workflowRequestInfo.setIsnextflow("0");

        WorkflowServiceImpl service = new WorkflowServiceImpl();
        String requestId = service.doCreateWorkflowRequest(workflowRequestInfo, Integer.parseInt(creatorId));
        baseBean.writeLog("创建流程返回：" + requestId);
    } catch (Exception e) {
        baseBean.writeLog("创建流程异常： " + e);
    }

    out.clear();
    out.print("创建成功");

%>

<%!
    public String getPostData(BufferedReader reader) throws IOException {
        StringBuilder stringBuilder = new StringBuilder();
        String str;
        while ((str = reader.readLine()) != null) {
            stringBuilder.append(str);
        }
        return new String(stringBuilder);
    }
%>





