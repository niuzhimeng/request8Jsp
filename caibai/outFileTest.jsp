<%@ page import="com.sap.conn.jco.JCoDestination" %>
<%@ page import="com.sap.conn.jco.JCoFunction" %>
<%@ page import="com.sap.conn.jco.JCoParameterList" %>
<%@ page import="com.sap.conn.jco.JCoTable" %>
<%@ page import="com.weavernorth.caibai.sap.CaiBaiPoolThree" %>
<%@ page import="weaver.general.BaseBean" %>
<%@ page import="weaver.general.TimeUtil" %>
<%@ page import="com.weavernorth.caibai.sap.CaiBaiPoolThreeFormal" %>
<%@ page import="java.io.BufferedWriter" %>
<%@ page import="java.io.File" %>
<%@ page import="java.io.FileWriter" %>
<%@ page import="com.weavernorth.caibai.orgsyn.vo.CbHrmResource" %>
<%@ page import="java.io.IOException" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%
    BaseBean baseBean = new BaseBean();
    String currentTimeString = com.weaver.general.TimeUtil.getCurrentTimeString().replace(":", "");
    BufferedWriter bufferedWriter = null;
    try {
        String outTxtPath = File.separator + "usr" + File.separator + "weavercs" + File.separator + "ecology"
                + File.separator + "orgLog" + File.separator + currentTimeString + ".txt";
        baseBean.writeLog("输出路径： " + outTxtPath);
        File file = new File(outTxtPath);
        if (!file.getParentFile().exists()) {
            file.getParentFile().mkdirs();
        }
        bufferedWriter = new BufferedWriter(new FileWriter(file));
        for (int i = 0; i < 100; i++) {
            bufferedWriter.write("牛智萌txt： " + i);
            bufferedWriter.newLine();
        }

        bufferedWriter.flush();
    } catch (IOException e) {
        baseBean.writeLog("org输出TXT异常： " + e);
    } finally {
        try {
            if (bufferedWriter != null) {
                bufferedWriter.close();
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

%>


















