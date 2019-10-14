// 抵押登记入库流程 - 生成编号

<script src="/classbean/com/weavernorth/cw.js"></script>
<script type="text/javascript">
    // 抵押物编号
    var dywbh = 'field6668';
    // 抵押物类型
    var dywlx = 'field7139';
    // 赋值明细表1
    var mxbNum1 = 'submitdtlid0';

    var buttonId = 'scbh';
    jQuery(document).ready(function () {
        $("#" + buttonId).append("<input id=\"createNum\" type=\"button\" value=\"生成编号\" onclick=\"myCreateNum()\" class=\"e8_btn_top_first\">");
        // checkCustomize = function () {
        //     myCreateNum();
        //     return true;
        // }

        // _C.run2(dywlx, myCreateNum);
        // _C.run2(mxbNum1, deleteChuFa);
    });

    function deleteChuFa(p) {
        if (p.v.o === undefined) {
            return;
        }
        var oldVal = p.v.o;
        var newVal = p.v.n;

        if (oldVal.length > newVal.length) {
            // 删除行
            myCreateNum();
        }
    }

    function myCreateNum(p) {
        if (p !== null && p !== undefined) {
            if (p.v.o === undefined) {
                return;
            }
        }
        var mxbObj = $("#" + mxbNum1).val().split(",");
        var len = mxbObj.length;
        var myArray = [];
        for (var i = 0; i < len; i++) {
            var dywlxVal = $("#" + dywlx + '_' + mxbObj[i]).val();
            myArray.push(dywlxVal);
        }

        $.ajax({
            type: "post",
            url: "/workflow/request/guojicaiwu/BianHaoBack.jsp",
            cache: false,
            async: false,
            data: {"myJson": myArray.toString()},
            success: function (myData) {
                myData = myData.replace(/\s+/g, "");
                var returns = myData.split(",");
                for (var i = 0; i < returns.length; i++) {
                    $("#" + dywbh + '_' + mxbObj[i]).val(returns[i]);
                    $("#" + dywbh + '_' + mxbObj[i] + 'span').html(returns[i]);
                }
            }
        });

    }


</script>







