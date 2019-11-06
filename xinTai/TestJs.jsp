// 新泰汽车 请假流程js
<script src="/mobile/plugin/cw.js"></script>
<script type="text/javascript">
    // 请假开始日期
    var startDate = 'field7368';
    var startTime = 'field7370';
    // 请假结束日期
    var endDate = 'field7369';
    var endTime = 'field7371';
    // 相差小时数
    var myHour = 'field7398';

    jQuery(document).ready(function () {
        $("#" + myHour).attr('readonly', 'readonly');
        _C.run2(startDate, calculateHour);
        _C.run2(startTime, calculateHour);
        _C.run2(endDate, calculateHour);
        _C.run2(endTime, calculateHour);

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
            var startDateTime = startDateVal + ' ' + startTimeVal;
            var endDateTime = endDateVal + ' ' + endTimeVal;

            if (startDateTime >= endDateTime) {
                window.top.Dialog.alert('【请假结束时间】不能早于【请假开始时间】')
                return false;
            }
            return myFlag;
        };
    });

    function calculateHour() {
        var startDateVal = jQuery("#" + startDate).val();
        var startTimeVal = jQuery("#" + startTime).val();
        var endDateVal = jQuery("#" + endDate).val();
        var endTimeVal = jQuery("#" + endTime).val();
        if (startDateVal === '' || startTimeVal === '' || endDateVal === '' || endTimeVal === '') {
            return;
        }
        var startDateTime = startDateVal + ' ' + startTimeVal;
        var endDateTime = endDateVal + ' ' + endTimeVal;

        var myStartDate = new Date(startDateTime);
        var myEndDate = new Date(endDateTime);
        var minus = myEndDate.getTime() - myStartDate.getTime();
        var hour = minus / (1000 * 60 * 60);
        let jsHour = Math.ceil(hour);
        jQuery("#" + myHour).val(jsHour);
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
