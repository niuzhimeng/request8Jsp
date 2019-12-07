// 询比价流程-物资类
<script type="text/javascript">
    let mxbNum1 = 'submitdtlid0'; // 明细表1
    let mxbNum2 = 'submitdtlid1';// 明细表2

    // ===========明细表1字段
    let wzbm1 = 'field9091'; // 物资编码
    // ===========明细表2字段
    let gysmc2 = 'field9366'; // 供应商名称

    jQuery(document).ready(function () {
        checkCustomize = function () {
            let params = {};
            // 拼接明细表1
            let mx1Array = [];
            let mx1Val = $("#" + mxbNum1).val().split(",");
            let mx1Length = mx1Val.length;
            for (let i = 0; i < mx1Length; i++) {
                let wzbm1Val = $("#" + wzbm1 + '_' + mx1Val[i]).val();
                mx1Array.push({
                    'wzbm1Val': wzbm1Val.trim()
                });
            }
            params['mx1Array'] = mx1Array;

            // 拼接明细表2
            let mx2Array = [];
            let mx2Val = $("#" + mxbNum2).val().split(",");
            let mx2Length = mx2Val.length;
            for (let i = 0; i < mx2Length; i++) {
                let gysmc2Val = $("#" + gysmc2 + '_' + mx2Val[i]).val();
                mx2Array.push({
                    "gysmc2Val": gysmc2Val.trim()
                });
            }

            params['mx2Array'] = mx2Array;
            var myJson = JSON.stringify(params);
            let flag = false;
            $.ajax({
                type: "post",
                url: "/workflow/request/zhongsha/crm/YuXuanCheckBack.jsp",
                cache: false,
                async: false,
                data: {"myJson": myJson},
                success: function (myData) {
                    myData = myData.replace(/\s+/g, "");
                    if ("true" === myData) {
                        flag = true;
                    } else {
                        window.top.Dialog.alert(myData);
                    }
                }
            });
            return flag;
        };
    });
</script>