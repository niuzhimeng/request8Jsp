<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib prefix="wea" uri="http://www.weaver.com.cn" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%
    String myIds = request.getParameter("ids");
%>
<wea:layout type="2col">
    <wea:group context="批量推送">
        <wea:item>请选择</wea:item>
        <wea:item>
            <select id="tongBu">
                <option value="0">合并推送</option>
                <option value="1">正常推送</option>
            </select>
        </wea:item>
        <wea:item>合计金额</wea:item>
        <wea:item>
            <input readonly id="myMoney"/>
        </wea:item>
        <wea:item>另一个合计</wea:item>
        <wea:item>
            <input readonly id="myVersion"/>
        </wea:item>

    </wea:group>

    <!-- 查询 重置 取消 按钮 -->
    <wea:group context="">
        <wea:item type="toolbar">
            <br />
            <input onclick="mySubmit()" class="e8_btn_submit" type="button" id="submit" value="确认"/>
            <input onclick="myCancel()" class="e8_btn_submit" type="button" id="cancle" value="取消"/>
        </wea:item>
    </wea:group>

</wea:layout>

<script type="text/javascript">
    $(function () {
        var ids = sessionStorage.getItem('ids');
        // 调用后台， 计算总金额
        $("#myMoney").val(ids);
        $("#myVersion").val(2);
    });
    function mySubmit() {

        alert('推送方式：' + $('#tongBu').val())
    }

    function myCancel() {
        var dialog = parent.getDialog(window);
        dialog.cancelButton.onclick.apply(dialog.cancelButton,[]);
    }


</script>

