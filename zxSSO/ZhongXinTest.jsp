<%@ page import="com.weaver.general.TimeUtil" %>
<%@ page import="org.apache.axis.encoding.Base64" %>
<%@ page import="weaver.docs.webservices.DocAttachment" %>

<%@ page import="weaver.docs.webservices.DocInfo" %>
<%@ page import="weaver.docs.webservices.DocServiceImpl" %>
<%@ page import="java.io.ByteArrayOutputStream" %>
<%@ page import="java.io.InputStream" %>
<%@ page import="java.net.HttpURLConnection" %>
<%@ page import="java.net.URL" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>


<%
    String s = "";
    try {
        String fileUrl = "http://47.94.241.183/041.doc";

        int i = fileUrl.lastIndexOf(".");
        String suffix = fileUrl.substring(i); // 文件后缀名

        //用户登陆**登录名
        String loginId = "fl";
        //用户登陆**密码
        String passward = "1";
        //用户登陆**登录类型
        int loginType = 0;
        //用户登陆**登录ip
        String ip = "127.0.0.1";
        //定义一个session存放登录属性
        String sessionStr = new DocServiceImpl().login(loginId, passward, loginType, ip);
        System.out.println("session---->" + session);

        try {
            s = downloadFile(fileUrl, sessionStr, suffix);
        } catch (Exception e) {
            out.print("异常： " + e);
        }
    } catch (Exception e) {
        out.print("异常： " + e);
    }
    out.print("文档id： " + s);
%>

<%!
    private String downloadFile(String fileUrl, String sessionStr, String suffix) throws Exception {
        URL url = new URL(fileUrl);
        HttpURLConnection urlCon = (HttpURLConnection) url.openConnection();
        urlCon.setConnectTimeout(6000);
        urlCon.setReadTimeout(6000);
        int code = urlCon.getResponseCode();
        if (code != HttpURLConnection.HTTP_OK) {
            throw new Exception("文件读取失败");
        }

        //读文件流
        InputStream input = urlCon.getInputStream();
        ByteArrayOutputStream out = new ByteArrayOutputStream();
        int byteread;
        byte[] data = new byte[10240];
        while ((byteread = input.read(data)) != -1) {
            out.write(data, 0, byteread);
            out.flush();
        }
        byte[] content = out.toByteArray();
        out.close();
        input.close();

        DocServiceImpl docService = new DocServiceImpl(); // 创建工具类

        // 文档对象
        DocInfo doc = new DocInfo();
        doc.setDoccreaterid(111);
        doc.setDoccreatertype(0);
        doc.setAccessorycount(1);
        doc.setMaincategory(120); //主目录id
        doc.setSeccategory(123); //子目录id

        doc.setDocStatus(1);
        doc.setId(1000);
        doc.setDocType(2);
        doc.setDocSubject("0307-员工资料" + TimeUtil.getCurrentTimeString());
        doc.setDoccontent("0307摩卡系统推送的员工资料，详情见附件");

        // 拼接附件
        DocAttachment[] arrays = new DocAttachment[2];
        for (int i = 0; i < 2; i++) {
            DocAttachment docAttachment = new DocAttachment();
            docAttachment.setFilecontent(Base64.encode(content));
            docAttachment.setIszip(1);
            docAttachment.setDocid(i);
            docAttachment.setImagefileid(i);
            docAttachment.setFilename(TimeUtil.getCurrentTimeString() + "测试文件" + i + suffix);
            docAttachment.setIsextfile("1");
            docAttachment.setDocfiletype("2");

            arrays[i] = docAttachment;
        }

        // 设置附件
        doc.setAttachments(arrays);
        int doc1 = docService.createDoc(doc, sessionStr);
        return doc1 + "";

    }

%>