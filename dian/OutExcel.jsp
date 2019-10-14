<%@ page import="java.io.FileOutputStream" %>
<%@ page import="km.org.apache.poi.hssf.usermodel.HSSFCellStyle" %>
<%@ page import="org.apache.poi.hssf.usermodel.*" %>
<%@ page import="java.io.BufferedOutputStream" %>
<%@ page import="java.io.OutputStream" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>

<%
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

    String[] titles = {"户名", "账号", "金额"};
    HSSFRow row = sheet.createRow(0);
    for (int i = 0; i < titles.length; i++) {
        HSSFCell cell = row.createCell((short) i);
        cell.setEncoding(HSSFCell.ENCODING_UTF_16);
        cell.setCellType(HSSFCell.CELL_TYPE_STRING);
        cell.setCellStyle(biaoTiStyle);
        cell.setCellValue(titles[i]);
    }

    for (int i = 1; i < 5; i++) {
        HSSFRow ConRow = sheet.createRow(i);
        for (int j = 0; j < 3; j++) {
            HSSFCell cell = ConRow.createCell((short) j);
            cell.setEncoding(HSSFCell.ENCODING_UTF_16);
            cell.setCellType(HSSFCell.CELL_TYPE_STRING);
            cell.setCellStyle(neiRongStyle);
            cell.setCellValue("第：" + i + "行，第：" + (j + 1) + "列");
        }

    }


//    FileOutputStream fileOutputStream = new FileOutputStream("C:\\Users\\29529\\Desktop\\student.xls");
//    workbook.write(fileOutputStream);
//    fileOutputStream.close();

    response.setContentType("application/octet-stream");    //设置数据种类

    response.reset();
    response.setContentType("application/x-download");
    //设置浏览器响应头对应的Content-disposition
    response.setHeader("Content-disposition", "attachment;filename="+new String("我得excel".getBytes("gbk"), "iso8859-1")+".xls");

    ServletOutputStream outputStream = response.getOutputStream();
    workbook.write(outputStream);
    outputStream.flush();
    outputStream.close();

%>