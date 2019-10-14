<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page"/>
<%@ include file="/systeminfo/init_wev8.jsp" %>

<script src="/workflow/request/testJsp/shauter_wev8.js"></script>
<script src="/workflow/request/testJsp/cw.js"></script>
<script type="text/javascript">
    var cbzx = 'field12164'; // 成本中心
    var yfgc = '12166'; // 研发工程
    var zjgc = '12504'; // 在建工程
    jQuery(document).ready(function () {
        checkCustomize = function () {
            var a1 = Number(jQuery("#field11903").val());   //付款金额
            var a2 = Number(jQuery("#field12315").val());   //票面金额
            if (a1 >= a2) {
                alert("付款金额不能大于票面金额！");
                return false;
            } else {
                return true;
            }
        }
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
