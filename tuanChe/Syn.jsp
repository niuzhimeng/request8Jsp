<%@ taglib prefix="wea" uri="http://www.weaver.com.cn" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<%@ include file="/systeminfo/init_wev8.jsp" %>
<script type="text/javascript" language="javascript" src="/FCKEditor/FCKEditorExt_wev8.js"></script>
<html>
<script src="/workflow/request/testJsp/shauter_wev8.js"></script>
<h3 style="margin-left: 23px">定时任务同步</h3>
<wea:layout type="2col">
    <wea:group context="选择同步范围">
        <wea:item>选择同步范围</wea:item>
        <wea:item>
            <select id="tongBu">
                <option value=""></option>
                <option value="1">部门</option>
                <option value="2">岗位</option>
                <option value="3">人员</option>
            </select>
        </wea:item>

    </wea:group>

    <!-- 查询 重置 取消 按钮 -->
    <wea:group context="">
        <wea:item type="toolbar">
            <input id="myInput" type="button" value="同步" class="e8_btn_submit" onclick="onBtnSearchClick();"/>
        </wea:item>
    </wea:group>

</wea:layout>
<%--<textarea style="margin-left: 200px; width: 600px; height: 50px"></textarea>--%>

<script type="text/javascript">

    function onBtnSearchClick() {
        var myType = $("#tongBu").val();
        $.ajax({
            type: "post",
            url: "/workflow/request/tuanChe/AllChuFa.jsp",
            cache: false,
            async: true,
            timeout: 1000,
            data: {"myType": myType},
            success: function (data) {
                var data = data.replace(/\s+/g, "");
                window.top.Dialog.alert(data);
            },
            complete: function (XMLHttpRequest, status) {
                window.top.Dialog.alert("后台同步中。");
            }
        });
    }

</script>


</html>



