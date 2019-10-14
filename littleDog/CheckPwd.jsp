<!DOCTYPE html>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea" %>
<%@ taglib uri="/WEB-INF/tld/browser.tld" prefix="brow" %>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page"/>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<script language="javascript" type="text/javascript" src="/js/init_wev8.js"></script>

<HTML>
<body style="background-color: #f0f2f7">

<table id="tableDiv" style="margin-left: 500px; margin-top: 200px;display: inline-block">
    <tr>
        <td style="font-size: x-large;">
            请输入密码： <input id="passWord" type="password"/>
        </td>
    </tr>
</table>

<div id="changeDiv" style="display: none">
    <table style=" margin-top: 200px; margin-left: 500px">
        <tr>
            <td style="font-size: x-large;">
                请输入旧密码： &nbsp;&nbsp;&nbsp;<input id="oldPwd" type="password"/>
            </td>
        </tr>
        <tr>
            <td style="font-size: x-large;">
                请输入新密码：&nbsp;&nbsp;&nbsp; <input id="onePwd" type="password"/>
            </td>
        </tr>
        <tr>
            <td style="font-size: x-large;">
                再次输入新密码： <input id="twoPwd" type="password"/>
            </td>
        </tr>
    </table>
</div>


<table id="tabcontentframe_box" cellpadding="0" cellspacing="0" style="float:right; display: inline-block">
    <tr>
        <td>
            <input id="tj" style="display: inline-block" type="button" value="提交" class="e8_btn_top_first"
                   onclick="doSave()">
            <input id="qrxg" style="display: none" type="button" value="确认修改" class="e8_btn_top_first"
                   onclick="changePwd()">
            <span class="e8_sep_line"> | </span>
            <input id="xgmm" style="display: inline-block" type="button" value="修改密码" class="e8_btn_top_first"
                   onclick="myHide()">
            <input id="fh" style="display: none" type="button" value="返回" class="e8_btn_top_first" onclick="myShow()">
        </td>
    </tr>
</table>

<script type="text/javascript">

    function changePwd() {
        var oldpwd = $("#oldPwd").val();
        var onePwd = $("#onePwd").val();
        var twoPwd = $("#twoPwd").val();

        if (oldpwd == '' || onePwd == '' || twoPwd == '') {
            alert('请输入完整信息！');
            return;
        }
        if (oldpwd.length < 6 || onePwd.length < 6 || twoPwd.length < 6) {
            alert('密码最少为6位！')
            return;
        }

        var id = <%=user.getUID()%>
            $.get("/workflow/request/littleDog/CheckPwdBack.jsp?operation=changePwd&id=" + id + "&oldPwd=" + oldpwd + "&onePwd=" + onePwd + "&twoPwd=" + twoPwd, function (data) {
                var data = data.replace(/\s+/g, "");
                if ('oldpwdErr' == data) {
                    alert("旧密码错误！")
                    return;
                }
                if ('twicePwdErr' == data) {
                    alert("两次新密码输入不一致！");
                    return;
                }
                if ('success' == data) {
                    alert("密码修改成功！");
                    myShow();
                }
            })
    }

    function myHide() {
        document.getElementById('tableDiv').style.display = 'none';
        document.getElementById('changeDiv').style.display = 'inline-block';

        document.getElementById('xgmm').style.display = 'none';
        document.getElementById('tj').style.display = 'none';
        document.getElementById('fh').style.display = 'inline-block';
        document.getElementById('qrxg').style.display = 'inline-block';
    }

    function myShow() {
        document.getElementById('tableDiv').style.display = 'inline-block';
        document.getElementById('changeDiv').style.display = 'none';

        document.getElementById('xgmm').style.display = 'inline-block';
        document.getElementById('tj').style.display = 'inline-block';
        document.getElementById('fh').style.display = 'none';
        document.getElementById('qrxg').style.display = 'none';
    }


</script>
<script type="text/javascript">


    function doSave() {
        var pwd = $("#passWord").val();
        if (pwd == null || pwd == '') {
            alert("请输入密码")
            return;
        }
        var id = <%=user.getUID()%>
            $.get("/workflow/request/littleDog/CheckPwdBack.jsp?operation=checkPwd&id=" + id + "&pwd=" + pwd, function (data) {
                var data = data.replace(/\s+/g, "");
                if ('y' == data) {
                    window.location.href = "/hrm/resource/HrmResourceFinanceView.jsp?flag=1";
                } else {
                    alert('密码错误！')
                }
            })
    }
</script>

</body>

</html>