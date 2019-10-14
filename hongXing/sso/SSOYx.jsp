<%@ page import="weaver.conn.RecordSetDataSource" %>
<%@ page import="java.io.OutputStream" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>

<%
    // 单点邮箱系统
    BaseBean baseBean = new BaseBean();
    RecordSetDataSource recordSet = new RecordSetDataSource("orcl");
    recordSet.execute("select * from cus_fielddata where id = " + user.getUID());
    String loginid = "";
    if (recordSet.next()) {
        loginid = recordSet.getString("field8"); // 人员自定义字段
    }

    String tempDir = hongXingSSO(loginid); // 获取单点令牌
    String url = "http://mail.redstarwine.com/sm501/src/index.php?tmpdir=" + tempDir;
    baseBean.writeLog(TimeUtil.getCurrentTimeString() + " 单点邮箱系统访问url： " + url);
    response.sendRedirect(url);

%>

<%!
    private String hongXingSSO(String user) {
        String host = "http://119.97.139.99/cgi-bin/welfax/loginsm.cgi"; // 改成实际邮件服务器域名或 IP
        String pass = "Redstar#0805";

        BaseBean baseBean = new BaseBean();
        try {
            URL url = new URL(host);
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setDoOutput(true);
            conn.setRequestMethod("POST");
            conn.setInstanceFollowRedirects(false); // 禁止自动重定向
            String param = "safemailer=1"
                    + "&user2=" + URLEncoder.encode(user, "utf-8")
                    + "&pass2=" + URLEncoder.encode(pass, "utf-8");
            OutputStream os = conn.getOutputStream();
            os.write(param.getBytes());
            os.flush();
            os.close();

            /* 用户名和密码是否匹配要根据 HTTP 头中的 X­Tmpdir 来判断 */
            String tmpdir = conn.getHeaderField("X-Tmpdir");
            if (tmpdir == null) {
                baseBean.writeLog("Login failed" + TimeUtil.getCurrentTimeString() + ", 登录邮箱系统失败， 返回tmpdir为空。");
                return null;
            }
            return tmpdir;
        } catch (Exception e) {
            e.printStackTrace();
            baseBean.writeLog("单点邮箱系统异常 : " + TimeUtil.getCurrentTimeString() + ", " + e);
            return null;
        }
    }
%>





