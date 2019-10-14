<%@ page import="com.google.gson.JsonArray" %>
<%@ page import="com.google.gson.JsonObject" %>
<%@ page import="com.google.gson.JsonParser" %>
<%@ page import="weaver.general.BaseBean" %>
<%@ page import="weaver.soa.workflow.request.RequestInfo" %>
<%@ page import="weaver.soa.workflow.request.RequestService" %>
<%@ page import="weaver.workflow.webservices.*" %>
<%@ page import="java.io.BufferedReader" %>
<%@ page import="java.io.IOException" %>
<%@ page import="java.lang.reflect.Method" %>
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
    String createrId = "150";

    BaseBean baseBean = new BaseBean();
    //String json = getPostData(request.getReader());
    String json = "{\n" +
            "\t\"Table\": {\n" +
            "\t\t\"bguid\": \"SAPERP120FA163EBE905A1EE8B2D9BA33320A96A4\",\n" +
            "\t\t\"btype\": 9057,\n" +
            "\t\t\"bsource\": 101,\n" +
            "\t\t\"bdestination\": 901,\n" +
            "\t\t\"bdatetime\": \"2018-10-08 15:42:20\",\n" +
            "\t\t\"bstatus\": 1,\n" +
            "\t\t\"bversion\": \"V1.0\",\n" +
            "\t\t\"bdatahash\": \"655AEAA32B8A28BE3DA24FA6B70BE66A\",\n" +
            "\t\t\"bkeys\": \"{\\\"ZFKDH\\\":\\\"9000000159\\\"}\",\n" +
            "\t\t\"bdata\": \"{\\\"ZFKDH\\\":\\\"9000000159\\\",\\\"ZFKZJE\\\":20689.65,\\\"KOSTL\\\":\\\"30000400\\\",\\\"ZFKFS\\\":\\\"01\\\",\\\"LIFNR\\\":\\\"0000500005\\\",\\\"NAME1\\\":\\\"浙江佐力药业股份有限公司\\\",\\\"BANKL\\\":\\\"123DDD\\\",\\\"REFZL\\\":\\\"123123123\\\",\\\"ZFYLX\\\":\\\"66021301\\\",\\\"BUKRS\\\":\\\"3000\\\",\\\"ZBLART\\\":\\\"02\\\",\\\"ZYWHT\\\":\\\"有\\\",\\\"ZHTZJE\\\":20689.65,\\\"ZSFKFP\\\":\\\"有\\\",\\\"ZFPZE\\\":20689.65}\"\n" +
            "\t}\n" +
            "}";
    JsonObject jsonObject = new JsonParser().parse(json).getAsJsonObject();
    JsonObject table = jsonObject.get("Table").getAsJsonObject();
    String bdataJson = table.get("bdata").getAsString();

    JsonObject bdata = new JsonParser().parse(bdataJson).getAsJsonObject();

    String xsddbh = "123";
    String ghdw = "123";
    String shdh = "123";
    String fhdz = "123";
    String ysfs = "123";

    JsonArray array = bdata.get("DETAILVOLIST").getAsJsonArray();
    int size = array.size();//明细表行数
     baseBean.writeLog("明细表行数============= " + size);
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

//        i++;
//        mainField[i] = new WorkflowRequestTableField();
//        mainField[i].setFieldName("fj");
//        mainField[i].setFieldType("http:一个文档.docx|http:一个文本.txt");
//        mainField[i].setFieldValue("http://192.168.1.214:8001/testDoc/123.docx|http://192.168.1.214:8001/testDoc/1234.txt");
//        mainField[i].setView(true);
//        mainField[i].setEdit(true);

        WorkflowRequestTableRecord[] mainRecord = new WorkflowRequestTableRecord[1];// 主字段只有一行数据
        mainRecord[0] = new WorkflowRequestTableRecord();
        mainRecord[0].setWorkflowRequestTableFields(mainField);

        WorkflowMainTableInfo workflowMainTableInfo = new WorkflowMainTableInfo();
        workflowMainTableInfo.setRequestRecords(mainRecord);

        //==========================================明细字段
        WorkflowDetailTableInfo detailTableInfos[] = new WorkflowDetailTableInfo[1];// 明细表数组

        // ==================================== 明细表1start
        WorkflowRequestTableRecord[] detailRecord = new WorkflowRequestTableRecord[10];//明细表对象

        JsonObject asJsonObject;
         for (int j = 0; j < size; j++) {
            asJsonObject = array.get(j).getAsJsonObject();
            WorkflowRequestTableField[] detailField1 = new WorkflowRequestTableField[2]; // 行对象，每行2个字段
            i = 0;
            detailField1[i] = new WorkflowRequestTableField();
            detailField1[i].setFieldName("ck");
            detailField1[i].setFieldValue(asJsonObject.get("ck").getAsString());
            detailField1[i].setView(true);
            detailField1[i].setEdit(true);

            i++;
            detailField1[i] = new WorkflowRequestTableField();
            detailField1[i].setFieldName("cpmc");
            detailField1[i].setFieldValue(asJsonObject.get("cpmc").getAsString());
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
        workflowRequestInfo.setCreatorId(createrId);// 创建人id
        workflowRequestInfo.setRequestLevel("0");// 0 正常，1重要，2紧急
        workflowRequestInfo.setRequestName("创建流程测试" + com.weaver.general.TimeUtil.getOnlyCurrentTimeString());// 流程标题
        workflowRequestInfo.setWorkflowBaseInfo(workflowBaseInfo);
        workflowRequestInfo.setWorkflowMainTableInfo(workflowMainTableInfo);// 添加主表字段数据
        workflowRequestInfo.setWorkflowDetailTableInfos(detailTableInfos);// 添加明细表字段数据
        workflowRequestInfo.setIsnextflow("1");

        //创建流程的类
        WorkflowServiceImpl service = new WorkflowServiceImpl();
        String requestid = service.doCreateWorkflowRequest(workflowRequestInfo, 150);
//        baseBean.writeLog("准备创建流程===============");
//
//        Class<? extends WorkflowServiceImpl> aClass = service.getClass();
//        Method method1 = aClass.getDeclaredMethod("getActiveWorkflowRequestInfo", WorkflowRequestInfo.class);
//        method1.setAccessible(true);
//        workflowRequestInfo = (WorkflowRequestInfo) method1.invoke(service, workflowRequestInfo);
//
//        baseBean.writeLog("准备创建流程===============11");
//
//        Method method2 = aClass.getDeclaredMethod("toRequestInfo", WorkflowRequestInfo.class);
//        method2.setAccessible(true);
//        RequestInfo requestInfo = (RequestInfo) method2.invoke(service, workflowRequestInfo);
//        if (requestInfo.getCreatorid() == null || requestInfo.getCreatorid().isEmpty()) {
//            requestInfo.setCreatorid(createrId);
//        }
//
//        if (!requestInfo.getCreatorid().equals(createrId)) {
//            requestInfo.setCreatorid(createrId);
//        }
//        baseBean.writeLog("准备创建流程===============22");
//        requestInfo.setIsNextFlow("1");
//        RequestService requestService = new RequestService();
//        returnStr = requestService.createRequest(requestInfo);
        baseBean.writeLog("创建流程完毕===============");
    } catch (Exception e) {
        baseBean.writeLog("对公付款创建流程异常： " + e);
    }

    out.clear();
    out.print(returnStr);

%>

<%!
    private String getPostData(BufferedReader reader) throws IOException {
        StringBuilder stringBuilder = new StringBuilder();
        String str;
        while ((str = reader.readLine()) != null) {
            stringBuilder.append(str);
        }
        return new String(stringBuilder);
    }
%>





