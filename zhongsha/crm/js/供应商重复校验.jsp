// 供应商CRM注册信息提交
<script type="text/javascript">
    var fzzd = 'field15303'; // 被赋值字段
    var gysmc = 'field15292'; //供应商名称
    var xydm = 'field15271'; //统一社会信用代码

    jQuery(document).ready(function () {
        $("#" + gysmc).bindPropertyChange(function () {
            checkGys();
        });
        $("#" + xydm).bindPropertyChange(function () {
            checkGys();
        });

        checkCustomize = function () {
            return checkGys();
        };
        setTimeout(function () {
            $('#' + fzzd + '_0').val(18);
            $('#' + fzzd + '_0span').html('<a title="" href="/formmode/view/AddFormMode.jsp?type=0&amp;modeId=90&amp;formId=-248&amp;billid=18" target="_blank">营业执照</a>');
            $('#' + fzzd + '_1').val(17);
            $('#' + fzzd + '_1span').html('<a title="" href="/formmode/view/AddFormMode.jsp?type=0&amp;modeId=90&amp;formId=-248&amp;billid=17" target="_blank">银行开户许可证</a>');
            $('#' + fzzd + '_2').val(3);
            $('#' + fzzd + '_2span').html('<a title="" href="/formmode/view/AddFormMode.jsp?type=0&amp;modeId=90&amp;formId=-248&amp;billid=3" target="_blank">公司实景展示-正门</a>');
        }, 1000);
        $("#field15792").attr("placeholder", "输入正确格式的邮箱！");
    });

    function checkGys() {
        var flag = false;
        $.ajax({
            type: "post",
            url: "/workflow/request/zhongsha/crm/GysRepeatCheckBack.jsp",
            cache: false,
            async: false,
            data: {
                "gysmc": $("#" + gysmc).val(),
                "xydm": $("#" + xydm).val()
            },
            dataType: 'json',
            success: function (myJson) {
                flag = myJson.state;
                if (!flag) {
                    window.top.Dialog.alert('您已保存了注册信息，信息变更请提交基本/关键信息变更流程。');
                }
            }
        });
        return flag;
    }
</script>






