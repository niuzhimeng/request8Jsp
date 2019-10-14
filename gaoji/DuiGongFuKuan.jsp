<%@ page import="com.google.gson.JsonArray" %>
<%@ page import="com.google.gson.JsonObject" %>
<%@ page import="com.google.gson.JsonParser" %>
<%@ page import="weaver.conn.RecordSet" %>
<%@ page import="weaver.general.BaseBean" %>
<%@ page import="weaver.general.TimeUtil" %>
<%@ page import="weaver.soa.workflow.request.RequestInfo" %>
<%@ page import="weaver.soa.workflow.request.RequestService" %>
<%@ page import="weaver.workflow.webservices.*" %>
<%@ page import="java.io.BufferedReader" %>
<%@ page import="java.io.IOException" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.lang.reflect.Method" %>
<%@ page import="com.alibaba.druid.util.Base64" %>
<%@ page import="com.weavernorth.gaoji.sap.action.util.ActionUtil" %>
<%@ page import="com.weavernorth.gaoji.sap.action.vo.POTableList" %>
<%@ page import="com.weavernorth.gaoji.sap.action.vo.POTableVo" %>
<%@ page import="com.weavernorth.gaoji.sap.action.vo.SapCallBackDataVo" %>
<%@ page import="com.google.gson.Gson" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.List" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<jsp:useBean id="RequestManager" class="weaver.workflow.request.RequestManager" scope="page"/>
<jsp:useBean id="flowDocss" class="weaver.workflow.request.RequestDoc" scope="session"/>
<jsp:useBean id="DocComInfo" class="weaver.docs.docs.DocComInfo" scope="page"/>
<jsp:useBean id="Doccoder" class="weaver.docs.docs.DocCoder" scope="page"/>

