<%@ page import="weaver.conn.RecordSet" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<%
    RecordSet recordSet = new RecordSet();
    recordSet.executeQuery("SELECT * FROM formtable_main_47 where id = 139");
    recordSet.next();

    int shrjdh = recordSet.getInt("shrjdh");


    out.clear();
    out.print("shrjdh:  " + shrjdh);

%>





















