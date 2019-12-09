// JT_个人调薪流程
<script type="text/javascript">
    let tzhzj = 'field102440'; // 调整后职级
    let tzhjbgz = 'field102443'; // 调整后基本工资

    jQuery(document).ready(function () {
        $("#" + tzhzj).bindPropertyChange(function () {
            xinZiCheck();
        });

        $("#" + tzhjbgz).blur(function () {
            xinZiCheck();
        });
    });

    function xinZiCheck() {
        var tzhzjVal = $("#" + tzhzj).val();//借款金额
        var tzhjbgzVal = $("#" + tzhjbgz).val();//本次报销金额
        if (tzhzjVal !== '' && tzhjbgzVal !== '') {
            $.ajax({
                type: "post",
                url: "/workflow/request/jiajiezb/TiaoXinCheckBack.jsp",
                cache: false,
                async: false,
                data: {"tzhzjVal": tzhzjVal, "tzhjbgzVal": tzhjbgzVal},
                success: function (myData) {
                    let myJson = jQuery.parseJSON(myData);
                    if (!myJson.myState) {
                        window.top.Dialog.alert(myJson.msg);
                    }
                }
            });
        }

    }
</script>