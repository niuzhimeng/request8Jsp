<%@ page import="com.sap.conn.jco.JCoDestination" %>
<%@ page import="com.sap.conn.jco.JCoFunction" %>
<%@ page import="com.sap.conn.jco.JCoParameterList" %>
<%@ page import="com.sap.conn.jco.JCoTable" %>
<%@ page import="com.weavernorth.caibai.sap.CaiBaiPoolThree" %>
<%@ page import="weaver.general.BaseBean" %>
<%@ page import="weaver.general.TimeUtil" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%
    BaseBean baseBean = new BaseBean();
    baseBean.writeLog("CaiBaiBackTest.jsp 执行=========== " + TimeUtil.getCurrentTimeString());
    try {
        JCoDestination jCoDestination = CaiBaiPoolThree.getJCoDestination();
        jCoDestination.ping();

        baseBean.writeLog("ping 通=====");

        // ZMMEX0010_JJJB_IF(测试)  ZOAIF0010
        JCoFunction function = jCoDestination.getRepository().getFunction("ZOAIF0010_RFC");
        baseBean.writeLog("获取函数完成===== " + function);

        JCoParameterList tableParameterList = function.getTableParameterList();

        JCoTable table = tableParameterList.getTable("IT_TAB");
        int fieldCount1 = table.getFieldCount();
        for (int i = 0; i < fieldCount1; i++) {
            baseBean.writeLog(table.getMetaData().getName(i) + ": " + table.getMetaData().getDescription(i));
        }

//        for (int i = 0; i < 5; i++) {
//            table.appendRow();
//            table.setRow(i);
//            table.setValue("ZHZDWBM", "nzm" + i);
//        }
//
//        baseBean.writeLog("拼接后表： " + table.toString());
//
//        // 调用sap接口
//        function.execute(jCoDestination);
//        baseBean.writeLog("调用接口结束===========");
//
//        JCoParameterList list = function.getTableParameterList();
//        baseBean.writeLog("list=======： " + list);
//
//        JCoTable ot_return = list.getTable("IT_TAB");
//
//        int fieldCount = ot_return.getFieldCount();
//        for (int i = 0; i < fieldCount; i++) {
//            baseBean.writeLog(ot_return.getMetaData().getName(i) + ": " + ot_return.getMetaData().getDescription(i));
//        }


//        int numRows = ot_return.getNumRows();
//        baseBean.writeLog("返回表行数： " + numRows);
//        for (int i = 0; i < numRows; i++) {
//            ot_return.setRow(i);
//            baseBean.writeLog(ot_return.getString("TYPE"));
//            baseBean.writeLog(ot_return.getString("MESSAGE"));
//        }

    } catch (Exception e) {
        baseBean.writeLog("CaiBaiBackTest.jsp error: " + e);
    }

    baseBean.writeLog("CaiBaiBackTest.jsp 结束=========== " + TimeUtil.getCurrentTimeString());

%>

<script type="text/javascript">
    // 日期字段
    var allFile = 'field9438';
    jQuery(document).ready(function () {
        checkCustomize = function () {
            var date;
            jQuery.ajax({
                async: false,
                type: "POST",
                success: function (result, status, xhr) {
                    date = new Date(xhr.getResponseHeader("Date"));
                }
            });
            var dateVal = formatDateTime(date);

            jQuery('#' + allFile).val(dateVal);
            return true;
        }
    });

    function formatDateTime(date) {
        var y = date.getFullYear();
        var m = date.getMonth() + 1;
        m = m < 10 ? ('0' + m) : m;
        var d = date.getDate();
        d = d < 10 ? ('0' + d) : d;
        var h = date.getHours();
        h = h < 10 ? ('0' + h) : h;
        var minute = date.getMinutes();
        minute = minute < 10 ? ('0' + minute) : minute;
        return y + '-' + m + '-' + d;
    }
</script>

















