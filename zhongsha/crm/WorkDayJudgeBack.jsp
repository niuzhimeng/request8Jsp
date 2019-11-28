<%@ page import="com.alibaba.fastjson.JSONObject" %>
<%@ page import="weaver.conn.RecordSet" %>
<%@ page import="weaver.general.BaseBean" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Calendar" %>
<%@ page import="java.util.Date" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%
    String startDate = request.getParameter("startDateVal");
    String endDate = request.getParameter("endDateVal");

    JSONObject jsonObject = new JSONObject();
    jsonObject.put("startDate", ifxxr(startDate) ? 0 : 1);
    jsonObject.put("endDate", ifxxr(endDate) ? 0 : 1);

    out.clear();
    out.print(jsonObject.toJSONString());

%>

<%!
    /**
     * 是否为休息日
     */
    private boolean ifxxr(String yzDate) {
        if (yzDate == null || "".equals(yzDate)) {
            return false;
        }
        boolean flag = false;
        SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyy-MM-dd");
        try {
            // 检测双休日
            Date bdate = simpleDateFormat.parse(yzDate);
            Calendar cal = Calendar.getInstance();
            cal.setTime(bdate);
            if (cal.get(Calendar.DAY_OF_WEEK) == Calendar.SATURDAY || cal.get(Calendar.DAY_OF_WEEK) == Calendar.SUNDAY) {
                // 是休息日
                flag = true;
            }

            if (!flag) {
                // 检测节假日
                String selectSql = "select * from HrmPubHoliday where holidaydate = ('" + yzDate + "')";
                RecordSet recordSet = new RecordSet();
                recordSet.executeQuery(selectSql);
                // 假日类型 1、3为休息日
                String changeType = "";
                if (recordSet.next()) {
                    changeType = Util.null2String(recordSet.getString("changetype"));
                    if ("1".equals(changeType)) {
                        flag = true;
                    }
                }
            }
        } catch (Exception e) {
            new BaseBean().writeLog("WorkDayJudgeBack.jsp ifxxr()方法异常: " + e);
        }
        return flag;
    }
%>