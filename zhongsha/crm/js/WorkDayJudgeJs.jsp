// 差旅及用车申请表
<script type="text/javascript">
    var startDate = 'field6783';
    var endDate = 'field6784';
    var startDateSfxxr = 'field14717'; // 是否休息日
    var endDateSfxxr = 'field14718'; // 是否休息日
    jQuery(document).ready(function () {
        $("#" + startDate).bindPropertyChange(function () {
            zsExecute()
        });
        $("#" + endDate).bindPropertyChange(function () {
            zsExecute()
        });
    });

    function zsExecute() {
        var startDateVal = $("#" + startDate).val();
        var endDateVal = $("#" + endDate).val();
        $.ajax({
            type: "post",
            url: "/workflow/request/zhongsha/crm/WorkDayJudgeBack.jsp",
            cache: false,
            async: false,
            data: {"startDateVal": startDateVal, "endDateVal": endDateVal},
            success: function (myData) {
                myData = myData.replace(/\s+/g, "");
                var myJson = jQuery.parseJSON(myData);
                $("#" + startDateSfxxr).val(myJson.startDate);
                $("#" + endDateSfxxr).val(myJson.endDate);
            }
        });
    }
</script>

// PC差旅及用车申请表
<script type="text/javascript">
    //  提交前验证是否大于4小时 ||  大于24小时
    //用车--下拉框
    var yc = "field10858";
    //用车 日期
    var startdate = "field10854";
    //用车 时间
    var starttime = "field10855";

    var yc_value = "";
    var startdate_value = "";
    var starttime_value = "";
    //是否允许提交
    var flag = "";
    //用车时   日期 + 时间
    var startdatetime = "";

    var startDate = 'field10854'; // 乘车日期
    var endDate = 'field10855'; // 返回日期
    var startDateSfxxr = 'field14719'; // 是否休息日
    var endDateSfxxr = 'field14720'; // 是否休息日

    //页面加载事件
    $(function () {
        $("#" + startDate).bindPropertyChange(function () {
            zsExecute()
        });
        $("#" + endDate).bindPropertyChange(function () {
            zsExecute()
        });
        //提交前事件
        checkCustomize = function () {
            //初始化flag
            flag = true;
            startdate_value = $("#" + startdate).val();
            starttime_value = $("#" + starttime).val();
            //用车时间
            startdatetime = startdate_value + " " + starttime_value;
            //用车   1：市区   2：外皋
            yc_value = $("#" + yc).val();
            if (yc_value == 1) {
                //alert(startdatetime+"====0===="+formatDateTime(getnowdatetime2()));
                if (startdatetime < formatDateTime(getnowdatetime2())) {
                    top.Dialog.alert("不能晚于2小时提交");
                    flag = false;
                }
            } else if (yc_value == 2) {
                //alert(startdatetime+"====2===="+formatDateTime(getnowdatetime24()));
                if (startdatetime < formatDateTime(getnowdatetime24())) {
                    top.Dialog.alert("不能晚于24小时提交");
                    flag = false;
                }
            }
            return flag;
        }
    });

    //获取系统当前时间 并加2小时
    function getnowdatetime2() {
        //1. js获取当前时间
        var date = new Date();
        //2. 获取当前分钟
        var min = date.getMinutes();
        //3. 设置当前时间+5分钟：把当前分钟数+5后的值重新设置为date对象的分钟数
        date.setMinutes(min + 2 * 60);
        //4. 测试
        //return date.toLocaleString();
        return date;
    }

    //获取系统当前时间 并加24小时
    function getnowdatetime24() {
        //1. js获取当前时间
        var date = new Date();
        //2. 获取当前分钟
        var min = date.getMinutes();
        //3. 设置当前时间+5分钟：把当前分钟数+5后的值重新设置为date对象的分钟数
        date.setMinutes(min + 24 * 60);
        //4. 测试
        //return date.toLocaleString();
        return date;
    }

    //将date转为 yyyy-mm-dd hh-mm 格式
    function formatDateTime(date) {
        var y = date.getFullYear();
        var m = date.getMonth() + 1;
        m = m < 10 ? ('0' + m) : m;
        var d = date.getDate();
        d = d < 10 ? ('0' + d) : d;
        var h = date.getHours();
        var minute = date.getMinutes();
        minute = minute < 10 ? ('0' + minute) : minute;
        return y + '-' + m + '-' + d + ' ' + h + ':' + minute;
    }

    function zsExecute() {
        var startDateVal = $("#" + startDate).val();
        var endDateVal = $("#" + endDate).val();
        $.ajax({
            type: "post",
            url: "/workflow/request/zhongsha/crm/WorkDayJudgeBack.jsp",
            cache: false,
            async: false,
            data: {"startDateVal": startDateVal, "endDateVal": endDateVal},
            success: function (myData) {
                myData = myData.replace(/\s+/g, "");
                var myJson = jQuery.parseJSON(myData);
                $("#" + startDateSfxxr).val(myJson.startDate);
                $("#" + endDateSfxxr).val(myJson.endDate);
            }
        });
    }
