<script type="text/javascript">
    // 发票号
    var fph = 'field7068';

    jQuery(document).ready(function () {
        checkCustomize = function () {
            var flag = false;
            //遍历明细表
            var nums = $("#submitdtlid0").val().split(',');

            var allStr = '';
            for (var i = 0; i < nums.length; i++) {
                var csjb = $("#" + fph + '_' + nums[i]).val().trim();
                if (csjb != null && csjb != undefined && csjb != '') {
                    allStr += csjb + ','
                }
            }
            // 表单查重
            var ss = allStr.split(',');
            var repeat = Array.from(new Set(ss.filter(function (currentValue, index, arr) {// 当前元素的值
                return arr.indexOf(currentValue) !== index
            })));
            if (repeat.length > 0) {
                window.top.Dialog.alert('发票号：' + repeat + ' 重复。')
                return false;
            }

            // 数据库查重
            $.ajax({
                type: "post",
                url: "/workflow/request/renhuan/CheckBack.jsp",
                cache: false,
                async: false,
                data: {"allStr": allStr},
                success: function (data) {
                    var data = data.replace(/\s+/g, "");
                    if ("true" == data) {
                        flag = true;
                    } else {
                        window.top.Dialog.alert(data);
                    }
                }
            });

            return flag;
        }
    })
</script>