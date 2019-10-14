<!DOCTYPE html>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page"/>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%
    long lastAccessedTime = request.getSession().getLastAccessedTime() / 1000;
    long creationTime = request.getSession().getCreationTime() / 1000;

    long l = System.currentTimeMillis() / 1000;
    String myTime = request.getParameter("myTime");
    out.clear();
    out.print("lastAccessedTime " + lastAccessedTime + ", ");
    out.print("creationTime " + creationTime + ", ");
    out.print("1 " + l + ", ");
    out.print("myTime " + myTime + ", ");

%>

<%-- 差旅报销 北京1000 上海2900 广州5810 深圳5840 --%>
<script src="/workflow/request/testJsp/cw.js"></script>
<script type="text/javascript">
    var yglx = 'field9474';//用工类型
    var yjbm = 'field9475';//所属一级部门
    var oneCity = ['1000', '2900', '5810', '5840'];
    jQuery(document).ready(function () {
        var a = getDays("2012-12-01", "2012-12-02");
        alert('相差日期： ' + a);
        var index = $.inArray('580', oneCity);// -1表示不存在
        if (parseFloat(index) >= 0) {
            // 一线城市

        } else {
            // 其他城市

        }

        // checkCustomize = function () {
        //
        // };
    });

    function getDays(strDateStart, strDateEnd) {
        var strSeparator = "-"; //日期分隔符
        var oDate1 = strDateStart.split(strSeparator);
        var oDate2 = strDateEnd.split(strSeparator);
        var strDateS = new Date(oDate1[0], oDate1[1] - 1, oDate1[2]);
        var strDateE = new Date(oDate2[0], oDate2[1] - 1, oDate2[2]);
        //把相差的毫秒数转换为天数
        return parseInt(Math.abs(strDateS - strDateE) / 1000 / 60 / 60 / 24);
    }
</script>


<!-- 日常交通报销 -->
<script type="text/javascript">
    var jtlx = 'field7807'; // 交通类型
    var yjbm = ''; //
    jQuery(document).ready(function () {
        checkCustomize = function () {
            var flag = false;
            var nums = $("#submitdtlid0").val().split(',');
            var allStr = '';
            for (var i = 0; i < nums.length; i++) {
                var jtlxVal = $("#" + jtlx + '_' + nums[i]).val().trim();// 交通类型
                if (jtlxVal == '487') {
                    // 加班出行

                } else if (jtlxVal == '488') {
                    // 商务出行

                }


                var jtgj = $("#" + chaiLv_jtgjzdid + '_' + nums[i]).val().trim();//
                if (csjb != '' && jtgj != '') {
                    allStr += csjb + ',' + jtgj + '#'
                }
            }
            var xqrsVal = jQuery("#" + jtlx).val();
            var yjbmVal = jQuery("#" + yjbm).val();
            if (parseFloat(xqrsVal) <= 0) {
                window.top.Dialog.alert('需求人数不能小于或等于0。');
                return false;
            }

            $.ajax({
                type: "post",
                url: "/workflow/request/huaLian/CheckBack.jsp",
                cache: false,
                async: false,
                data: {"xqrsVal": xqrsVal, "yjbmVal": yjbmVal},
                success: function (data) {
                    var data = data.replace(/\s+/g, "");
                    if ('true' == data) {
                        flag = true;
                    } else {
                        window.top.Dialog.alert(data);
                    }
                }
            });
            return flag;
        };
    })
</script>