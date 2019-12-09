
// JT_入职流程
<script type="text/javascript">
    // 试用期是否打折
    var sfdz = 'field102174';
    // 基本工资
    var jbgz = 'field102626';
    // 社保基数
    var sbjs = 'field102291';

    jQuery(document).ready(function () {
        $("#" + sbjs).attr('readonly', 'readonly');

        $("#" + sfdz).bindPropertyChange(function () {
            myExe();
        });

        $("#" + jbgz).blur(function () {
            myExe();
        })
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


// JT_实习生转正式员工流程
<script type="text/javascript">
    // 试用期是否打折
    var sfdz = 'field102204';
    // 基本工资
    var jbgz = 'field102627';
    // 社保基数
    var sbjs = 'field102194';

    jQuery(document).ready(function () {
        $("#" + sbjs).attr('readonly', 'readonly');

        $("#" + sfdz).bindPropertyChange(function () {
            myExe();
        });

        $("#" + jbgz).blur(function () {
            myExe();
        })
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