<script src="/mobile/plugin/cw.js"></script>
<script type="text/javascript">
    var mainHrm = 'field6655'; // 主表人力字段
    var detailHrm = 'field7028'; // 明细表人力字段
    var resultZd = 'field7029'; // 赋值字段

    jQuery(document).ready(function () {
        _C.run2(detailHrm, gatherSftz);
        _C.run2(mainHrm, gatherSftz);
    });

    function gatherSftz(p) {
        if (p.v.o == undefined) {
            return;
        }
        var mainHrmVal = $("#" + mainHrm).val(); // 主表人力字段值
        var flag = true;
        var nums = $("#indexnum0").val();
        for (var i = 0; i < nums; i++) {
            var current = $("#" + detailHrm + '_' + i).val();
            if (current == null || current == undefined || current == '') {
                continue;
            }
            if (parseFloat(current) != mainHrmVal) {
                flag = false
            }
        }
        if (flag) {
            $("#" + resultZd).val(0);
        } else {
            $("#" + resultZd).val(1);
        }
    }
</script>

