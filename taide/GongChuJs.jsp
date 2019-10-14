<script type="text/javascript">
    jQuery(document).ready(function () {
        doSave_nNew = function () {
            alert("无法保存，请直接提交！！！");
            return false;
        };

        checkCustomize = function () {
            //以下是都有的
            var type = jQuery('#field19919').val(); //类型
            var sDate = jQuery('#field19226').val(); //开始日期
            var eDate = jQuery('#field19227').val(); //结束日期
            var sHour = jQuery('#field19229').val(); //开始小时
            var eHour = jQuery('#field19230').val(); //结束小时
            var sMinute = jQuery('#field19231').val(); //开始分钟
            var eMinute = jQuery('#field19232').val(); //结束分钟
            //以上是都有的
            var date;
            jQuery.ajax({
                async: false,
                type: "POST", //get 方式猎豹有问题
                success: function (result, status, xhr) {
                    date = new Date(xhr.getResponseHeader("Date"));
                }
            });
            if (sHour.length = 1) {
                sHour = '0' + sHour;
            }
            if (eHour.length = 1) {
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
            // if (!(flag1 && flag2)) {
            //     alert("开始日期超过考勤周期");
            //     return false;
            // }
            //这里是拼装开始和结束日期
            //时长不能为负数
            if (hour <= 0) {
                alert("公出时长应大于0");
                return false;
            }
            //这里是公出的特殊限制
            return true;
        }

        //检查申请时间是否合法
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

            if (cDate >= sDate) {
                return true;
            } else {
                return false;
            }
        }

        function chechkCrossDay(sDay, eDay, eHour, eMinute) {
            if (eDay - sDay > 1) {
                return false;
            } else if ((eDay - sDay) == 1) {
                if (eHour == 0 && eMinute == 0) {
                    return true;
                } else {
                    return false;
                }
            }
            return true;
        }

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
    });

</script>
