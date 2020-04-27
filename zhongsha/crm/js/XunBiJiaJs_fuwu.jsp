// 中沙石化询比价流程（服务） 第一节点 给下拉框赋值
// 带出预选流程供应商名称
<script type="text/javascript">
    // =============== 下拉框赋值
    var dwsl = 'field16660'; // 询比价单位数量
    var xlk = 'field16550'; // 下拉框

    // =============== 供应商名称赋值
    var yxTableName = 'formtable_main_33_dt1'; // 预选流程表名
    var gysFiled = 'xzgys'; // 预选流程-供应商字段名
    var gysFiledStr = 'Supplier_Name'; // 预选流程-供应商中文字段名
    var yxlc = 'field16540'; // 预选流程
    var configName = {
        '1': 'field16552', // 供应商名称a
        '2': 'field16553', // 供应商名称b
        '3': 'field16554', // 供应商名称c
        '4': 'field16555', // 供应商名称d
        '5': 'field16556', // 供应商名称e

        '6': 'field16557', // 供应商名称f
        '7': 'field16558', // 供应商名称g
        '8': 'field16559', // 供应商名称h
        '9': 'field16560', // 供应商名称i
        '10': 'field16561', // 供应商名称j
    };
    jQuery(document).ready(function () {
        $("#" + dwsl).bindPropertyChange(function () {
            xlkFuZhi();
        });

        $("#" + yxlc).bindPropertyChange(function () {
            xlkFuZhi();
            getName();
        });
    });

    function xlkFuZhi() {
        var dwslVal = $("#" + dwsl).val();
        $("#" + xlk).val(dwslVal);
        $("#" + xlk).trigger('change');

    }

    function getName() {
        $.ajax({
            type: "post",
            url: "/workflow/request/zhongsha/crm/YuXuanGetName.jsp",
            cache: false,
            async: true,
            data: {
                "yxlc": $("#" + yxlc).val(),
                'yxTableName': yxTableName,
                "gysFiled": gysFiled,
                "gysFiledStr": gysFiledStr
            },
            dataType: 'json',
            success: function (myData) {
                var gysArray = myData.gysArray;

                var len = gysArray.length;
                for (var i = 0; i < len; i++) {
                    var sz = gysArray[i].split(',');
                    $("#" + configName[i + 1]).val(sz[0]);
                    var mya = "<a title=\"" + sz[1] + "\" href=\"/formmode/view/AddFormMode.jsp?type=0&amp;modeId=67&amp;formId=-232&amp;billid=" + sz[0] + "\" target=\"_blank\">" + sz[1] + "</a>";
                    $("#" + configName[i + 1] + 'span').html(mya);
                }
            }
        });
    }
</script>


// 中沙石化询比价流程（服务） 供应商A节点 明细表【单价字段必填】
<script src="/workflow/request/zhongsha/crm/shauter_wev8.js"></script>
<script type="text/javascript">
    var fj = '16563'; // 附件

    jQuery(document).ready(function () {
        changeFieldShowattr(fj, "2", "0", -1);
        checkCustomize = function () {
            return confirm("提交后无法撤回或修改报价，请确认提交!");
        }
    });
</script>