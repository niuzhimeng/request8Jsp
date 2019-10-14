<%@ page import="com.google.gson.Gson" %>
<%@ page import="weaver.conn.RecordSet" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.zip.ZipEntry" %>
<%@ page import="java.util.zip.ZipFile" %>
<%@ page import="java.util.zip.ZipOutputStream" %>
<%@ page import="java.nio.charset.Charset" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page"/>
<%@ include file="/systeminfo/init_wev8.jsp" %>

<%
    BaseBean baseBean = new BaseBean();
    Gson gson = new Gson();
    try {
        // 表名
        String tableName = "uf_patchDown";
        // 一级目录分级字段
        String firstFile = "name";

        // 前台多条数据id的数组
        String idStr = request.getParameter("ids");
        baseBean.writeLog("PatchDown.jsp 收到前台传递的id字符串： " + idStr);
        String[] ids = idStr.split(",");
        baseBean.writeLog("PatchDown.jsp 收到前台传递的id数组： " + gson.toJson(ids));

        // 查询附件字段的sql
        String fjSql = "SELECT zd.fieldname FROM workflow_billfield zd LEFT JOIN workflow_bill bm ON bm.id = zd.billid WHERE bm.tablename = '" + tableName + "' AND zd.fieldhtmltype = 6 ORDER BY zd.dsporder";
        // 附件字段名集合
        List<String> fileNameList = new ArrayList<>();
        RecordSet recordSet = new RecordSet();
        recordSet.executeQuery(fjSql);
        while (recordSet.next()) {
            fileNameList.add(recordSet.getString("fieldname"));
        }

        // ==================== 创建本次操作的文件夹 ====================
        // 201904 年月
        String dateStamp = TimeUtil.getCurrentDateString().replace("-", "").substring(0, 6);
        String rootPath = "D:" + File.separator + "WEAVER" + File.separator + "ecology";
        String basePath = File.separator + "filesystem" + File.separator + "batchClassify" + File.separator + dateStamp + File.separator;

        // 30124400 日时分秒
        String path = TimeUtil.getCurrentTimeString().replace("-", "").replace(":", "")
                .replaceAll("\\s*", "").substring(6);

        String realPath = rootPath + basePath + path;
        File file = new File(realPath);
        if (!file.exists()) {
            file.mkdirs();
        }

        // 字段名 - 附件id数组
        Map<String, String[]> fileMap = new HashMap<>();
        String tempStr;
        // 循环多条建模数据
        for (String id : ids) {
            recordSet.executeQuery("select * from " + tableName + " where id = " + id);
            recordSet.next();
            for (String s : fileNameList) {
                tempStr = Util.null2String(recordSet.getString(s));
                if (!"".equals(tempStr)) {
                    fileMap.put(s, tempStr.split(","));
                }
            }

            baseBean.writeLog("字段名 - 附件id数组: " + gson.toJson(fileMap));

            // 按每条数据分文件夹
            String onePath = realPath + File.separator + recordSet.getString(firstFile) + "_" + id;

            // 查询附件 名称 - 所在路径
            RecordSet pathSet = new RecordSet();
            for (Map.Entry<String, String[]> entry : fileMap.entrySet()) {
                String changedId = shuZuChange(entry.getValue());
                String pathSql = "SELECT im.imagefilename,im.filerealpath FROM ImageFile im LEFT JOIN DocImageFile df ON df.imagefileid = im.imagefileid WHERE df.docid IN ( " + changedId + " )";
                baseBean.writeLog("拼接后sql： " + pathSql);

                String twoPath = onePath + File.separator + changeChina(tableName, entry.getKey());
                File twoFile = new File(twoPath);
                if (!twoFile.exists()) {
                    twoFile.mkdirs();
                }

                pathSet.executeQuery(pathSql);
                while (pathSet.next()) {
                    unZip(pathSet.getString("filerealpath"), twoPath + File.separator + pathSet.getString("imagefilename"));
                }
            }
            // 清空本次操作的map
            fileMap.clear();
        }
        baseBean.writeLog("88组合文件创建完成========== ");
        // 压缩该文件夹
        FileOutputStream fileOutputStream = new FileOutputStream(realPath + ".zip");
        toZip(realPath, fileOutputStream, true);

        response.sendRedirect("/" + basePath + path + ".zip");
    } catch (Exception e) {
        baseBean.writeLog("PatchDown.jsp 异常： " + e);
    }

