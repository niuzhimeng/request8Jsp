<%@ page import="com.alibaba.fastjson.JSONObject" %>
<%@ page import="weaver.hrm.HrmUserVarify" %>
<%@ page import="weaver.hrm.User" %>
<%@ page import="com.mfwoa.util.CustomUtil" %>
<%@ page import="weaver.general.GCONST" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.net.URLEncoder" %>
<%@ page import="java.nio.charset.StandardCharsets" %>
<%@ page import="java.io.*" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="bb" class="weaver.general.BaseBean" scope="page"/>
<%

    /**
     *文件上传
     */
    try {
        User user = HrmUserVarify.checkUser(request, response);
//        user = new User(3759);
        if (user == null) {
            //判断是否登录
            response.sendRedirect("/login/Login.jsp");
            return;
        }
        int fileId = Util.getIntValue(request.getParameter("id"));
        rs.executeQuery("select ORIGINALNAME, SAVENAME, SAVEPATH,RELATIVETYPE, RELATIVEID from UF_FILEINFO where id = ?", fileId);
        if (!rs.next()) {
            request.getRequestDispatcher("/notice/noright.jsp").forward(request, response);
            return;
        }
        String originalFileName = Util.null2String(rs.getString(1));
        String saveFileName = Util.null2String(rs.getString(2));
        String savePath = Util.null2String(rs.getString(3));
        int relativeType = rs.getInt(4);
        int relativeId = rs.getInt(5);

        String finalFilePath = GCONST.getRootPath() + savePath + "/" + saveFileName;
        File file = new File(finalFilePath);
        bb.writeLog(finalFilePath);
        if (!file.exists()) {
            request.getRequestDispatcher("/notice/noright.jsp").forward(request, response);
            return;
        }
        response.setContentType("application/octet-stream");
        InputStream fis = new BufferedInputStream(new FileInputStream(finalFilePath));
        byte[] buffer = new byte[fis.available()];
        fis.read(buffer);  //读取文件流
        bb.writeLog(new String(buffer));
        fis.close();
        response.reset();  //重置结果集
        response.addHeader("Content-Disposition", "attachment;filename=" + URLEncoder.encode(originalFileName, "UTF-8"));  //返回头 文件名
        response.addHeader("Content-Length", "" + file.length());  //返回头 文件大小
        response.setContentType("application/octet-stream");    //设置数据种类
        //获取返回体输出权
        ServletOutputStream output = response.getOutputStream();

        OutputStream os = new BufferedOutputStream(output);
        os.write(buffer); // 输出文件
        os.flush();
        os.close();

    } catch (Exception e) {
        bb.writeLog("===自定义下载文件异常===", e);
        request.getRequestDispatcher("/notice/noright.jsp").forward(request, response);
    }
%>