// 差旅费用报销申请流程_wdd

<script type="text/javascript">
    // 岗位级别
    var gwjb = 'field74133';

    // 出差天数
    var ccts = 'field74625';
    // 目的地
    var mdd = 'field74627';
    // 住宿费
    var zsf = 'field74628';
    // 餐费
    var cf = 'field74630';
    // 交通补贴
    var jtbt = 'field74631';

    // 发票号
    var fph = 'field74637';
    // 发票明细表4
    var mxbNum = 'submitdtlid3';
    var myReg = new RegExp("^\\d*$");

    jQuery(document).ready(function () {
        checkCustomize = function () {
            if (!fpCheck()) {
                return false;
            }
            var params = {};
            var myArray = [];
            params['gwjb'] = jQuery('#' + gwjb).val();

            var myNumber = 1;
            //遍历明细表
            var mx1Val = $("#submitdtlid2").val();
            if (mx1Val === '' || mx1Val === null) {
                return true;
            }

            var nums = mx1Val.split(',');
            for (var i = 0; i < nums.length; i++) {
                var cctsVal = $("#" + ccts + '_' + nums[i]).val();
                var mddVal = $("#" + mdd + '_' + nums[i]).val();
                var zsfVal = $("#" + zsf + '_' + nums[i]).val();
                var cfVal = $("#" + cf + '_' + nums[i]).val();
                var jtbtVal = $("#" + jtbt + '_' + nums[i]).val();
                myArray.push({
                    'myNumber': myNumber,
                    'cctsVal': cctsVal,
                    'mddVal': mddVal,
                    'zsfVal': zsfVal,
                    'cfVal': cfVal,
                    'jtbtVal': jtbtVal
                });
                myNumber++;
            }
            params['mxData'] = myArray;
            var myJson = JSON.stringify(params);

            var flag = false;
            $.ajax({
                type: "post",
                url: "/workflow/request/jiajie/ChaiLvBaoXiaoBack.jsp",
                cache: false,
                async: false,
                data: {"myJson": myJson},
                success: function (data) {
                    data = data.replace(/\s+/g, "");
                    if ("true" == data) {
                        flag = true;
                    } else {
                        window.top.Dialog.alert(data);
                    }
                }
            });

            return flag;
        };

        function fpCheck() {
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
                window.top.Dialog.alert('第：' + ycResult + ' 行发票号格式错误，只能由纯数字组成, 且不能有空格。');
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