<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="com.alibaba.fastjson.JSONArray" %>
<%@ page import="com.alibaba.fastjson.JSONObject" %>
<%@ page import="weaver.conn.RecordSet" %>
<%@ page import="weaver.general.BaseBean" %>
<%@ page import="weaver.general.TimeUtil" %>
<%@ page import="weaver.general.MD5" %>
<%@ page import="weaver.general.Util" %>

<%
    // 门户系统，返回已办json
    BaseBean baseBean = new BaseBean();

    try {
        String flowStr = "OA_DONE_FLOW";
        String loginId = request.getParameter("loginId");
        String token = request.getParameter("token");
        String currentTime = request.getParameter("currentTime");
        String getCounts = request.getParameter("getCounts");

        String defaultCounts = "10";
        if (getCounts != null && !"".equals(getCounts)) {
            defaultCounts = getCounts;
        }
        int defaultInt = Util.getIntValue(defaultCounts, 10);

        baseBean.writeLog("门户系统获取oa已办 Start============ " + " " + TimeUtil.getCurrentTimeString());
        baseBean.writeLog("loginId: " + loginId);
        baseBean.writeLog("token: " + token);

        MD5 md5 = new MD5();

        String md5ofStr = md5.getMD5ofStr(currentTime + flowStr + loginId);
        baseBean.writeLog("oa加密token：" + md5ofStr);
        if (!md5ofStr.equals(token)) {
            JSONObject errObject = new JSONObject();
            errObject.put("status", "1");
            errObject.put("message", "认证失败。");
            out.clear();
            out.print(errObject.toJSONString());
            return;
        }

        RecordSet rs = new RecordSet();
        rs.executeQuery("SELECT\n" +
                "\th.id,\n" +
                "\th.lastname,\n" +
                "\td.departmentname \n" +
                "FROM\n" +
                "\tHrmResource h\n" +
                "\tLEFT JOIN HrmDepartment d ON h.departmentid = d.id \n" +
                "WHERE\n" +
                "\th.loginid = lower( '" + loginId + "' ) \n" +
                "\tAND STATUS < 4 \n" +
                "\tAND ( accounttype != 1 OR accounttype IS NULL )");
        // 部门名称
        String depName = "";
        // 当前姓名
        String lastName = "";
        int myUid;
        if (rs.next()) {
            myUid = rs.getInt("id");
            depName = rs.getString("departmentname");
            lastName = rs.getString("lastname");
        } else {
            JSONObject errObject = new JSONObject();
            errObject.put("status", "1");
            errObject.put("message", "登录名不存在。");
            out.clear();
            out.print(errObject.toJSONString());
            return;
        }
        baseBean.writeLog("当前人id： " + myUid);
        baseBean.writeLog("当前人部门名称： " + depName);
        baseBean.writeLog("当前人姓名： " + lastName);

        // 查询已办的sql
        String toDoSql = "SELECT \n" +
                "\tt1.requestid,\n" +
                "\tt1.requestnamenew,\n" +
                "  t2.receivedate || ' ' || t2.receivetime pjDate \n" +
                "FROM\n" +
                "\tworkflow_requestbase t1,\n" +
                "\tworkflow_currentoperator t2 \n" +
                "WHERE\n" +
                "\tt1.requestid = t2.requestid \n" +
                "\t AND t2.usertype = 0 \n" +
                "\tAND t2.userid = " + myUid + " \n" +
                "\tAND t2.isremark IN ( '2', '3', '4', '6' ) \n" +
                "\tAND t2.islasttimes = 1 \n" +
                "\tAND ( t1.deleted <> 1 OR t1.deleted IS NULL OR t1.deleted = '' ) \n" +
                "ORDER BY\n" +
                "\tt2.receivedate DESC,\n" +
                "\tt2.receivetime DESC";
        //baseBean.writeLog("查询已办的sql： " + toDoSql);

        rs.executeQuery(toDoSql);

        JSONObject jsonObjectAll = new JSONObject();
        JSONArray jsonArray = new JSONArray();
        String oaUrl = "";
        int allCount = 0;
        while (rs.next()) {
            if (allCount > defaultInt) {
                break;
            }
            oaUrl = "http://10.1.11.27/gaodeng?forwardUrl=workflow/request/gaodeng/OpenOAFlowBySSO.jsp?requestId=" + rs.getString("requestid");
            JSONObject jsonObject = new JSONObject();
            jsonObject.put("requestId", rs.getString("requestid"));
            jsonObject.put("requestName", rs.getString("requestnamenew"));
            jsonObject.put("depName", depName);
            jsonObject.put("personName", lastName);
            jsonObject.put("receiveDate", rs.getString("pjDate"));
            jsonObject.put("openUrl", oaUrl);
            jsonObject.put("fromSys", "OA");

            jsonArray.add(jsonObject);
            allCount++;
        }
        jsonObjectAll.put("status", "0");
        jsonObjectAll.put("message", "认证成功。");
        jsonObjectAll.put("allCount", allCount);
        jsonObjectAll.put("flowInfo", jsonArray);

        baseBean.writeLog("返回的xml： " + jsonObjectAll.toJSONString());

        baseBean.writeLog("门户获取oa已办 End============ " + TimeUtil.getCurrentTimeString());
        response.setHeader("Content-Type", "application/json;charset=UTF-8");
        out.clear();
        out.print(jsonObjectAll.toJSONString());
    } catch (Exception e) {
        baseBean.writeLog("GetFlowDone.jsp获取待办异常：" + e);
    }
%>

