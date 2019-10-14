<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page"/>
<%@ page import="weaver.conn.RecordSet" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>

<%
    BaseBean baseBean = new BaseBean();
    baseBean.writeLog("校验人数CheckBack.jsp执行=================");
    int xqrsVal = Integer.parseInt(request.getParameter("xqrsVal"));//需求人数
    String fbVal = request.getParameter("fbVal"); // 分部

    String returnData = "true";
    RecordSet recordSet = new RecordSet();
    recordSet.executeQuery("select * from uf_rsbzxx where fb = '" + fbVal + "'");
    if (recordSet.next()) {
        int ksqrs = recordSet.getInt("ksqrs") > 0 ? recordSet.getInt("ksqrs") : 0;
        baseBean.writeLog("可申请人数： " + ksqrs);
        baseBean.writeLog("需求人数： " + xqrsVal);
        if (xqrsVal > ksqrs) {
            returnData = "人数超出限制，当前可申请人数为：" + ksqrs + "人，请提交《编制架构调整申请流程》";
        }
    }
    out.clear();
    out.print(returnData);

%>



