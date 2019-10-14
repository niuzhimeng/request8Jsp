<%@ page import="com.google.gson.Gson" %>
<%@ page import="com.google.gson.JsonArray" %>
<%@ page import="com.google.gson.JsonObject" %>
<%@ page import="com.google.gson.JsonParser" %>
<%@ page import="com.google.gson.reflect.TypeToken" %>
<%@ page import="com.weavernorth.B1.zyml.po.GetSingle" %>
<%@ page import="weaver.conn.RecordSet" %>
<%@ page import="weaver.integration.util.HTTPUtil" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea" %>
<%@ taglib uri="/WEB-INF/tld/browser.tld" prefix="brow" %>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page"/>
<script type="text/javascript" src="/js/select/script/jquery-1.8.3.min_wev8.js"></script>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%
    //接口访问地址
    String apiUrl = "http://222.102.23.7:7072/api/CatalogInfoSearch/getFields?catalogInfo_id=";

    String modelUrl = "/formmode/search/CustomSearchBySimple.jsp?customid=3";

    BaseBean baseBean = new BaseBean();
    String id = request.getParameter("id");
    baseBean.writeLog("获取单个资源目录字段， 请求url： " + apiUrl + id);
    try {
        String returnStr = HTTPUtil.doGet(apiUrl + id);
        //String returnStr = "{\"obj\":[{\"id\":\"312\",\"catalogrec_id\":\"40288adb5fc39b52015fc3b232f30001\",\"item_name\":\"索引号1\",\"item_nameen\":\"无\",\"data_type\":\"字符串型C\",\"table_name\":\"无\",\"share_type\":\"无条件共享\",\"create_time\":1510816757000,\"create_user\":\"root\",\"field_length\":\"128\",\"share_condition\":\"无条件\",\"share_mode\":\"共享平台方式\",\"share_mode_type\":\"文件\",\"open_condition\":\"无条件\",\"isopen_society\":\"是\",\"updatecycle\":\"其他\",\"publishdate\":\"2017年11月10日\",\"sharemode\":\"共享平台方式/文件\"},{\"id\":\"435\",\"catalogrec_id\":\"40288adb5fe1a53f015fe2e9db7c0017\",\"item_name\":\"索引号2\",\"item_nameen\":\"无\",\"data_type\":\"字符串型C\",\"table_name\":\"无\",\"share_type\":\"无条件共享\",\"create_time\":1510816757000,\"create_user\":\"root\",\"field_length\":\"128\",\"share_condition\":\"无条件\",\"share_mode\":\"共享平台方式\",\"share_mode_type\":\"文件\",\"open_condition\":\"无条件\",\"isopen_society\":\"是\",\"updatecycle\":\"其他\",\"publishdate\":\"2017年11月10日\",\"sharemode\":\"共享平台方式/文件\"}],\"ok\":true}";
        baseBean.writeLog("获取单个资源目录字段信息 返回json： " + returnStr);
        JsonObject jsonObject = new JsonParser().parse(returnStr).getAsJsonObject();
        if (jsonObject.get("ok").getAsBoolean()) {
            JsonArray jsonArray = jsonObject.get("obj").getAsJsonArray();
            List<GetSingle> getSingleList = new Gson().fromJson(jsonArray.toString(), new TypeToken<List<GetSingle>>() {
            }.getType());

            RecordSet existSet = new RecordSet();
            if (getSingleList.size() > 0) {
                existSet.execute("delete from uf_getFields where my_id = '" + id + "'");
                for (GetSingle getSingle : getSingleList) {
                    getSingle.setId(id);
                    getSingle.insert();
                }
            }
        }
        String sendUrl = modelUrl + "&my_id=" + id;
        baseBean.writeLog("转发url： " + sendUrl);
        response.sendRedirect(sendUrl);
    } catch (Exception e) {
        baseBean.writeLog("GetFields.jsp异常： " + e);
    }

%>




