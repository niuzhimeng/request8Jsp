<%--31-费用报支-汇公司（分摊-新）--%>
<script src="/workflow/request/testJsp/cw.js"></script>
<script src="/workflow/request/testJsp/shauter_wev8.js"></script>
<script type="text/javascript">
    $(function () {
        appendFpButton();
        checkCustomize = function (){
            var a1 = Number(jQuery("#field19352").val());   //付款金额
            var a3=  Number(jQuery("#field19379").val());   //票面金额
            if(a1!=a3){
                alert("付款金额必须等于票面金额！");
                return false;
            }else{
                return true;
            }
        };
    });

    function appendFpButton() {
        jQuery("#getFpInfo").append("<input id=\"jiaoYan\" type=\"button\" value=\"获取发票\" onclick=\"newButton();\" class=\"e8_btn_top_first\">");
    }

    function newButton() {
        let queryBut = jQuery("#jiaoYan");
        queryBut.attr("disabled", true);
        queryBut.val('请勿重复点击');
        $.ajax({
            type: "post",
            url: "/workflow/request/taide/invoice/GetInvoiceByGh.jsp",
            cache: false,
            async: false,
            data: {"userId": ""},
            success: function (myData) {
                window.top.Dialog.alert('获取发票信息成功。');
            }
        });
        setTimeout('buttonTrue()', 10000);
    }

    function buttonTrue() {
        let queryBut = jQuery("#jiaoYan");
        queryBut.attr("disabled", false);
        queryBut.val('获取发票');
    }
</script>

