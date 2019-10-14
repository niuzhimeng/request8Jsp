
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<jsp:useBean id="RequestManager" class="weaver.workflow.request.RequestManager" scope="page"/>
<jsp:useBean id="flowDocss" class="weaver.workflow.request.RequestDoc" scope="session"/>
<jsp:useBean id="DocComInfo" class="weaver.docs.docs.DocComInfo" scope="page"/>
<jsp:useBean id="Doccoder" class="weaver.docs.docs.DocCoder" scope="page"/>
<%@ include file="/systeminfo/init_wev8.jsp" %>
//var check = $("#field7038").val();
<script type="text/javascript" language="JavaScript" src="/workflow/request/littleDog/ui.js"></script>
<script type="text/javascript" language="JavaScript" src="/workflow/request/testJsp/test.js"></script>

<script type="text/javascript">
    $(function () {
        checkCustomize = function () {
            var cord = $("#field6500").val();
            var reg = /^\d*$/;
            var flag = reg.test(cord)
            if (!flag) {
                alert('银行卡号位数错误~！')
            }
            return flag;
        }
    })
</script>

<script type="text/javascript">
    $(function () {
        checkCustomize = function () {
            var requestid = $("input[name='requestid']").val();
            var check = $("#field7038").val();
            var flag = true;
            var my_url = "/workflow/request/littleDog/CheckNumber.jsp";
            $.ajax({
                type: "post",
                async: false,
                url: my_url,
                data: {"check": check, "requestid": requestid},
                success: function (data) {
                    data = data.replace(/\s+/g, "");
                    if (data == 'formatErr') {
                        alert('发票格式错误');
                        flag = false;
                    } else if (data != 'y') {
                        alert(data);
                        flag = false;
                    }
                }
            });
            return flag;
        }
    });

    $(function () {
        var inputId = "field6703_";
        var button = "6703_";
        $("#\\$addbutton0\\$").click(function () {
            var sums = $("#submitdtlid0").val().split(",");
            var newLocation = sums[sums.length - 1];
            //window.top.Dialog.alert(newLocation);

            var removeInput = inputId + newLocation;
            var addButton = button + newLocation;
            $("#" + removeInput).removeAttr("style");
            $("td[_fieldid = " + addButton + "]").append("<input id=" + addButton + " type=\"button\" name=\"myCheck\" value=\"校验\" class=\"e8_btn_top_first\">")
            //绑定事件
            $("#" + addButton).click(function () {
                var id = $(this).attr("name");
                alert(id)
            })
        })
    });


</script>



