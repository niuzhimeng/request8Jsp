<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="org.apache.commons.lang.StringUtils" %>
<%@ page import="weaver.general.TimeUtil" %>
<%@ page import="weaver.general.BaseBean" %>
<%@ page import="weaver.conn.RecordSet" %>

<%
    // 智企调用，返回待办xml
    BaseBean baseBean = new BaseBean();
    baseBean.writeLog("智企获取oa待办 Start============ " + TimeUtil.getCurrentDateString());
    String userID = request.getParameter("userID");
    String userName = request.getParameter("userName");
    String PID = request.getParameter("PID");
    String pidAfter = StringUtils.trim(PID);
    String sessionID = request.getParameter("sessionID");
    String WSUrl = request.getParameter("WSUrl");
    String verifySSO = request.getParameter("verifySSO");

    baseBean.writeLog("userID: " + userID);
    baseBean.writeLog("userName: " + userName);
    baseBean.writeLog("PID: " + PID);
    baseBean.writeLog("pidAfter: " + pidAfter);
    baseBean.writeLog("sessionID: " + sessionID);
    baseBean.writeLog("WSUrl: " + WSUrl);
    baseBean.writeLog("verifySSO: " + verifySSO);

    RecordSet rs = new RecordSet();
    rs.executeQuery("SELECT\n" +
            "\th.id,\n" +
            "\th.lastname,\n" +
            "\td.departmentname \n" +
            "FROM\n" +
            "\tHrmResource h\n" +
            "\tLEFT JOIN HrmDepartment d ON h.departmentid = d.id \n" +
            "WHERE\n" +
            "\tcertificatenum = lower( '" + pidAfter + "' ) \n" +
            "\tAND STATUS < 4 \n" +
            "\tAND ( accounttype != 1 OR accounttype IS NULL )");
    // 当前人id
    String uid = "";
    // 部门名称
    String depName = "";
    // 当前姓名
    String lastName = "";
    if (rs.next()) {
        uid = rs.getString("id");
        depName = rs.getString("departmentname");
        lastName = rs.getString("lastname");
    }
    baseBean.writeLog("当前人id： " + uid);
    baseBean.writeLog("当前人部门名称： " + depName);
    baseBean.writeLog("当前人姓名： " + lastName);

    // 查询待办的sql
    String toDoSql = "SELECT\n" +
            "\tt1.requestid,\n" +
            "\tt1.requestnamenew,\n" +
            "\tt2.receivedate + ' ' + t2.receivetime pjDate\n" +
            "FROM\n" +
            "\tworkflow_requestbase t1,\n" +
            "\tworkflow_currentoperator t2 \n" +
            "WHERE\n" +
            "\t( t1.deleted <> 1 OR t1.deleted IS NULL OR t1.deleted= '' ) \n" +
            "\tAND t1.requestid = t2.requestid \n" +
            "\tAND t2.userid IN ( " + uid + " ) \n" +
            "\tAND t2.usertype= 0 \n" +
            "\tAND ((\n" +
            "\tt2.isremark= 0 \n" +
            "\tAND ( t2.takisremark IS NULL OR t2.takisremark= 0 )) \n" +
            "\tOR t2.isremark IN ( '1', '5', '8', '9', '7' )) \n" +
            "\tAND ( t1.deleted= 0 OR t1.deleted IS NULL ) \n" +
            "\tAND t2.islasttimes= 1 \n" +
            "\tAND (\n" +
            "\tisnull( t1.currentstatus,- 1 ) = - 1 \n" +
            "\tOR (\n" +
            "\tisnull( t1.currentstatus,- 1 ) = 0 \n" +
            "\tAND t1.creater IN ( " + uid + " ))) \n" +
            "\t\n" +
            "\tAND t1.workflowid IN ( SELECT id FROM workflow_base WHERE ( isvalid = '1' OR isvalid = '3' ) )";
    baseBean.writeLog("查询待办的sql： " + toDoSql);

    rs.executeQuery(toDoSql);
    StringBuilder builder = new StringBuilder();
    builder.append("<?xml version=\"1.0\" encoding=\"utf-8\"?>\n" +
            "<list type=\"Mgs\" rowNum=\"" + rs.getCounts() + "\"> ");
    String oaurl = "";
    while (rs.next()) {
        oaurl = "http://10.88.161.21:8080/workflow/request/teZhong/OpenOAFlow.jsp?uid=" + uid + "&requestId=" + rs.getString("requestid");
        //oaurl = "http://localhost:8080/workflow/request/teZhong/OpenOAFlow.jsp?uid=" + uid + "&requestId=" + rs.getString("requestid");
        builder.append("<Mgs> \n" +
                "    <MgsFromDept>" + depName + "</MgsFromDept>  \n" +
                "    <MgsFromSys>OA 系统</MgsFromSys>  \n" +
                "    <MgsType></MgsType>  \n" +
                "    <MgsFunc>审批</MgsFunc>  \n" +
                "    <MgsMessage/>  \n" +
                "    <MgsFromName>" + lastName + "</MgsFromName>  \n" +
                "    <SentTime>" + rs.getString("pjDate") + "</SentTime>  \n" +
                "    <MgsUrgent>一般</MgsUrgent>  \n" +
                "    <MgsStatus/>  \n" +
                "    <MgsAccessory/>  \n" +
                "    <Title>" + rs.getString("requestnamenew") + "</Title>  \n" +
                "    <Url>" + oaurl + "</Url> \n" +
                "  </Mgs> ");
    }
    builder.append("</list>");
    baseBean.writeLog("返回的xml： " + builder.toString());

    baseBean.writeLog("智企获取oa待办 End============ " + TimeUtil.getCurrentDateString());
    out.clear();
    out.print(builder.toString());

%>

