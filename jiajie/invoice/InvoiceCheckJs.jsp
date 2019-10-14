<%-- 发票验重--%>

<script type="text/javascript">
    // 发票号
    var fph = 'field75155';
    // 明细表2
    var mxbNum = 'submitdtlid1';

    var myReg = new RegExp("^\\d*$");

    jQuery(document).ready(function () {
        checkCustomize = function () {
            // 表单明细行发票规则校验
            var nums = $("#" + mxbNum).val().split(',');
            var mxLength = nums.length;
            var ycCount = 1;
            var ycResult = '';
            for (var j = 0; j < mxLength; j++) {
                var fphVal = $("#" + fph + '_' + nums[j]).val();
                if (!myReg.test(fphVal)) {
                    ycResult += (ycCount + ',');
                }
                ycCount++;
            }
            if (ycResult.length > 0) {
                ycResult = ycResult.substring(0, ycResult.length - 1);
                window.top.Dialog.alert('第：' + ycResult + ' 行发票号格式错误，只能由纯数字组成, 不能有空格。');
                return false;
            }

            // 表单明细行发票验重
            var allStr = '';
            for (var i = 0; i < mxLength; i++) {
                var csjb = $("#" + fph + '_' + nums[i]).val();
                if (csjb.length > 0) {
                    allStr += csjb + ','
                }
            }
            // 表单查重
            var ss = allStr.split(',');
            var repeat = Array.from(new Set(ss.filter(function (currentValue, index, arr) {// 当前元素的值
                return arr.indexOf(currentValue) !== index
            })));
            if (repeat.length > 0) {
                window.top.Dialog.alert('发票号：' + repeat.toString() + ' 重复。');
                return false;
            }

            return true;
        }
    })
</script>


