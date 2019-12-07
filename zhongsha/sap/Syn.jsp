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
<h3 style="margin-left: 23px">手动触发定时任务</h3>
<wea:layout type="2col">
    <wea:group context="选择同步范围">
        <wea:item>请选择</wea:item>
        <wea:item>
            <select id="tongBu">
                <option value="0">获取工单台账</option>

            </select>
        </wea:item>

    </wea:group>

    <!-- 查询 重置 取消 按钮 -->
    <wea:group context="">
        <wea:item type="toolbar">
            <input id="myInput" type="button" value="执行" class="e8_btn_submit" onclick="onBtnSearchClick();"/>
        </wea:item>
    </wea:group>

</wea:layout>
<%--<textarea style="margin-left: 200px; width: 600px; height: 50px"></textarea>--%>

<script type="text/javascript">

    function onBtnSearchClick() {
        var myType = $("#tongBu").val();
        $.ajax({
            type: "post",
            url: "/workflow/request/zhongsha/sap/AllChuFa.jsp",
            cache: false,
            async: true,
            timeout: 1000,
            data: {"myType": myType},
            complete: function (XMLHttpRequest, status) {
                window.top.Dialog.alert("后台执行中...");
            }
        });
    }

</script>


</html>



