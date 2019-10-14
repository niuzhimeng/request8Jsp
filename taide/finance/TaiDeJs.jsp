<script src="/classbean/com/weavernorth/cw.js"></script>
<script type="text/javascript">
    // 发票多选字段
    var chufa = 'field7128';

    // 赋值字段
    var xm = 'field6614';
    var nl = 'field6615';

    // 赋值明细表2
    var mxbNum2 = 'submitdtlid1';

    jQuery(document).ready(function () {
        _C.run2(chufa, getDetail);
    });

    function getDetail(p) {
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

            // 查询该发票明细
            $.ajax({
                type: "post",
                url: "/workflow/request/taide/finance/BaoXiaoBack.jsp",
                cache: false,
                async: false,
                data: {"params": bhVal.toString()},
                success: function (myData) {
                    myData = myData.replace(/\s+/g, "");
                    var myJson = jQuery.parseJSON(myData);
                    // 新增行数
                    let length = myJson.length;

                    // 查询当前明细行
                    var currentRows;
                    var mxbObj = $("#" + mxbNum2);
                    let mxbObjVal = mxbObj.val();
                    if (mxbObjVal === '') {
                        currentRows = 0;
                    } else {
                        currentRows = mxbObj.val().split(",").length;
                    }
                    for (var i = 0; i < length; i++) {
                        addRow1(1);
                    }

                    let currentMxs = mxbObj.val().split(",");
                    for (let i = 0; i < length; i++) {
                        $("#" + xm + '_' + currentMxs[currentRows]).val(myJson[i].fpmainid);
                        $("#" + nl + '_' + currentMxs[currentRows]).val(myJson[i].mxname);
                        currentRows++;
                    }
                }
            });
        } else {
            // 删除
            let newSz = newVal.split(',');
            let oldSz = oldVal.split(',');
            bhVal = diff(newSz, oldSz);
            bhVal = bhVal.toString().replace(',', '');

            var mxbObj = $("#" + mxbNum2).val().split(",");
            let length1 = mxbObj.length;
            // 删除
            var delIndex = [];
            for (var i = 0; i < length1; i++) {
                if ($("#" + xm + '_' + mxbObj[i]).val() === bhVal) {
                    delIndex.push(mxbObj[i]);
                }
            }
            $("input[name='check_node_1']").each(function () {
                if (delIndex.contains($(this).val())) {
                    $(this).attr("checked", true);
                }
            });
            deleteRow1(1, true);

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

</script>

<script type="text/javascript">
    $(function () {
        $("#field7033").val('213哈哈')
        $("#field7033span").html('213哈哈')
    })
</script>

<script type="text/javascript">
    $(function () {
        var name = '<span class="e8_showNameClass"><a href="javaScript:openhrm(150);" onclick="pointerXY(event);">李妍</a>&nbsp;<span class="e8_delClass" id="150" onclick="del(event,this,1,false,{});" style="opacity: 1; visibility: hidden;">&nbsp;x&nbsp;</span></span>';
        __browserNamespace__._writeBackData('field6659', 1, {id: '150', name: name})
    })
</script>


