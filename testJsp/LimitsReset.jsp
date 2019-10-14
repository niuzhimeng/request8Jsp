<%@ page import="com.alibaba.fastjson.JSON" %>
<%@ page import="com.alibaba.fastjson.JSONObject" %>
<%@ page import="weaver.formmode.exttools.impexp.log.LogRecordService" %>
<%@ page import="weaver.conn.RecordSet" %>
<%@ page import="weaver.formmode.setup.ModeRightInfo" %>
<%@ page import="weaver.conn.ConnStatement" %>
<%@ page import="java.sql.SQLException" %>
<%@ page import="com.weaver.general.TimeUtil" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<jsp:useBean id="RequestManager" class="weaver.workflow.request.RequestManager" scope="page"/>
<jsp:useBean id="flowDocss" class="weaver.workflow.request.RequestDoc" scope="session"/>
<jsp:useBean id="DocComInfo" class="weaver.docs.docs.DocComInfo" scope="page"/>
<jsp:useBean id="Doccoder" class="weaver.docs.docs.DocCoder" scope="page"/>


<%
    //建模历史数据赋权限，让查询可见
    //模块id
    Integer formmodeid = 8;
    //表名
    String tableName = "uf_annualLeave";

    String insertDate = TimeUtil.getCurrentTimeString().substring(0, 10);
    String insertTime = TimeUtil.getCurrentTimeString().substring(11);
    RecordSet recordSet = new RecordSet();
    recordSet.execute("select id from " + tableName + " where formmodeid is null");
    ConnStatement statement = new ConnStatement();
    String sql = "update " + tableName + " set  formmodeid = '" + formmodeid + "',modedatacreater = 1,modedatacreatertype = 0," +
            "modedatacreatedate = '" + insertDate + "', modedatacreatetime = '" + insertTime + "' where id = ?";
    try {
        statement.setStatementSql(sql);
        int id;
        while (recordSet.next()) {
            id = recordSet.getInt("id");
            statement.setInt(1, id);
            statement.executeUpdate();

            ModeRightInfo modeRightInfo = new ModeRightInfo();
            modeRightInfo.setNewRight(true);
            modeRightInfo.editModeDataShare(1, formmodeid, id);
        }
    } catch (SQLException e) {
        e.getErrorCode();
    } finally {
        statement.close();
    }
    out.print("权限设置成功");

%>


