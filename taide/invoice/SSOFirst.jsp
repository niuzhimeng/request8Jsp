<%@ taglib prefix="wea" uri="http://www.weaver.com.cn" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<%@ include file="/systeminfo/init_wev8.jsp" %>

<%
    int myUserId = user.getUID();
%>
<html>
<h3 style="margin-left: 23px">票夹登录</h3>
<wea:layout type="2col">
    <wea:group context="选择所属公司">
        <wea:item>选择所属公司</wea:item>
        <wea:item>
            <select id="tongBu">
                <option value="1010">北京泰德制药股份有限公司</option>
                <option value="1020">河北鼎泰制药有限公司</option>
                <option value="1040">北京泰德美伦科技发展有限公司</option>
                <option value="1070">北京卡迪泰医疗器械科技有限公司</option>
            </select>
        </wea:item>

    </wea:group>

    <!-- 查询 重置 取消 按钮 -->
    <wea:group context="">
        <wea:item type="toolbar">
            <input id="myInput" type="button" value="确认" class="e8_btn_submit" onclick="onBtnSearchClick();"/>
        </wea:item>
    </wea:group>

</wea:layout>
<%--<textarea style="margin-left: 200px; width: 600px; height: 50px"></textarea>--%>

<script type="text/javascript">

    function onBtnSearchClick() {
        var enterpriseId = $("#tongBu").val();
        $.ajax({
            type: "post",
            url: "/workflow/request/taide/invoice/PiaoJiaSSO.jsp",
            cache: false,
            async: true,
            data: {"enterpriseId": enterpriseId, "myUserId":<%=myUserId%>},
            success: function (myData) {
                myData = myData.replace(/\s+/g, "");
                window.open(myData)
            }
        });
    }

</script>


</html>



