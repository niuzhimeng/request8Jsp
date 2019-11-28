<script src="/workflow/request/testJsp/cw.js"></script>
<script type="text/javascript">
    var fpzd = 'field24066'; // 发票字段
    var sqr = 'field23967'; // 申请人
    var mxbNum5 = 'submitdtlid4'; // 明细表5（发票主表表信息）

    // ===========明细表5字段
    let fpid5 = 'field24068'; // 发票id
    let fph5 = 'field24070'; // 发票号
    let fplx5 = 'field24069'; // 发票类型
    let xsf5 = 'field24074'; // 销售方
    let bz5 = 'field24075'; // 币种

    let fphj5 = 'field24071'; // 发票合计
    let bhs5 = 'field24072'; // 不含税金额
    let se5 = 'field24073'; // 税额
    let sfdk5 = 'field24076'; // 是否抵扣

    // 原有js
    var fylx = 'field23991'; // 费用类型
    var yydm = 'field23998'; // 原因代码

    $(function () {
        appendFpButton();
        _C.run2(fpzd, addCount01);
        jQuery("#" + fylx).bindPropertyChange(function () {
            bindFunction();
        });
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
                        $("#" + sfdk5 + '_' + mainCurrentMxs[mainCurrentRows]).val(mainArrays[i].isdeductible);
                        $("#" + sfdk5 + '_' + mainCurrentMxs[mainCurrentRows] + 'span').html(mainArrays[i].isdeductible);

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

    function bindFunction() {
        var c = jQuery("#" + fylx).val();
        if (c === '0') {
            jQuery("#" + yydm + "_0").val("410");
            jQuery("#" + yydm + "_0span").html("<span class=\"e8_showNameClass\"><a title=\"\" href=\"/formmode/view/AddFormMode.jsp?type=0&amp;modeId=1484&amp;pkfield=S01&amp;formId=-361&amp;billid=410\" target=\"_blank\">410</a>&nbsp;<span class=\"e8_delClass\" id=\"410\" onclick=\"del(event,this,2,false,{});\" style=\"opacity: 1; visibility: hidden;\">&nbsp;x&nbsp;</span></span>");
        } else if (c === '1') {
            jQuery("#" + yydm + "_0").val("210");
            jQuery("#" + yydm + "_0span").html("<span class=\"e8_showNameClass\"><a title=\"\" href=\"/formmode/view/AddFormMode.jsp?type=0&amp;modeId=1484&amp;pkfield=S01&amp;formId=-361&amp;billid=210 \" target=\"_blank\">210</a>&nbsp;<span class=\"e8_delClass\" id=\"210\" onclick=\"del(event,this,2,false,{});\" style=\"opacity: 0; visibility: hidden;\">&nbsp;x&nbsp;</span></span>");
        } else if (c === '3') {
            jQuery("#" + yydm + "_0").val("240");
            jQuery("#" + yydm + "_0span").html("<span class=\"e8_showNameClass\"><a title=\"\" href=\"/formmode/view/AddFormMode.jsp?type=0&amp;modeId=1484&amp;pkfield=S01&amp;formId=-361&amp;billid=240\" target=\"_blank\">240</a>&nbsp;<span class=\"e8_delClass\" id=\"240\" onclick=\"del(event,this,2,false,{});\" style=\"opacity: 0; visibility: hidden;\">&nbsp;x&nbsp;</span></span>");
        } else {
            jQuery("#" + yydm + "_0").val("410");
            jQuery("#" + yydm + "_0span").html("<span class=\"e8_showNameClass\"><a title=\"\" href=\"/formmode/view/AddFormMode.jsp?type=0&amp;modeId=1484&amp;pkfield=S01&amp;formId=-361&amp;billid=410 \" target=\"_blank\">410</a>&nbsp;<span class=\"e8_delClass\" id=\"410\" onclick=\"del(event,this,2,false,{});\" style=\"opacity: 0; visibility: hidden;\">&nbsp;x&nbsp;</span></span>");
        }

    }
</script>
