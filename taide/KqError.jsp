<%@ page import="weaver.conn.RecordSet" %>
<%@ page import="weaver.soa.workflow.request.RequestInfo" %>
<%@ page import="com.weavernorth.taide.kaoQin.action.Gcsq03" %>
<%@ page import="com.weavernorth.taide.kaoQin.action.Qjsq02" %>
<%@ page import="com.weavernorth.taide.kaoQin.action.Jbsq01" %>
<%@ page import="com.weavernorth.taide.kaoQin.action.Kqbt04" %>
<%@ page import="weaver.workflow.request.RequestManager" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>


<%
    BaseBean baseBean = new BaseBean();

    // '2002'."人事公出；'2001'."人事请假；'2005'."人事加班； '2010'."补贴次数
    RecordSet recordSet = new RecordSet();
    recordSet.executeQuery("select * from uf_kqerror where kq04 = 1"); // 0是 1否
    // recordSet.executeQuery("select * from uf_kqerror where kq03 = 2002"); // 只查询公出的
    baseBean.writeLog("处理异常信息，" + TimeUtil.getCurrentTimeString() + " 条数为： " + recordSet.getCounts());
    try {
        RequestInfo requestInfo = new RequestInfo();
        RequestManager requestManager = new RequestManager();
        requestInfo.setRequestManager(requestManager);

        Gcsq03 gcsq03 = new Gcsq03();
        Qjsq02 qjsq02 = new Qjsq02();
        Jbsq01 jbsq01 = new Jbsq01();
        Kqbt04 kqbt04 = new Kqbt04();

        RecordSet updateSet = new RecordSet();
        while (recordSet.next()) {
            String tableName = recordSet.getString("kq01");
            String requestId = recordSet.getString("kq02");
            baseBean.writeLog("requestid： " + requestId);
            String flag = recordSet.getString("kq03");

            requestInfo.setRequestid(requestId);
            requestInfo.getRequestManager().setSrc("submit");
            requestInfo.getRequestManager().setBilltablename(tableName);

            switch (flag) {
                case "2002":
                    gcsq03.execute(requestInfo);
                    break;
                case "2001":
                    qjsq02.execute(requestInfo);
                    break;
                case "2005":
                    jbsq01.execute(requestInfo);
                    break;
                case "2010":
                    kqbt04.execute(requestInfo);
                    break;
            }
            updateSet.execute("update uf_kqerror set kq04 = 0 where kq02 = '" + requestId + "'");
        }
    } catch (Exception e) {
        baseBean.writeLog("处理异常报错： " + e);
        out.clear();
        out.print("yi chang : " + e);
    }

    out.clear();
    out.print("处理完成.");

%>