<%@ include file="/systeminfo/init_wev8.jsp" %>


<html>
<input id="myInput" type="text" onclick="myClear()" class="input" style="margin-left: 20px; margin-top: 10px; color: #848484"/>
<input id="myButton" type="button" onclick="openDialog()" value="流程列表" class="e8_btn_top_first" style="margin-left: 20px; margin-top: 10px"/>
</html>

<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>
<script type="text/javascript">
    jQuery(function () {
        var doInput = jQuery("#myInput");
        doInput.focus();
        doInput.blur(function () {
            doInput.val('请选中后进行扫码')
        });

        doInput.keyup(function () {
            if (event.keyCode === 13) {
                var requestId = doInput.val();
                $.post("/workflow/request/xinTai/TanChuBack.jsp", {
                    "requestId": requestId
                }, function (data) {
                    var data = data.replace(/\s+/g, "");
                    if (data != 'true') {
                        window.top.Dialog.alert(data);
                    } else {
                        doInput.val('');
                    }
                })
            }
        })

    });

    function openDialog() {
        var dlg = new window.top.Dialog();
        dlg.currentWindow = window;
        dlg.Model = false;
        dlg.Width = 1060;
        dlg.Height = 500;
        dlg.URL = '/formmode/search/CustomSearchBySimple.jsp?customid=23';
        dlg.Title = '批量提交';
        dlg.maxiumnable = true;
        dlg.show();
        window.dialog = dlg;
    }

    function myClear() {
        jQuery("#myInput").val('')
    }
</script>

