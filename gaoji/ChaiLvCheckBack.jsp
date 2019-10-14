<%@ page import="weaver.conn.RecordSet" %>
<%@ page import="weaver.general.BaseBean" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea" %>
<%@ taglib uri="/WEB-INF/tld/browser.tld" prefix="brow" %>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page"/>
<script type="text/javascript" src="/js/select/script/jquery-1.8.3.min_wev8.js"></script>

<%
    /**
     * 差旅报销标准后台
     */
    String flag = "yes";
    RecordSet recordSet = new RecordSet();
    String allStr = request.getParameter("allStr");
    String tbr = request.getParameter("tbr");
    //明细表类型
    String type = request.getParameter("type");
    recordSet.execute("select * from hrmresource where id = '" + tbr + "'");
    String seclevel = "";//安全级别
    if (recordSet.next()) {
        seclevel = recordSet.getString("seclevel");
    }

    if ("chaiLv".equals(type)) {
        flag = chaiLv(allStr, seclevel);
    } else if ("zhuSu".equals(type)) {
        flag = zhuSu(allStr, seclevel);
    } else if ("canYin".equals(type)) {
        flag = canYin(allStr, seclevel);
    }

    out.clear();
    out.print(flag);

%>

<%!
    /**
     * 差旅
     * @param allStr 前台拼接的字段
     * @param seclevel 人员安全级别
     * @return
     */
    private String chaiLv(String allStr, String seclevel) {
        String flag = "yes";
        RecordSet recordSet = new RecordSet();
        BaseBean baseBean = new BaseBean();
        String[] lines = allStr.split("#");
        String csjb;//城市级别
        String jtgj;//交通工具
        String chaiLvSql;
        for (String obj : lines) {
            String[] split = obj.split(",");
            csjb = split[0];
            jtgj = "," + split[1] + ",";
            baseBean.writeLog("城市级别： " + csjb + ", 交通工具： " + jtgj);
            chaiLvSql = "select * from uf_ccbz where cs = '" + csjb + "' and '" + seclevel + "' >= zjxx and  '" + seclevel
                    + "' < zjsx and jt like  '%" + jtgj + "%'";
            baseBean.writeLog("差旅交通校验执行的sql==========： " + chaiLvSql);
            recordSet.execute(chaiLvSql);
            if (!recordSet.next()) {
                flag = "no";
            }
        }
        return flag;
    }

    /**
     * 住宿
     * @param allStr 前台拼接的字段
     * @param seclevel 人员安全级别
     * @return
     */
    private String zhuSu(String allStr, String seclevel) {
        String flag = "yes";
        RecordSet recordSet = new RecordSet();
        BaseBean baseBean = new BaseBean();
        String[] lines = allStr.split("#");
        String csjb;//城市级别
        String rjfy;//日均费用
        String chaiLvSql;
        for (String obj : lines) {
            String[] split = obj.split(",");
            csjb = split[0];
            rjfy = split[1];
            baseBean.writeLog("城市级别： " + csjb + ", 日均费用： " + rjfy);
            chaiLvSql = "select * from uf_ccbz where cs = '" + csjb + "' and '" + seclevel + "' >= zjxx and  '" + seclevel
                    + "' < zjsx and zsbz >=  '" + rjfy + "'";
            baseBean.writeLog("差旅住宿校验执行的sql==========： " + chaiLvSql);
            recordSet.execute(chaiLvSql);
            if (!recordSet.next()) {
                flag = "no";
            }
        }
        return flag;
    }

    /**
     * 住宿
     * @param allStr 前台拼接的字段
     * @param seclevel 人员安全级别
     * @return
     */
    private String canYin(String allStr, String seclevel) {
        String flag = "yes";
        RecordSet recordSet = new RecordSet();
        BaseBean baseBean = new BaseBean();
        String[] lines = allStr.split("#");
        String csjb;//城市级别
        String rjje;//人均金额
        String chaiLvSql;
        for (String obj : lines) {
            String[] split = obj.split(",");
            csjb = split[0];
            rjje = split[1];
            chaiLvSql = "select * from uf_ccbz where cs = '" + csjb + "' and '" + seclevel + "' >= zjxx and  '" + seclevel
                    + "' < zjsx and cy >=  '" + rjje + "'";
            baseBean.writeLog("差旅餐饮校验执行的sql==========： " + chaiLvSql);
            recordSet.execute(chaiLvSql);
            if (!recordSet.next()) {
                flag = "no";
            }
        }
        return flag;
    }

%>




