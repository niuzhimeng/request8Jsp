<%@ taglib prefix="wea" uri="http://www.weaver.com.cn" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<jsp:useBean id="RequestManager" class="weaver.workflow.request.RequestManager" scope="page"/>
<jsp:useBean id="flowDocss" class="weaver.workflow.request.RequestDoc" scope="session"/>
<jsp:useBean id="DocComInfo" class="weaver.docs.docs.DocComInfo" scope="page"/>
<jsp:useBean id="Doccoder" class="weaver.docs.docs.DocCoder" scope="page"/>
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
                <option value="1">考勤明细</option>
                <option value="2">考勤异常</option>
                <option value="3">排班数据</option>
                <option value="4">剩余假期</option>
                <option value="5">刷卡数据</option>
                <option value="6">物料数据</option>
                <option value="7">供应商数据</option>
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
            url: "/workflow/request/taide/timed/AllChuFa.jsp",
            cache: false,
            async: true,
            timeout: 1000,
            data: {"myType": myType},
            success: function (data) {
                var data = data.replace(/\s+/g, "");
                window.top.Dialog.alert(data);
            },
            complete: function (XMLHttpRequest, status) {
                window.top.Dialog.alert("后台同步中。。。");
            }
        });
    }

</script>


</html>



