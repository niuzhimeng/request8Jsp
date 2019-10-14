<%@ page import="com.alibaba.fastjson.JSON" %>
<%@ page import="com.alibaba.fastjson.JSONObject" %>
<%@ page import="weaver.conn.RecordSet" %>
<%@ page import="weaver.conn.BatchRecordSet" %>
<%@ page import="java.util.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<jsp:useBean id="RequestManager" class="weaver.workflow.request.RequestManager" scope="page"/>
<jsp:useBean id="flowDocss" class="weaver.workflow.request.RequestDoc" scope="session"/>
<jsp:useBean id="DocComInfo" class="weaver.docs.docs.DocComInfo" scope="page"/>
<jsp:useBean id="Doccoder" class="weaver.docs.docs.DocCoder" scope="page"/>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<script type="text/javascript" language="javascript" src="/FCKEditor/FCKEditorExt_wev8.js"></script>
<%--<script type="text/javascript" language="JavaScript" src="/workflow/request/testJsp/test.js"></script>--%>
<html>


<script type="text/javascript">
    $(function () {
        var bt = $("#requestname").val();
        $("#requestname").css('color', 'red')
        $("#requestname").val(bt + '自己代码加的');
    });
</script>


<script src="/workflow/request/testJsp/shauter_wev8.js"></script>
<script src="/workflow/request/testJsp/cw.js"></script>
<script type="text/javascript">
    jQuery(document).ready(function () {
        var liuLanId = 'field10870';
        var controled = '10871';
        _C.run2(liuLanId, function (p) {
            if (p.v.o == undefined) {
                return;
            }
            var nowLine = p.r.substring(1);
            var a = jQuery('#' + liuLanId + p.r).val();
            if (a == 'C006' || a == 'V000') {
                changeFieldShowattr(controled, "2", "1", nowLine);//1、编辑 2、必填 3、只读; 0主表 1明细表
            } else {
                changeFieldShowattr(controled, "1", "1", nowLine);//编辑
            }
        });
    })
</script>


<script type="text/javascript">
    jQuery(document).ready(function () {
        var ary = ["111", "22", "33", "111"];
        var s = ary.join(",") + ",";
        for (var i = 0; i < ary.length; i++) {
            if (s.replace(ary[i] + ",", "").indexOf(ary[i] + ",") > -1) {
                alert("数组中有重复元素：" + ary[i]);
                break;
            }
        }
    });
</script>
<script type="text/javascript">
    $(function () {
        alert("1");
        var userid = wf__info.f_bel_userid;
        alert(userid)
    });

    // $(function () {
    //     $("#field6446").bindPropertyChange(function () {
    //         alert( $("#field6446 option:selected").text())
    //     })
    // })field6387


    $("#\\$addbutton0\\$").click(function () {
        var str = $("#submitdtlid0").val();
        var nums = str.split(",");
        var len = nums.length - 1;

        $("#field6389_" + nums[len]).bindPropertyChange(function () {
            alert('绑定')
        })
    });

    $(function () {
        try {
            addRow0(0);
        } catch (e) {
        }
        $("#field6671_0").bindPropertyChange(function () {
            var i = $("#field6671_0").val();
            alert(i);
            $("#field6670").val(i)
        })
    });

    $(function () {
        fuZhi()
    });

    function fuZhi() {
        $.get("/workflow/request/testJsp/TestBack.jsp", function (data) {
            $("#myInput").val(data.replace(/\s+/g, ""));
        });
        setTimeout(fuZhi, 5000);
    }
</script>
<body background="/workflow/request/littleDog/back.jpg" style="margin: 2%; padding: 2%; overflow: hidden">
<div style="width: 25%; height: 80%;  float: left; box-shadow: #f0f2f7;" id="left">
    <input id="myInput" value="默认值">
</div>
<div style="border:solid;border-color: #f1f1f1; border-width:1px;margin-left: 20px;width: 95%; height: 80%;" id="right">

</div>
</body>


<script type="text/javascript">
    jQuery(document).ready(function () {
        zhuiJia();
    });

    function zhuiJia() {
        jQuery("#ssoid").append("<input id=\"jiaoYan\" type=\"button\" value=\"跳转携程\" onclick=\"newButton();\" class=\"e8_btn_top_first\">");
    }

    function newButton() {
        var sqrgh = $("#field7560").val();
        var sqdh = $("#field7557").val();
        window.open("/com/weavernorth/mlc/mobilelogin.jsp?sqrgh=" + sqrgh + "&sqdh=" + sqdh);
    }
</script>

<script type="text/javascript">
    jQuery(document).ready(function () {
        var startTime = 'field6748'; // 开始日期
        var endTime = 'field6749'; // 结束日期
        var zzType = 'field6929'; // 证照类别

        checkCustomize = function () {
            var flag = true;
            var startTimeValue = $("#" + startTime).val();
            var endTimeValue = $("#" + endTime).val();
            var zzTypeValue = $("#" + zzType).val();

            // 只校验原件
            if (parseFloat(zzTypeValue) == 0) {
                if (endTimeValue < startTimeValue) {
                    window.top.Dialog.alert('结束时间不能早于开始时间');
                    flag = false;
                } else {
                    flag = true;
                }
            }
            return flag;
        };
    })
</script>









