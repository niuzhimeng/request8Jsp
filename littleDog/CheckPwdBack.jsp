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
    //校验密码
    if ("checkPwd".equals(request.getParameter("operation"))) {
        String pwd = request.getParameter("pwd");
        String id = request.getParameter("id");
        pwd = MD5(pwd);

        RecordSet recordSet = new RecordSet();
        String sql = "select * from money_check where id = '" + id + "' and pwd = '" + pwd + "'";
        recordSet.execute(sql);
        if (recordSet.next()) {
            out.write("y");
        } else {
            out.write("n");
        }
    } else {
        //修改密码
        String id = request.getParameter("id");
        String oldPwd = request.getParameter("oldPwd");
        String onePwd = request.getParameter("onePwd");
        String twoPwd = request.getParameter("twoPwd");
        oldPwd = MD5(oldPwd);
        RecordSet recordSet = new RecordSet();
        String sql = "select * from money_check where id = '" + id + "' and pwd = '" + oldPwd + "'";
        recordSet.execute(sql);
        if (!recordSet.next()) {
            //旧密码错误
            out.write("oldpwdErr");
            return;
        }
        if (!(onePwd.trim().equals(twoPwd.trim()))) {
            out.print("twicePwdErr");
            return;
        }
        onePwd = MD5(onePwd);
        RecordSet record = new RecordSet();
        record.execute("update money_check set pwd = '" + onePwd + "' where id = '" + id + "'");
        out.print("success");
    }

%>