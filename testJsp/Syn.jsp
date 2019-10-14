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
<h3 style="margin-left: 23px">组织架构同步</h3>
<wea:layout type="2col">
    <wea:group context="选择同步范围">
        <wea:item>选择同步范围</wea:item>
        <wea:item>
            <select id="tongBu">
                <option value=""></option>
                <option value="1">分部</option>
                <option value="2">部门</option>
                <option value="3">职务类别</option>
                <option value="4">职务</option>
                <option value="5">岗位</option>
                <option value="6">人员</option>
                <option value="7">全部</option>
            </select>
        </wea:item>

    </wea:group>

    <!-- 查询 重置 取消 按钮 -->
    <wea:group context="">
        <wea:item type="toolbar">
            <input type="button" value="同步" class="e8_btn_submit" onclick="onBtnSearchClick();"/>
        </wea:item>
    </wea:group>

</wea:layout>
<%--<textarea style="margin-left: 200px; width: 600px; height: 50px"></textarea>--%>

<script type="text/javascript">

    function onBtnSearchClick() {
        var a = $("#tongBu").val();
        alert(a)
        if (a == 2) {
            <%
                new BaseBean().writeLog("1231223123===========");
            %>
        }
    }

</script>


</html>



