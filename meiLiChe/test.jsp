<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea" %>
<%@ taglib uri="/WEB-INF/tld/browser.tld" prefix="brow" %>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page"/>
<script type="text/javascript" src="/js/select/script/jquery-1.8.3.min_wev8.js"></script>
<%@ include file="/systeminfo/init_wev8.jsp" %>

<%
    response.sendRedirect("/workflow/request/meiLiChe/BaoXiaoStandard.jsp?myTime= " + System.currentTimeMillis() / 1000);
%>

<script type="text/javascript">
    $(function () {
        var myUrl = $("#field6667").val();
        $("#mya").append("<a href=" + myUrl + ">" + myUrl + "</a>")

    })
</script>

<script src="/workflow/request/testJsp/cw.js"></script>
<script type="text/javascript">
    var fplx = 'field7789';// 发票类型
    var hsje = 'field7794'; //含税金额
    var wsje = 'field7791';// 未税金额
    var se = 'field7793';// 税额
    jQuery(document).ready(function () {
        _C.run2(fplx, fz);
        _C.run2(hsje, fz);
    });

    function fz(p) {
        if (p.v.o == undefined) {
            return;
        }
        var fplxVal = $("#" + fplx + p.r).val();
        if ("1" == fplxVal) {

            setTimeout(function () {
                alert('赋值')
                $("#" + wsje + p.r).val(0);
                $("#" + se + p.r).val(0);
            }, 2000);
        }
    }
</script>


<%--还款流程 本次还款金额不得大于未还款金额--%>
<script type="text/javascript">
    jQuery(document).ready(function () {
        checkCustomize = function () {
            var bchk = 'field8059'; // 本次还款
            var whk = 'field8058'; // 未还款
            var flag = true;
            var nums = $("#submitdtlid1").val().split(',');
            for (var i = 0; i < nums.length; i++) {
                var bchkVal = $("#" + bchk + '_' + nums[i]).val();// 本次还款
                var whkVal = $("#" + whk + '_' + nums[i]).val();// 未还款
                if (parseFloat(bchkVal) > parseFloat(whkVal)) {
                    flag = false;
                    window.top.Dialog.alert('【本次还款金额】不得大于【未还款金额】');
                }
            }
            return flag;
        }
    })
</script>


