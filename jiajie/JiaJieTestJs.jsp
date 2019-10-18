// 薪资申请流程

<script type="text/javascript">
    // 本次生效日期
    var myDate = 'field73165';
    jQuery(document).ready(function () {
        checkCustomize = function () {
            var myFlag = false;
            // 表单日期
            var myDateVal = jQuery("#" + myDate).val();
            if (myDateVal === '') {
                window.top.Dialog.alert('【本次生效日期】不能为空。');
                return false;
            }
            //  本月1号
            var localDateFirst = getCurrDate(0);

            if (myDateVal >= localDateFirst) {
                myFlag = true;
            } else {
                window.top.Dialog.alert('【本次生效日期】不能早于 ' + localDateFirst)
            }
            return myFlag;
        };
    });

    /**
     * 获取当前日期
     */
    function getCurrDate(nums) {
        var myDate = '';
        jQuery.ajax({
            async: false,
            type: "POST",
            success: function (result, status, xhr) {
                myDate = new Date(xhr.getResponseHeader("Date"));
            }
        });
        myDate.setMonth(myDate.getMonth() + nums);
        var year = myDate.getFullYear();
        var month = myDate.getMonth() + 1;
        var day = myDate.getDate();
        if (month < 10) {
            month = '0' + month;
        }
        if (day < 10) {
            day = '0' + day;
        }
        return year + '-' + month + '-' + '01';
    }
</script>

// 离职流程

<script type="text/javascript">
    // 人员类别
    var rylb = 'field80623';
    // 申请离职日期
    var sqlzrq = 'field80660';

    // 离职日期
    var rzrq = 'field80687';

    jQuery(document).ready(function () {
        checkCustomize = function () {
            var myFlag = false;
            // 人员类别
            var rylbVal = jQuery("#" + rylb).val();
            if (rylbVal === '') {
                window.top.Dialog.alert('【人员类别】不能为空。');
                return false;
            }

            if (rylbVal === '0') {
                // 正编
                // 申请离职日期
                var sqlzrqVal = jQuery("#" + sqlzrq).val();
                if ('' === sqlzrqVal) {
                    window.top.Dialog.alert('【申请离职日期】不能为空。');
                    return false;
                }
                // 当前日期向前15天
                var beforeDate = getCurrDate(-15);
                if (sqlzrqVal >= beforeDate) {
                    myFlag = true;
                } else {
                    window.top.Dialog.alert('【申请离职日期】不能早于 ' + beforeDate);
                }
            } else if (rylbVal === '1') {
                // 托管
                //入职日期
                var rzrqVal = jQuery("#" + rzrq).val();
                if ('' === rzrqVal) {
                    window.top.Dialog.alert('【离职日期】不能为空。');
                    return false;
                }
                // 当前日期向前7天
                var beforeDate1 = getCurrDate(-7);
                if (rzrqVal >= beforeDate1) {
                    myFlag = true;
                } else {
                    window.top.Dialog.alert('【离职日期】不能早于 ' + beforeDate1);
                }
            }
            return myFlag;
        };
    });

    /**
     * 获取当前日期
     */
    function getCurrDate(nums) {
        var myDate = '';
        jQuery.ajax({
            async: false,
            type: "POST",
            success: function (result, status, xhr) {
                myDate = new Date(xhr.getResponseHeader("Date"));
            }
        });

        myDate.setDate(myDate.getDate() + nums);
        var year = myDate.getFullYear();
        var month = myDate.getMonth() + 1;
        var day = myDate.getDate();
        if (month < 10) {
            month = '0' + month;
        }
        if (day < 10) {
            day = '0' + day;
        }
        return year + '-' + month + '-' + day;
    }
</script>


// 协议解除劳动关系申请表-wdd

