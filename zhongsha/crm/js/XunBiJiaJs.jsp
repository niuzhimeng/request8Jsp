// 询比价流程-服务类
<script type="text/javascript">
    var mxbNum6 = 'submitdtlid5'; // 明细表6
    // ===========明细表6字段
    var zbgys6 = 'field15985'; // 中标供应商

    jQuery(document).ready(function () {
        checkCustomize = function () {
            var params = {};
            // 拼接明细表6
            var mx6Array = [];
            var mx6Val = $("#" + mxbNum6).val().split(",");
            var mx6Length = mx6Val.length;
            for (var i = 0; i < mx6Length; i++) {
                var zbgys6Val = $("#" + zbgys6 + '_' + mx6Val[i]).val();
                mx6Array.push({
                    'zbgys6Val': zbgys6Val.trim()
                });
            }
            params['mx6Array'] = mx6Array;

            var myJson = JSON.stringify(params);
            var flag = false;
            $.ajax({
                type: "post",
                url: "/workflow/request/zhongsha/crm/XunJiaBack.jsp",
                cache: false,
                async: false,
                data: {"myJson": myJson},
                success: function (myData) {
                    myData = myData.replace(/\s+/g, "");
                    var myJson = jQuery.parseJSON(myData);
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
    var zbgys6 = 'field16005'; // 中标供应商
    // ===========主表字段
    var zbgysA = 'field16012'; // 中标供应商A
    var zbgysB = 'field16013'; // 中标供应商B
    var zbgysC = 'field16014'; // 中标供应商C
    var zbgysD = 'field16015'; // 中标供应商D
    var zbgysE = 'field16016'; // 中标供应商E

    jQuery(document).ready(function () {
        checkCustomize = function () {
            var map = {
                "1": zbgysA,
                "2": zbgysB,
                "3": zbgysC,
                "4": zbgysD,
                "5": zbgysE,
            };

            var params = {};
            // 拼接明细表6
            var mx6Array = [];
            var mx6Val = $("#" + mxbNum6).val().split(",");
            var mx6Length = mx6Val.length;
            for (var i = 0; i < mx6Length; i++) {
                var zbgys6Val = $("#" + zbgys6 + '_' + mx6Val[i]).val();
                var gysVal = $("#" +   map[zbgys6Val]).val();

                mx6Array.push({
                    'zbgys6Val': gysVal
                });
            }
            params['mx6Array'] = mx6Array;

            var myJson = JSON.stringify(params);
            var flag = false;
            $.ajax({
                type: "post",
                url: "/workflow/request/zhongsha/crm/XunJiaBack.jsp",
                cache: false,
                async: false,
                data: {"myJson": myJson},
                success: function (myData) {
                    myData = myData.replace(/\s+/g, "");
                    var myJson = jQuery.parseJSON(myData);
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