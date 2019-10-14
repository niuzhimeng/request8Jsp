<%@ page import="cn.hutool.core.io.FileUtil" %>
<%@ page import="cn.hutool.core.io.IoUtil" %>
<%@ page import="cn.hutool.core.util.ZipUtil" %>
<%@ page import="weaver.general.BaseBean" %>
<%@ page import="java.io.*" %>

<%@ page import="weaver.conn.RecordSet" %>
<%@ page import="com.weavernorth.ningbowuxin.wordoperate.DocCreateService" %>
<%@ page import="java.util.regex.Pattern" %>
<%@ page import="java.util.regex.Matcher" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>


<%
    /**
     * 子目录id
     */
    final String MU_LU_ID = "122";
    BaseBean baseBean = new BaseBean();

    BufferedInputStream inputStream1 = null;
    BufferedOutputStream outputStream1 = null;
    BufferedReader bufferedReader = null;
    BufferedWriter bufferedWriter = null;
    BufferedInputStream inputStream2 = null;
    BufferedOutputStream outputStream2 = null;

    try {
        baseBean.writeLog("word标记替换开始 ；========");
        // 将模板复制一份 zip格式
        inputStream1 = FileUtil.getInputStream("d:/weaver/ecology/wordTemplate/1.docx");

        File file = new File("d:/weaver/ecology/temp/1.zip");

        outputStream1 = FileUtil.getOutputStream(file);
        long copySize = IoUtil.copy(inputStream1, outputStream1, IoUtil.DEFAULT_BUFFER_SIZE);
        baseBean.writeLog("另存一份zip文件完成，copySize: " + copySize);

        // 解压该zip文件 读取document.xml文件
        File unzip = ZipUtil.unzip(file);
        baseBean.writeLog("解压完成： " + unzip);

        String unPathStr = unzip.toString() + File.separatorChar + "word" + File.separatorChar + "document.xml";
        baseBean.writeLog("xml路径： " + unPathStr);

        bufferedReader = FileUtil.getReader(unPathStr, "utf-8");
        String xmlStr = IoUtil.read(bufferedReader);
        baseBean.writeLog("读取到的xml： " + xmlStr);
        baseBean.writeLog("xml长度： " + xmlStr.length());

        // 替换xml
        xmlStr = xmlStr.replace("{name}", "牛智萌1")
                .replace("{address}", "齐齐哈尔市1")
                .replace("{email}", "295290968@qq.com")
                .replace("{phone}", "15777777777");

//        Map<String, String> map = new HashMap<String, String>();
//        String xml = "<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"yes\"?><w:document xmlns:wpc=\"http://schemas.microsoft.com/office/word/2010/wordprocessingCanvas\" xmlns:mc=\"http://schemas.openxmlformats.org/markup-compatibility/2006\" xmlns:o=\"urn:schemas-microsoft-com:office:office\" xmlns:r=\"http://schemas.openxmlformats.org/officeDocument/2006/relationships\" xmlns:m=\"http://schemas.openxmlformats.org/officeDocument/2006/math\" xmlns:v=\"urn:schemas-microsoft-com:vml\" xmlns:wp14=\"http://schemas.microsoft.com/office/word/2010/wordprocessingDrawing\" xmlns:wp=\"http://schemas.openxmlformats.org/drawingml/2006/wordprocessingDrawing\" xmlns:w=\"http://schemas.openxmlformats.org/wordprocessingml/2006/main\" xmlns:w14=\"http://schemas.microsoft.com/office/word/2010/wordml\" xmlns:w10=\"urn:schemas-microsoft-com:office:word\" xmlns:w15=\"http://schemas.microsoft.com/office/word/2012/wordml\" xmlns:wpg=\"http://schemas.microsoft.com/office/word/2010/wordprocessingGroup\" xmlns:wpi=\"http://schemas.microsoft.com/office/word/2010/wordprocessingInk\" xmlns:wne=\"http://schemas.microsoft.com/office/word/2006/wordml\" xmlns:wps=\"http://schemas.microsoft.com/office/word/2010/wordprocessingShape\" xmlns:wpsCustomData=\"http://www.wps.cn/officeDocument/2013/wpsCustomData\" mc:Ignorable=\"w14 w15 wp14\"><w:body><w:p><w:pPr><w:rPr><w:rFonts w:hint=\"eastAsia\" w:eastAsiaTheme=\"minorEastAsia\"/><w:lang w:val=\"en-US\" w:eastAsia=\"zh-CN\"/></w:rPr></w:pPr><w:r><w:rPr><w:rFonts w:hint=\"eastAsia\"/><w:lang w:val=\"en-US\" w:eastAsia=\"zh-CN\"/></w:rPr><w:t>牛智萌：{name}</w:t><w:t>牛智萌：{sex}</w:t><w:t>牛智萌：{age}</w:t></w:r><w:bookmarkStart w:id=\"0\" w:name=\"_GoBack\"/><w:bookmarkEnd w:id=\"0\"/></w:p><w:sectPr><w:pgSz w:w=\"11906\" w:h=\"16838\"/><w:pgMar w:top=\"1440\" w:right=\"1800\" w:bottom=\"1440\" w:left=\"1800\" w:header=\"851\" w:footer=\"992\" w:gutter=\"0\"/><w:cols w:space=\"425\" w:num=\"1\"/><w:docGrid w:type=\"lines\" w:linePitch=\"312\" w:charSpace=\"0\"/></w:sectPr></w:body></w:document>";
//        匹配{数字、字母、下划线}
//        Pattern pattern = Pattern.compile("\\{\\w+}");
//        Matcher matcher = pattern.matcher(xml);
//        while (matcher.find()) {
//            String group = matcher.group();
//            String substring = group.substring(1, group.length() - 1);
//            map.put(group, substring);
//        }
//
//        for (Map.Entry<String, String> entry : map.entrySet()) {
//            System.out.println(entry.getKey() + ": " + entry.getValue());
//        }

        // 输出新的xml false 表示不追加
        bufferedWriter = FileUtil.getWriter(unPathStr, "utf-8", false);
        bufferedWriter.write(xmlStr);
        bufferedWriter.flush();

        // 重新压缩
        File zip = ZipUtil.zip(unzip);
        String inPath = zip.toString();
        baseBean.writeLog("重新压缩后的路径： " + inPath);

        // 复制一份为 .docx的文件
        String outPath = inPath.substring(0, inPath.lastIndexOf(".")) + ".docx";
        inputStream2 = FileUtil.getInputStream(inPath);
        outputStream2 = FileUtil.getOutputStream(outPath);
        IoUtil.copy(inputStream2, outputStream2, IoUtil.DEFAULT_BUFFER_SIZE);

        baseBean.writeLog("模板填充完成： " + outPath);
        // 上传附件
        DocCreateService service = new DocCreateService("sysadmin", "1");
        String strDocId = service.init("生成的附件" + ".docx", outPath, MU_LU_ID, "");

        // 更新流程表单
        RecordSet recordSet = new RecordSet();
        recordSet.executeUpdate("update formtable_main_47 set htzwfj = '" + strDocId + "' where requestid = " + 2569);

    } catch (Exception e) {
        baseBean.writeLog("word标记替换异常： " + e);
    } finally {
        myClose(inputStream1, outputStream1, bufferedReader, bufferedWriter, inputStream2, outputStream2);
    }
%>

<%!
    private void myClose(Closeable... closeableList) {
        for (Closeable closeable : closeableList) {
            IoUtil.close(closeable);
        }
    }
%>



