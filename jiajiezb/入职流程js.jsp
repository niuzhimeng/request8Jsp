// 佳杰总部- 正式环境 入职流程第一节点
<script type="text/javascript">
    let sfdz = 'field112654';  // 试用期是否打折
    let jbgz = 'field112663'; // 基本工资
    let sbjs = 'field112623';  // 社保基数

    let htqyks = 'field112638'; // 合同签约开始日期
    let htqyjs = 'field112639'; // 合同签约结束日期

    let rzrq = 'field112640'; // 入职日期
    let syqjsrq = 'field112641';  // 试用期结束日期

    jQuery(document).ready(function () {
        $("#" + sbjs).attr('readonly', 'readonly');
        $("#" + sfdz).bindPropertyChange(function () {
            myExe();
        });
        $("#" + jbgz).blur(function () {
            myExe();
        });

        checkCustomize = function () {
            let htqyksVal = jQuery("#" + htqyks).val();
            let htqyjsVal = jQuery("#" + htqyjs).val();
            let rzrqVal = jQuery("#" + rzrq).val();
            let syqjsrqVal = jQuery("#" + syqjsrq).val();

            if (htqyksVal >= htqyjsVal) {
                window.top.Dialog.alert('【合同签约开始日期】不能晚于 【合同签约结束日期】');
                return false;
            }
            if (rzrqVal > syqjsrqVal) {
                window.top.Dialog.alert('【入职日期】不能晚于 【试用期结束日期】');
                return false;
            }
            return true;
        };
    });

    function myExe() {
        let jbgzVal = $("#" + jbgz).val(); // 基本工资
        let sfdzVal = $("#" + sfdz).val();
        if ("0" === sfdzVal) {
            jbgzVal = jbgzVal * 0.8;
        }
        $("#" + sbjs).val(Math.round(jbgzVal));
    }
</script>
