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
    var mxbNum6 = 'submitdtlid5'; // 明细表6
    // ===========明细表6字段
    let zbgys6 = 'field15983'; // 中标供应商

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