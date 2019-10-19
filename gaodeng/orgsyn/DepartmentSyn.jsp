<%@ page import="com.alibaba.fastjson.JSONArray" %>
<%@ page import="com.alibaba.fastjson.JSONObject" %>
<%@ page import="com.weavernorth.gaodeng.orgsyn.vo.GdHrmDepartment" %>
<%@ page import="weaver.conn.ConnStatement" %>
<%@ page import="weaver.conn.RecordSet" %>
<%@ page import="weaver.general.BaseBean" %>
<%@ page import="weaver.general.TimeUtil" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.hrm.company.DepartmentComInfo" %>
<%@ page import="java.io.BufferedReader" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%
    BaseBean baseBean = new BaseBean();
    // 部门同步
    baseBean.writeLog("部门同步 Start ========================= " + TimeUtil.getCurrentTimeString());
    try {
        long start = System.currentTimeMillis();
        String json = getPostData(request.getReader());
        baseBean.writeLog("接收到MDM数据 ========= " + json);
        JSONArray jsonArray = JSONObject.parseArray(json);
        int allCount = jsonArray.size();
        baseBean.writeLog("接收部门数量: " + allCount);
        List<GdHrmDepartment> departmentList = jsonArray.toJavaList(GdHrmDepartment.class);

        int departmentErrorCount = 1;
        for (int i = 0; i < 4; i++) {
            if (departmentErrorCount > 0) {
                departmentList = synHrmDepartment(departmentList, i);
            }
            departmentErrorCount = departmentList.size();
            baseBean.writeLog("待插入部门数量： " + departmentErrorCount);
        }

        // 结束时间戳
        long end = System.currentTimeMillis();
        long cha = (end - start) / 1000;

        String logStr = "部门信息同步完成，同步数量： " + allCount + ", 耗时：" + cha + " 秒。";
        // 插入日志
        //GdConnUtil.insertTimedLog("HrmDepartment", logStr, allCount);
    } catch (Exception e) {
        baseBean.writeLog("部门同步异常： " + e);
    }

%>

