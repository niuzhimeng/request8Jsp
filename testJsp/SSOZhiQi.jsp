<%@ page import="ln.LN" %>
<%@ page import="org.apache.commons.lang.StringUtils" %>
<%@ page import="weaver.conn.RecordSet" %>
<%@ page import="weaver.general.BaseBean" %>
<%@ page import="weaver.general.StaticObj" %>
<%@ page import="weaver.general.TimeUtil" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.hrm.OnLineMonitor" %>
<%@ page import="weaver.hrm.User" %>
<%@ page import="weaver.systeminfo.SysMaintenanceLog" %>
<%@ page import="java.util.Calendar" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Map" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<script type="text/javascript" src="/js/select/script/jquery-1.8.3.min_wev8.js"></script>
<%
    // 智企单点接收值
    BaseBean baseBean = new BaseBean();

    String Frusername = "";
    String frPwd = "";

    baseBean.writeLog("智企单点oa Start============ " + TimeUtil.getCurrentDateString());
    try {
        String userID = request.getParameter("userID");
        String userName = request.getParameter("userName");
        String PID = request.getParameter("PID");
        String pidAfter = "123";
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


        // 允许登录
        RecordSet rs = new RecordSet();
        rs.executeSql("select * from HrmResource where certificatenum = lower('" + pidAfter + "') and status < 4 and (accounttype !=1 or accounttype is null)");

        String workFlowUrl = "/wui/main.jsp?templateId=1";
        //检查license
        String currentPage = request.getServletPath().toLowerCase();
        if (!currentPage.toLowerCase().contains(("/system/inlicense.jsp")) && !currentPage.toLowerCase().contains(("/system/licenseoperation.jsp"))) {
            if (!currentPage.toLowerCase().contains(("/mobile/plugin/"))) {
                // 不是手机端调用接口，判断license
                Calendar today1 = Calendar.getInstance();
                String currentdate1 = Util.add0(today1.get(Calendar.YEAR), 4) + "-" + Util.add0(today1.get(Calendar.MONTH) + 1, 2) + "-" + Util.add0(today1.get(Calendar.DAY_OF_MONTH), 2);
                String message;
                LN ckLicense = new LN();
                message = ckLicense.CkLicense(currentdate1);
                if (!message.equals("1")) {
                    response.sendRedirect("/system/InLicense.jsp");
                    return;
                } else {
                    StaticObj.getInstance().putObject("isLicense", "true");
                }
            }
        }

        //登录名为空
        if (StringUtils.isBlank(pidAfter)) {
            response.sendRedirect("/login/Login.jsp?logintype=1");
        }
        User user_new;

        if (rs.next()) {
            baseBean.writeLog("rs.getString: " + rs.getString("lastname"));
            // OA有相关人员
            User user = (User) request.getSession(true).getAttribute("weaver_user@bean");
            // 用户session不存在 或者 用户session中的用户名和此次登录的用户名不一致，要重启构造用户session
            if (user == null || !user.getLoginid().equals(pidAfter)) {
                Frusername = rs.getString("loginid");
                frPwd = rs.getString("password");
                //用户登录
                user_new = new User();
                user_new.setUid(rs.getInt("id"));
                user_new.setLoginid(rs.getString("loginid"));
                user_new.setFirstname(rs.getString("firstname"));
                user_new.setLastname(rs.getString("lastname"));
                user_new.setAliasname(rs.getString("aliasname"));
                user_new.setTitle(rs.getString("title"));
                user_new.setTitlelocation(rs.getString("titlelocation"));
                user_new.setSex(rs.getString("sex"));
                user_new.setPwd(rs.getString("password"));
                String languageidweaver = rs.getString("systemlanguage");
                user_new.setLanguage(Util.getIntValue(languageidweaver, 0));
                user_new.setTelephone(rs.getString("telephone"));
                user_new.setMobile(rs.getString("mobile"));
                user_new.setMobilecall(rs.getString("mobilecall"));
                user_new.setEmail(rs.getString("email"));
                user_new.setCountryid(rs.getString("countryid"));
                user_new.setLocationid(rs.getString("locationid"));
                user_new.setResourcetype(rs.getString("resourcetype"));
                user_new.setStartdate(rs.getString("startdate"));
                user_new.setEnddate(rs.getString("enddate"));
                user_new.setContractdate(rs.getString("contractdate"));
                user_new.setJobtitle(rs.getString("jobtitle"));
                user_new.setJobgroup(rs.getString("jobgroup"));
                user_new.setJobactivity(rs.getString("jobactivity"));
                user_new.setJoblevel(rs.getString("joblevel"));
                user_new.setSeclevel(rs.getString("seclevel"));
                user_new.setUserDepartment(Util.getIntValue(rs.getString("departmentid"), 0));
                user_new.setUserSubCompany1(Util.getIntValue(rs.getString("subcompanyid1"), 0));
                user_new.setUserSubCompany2(Util.getIntValue(rs.getString("subcompanyid2"), 0));
                user_new.setUserSubCompany3(Util.getIntValue(rs.getString("subcompanyid3"), 0));
                user_new.setUserSubCompany4(Util.getIntValue(rs.getString("subcompanyid4"), 0));
                user_new.setManagerid(rs.getString("managerid"));
                user_new.setAssistantid(rs.getString("assistantid"));
                user_new.setPurchaselimit(rs.getString("purchaselimit"));
                user_new.setCurrencyid(rs.getString("currencyid"));
                user_new.setLastlogindate(rs.getString("currentdate"));
                user_new.setLogintype("1");
                user_new.setAccount(rs.getString("account"));

                user_new.setLoginip(request.getRemoteAddr());
                request.getSession(true).setMaxInactiveInterval(60 * 60 * 24);
                request.getSession(true).setAttribute("weaver_user@bean", user_new);
                request.getSession(true).setAttribute("browser_isie", getisIE(request));

                request.getSession(true).setAttribute("moniter", new OnLineMonitor("" + user_new.getUID(), user_new.getLoginip()));
                Util.setCookie(response, "loginfileweaver", "/main.jsp", 172800);
                Util.setCookie(response, "loginidweaver", "" + user_new.getUID(), 172800);
                Util.setCookie(response, "languageidweaver", languageidweaver, 172800);

                Map logmessages = (Map) application.getAttribute("logmessages");
                if (logmessages == null) {
                    logmessages = new HashMap();
                    logmessages.put(String.valueOf(user_new.getUID()), "");
                    application.setAttribute("logmessages", logmessages);
                }

                request.getSession(true).setAttribute("logmessage", getLogMessage(String.valueOf(user_new.getUID())));

                // 登录日志
                SysMaintenanceLog log1 = new SysMaintenanceLog();
                log1.resetParameter();
                log1.setRelatedId(rs.getInt("id"));
                log1.setRelatedName((rs.getString("firstname") + " " + rs.getString("lastname")).trim());
                log1.setOperateType("6");
                log1.setOperateDesc("");
                log1.setOperateItem("60");
                log1.setOperateUserid(rs.getInt("id"));
                log1.setClientAddress(request.getRemoteAddr());
                try {
                    log1.setSysLogInfo();
                } catch (Exception e) {
                    e.printStackTrace();
                }

            } else {
                user_new = user;
            }

            //response.sendRedirect(workFlowUrl);

        } else {
            // OA中查无此人，必须重新登录
            baseBean.writeLog("OA中查无此人==================");
            response.sendRedirect("/login/Login.jsp?logintype=1");
        }


    } catch (Exception e) {
        baseBean.writeLog("智企单点OA异常： " + e);
    }

    baseBean.writeLog("智企单点oa End============  " + TimeUtil.getCurrentDateString());

