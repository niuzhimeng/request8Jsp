// 物资采购预选供应商审批表- 合并后版本
<script type="text/javascript">
    var mxbNum1 = 'submitdtlid0'; // 明细表1
    let mxbNum2 = 'submitdtlid1';// 明细表2
    let cgsqbh = 'field9117';// 采购申请编号

    // ===========明细表1字段
    let wzbm1 = 'field9091'; // 物资编码
    let wzcms1 = 'field9092'; // 物料长描述
    let dw1 = 'field9093'; // 单位
    let sl1 = 'field9094'; // 数量
    let jhsj1 = 'field9095'; // 交货时间

    let cgsqh1 = 'field16017'; // 采购申请号
    let hxm1 = 'field16018'; // 行项目
    let lx1 = 'field16030'; // 类型
    // ===========明细表2字段
    let gysmc2 = 'field15984'; // 供应商名称

    jQuery(document).ready(function () {
        appendButton();
        checkCustomize = function () {
            let params = {};
            // 拼接明细表1
            let mx1Array = [];
            let mx1Val = $("#" + mxbNum1).val().split(",");
            let mx1Length = mx1Val.length;
            for (let i = 0; i < mx1Length; i++) {
                let wzbm1Val = $("#" + wzbm1 + '_' + mx1Val[i]).val().trim();
                mx1Array.push({
                    'wzbm1Val': wzbm1Val.substring(0, 6)
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

    function newButton() {
        let cgsqbhVal = $("#" + cgsqbh).val();
        $.ajax({
            type: "post",
            url: "/workflow/request/zhongsha/crm/YuXuanGysBack.jsp",
            cache: false,
            async: false,
            data: {"cgsqbhVal": cgsqbhVal},
            success: function (myData) {
                myData = myData.replace(/\s+/g, "");
                let myJson = jQuery.parseJSON(myData);
                let returnState = myJson.zState;
                if ("S" !== returnState) {
                    window.top.Dialog.alert('采购申请编号【' + myJson.banfn + '】, ' + myJson.zmsg);
                } else {
                    // 赋值操作
                    var myJsonArray = myJson.arrays;  // 明细表数组
                    let length = myJsonArray.length;
                    // 查询当前明细行
                    var currentRows;
                    var mxbObj = $("#" + mxbNum1);
                    let mxbObjVal = mxbObj.val();
                    if (mxbObjVal === '') {
                        currentRows = 0;
                    } else {
                        currentRows = mxbObj.val().split(",").length;
                    }

                    for (let i = 0; i < length; i++) {
                        addRow0(0);
                    }
                    let currentMxs = mxbObj.val().split(",");
                    for (let i = 0; i < length; i++) {
                        $("#" + wzbm1 + '_' + currentMxs[currentRows]).val(myJsonArray[i].MATNR);
                        $("#" + wzbm1 + '_' + currentMxs[currentRows] + 'span').html(myJsonArray[i].MATNR);
                        $("#" + wzcms1 + '_' + currentMxs[currentRows]).val(myJsonArray[i].TXZ01);
                        $("#" + wzcms1 + '_' + currentMxs[currentRows] + 'span').html(myJsonArray[i].TXZ01);
                        $("#" + dw1 + '_' + currentMxs[currentRows]).val(myJsonArray[i].MEINS);
                        $("#" + dw1 + '_' + currentMxs[currentRows] + 'span').html(myJsonArray[i].MEINS);
                        $("#" + sl1 + '_' + currentMxs[currentRows]).val(myJsonArray[i].MENGE);
                        $("#" + sl1 + '_' + currentMxs[currentRows] + 'span').html(myJsonArray[i].MENGE);
                        $("#" + jhsj1 + '_' + currentMxs[currentRows]).val(myJsonArray[i].LFDAT);
                        $("#" + jhsj1 + '_' + currentMxs[currentRows] + 'span').html(myJsonArray[i].LFDAT);
                        $("#" + cgsqh1 + '_' + currentMxs[currentRows]).val(myJsonArray[i].BANFN);
                        $("#" + cgsqh1 + '_' + currentMxs[currentRows] + 'span').html(myJsonArray[i].BANFN);
                        $("#" + hxm1 + '_' + currentMxs[currentRows]).val(myJsonArray[i].BNFPO);
                        $("#" + hxm1 + '_' + currentMxs[currentRows] + 'span').html(myJsonArray[i].BNFPO);
                        $("#" + lx1 + '_' + currentMxs[currentRows]).val(myJsonArray[i].BATXT);
                        $("#" + lx1 + '_' + currentMxs[currentRows] + 'span').html(myJsonArray[i].BATXT);
                        currentRows++;
                    }
                }
            }
        });
    }

    function appendButton() {
        jQuery("#getGysInfo").append("<input id=\"getGys\" type=\"button\" value=\"获取供应商\" onclick=\"newButton();\" class=\"e8_btn_top_first\">");
    }
</script>