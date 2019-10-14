<%@ page import="cn.hutool.core.io.FileUtil" %>
<%@ page import="cn.hutool.core.io.IoUtil" %>
<%@ page import="cn.hutool.core.util.ZipUtil" %>
<%@ page import="weaver.general.BaseBean" %>
<%@ page import="java.io.*" %>
<%@ page import="java.net.URLEncoder" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>


<%
    // 文件在线预览
    File file = new File("C:\\Users\\29529\\Desktop\\123.pdf");

    BufferedInputStream inputStream = new BufferedInputStream(new FileInputStream(file));
    byte[] bytes = new byte[1024];
    int len = 0;
    response.reset();
    response.setContentType("application/pdf");
    response.addHeader("Content-Disposition", "inline;filename=" + URLEncoder.encode(file.getName(), "UTF-8"));

    ServletOutputStream outputStream = response.getOutputStream();
    OutputStream bufferedOutputStream = new BufferedOutputStream(outputStream);
    while ((len = inputStream.read(bytes)) > 0) {
        bufferedOutputStream.write(bytes, 0, len);
    }
    inputStream.close();
    bufferedOutputStream.close();

%>





