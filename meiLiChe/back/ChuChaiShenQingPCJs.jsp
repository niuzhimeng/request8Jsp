<script src="/workflow/request/testJsp/cw.js"></script>
<script type="text/javascript">

    var rq = 'field7588';//开始日期
    var fyqj = 'field8178';//费用区间2

    var ldrq = 'field7599';//入住日期
    var fyqj3 = 'field8179';//费用区间3

    var sftzDetail = 'field7602';//是否同住-明细
    var sftzMain = 'field7673';//是否同住-主表

    var sfczfjMain = 'field7672';//是否乘坐飞机-主表
    jQuery(document).ready(function () {

        _C.run2(rq, fuZhi);
        _C.run2(ldrq, fuZhi1);

        $("#\\$addbutton1\\$").click(function () {
            gatherSfCzfj('nodenum1')
        });
        $("#\\$delbutton1\\$").click(function () {
            gatherSfCzfj('nodenum1')
        });
        _C.run2(sftzDetail, gatherSftz);

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

        function gatherSfCzfj(submitdtlidn) {
            var flag = true;
            var nums = $("#" + submitdtlidn).val();

            if (nums == null || nums == '' || nums == undefined) {
                flag = false;
            }

            if (flag) {
                $("#" + sfczfjMain).val(0);
            } else {
                $("#" + sfczfjMain).val(1);
            }
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

    })
</script>