<script type="text/javascript">
    // 离职日期
    var myDate = 'field80656';
    jQuery(document).ready(function () {
        checkCustomize = function () {
            var myFlag = false;
            // 离职日期
            var myDateVal = jQuery("#" + myDate).val();
            if (myDateVal === '') {
                window.top.Dialog.alert('【离职日期】不能为空。');
                return false;
            }
            //  上月1号
            var localDateFirst = getCurrDate(-1);

            if (myDateVal >= localDateFirst) {
                myFlag = true;
            } else {
                window.top.Dialog.alert('【离职日期】不能早于' + localDateFirst)
            }
            return myFlag;
        };
    });

    /**
     * 获取当前日期
     */
    function getCurrDate(nums) {
        var myDate = '';
        jQuery.ajax({
            async: false,
            type: "POST",
            success: function (result, status, xhr) {
                myDate = new Date(xhr.getResponseHeader("Date"));
            }
        });
        myDate.setMonth(myDate.getMonth() + nums);
        var year = myDate.getFullYear();
        var month = myDate.getMonth() + 1;
        var day = myDate.getDate();
        if (month < 10) {
            month = '0' + month;
        }
        if (day < 10) {
            day = '0' + day;
        }
        return year + '-' + month + '-' + '01';
    }
</script>


// 日常其他费用报销申请流程-wdd

<script type="text/javascript">
    // 发票号
    var fph = 'field75155';
    // 明细表2
    var mxbNum2 = 'submitdtlid1';

    // 发票日期
    var fprq = 'field89648';

    var myReg = new RegExp("^\\d*$");

    jQuery(document).ready(function () {
        checkCustomize = function () {
            // 校验发票日期，需大于3个月前的1号
            var beforeThreeDate = getCurrDate(-3);
            if (!rcDateCheck(beforeThreeDate)) {
                window.top.Dialog.alert('【发票日期】不得早于 ' + beforeThreeDate);
                return false;
            }
            // 表单明细行发票规则校验
            var nums = $("#" + mxbNum2).val().split(',');
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
        };
    });

    // 日期校验
    function rcDateCheck(beforeThreeDate) {
        var flag = true;
        var nums = $("#" + mxbNum2).val().split(',');
        for (var i = 0; i < nums.length; i++) {
            var fprqVal = $("#" + fprq + '_' + nums[i]).val();
            if (fprqVal === '') {
                continue;
            }
            if (fprqVal < beforeThreeDate) {
                flag = false;
            }
        }
        return flag;
    }

    /**
     * 获取当前日期
     */
    function getCurrDate(nums) {
        var myDate = '';
        jQuery.ajax({
            async: false,
            type: "POST",
            success: function (result, status, xhr) {
                myDate = new Date(xhr.getResponseHeader("Date"));
            }
        });
        myDate.setMonth(myDate.getMonth() + nums);
        var year = myDate.getFullYear();
        var month = myDate.getMonth() + 1;
        var day = myDate.getDate();
        if (month < 10) {
            month = '0' + month;
        }
        if (day < 10) {
            day = '0' + day;
        }
        return year + '-' + month + '-' + '01';
    }
</script>


// 招聘需求

<script type="text/javascript">
    // 招聘人数
    var zprs = 'field73196';
    $(function () {
        checkCustomize = function () {
            var zprsVal = $("#" + zprs).val();
            if (zprsVal > 10) {
                window.top.Dialog.alert('【招聘人数】不得超过10人。');
                return false;
            }
            return true;
        }
    })
</script>

// 聘用管理 - 第一节点手机号验证

<script type="text/javascript">
    // 手机号码
    var sjhm = 'field77247';
    // 手机号码验证规则
    var phoneReg = new RegExp("^\\d{11}$");

    $(function () {
        checkCustomize = function () {
            var sjhmVal = $("#" + sjhm).val();
            if (sjhmVal !== '') {
                if (!phoneReg.test(sjhmVal)) {
                    window.top.Dialog.alert('【应聘者手机号】只能由11位纯数字组成。');
                    return false;
                }
            }
            return true;
        }
    })
</script>

// 聘用管理 - 第四节点身份证号验证

<script type="text/javascript">
    // 身份证号码
    var sfzhm = 'field85624';
    // 身份证号码验证规则
    var cfzReg = new RegExp("^\\d{17}[\\dXx]$");

    $(function () {
        checkCustomize = function () {
            var sfzhmVal = $("#" + sfzhm).val();
            if (sfzhmVal !== '') {
                if (!cfzReg.test(sfzhmVal)) {
                    window.top.Dialog.alert('【身份证号码】不合规。');
                    return false;
                }
            }
            return true;
        }
    })
