<%@ page import="com.alibaba.fastjson.JSONObject" %>
<%@ page import="com.sap.conn.jco.JCoDestination" %>
<%@ page import="com.sap.conn.jco.JCoFunction" %>
<%@ page import="com.sap.conn.jco.JCoTable" %>
<%@ page import="com.weavernorth.zhongsha21.util.ZhsPoolThreeTest" %>
<%@ page import="weaver.conn.RecordSet" %>
<%@ page import="weaver.general.BaseBean" %>
<%@ page import="weaver.general.Util" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%
    BaseBean baseBean = new BaseBean();
    baseBean.writeLog("打印数据推送sap Start=======================");
    String id = request.getParameter("id");
    baseBean.writeLog("打印数据推送sap 接收前台参数: " + id);
    RecordSet recordSet = new RecordSet();
    JSONObject returnJsonObj = new JSONObject();
    try {
        recordSet.executeQuery("select * from uf_tdlb where id = ?", id);
        recordSet.next();
        String zxfs = recordSet.getString("zxfs"); // 执行方式
        String dh = recordSet.getString("dh");// 交易编号
        double dyje = recordSet.getDouble("dyje") < 0 ? 0 : recordSet.getDouble("dyje");// 打印金额
        double je = recordSet.getDouble("je") < 0 ? 0 : recordSet.getDouble("je");// 金额
        if (dyje <= 0) {
            returnJsonObj.put("myState", false);
            returnJsonObj.put("message", "打印金额填写为空！");
            out.clear();
            out.print(returnJsonObj.toJSONString());
            return;
        }

        JCoDestination jCoDestination = ZhsPoolThreeTest.getJCoDestination();
        jCoDestination.ping();
        baseBean.writeLog("ping 通=====");
        JCoFunction function = jCoDestination.getRepository().getFunction("ZCM_EHQ00470");
        baseBean.writeLog("function========== " + function);
        JCoTable it_input = function.getTableParameterList().getTable("IT_INPUT");

        // 将【执行进度】改为 已完成
        recordSet.executeUpdate("update uf_tdlb set zxjd = 1 where id = ?", id);
        if ("0".equals(zxfs)) {
            it_input.appendRow();
            it_input.setRow(0);
            it_input.setValue("ZOAID", dh); // 交易编号
            it_input.setValue("ZDYJE", dyje); // 打印金额
            it_input.setValue("BUKRS", "9009"); // 公司代码
        } else {
            returnJsonObj.put("myState", false);
            returnJsonObj.put("message", "已完成，不提交sap");
            out.clear();
            out.print(returnJsonObj.toJSONString());
            return;
        }

        // 调用sap接口
        function.execute(jCoDestination);
        baseBean.writeLog("调用接口结束===========");

        StringBuilder stringBuilder = new StringBuilder();
        JCoTable et_return = function.getTableParameterList().getTable("ET_RETURN");
        int numRows = et_return.getNumRows();
        for (int j = 0; j < numRows; j++) {
            et_return.setRow(j);
            String bukrs = et_return.getString("BUKRS"); // 公司代码
            String ZOAID = et_return.getString("ZOAID"); // OA单号
            String ZMSTP = Util.null2String(et_return.getString("ZMSTP")).trim(); // 消息类型
            String ZMSEG = et_return.getString("ZMSEG"); // 消息文本
            baseBean.writeLog("公司代码: " + bukrs + ", OA单号: " + ZOAID + ", 消息类型: " + ZMSTP + ", 消息文本； " + ZMSEG);

            // 回写建模备注
            updateBz("消息类型: " + ZMSTP + ", 消息文本； " + ZMSEG, id);
            if ("E".equalsIgnoreCase(ZMSTP)) {
                stringBuilder.append("消息类型: ").append(ZMSTP).append(", 消息文本: ").append(ZMSEG).append("；");
            }
        }
        if (stringBuilder.length() > 0) {
            returnJsonObj.put("myState", false);
            returnJsonObj.put("message", stringBuilder.toString());
        } else {
            returnJsonObj.put("myState", true);
            returnJsonObj.put("message", "已完成并提交sap");
        }

    } catch (Exception e) {
        baseBean.writeLog("打印数据推送sap ERR： " + e);
        returnJsonObj.put("myState", false);
        returnJsonObj.put("message", "调用sap接口异常，请查看日志。");
        updateBz("调用sap接口异常，请查看日志。", id);
    }

    baseBean.writeLog("打印数据推送sap ======================= End ");
    out.clear();
    out.print(returnJsonObj.toJSONString());

%>

<%!
    /**
     * sap返回信息更新到建模表备注字段
     */
    private void updateBz(String bz, String id) {
        try {
            RecordSet recordSet = new RecordSet();
            recordSet.executeUpdate("update uf_tdlb set bz = ? where id = ?", bz, id);
        } catch (Exception e) {
            new BaseBean().writeLog("sap返回信息更新到建模err: " + e);
        }

    }
%>