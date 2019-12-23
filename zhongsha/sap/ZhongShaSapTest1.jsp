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
    baseBean.writeLog("ZhongShaSapTest.jsp1 执行=========== " + TimeUtil.getCurrentTimeString());
    try {
        String currentDateString = TimeUtil.getCurrentDateString();
        String dateAdd = TimeUtil.dateAdd(currentDateString, -1);

        JCoDestination jCoDestination = getJCoDestination();
        jCoDestination.ping();
        baseBean.writeLog("ping 通=====");
        JCoFunction function = jCoDestination.getRepository().getFunction("ZFM_CRM_OA_INF_ZMRHQ_UP");

        baseBean.writeLog("function: " + function);

        function.getImportParameterList().setValue("IV_LIFNR", "1");
        function.getImportParameterList().setValue("IV_EKORG", "2");
        //function.execute(jCoDestination);

        JCoTable itMatkl = function.getTableParameterList().getTable("IT_MATKL");
        baseBean.writeLog("itMatkl=============: "+ itMatkl);

        int fieldCount = itMatkl.getFieldCount();
        for (int i = 0; i < fieldCount; i++) {
            baseBean.writeLog(itMatkl.getMetaData().getName(i) + ", " + itMatkl.getMetaData().getDescription(i));
        }
        baseBean.writeLog("输出表=============");


    } catch (Exception e) {
        baseBean.writeLog("ZhongShaSapTest.jsp1 error: " + e);
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

















