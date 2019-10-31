<%@ page import="com.sap.conn.jco.*" %>
<%@ page import="com.sap.conn.jco.ext.DestinationDataProvider" %>
<%@ page import="weaver.general.BaseBean" %>
<%@ page import="weaver.general.TimeUtil" %>
<%@ page import="java.io.File" %>
<%@ page import="java.io.FileOutputStream" %>
<%@ page import="java.util.Properties" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%
    BaseBean baseBean = new BaseBean();
    baseBean.writeLog("CaiBaiBackTest.jsp 执行=========== " + TimeUtil.getCurrentTimeString());
    try {
        JCoDestination jCoDestination = getJCoDestination();
        jCoDestination.ping();

        baseBean.writeLog("ping 通=====");

        // ZMMEX0010_JJJB_IF(测试)  ZOAIF0010
        JCoFunction function = jCoDestination.getRepository().getFunction("ZOAIF0020_RFC");
        baseBean.writeLog("获取函数完成===== " + function);

//        JCoParameterList tableParameterList = function.getTableParameterList();
//
//        JCoTable table = tableParameterList.getTable("IT_TAB");
//        int fieldCount1 = table.getFieldCount();
//        for (int i = 0; i < fieldCount1; i++) {
//            baseBean.writeLog(table.getMetaData().getName(i) + ": " + table.getMetaData().getDescription(i));
//        }

//        for (int i = 0; i < 5; i++) {
//            table.appendRow();
//            table.setRow(i);
//            table.setValue("ZHZDWBM", "nzm" + i);
//        }
//
//        baseBean.writeLog("拼接后表： " + table.toString());
//
        // 调用sap接口
        function.execute(jCoDestination);
        baseBean.writeLog("调用接口结束===========");
//
        JCoParameterList list = function.getTableParameterList();
        baseBean.writeLog("list=======： " + list);

        JCoTable ot_return = list.getTable("IT_TAB");
//
//        int fieldCount = ot_return.getFieldCount();
//        for (int i = 0; i < fieldCount; i++) {
//            baseBean.writeLog(ot_return.getMetaData().getName(i) + ": " + ot_return.getMetaData().getDescription(i));
//        }


        int numRows = ot_return.getNumRows();
        baseBean.writeLog("返回表行数： " + numRows);
        for (int i = 0; i < numRows; i++) {
            ot_return.setRow(i);
            baseBean.writeLog(ot_return.getString("WORKCODE"));
            baseBean.writeLog(ot_return.getString("LASTNAME"));
            baseBean.writeLog("====================");
        }

    } catch (Exception e) {
        baseBean.writeLog("CaiBaiBackTest.jsp error: " + e);
    }

    baseBean.writeLog("CaiBaiBackTest.jsp 结束=========== " + TimeUtil.getCurrentTimeString());

%>

<%!
    private static JCoDestination getJCoDestination() throws JCoException {
        String CONN_NAME = "CAI_BAI_POOL_OARFC";
        Properties properties = new Properties();
        // IP
        properties.setProperty(DestinationDataProvider.JCO_ASHOST, "192.168.30.27");
        // 系统编号
        properties.setProperty(DestinationDataProvider.JCO_SYSNR, "00");
        // 客户端编号
        properties.setProperty(DestinationDataProvider.JCO_CLIENT, "800");
        // 用户名
        properties.setProperty(DestinationDataProvider.JCO_USER, "OA_RFC");
        // 密码
        properties.setProperty(DestinationDataProvider.JCO_PASSWD, "POARFC1020");
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
        String CONN_NAME = "CAI_BAI_POOL_OARFC";
        File destCfg = new File(CONN_NAME + ".jcoDestination");
        try {
            if (!destCfg.exists()) {
                FileOutputStream fos = new FileOutputStream(destCfg, false);
                properties.store(fos, "MY test jco3Formal");
                fos.close();
            }
        } catch (Exception e) {
            throw new RuntimeException("Unable to create the destination files", e);
        }
    }
%>

