</script>

// DBN差旅及用车申请表
<script type="text/javascript">
    // 提交前验证是否大于4小时 ||  大于24小时
    // 去向
    var yc = "field14320";
    //用车 日期
    var startdate = "field14316";
    //用车 时间
    var starttime = "field14336";

    var yc_value = "";
    var startdate_value = "";
    var starttime_value = "";
    //是否允许提交
    var flag = "";
    //用车时   日期 + 时间
    var startdatetime = "";

    var startDate = 'field14316';
    var endDate = 'field14317';
    var startDateSfxxr = 'field14721'; // 是否休息日
    var endDateSfxxr = 'field14722'; // 是否休息日

    //页面加载事件
    $(function () {
        $("#" + startDate).bindPropertyChange(function () {
            zsExecute()
        });
        $("#" + endDate).bindPropertyChange(function () {
            zsExecute()
        });

        checkCustomize = function () {
            //初始化flag
            flag = true;
            startdate_value = $("#" + startdate).val();
            starttime_value = $("#" + starttime).val();
            //用车时间
            startdatetime = startdate_value + " " + starttime_value;
            //用车   1：市区   2：外皋
            yc_value = $("#" + yc).val();
            if (yc_value == 1) {
                //alert(startdatetime + "====0====" + formatDateTime(getnowdatetime2()));
                if (startdatetime < formatDateTime(getnowdatetime2())) {
                    top.Dialog.alert("市区用车需提前4小时申请");
                    flag = false;
                }
            } else if (yc_value == 2) {
                //alert(startdatetime+"====2===="+formatDateTime(getnowdatetime24()));
                if (startdatetime < formatDateTime(getnowdatetime24())) {
                    top.Dialog.alert("外埠用车需提前24小时申请");
                    flag = false;
                }
            }
            return flag;
        }
    });

    //获取系统当前时间 并加4小时
    function getnowdatetime2() {
        //1. js获取当前时间
        var date = new Date();
        //2. 获取当前分钟
        var min = date.getMinutes();
        //3. 设置当前时间+5分钟：把当前分钟数+5后的值重新设置为date对象的分钟数
        date.setMinutes(min + 4 * 60);
        //4. 测试
        //return date.toLocaleString();
        // alert('当前时间 加4小时： ' + formatDateTime(date))
        return date;
    }

    //获取系统当前时间 并加24小时
    function getnowdatetime24() {
        //1. js获取当前时间
        var date = new Date();
        //2. 获取当前分钟
        var min = date.getMinutes();
        //3. 设置当前时间+5分钟：把当前分钟数+5后的值重新设置为date对象的分钟数
        date.setMinutes(min + 24 * 60);
        //4. 测试
        //return date.toLocaleString();
        return date;
    }

    //将date转为 yyyy-mm-dd hh-mm 格式
    function formatDateTime(date) {
        var y = date.getFullYear();
        var m = date.getMonth() + 1;
        m = m < 10 ? ('0' + m) : m;
        var d = date.getDate();
        d = d < 10 ? ('0' + d) : d;
        var h = date.getHours();
        h = h < 10 ? ('0' + h) : h;
        var minute = date.getMinutes();
        minute = minute < 10 ? ('0' + minute) : minute;
        return y + '-' + m + '-' + d + ' ' + h + ':' + minute;
    }

    function zsExecute() {
        var startDateVal = $("#" + startDate).val();
        var endDateVal = $("#" + endDate).val();
        $.ajax({
            type: "post",
            url: "/workflow/request/zhongsha/crm/WorkDayJudgeBack.jsp",
            cache: false,
            async: false,
            data: {"startDateVal": startDateVal, "endDateVal": endDateVal},
            success: function (myData) {
                myData = myData.replace(/\s+/g, "");
                var myJson = jQuery.parseJSON(myData);
                $("#" + startDateSfxxr).val(myJson.startDate);
                $("#" + endDateSfxxr).val(myJson.endDate);
            }
        });
    }
</script>

<script type="text/javascript">
    var mainZd = 'field16223';
    var detailZd = 'field16177';
    var mxbNum1 = 'submitdtlid0'; // 明细表1
    jQuery(document).ready(function () {
        $("#" + mainZd).bindPropertyChange(function () {
            var mainZdVal = $('#' + mainZd).val();
            if (!mainZdVal) {
                return;
            }

            if (mainZdVal == '0') {
                setNewVal(1, 0);
            } else if (mainZdVal == '1') {
                setNewVal(0, 1);
            }
        });
    });

    function setNewVal(standard, newVal) {
        var mxDetail = $('#'+mxbNum1).val().split(',');
        var len = mxDetail.length;
        for (var i = 0; i < len; i++) {
            var currVal = $('#' + detailZd + "_" + mxDetail[i]).val();
            if (currVal && currVal == standard) {
                $('#' + detailZd + "_" + mxDetail[i]).val(newVal);
            }
        }
    }
</script>

