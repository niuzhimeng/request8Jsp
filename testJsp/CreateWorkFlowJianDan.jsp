<%@ page import="weaver.general.BaseBean" %>
<%@ page import="weaver.workflow.webservices.*" %>
<%@ page import="java.lang.reflect.Method" %>
<%@ page import="weaver.soa.workflow.request.RequestInfo" %>
<%@ page import="weaver.soa.workflow.request.RequestService" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<jsp:useBean id="RequestManager" class="weaver.workflow.request.RequestManager" scope="page"/>
<jsp:useBean id="flowDocss" class="weaver.workflow.request.RequestDoc" scope="session"/>
<jsp:useBean id="DocComInfo" class="weaver.docs.docs.DocComInfo" scope="page"/>
<jsp:useBean id="Doccoder" class="weaver.docs.docs.DocCoder" scope="page"/>


<%
    /**
     * 对公付款创建流程
     */
    //流程id
    String workFlowId = "77";
    //流程创建人id
    String creatorId = "150";

    BaseBean baseBean = new BaseBean();
    baseBean.writeLog("创建开始------------------123");

    String xsddbh = "123";
    String ghdw = "123";
    String shdh = "123";
    String fhdz = "123";
    String ysfs = "123";

    String returnStr = "";
    try {
        WorkflowRequestTableField[] mainField = new WorkflowRequestTableField[15]; //主表行对象

        int i = 0;
        mainField[i] = new WorkflowRequestTableField();
        mainField[i].setFieldName("xsddbh");// 字段名
        mainField[i].setFieldValue(xsddbh); // 字段值
        mainField[i].setView(true); //字段是否可见
        mainField[i].setEdit(true); //字段是否可编辑

        i++;
        mainField[i] = new WorkflowRequestTableField();
        mainField[i].setFieldName("ghdw");
        mainField[i].setFieldValue(ghdw);
        mainField[i].setView(true);
        mainField[i].setEdit(true);

        i++;
        mainField[i] = new WorkflowRequestTableField();
        mainField[i].setFieldName("shdh");
        mainField[i].setFieldValue(shdh);
        mainField[i].setView(true);
        mainField[i].setEdit(true);

        i++;
        mainField[i] = new WorkflowRequestTableField();
        mainField[i].setFieldName("fhdz");
        mainField[i].setFieldValue(fhdz);
        mainField[i].setView(true);
        mainField[i].setEdit(true);

        i++;
        mainField[i] = new WorkflowRequestTableField();
        mainField[i].setFieldName("ysfs");
        mainField[i].setFieldValue(ysfs);
        mainField[i].setView(true);
        mainField[i].setEdit(true);

        WorkflowRequestTableRecord[] mainRecord = new WorkflowRequestTableRecord[1];// 主字段只有一行数据
        mainRecord[0] = new WorkflowRequestTableRecord();
        mainRecord[0].setWorkflowRequestTableFields(mainField);

        WorkflowMainTableInfo workflowMainTableInfo = new WorkflowMainTableInfo();
        workflowMainTableInfo.setRequestRecords(mainRecord);

        //====================================流程基本信息录入
        WorkflowBaseInfo workflowBaseInfo = new WorkflowBaseInfo();
        workflowBaseInfo.setWorkflowId(workFlowId);// 流程id

        WorkflowRequestInfo workflowRequestInfo = new WorkflowRequestInfo();// 流程基本信息
        workflowRequestInfo.setCreatorId(creatorId);// 创建人id
        workflowRequestInfo.setRequestLevel("0");// 0 正常，1重要，2紧急
        workflowRequestInfo.setRequestName("创建流程测试" + com.weaver.general.TimeUtil.getOnlyCurrentTimeString());// 流程标题
        workflowRequestInfo.setWorkflowBaseInfo(workflowBaseInfo);
        workflowRequestInfo.setWorkflowMainTableInfo(workflowMainTableInfo);// 添加主表字段数据
        workflowRequestInfo.setIsnextflow("0");

        //创建流程的类
        WorkflowServiceImpl service = new WorkflowServiceImpl();
        String requestId = service.doCreateWorkflowRequest(workflowRequestInfo, Integer.parseInt(creatorId));


        baseBean.writeLog("创建流程完毕===============" + requestId);

    } catch (Exception e) {
        baseBean.writeLog("对公付款创建流程异常： " + e);
    }

    out.clear();
    out.print(returnStr);

%>





