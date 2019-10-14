<!DOCTYPE html>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page"/>
<%@ include file="/systeminfo/init_wev8.jsp" %>


<script type="text/javascript">
    jQuery(document).ready(function () {
        doSave_nNew = function () {
            window.top.Dialog.alert("无法保存，请直接提交！！！");
            return false;
        };

        checkCustomize = function () {
            //以下是都有的
            var type = jQuery('#field12439').val(); //类型
            var sDate = jQuery('#field8561').val(); //开始日期
            var eDate = jQuery('#field8563').val(); //结束日期
            var sHour = jQuery('#field12443').val(); //开始小时
            var eHour = jQuery('#field12444').val(); //结束小时
            var sMinute = jQuery('#field12445').val(); //开始分钟
            var eMinute = jQuery('#field12446').val(); //结束分钟
            //以上是都有的

            //这个请假有的
            var annualLeaveNumber = jQuery('#field8246').val(); //年假数量
            var tuneOffNumber = jQuery('#field8247').val(); //调休假数量
            //这个是请假有的

            var date;
            jQuery.ajax({
                async: false,
                type: "POST", //get 方式猎豹有问题
                success: function (result, status, xhr) {
                    date = new Date(xhr.getResponseHeader("Date"));
                }
            });

            if (sHour.length == 1) {
                sHour = '0' + sHour;
            }
            if (eHour.length == 1) {
                eHour = '0' + eHour;
            }
            var year = date.getFullYear();
            //这里是拼装开始和结束日期
            var startDate = NewDate(sDate + ' ' + sHour + ":" + (sMinute == 0 ? '00' : '30') + ":00");
            var endDate = NewDate(eDate + ' ' + eHour + ":" + (eMinute == 0 ? '00' : '30') + ":00");

            // 计算时间差, 单位是毫秒
            var minus = endDate.getTime() - startDate.getTime();
            //这里是毫秒，除以1000是秒，除60是分钟再除60是小时
            var hour = minus / (1000 * 60 * 60);

            var flag1 = checkDate(startDate, 26);
            var flag2 = checkDate(endDate, 26);
            if (!(flag1 && flag2)) {
                window.top.Dialog.alert("开始日期超过考勤周期");
            }
            //这里是拼装开始和结束日期
            //时长不能为负数
            if (hour <= 0) {
                window.top.Dialog.alert("请假时长应大于0");
                return false;
            }

            //年假最小休假单位为4
            if (type == "4") {
                if (hour < 4) {
                    window.top.Dialog.alert("年假最小单位为4个小时");
                    return false;
                }
            }
            //事假最小休假单位为1
            if (type == "0") {
                if (hour < 1) {
                    window.top.Dialog.alert("事假最小单位为1个小时");
                    return false;
                }
            }
            //家长会假最大4个小时
            if (type == "9") {
                if (hour > 4) {
                    window.top.Dialog.alert("家长会假最多请四个小时");
                    return false;
                }
            }
            //产检假不能超过一天
            if (type == "7") {
                if (hour > 9) {
                    window.top.Dialog.alert("产检假最多请一天");
                    return false;
                }
            }
            //陪产假不能超过15天
            if (type == "10") {
                var temp = parseInt(hour / 24);
                if (temp != 15) {
                    window.top.Dialog.alert("陪产假只能一次请连续的15天");
                    return false;
                }
            }
            //病假最小请假单位1个小时
            if (type == "1") {
                if (hour < 1) {
                    window.top.Dialog.alert("病假最小单位为1小时");
                    return false;
                }
            }
            //产假：大于等于128天
            if (type == "2") {
                var temp = hour / 24;
                if (temp < 128) {
                    window.top.Dialog.alert("产假需要大于等于128天");
                    return false;
                }
            }
            //其他假不能跨天申请
            if (type == "11") {
                var flag3 = chechkCrossDay(startDate.getDate(), endDate.getDate(), endDate.getHours(), endDate.getMinutes());
                if (!flag3) {
                    window.top.Dialog.alert("其他假不能跨天申请");
                    return false;
                }
            }
            return true;
        }
    });

    function NewDate(str) {
        //首先将日期分隔 ，获取到日期部分 和 时间部分
        var day = str.split(' ');
        //获取日期部分的年月日
        var days = day[0].split('-');
        //获取时间部分的 时分秒
        var mi = day[day.length - 1].split(':');
        //获取当前date类型日期
        var date = new Date();
        //给date赋值  年月日
        date.setUTCFullYear(days[0], days[1] - 1, days[2]);
        //给date赋值 时分秒  首先转换utc时区 ：+8
        date.setUTCHours(mi[0] - 8, mi[1], mi[2]);
        return date;
    }

    function checkDate(cDate, divideDay) {
        //获得当前服务器时间
        var date;
        jQuery.ajax({
            async: false,
            type: "POST", //get 方式猎豹有问题
            success: function (result, status, xhr) {
                date = new Date(xhr.getResponseHeader("Date"));
            }
        });
        //获得客户端时间
        //var date = new Date();
        //得到当前天
        var cDay = date.getDate();
        //得到开始年月日
        var sYear = date.getFullYear();
        var sMonth = date.getMonth() + 1; //月份从零开始，所以要补1
        var sDay = 16;

        //得到结束年月日
        var eYear = date.getFullYear();
        var eMonth = date.getMonth() + 1; //月份从零开始，所以要补1
        var eDay = 15;

        //计算具体的开始和结束区间
        if (cDay < divideDay) {
            //得到区间
            if (sMonth == 1) {
                sMonth = 12;
                sYear = sYear - 1;
            } else {
                sMonth = sMonth - 1;
            }
        } else {
            if (eMonth == 12) {
                eMonth = 1;
                eYear = eYear + 1
            } else {
                eMonth = eMonth + 1;
            }
        }
        var sDate = NewDate(sYear + "-" + sMonth + "-" + sDay + " 00:00:00");
        var eDate = NewDate(eYear + "-" + eMonth + "-" + eDay + " 00:00:00");
        //判断是否大于开始时间
        return cDate >= sDate;
    }

    function chechkCrossDay(sDay, eDay, eHour, eMinute) {
        if (eDay - sDay > 1) {
            return false;
        } else if ((eDay - sDay) == 1) {
            return eHour == 0 && eMinute == 0;
        }
        return true;
    }
</script>


<script type="text/javascript">
    // 日期字段
    var allFile = 'field9438';
    jQuery(document).ready(function () {
        checkCustomize = function () {
            var date;
            jQuery.ajax({
                async: false,
                type: "POST",
                success: function (result, status, xhr) {
                    date = new Date(xhr.getResponseHeader("Date"));
                }
            });
            var dateVal = formatDateTime(date);
            jQuery('#' + allFile).val(dateVal);
            return true;
        }
    });

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
        return y + '-' + m + '-' + d;
    }
</script>






