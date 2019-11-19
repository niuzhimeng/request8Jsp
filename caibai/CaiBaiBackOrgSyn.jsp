<%@ page import="com.sap.conn.jco.JCoDestination" %>
<%@ page import="com.sap.conn.jco.JCoFunction" %>
<%@ page import="com.sap.conn.jco.JCoParameterList" %>
<%@ page import="com.sap.conn.jco.JCoTable" %>
<%@ page import="com.weavernorth.caibai.sap.CaiBaiPoolThree" %>
<%@ page import="weaver.general.BaseBean" %>
<%@ page import="weaver.general.TimeUtil" %>
<%@ page import="com.weavernorth.caibai.sap.CaiBaiPoolThreeFormal" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%
    BaseBean baseBean = new BaseBean();
    baseBean.writeLog("CaiBaiBackTest.jsp 执行=========== " + TimeUtil.getCurrentTimeString());
    try {
        JCoDestination jCoDestination = CaiBaiPoolThreeFormal.getJCoDestination();
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
//        // 调用sap接口
        function.execute(jCoDestination);
        baseBean.writeLog("调用接口结束===========");
//
        JCoParameterList list = function.getTableParameterList();
        baseBean.writeLog("list=======： " + list);

        JCoTable ot_return = list.getTable("IT_TAB");

        int fieldCount = ot_return.getFieldCount();
        for (int i = 0; i < fieldCount; i++) {
            baseBean.writeLog(ot_return.getMetaData().getName(i) + ": " + ot_return.getMetaData().getDescription(i));
        }


        int numRows = ot_return.getNumRows();
        baseBean.writeLog("返回表行数： " + numRows);
        for (int i = 0; i < numRows; i++) {
            ot_return.setRow(i);
            baseBean.writeLog("=======================");
            baseBean.writeLog("人员编号: " + ot_return.getString("WORKCODE"));
            baseBean.writeLog("员工姓名: " + ot_return.getString("LASTNAME"));
            baseBean.writeLog("客户特定状态: " + ot_return.getString("STATUS"));
            baseBean.writeLog("性别代码: " + ot_return.getString("SEX"));
            baseBean.writeLog("工作地点: " + ot_return.getString("LOCATION"));

            baseBean.writeLog("电子邮件: " + ot_return.getString("EMAIL"));
            baseBean.writeLog("通信标识: " + ot_return.getString("PHONE"));
            baseBean.writeLog("直接上级: " + ot_return.getString("MANAGERID"));
            baseBean.writeLog("安全级别: " + ot_return.getString("SECLEVEL"));
            baseBean.writeLog("OA_部门编码: " + ot_return.getString("DEPCODE"));

            baseBean.writeLog("所属分部编码: " + ot_return.getString("CODE"));
            baseBean.writeLog("OA岗位代码: " + ot_return.getString("JOBTITLECODE"));
            baseBean.writeLog("出生日期: " + ot_return.getString("BIRTHDAY"));
            baseBean.writeLog("标识编号: " + ot_return.getString("IDNUMBER"));
            baseBean.writeLog("是否有系统登录账号: " + ot_return.getString("SFDLZH"));

        }

    } catch (Exception e) {
        baseBean.writeLog("CaiBaiBackTest.jsp error: " + e);
    }

    baseBean.writeLog("CaiBaiBackTest.jsp 结束=========== " + TimeUtil.getCurrentTimeString());

%>




