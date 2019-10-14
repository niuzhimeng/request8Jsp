<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.*" %>
<%@ page import="weaver.conn.RecordSet" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<%
    String jhskrqwhere = "";
    String kprqwhere = "";
    String sjwhere = "";
    String ssrqwhere = "";
    String sqrqwhere = "";
    String ssrqfwwhere = "";
    //查询条件：起止日期
    String searchFromDateValue = Util.null2String(request.getParameter("StartDate"));
    String searchToDateValue = Util.null2String(request.getParameter("EndDate"));

    if(!"".equals(searchFromDateValue)){
        jhskrqwhere += " and jhskrq >= '"+ searchFromDateValue +"'";
        kprqwhere += " and kprq >= '"+ searchFromDateValue +"'";
        sjwhere += " and sj >= '"+ searchFromDateValue +"'";
        ssrqwhere += " and ssrq >= '"+ searchFromDateValue +"'";
        sqrqwhere += " and sqrq >= '"+ searchFromDateValue +"'";
        ssrqfwwhere += " and ssrqfw >= '"+ searchFromDateValue +"'";
    }

    if(!"".equals(searchToDateValue)){
        jhskrqwhere += " and jhskrq <= '"+ searchToDateValue +"'";
        kprqwhere += " and kprq <= '"+ searchToDateValue +"'";
        sjwhere += " and sj <= '"+ searchToDateValue +"'";
        ssrqwhere += " and ssrq <= '"+ searchToDateValue +"'";
        sqrqwhere += " and sqrq <= '"+ searchToDateValue +"'";
        ssrqfwwhere += " and ssrqfw <= '"+ searchToDateValue +"'";


    }

%>
<html>
<head>
    <link href="/css/Weaver_wev8.css" type="text/css" rel="stylesheet">
    <link href="/js/ecology8/selectbox/css/jquery.selectbox_wev8.css" type="text/css" rel="stylesheet">
    <script language="javascript" src="/js/ecology8/selectbox/js/jquery.selectbox-0.2_wev8.js"></script>
    <script language="javascript" src="/js/browser/WorkFlowBrowser_wev8.js"></script>
    <script language="javascript" src="/js/datetime_wev8.js"></script>
    <script language="javascript" src="/js/selectDateTime_wev8.js"></script>
    <script language="javascript" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
    <SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
</head>

<%
    String imagefilename = "/images/hdMaintenance_wev8.gif";
    String titlename = SystemEnv.getHtmlLabelName(527, user.getLanguage());
    String needfav = "1";
    String needhelp = "";

%>

<body>

<jsp:include page="/systeminfo/commonTabHead.jsp">
    <jsp:param name="mouldID" value="proj"/>
    <jsp:param name="navName" value="统计表" />
</jsp:include>


<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
    RCMenu += "{"+ SystemEnv.getHtmlLabelName(197,user.getLanguage()) +",javascript:submitForm(),_top} " ;
    RCMenuHeight += RCMenuHeightStep;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<!-- 条件页面内容 -->

    <div>
        <wea:layout type="4col" attributes="{'expandAllGroup':'true'}">
            <wea:group context="数据列表">
                <wea:item attributes="{'isTableList':'true','colspan':'full'}">
                    <TABLE class="ListStyle" cellspacing="0" style="table-layout: fixed;">
                        <col width="10%">
                        <col width="10%">
                        <col width="10%">
                        <col width="10%">
                        <thead>
                        <TR class="HeaderForXtalbe">
                            <th title="安全日报名称">安全日报名称</th>
                            <th title="安全">安全</th>
                            <th title="不安全">不安全</th>
                            <th title="未填">未填</th>

                        </tr>
                        </thead>
                        <tbody>
                        <%
                            String sql_selaqrbmc = "select name from my_start group by name";
//                            String sql_selaq = "select name, count(safe) safe from my_start GROUP BY name,safe HAVING safe ='1'";
//                            String sql_selbaq = "select name, count(safe) safe from my_start GROUP BY name,safe HAVING safe ='0'";
//                            String sql_selwt = "select name, count(safe) safe from my_start GROUP BY name,safe HAVING safe ='0'";

                            RecordSet rs_selaqrbmc = new RecordSet();
//                            RecordSet rs_selaq = new RecordSet();
//                            RecordSet rs_selbaq = new RecordSet();
//                            RecordSet rs_selwt = new RecordSet();
                            rs_selaqrbmc.executeSql(sql_selaqrbmc);
//                            rs_selaq.executeSql(sql_selaq);
//                            rs_selbaq.executeSql(sql_selbaq);
//                            rs_selwt.executeSql(sql_selwt);

                            while(rs_selaqrbmc.next()) {
                                String aqrbmc = "";
                                String aq = "";
                                String baq = "";
                                String wt = "";

                                RecordSet rs_selaq = new RecordSet();
                                RecordSet rs_selbaq = new RecordSet();
                                RecordSet rs_selwt = new RecordSet();

                                aqrbmc = Util.null2String(rs_selaqrbmc.getString("name"));
                                new BaseBean().writeLog("aqrbmc:" + aqrbmc);
                                String sql_selaq = "select count(safe) safe from my_start where safe ='1' and name = '" + aqrbmc  + "'";
                                new BaseBean().writeLog("sql_selaq:" + sql_selaq);
                                rs_selaq.executeSql(sql_selaq);
                                while (rs_selaq.next()) {
                                    aq = Util.null2String(rs_selaq.getString("safe"));
                                    new BaseBean().writeLog("aq:" + aq);
                                }
                                String sql_selbaq = "select count(safe) safe from my_start where safe ='0' and name= '" + aqrbmc  + "'";
                                rs_selbaq.executeSql(sql_selbaq);
                                while (rs_selbaq.next()) {
                                    baq = Util.null2String(rs_selbaq.getString("safe"));
                                }
                                String sql_selwt = "select count(1) safe from my_start where safe is null and name= '" + aqrbmc + "'";
                                new BaseBean().writeLog("sql_selwt:" + sql_selwt);
                                rs_selwt.executeSql(sql_selwt);
                                while (rs_selwt.next()) {
                                    wt = Util.null2String(rs_selwt.getString("safe"));
                                }

                        %>
                        <tr>
                            <td>
                                <a href="http://www.baidu.com"><%=aqrbmc %></a>
                            </td>
                            <td>
                                <span><%=aq %></span>
                            </td>
                            <td>
                                <span><%=baq %></span>
                            </td>
                            <td>
                                <span><%=wt %></span>
                            </td>

                        </tr>
                        <%
                            }
                        %>
                        </tbody>
                    </TABLE>
                </wea:item>
            </wea:group>
        </wea:layout>
    </div>
    <script type="text/javascript">
        function submitForm(){
            $('#weaver').submit();
        }

        function exportExcel(){
            window.location.href="/weavernorth/zgrb/report/htjetjb_excel.jsp?jhskrqwhere=<%=jhskrqwhere%>&kprqwhere=<%=kprqwhere%>&sjwhere=<%=sjwhere%>&ssrqwhere=<%=ssrqwhere%>&sqrqwhere=<%=sqrqwhere%>&ssrqfwwhere=<%=ssrqfwwhere%>";
        }


    </script>
</form>
</body>
</html>