<%
    /**
     * 对公付款创建流程
     */

    BaseBean baseBean = new BaseBean();
    String json = getPostData(request.getReader());
    baseBean.writeLog("对公付款接收到的json===========》 " + json);
    String returnStr = "";
    String STATUS = "S";
    String ZFKDH = "";
    try {
        String poauth = request.getHeader("Authorization");
        baseBean.writeLog("Authorization --- " + poauth);
        String userPwd = baseBean.getPropValue("poMutualConn","oaAuthPwd");
        String byteArrayToBase64 = Base64.byteArrayToBase64(userPwd.getBytes());
        String oaauth = "Basic " + byteArrayToBase64;
        baseBean.writeLog("oaauth --- " + oaauth);
        //外部访问凭证校验，校验通过执行操作
        if (poauth != null && oaauth.equals(poauth.trim())) {
            SimpleDateFormat dateformat1 = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
            JsonObject jsonObject1 = new JsonParser().parse(json).getAsJsonObject();
            JsonObject jsonObject = jsonObject1.get("Table").isJsonNull() ? new JsonObject() : jsonObject1.get("Table").getAsJsonObject();

            String bguid = jsonObject.get("bguid").isJsonNull() ? "" : jsonObject.get("bguid").getAsString();
            String type = jsonObject.get("btype").isJsonNull() ? "" : jsonObject.get("btype").getAsString();
            int btype = Integer.parseInt(type);
            String source = jsonObject.get("bsource").isJsonNull() ? "" : jsonObject.get("bsource").getAsString();
            int bsource = Integer.parseInt(source);
            String destination = jsonObject.get("bdestination").isJsonNull() ? "" : jsonObject.get("bdestination").getAsString();
            int bdestination = Integer.parseInt(destination);
            String bdatetime = jsonObject.get("bdatetime").isJsonNull() ? "" : jsonObject.get("bdatetime").getAsString();
            String status = jsonObject.get("bstatus").isJsonNull() ? "" : jsonObject.get("bstatus").getAsString();
            int bstatus = Integer.parseInt(status);
            String bcallback = "";
            String bversion = jsonObject.get("bversion").isJsonNull() ? "" : jsonObject.get("bversion").getAsString();
            String bdatahash = jsonObject.get("bdatahash").isJsonNull() ? "" : jsonObject.get("bdatahash").getAsString();
            String bkeys = jsonObject.get("bkeys").isJsonNull() ? "" : jsonObject.get("bkeys").getAsString();
            String bdataJson = jsonObject.get("bdata").isJsonNull() ? "" : jsonObject.get("bdata").getAsString();
            String insertBkeys = "";
            if(bkeys.length() < 95){
                insertBkeys = bkeys;
            } else {
                insertBkeys = bkeys.substring(0,95);
            }
            String insertBdata = "";
            if(bdataJson.length() < 3500){
                insertBdata = bdataJson;
            } else {
                insertBdata = bdataJson.substring(0,3500);
            }

            //更新流程日志表
            StringBuilder insertSql = new StringBuilder("");
            insertSql.append("insert into uf_sapData(bguid, btype, bsource, bdestination, bdatetime, bstatus, bcallback, bversion, bdatahash, bkeys, bdata, createtime, modifytime) values (");
            insertSql.append("'"+bguid+"',"+btype+","+bsource+","+bdestination+",'"+bdatetime+"',"+bstatus+",'"+bcallback+"','"+bversion+"','"+bdatahash+"','"+insertBkeys+"','"+insertBdata+"','"+dateformat1.format(new Date())+"','"+dateformat1.format(new Date())+"'");
            insertSql.append(")");
            baseBean.writeLog("sap回调SQL： " + insertSql.toString());
            RecordSet recordSet = new RecordSet();
            recordSet.execute(insertSql.toString());


            JsonObject bdata = new JsonParser().parse(bdataJson).getAsJsonObject();
            ZFKDH = bdata.get("ZFKDH").isJsonNull() ? "" : bdata.get("ZFKDH").getAsString();//付款单号
            String BUKRS = bdata.get("BUKRS").isJsonNull() ? "" : bdata.get("BUKRS").getAsString();//公司代码（费用承担主体）
            String ACCNT = "";//申请人
            if(bdata.has("ACCNT")){
                ACCNT = bdata.get("ACCNT").isJsonNull() ? "" : bdata.get("ACCNT").getAsString();
            }
            if(ACCNT != null && !"".equals(ACCNT.trim())){
                String ZYWHT = bdata.get("ZYWHT").isJsonNull() ? "" : bdata.get("ZYWHT").getAsString();//有无合同 1有/0无
                if("1".equals(ZYWHT)){
                    ZYWHT = "0";//OA中 0有合同（非框架） 1无合同 2有合同（框架）
                } else {
                    ZYWHT = "1";//OA中 0有合同（非框架） 1无合同 2有合同（框架）
                }
                String ZHTZJE = bdata.get("ZHTZJE").isJsonNull() ? "" : bdata.get("ZHTZJE").getAsString();//合同总金额
                String ZBLART = bdata.get("ZBLART").isJsonNull() ? "" : bdata.get("ZBLART").getAsString();//单据类型（款项类型）
                String ZFYLX = bdata.get("ZFYLX").isJsonNull() ? "" : bdata.get("ZFYLX").getAsString();//费用类型
                String NAME1 = bdata.get("NAME1").isJsonNull() ? "" : bdata.get("NAME1").getAsString();//供应商描述（收款人/公司名称）
                String ZSFKFP = bdata.get("ZSFKFP").isJsonNull() ? "" : bdata.get("ZSFKFP").getAsString();//是否已开发票 1有/0无
                if("1".equals(ZSFKFP)){
                    ZSFKFP = "0";//OA中 0已开票 1未开票
                } else {
                    ZSFKFP = "1";//OA中 0已开票 1未开票
                }
                String BANKL = bdata.get("BANKL").isJsonNull() ? "" : bdata.get("BANKL").getAsString();//银行代码（收款人/公司开户行）
                String REFZL = bdata.get("REFZL").isJsonNull() ? "" : bdata.get("REFZL").getAsString();//收款账号（收款人/公司账户）
                String ZFKFS = bdata.get("ZFKFS").isJsonNull() ? "" : bdata.get("ZFKFS").getAsString();//付款方式
                if("01".equals(ZFKFS)){
                    ZFKFS = "0";//OA中 0网银转账
                }
                String ZFPZE = "";
                if(bdata.has("ZFPZE")){
                    ZFPZE = bdata.get("ZFPZE").isJsonNull() ? "" : bdata.get("ZFPZE").getAsString();//发票总金额
                }
                String ZFKZJE = bdata.get("ZFKZJE").isJsonNull() ? "" : bdata.get("ZFKZJE").getAsString();//付款总金额

                recordSet.execute("select * from hrmresource where workcode = '" + ACCNT + "'");
                //流程创建人id
                String createrId = "";
                //部门id
                String departmentId = "";
                if (recordSet.next()) {
                    createrId = String.valueOf(recordSet.getInt("id"));
                    departmentId = String.valueOf(recordSet.getInt("departmentid"));
                }
                recordSet.execute("select * from uf_dgfklcbh where fycdztbm = '" + BUKRS + "'");
                //流程id
                String workFlowId = "";
                if (recordSet.next()) {
                    workFlowId = recordSet.getString("workflowid");
                }

                WorkflowRequestTableField[] mainField = new WorkflowRequestTableField[15]; //主表行对象

                int i = 0;
                mainField[i] = new WorkflowRequestTableField();
                mainField[i].setFieldName("djbh");// 字段名
                mainField[i].setFieldValue(ZFKDH); // 字段值
                mainField[i].setView(true); //字段是否可见
                mainField[i].setEdit(true); //字段是否可编辑

                i++;
                mainField[i] = new WorkflowRequestTableField();
                mainField[i].setFieldName("sapfycdzt");
                mainField[i].setFieldValue(BUKRS);
                mainField[i].setView(true);
                mainField[i].setEdit(true);

                i++;
                mainField[i] = new WorkflowRequestTableField();
                mainField[i].setFieldName("ssbm");
                mainField[i].setFieldValue(departmentId);
                mainField[i].setView(true);
                mainField[i].setEdit(true);

                i++;
                mainField[i] = new WorkflowRequestTableField();
                mainField[i].setFieldName("sqr");
                mainField[i].setFieldValue(createrId);
                mainField[i].setView(true);
                mainField[i].setEdit(true);

                i++;
                mainField[i] = new WorkflowRequestTableField();
                mainField[i].setFieldName("ywht");
                mainField[i].setFieldValue(ZYWHT);
                mainField[i].setView(true);
                mainField[i].setEdit(true);

                i++;
                mainField[i] = new WorkflowRequestTableField();
                mainField[i].setFieldName("htwhtje");
                mainField[i].setFieldValue(ZHTZJE);
                mainField[i].setView(true);
                mainField[i].setEdit(true);

                i++;
                mainField[i] = new WorkflowRequestTableField();
                mainField[i].setFieldName("kxlx");// 字段名
                mainField[i].setFieldValue(ZBLART); // 字段值
                mainField[i].setView(true); //字段是否可见
                mainField[i].setEdit(true); //字段是否可编辑

                i++;
                mainField[i] = new WorkflowRequestTableField();
                mainField[i].setFieldName("xfylx");
                mainField[i].setFieldValue(ZFYLX);
                mainField[i].setView(true);
                mainField[i].setEdit(true);

                i++;
                mainField[i] = new WorkflowRequestTableField();
                mainField[i].setFieldName("skrgsmc");// 字段名
                mainField[i].setFieldValue(NAME1); // 字段值
                mainField[i].setView(true); //字段是否可见
                mainField[i].setEdit(true); //字段是否可编辑

                i++;
                mainField[i] = new WorkflowRequestTableField();
                mainField[i].setFieldName("sfkfp");
                mainField[i].setFieldValue(ZSFKFP);
                mainField[i].setView(true);
                mainField[i].setEdit(true);

                i++;
                mainField[i] = new WorkflowRequestTableField();
                mainField[i].setFieldName("skrgskhh");
                mainField[i].setFieldValue(BANKL);
                mainField[i].setView(true);
                mainField[i].setEdit(true);

                i++;
                mainField[i] = new WorkflowRequestTableField();
                mainField[i].setFieldName("skrgszh");
                mainField[i].setFieldValue(REFZL);
                mainField[i].setView(true);
                mainField[i].setEdit(true);

                i++;
                mainField[i] = new WorkflowRequestTableField();
                mainField[i].setFieldName("fkfs");
                mainField[i].setFieldValue(ZFKFS);
                mainField[i].setView(true);
                mainField[i].setEdit(true);

                i++;
                mainField[i] = new WorkflowRequestTableField();
                mainField[i].setFieldName("fpjehj");
                mainField[i].setFieldValue(ZFPZE);
                mainField[i].setView(true);
                mainField[i].setEdit(true);

                i++;
                mainField[i] = new WorkflowRequestTableField();
                mainField[i].setFieldName("bczfje");
                mainField[i].setFieldValue(ZFKZJE);
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
                workflowRequestInfo.setCreatorId(createrId);// 创建人id
                workflowRequestInfo.setRequestLevel("0");// 0 正常，1重要，2紧急
                workflowRequestInfo.setRequestName("SAP发起对公付款申请" + com.weaver.general.TimeUtil.getOnlyCurrentTimeString());// 流程标题
                workflowRequestInfo.setWorkflowBaseInfo(workflowBaseInfo);
                workflowRequestInfo.setWorkflowMainTableInfo(workflowMainTableInfo);// 添加主表字段数据
                workflowRequestInfo.setWorkflowDetailTableInfos(new WorkflowDetailTableInfo[1]);// 添加明细表字段数据

                //创建流程的类
                WorkflowServiceImpl service = new WorkflowServiceImpl();
                //service.doCreateWorkflowRequest()
                baseBean.writeLog("准备创建流程===============");

                Class<? extends WorkflowServiceImpl> aClass = service.getClass();
                Method method1 = aClass.getDeclaredMethod("getActiveWorkflowRequestInfo", WorkflowRequestInfo.class);
                method1.setAccessible(true);
                workflowRequestInfo = (WorkflowRequestInfo) method1.invoke(service, workflowRequestInfo);

                baseBean.writeLog("准备创建流程===============11");

                Method method2 = aClass.getDeclaredMethod("toRequestInfo", WorkflowRequestInfo.class);
                method2.setAccessible(true);
                RequestInfo requestInfo = (RequestInfo) method2.invoke(service, workflowRequestInfo);
                if (requestInfo.getCreatorid() == null || requestInfo.getCreatorid().isEmpty()) {
                    requestInfo.setCreatorid(createrId);
                }

                if (!requestInfo.getCreatorid().equals(createrId)) {
                    requestInfo.setCreatorid(createrId);
                }
                baseBean.writeLog("准备创建流程===============22");
                requestInfo.setIsNextFlow("0");
                RequestService requestService = new RequestService();
                returnStr = requestService.createRequest(requestInfo);
                baseBean.writeLog("创建流程完毕=============== " + returnStr);
            }
        } else {
            STATUS = "E";
            returnStr = "员工编码为空，对公付款创建流程异常";
            baseBean.writeLog("员工编码为空，对公付款创建流程异常！");
        }
    } catch (Exception e) {
        STATUS = "E";
        returnStr = "对公付款创建流程异常";
        baseBean.writeLog("对公付款创建流程异常： " + e);
    } finally {
        try {
            Gson gson = new Gson();
            List<POTableVo> list = new ArrayList<POTableVo>();
            POTableVo pOTableVo = new POTableVo("DGFK");
            SapCallBackDataVo sapCallBackDataVo = new SapCallBackDataVo();
            sapCallBackDataVo.setZYFKDH(ZFKDH);
            sapCallBackDataVo.setSTATUS(STATUS);//状态 S:成功 E:失败
            sapCallBackDataVo.setMESSAGE_TEXT(returnStr);//消息
            String dataJson = gson.toJson(sapCallBackDataVo);
            String md5Str = ActionUtil.md5(dataJson);
            pOTableVo.setBdatahash(md5Str);//设置校验字段
            pOTableVo.setBdata(dataJson);

            POTableList pOTableList = new POTableList();
            list.add(pOTableVo);
            pOTableList.setTable(list);
            //发送
            String sendJson = gson.toJson(pOTableList);

            //本地存储
            ActionUtil.saveDataJson(list);
            String code = ActionUtil.sendPo(sendJson);
            baseBean.writeLog("对公付款创建流程结果返回SAP： " + sendJson + " CODE:" + code);
        } catch (Exception e) {
            baseBean.writeLog(e);
        }
    }

    out.clear();
    out.print(returnStr);

%>

<%!
    private static String getPostData(BufferedReader reader) throws IOException {
        StringBuilder stringBuilder = new StringBuilder();
        String str;
        while ((str = reader.readLine()) != null) {
            stringBuilder.append(str);
        }
        return new String(stringBuilder);
    }
%>





