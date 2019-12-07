// 询比价流程-物资类
<script type="text/javascript">
    var mxbNum1 = 'submitdtlid0'; // 明细表1
    let cgsqbh = 'field9117';// 采购申请编号

    // ===========明细表1字段
    let wzbm1 = 'field9091'; // 物资编码
    let wzcms1 = 'field9092'; // 物料长描述
    let dw1 = 'field9093'; // 单位
    let sl1 = 'field9094'; // 数量
    let jhsj1 = 'field9095'; // 交货时间

    jQuery(document).ready(function () {
        appendButton();
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