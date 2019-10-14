<%@ page import="weaver.conn.ConnStatement" %>
<%@ page import="weaver.conn.RecordSet" %>
<%@ page import="weaver.formmode.setup.ModeRightInfo" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>

<%
    BaseBean baseBean = new BaseBean();
    ConnStatement statement = new ConnStatement();
    ModeRightInfo moderightinfo = new ModeRightInfo();
    int modeId = 25;
    String currentTimeString = TimeUtil.getCurrentTimeString();
    int uid = user.getUID();
    try {

        String requestId = request.getParameter("requestId");
        baseBean.writeLog("TanChuBack.jsp 收到的requestId： " + requestId);
        RecordSet recordSet = new RecordSet();
        recordSet.executeQuery("select * from workflow_requestbase where requestid = '" + requestId + "'");
        if (recordSet.getCounts() <= 0) {
            out.clear();
            out.print("流程不存在。");
            return;
        }

        statement.setStatementSql("insert into uf_pltj (myId, myCurrent, createDate, status," +
                "formmodeid,modedatacreater,modedatacreatertype,modedatacreatedate,modedatacreatetime) values(?,?,?,?,?, ?,?,?,?)");
        statement.setString(1, requestId);
        statement.setString(2, "1");
        statement.setString(3, "2019-04-24");
        statement.setString(4, "0");

        statement.setInt(5, modeId);//模块id
        statement.setString(6, String.valueOf(uid));//创建人id
        statement.setString(7, "0");//一个默认值0
        statement.setString(8, com.weaver.general.TimeUtil.getCurrentTimeString().substring(0, 10));
        statement.setString(9, com.weaver.general.TimeUtil.getCurrentTimeString().substring(11));
        statement.executeUpdate();
    } catch (Exception e) {
        baseBean.writeLog("插入建模表 uf_pltj 异常： " + e);
    } finally {
        statement.close();
        //赋权
        moderightinfo.setNewRight(true);
        RecordSet maxSet = new RecordSet();
        maxSet.executeSql("select id from uf_pltj where MODEDATACREATEDATE + MODEDATACREATETIME >= '" + currentTimeString + "'");

        int maxId;
        while (maxSet.next()) {
            maxId = maxSet.getInt("id");
            moderightinfo.editModeDataShare(uid, modeId, maxId);//创建人id， 模块id， 该条数据id
        }

        out.clear();
        out.print("true");
    }


%>




