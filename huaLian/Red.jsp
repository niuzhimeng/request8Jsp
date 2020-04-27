<script type="text/javascript">
    var gysmc = 'myPoint';
    var mxbNum1 = 'submitdtlid0'; // 明细表1
    var mxid = 'field6670';
    var jtgj = 'field7066'; // 交通工具
    jQuery(document).ready(function () {
        var currentRows = $("#" + mxbNum1).val().split(",");
        var szlen = currentRows.length;
        for (var i = 0; i < szlen; i++) {
            var val = $("#" + jtgj + '_' + currentRows[i]).val();
            if (val === '0') {
                $("#" + mxid + '_' + currentRows[i] + 'span').append("<div class='myPointRed'/>");
            } else if (val === '1') {
                $("#" + mxid + '_' + currentRows[i] + 'span').append("<div class='myPointGreen'/>");
            } else if (val === '2') {
                $("#" + mxid + '_' + currentRows[i] + 'span').append("<div class='myPointYellow'/>");
            }
        }

    });
</script>
<style>
    .myPointRed {
        width: 15px;
        height: 15px;
        border-radius: 100%;
        background-color: red;
        margin-left: 10px;
    }

    .myPointGreen {
        width: 15px;
        height: 15px;
        border-radius: 50%;
        background-color: green;
        margin-left: 10px;
    }

    .myPointYellow {
        width: 15px;
        height: 15px;
        border-radius: 50%;
        background-color: yellow;
        margin-left: 10px;
    }
</style>
