<%--需求一：填完最后一个字段，执行赋值--%>
<script type="text/javascript">
    // 取值数组 部门id, 预算科目id, 预算额度id
    var vars = ["field6665", "field6666", "field6667"];
    // ============ 赋值字段 ============
    // 可用预算
    var kyys = 'field6661';
    // 审批中预算
    var spzys = 'field6662';
    // 已用预算
    var yyys = 'field6663';

    jQuery(document).ready(function () {
        for (var i = 0; i < vars.length; i++) {
            jQuery('#' + vars[i]).blur(carry);
        }
    });

    function carry() {
        var flag = true;
        for (var i = 0; i < vars.length; i++) {
            var myValue = jQuery('#' + vars[i]).val();
            if (myValue == '' || myValue == null || myValue == undefined) {
                flag = false;
            }
        }

        if (flag) {
            // 部门, 预算科目, 预算额度 的值，拼成一串（逗号分隔）
            var message = '';
            for (var i = 0; i < vars.length; i++) {
                message += jQuery('#' + vars[i]).val() + ',';
            }

            alert('message: ' + message);
            $.post("/workflow/request/shuTaiShen/Background.jsp", {
                "message": message
            }, function (data) {
                var data = data.replace(/\s+/g, "");
                alert('后台返回： ' + data);
                var datas = data.split(',');

                jQuery('#' + kyys).val(datas[0]);
                jQuery('#' + spzys).val(datas[1]);
                jQuery('#' + yyys).val(datas[2]);
            });
        }
    }
</script>


<%-- 需求二 当前申请项目费用超出可用预算，请确认是否继续提交。 --%>
<script type="text/javascript">
    jQuery(document).ready(function () {
        checkCustomize = function () {
            var flag = true;
            var myVal = jQuery("#field6654").val();
            if (myVal > 100) {
                flag = confirm("是否提交?");
            }
            return flag;
        }
    })
</script>

<%--国机财务 js修改--%>

<script type="text/javascript">

    function checkCustomize() {
        //报销类别
        var str0 = document.getElementById("field6447").value;
        //其他费用报销总额（元）
        var str1 = document.getElementById("field6448").value;
        //补领金额（元）
        var str2 = document.getElementById("field6319").value;
        //退还金额（元）
        var str3 = document.getElementById("field6320").value;
        //预借金额（元）
        var str4 = document.getElementById("field6346").value;
        //差旅费用报销总额
        var str5 = document.getElementById("field6345").value;
        //住宿费用报销进项税
        var str6 = document.getElementById("field9534").value;
        //交通费进项税
        var str8 = document.getElementById("field10692").value;

        var flag;
        if (str0 == 1) {
            var st333 = parseFloat(str2) - parseFloat(str3) + parseFloat(str4);
            var st444 = parseFloat(str1);
            if (st333.toFixed(2) == st444.toFixed(2)) {
                flag = true;
            } else {
                window.top.Dialog.alert("【补领金额】-【退还金额】+【预借金额】 ≠【其他费用报销总额】！");
                flag = false;
            }
        } else {
            var st111 = parseFloat(str2) - parseFloat(str3) + parseFloat(str4);
            var st222 = parseFloat(str5) + parseFloat(str6) + parseFloat(str8);

            if (st111.toFixed(2) == st222.toFixed(2)) {
                flag = true;
            } else {
                window.top.Dialog.alert("【补领金额】-【退还金额】+【预借金额】 ≠【差旅费用总额】+【住宿费用进项税】+【交通费用进项税】");
                flag = false;
            }
        }
        return flag;
    }

    var str7 = jQuery("#field10444").val();
    jQuery("#htmlid").append("<a href=" + str7 + " >" + str7 + "</a>");
</script>










