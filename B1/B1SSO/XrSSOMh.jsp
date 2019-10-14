<!DOCTYPE html>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea" %>
<%@ taglib uri="/WEB-INF/tld/browser.tld" prefix="brow" %>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page"/>
<script type="text/javascript" src="/js/select/script/jquery-1.8.3.min_wev8.js"></script>
<object id="initshare" classid="CLSID:91571FEA-14D0-41B4-B4B9-7C49A9EE66F8"></object>
<script type="text/javascript">
    $(function () {
        var userInfoXml = getUserInfo();
        if (userInfoXml == "undefined" || userInfoXml == "<uri /><nam /><utp />" || userInfoXml == null || userInfoXml == "") {
            alert("获取信任系统人员信息出错： " + userInfoXml);
        }else {
            alert(userInfoXml)
            window.location.href = "/xr/sso?userInfoXml=" + userInfoXml;
        }
    });

    var appUri = "2501630004@rmyh.gov";
    function getUserInfo() {
        alert('开始获取')
        var ret = initshare.GetUserInfo(appUri);
        //var ret = "<nam>mengxh</nam><uri>123456@gd.zg</uri>";
        if (ret == "") {
            var error = initshare.ErrorCode;
            alert(error);
            return "";
        }
        alert('获取完成')
        return ret;
    }
</script>



