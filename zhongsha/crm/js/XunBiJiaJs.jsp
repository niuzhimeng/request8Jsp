// 询比价流程-服务类
<script type="text/javascript">
    var mxbNum6 = 'submitdtlid5'; // 明细表6
    // ===========明细表6字段
    let zbgys6 = 'field15985'; // 中标供应商

    jQuery(document).ready(function () {
        checkCustomize = function () {
            let params = {};
            // 拼接明细表6
            let mx6Array = [];
            let mx6Val = $("#" + mxbNum6).val().split(",");
            let mx6Length = mx6Val.length;
            for (let i = 0; i < mx6Length; i++) {
                let zbgys6Val = $("#" + zbgys6 + '_' + mx6Val[i]).val();
                mx6Array.push({
                    'zbgys6Val': zbgys6Val.trim()
                });
            }
            params['mx6Array'] = mx6Array;

            var myJson = JSON.stringify(params);
            let flag = false;
            $.ajax({
                type: "post",
                url: "/workflow/request/zhongsha/crm/XunJiaBack.jsp",
                cache: false,
                async: false,
                data: {"myJson": myJson},
                success: function (myData) {
                    myData = myData.replace(/\s+/g, "");
                    let myJson = jQuery.parseJSON(myData);
                    if (true === myJson.state) {
                        flag = true;
                    } else {
                        window.top.Dialog.alert(myJson.msg);
                    }
                }
            });
            return flag;
        };
    });
</script>

// 询比价流程-物资类
<script type="text/javascript">
    let mxbNum6 = 'submitdtlid5'; // 明细表6
    // ===========明细表6字段
    let zbgys6 = 'field16005'; // 中标供应商
    // ===========主表字段
    let zbgysA = 'field16012'; // 中标供应商A
    let zbgysB = 'field16013'; // 中标供应商B
    let zbgysC = 'field16014'; // 中标供应商C
    let zbgysD = 'field16015'; // 中标供应商D
    let zbgysE = 'field16016'; // 中标供应商E

    jQuery(document).ready(function () {
        checkCustomize = function () {
            let map = {
                "1": zbgysA,
                "2": zbgysB,
                "3": zbgysC,
                "4": zbgysD,
                "5": zbgysE,
            };

            let params = {};
            // 拼接明细表6
            let mx6Array = [];
            let mx6Val = $("#" + mxbNum6).val().split(",");
            let mx6Length = mx6Val.length;
            for (let i = 0; i < mx6Length; i++) {
                let zbgys6Val = $("#" + zbgys6 + '_' + mx6Val[i]).val();
                let gysVal = $("#" +   map[zbgys6Val]).val();

                mx6Array.push({
                    'zbgys6Val': gysVal
                });
            }
            params['mx6Array'] = mx6Array;

            var myJson = JSON.stringify(params);
            let flag = false;
            $.ajax({
                type: "post",
                url: "/workflow/request/zhongsha/crm/XunJiaBack.jsp",
                cache: false,
                async: false,
                data: {"myJson": myJson},
                success: function (myData) {
                    myData = myData.replace(/\s+/g, "");
                    let myJson = jQuery.parseJSON(myData);
                    if (true === myJson.state) {
                        flag = true;
                    } else {
                        window.top.Dialog.alert(myJson.msg);
                    }
                }
            });
            return flag;
        };
    });
</script>