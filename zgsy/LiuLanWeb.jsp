<%@ page import="com.weavernorth.zgsy.webUtil.util.BaseDataUtil" %>
<%@ page import="weaver.general.BaseBean" %>
<%@ page import="java.util.Properties" %>
<%@ page import="java.io.InputStream" %>
<%@ page import="java.io.BufferedInputStream" %>
<%@ page import="java.io.FileInputStream" %>
<%@ page import="java.io.InputStreamReader" %>
<%@ page import="com.weavernorth.zgsy.baseInfo.MaterialDataTimed" %>
<%@ page language="java" contentType="text/html; charset=GBK" %>
<jsp:useBean id="RequestManager" class="weaver.workflow.request.RequestManager" scope="page"/>
<jsp:useBean id="flowDocss" class="weaver.workflow.request.RequestDoc" scope="session"/>
<jsp:useBean id="DocComInfo" class="weaver.docs.docs.DocComInfo" scope="page"/>
<jsp:useBean id="Doccoder" class="weaver.docs.docs.DocCoder" scope="page"/>


<%

    BaseBean baseBean = new BaseBean();
    String code = request.getParameter("code");
    baseBean.writeLog("浏览按钮 收到code： ======= " + code);
    if ("cfwl".equals(code)) {
        baseBean.writeLog("触发物料接口 " + code);
        MaterialDataTimed materialDataTimed = new MaterialDataTimed();
        materialDataTimed.execute();
        out.print("物料同步完成");
    }else {
        BaseDataUtil baseDataUtil = new BaseDataUtil();
        String baseData = baseDataUtil.getBaseData(code);
        out.print(baseData);
    }


%>