<%!

    private List<GdHrmDepartment> synHrmDepartment(List<GdHrmDepartment> departmentList, int count) {
        BaseBean baseBean = new BaseBean();
        baseBean.writeLog("第 " + count + " 次执行部门同步=========================");
        // departmentCode - id map
        Map<String, String> numIdMap = new HashMap<String, String>();
        RecordSet recordSet = new RecordSet();
        recordSet.executeQuery("select id, departmentcode from HrmDepartment");
        while (recordSet.next()) {
            if (!"".equals(recordSet.getString("departmentcode"))) {
                numIdMap.put(recordSet.getString("departmentcode"), recordSet.getString("id"));
            }
        }

        // 部门 - id 所属分部id
        Map<Integer, String> idSubIdMap = new HashMap<Integer, String>();
        recordSet.executeQuery("select id, subcompanyid1 from hrmdepartment");
        while (recordSet.next()) {
            if (!"".equals(recordSet.getString("subcompanyid1"))) {
                idSubIdMap.put(recordSet.getInt("id"), recordSet.getString("subcompanyid1"));
            }
        }

        // 分部编码 - id map
        recordSet.executeQuery("select SUBCOMPANYCODE, ID from HRMSUBCOMPANY");
        Map<String, String> subIdMap = new HashMap<String, String>(recordSet.getCounts() + 10);
        while (recordSet.next()) {
            if (!"".equalsIgnoreCase(recordSet.getString("SUBCOMPANYCODE").trim())) {
                subIdMap.put(recordSet.getString("SUBCOMPANYCODE"), recordSet.getString("ID"));
            }
        }

        List<GdHrmDepartment> insertHrmDepartments = new ArrayList<GdHrmDepartment>();
        List<GdHrmDepartment> updateHrmDepartments = new ArrayList<GdHrmDepartment>();
        List<GdHrmDepartment> errorHrmDepartments = new ArrayList<GdHrmDepartment>();
        for (GdHrmDepartment department : departmentList) {
            // 部门编码
            String depcode = Util.null2String(department.getDepcode()).trim();
            // 上级编码
            String supsubcode = Util.null2String(department.getSupsubcode()).trim();
            // 部门状态 Y有效，N无效
            String mhStatus = Util.null2String(department.getStatus()).trim();
            String status = "0";
            if ("N".equalsIgnoreCase(mhStatus)) {
                status = "1";
            }

            baseBean.writeLog("==========================");
            baseBean.writeLog("部门编码： " + depcode + ", 上级编码： " + supsubcode);
            baseBean.writeLog("部门名称： " + department.getDepname() + ", sap部门状态： " + department.getStatus());
            baseBean.writeLog("转换后部门状态： " + status);
            baseBean.writeLog("部门顺序： " + department.getShoworder());

            if ("".equals(depcode)) {
                baseBean.writeLog("部门编码为空，上级编码： " + supsubcode + "部门名称： " + department.getDepname());
                continue;
            }
            if ("".equals(supsubcode)) {
                baseBean.writeLog("部门编上级编码为空，部门编码： " + depcode + "部门名称： " + department.getDepname());
                continue;
            }
            if ("".equals(department.getDepname())) {
                baseBean.writeLog("部门名称为空，部门编码： " + depcode + "上级编码： " + supsubcode);
                continue;
            }

            int subCompanyId = Util.getIntValue(subIdMap.get(supsubcode), 0);
            if (subCompanyId > 0) {
                // 上级是分部
                department.setSupdepid("0");
                department.setSupsubid(String.valueOf(subCompanyId));
            } else {
                // 上级是部门
                int subDepId = Util.getIntValue(numIdMap.get(supsubcode), 0);
                if (subDepId <= 0) {
                    if (count >= 3) {
                        baseBean.writeLog("上级部门不存在，部门编码： " + depcode + ", 上级编码： " + supsubcode + "部门名称： " + department.getDepname());
                    }
                    errorHrmDepartments.add(department);
                    continue;
                }
                department.setSupdepid(String.valueOf(subDepId));
                department.setSupsubid(idSubIdMap.get(subDepId));
            }

            department.setStatusOa(status);

            if (numIdMap.get(depcode) == null) {
                insertHrmDepartments.add(department);
                numIdMap.put(depcode, "");
            } else {
                updateHrmDepartments.add(department);
            }

            baseBean.writeLog("新增部门数： " + insertHrmDepartments.size());
            insertHrmDepartment(insertHrmDepartments);

            baseBean.writeLog("更新部门数： " + updateHrmDepartments.size());
            updateHrmDepartment(updateHrmDepartments);

            new DepartmentComInfo().removeCompanyCache();

        }
        return errorHrmDepartments;
    }

    private static void insertHrmDepartment(List<GdHrmDepartment> insertHrmDepartments) {
        ConnStatement statement = new ConnStatement();
        try {
            String sql = "insert into HrmDepartment (departmentcode, departmentname, departmentmark," +
                    " subcompanyid1, supdepid, canceled, showorder) " +
                    "values (?,?,?,?,?,  ?,?)";
            statement.setStatementSql(sql);
            for (GdHrmDepartment department : insertHrmDepartments) {
                new BaseBean().writeLog(department.toString());
                statement.setString(1, department.getDepcode());
                statement.setString(2, department.getDepname());
                statement.setString(3, department.getDepname());
                statement.setString(4, department.getSupsubid());
                statement.setString(5, department.getSupdepid());
                statement.setString(6, department.getStatusOa());
                statement.setString(7, department.getShoworder());
                statement.executeUpdate();
            }
        } catch (Exception e) {
            new BaseBean().writeLog("insert department Exception :" + e);
        } finally {
            statement.close();
        }

    }

    /**
     * 更新部门
     */
    private static void updateHrmDepartment(List<GdHrmDepartment> insertHrmDepartments) {

        ConnStatement statement = new ConnStatement();
        try {
            String sql = "update HrmDepartment set  departmentname = ?, departmentmark = ?, subcompanyid1 = ?, supdepid = ?," +
                    " canceled = ?, showorder = ? where departmentcode = ?";
            statement.setStatementSql(sql);
            for (GdHrmDepartment hrmDepartment : insertHrmDepartments) {
                new BaseBean().writeLog(hrmDepartment.toString());
                statement.setString(1, hrmDepartment.getDepname());
                statement.setString(2, hrmDepartment.getDepname());
                statement.setString(3, hrmDepartment.getSupsubid());
                statement.setString(4, hrmDepartment.getSupdepid());
                statement.setString(5, hrmDepartment.getStatusOa());

                statement.setString(6, hrmDepartment.getShoworder());
                statement.setString(7, hrmDepartment.getDepcode());
                statement.executeUpdate();
            }
        } catch (Exception e) {
            new BaseBean().writeLog("update department Exception :" + e);
        } finally {
            statement.close();
        }

    }

    private static String getPostData(BufferedReader reader) throws Exception {
        StringBuilder stringBuilder = new StringBuilder();
        String str;
        while ((str = reader.readLine()) != null) {
            stringBuilder.append(str);
        }
        return new String(stringBuilder).replaceAll("\\s*", "");
    }
%>