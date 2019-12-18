<%--03-费用报支-汇公司（新）--%>
<script src="/workflow/request/testJsp/cw.js"></script>
<script type="text/javascript">
    var fpzd = 'field15550'; // 发票字段
    var sqr = 'field11763'; // 申请人
    var bhsje = 'field15646'; // 不含税金额

    // ===========明细表字段
    var fpid = 'field15430'; // 发票id
    var fph = 'field12157'; // 发票号
    var fpCode = 'field12157'; // 发票Code
    var bhsjemx = 'field12160'; // 不含税金额
    var jxs = 'field15379'; // 进项税
    var sl = 'field12159'; // 税率
    var mxbNum1 = 'submitdtlid0'; // 明细表1（主）
    var mxbNum4 = 'submitdtlid3'; // 明细表4（次）
    $(function () {
        appendFpButton();
        _C.run2(fpzd, addCount01);
        _C.run2(mxbNum1, deleteLine);
    });

    function deleteLine(p) {
        if (p.v.o === undefined) {
            return;
        }
        var oldVal = p.v.o;
        var newVal = p.v.n;
        var bhVal;
        if (newVal.length < oldVal.length) {
            let newSz = newVal.split(',');
            let oldSz = oldVal.split(',');
            bhVal = diff(newSz, oldSz);
            var mxbObj = $("#" + mxbNum4).val().split(",");
            let length1 = mxbObj.length;
            // 删除
            var delIndex = [];
            for (var i = 0; i < length1; i++) {
                var fphz = $("#" + fpid + '_' + mxbObj[i]).val().split('_');
                if (bhVal.indexOf(fphz[1]) !== -1) {
                    delIndex.push(mxbObj[i]);
                }
            }
            $("input[name='check_node_3']").each(function () {
                if (delIndex.contains($(this).val())) {
                    $(this).attr("checked", true);
                }
            });
            deleteRow3(3, true);
        }
    }

    function addCount01(p) {
        if (p.v.o === undefined) {
            return;
        }
        var oldVal = p.v.o;
        var newVal = p.v.n;
        var bhVal;
        if (oldVal.length < newVal.length) {
            // 增加
            let newSz = newVal.split(',');
            let oldSz = oldVal.split(',');
            bhVal = diff(newSz, oldSz);
            var sqrVal = $("#" + sqr).val();
            // 查询该发票明细
            $.ajax({
                type: "post",
                url: "/workflow/request/taide/financeJs/FinanceAddBack.jsp",
                cache: false,
                async: false,
                data: {"diffVal": bhVal.toString(), "sqrVal": sqrVal, "allVal": newVal.toString(), "operateType": 2},
                success: function (myData) {
                    myData = myData.replace(/\s+/g, "");
                    var myJson = jQuery.parseJSON(myData);
                    // 不含税金额合计
                    var allMoney = myJson.allMoney;
                    var bhsObj = $("#" + bhsje + p.r);
                    bhsObj.val(allMoney);
                    bhsObj.trigger('change');
                    $("#" + bhsje + p.r + 'span').html(allMoney);
                    // 明细行数组
                    var myJsonArray = myJson.arrays;
                    // 新增行数
                    let length = myJsonArray.length;

                    // 查询当前明细行
                    var currentRows;
                    var mxbObj = $("#" + mxbNum4);
                    let mxbObjVal = mxbObj.val();
                    if (mxbObjVal === '') {
                        currentRows = 0;
                    } else {
                        currentRows = mxbObj.val().split(",").length;
                    }

                    for (var i = 0; i < length; i++) {
                        addRow3(3);
                    }
                    let currentMxs = mxbObj.val().split(",");
                    for (let i = 0; i < length; i++) {
                        $("#" + fpid + '_' + currentMxs[currentRows]).val(myJsonArray[i].uuid + p.r);
                        $("#" + fpid + '_' + currentMxs[currentRows] + 'span').html(myJsonArray[i].uuid + p.r);
                        $("#" + fph + '_' + currentMxs[currentRows]).val(myJsonArray[i].invoiceNo);
                        $("#" + fph + '_' + currentMxs[currentRows] + 'span').html(myJsonArray[i].invoiceNo);
                        $("#" + bhsjemx + '_' + currentMxs[currentRows]).val(myJsonArray[i].taxAmount);
                        $("#" + bhsjemx + '_' + currentMxs[currentRows] + 'span').html(myJsonArray[i].taxAmount);
                        $("#" + jxs + '_' + currentMxs[currentRows]).val(myJsonArray[i].detailTransferTax);
                        $("#" + jxs + '_' + currentMxs[currentRows] + 'span').html(myJsonArray[i].detailTransferTax);
                        $("#" + sl + '_' + currentMxs[currentRows]).val(myJsonArray[i].taxrate);
                        $("#" + sl + '_' + currentMxs[currentRows] + 'span').html(myJsonArray[i].taxrate);
                        if (i === length - 1) {
                            $("#" + jxs + '_' + currentMxs[currentRows]).trigger('change');
                            $("#" + bhsjemx + '_' + currentMxs[currentRows]).trigger('change');
                        }
                        currentRows++;

                    }
                }
            });
        } else {
            $.ajax({
                type: "post",
                url: "/workflow/request/taide/financeJs/FinanceAddBack.jsp",
                cache: false,
                async: false,
                data: {"allVal": newVal.toString(), "operateType": 1},
                success: function (myData) {
                    myData = myData.replace(/\s+/g, "");
                    var myJson = jQuery.parseJSON(myData);
                    // 不含税金额合计
                    var allMoney = myJson.allMoney;
                    var bshObj = $("#" + bhsje + p.r)
                    bshObj.val(allMoney);
                    $("#" + bhsje + p.r + 'span').html(allMoney);
                    bshObj.trigger('change');
                }
            });

            // 删除
            let newSz = newVal.split(',');
            let oldSz = oldVal.split(',');
            bhVal = diff(newSz, oldSz);
            for (let i = 0; i < bhVal.length; i++) {
                bhVal[i] = bhVal[i] + p.r;
            }

            var mxbObj = $("#" + mxbNum4).val().split(",");
            let length1 = mxbObj.length;
            // 删除
            var delIndex = [];
            for (var i = 0; i < length1; i++) {
                if (bhVal.indexOf($("#" + fpid + '_' + mxbObj[i]).val()) !== -1) {
                    delIndex.push(mxbObj[i]);
                }
            }
            $("input[name='check_node_3']").each(function () {
                if (delIndex.contains($(this).val())) {
                    $(this).attr("checked", true);
                }
            });
            deleteRow3(3, true);
        }
    }

    /**
     * 数组去重
     */
    function diff(arr, arr1) {
        for (var i = 0; i < arr.length; i++) {
            var index = arr1.indexOf(arr[i]);
            if (index !== -1) {
                for (var j = index; j < arr1.length; j++) {
                    if (arr1[j] === arr[i]) {
                        arr1.splice(j, 1);
                        j = j - 1;
                    }
                }
                for (var k = i + 1; k < arr.length; k++) {
                    if (arr[k] === arr[i]) {
                        arr.splice(k, 1);
                        k = k - 1;
                    }
                }
                arr.splice(i, 1);
                i = i - 1;
            }
        }
        return arr.concat(arr1);
    }

    function appendFpButton() {
        jQuery("#getFpInfo").append("<input id=\"jiaoYan\" type=\"button\" value=\"获取发票\" onclick=\"newButton();\" class=\"e8_btn_top_first\">");
    }

    function newButton() {
        let queryBut = jQuery("#jiaoYan");
        queryBut.attr("disabled", true);
        queryBut.val('请勿重复点击');
        $.ajax({
            type: "post",
            url: "/workflow/request/taide/invoice/GetInvoiceByGh.jsp",
            cache: false,
            async: false,
            data: {"userId": ""},
            success: function (myData) {
                window.top.Dialog.alert('获取发票信息成功。');
            }
        });
        setTimeout('buttonTrue()', 10000);
    }

    function buttonTrue() {
        let queryBut = jQuery("#jiaoYan");
        queryBut.attr("disabled", false);
        queryBut.val('获取发票');
    }
</script>
