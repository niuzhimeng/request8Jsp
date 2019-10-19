<%@ page import="weaver.conn.RecordSet" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>

<%
    // 报价系统单点登录
    BaseBean baseBean = new BaseBean();
    RecordSet recordSet = new RecordSet();
    baseBean.writeLog("单点报价系统Start===========================");
    try {
        // 查询单点配置信息
        Map<String, String> ssoInfoMap = new HashMap<String, String>();
        recordSet.executeQuery("select * from uf_sso_info");
        while (recordSet.next()) {
            ssoInfoMap.put(recordSet.getString("ssokey").trim(), recordSet.getString("ssovalue").trim());
        }

        String bjUrl = ssoInfoMap.get("bjUrl");
        String bjKey = ssoInfoMap.get("bjKey");

        long timestamp = System.currentTimeMillis();
        int uid = user.getUID();
        // 手机号
        String mobile = "";
        recordSet.executeQuery("select mobile from hrmresource where id = " + uid);
        if (recordSet.next()) {
            mobile = recordSet.getString("mobile");
        }
        baseBean.writeLog("当前人手机号==== " + mobile);

        MD5 md5 = new MD5();
        String authid = md5.getMD5ofStr(mobile + timestamp + bjKey);

        String endUrl = bjUrl + "?usercode=" + mobile + "&timestamp=" + timestamp + "&authid=" + authid;
        baseBean.writeLog("报价系统跳转地址： " + endUrl);

        response.sendRedirect(endUrl);
    } catch (Exception e) {
        baseBean.writeLog("单点报价系统异常： " + e);
    }

%>
