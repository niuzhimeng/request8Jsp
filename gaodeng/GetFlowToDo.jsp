<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="com.alibaba.fastjson.JSONArray" %>
<%@ page import="com.alibaba.fastjson.JSONObject" %>
<%@ page import="weaver.conn.RecordSet" %>
<%@ page import="weaver.general.BaseBean" %>
<%@ page import="weaver.general.TimeUtil" %>
<%@ page import="weaver.general.MD5" %>

<%
    // 门户系统，返回待办json
    BaseBean baseBean = new BaseBean();

    try {
        String flowStr = "OA_TODO_FLOW";
        String loginId = request.getParameter("loginId");
        String token = request.getParameter("token");
        String currentTime = request.getParameter("currentTime");

        baseBean.writeLog("门户系统获取oa待办 Start============ " + " " + TimeUtil.getCurrentTimeString());
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

        // 查询待办的sql
        String toDoSql = "SELECT\n" +
                "  t1.requestid,\n" +
                "  t1.requestnamenew,\n" +
                "  t1.creater,\n" +
                "  t2.receivedate || ' ' || t2.receivetime pjDate \n" +
                //"  t2.receivedate + t2.receivetime pjDate \n" +
                "FROM\n" +
                "  workflow_requestbase t1,\n" +
                "  workflow_currentoperator t2 \n" +
                "WHERE\n" +
                "  t1.requestid = t2.requestid \n" +
                "  AND t2.usertype = 0 \n" +
                "  AND t2.userid = '" + myUid + "' \n" +
                "  AND t2.isremark IN ( '0','1', '5', '8', '9', '7' ) \n" +
                "  AND t2.islasttimes = 1 \n" +
                "  AND ( t1.deleted <> 1 OR t1.deleted IS NULL OR t1.deleted = '' ) \n" +
                "ORDER BY\n" +
                "  t2.receivedate DESC,\n" +
                "  t2.receivetime DESC";
        baseBean.writeLog("查询待办的sql： " + toDoSql);

        rs.executeQuery(toDoSql);
        int counts = rs.getCounts();
        JSONObject jsonObjectAll = new JSONObject();
        JSONArray jsonArray = new JSONArray();
        String oaUrl = "";
        RecordSet hrmSet = new RecordSet();

        while (rs.next()) {
            oaUrl = "http://gjoa.hep.cn/gaodeng?forwardUrl=workflow/request/gaodeng/OpenOAFlowBySSO.jsp?requestId=" + rs.getString("requestid");
            JSONObject jsonObject = new JSONObject();
            jsonObject.put("requestId", rs.getString("requestid"));
            jsonObject.put("requestName", rs.getString("requestnamenew"));
            String[] creaters = hrmInfo(hrmSet, rs.getString("creater"));
            jsonObject.put("personName", creaters[0]); //创建者姓名
            jsonObject.put("depName", creaters[1]); // 创建者部门
            jsonObject.put("receiveDate", rs.getString("pjDate"));
            jsonObject.put("openUrl", oaUrl);
            jsonObject.put("fromSys", "OA");

            jsonArray.add(jsonObject);
        }
        jsonObjectAll.put("status", "0");
        jsonObjectAll.put("message", "认证成功。");
        jsonObjectAll.put("allCount", counts);
        jsonObjectAll.put("flowInfo", jsonArray);

        baseBean.writeLog("返回的xml： " + jsonObjectAll.toJSONString());

        baseBean.writeLog("门户获取oa待办 End============ " + TimeUtil.getCurrentTimeString());
        response.setHeader("Content-Type", "application/json;charset=UTF-8");
        out.clear();
        out.print(jsonObjectAll.toJSONString());
    } catch (Exception e) {
        baseBean.writeLog("GetFlowToDo.jsp获取待办异常：" + e);
    }
%>

<%!
    private String[] hrmInfo(RecordSet recordSet, String hrmId) {
        String[] returnInfo = new String[2];
        recordSet.executeQuery("select h.lastname, d.departmentname from hrmresource h left join HrmDepartment d on h.departmentid = d.id where h.id = " + hrmId);
        recordSet.next();

        returnInfo[0] = recordSet.getString("lastname");
        returnInfo[1] = recordSet.getString("departmentname");
        return returnInfo;
    }
%>