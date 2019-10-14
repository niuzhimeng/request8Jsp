<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.conn.RecordSet" %>
<%@ page import="weaver.general.BaseBean" %>
<%@ page import="java.util.regex.Pattern" %>
<%@ page import="java.util.regex.Matcher" %>
<%@ page import="java.util.Arrays" %>
<%
    String flag = "y";
    BaseBean baseBean = new BaseBean();
    baseBean.writeLog("发票验重执行================");
    String check = request.getParameter("check").trim();
    baseBean.writeLog("check---------------------->" + check);
    String requestid = request.getParameter("requestid").trim();
    baseBean.writeLog("requestid-> " + requestid);
    //校验=================
    check = check.replaceAll("\\s*", "");
    if (!check.equals("")) {
        Pattern loginPattern = Pattern.compile("^\\d{8}(#\\d{8})*$");
        Matcher matcher = loginPattern.matcher(check);
        if (!matcher.matches()) {
            //格式错误
            out.write("formatErr");
            return;
        }
    }

    RecordSet recordSet = new RecordSet();
    if (check.contains("#")) {
        String[] splits = check.split("#");
        baseBean.writeLog("接收到的数据====》》》》" + Arrays.toString(splits));
        StringBuilder builder = new StringBuilder();
        for (String split : splits) {
            recordSet.execute("select * from formtable_main_27 where cgyy like '%" + split + "%' and requestId != '" + requestid + "'");
            if (recordSet.next()) {
                builder.append(split).append(", ");
            }
        }
        if (builder.length() > 2) {
            builder.deleteCharAt(builder.length() - 2);
            flag = "发票号码重复: " + builder.toString();
        }
    } else if (!"".equals(check)) {
        String sql = "select * from formtable_main_27 where cgyy like '%" + check + "%' and requestId != '" + requestid + "'";
        recordSet.execute(sql);
        if (recordSet.next()) {
            flag = "发票号码重复";
        }
    }
    out.write(flag);

%>