%>

<%!
    /**
     * 获取日志信息
     */
    private String getLogMessage(String uid) {
        String message = "";
        RecordSet rs = new RecordSet();
        String sqltmp = "";
        if (rs.getDBType().equals("oracle")) {
            sqltmp = "select * from (select * from SysMaintenanceLog where relatedid = " + uid + " and operatetype='6' and operateitem='60' order by id desc ) where rownum=1 ";
        } else if (rs.getDBType().equals("db2")) {
            sqltmp = "select * from SysMaintenanceLog where relatedid = " + uid + " and operatetype='6' and operateitem='60' order by id desc fetch first 1 rows only ";
        } else if (rs.getDBType().equals("mysql")) {
            sqltmp = "SELECT t2.* FROM (SELECT * FROM SysMaintenanceLog WHERE relatedid = " + uid + " and  operatetype='6' AND operateitem='60' ORDER BY id DESC) t2  LIMIT 1 ,1";
        } else {
            sqltmp = "select top 1 * from SysMaintenanceLog where relatedid = " + uid + " and operatetype='6' and operateitem='60' order by id desc";
        }

        rs.executeSql(sqltmp);
        if (rs.next()) {
            message = rs.getString("clientaddress") + " " + rs.getString("operatedate") + " " + rs.getString("operatetime");
        }

        return message;
    }

    /**
     * 判断浏览器是否为IE
     *
     * @param request
     * @return
     */
    private String getisIE(HttpServletRequest request) {
        String isIE = "true";
        String agent = request.getHeader("User-Agent").toLowerCase();
        if (!agent.contains("rv:11") && !agent.contains("msie")) {
            isIE = "false";
        }
        if (agent.contains("rv:11") || agent.indexOf("msie") > -1) {
            isIE = "true";
        }
        return isIE;
    }
%>
<script language="JavaScript">
    function loginFR() {
        var username = "<%=Frusername%>";//获取用户名
        var password = "<%=frPwd%>";//获取密码
        <%--var url = "http://localhost:8080/webroot/decision/login/cross/domain" + "?fine_username=" + username + "&fine_password=" + password + "&validity=" + -1;--%>
        <%--jQuery.ajax({--%>
        <%--    url: url,//单点登录的管理平台报表服务器--%>
        <%--    timeout: 5000,//超时时间（单位：毫秒）--%>
        <%--    dataType: "jsonp",//跨域采用jsonp方式--%>
        <%--    jsonp: "callback",--%>
        <%--    async: false,--%>
        <%--    success: function (res) {--%>
        <%--        console.log(res);--%>
        <%--        if (res.errorCode) {--%>
        <%--            console.log(res.errorCode);--%>
        <%--        } else {--%>
        <%--            // 保存token并跳转到对应链接--%>
        <%--            console.log("登录成功");--%>
        <%--        }--%>
        <%--    },--%>
        <%--    error: function () {--%>
        <%--        console.log("超时或服务器其他错误");// 登录失败（超时或服务器其他错误）--%>
        <%--    }--%>
        <%--});--%>
        alert(username)
        alert(password)
        window.location = '/wui/main.jsp?templateId=1';

    }

    loginFR();
</script>

