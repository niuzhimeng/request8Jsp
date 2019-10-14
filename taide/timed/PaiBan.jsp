<%@ page import="com.weavernorth.taide.kaoQin.pbsj05.timedTask.TimedPbsj" %>
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
            if (a1 > a2) {
                alert("付款金额不能大于票面金额合计！");
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
<script type="text/javascript">
    jQuery(document).ready(function () {

        jQuery("#field18302").bindPropertyChange(function () {
            bindFunction();
        });
    });

    function bindFunction() {
        var tempValue = "";
        var tempSpan = "";
        var c = jQuery("#field18302").val();
        if (c == 0) {
            jQuery("#field18309_0").val("410");
            jQuery("#field18309_0span").html("<span class=\"e8_showNameClass\"><a title=\"\" href=\" \" target=\"_blank\">410</ a>&nbsp;<span class=\"e8_delClass\" id=\"410\" onclick=\"del(event,this,2,false,{});\" style=\"opacity: 0; visibility: hidden;\">&nbsp;x&nbsp;</span></span>");
        } else if (c == 1) {
            jQuery("#field18309_0").val("210");
            jQuery("#field18309_0span").html("<span class=\"e8_showNameClass\"><a title=\"\" href=\" \" target=\"_blank\">210</ a>&nbsp;<span class=\"e8_delClass\" id=\"210\" onclick=\"del(event,this,2,false,{});\" style=\"opacity: 0; visibility: hidden;\">&nbsp;x&nbsp;</span></span>");
        } else if (c == 3) {
            jQuery("#field18309_0").val("240");
            jQuery("#field18309_0span").html("<span class=\"e8_showNameClass\"><a title=\"\" href=\" \" target=\"_blank\">240</ a>&nbsp;<span class=\"e8_delClass\" id=\"240\" onclick=\"del(event,this,2,false,{});\" style=\"opacity: 0; visibility: hidden;\">&nbsp;x&nbsp;</span></span>");
        } else {
            jQuery("#field18309_0").val("410");
            jQuery("#field18309_0span").html("<span class=\"e8_showNameClass\"><a title=\"\" href=\" \" target=\"_blank\">410</ a>&nbsp;<span class=\"e8_delClass\" id=\"410\" onclick=\"del(event,this,2,false,{});\" style=\"opacity: 0; visibility: hidden;\">&nbsp;x&nbsp;</span></span>");
        }

    }
</script>


<%
    new TimedPbsj().execute();
    out.print("排班数据同步完成。" + TimeUtil.getCurrentTimeString());
%>