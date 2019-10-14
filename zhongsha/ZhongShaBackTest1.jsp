<%@ page import="com.weavernorth.OA2archives.util.ConvertToPdf" %>
<%@ page import="weaver.general.BaseBean" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%
    BaseBean baseBean = new BaseBean();
    baseBean.writeLog("nzm 执行了===========");
    ConvertToPdf conpdf = new ConvertToPdf();
    boolean isOk = conpdf.convert2PDF("C:\\Users\\29529\\Desktop\\PDF加水印Action-配置手册.doc", "C:\\Users\\29529\\Desktop\\test.pdf");

%>