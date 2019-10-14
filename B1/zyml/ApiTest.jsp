<%@ page import="weaver.integration.util.HTTPUtil" %>
<%@ page import="com.weavernorth.B1.zyml.TimedGetAllCatalogList" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea" %>
<%@ taglib uri="/WEB-INF/tld/browser.tld" prefix="brow" %>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page"/>
<script type="text/javascript" src="/js/select/script/jquery-1.8.3.min_wev8.js"></script>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%
    //获取所有的访问地址
    String allUrl = "http://222.102.23.7:7072/api/CatalogInfoSearch/getAllCatalogList";
    //获取单个的访问地址
    String singleUrl = "http://222.102.23.7:7072/api/CatalogInfoSearch/getFields?catalogInfo_id=";
    BaseBean baseBean = new BaseBean();
    String id = request.getParameter("id");

    String catalogInfo_id = request.getParameter("catalogInfo_id");

    try {
        if ("1".equals(id)) {
            String s = HTTPUtil.doGet(allUrl);
            baseBean.writeLog("获取所有接口返回" + s);
        } else if ("2".equals(id)) {
            String s = HTTPUtil.doGet(singleUrl + catalogInfo_id);
            baseBean.writeLog("获取单个资源目录字段: " + s);
        } else if ("3".equals(id)) {
            TimedGetAllCatalogList getAllCatalogList = new TimedGetAllCatalogList();
            getAllCatalogList.execute();
        }

    } catch (Exception e) {
        baseBean.writeLog("ApiTest.jsp异常： " + e);
    }

%>




