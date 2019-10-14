<%@ page import="org.apache.commons.fileupload.servlet.ServletFileUpload" %>
<%@ page import="org.apache.commons.fileupload.disk.DiskFileItemFactory" %>
<%@ page import="java.io.File" %>
<%@ page import="org.apache.commons.fileupload.FileItem" %>
<%@ page import="java.util.List" %>
<%@ page import="java.io.InputStream" %>
<%@ page import="java.io.OutputStream" %>
<%@ page import="java.io.FileOutputStream" %>
<%@ page import="weaver.general.BaseBean" %>
<%@ page import="java.time.LocalDate" %>
<%@ page import="weaver.conn.RecordSet" %>
<%@ page import="java.time.LocalDateTime" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<%

    BaseBean baseBean = new BaseBean();
    String parameter = request.getParameter("name");

    //检查我们是否有文件上传请求
    boolean isMultipart = ServletFileUpload.isMultipartContent(request);
    baseBean.writeLog("上传开始： " + isMultipart + ", " + LocalDateTime.now());
    //1,声明DiskFileItemFactory工厂类，用于在指定磁盘上设置一个临时目录
    DiskFileItemFactory disk = new DiskFileItemFactory();
    //2,声明ServletFileUpload，接收上边的临时文件。也可以默认值
    ServletFileUpload up = new ServletFileUpload(disk);
    //3,解析request
    OutputStream outputStream = null;
    try {
        List<FileItem> list = up.parseRequest(request);
        for (FileItem file : list) {
            //获取文件名：
            String fileName = file.getName();
            baseBean.writeLog("fileName: " + fileName);

            //获取文件的类型：
            String fileType = file.getContentType();
            baseBean.writeLog("fileType: " + fileType);

            //获取文件的字节码：
            InputStream in = file.getInputStream();
            //文件大小
            int size = file.getInputStream().available();
            baseBean.writeLog("size: " + size);

            //声明输出字节流
            outputStream = new FileOutputStream("D:\\uploadTest\\" + fileName);
            //文件copy
            byte[] b = new byte[1024];
            int len;
            while ((len = in.read(b)) != -1) {
                outputStream.write(b, 0, len);
            }
            //删除上传生成的临时文件
            file.delete();
            out.flush();
        }
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        if (outputStream != null) {
            outputStream.close();
        }
    }

    out.print("上传完成: " + parameter);

%>










