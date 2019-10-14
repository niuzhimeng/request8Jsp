<%@ page import="java.io.IOException" %>
<%@ page import="java.io.File" %>
<%@ page import="com.artofsolving.jodconverter.openoffice.connection.OpenOfficeConnection" %>
<%@ page import="com.artofsolving.jodconverter.openoffice.connection.SocketOpenOfficeConnection" %>
<%@ page import="com.artofsolving.jodconverter.openoffice.converter.OpenOfficeDocumentConverter" %>
<%@ page import="com.artofsolving.jodconverter.DocumentConverter" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<jsp:useBean id="RequestManager" class="weaver.workflow.request.RequestManager" scope="page"/>
<jsp:useBean id="flowDocss" class="weaver.workflow.request.RequestDoc" scope="session"/>
<jsp:useBean id="DocComInfo" class="weaver.docs.docs.DocComInfo" scope="page"/>
<jsp:useBean id="Doccoder" class="weaver.docs.docs.DocCoder" scope="page"/>

<%
    String start = "C:\\Users\\29529\\Desktop\\123.docx";
    String over = "C:\\Users\\29529\\Desktop\\成了.pdf";
    try {
        WordToPDF(start, over);
    } catch (IOException e) {
        e.printStackTrace();
    }
%>

<%!
    private static void WordToPDF(String startFile, String overFile) throws IOException {
        // 源文件目录
        File inputFile = new File(startFile);
        if (!inputFile.exists()) {
            System.out.println("源文件不存在！");
            return;
        }

        // 输出文件目录
        File outputFile = new File(overFile);
        if (!outputFile.getParentFile().exists()) {
            outputFile.getParentFile().mkdirs();
        }

        // 调用openoffice服务线程
        String command = "D:/openOffice/program/soffice.exe -headless -accept=\"socket,host=127.0.0.1,port=8100;urp;\"";
        Process p = Runtime.getRuntime().exec(command);

        // 连接openoffice服务
        OpenOfficeConnection connection = new SocketOpenOfficeConnection("127.0.0.1", 8100);

        connection.connect();

        // 转换
        DocumentConverter converter = new OpenOfficeDocumentConverter(connection);
        converter.convert(inputFile, outputFile);

        // 关闭连接
        connection.disconnect();

        // 关闭进程
        p.destroy();
    }
%>





