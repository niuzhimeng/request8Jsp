<%@ page import="com.alibaba.fastjson.JSONArray" %>
<%@ page import="com.alibaba.fastjson.JSONObject" %>
<%@ page import="com.sap.conn.jco.JCoDestination" %>
<%@ page import="com.sap.conn.jco.JCoFunction" %>
<%@ page import="com.sap.conn.jco.JCoParameterList" %>
<%@ page import="com.sap.conn.jco.JCoTable" %>
<%@ page import="com.weavernorth.zhongsha.crmsap.ZhsPoolThree" %>
<%@ page import="weaver.general.BaseBean" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%
    // 物资采购预选供应商审批表
    BaseBean baseBean = new BaseBean();
    String cgsqbhVal = request.getParameter("cgsqbhVal");
    baseBean.writeLog("物资采购预选供应商审批表Start===========采购申请编号=" + cgsqbhVal);
    try {
        JCoDestination jCoDestination = ZhsPoolThree.getJCoDestination();
        jCoDestination.ping();
        baseBean.writeLog("ping 通=====");
        JCoFunction function = jCoDestination.getRepository().getFunction("ZFM_CRM_OA_INF_PR_GET");

        JCoParameterList importParameterList = function.getImportParameterList();
        importParameterList.setValue("IV_PRNO", cgsqbhVal);

        // 调用sap接口
        function.execute(jCoDestination);
        baseBean.writeLog("调用接口结束===========");

        JCoParameterList exportParameterList = function.getTableParameterList();
        // 返回调用是否成功
        JCoTable itOutputMsg = exportParameterList.getTable("IT_OUTPUT_MSG");
        int msgNumRows = itOutputMsg.getNumRows();
        String zState = ""; // 返回状态
        String banfn = ""; // 采购申请编号
        String zmsg = ""; // 返回信息
        for (int i = 0; i < msgNumRows; i++) {
            itOutputMsg.setRow(i);
            banfn = itOutputMsg.getString("BANFN");
            zState = itOutputMsg.getString("ZSTATE");
            zmsg = itOutputMsg.getString("ZMSG");
        }
        if (!"S".equalsIgnoreCase(zState)) {
            JSONObject errorObject = new JSONObject();
            errorObject.put("banfn", banfn);
            errorObject.put("zState", "E");
            errorObject.put("zmsg", zmsg);
            baseBean.writeLog("返回错误信息： " + errorObject.toJSONString());
            out.clear();
            out.print(errorObject.toJSONString());
            return;
        }

        // 返回信息
        JSONObject returnObject = new JSONObject();
        JSONArray arrays = new JSONArray();
        JCoTable itOUtPut = exportParameterList.getTable("IT_OUTPUT");
        int numRows = itOUtPut.getNumRows();
        for (int i = 0; i < numRows; i++) {
            itOUtPut.setRow(i);
            JSONObject sonObject = new JSONObject(true);
            sonObject.put("MATNR", itOutputMsg.getString("MATNR")); // 物资编码
            sonObject.put("TXZ01", itOutputMsg.getString("TXZ01")); // 物料长描述
            sonObject.put("MEINS", itOutputMsg.getString("MEINS")); // 单位
            sonObject.put("MENGE", itOutputMsg.getString("MENGE")); // 数量
            sonObject.put("LFDAT", itOutputMsg.getString("LFDAT")); // 交货时间

            arrays.add(sonObject);
        }
        returnObject.put("zState", "S");
        returnObject.put("arrays", arrays);

        baseBean.writeLog("返回正常信息： " + returnObject.toJSONString());
        out.clear();
        out.print(returnObject.toJSONString());
    } catch (Exception e) {
        baseBean.writeLog("询比价流程-物资类Err: " + e);
    }


%>
