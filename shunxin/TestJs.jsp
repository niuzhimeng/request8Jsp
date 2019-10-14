<%@ page language="java" contentType="text/html; charset=UTF-8" %>


<script type="text/javascript">
    $(function () {
        window.parent.location.href = '/workflow/request/shunxin/TestBack.jsp';
    })
</script>

// 根据主表字段，调整明细行
<script type="text/javascript">
    var chuFa = 'field6667';
    $(function () {
        $('#' + chuFa).blur(function () {
            // 标准值
            var bzVal = parseFloat($('#' + chuFa).val());
            // 明细表行数
            var nums;
            var submitVal = $("#submitdtlid0").val();

            if (submitVal == '' || submitVal == undefined || submitVal == null) {
                nums = 0;
            } else {
                nums = parseFloat(submitVal.split(',').length);
            }

            if (bzVal < 0 || bzVal > 10) {
                window.top.Dialog.alert('行数不能小于0，或大于10');
                return;
            }
            var chaVal = Math.abs(bzVal - nums);
            if (nums > bzVal) {
                // 删除
                var delIndex = [];
                var aa = nums - chaVal;
                var mySub = submitVal.split(',');
                for (var i = aa; i < nums; i++) {
                    delIndex.push(mySub[i]);
                }
                $("input[name='check_node_0']").each(function () {
                    if (delIndex.contains($(this).val())) {
                        $(this).attr("checked", true);
                    }
                });
                deleteRow0(0, true);

            } else if (nums < bzVal) {
                // 增加
                for (var j = 0; j < chaVal; j++) {
                    try {
                        addRow0(0)
                    } catch (e) {
                        alert('增加明细行异常： ' + e)
                    }

                }
            }
        });
    })
</script>


<script type="text/javascript">
    $(function () {
        var name = '<span class="e8_showNameClass"><a href="javaScript:openhrm(150);" onclick="pointerXY(event);">李妍</a>&nbsp;<span class="e8_delClass" id="150" onclick="del(event,this,1,false,{});" style="opacity: 1; visibility: hidden;">&nbsp;x&nbsp;</span></span>';
        __browserNamespace__._writeBackData('field6659', 1, {id: '150', name: name})
    })
</script>




<script type="text/javascript">
    $(function () {
        $('#field6655').bindPropertyChange(function () {
            alert( $('#field6655').val())
        })
    })
</script>








