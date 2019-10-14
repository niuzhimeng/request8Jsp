<%@ page import="com.alibaba.excel.metadata.Table" %>
<%@ page import="java.io.OutputStream" %>
<%@ page import="java.io.FileOutputStream" %>
<%@ page import="com.alibaba.excel.ExcelWriter" %>
<%@ page import="com.alibaba.excel.metadata.Sheet" %>
<%@ page import="com.alibaba.excel.support.ExcelTypeEnum" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>

<%
    try (OutputStream outputStream = new FileOutputStream("C:\\Users\\29529\\Desktop\\withoutHead.xlsx")) {
        ExcelWriter writer = new ExcelWriter(outputStream, ExcelTypeEnum.XLSX, true);
        Sheet sheet1 = new Sheet(1, 0);
        sheet1.setSheetName("sheet1");
        List<List<String>> data = new ArrayList<>();
        for (int i = 0; i < 10; i++) {
            List<String> item = new ArrayList<>();
            item.add("item0" + i);
            item.add("item1" + i);
            item.add("item2" + i);
            data.add(item);
        }
        List<List<String>> head = new ArrayList<List<String>>();
        List<String> headCoulumn1 = new ArrayList<String>();
        List<String> headCoulumn2 = new ArrayList<String>();
        List<String> headCoulumn3 = new ArrayList<String>();
        headCoulumn1.add("第一列");
        headCoulumn2.add("第二列");
        headCoulumn3.add("第三列");
        head.add(headCoulumn1);
        head.add(headCoulumn2);
        head.add(headCoulumn3);
        Table table = new Table(1);
        table.setHead(head);
        writer.write0(data, sheet1, table);
        writer.finish();

    } catch (Exception e) {
        e.printStackTrace();
    }

%>