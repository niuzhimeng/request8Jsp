<%@ page import="weaver.conn.RecordSet" %>
<%@ page language="java" contentType="text/html; charset=GBK" %>
<jsp:useBean id="RequestManager" class="weaver.workflow.request.RequestManager" scope="page"/>
<jsp:useBean id="flowDocss" class="weaver.workflow.request.RequestDoc" scope="session"/>
<jsp:useBean id="DocComInfo" class="weaver.docs.docs.DocComInfo" scope="page"/>
<jsp:useBean id="Doccoder" class="weaver.docs.docs.DocCoder" scope="page"/>


<%
    RecordSet recordSet = new RecordSet();
    recordSet.execute("select * from mlc");

    RecordSet rs = new RecordSet();

    String ygid;
    String bm;
    while (recordSet.next()) {
        ygid = recordSet.getString("ygid");
        bm = recordSet.getString("bm");
        while (bm.endsWith(">")) {
            bm = bm.substring(0, bm.length() - 1);
        }
        rs.execute("update mlc set bm = '" + bm + "' where ygid = '" + ygid + "'");
    }

    out.clear();
    out.print("Íê³É");


%>



