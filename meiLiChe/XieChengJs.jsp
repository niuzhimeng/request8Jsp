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

        zhuiJia();

        _C.run2(rq, fuZhi);
        _C.run2(ldrq, fuZhi1);
        _C.run2(sftzDetail, gatherSftz);
        _C.run2(sfczfjDetail, gatherSfCzfj);
        //     window.setInterval(function () {
        //         if (jQuery('#field7580_1').attr('readonly')) {
        //             return;
        //         }
        //         //jQuery('#innerContent' + feeTypeFieldId + '0div').hide();//费用类型隐藏(交通)
        //         //jQuery('#' + feeTypeFieldId + '0_browserbtn').hide();//费用类型隐藏(交通)
        //         jQuery('#' + feeTypeFieldId + '0').val('123');//交通费用类型ID
        //         jQuery('#' + feeTypeFieldId + '0wrapspan').html('交通费用类型');//交通费用类型名称
        //         jQuery('#innerContent' + feeTypeFieldId + '1div').hide();//费用类型隐藏(住宿)
        //         jQuery('#' + feeTypeFieldId + '1_browserbtn').hide();//费用类型隐藏(住宿)
        //         jQuery('#' + feeTypeFieldId + '1').val('456');//住宿费用类型ID
        //         jQuery('#' + feeTypeFieldId + '1wrapspan').html('住宿费用类型');//住宿费用类型名称
        //         jQuery('#' + expectedCostFieldId + '0').hide();//预计费用隐藏（交通）
        //         jQuery('#' + expectedCostFieldId + '0').val(jQuery('#sumvalue7594').val());//预计费用赋值（交通）
        //         jQuery('#' + expectedCostFieldId + '0span').html(jQuery('#sumvalue7594').val());//预计费用展示（交通）
        //         jQuery('#' + expectedCostFieldId + '1').hide();//预计费用隐藏（住宿）
        //         jQuery('#' + expectedCostFieldId + '1').val(jQuery('#sumvalue7604').val());//预计费用赋值（住宿）
        //         jQuery('#' + expectedCostFieldId + '1span').html(jQuery('#sumvalue7604').val());//预计费用展示（住宿）
        //     }, 500);
        // });

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
    })

    function zhuiJia() {
        jQuery("#ssoid").append("<input id=\"jiaoYan\" type=\"button\" value=\"跳转携程\" onclick=\"newButton();\" class=\"e8_btn_top_first\">");


    }

    function newButton() {
        var sqrgh = $("#field7560").val()
        var sqdh= $("#field7557").val()
        alert('申请人工号' + sqrgh)
        window.open("/com/weavernorth/mlc/SSO.jsp?sqrgh="+sqrgh+"&sqdh="+sqdh);

    }

</script>





