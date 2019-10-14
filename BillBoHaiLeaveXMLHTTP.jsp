<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<%@ page import="weaver.hrm.HrmUserVarify" %>
<%@ page import="weaver.hrm.User" %>
<%@ page import="weaver.systeminfo.SystemEnv" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.hrm.attendance.domain.*" %>
<%@ page import="weaver.hrm.schedule.HrmAnnualManagement" %>
<%@ page import="weaver.hrm.schedule.HrmPaidSickManagement" %>
<%@ page import="weaver.hrm.schedule.manager.HrmScheduleManager" %>
<%@ page import="weaver.general.TimeUtil" %>
<%@ page import="weaver.conn.RecordSet" %>
<%@ page import="weaver.general.BaseBean" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="strUtil" class="weaver.common.StringUtil" scope="page"/>
<jsp:useBean id="dateUtil" class="weaver.common.DateUtil" scope="page"/>
<jsp:useBean id="HrmScheduleDiffUtil" class="weaver.hrm.report.schedulediff.HrmScheduleDiffUtil" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="paidLeaveTimeManager" class="weaver.hrm.attendance.manager.HrmPaidLeaveTimeManager" scope="page"/>
<jsp:useBean id="attProcSetManager" class="weaver.hrm.attendance.manager.HrmAttProcSetManager" scope="page"/>
<jsp:useBean id="attVacationManager" class="weaver.hrm.attendance.manager.HrmAttVacationManager" scope="page"/>

<%

    User user = HrmUserVarify.getUser(request, response);
    if (user == null) return;
    String returnString = "";
    String operation = Util.null2String(request.getParameter("operation"));

