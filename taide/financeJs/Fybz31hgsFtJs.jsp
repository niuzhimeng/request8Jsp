<%--31-费用报支-汇公司（分摊-新）--%>
<script src="/workflow/request/testJsp/cw.js"></script>
<script type="text/javascript">
    var fpzd = 'field15570'; // 发票字段
    var sqr = 'field11763'; // 申请人

    // ===========明细表4字段
    var fpid = 'field15430'; // 发票id
    var fph = 'field12157'; // 发票号
    var fpCode = 'field12157'; // 发票Code
    var bhsjemx = 'field12160'; // 不含税金额
    var jxs = 'field15379'; // 进项税
    var sl4 = 'field12159'; // 税率
    var mxbNum5 = 'submitdtlid4'; // 明细表5（发票主表表信息）
    var mxbNum4 = 'submitdtlid3'; // 明细表4（发票明细表表信息）

    // ===========明细表5字段
    let fpid5 = 'field15450'; // 发票id
    let fph5 = 'field15374'; // 发票号
    let fplx5 = 'field15559'; // 发票类型
    let xsf5 = 'field15557'; // 销售方
    let bz5 = 'field15558'; // 币种

    let fphj5 = 'field15375'; // 发票合计
    let bhs5 = 'field15376'; // 不含税金额
    let se5 = 'field15377'; // 税额

    $(function () {
        appendFpButton();
        _C.run2(fpzd, addCount01);
    });

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
                url: "/workflow/request/taide/financeJs/FinanceAddFtBack.jsp",
                cache: false,
                async: false,
                data: {"diffVal": bhVal.toString(), "sqrVal": sqrVal, "allVal": newVal.toString()},
                success: function (myData) {
                    myData = myData.replace(/\s+/g, "");
                    var myJson = jQuery.parseJSON(myData);

                    var myJsonArray = myJson.arrays;  // 发票明细表数组
                    let length = myJsonArray.length;

                    // 发票明细表信息新增==================
                    // 查询当前明细行
                    var currentRows;
                    var mxbObj = $("#" + mxbNum4);
                    let mxbObjVal = mxbObj.val();
                    if (mxbObjVal === '') {
                        currentRows = 0;
                    } else {
                        currentRows = mxbObj.val().split(",").length;
                    }

                    for (let i = 0; i < length; i++) {
                        addRow3(3);
                    }
                    let currentMxs = mxbObj.val().split(",");
                    for (let i = 0; i < length; i++) {
                        $("#" + fpid + '_' + currentMxs[currentRows]).val(myJsonArray[i].uuid);
                        $("#" + fpid + '_' + currentMxs[currentRows] + 'span').html(myJsonArray[i].uuid);
                        $("#" + fph + '_' + currentMxs[currentRows]).val(myJsonArray[i].invoiceNo);
                        $("#" + fph + '_' + currentMxs[currentRows] + 'span').html(myJsonArray[i].invoiceNo);
                        $("#" + bhsjemx + '_' + currentMxs[currentRows]).val(myJsonArray[i].taxAmount);
                        $("#" + bhsjemx + '_' + currentMxs[currentRows] + 'span').html(myJsonArray[i].taxAmount);
                        $("#" + jxs + '_' + currentMxs[currentRows]).val(myJsonArray[i].detailTransferTax);
                        $("#" + jxs + '_' + currentMxs[currentRows] + 'span').html(myJsonArray[i].detailTransferTax);
                        $("#" + sl4 + '_' + currentMxs[currentRows]).val(myJsonArray[i].taxrate);
                        $("#" + sl4 + '_' + currentMxs[currentRows] + 'span').html(myJsonArray[i].taxrate);

                        if (i === length - 1) {
                            $("#" + jxs + '_' + currentMxs[currentRows]).trigger('change');
                            $("#" + bhsjemx + '_' + currentMxs[currentRows]).trigger('change');
                        }
                        currentRows++;
                    }

                    // 发票主表信息新增==================
                    var mainArrays = myJson.mainArrays; // 发票主表数组
                    let mainLength = mainArrays.length;
                    // 查询当前明细行
                    var mainCurrentRows;
                    var myMainObj = $("#" + mxbNum5);

                    let mainObjVal = myMainObj.val();
                    if (mainObjVal === '') {
                        mainCurrentRows = 0;
                    } else {
                        mainCurrentRows = myMainObj.val().split(",").length;
                    }

                    for (let i = 0; i < mainLength; i++) {
                        addRow4(4);
                    }
                    let mainCurrentMxs = myMainObj.val().split(",");
                    for (let i = 0; i < mainLength; i++) {
                        $("#" + fpid5 + '_' + mainCurrentMxs[mainCurrentRows]).val(mainArrays[i].uuid);
                        $("#" + fpid5 + '_' + mainCurrentMxs[mainCurrentRows] + 'span').html(mainArrays[i].uuid);
                        $("#" + fph5 + '_' + mainCurrentMxs[mainCurrentRows]).val(mainArrays[i].invoiceNo);
                        $("#" + fph5 + '_' + mainCurrentMxs[mainCurrentRows] + 'span').html(mainArrays[i].invoiceNo);
                        $("#" + fplx5 + '_' + mainCurrentMxs[mainCurrentRows]).val(mainArrays[i].invoiceTypeName);
                        $("#" + fplx5 + '_' + mainCurrentMxs[mainCurrentRows] + 'span').html(mainArrays[i].invoiceTypeName);
                        $("#" + xsf5 + '_' + mainCurrentMxs[mainCurrentRows]).val(mainArrays[i].salerName);
                        $("#" + xsf5 + '_' + mainCurrentMxs[mainCurrentRows] + 'span').html(mainArrays[i].salerName);
                        $("#" + bz5 + '_' + mainCurrentMxs[mainCurrentRows]).val(mainArrays[i].currencyTypeName);
                        $("#" + bz5 + '_' + mainCurrentMxs[mainCurrentRows] + 'span').html(mainArrays[i].currencyTypeName);

                        $("#" + fphj5 + '_' + mainCurrentMxs[mainCurrentRows]).val(mainArrays[i].totalAmount);
                        $("#" + fphj5 + '_' + mainCurrentMxs[mainCurrentRows] + 'span').html(mainArrays[i].totalAmount);
                        $("#" + bhs5 + '_' + mainCurrentMxs[mainCurrentRows]).val(mainArrays[i].invoiceAmount);
                        $("#" + bhs5 + '_' + mainCurrentMxs[mainCurrentRows] + 'span').html(mainArrays[i].invoiceAmount);
                        $("#" + se5 + '_' + mainCurrentMxs[mainCurrentRows]).val(mainArrays[i].taxAmount);
                        $("#" + se5 + '_' + mainCurrentMxs[mainCurrentRows] + 'span').html(mainArrays[i].taxAmount);

                        if (i === mainLength - 1) {
                            $("#" + fphj5 + '_' + mainCurrentMxs[mainCurrentRows]).trigger('change');
                            $("#" + bhs5 + '_' + mainCurrentMxs[mainCurrentRows]).trigger('change');
                            $("#" + se5 + '_' + mainCurrentMxs[mainCurrentRows]).trigger('change');
                        }
                        mainCurrentRows++;
                    }
                }

            });
        } else {
            // 删除
            let newSz = newVal.split(',');
            let oldSz = oldVal.split(',');
            bhVal = diff(newSz, oldSz);

            var mxbObj = $("#" + mxbNum4).val().split(",");
            let length1 = mxbObj.length;
            // 删除
            var delIndex = [];
            for (let i = 0; i < length1; i++) {
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

            // 删除发票主表信息
            let mainObj = $("#" + mxbNum5).val().split(",");
            let mainLength = mainObj.length;
            // 删除
            var mainDelIndex = [];
            for (let i = 0; i < mainLength; i++) {
                if (bhVal.indexOf($("#" + fpid5 + '_' + mainObj[i]).val()) !== -1) {
                    mainDelIndex.push(mainObj[i]);
                }
            }
            $("input[name='check_node_4']").each(function () {
                if (mainDelIndex.contains($(this).val())) {
                    $(this).attr("checked", true);
                }
            });
            deleteRow4(4, true);
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