//出差流程
<script src="/workflow/request/testJsp/cw.js"></script>
<script type="text/javascript">
    //出差申请第一节点预算表赋值
    var feeTypeFieldId = 'field7585_';//费用类型
    var expectedCostFieldId = 'field7580_';//预计费用
    var rq = 'field7588';//开始日期
    var fyqj = 'field8178';//费用区间2

    var ldrq = 'field7599';//入住日期
    var fyqj3 = 'field8179';//费用区间3

    var sftzDetail = 'field7602';//是否同住-明细
    var sftzMain = 'field7673';//是否同住-主表

    var sfczfjDetail = 'field7593';//是否乘坐飞机-明细
    var sfczfjMain = 'field7672';//是否乘坐飞机-主表
    jQuery(document).ready(function () {
        _C.run2(rq, fuZhi);
        _C.run2(ldrq, fuZhi1);
        _C.run2(sftzDetail, gatherSftz);
        _C.run2(sfczfjDetail, gatherSfCzfj);
        window.setInterval(function () {
            if (jQuery('#field7580_1').attr('readonly')) {
                return;
            }
            jQuery('#innerContent' + feeTypeFieldId + '0div').hide();//费用类型隐藏(交通)
            jQuery('#' + feeTypeFieldId + '0_browserbtn').hide();//费用类型隐藏(交通)
            jQuery('#' + feeTypeFieldId + '0').val('123');//交通费用类型ID
            jQuery('#' + feeTypeFieldId + '0wrapspan').html('交通费用类型');//交通费用类型名称
            jQuery('#innerContent' + feeTypeFieldId + '1div').hide();//费用类型隐藏(住宿)
            jQuery('#' + feeTypeFieldId + '1_browserbtn').hide();//费用类型隐藏(住宿)
            jQuery('#' + feeTypeFieldId + '1').val('456');//住宿费用类型ID
            jQuery('#' + feeTypeFieldId + '1wrapspan').html('住宿费用类型');//住宿费用类型名称
            jQuery('#' + expectedCostFieldId + '0').hide();//预计费用隐藏（交通）
            jQuery('#' + expectedCostFieldId + '0').val(jQuery('#sumvalue7594').val());//预计费用赋值（交通）
            jQuery('#' + expectedCostFieldId + '0span').html(jQuery('#sumvalue7594').val());//预计费用展示（交通）
            jQuery('#' + expectedCostFieldId + '1').hide();//预计费用隐藏（住宿）
            jQuery('#' + expectedCostFieldId + '1').val(jQuery('#sumvalue7604').val());//预计费用赋值（住宿）
            jQuery('#' + expectedCostFieldId + '1span').html(jQuery('#sumvalue7604').val());//预计费用展示（住宿）
        }, 500);
    });

    function fuZhi(p) {
        if (p.v.o == undefined) {
            return;
        }
        var rqVal = $("#" + rq + p.r).val();//日期
        rqVal = parseFloat(rqVal.substring(5, 7));
        $("#" + fyqj + p.r).val(rqVal - 1);//费用区间
    }

    function fuZhi1(p) {
        if (p.v.o == undefined) {
            return;
        }
        var rqVal = $("#" + ldrq + p.r).val();//日期
        rqVal = parseFloat(rqVal.substring(5, 7));
        $("#" + fyqj3 + p.r).val(rqVal - 1);//费用区间
    }

    function gatherSftz(p) {
        if (p.v.o == undefined) {
            return;
        }
        var flag = false;
        var nums = $("#submitdtlid2").val().split(',');
        for (var i = 0; i < nums.length; i++) {
            var current = $("#" + sftzDetail + '_' + nums[i]).val();
            if (parseFloat(current) === 0) {
                flag = true
            }
        }
        if (flag) {
            $("#" + sftzMain).val(0);
        } else {
            $("#" + sftzMain).val(1);
        }
    }

    function gatherSfCzfj(p) {
        if (p.v.o == undefined) {
            return;
        }
        var flag = false;
        var nums = $("#submitdtlid1").val().split(',');
        for (var i = 0; i < nums.length; i++) {
            var current = $("#" + sfczfjDetail + '_' + nums[i]).val();
            if (parseFloat(current) === 0) {
                flag = true
            }
        }
        if (flag) {
            $("#" + sfczfjMain).val(0);
        } else {
            $("#" + sfczfjMain).val(1);
        }
    }
</script>

//明细表控制主表
<script src="/workflow/request/testJsp/cw.js"></script>
<script type="text/javascript">
    var sfczfjDetail = 'field7593';//是否乘坐飞机-明细
    var sfczfjMain = 'field7672';//是否乘坐飞机-主表
    $(function () {
        _C.run2(sftzDetail, gatherSfCzfj);
    });

    function gatherSfCzfj(p) {
        if (p.v.o == undefined) {
            return;
        }
        var flag = false;
        var nums = $("#submitdtlid1").val().split(',');
        for (var i = 0; i < nums.length; i++) {
            var current = $("#" + sfczfjDetail + '_' + nums[i]).val();
            if (parseFloat(current) === 0) {
                flag = true
            }
        }
        if (flag) {
            $("#" + sfczfjMain).val(0);
        } else {
            $("#" + sfczfjMain).val(1);
        }
    }
</script>

//日期截取
<script src="/workflow/request/testJsp/cw.js"></script>
<script type="text/javascript">
    var ldrq = 'field7532';//日期
    var fyqj3 = 'field8183';//区间
    $(function () {
        _C.run2(ldrq, fuZhi1);
    });

    function fuZhi1(p) {
        if (p.v.o == undefined) {
            return;
        }
        var rqVal = $("#" + ldrq + p.r).val();//日期
        rqVal = parseFloat(rqVal.substring(5, 7));
        $("#" + fyqj3 + p.r).val(rqVal - 1);//费用区间
    }
</script>