//检查其它请假类型是否可行
    if ("checkOtherLeaveType".equals(operation)) {
        int leaveType = Util.getIntValue(request.getParameter("leaveType"), 0);
        int otherLeaveType = Util.getIntValue(request.getParameter("otherLeaveType"), 0);
        int resourceId = Util.getIntValue(request.getParameter("resourceId"), 0);
        String fromDate = Util.null2String(request.getParameter("fromDate"));
        String fromYear = "";
        if (fromDate.length() >= 4) {
            fromYear = fromDate.substring(0, 4);
        }

        int requestId = Util.getIntValue(request.getParameter("requestId"), 0);

        StringBuffer sb = new StringBuffer();
        sb.append(" select 1 ")
                .append("   from Bill_BoHaiLeave b ")
                .append("  where b.resourceId=").append(resourceId)
                .append("    and b.otherLeaveType=").append(otherLeaveType == 1 ? 2 : 1)
                .append("    and (b.leaveType=3  or b.leaveType=4) ");

        if (!fromYear.equals("")) {
            sb.append(" and b.fromDate like '").append(fromYear).append("%'");
        }

        if (requestId > 0) {
            sb.append(" and b.requestId<>" + requestId);
        }

        RecordSet.executeSql(sb.toString());
        if (RecordSet.next()) {
            returnString += "false";
        } else {
            returnString += "true";
        }
    } else if ("getLeaveDays".equals(operation)) {//根据起始日期、起始时间、结束日期、结束时间获得请假天数
        returnString = new HrmScheduleManager(request, response).getLeaveDays();
    }
    /*
     * 年假信息
     * 返回值前需要加-》 getAnnualInfo#
     *  SystemEnv.getHtmlLabelName(21614, user.getLanguage()) -> 上一年可请年假天数
     *  SystemEnv.getHtmlLabelName(21615, user.getLanguage()) -> 今年剩余年假天数
     *  SystemEnv.getHtmlLabelName(21616, user.getLanguage()) -> 当前可请年假天数
     */

    if ("getAnnualInfo".equals(operation)) {
        //请假人id
        String resourceId = Util.null2String(request.getParameter("resourceId"));
        //当前年月 2018-06-17
        String currentDate = Util.null2String(request.getParameter("currentDate"));
        String userannualinfo = null;
        try {
            userannualinfo = HrmAnnualManagement.getUserAannualInfo(resourceId, currentDate);
        } catch (Exception e) {
            e.printStackTrace();
        }
        //上一年可请标准年假天数
        String lastyearannual = Util.TokenizerString2(userannualinfo, "#")[1];
        //今年剩余标准年假天数
        String thisyearannual = Util.TokenizerString2(userannualinfo, "#")[0];
        //当前可请年假天数
        String allannual = Util.TokenizerString2(userannualinfo, "#")[2];
        float[] freezeDays = attVacationManager.getFreezeDays(resourceId);
        if (freezeDays[0] > 0) allannual += " - " + freezeDays[0];

        //奖励 可用年假
        RecordSet jlSet = new RecordSet();
        jlSet.execute("SELECT * FROM uf_annualLeave WHERE unuseddate > (select CONVERT(varchar(30),getdate(),23)) AND ryid = '" + resourceId + "'");
        Float currentTx = 0f;//今年奖励年假天数
        Float lastTx = 0f;//去年奖励年假天数
        while (jlSet.next()) {
            if (currentDate.substring(0, 4).equals(jlSet.getString("annualyear").trim())) {
                //今年的调休天数
                currentTx += jlSet.getFloat("annualdays");
            } else {
                //上一年的调休天数
                lastTx += jlSet.getFloat("annualdays");
            }
        }
        //今年剩余年假天数
        Float allthisyearannual = Float.valueOf(thisyearannual) + currentTx;
        //上一年可请年假天数
        Float alllastyearannual = Float.valueOf(lastyearannual) + lastTx;
        //计算可用年假
        Float canUseCount = useCount(allthisyearannual + alllastyearannual, currentDate);
        //returnString = "getAnnualInfo#"+SystemEnv.getHtmlLabelName(21614,user.getLanguage())+"&nbsp;:&nbsp;"+lastyearannual+"<br>"+SystemEnv.getHtmlLabelName(21615,user.getLanguage())+"&nbsp;:&nbsp;"+thisyearannual+"<br>"+SystemEnv.getHtmlLabelName(21616,user.getLanguage())+"&nbsp;:&nbsp;"+String.valueOf(big);
        returnString = "getAnnualInfo#上一年可请年假天数&nbsp;:&nbsp;" + alllastyearannual.toString() + "<br>今年剩余年假天数&nbsp;:&nbsp;" + allthisyearannual.toString() + "<br>当前可请年假天数&nbsp;:&nbsp;" + canUseCount.toString();
    }


    if ("getPSInfo".equals(operation)) {
        String resourceId = Util.null2String(request.getParameter("resourceId"));
        String currentDate = Util.null2String(request.getParameter("currentDate"));
        String userpslinfo = HrmPaidSickManagement.getUserPaidSickInfo(resourceId, currentDate);
        String thisyearpsldays = "" + Util.getFloatValue(Util.TokenizerString2(userpslinfo, "#")[0], 0);
        String lastyearpsldays = "" + Util.getFloatValue(Util.TokenizerString2(userpslinfo, "#")[1], 0);
        String allpsldays = "" + Util.getFloatValue(Util.TokenizerString2(userpslinfo, "#")[2], 0);
        float[] freezeDays = attVacationManager.getFreezeDays(resourceId);
        if (freezeDays[1] > 0) allpsldays += " - " + freezeDays[1];
        returnString = "getPSInfo#" + SystemEnv.getHtmlLabelName(24039, user.getLanguage()) + "&nbsp;:&nbsp;" + lastyearpsldays + "<br>" + SystemEnv.getHtmlLabelName(24040, user.getLanguage()) + "&nbsp;:&nbsp;" + thisyearpsldays + "<br>" + SystemEnv.getHtmlLabelName(24041, user.getLanguage()) + "&nbsp;:&nbsp;" + allpsldays;

    }

    if ("getTXInfo".equals(operation)) {
        String resourceId = Util.null2String(request.getParameter("resourceId"));
        String currentDate = Util.null2String(request.getParameter("currentDate"));
        String paidLeaveDays = String.valueOf(paidLeaveTimeManager.getCurrentPaidLeaveDaysByUser(resourceId, currentDate));
        float[] freezeDays = attVacationManager.getFreezeDays(resourceId);
        if (freezeDays[2] > 0) paidLeaveDays += " - " + freezeDays[2];
        returnString = "getTXInfo#" + SystemEnv.getHtmlLabelName(82854, user.getLanguage()) + "&nbsp;:&nbsp;" + paidLeaveDays;
    }

    if ("initInfo".equals(operation)) {
        String resourceId = Util.null2String(request.getParameter("resourceId"));
        String currentDate = Util.null2String(request.getParameter("currentDate"));
        String bohai = Util.null2String(request.getParameter("bohai"));
        int nodetype = strUtil.parseToInt(Util.null2String(request.getParameter("nodetype")));
        int workflowid = strUtil.parseToInt(Util.null2String(request.getParameter("workflowid")));
        String userannualinfo = HrmAnnualManagement.getUserAannualInfo(resourceId, currentDate);
        String thisyearannual = Util.TokenizerString2(userannualinfo, "#")[0];
        String lastyearannual = Util.TokenizerString2(userannualinfo, "#")[1];
        String allannual = Util.TokenizerString2(userannualinfo, "#")[2];
        String userpslinfo = HrmPaidSickManagement.getUserPaidSickInfo(resourceId, currentDate);
        String thisyearpsldays = "" + Util.getFloatValue(Util.TokenizerString2(userpslinfo, "#")[0], 0);
        String lastyearpsldays = "" + Util.getFloatValue(Util.TokenizerString2(userpslinfo, "#")[1], 0);
        String allpsldays = "" + Util.getFloatValue(Util.TokenizerString2(userpslinfo, "#")[2], 0);
        String paidLeaveDays = String.valueOf(paidLeaveTimeManager.getCurrentPaidLeaveDaysByUser(resourceId, currentDate));
        //当前可请年假天数
        String allannualValue = allannual;
        String allpsldaysValue = allpsldays;
        String paidLeaveDaysValue = paidLeaveDays;
        float[] freezeDays = attVacationManager.getFreezeDays(resourceId);
        if (freezeDays[0] > 0) allannual += " - " + freezeDays[0];
        if (freezeDays[1] > 0) allpsldays += " - " + freezeDays[1];
        if (freezeDays[2] > 0) paidLeaveDays += " - " + freezeDays[2];

        float realAllannualValue = strUtil.parseToFloat(allannualValue, 0);
        float realAllpsldaysValue = strUtil.parseToFloat(allpsldaysValue, 0);
        float realPaidLeaveDaysValue = strUtil.parseToFloat(paidLeaveDaysValue, 0);

        if (bohai.equals("true")) {
            //影响前台
            realAllannualValue = (float) strUtil.round(realAllannualValue - freezeDays[0]);
            realAllpsldaysValue = (float) strUtil.round(realAllpsldaysValue - freezeDays[1]);
            realPaidLeaveDaysValue = (float) strUtil.round(realPaidLeaveDaysValue - freezeDays[2]);
        } else {
            if (attProcSetManager.isFreezeNode(workflowid, nodetype)) {
                realAllannualValue = (float) strUtil.round(realAllannualValue - freezeDays[0]);
                realAllpsldaysValue = (float) strUtil.round(realAllpsldaysValue - freezeDays[1]);
                realPaidLeaveDaysValue = (float) strUtil.round(realPaidLeaveDaysValue - freezeDays[2]);
            }
        }
        if (freezeDays[0] > 0) allannual += " - " + freezeDays[0];

        //==================================
        //奖励 可用年假
        RecordSet jlSet = new RecordSet();
        jlSet.execute("SELECT * FROM uf_annualLeave WHERE unuseddate > (select CONVERT(varchar(30),getdate(),23)) AND ryid = '" + resourceId + "'");
        Float currentTx = 0f;//今年奖励年假天数
        Float lastTx = 0f;//去年奖励年假天数
        while (jlSet.next()) {
            if (currentDate.substring(0, 4).equals(jlSet.getString("annualyear").trim())) {
                //今年的调休天数
                currentTx += jlSet.getFloat("annualdays");
            } else {
                //上一年的调休天数
                lastTx += jlSet.getFloat("annualdays");
            }
        }
        //今年剩余年假天数
        Float allthisyearannual = Float.valueOf(thisyearannual) + currentTx;
        //上一年可请年假天数
        Float alllastyearannual = Float.valueOf(lastyearannual) + lastTx;
        //计算可用年假
        Float canUseCount = useCount(allthisyearannual + alllastyearannual, currentDate);

        realAllannualValue = canUseCount;
        allannualValue = canUseCount.toString();
        returnString = allannualValue + "#" + allpsldaysValue + "#" + paidLeaveDaysValue + "#" + realAllannualValue + "#" + realAllpsldaysValue + "#" + realPaidLeaveDaysValue;

    }
