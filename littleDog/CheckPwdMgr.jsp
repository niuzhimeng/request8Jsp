<!DOCTYPE html>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea" %>
<%@ taglib uri="/WEB-INF/tld/browser.tld" prefix="brow" %>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page"/>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<script language="javascript" type="text/javascript" src="/js/init_wev8.js"></script>

<HTML>
<body style="background-color: #f0f2f7">

<div id="changeDiv" style="display: inline-block">
    <table style=" margin-top: 200px; margin-left: 450px">
        <tr>
            <td style="font-size: x-large;">
                请输入员工登录名： &nbsp;&nbsp;&nbsp;<input id="loginId"/>
            </td>
        </tr>
    </table>
</div>


<table id="tabcontentframe_box" cellpadding="0" cellspacing="0" style="float:right; display: inline-block">
    <tr>
        <td>
            <input id="jy" style="display: inline-block" type="button" value="校验" class="e8_btn_top_first"
                   onclick="checkStaff()">
            <span class="e8_sep_line"> | </span>
            <input readonly="readonly" id="czmm" style="display: inline-block;" type="button" value="重置密码" class="e8_btn_top_first"
                   onclick="resetPwd()">
            <input id="fh" style="display: none" type="button" value="返回" class="e8_btn_top_first"
                   onclick="back()">
        </td>
    </tr>
</table>

<script type="text/javascript">

    var checkFlag = 0;
    //校验员工登录名
    function checkStaff() {
        var loginId = $("#loginId").val();
        if (loginId === '') {
            alert('请输入员工登录名！');
            return;
        }

        $.get("/workflow/request/littleDog/CheckPwdMgrBack.jsp?operationType=checkStaff&loginId=" + loginId, function (data) {
            var data = data.replace(/\s+/g, "");
            if ('n' === data) {
                alert("登录名不存在！");
                return;
            }
            document.getElementById('jy').style.display = 'none';
            document.getElementById('fh').style.display = 'inline-block';
            alert(data);
            checkFlag = 1;
            document.getElementById("loginId").readOnly=true;
        })
    }

    function back(){
        myClear();
        checkFlag = 0;
        document.getElementById('jy').style.display = 'inline-block';
        document.getElementById('fh').style.display = 'none';
        document.getElementById("loginId").readOnly=false;
    }

    function myClear() {
        $("#loginId").val('');
    }

    function resetPwd() {
        if(checkFlag === 0){
            alert('请先校验~')
            return;
        }
        var loginId = $("#loginId").val();
        $.get("/workflow/request/littleDog/CheckPwdMgrBack.jsp?loginId=" + loginId, function (data) {
            var data = data.replace(/\s+/g, "");
            if ('success' === data) {
                alert("密码重置成功！");
                myClear();
                checkFlag = 0;
                document.getElementById('jy').style.display = 'inline-block';
                document.getElementById('fh').style.display = 'none';
                document.getElementById("loginId").readOnly=false;
            }
        })
    }
</script>

</body>

</html>