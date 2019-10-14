<%@ page import="com.sap.conn.jco.JCoDestination" %>
<%@ page import="com.weavernorth.taide.kaoQin.jcoTest.ConnPoolThree" %>
<%@ page import="com.sap.conn.jco.JCoFunction" %>
<%@ page import="com.sap.conn.jco.JCoParameterList" %>
<%@ page import="com.sap.conn.jco.JCoTable" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page"/>
<%@ include file="/systeminfo/init_wev8.jsp" %>

<script src="/workflow/request/testJsp/shauter_wev8.js"></script>
<script src="/workflow/request/testJsp/cw.js"></script>
<script type="text/javascript">
    var cbzx = 'field18334'; // 成本中心
    var yfgc = '18336'; // 研发工程
    var zjgc = '18364'; // 在建工程
    jQuery(document).ready(function () {
        checkCustomize = function () {
            var a1 = Number(jQuery("#field18301").val());   //付款金额
            var a2 = Number(jQuery("#field18343").val());   //票面金额
            var a3 = Number(jQuery("#field18367").val());   //借款金额
            var a4 = Number(jQuery("#field18358").val());   //冲账金额
            if (a1 != (a2 - a3)) {
                alert("付款金额必须等于票面金额合计减掉借款金额合计！");
                return false;
            } else {
                if (a3 != a4) {
                    alert("借款金额必须等于冲账金额！");
                    return false;
                } else {
                    return true;
                }
            }
        };

        _C.run2(cbzx, change);
    });

    function change(p) {
        if (p.v.o == undefined) {
            return;
        }
        var nowLine = p.r.substring(1);
        var a = jQuery('#' + cbzx + p.r).val();

        $.ajax({
            type: "post",
            url: "/workflow/request/taide/BaoXiaoBack.jsp",
            cache: false,
            async: false,
            data: {"id": a},
            success: function (data) {
                var data = data.replace(/\s+/g, "");

                if (data === '41') {
                    changeFieldShowattr(zjgc, "2", "1", nowLine);//1、编辑 2、必填 3、只读; 0主表 1明细表
                } else {
                    changeFieldShowattr(zjgc, "1", "1", nowLine);//编辑
                }

                if (data === '42') {
                    changeFieldShowattr(yfgc, "2", "1", nowLine);//1、编辑 2、必填 3、只读; 0主表 1明细表
                } else {
                    changeFieldShowattr(yfgc, "1", "1", nowLine);//编辑
                }
            }
        });
    }
</script>


<%
    BaseBean baseBean = new BaseBean();
    baseBean.writeLog("20191515============");
    try {
        baseBean.writeLog("jcoTest开始==================" + TimeUtil.getCurrentTimeString());
        JCoDestination destination = ConnPoolThree.getJCoDestination();
        try {
            destination.ping();
        } catch (Exception e) {
            System.out.println("接口不通");
        }

        JCoFunction function = destination.getRepository().getFunction("ZHRI0006");

        //function.getImportParameterList().setValue("I_BELNR", "5105600129");

        // 调用sap接口
        function.execute(destination);

        JCoParameterList tableParameterList = function.getTableParameterList();
        System.out.println(tableParameterList.toString());
        JCoTable table1 = function.getTableParameterList().getTable("OUTPUT_P0002");

        // 打印一个表所有字段名
        List<String> zdList = new ArrayList<String>();
        for (int j = 0; j < table1.getFieldCount(); j++) {
            String name = table1.getMetaData().getName(j);
            zdList.add(name);
        }

        baseBean.writeLog("=====================行数： " + table1.getNumRows());
        for (int i = 0; i < table1.getNumRows(); i++) {
            table1.setRow(i);
            for (String zdName : zdList) {
                baseBean.writeLog(zdName + ": " + table1.getString(zdName) + "\r\n");
            }
            baseBean.writeLog("-----------------" + "\r\n");
        }
        baseBean.writeLog("jcoTest结束==================" + TimeUtil.getCurrentTimeString());
    } catch (Exception e) {
        baseBean.writeLog("jcoTest异常==================" + e);
    }
    out.print("执行完毕");
%>