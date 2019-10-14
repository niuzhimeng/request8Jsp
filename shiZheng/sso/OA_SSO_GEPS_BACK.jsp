<%@ page import="weaver.conn.RecordSet" %>
<%@ page import="weaver.general.BaseBean" %>
<%@ page import="weaver.general.TimeUtil" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%
    // 单点回调接口
    BaseBean baseBean = new BaseBean();
    baseBean.writeLog("OA_SSO_GEPS_BACK.jsp 回调接口执行--------------> " + TimeUtil.getCurrentTimeString());
    String ticket = request.getParameter("ticket");
    baseBean.writeLog("收到的ticket: " + ticket);

    RecordSet recordSet = new RecordSet();
    recordSet.execute("select userid from uf_sso_geps where ticket = '" + ticket + "'");

    // OA系统登录名
    String userId = "";
    // OA系统登录名
    String loginId = "";
    // 用户姓名
    String lastName = "";
    // 身份证号码
    String certificatenum = "";
    if (recordSet.next()) {
        userId = recordSet.getString("userid");
        RecordSet hrmSet = new RecordSet();
        hrmSet.executeQuery("select * from hrmresource where id = " + userId);
        if (hrmSet.next()) {
            loginId = hrmSet.getString("loginid");
            lastName = hrmSet.getString("lastname");
            certificatenum = hrmSet.getString("certificatenum");
        }
    }
    baseBean.writeLog("登录名--->> " + loginId + " 姓名--->> " + lastName + " 身份证号码--->> " + certificatenum);
    response.setContentType("text/xml;charset=UTF-8");
    String xml = "<?xml version=\"1.0\" encoding=\"utf-8\"?>\n" +
            "<cas:serviceResponse\n" +
            "xmlns:cas=\"http://www.yale.edu/tp/cas\">\n" +
            "<cas:authenticationSuccess>\n" +
            "<cas:GtpUserID>" + userId + "</cas:GtpUserID>\n" +
            "<cas:user>" + loginId + "</cas:user>\n" +
            "<cas:GtpUserName>" + lastName + "</cas:GtpUserName>\n" +
            "<cas:GtpUserLangID>" + certificatenum + "</cas:GtpUserLangID>\n" +
            "<cas:GtpTokenString>" + ticket + "</cas:GtpTokenString>\n" +
            "<cas:GtpDataSourceType>GTP</cas:GtpDataSourceType>\n" +
            "<cas:GtpTimeoutMiniutes>120</cas:GtpTimeoutMiniutes>\n" +
            "<cas:IsActived>False</cas:IsActived>\n" +
            "<cas:ClientTag>WEB</cas:ClientTag>\n" +
            "<cas:GtpSecurityArea/>\n" +
            "</cas:authenticationSuccess>\n" +
            "</cas:serviceResponse>";

    out.clear();
    out.print(xml);
%>