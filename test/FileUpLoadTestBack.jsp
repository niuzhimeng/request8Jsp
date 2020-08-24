<%@ page import="org.springframework.web.multipart.MultipartFile" %>
<%@ page import="org.springframework.web.multipart.MultipartHttpServletRequest" %>
<%@ page import="weaver.general.BaseBean" %>
<%@ page import="weaver.general.TimeUtil" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<script type="text/javascript" src="/weavernorth/prop/Prop2Js.js"></script>
<script type="text/javascript">
    //1、在 “授权委托申请流程”归档前一节点，增加链接“流程代理”。
    //2、打开该链接后自动将流程中“被代理人”、“代理人”、“开始日期, 时间”、“结束日期, 时间”字段带入代理设置页面中
    //链接字段1
    var ljzd = "";
    //被代理人
    var bdlr = "";
    //代理人
    var dlr = "";
    //开始日期
    var ksrq = "";
    //结束日期
    var jsrq = "";
    //页面加载事件
    $(function () {
        var prop = new Prop();
        ljzd = prop.getVal("wf_request", "ljzd");
        bdlr = prop.getVal("wf_request", "bdlr");
        dlr = prop.getVal("wf_request", "dlr");
        ksrq = prop.getVal("wf_request", "ksrq");
        jsrq = prop.getVal("wf_request", "jsrq");
        //文字信息
        var wz = "流程代理";
        //被代理人
        var bdlr_value = $("#field6928").val();
        alert('被代理人: '+ bdlr_value)
        //代理人
        var dlr_value = $("#field12059").val();
        dlr_value = dlr_value.split(',')[0];
        alert('代理人: '+ dlr_value)
        //开始日期
        var ksrq_value = $("#" + ksrq).val();
        //结束日期
        var jsrq_value = $("#" + jsrq).val();
        //赋值链接
        $("#" + ljzd + "span").html("<a href='/workflow/request/wfAgentAdd.jsp?isdialog=1&f_weaver_belongto_userid=" + bdlr_value + "&agenterId=" + dlr_value + "&beginDate=" + ksrq_value + "&beginTime=00:00&endDate=" + jsrq_value + "&endTime=23:59&FromWf=1' target='_blank'>" + wz + "</a>");
    });
</script>

<%
    BaseBean baseBean = new BaseBean();
    baseBean.writeLog("上传文件开始： " + TimeUtil.getCurrentTimeString());

    MultipartHttpServletRequest multipartHttpservletRequest = (MultipartHttpServletRequest) request;
    MultipartFile multipartFile = multipartHttpservletRequest.getFile("uploadFile");
    //获取上传文件名称
    String fileName = multipartFile.getOriginalFilename();
    baseBean.writeLog("fileName: "+ fileName);


%>





















