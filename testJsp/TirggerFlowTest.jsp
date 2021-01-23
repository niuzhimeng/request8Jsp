<%@ page import="weaver.general.TimeUtil" %>
<%@ page import="weaver.workflow.webservices.*" %>
<%@ page import="java.util.Set" %>
<%@ page import="java.util.HashSet" %>
<%@ page import="java.util.Arrays" %>
<%@ page import="weaver.conn.RecordSet" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>

<%

    String userId = "150";

    String[] baseIds = {"-1", "1", "3"};
    Set<String> baseSet = new HashSet<String>(Arrays.asList(baseIds));

    Set<String> SelectSet = new HashSet<String>();

    RecordSet recordSet = new RecordSet();
    recordSet.executeQuery("select scopeid from CUS_FIELDDATA where id = " + userId);
    while (recordSet.next()) {
        SelectSet.add(recordSet.getString("scopeid"));
    }

    baseSet.removeAll(SelectSet);
    for (String s : baseSet) {
        recordSet.executeUpdate("insert into CUS_FIELDDATA(scope, scopeid, id)values(?,?,?)",
                "HrmCustomFieldByInfoType", s, userId);
    }

%>