</script>


// 请假申请 日期限制
<script type="text/javascript">
    // 请假开始日期
    var startDate = 'field87127';
    var startTime = 'field87128';
    // 请假结束日期
    var endDate = 'field87129';
    var endTime = 'field87130';

    jQuery(document).ready(function () {
        checkCustomize = function () {
            var myFlag = false;
            var startDateVal = jQuery("#" + startDate).val();
            var startTimeVal = jQuery("#" + startTime).val();
            var endDateVal = jQuery("#" + endDate).val();
            var endTimeVal = jQuery("#" + endTime).val();
            if (startDateVal === '' || endDateVal === '') {
                window.top.Dialog.alert('【请假时间】不能为空。');
                return false;
            }
            //  上月1号
            var localDateFirst = getCurrDate(-1);

            if (startDateVal >= localDateFirst) {
                myFlag = true;
            } else {
                window.top.Dialog.alert('【请假开始时间】不能早于' + localDateFirst)
                return false;
            }

            var startDateTime = startDateVal + ' ' + startTimeVal;
            var endDateTime = endDateVal + ' ' + endTimeVal;
            if (startDateTime >= endDateTime) {
                window.top.Dialog.alert('【请假结束时间】不能早于【请假开始时间】')
                return false;
            }
            return myFlag;
        };
    });

    /**
     * 获取当前日期
     */
    function getCurrDate(nums) {
        var myDate = '';
        jQuery.ajax({
            async: false,
            type: "POST",
            success: function (result, status, xhr) {
                myDate = new Date(xhr.getResponseHeader("Date"));
            }
        });
        myDate.setMonth(myDate.getMonth() + nums);
        var year = myDate.getFullYear();
        var month = myDate.getMonth() + 1;
        var day = myDate.getDate();
        if (month < 10) {
            month = '0' + month;
        }
        if (day < 10) {
            day = '0' + day;
        }
        return year + '-' + month + '-' + '01';
    }
</script>


// 补考勤流程
<script type="text/javascript">
    // 请假开始日期
    var startDate = 'field87625';
    var startTime = 'field87626';
    // 请假结束日期
    var endDate = 'field87627';
    var endTime = 'field87628';

    jQuery(document).ready(function () {
        checkCustomize = function () {
            var myFlag = false;
            var startDateVal = jQuery("#" + startDate).val();
            var startTimeVal = jQuery("#" + startTime).val();
            var endDateVal = jQuery("#" + endDate).val();
            var endTimeVal = jQuery("#" + endTime).val();
            if (startDateVal === '' || endDateVal === '') {
                window.top.Dialog.alert('【日期】不能为空。');
                return false;
            }
            //  上月1号
            var localDateFirst = getCurrDate(-1);

            if (startDateVal >= localDateFirst) {
                myFlag = true;
            } else {
                window.top.Dialog.alert('【开始时间】不能早于' + localDateFirst);
                return false;
            }

            var startDateTime = startDateVal + ' ' + startTimeVal;
            var endDateTime = endDateVal + ' ' + endTimeVal;
            if (startDateTime >= endDateTime) {
                window.top.Dialog.alert('【结束时间】不能早于【开始时间】');
                return false;
            }
            return myFlag;
        };
    });

    /**
     * 获取当前日期
     */
    function getCurrDate(nums) {
        var myDate = '';
        jQuery.ajax({
            async: false,
            type: "POST",
            success: function (result, status, xhr) {
                myDate = new Date(xhr.getResponseHeader("Date"));
            }
        });
        myDate.setMonth(myDate.getMonth() + nums);
        var year = myDate.getFullYear();
        var month = myDate.getMonth() + 1;
        var day = myDate.getDate();
        if (month < 10) {
            month = '0' + month;
        }
        if (day < 10) {
            day = '0' + day;
        }
        return year + '-' + month + '-' + '01';
    }
</script>