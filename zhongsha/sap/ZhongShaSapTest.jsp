<%@ page import="com.sap.conn.jco.*" %>
<%@ page import="com.sap.conn.jco.ext.DestinationDataProvider" %>
<%@ page import="weaver.conn.RecordSet" %>
<%@ page import="weaver.general.BaseBean" %>
<%@ page import="weaver.general.TimeUtil" %>
<%@ page import="java.io.File" %>
<%@ page import="java.io.FileOutputStream" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Properties" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%
    BaseBean baseBean = new BaseBean();
    RecordSet recordSet = new RecordSet();
    baseBean.writeLog("ZhongShaSapTest.jsp 执行=========== " + TimeUtil.getCurrentTimeString());
    try {
        String currentDateString = TimeUtil.getCurrentDateString();
        String dateAdd = TimeUtil.dateAdd(currentDateString, -1);

        JCoDestination jCoDestination = getJCoDestination();
        jCoDestination.ping();
        baseBean.writeLog("ping 通=====");
        JCoFunction function = jCoDestination.getRepository().getFunction("ZFM_CRM_OA_INF_PMORD_RE");

        // 获取输入表
        JCoTable insertTable = function.getTableParameterList().getTable("IT_PMORD_R");

        recordSet.executeQuery("select * from uf_gdtzmxb where rq = '" + dateAdd + "'");
        int counts = recordSet.getCounts();
        baseBean.writeLog("工单台账推送数据数量： " + counts + ", 数据日期： " + dateAdd);
//        int fieldCount = insertTable.getFieldCount();
//        for (int i = 0; i < fieldCount; i++) {
//            baseBean.writeLog(insertTable.getMetaData().getName(i) + ", " + insertTable.getMetaData().getDescription(i));
//        }
        int i = 0;
        while (recordSet.next()) {
            insertTable.appendRow();
            insertTable.setRow(i);
            insertTable.setValue("AUFNR", recordSet.getString("gdh")); // 工单号
            insertTable.setValue("VORNR", recordSet.getString("gxh")); // 工序
            insertTable.setValue("ISDD", recordSet.getString("sjksrq")); // 工作开始
            insertTable.setValue("IEDD", recordSet.getString("sjjsrq")); // 工作结束
            insertTable.setValue("ISMNW", recordSet.getString("rgs")); // 人工时

            insertTable.setValue("IDAUR", recordSet.getString("zgs")); // 总小时
            insertTable.setValue("LIFNR", recordSet.getString("sgdw")); // 施工单位

            i++;
        }

        // 调用sap接口
        function.execute(jCoDestination);
        baseBean.writeLog("调用接口结束===========");
        JCoParameterList list = function.getTableParameterList();
        JCoTable returnTable = list.getTable("IT_OUTPUT_MSG");

        int numRows = returnTable.getNumRows();
        baseBean.writeLog("headList返回表行数： " + numRows);
        for (int j = 0; j < numRows; j++) {
            returnTable.setRow(j);
            baseBean.writeLog("订单号：" + returnTable.getString("AUFNR"));
            baseBean.writeLog("活动编号：" + returnTable.getString("VORNR"));
            baseBean.writeLog("回写订单状态：" + returnTable.getString("ZSTATE"));
            baseBean.writeLog("消息文本：" + returnTable.getString("ZMSG"));
            baseBean.writeLog("回写供应商状态：" + returnTable.getString("ZSTATE_V"));
            baseBean.writeLog("消息文本：" + returnTable.getString("ZMSG_V"));
        }

    } catch (Exception e) {
        baseBean.writeLog("ZhongShaSapTest.jsp error: " + e);
    }

    baseBean.writeLog("ZhongShaSapTest.jsp 结束=========== " + TimeUtil.getCurrentTimeString());

%>

<%!
    private static JCoDestination getJCoDestination() throws JCoException {
        String CONN_NAME = "ZHONG_SHA_POOL_OARFC";
        Properties properties = new Properties();
        // IP
        properties.setProperty(DestinationDataProvider.JCO_ASHOST, "10.102.176.184");
        // 系统编号
        properties.setProperty(DestinationDataProvider.JCO_SYSNR, "00");
        // 客户端编号
        properties.setProperty(DestinationDataProvider.JCO_CLIENT, "400");
        // 用户名
        properties.setProperty(DestinationDataProvider.JCO_USER, "RFCOA02");
        // 密码
        properties.setProperty(DestinationDataProvider.JCO_PASSWD, "init12345");
        // 语言
        properties.setProperty(DestinationDataProvider.JCO_LANG, "zh");

        // JCO_PEAK_LIMIT - 同时可创建的最大活动连接数，0表示无限制，默认为JCO_POOL_CAPACITY的值
        // 如果小于JCO_POOL_CAPACITY的值，则自动设置为该值，在没有设置JCO_POOL_CAPACITY的情况下为0
        // 最大活动连接数
        properties.setProperty(DestinationDataProvider.JCO_PEAK_LIMIT, "10");
        // 最大空闲连接数
        properties.setProperty(DestinationDataProvider.JCO_POOL_CAPACITY, "5");
        createDestinationDataFile(properties);

        return JCoDestinationManager.getDestination(CONN_NAME);
    }

    /**
     * 创建连信息接配置文件
     */
    private static void createDestinationDataFile(Properties properties) {
        String CONN_NAME = "ZHONG_SHA_POOL_OARFC";
        File destCfg = new File(CONN_NAME + ".jcoDestination");
        try {
            if (!destCfg.exists()) {
                FileOutputStream fos = new FileOutputStream(destCfg, false);
                properties.store(fos, "MyTestJco3");
                fos.close();
            }
        } catch (Exception e) {
            throw new RuntimeException("Unable to create the destination files", e);
        }
    }
%>

















