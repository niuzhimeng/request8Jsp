<%@ page import="org.springframework.web.multipart.MultipartFile" %>
<%@ page import="org.springframework.web.multipart.MultipartHttpServletRequest" %>
<%@ page import="weaver.general.BaseBean" %>
<%@ page import="weaver.general.TimeUtil" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<%
    BaseBean baseBean = new BaseBean();
    baseBean.writeLog("上传文件开始： " + TimeUtil.getCurrentTimeString());

    MultipartHttpServletRequest multipartHttpservletRequest = (MultipartHttpServletRequest) request;
    MultipartFile multipartFile = multipartHttpservletRequest.getFile("uploadFile");
    //获取上传文件名称
    String fileName = multipartFile.getOriginalFilename();
    baseBean.writeLog("fileName: "+ fileName);


%>





















