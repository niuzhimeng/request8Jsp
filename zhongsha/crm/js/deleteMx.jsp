// 删除明细表
<script type="text/javascript">
    var gysmc = 'field15770'; //供应商名称

    jQuery(document).ready(function () {
        $("#" + gysmc).bindPropertyChange(function () {
            $("input[name='check_node_1']").each(function () {
                $(this).attr("checked", true);
            });
            deleteRow1(1, true);
        })
    });
</script>






