<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.conn.RecordSet" %>
<%@ page import="java.nio.charset.Charset" %>
<%@ page import="java.security.MessageDigest" %>
<%@ page import="java.security.NoSuchAlgorithmException" %>
<%!
    public String MD5(String content) {
        MessageDigest ins = null;
        try {
            ins = MessageDigest.getInstance("MD5");
        } catch (NoSuchAlgorithmException e) {
            e.printStackTrace();
        }
        ins.update(content.getBytes(Charset.forName("UTF-8")));
        char hexDigits[] = {'0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'a', 'b', 'c', 'd', 'e', 'f'};
        byte tmp[] = ins.digest();
        char str[] = new char[16 * 2];
        int k = 0;
        for (int i = 0; i < 16; i++) {
            byte byte0 = tmp[i];
            str[k++] = hexDigits[byte0 >>> 4 & 0xf];
            str[k++] = hexDigits[byte0 & 0xf];
        }
        return new String(str);
    }

%>
<%
    String loginId = request.getParameter("loginId");
    if ("checkStaff".equals(request.getParameter("operationType"))) {
        //检验员工信息
        RecordSet recordSet = new RecordSet();
        String sql = "select * from money_check where loginid = '" + loginId + "'";
        recordSet.execute(sql);
        if (!recordSet.next()) {
            out.write("n");
            return;
        }

        //姓名
        RecordSet recordHrmresource = new RecordSet();
        recordHrmresource.execute("select * from hrmresource where loginid = '" + loginId + "'");
        String name = "";
        if (recordHrmresource.next()) {
            name = recordHrmresource.getString("lastname");
        }
        //性别
        String sex;
        if ("0".equals(recordHrmresource.getString("sex"))) {
            sex = "男";
        } else {
            sex = "女";
        }
        String department = "";
        RecordSet recordDepartment = new RecordSet();
        recordDepartment.execute("select * from HrmDepartment where id = '" + recordHrmresource.getString("departmentid") + "'");
        if (recordDepartment.next()) {
            department = recordDepartment.getString("departmentname");
        }

        out.write("姓名：" + name + "， 性别：" + sex + "， 部门： " + department);
        return;
    }


    //重置密码
    String pwd = MD5("123456");
    RecordSet recordSet = new RecordSet();
    recordSet.execute("update money_check set pwd = '" + pwd + "' where loginid = '" + loginId + "'");
    out.print("success");
%>