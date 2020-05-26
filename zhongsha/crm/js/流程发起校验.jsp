// 流程不允许重复发起
<script type="text/javascript">
    jQuery(document).ready(function () {
        doSave_nNew = function () {
            window.top.Dialog.alert("无法保存，请直接提交。");
            return false;
        };
        checkRepeat();
        checkCustomize = function () {
            return checkRepeat();
        };

    });

    function checkRepeat() {
        var workflowid = $("input[name='workflowid']").val();
        var requestid = $("input[name='requestid']").val();
        var flag = false;
        $.ajax({
            type: "post",
            url: "/workflow/request/zhongsha/crm/WorkCreateRepeatCheckBack.jsp",
            cache: false,
            async: false,
            data: {
                "workflowid": workflowid,
                "requestid": requestid
            },
            dataType: 'json',
            success: function (myJson) {
                flag = myJson.state;
                if (!flag) {
                    window.top.Dialog.alert('本类流程已发起，请在“待办事宜”中处理，勿重复新建流程。');
                }
            }
        });
        return flag;
    }
</script>






