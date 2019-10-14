<%@ page import="com.google.gson.Gson" %>
<%@ page import="com.weavernorth.daTang.vo.TableZdVo" %>
<%@ page import="km.org.apache.poi.hssf.usermodel.HSSFCellStyle" %>
<%@ page import="km.org.apache.poi.hssf.usermodel.HSSFFont" %>
<%@ page import="org.apache.poi.hssf.usermodel.HSSFCell" %>
<%@ page import="org.apache.poi.hssf.usermodel.HSSFRow" %>
<%@ page import="org.apache.poi.hssf.usermodel.HSSFSheet" %>
<%@ page import="org.apache.poi.hssf.usermodel.HSSFWorkbook" %>
<%@ page import="org.apache.poi.hssf.util.Region" %>
<%@ page import="weaver.conn.RecordSet" %>
<%@ page import="weaver.general.BaseBean" %>
<%@ page import="weaver.general.TimeUtil" %>
<%@ page import="java.io.File" %>
<%@ page import="java.io.FileOutputStream" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.List" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%
    String tableName = "uf_getAllCatalogLis";//建模表名

    String useless = "";//无需导出的字段名
    BaseBean baseBean = new BaseBean();
    try {
        String id = request.getParameter("id");
        baseBean.writeLog("接收到建模id：" + id);
        //数据库字段名 - 字段显示名
        List<TableZdVo> tableZdVoList = new ArrayList<TableZdVo>();
        RecordSet zdSet = new RecordSet();
        zdSet.executeQuery("SELECT zd.fieldname, ht.labelname FROM workflow_billfield zd LEFT JOIN workflow_bill bm ON bm.id = zd.billid LEFT JOIN HtmlLabelInfo ht ON zd.fieldlabel = ht.indexid where bm.tablename = '" + tableName + "' and ht.languageid = '7' ORDER BY zd.dsporder ");
        baseBean.writeLog("---------- " + zdSet.getCounts());
        while (zdSet.next()) {
            if (useless.contains(zdSet.getString("fieldname"))) {
                continue;
            }
            TableZdVo vo = new TableZdVo();
            vo.setHideName(zdSet.getString("fieldname"));
            vo.setShowName(zdSet.getString("labelname"));
            tableZdVoList.add(vo);
        }
        baseBean.writeLog("拼装好的字段名======== " + new Gson().toJson(tableZdVoList));
        RecordSet recordSet = new RecordSet();
        recordSet.executeQuery("select * from " + tableName + " where id = '" + id + "'");
        if (recordSet.next()) {
            //创建一个工作簿
            HSSFWorkbook workbook = new HSSFWorkbook();
            //创建一个电子表格
            HSSFSheet sheet = workbook.createSheet("Sheet1");
            //内容字体
            org.apache.poi.hssf.usermodel.HSSFFont font = workbook.createFont();
            font.setFontHeightInPoints((short) 9); //字体高度
            font.setFontName("微软雅黑"); //字体
            font.setBoldweight(HSSFFont.BOLDWEIGHT_NORMAL); //宽度

            //标题字体
            org.apache.poi.hssf.usermodel.HSSFFont biaoTifont = workbook.createFont();
            biaoTifont.setFontHeightInPoints((short) 10); //字体高度
            biaoTifont.setFontName("微软雅黑"); //字体
            biaoTifont.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD); //宽度

            //内容格式
            org.apache.poi.hssf.usermodel.HSSFCellStyle neiRongStyle = workbook.createCellStyle();
            neiRongStyle.setFont(font);
            neiRongStyle.setAlignment(HSSFCellStyle.ALIGN_LEFT); //布局，偏左
            neiRongStyle.setWrapText(true);
            neiRongStyle.setBorderBottom(HSSFCellStyle.BORDER_THIN);
            neiRongStyle.setBorderLeft(HSSFCellStyle.BORDER_THIN);
            neiRongStyle.setBorderRight(HSSFCellStyle.BORDER_THIN);
            neiRongStyle.setBorderTop(HSSFCellStyle.BORDER_THIN);
            //标题格式
            org.apache.poi.hssf.usermodel.HSSFCellStyle biaoTiStyle = workbook.createCellStyle();
            biaoTiStyle.setFont(biaoTifont);
            biaoTiStyle.setAlignment(HSSFCellStyle.ALIGN_CENTER); //布局，居中
            biaoTiStyle.setWrapText(true);
            biaoTiStyle.setBorderBottom(HSSFCellStyle.BORDER_THIN);
            biaoTiStyle.setBorderLeft(HSSFCellStyle.BORDER_THIN);
            biaoTiStyle.setBorderRight(HSSFCellStyle.BORDER_THIN);
            biaoTiStyle.setBorderTop(HSSFCellStyle.BORDER_THIN);

            //设置第一行标题
            Region region0 = new Region(1, (short) 1, 1, (short) 4);//（开始行，（short）开始列），结束行，（short）结束列）。
            sheet.addMergedRegion(region0);
            HSSFRow row1 = sheet.createRow(1);
            HSSFCell cell = row1.createCell((short) 1);
            for (int i = 1; i < 5; i++) {
                HSSFCell cell1 = row1.createCell((short) i);
                cell1.setCellStyle(biaoTiStyle);
            }
            ssoagent.client.filter.AuthenFilter
            String titleName = "部门利润表";//标题名称

            cell.setCellType(HSSFCell.CELL_TYPE_STRING);
            cell.setEncoding(HSSFCell.ENCODING_UTF_16);
            cell.setCellValue(titleName);
            cell.setCellStyle(biaoTiStyle);
            baseBean.writeLog("字体标题设置完毕=============");

            int myRow = 2;//输出行数
            int size = tableZdVoList.size();
            for (int i = 0; i < size; i += 2) {
                //1.创建一个行对象
                HSSFRow row = sheet.createRow(myRow);

                sheet.setColumnWidth((short) 1, (short) (20 * 256));
                sheet.setColumnWidth((short) 2, (short) (40 * 256));
                sheet.setColumnWidth((short) 3, (short) (20 * 256));
                sheet.setColumnWidth((short) 4, (short) (40 * 256));
                HSSFCell cell1 = row.createCell((short) 1);
                cell1.setCellType(HSSFCell.CELL_TYPE_STRING);
                cell1.setEncoding(HSSFCell.ENCODING_UTF_16);
                baseBean.writeLog("1 =========" + tableZdVoList.get(i).getShowName());
                cell1.setCellValue(tableZdVoList.get(i).getShowName());
                cell1.setCellStyle(neiRongStyle);

                HSSFCell cell2 = row.createCell((short) 2);
                cell2.setCellType(HSSFCell.CELL_TYPE_STRING);
                cell2.setEncoding(HSSFCell.ENCODING_UTF_16);
                baseBean.writeLog("2 =========" + recordSet.getString(tableZdVoList.get(i).getHideName()));
                cell2.setCellValue(recordSet.getString(tableZdVoList.get(i).getHideName()));
                cell2.setCellStyle(neiRongStyle);
                if (i + 1 < size) {
                    HSSFCell cell3 = row.createCell((short) 3);
                    cell3.setCellType(HSSFCell.CELL_TYPE_STRING);
                    cell3.setEncoding(HSSFCell.ENCODING_UTF_16);
                    baseBean.writeLog("3 =========" + tableZdVoList.get(i + 1).getShowName());
                    cell3.setCellValue(tableZdVoList.get(i + 1).getShowName());
                    cell3.setCellStyle(neiRongStyle);

                    HSSFCell cell4 = row.createCell((short) 4);
                    cell4.setCellType(HSSFCell.CELL_TYPE_STRING);
                    cell4.setEncoding(HSSFCell.ENCODING_UTF_16);
                    baseBean.writeLog("4 =========" + recordSet.getString(tableZdVoList.get(i + 1).getHideName()));
                    cell4.setCellValue(recordSet.getString(tableZdVoList.get(i + 1).getHideName()));
                    cell4.setCellStyle(neiRongStyle);
                } else {
                    baseBean.writeLog("设置边框=========");
                    HSSFCell cell3 = row.createCell((short) 3);
                    cell3.setCellStyle(neiRongStyle);
                    HSSFCell cell4 = row.createCell((short) 4);
                    cell4.setCellStyle(neiRongStyle);
                }
                myRow++;
            }
            baseBean.writeLog("导出开始===========");
            String timestamp = TimeUtil.getCurrentTimeString().replace("-", "").replace(":", "").replaceAll("\\s*", "").substring(0, 12);
            String basePath = "D:\\WEAVER\\ecology";
            String path = "\\filesystem\\bmlr" + File.separator + "departmentProfit" + timestamp + ".xlsx";
            FileOutputStream fileOutputStream = new FileOutputStream(basePath + path);
            workbook.write(fileOutputStream);
            fileOutputStream.close();
            response.sendRedirect("/" + path);
        }
    } catch (Exception e) {
        baseBean.writeLog("OutExcel.jsp 异常:" + e);
        out.clear();
        out.print(e);
        return;
    }

%>

