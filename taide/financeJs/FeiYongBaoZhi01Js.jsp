<script type="text/javascript">
    var nzmjs = '<script src="/workflow/request/taide/financeJs/FinanceAdd.js?v=' + new Date().getTime() + '"<\/script>';
    document.write(nzmjs);
</script>

<script type="text/javascript">
    $(function () {
        var name = '<span class="e8_showNameClass"><a href="javaScript:openhrm(150);" onclick="pointerXY(event);">李妍</a>&nbsp;<span class="e8_delClass" id="150" onclick="del(event,this,1,false,{});" style="opacity: 1; visibility: hidden;">&nbsp;x&nbsp;</span></span>';
        __browserNamespace__._writeBackData('field6659', 1, {id: '150', name: name})
    })
</script>

<script src="/workflow/request/testJsp/cw.js"></script>
<script type="text/javascript">
    var fpzd = 'field15419'; // 发票字段
    var sqr = 'field11763'; // 申请人
    var bhsje = 'field11775'; // 不含税金额

    // ===========明细表字段
    var fpid = 'field15430'; // 发票id
    var fph = 'field12157'; // 发票号
    var bhsjemx = 'field12160'; // 不含税金额
    var mxbNum4 = 'submitdtlid3';
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
                url: "/workflow/request/taide/financeJs/FinanceAddBack.jsp",
                cache: false,
                async: false,
                data: {"diffVal": bhVal.toString(), "sqrVal": sqrVal, "allVal": newVal.toString(), "operateType": 2},
                success: function (myData) {
                    myData = myData.replace(/\s+/g, "");
                    var myJson = jQuery.parseJSON(myData);

                    // 不含税金额合计
                    var allMoney = myJson.allMoney;
                    $("#" + bhsje + p.r).val(allMoney);

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
                        $("#" + fph + '_' + currentMxs[currentRows]).val(myJsonArray[i].invoiceNo);
                        $("#" + bhsjemx + '_' + currentMxs[currentRows]).val(myJsonArray[i].noTaxAmount);
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
                    $("#" + bhsje + p.r).val(allMoney);
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
        setTimeout(function () {
            alert('123')
            calSum(0);
        }, 1000);
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
        $.ajax({
            type: "post",
            url: "/workflow/request/taide/invoice/Test.jsp",
            cache: false,
            async: false,
            data: {"userId": ""},
            success: function (myData) {
                window.top.Dialog.alert('获取发票信息成功。');
            }
        });

    }
</script>