%>


<%!
    /**
     * 计算标准年假可用天数
     *
     * @param allCount    总年假天数（去年剩余 + 今年）
     * @param currentDate 当前日期
     * @return 可用天数
     */
    private Float useCount(Float allCount, String currentDate) {
        String currentMonthFirst = currentDate.substring(0, 8) + "01";
        int diff = TimeUtil.dateInterval(currentMonthFirst, currentDate);
        Integer currentMonth;
        if (diff < 14) {
            //上月
            currentMonth = Integer.parseInt(currentDate.substring(5, 7));
            if (currentMonth == 1) {
                currentMonth = 12;
            } else {
                currentMonth--;
            }
        } else {
            //当月
            currentMonth = Integer.parseInt(currentDate.substring(5, 7));
        }
        Float use = allCount / 12 * currentMonth;
        //计算小数部分 规则为计算的年假天数小于0.4，年假天数为0天；大于等于0.4小于0.9，年假天数为0.5天；大于等于0.9，年假天数为1天。
        String[] split = String.valueOf(use).split("\\.");
        //整数部分
        Float big;
        big = Float.parseFloat(split[0]);
        Float little = Float.parseFloat("0." + split[1]);
        if (0.4 <= little && little < 0.9) {
            big += 0.5f;
        } else if (little >= 0.9) {
            big += 1;
        }
        return big;
    }
%>

<%=Util.toHtml(returnString)%>