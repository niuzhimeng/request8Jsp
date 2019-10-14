<%--报销流程 正式环境 js修改--%>

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