%>

<%!
    /**
     * 数据库字段名， 转为汉字显示
     * @param tableName 表名
     * @param zdName 字段
     * @return
     */
    private String changeChina(String tableName, String zdName) {
        String retuers = "";
        String sql = "SELECT ht.labelname FROM workflow_billfield zd LEFT JOIN workflow_bill bm ON bm.id = zd.billid LEFT JOIN " +
                "HtmlLabelInfo ht ON zd.fieldlabel = ht.indexid WHERE bm.tablename = '" + tableName + "' AND ht.languageid = '7' and zd.fieldname = '" + zdName + "'";
        RecordSet recordSet = new RecordSet();
        recordSet.executeQuery(sql);
        if (recordSet.next()) {
            retuers = recordSet.getString("labelname");
        }
        return retuers;
    }

    /**
     * 压缩成ZIP 方法1
     *
     * @param srcDir           压缩文件夹路径
     * @param out              压缩文件输出流
     * @param KeepDirStructure 是否保留原来的目录结构,true:保留目录结构;
     *                         false:所有文件跑到压缩包根目录下(注意：不保留目录结构可能会出现同名文件,会压缩失败)
     * @throws RuntimeException 压缩失败会抛出运行时异常
     */
    private static void toZip(String srcDir, OutputStream out, boolean KeepDirStructure) throws Exception {
        long start = System.currentTimeMillis();
        ZipOutputStream zos = null;
        try {
            zos = new ZipOutputStream(out);

            File sourceFile = new File(srcDir);
            compress(sourceFile, zos, sourceFile.getName(), KeepDirStructure);
            long end = System.currentTimeMillis();
            System.out.println("压缩完成，耗时：" + (end - start) + " ms");
        } catch (Exception e) {
            throw new RuntimeException("zip error from ZipUtils", e);
        } finally {
            if (zos != null) {
                try {
                    zos.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        }
    }


    private static void compress(File sourceFile, ZipOutputStream zos, String name,
                                 boolean KeepDirStructure) throws Exception {
        byte[] buf = new byte[2048];
        if (sourceFile.isFile()) {
            // 向zip输出流中添加一个zip实体，构造器中name为zip实体的文件的名字
            zos.putNextEntry(new ZipEntry(name));
            // copy文件到zip输出流中
            int len;
            FileInputStream in = new FileInputStream(sourceFile);
            while ((len = in.read(buf)) != -1) {
                zos.write(buf, 0, len);
            }
            // Complete the entry
            zos.closeEntry();
            in.close();
        } else {
            File[] listFiles = sourceFile.listFiles();
            if (listFiles == null || listFiles.length == 0) {
                // 需要保留原来的文件结构时,需要对空文件夹进行处理
                if (KeepDirStructure) {
                    // 空文件夹的处理
                    zos.putNextEntry(new ZipEntry(name + "/"));
                    // 没有文件，不需要文件的copy
                    zos.closeEntry();
                }
            } else {
                for (File file : listFiles) {
                    // 判断是否需要保留原来的文件结构
                    if (KeepDirStructure) {
                        // 注意：file.getName()前面需要带上父文件夹的名字加一斜杠,
                        // 不然最后压缩包中就不能保留原来的文件结构,即：所有文件都跑到压缩包根目录下了
                        compress(file, zos, name + "/" + file.getName(), KeepDirStructure);
                    } else {
                        compress(file, zos, file.getName(), KeepDirStructure);
                    }
                }
            }
        }
    }

    private String shuZuChange(String[] strs) {
        StringJoiner joiner = new StringJoiner(",");
        for (String str : strs) {
            joiner.add(str);
        }
        return joiner.toString();
    }

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