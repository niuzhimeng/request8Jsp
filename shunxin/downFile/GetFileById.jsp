<%@ page import="sun.misc.BASE64Encoder" %>
<%@ page import="weaver.conn.RecordSet" %>
<%@ page import="weaver.general.BaseBean" %>
<%@ page import="java.net.URLEncoder" %>
<%@ page import="java.util.Enumeration" %>
<%@ page import="java.util.zip.ZipEntry" %>
<%@ page import="java.util.zip.ZipFile" %>
<%@ page import="java.io.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<%
    // 根据附件id下载附件
    String fileId = request.getParameter("fileId");
    BaseBean baseBean = new BaseBean();
    baseBean.writeLog("下载文件开始，文件id： " + fileId);
    if ("".equals(fileId)) {
        out.clear();
        out.print("下载失败，文件id不能为空。");
        return;
    }

    RecordSet recordSet = new RecordSet();
    // 查询附件字段的sql
    String pathSql = "SELECT im.imagefiletype, im.imagefilename,im.filerealpath FROM ImageFile im LEFT JOIN DocImageFile df " +
            "ON df.imagefileid = im.imagefileid WHERE df.docid = '" + fileId + "'";
    recordSet.executeQuery(pathSql);
    if (recordSet.next()) {
        String imagefilename = recordSet.getString("imagefilename");
        String filerealpath = recordSet.getString("filerealpath"); // 文件全路径
        String imagefiletype = recordSet.getString("imagefiletype");

        // 中文名设置
        //获取客户端信息
        String agent = request.getHeader("User-Agent");
        baseBean.writeLog("agent: " + agent);
        //定义一个变量记录编码之后的名字
        String filenameEncoder = "";
        if (agent.contains("MSIE")) {
            //IE编码
            filenameEncoder = URLEncoder.encode(imagefilename, "utf-8");
            filenameEncoder = filenameEncoder.replace("+", "");
        } else if (agent.contains("Firefox")) {
            //火狐编码
            BASE64Encoder base64Encoder = new BASE64Encoder();
            filenameEncoder = "=?utf-8?B?" + base64Encoder.encode(imagefilename.getBytes("utf-8")) + "?=";
        } else {
            //浏览器编码
            filenameEncoder = URLEncoder.encode(imagefilename, "utf-8");
        }

        baseBean.writeLog("调整编码后文件名： " + filenameEncoder);

        // 设置响应头打开方式
        response.reset();
        response.setHeader("content-disposition", "attachment;filename=\"" + filenameEncoder + "\"");
        response.setDateHeader("Expires", -1);
        response.setHeader("Cache-Control", "no-cache");
        response.setHeader("Pragma", "no-cache");
        response.setHeader("content-type", "application/octet-stream");

        unZip(filerealpath, "D:\\WEAVER\\ecology\\filesystem\\sxTempFile\\" + imagefilename);
//        // 开始解压
//        ZipFile zipFile = null;
//        InputStream inputStream = null;
//        try {
//            zipFile = new ZipFile(filerealpath);
//            Enumeration<?> entries = zipFile.entries();
//            while (entries.hasMoreElements()) {
//                ZipEntry entry = (ZipEntry) entries.nextElement();
//                inputStream = zipFile.getInputStream(entry);
//
//                InputStream is = zipFile.getInputStream(entry);
//                FileOutputStream fos = new FileOutputStream("D:\\WEAVER\\ecology\\filesystem\\sxTempFile\\" + imagefilename);
//                int len;
//                byte[] buf = new byte[4096];
//                while ((len = is.read(buf)) != -1) {
//                    fos.write(buf, 0, len);
//                }
//                // 关流顺序，先打开的后关闭
//                fos.close();
//                is.close();
//
//            }
//
//        } catch (Exception e) {
//            throw new RuntimeException("unzip error from ZipUtils", e);
//        } finally {
//            if (zipFile != null) {
//                zipFile.close();
//            }
//            if (inputStream != null) {
//                inputStream.close();
//            }
//        }

        ServletOutputStream outputStream = response.getOutputStream();
        out.clearBuffer();
        FileInputStream fileInputStream = new FileInputStream("D:\\WEAVER\\ecology\\filesystem\\sxTempFile\\" + imagefilename);
        byte[] bytes = new byte[1024 * 2];
        int len;
        while ((len = fileInputStream.read(bytes)) != -1) {
            outputStream.write(bytes, 0, len);
        }

        fileInputStream.close();

    } else {
        out.clear();
        out.print("下载失败，文件id不存在。");
        return;
    }


%>


<%!
    /**
     * zip解压
     *
     * @param srcFilePath     zip源文件
     * @param destDirPath 解压后的目标文件夹
     * @throws RuntimeException 解压失败会抛出运行时异常
     */

    private void unZip(String srcFilePath, String destDirPath) throws RuntimeException {
        File srcFile = new File(srcFilePath);
        // 判断源文件是否存在
        if (!srcFile.exists()) {
            throw new RuntimeException(srcFile.getPath() + "所指文件不存在");
        }
        // 开始解压
        ZipFile zipFile = null;
        try {
            zipFile = new ZipFile(srcFile);
            Enumeration<?> entries = zipFile.entries();
            while (entries.hasMoreElements()) {
                ZipEntry entry = (ZipEntry) entries.nextElement();
                // 如果是文件夹，就创建个文件夹
                if (entry.isDirectory()) {
                    String dirPath = destDirPath + "/" + entry.getName();
                    File dir = new File(dirPath);
                    dir.mkdirs();
                } else {
                    // 如果是文件，就先创建一个文件，然后用io流把内容copy过去
                    File targetFile = new File(destDirPath);
                    // 保证这个文件的父文件夹必须要存在
                    if (!targetFile.getParentFile().exists()) {
                        targetFile.getParentFile().mkdirs();
                    }
//                    targetFile.createNewFile();
                    // 将压缩文件内容写入到这个文件中
                    InputStream is = zipFile.getInputStream(entry);
                    FileOutputStream fos = new FileOutputStream(targetFile);
                    int len;
                    byte[] buf = new byte[4096];
                    while ((len = is.read(buf)) != -1) {
                        fos.write(buf, 0, len);
                    }
                    // 关流顺序，先打开的后关闭
                    fos.close();
                    is.close();
                }
            }
        } catch (Exception e) {
            throw new RuntimeException("unzip error from ZipUtils", e);
        } finally {
            if (zipFile != null) {
                try {
                    zipFile.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        }
    }
%>
