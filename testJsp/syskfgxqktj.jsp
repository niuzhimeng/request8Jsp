<%@page import="weaver.general.Util"%>
<%@ page import="weaver.general.BaseBean" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %><!--指定页面编码-->
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/WEB-INF/tld/browser.tld" prefix="brow"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs_sys" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="rs_dws" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="rs_zjrc" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="rs_zjdwlx1" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="rs_zjdwlx2" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="rs_zjdwlx3" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="rs_zjdwlx4" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="rs_zjsc" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="rs_zjsf" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="rs_syrdw1" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="rs_xjrc" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="rs_xjdwlx1" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="rs_xjdwlx2" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="rs_xjdwlx3" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="rs_xjdwlx4" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="rs_xjsc" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="rs_xjsf" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="rs_syrdwrc" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="rs_syrdwsc" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="rs_syrdwsf" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="rs_sf_syrdw" class="weaver.conn.RecordSet" scope="page"/>
<%
	//实验室开放共享情况统计

	//接收查询条件参数	（根据时间条件筛选）
	String searchwhere = "";
	//建模表传递数据
	String qysj1 = "";
	String qysj2 = "";

	//拼接SQL： 日期条件语句
	String searchFromDateValue = Util.null2String(request.getParameter("StartDate"));
	String searchToDateValue = Util.null2String(request.getParameter("EndDate"));
	if(!"".equals(searchFromDateValue)){
		searchwhere += " and djrq >= '"+ searchFromDateValue +"'";
		qysj1 = "&qysj1=" + searchFromDateValue;
	}
	new BaseBean().writeLog(">>>>>>>>>> String >>>>>>> qysj1 >>>>>>>>>>" + qysj1);

	if(!"".equals(searchToDateValue)){
		searchwhere += " and djrq <= '"+ searchToDateValue +"'";
		qysj2 = "&qysj2=" + searchToDateValue;
	}
	new BaseBean().writeLog(">>>>>>>>>> String >>>>>>> qysj2 >>>>>>>>>>" + qysj2);

%>


<HTML>
<HEAD>
	<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET><!--加载全局CSS-->
	<script language=javascript src="/js/ecology8/hrm/HrmSearchInit_wev8.js"></script>
	<link type="text/css" href="/js/tabs/css/e8tabs1_wev8.css" rel="stylesheet" />


	<script type='text/javascript' src='/js/jquery-autocomplete/lib/jquery.bgiframe.min_wev8.js'></script>
	<script type='text/javascript' src='/js/jquery-autocomplete/jquery.autocomplete_wev8.js'></script>
	<script type='text/javascript' src='/js/jquery-autocomplete/browser_wev8.js'></script>
	<link rel="stylesheet" type="text/css" href="/js/jquery-autocomplete/jquery.autocomplete_wev8.css" />
	<link rel="stylesheet" type="text/css" href="/js/jquery-autocomplete/browser_wev8.css" />
	<style>
		TABLE.ListStyle TR.Tot TD {
			BACKGROUND-COLOR: #ECFDEA;
		}
		TABLE.ListStyle TR.Tot TD.Tit {
			FONT-WEIGHT: BOLD;
			TEXT-ALIGN: RIGHT;
		}
		TABLE.ListStyle TR.Tot,TABLE.ListStyle TR TD.TypeName a,TABLE.ListStyle TR TD.FlowName a {
			COLOR: #538DD5;
		}
		TABLE.ListStyle TR.Obj TD{
			text-align:center!important;
		}
		TABLE.ListStyle TR.xj TD{
			text-align:center!important;
			background-color: #f8f8f8;
			color: red;
		}
		TABLE.ListStyle TR {
			vertical-align: middle;
		}
		TABLE.ListStyle TR TD {
			border-top:1px #E9E9E2 solid;
			height: 30px;
			vertical-align: middle;
			text-overflow: ellipsis;
			white-space: nowrap;
			word-break: keep-all;
			overflow: hidden;
		}
		table.ListStyle tr.HeaderForXtalbe th{
			text-align:center!important;
		}
		TABLE.ListStyle tbody TR TD {
			padding:0px 0px 0px 0px;
		}
	</style>
</HEAD>
<%
	String imagefilename = "/images/hdReport_wev8.gif";
	String titlename = "实验室开放共享情况统计";
	String needfav ="1";
	String needhelp ="";
%>

<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%--<body scroll="no">--%>
<body>
<%--页面右键菜单栏--%>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%--页面右键菜单栏  搜索 导出--%>
<%
	RCMenu += "{搜索,javascript:doSearch(),_self} " ;
	RCMenuHeight += RCMenuHeightStep;

	RCMenu += "{"+SystemEnv.getHtmlLabelName(28343,user.getLanguage())+",javascript:exportExcel(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
%>

<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<!-- 顶部查询按钮 -->
<div id="mainDiv" style="overflow-x: hidden">
       <span  style="width:100%; height:30px;line-height:60px; text-align:center; float:left;font-size:25px;font-weight: bold ">
                                                    实验室开放共享情况统计</span>
	<form NAME="SearchForm" id="SearchForm" STYLE="margin-bottom:0" action="syskfgxqktj.jsp" method=post>
		<input type="hidden" name="pageId" id="pageId" _showCol="false" value="db_list3"/>
		<wea:layout type="fourCol">
			<wea:group context='<%=SystemEnv.getHtmlLabelName(20331, user.getLanguage())%>'>

				<%--日期选择按钮--%>
				<wea:item>&nbsp;&nbsp;日期</wea:item>
				<wea:item>

					<BUTTON class=Calendar type="button" onClick="getDate(StartDatespan,StartDate)"></BUTTON>
					<SPAN id="StartDatespan"><%=searchFromDateValue %></SPAN>
					<input type="hidden" name="StartDate" value = "<%=searchFromDateValue %>" >
					到&nbsp;&nbsp;
					<BUTTON class=Calendar type="button" onClick="getDate(EndDatespan,EndDate)"></BUTTON>
					<SPAN id="EndDatespan"><%=searchToDateValue %></SPAN>
					<input type="hidden" name="EndDate" value = "<%=searchToDateValue %>">

				</wea:item>

				<%--搜索按钮--%>
				<wea:item>
					<input type="button" class="e8_btn_top_first" value="搜索" title="搜索"
						   style=" max-width: 100px; float:right;overflow: hidden; text-overflow: ellipsis; white-space: nowrap;"
						   onclick="javascript:doSearch()">
				</wea:item>

			</wea:group>

			<wea:group context="数据列表">
				<wea:item attributes="{'isTableList':'true','colspan':'full'}">
					<TABLE class="ListStyle" cellspacing="0" style="table-layout: fixed;">
					<%--自定义表头	--%>
						<thead>
						<TR class="HeaderForXtalbe">
							<th width="2%" rowspan="2">序号</th>
							<th width="5%" rowspan="2">实验室</th>
							<th width="3%" rowspan="2">人次</th>
							<th width="25%" colspan="5">开放共享单位类型</th>
							<th width="5%" rowspan="2">时长</br>(小时)</th>
							<th width="5%" rowspan="2">收费</br>(元)</th>
						</tr>
						<TR class="HeaderForXtalbe">
							<th width="5%">广电局/台/网等</th>
							<th width="5%">科研院所/大专院校</th>
							<th width="5%">企业</th>
							<th width="5%">其他</th>
							<th width="5%">合计</th>
						</tr>
						</thead>
						<tbody>

						<%
							//总计行-明细
//							String sql_zjrc = "select ISNULL(COUNT(*),0) as zjrc from uf_syssyjl";
							String sql_zjrc = "select isnull(sum(rs),0) as zrs from uf_syssyjl where 1=1" + searchwhere;
							rs_zjrc.executeSql(sql_zjrc);
							new BaseBean().writeLog("SQL:sql_zjrc++++++" + sql_zjrc);
							String zjrc = "";
							while (rs_zjrc.next()) {
								zjrc = Util.null2String(rs_zjrc.getString("zrs"));
								new BaseBean().writeLog("zjrc:" + zjrc);
							}
							String sql_zjdwlx1 = "select isnull(count(DISTINCT syrdw),0) as zjdwlx1 from uf_syssyjl where syrlx='2'" + searchwhere;
							rs_zjdwlx1.executeSql(sql_zjdwlx1);
							String zjdwlx1 = "";
							while (rs_zjdwlx1.next()) {
								zjdwlx1 = Util.null2String(rs_zjdwlx1.getString("zjdwlx1"));
							}
							String sql_zjdwlx2 = "select isnull(count(DISTINCT syrdw),0) as zjdwlx2 from uf_syssyjl where syrlx='3'" + searchwhere;
							rs_zjdwlx2.executeSql(sql_zjdwlx2);
							String zjdwlx2 = "";
							while (rs_zjdwlx2.next()) {
								zjdwlx2 = Util.null2String(rs_zjdwlx2.getString("zjdwlx2"));
							}
							String sql_zjdwlx3 = "select isnull(count(DISTINCT syrdw),0) as zjdwlx3 from uf_syssyjl where syrlx='4'" + searchwhere;
							rs_zjdwlx3.executeSql(sql_zjdwlx3);
							String zjdwlx3 = "";
							while (rs_zjdwlx3.next()) {
								zjdwlx3 = Util.null2String(rs_zjdwlx3.getString("zjdwlx3"));
							}
							String sql_zjdwlx4 = "select isnull(count(DISTINCT syrdw),0) as zjdwlx4 from uf_syssyjl where syrlx='5'" + searchwhere;
							rs_zjdwlx4.executeSql(sql_zjdwlx4);
							String zjdwlx4 = "";
							while (rs_zjdwlx4.next()) {
								zjdwlx4 = Util.null2String(rs_zjdwlx4.getString("zjdwlx4"));
							}
							int hj = Integer.parseInt(zjdwlx1) + Integer.parseInt(zjdwlx2) + Integer.parseInt(zjdwlx3) + Integer.parseInt(zjdwlx4);
							String sql_zjsc = "select isnull(sum(sysc),0.0) as zjsc from uf_syssyjl where 1=1 " + searchwhere;
							rs_zjsc.executeSql(sql_zjsc);
							String zjsc = "";
							while (rs_zjsc.next()) {
								zjsc = Util.null2String(rs_zjsc.getString("zjsc"));
							}
							String sql_zjsf = "select isnull(sum(sfje),0.0) as zjsf from uf_dxsbsyjl where sbmc in (select id from uf_sysdxsb) " + searchwhere;
							rs_zjsf.executeSql(sql_zjsf);
							String zjsf = "";
							while (rs_zjsf.next()) {
								zjsf = Util.null2String(rs_zjsf.getString("zjsf"));
							}
						%>
						<tr class="Obj" align="center">
							<th>
								<span>&nbsp;</span>
							</th>
							<th>
								<span>总计</span>
							</th>
							<th>
								<span><%=zjrc%></span>
							</th>

							<th>
								<span><%=zjdwlx1%></span>
							</th>

							<th>
								<span><%=zjdwlx2%></span>
							</th>
							<th>
								<span><%=zjdwlx3%></span>
							</th>
							<th>
								<span><%=zjdwlx4%></span>
							</th>
							<th>
								<span><%=hj%></span>
							</th>
							<th>
								<span><%=zjsc%></span>
							</th>
							<th>
								<span><%=zjsf%></span>
							</th>
						</tr>
						<%
							String sql_sysAllornot = "select * from formtable_main_59";
//							new BaseBean().writeLog(">>>>>>>>>> SQL >>>>>>> sys all or not >>>>>>>>>>" + sql_sysAllornot);
							rs_sys.executeSql(sql_sysAllornot);

							int num = 0;
							while(rs_sys.next()){
								String sysid = Util.null2String(rs_sys.getString("id"));
								String sysmc = Util.null2String(rs_sys.getString("sysmc"));

								new BaseBean().writeLog("实验室id-sysid:" + sysid);
								new BaseBean().writeLog("实验室id-sysmc:" + sysmc);

								num += 1;
								//小计行-明细

								String sql_xjrc = "select isnull(sum(rs),0) as zrs from uf_syssyjl where sysmc = "+sysid + searchwhere;
								rs_xjrc.executeSql(sql_xjrc);
								new BaseBean().writeLog("SQL:sql_xjrc++++++" + sql_xjrc);
								String xjrc = "";
								while (rs_xjrc.next()) {
									xjrc = Util.null2String(rs_xjrc.getString("zrs"));
									new BaseBean().writeLog("xjrc:" + xjrc);
								}
//								String sql_xjdwlx1 = "select isnull(count(*),0) as xjdwlx1 from uf_syssyjl where syrlx='2' and sysmc = " + sysid + searchwhere;
								String sql_xjdwlx1 = "select isnull(count(DISTINCT syrdw),0) as xjdwlx1 from uf_syssyjl where syrlx='2' and sysmc = "+ sysid + searchwhere;
								rs_xjdwlx1.executeSql(sql_xjdwlx1);
								String xjdwlx1 = "";
								while (rs_xjdwlx1.next()) {
									xjdwlx1 = Util.null2String(rs_xjdwlx1.getString("xjdwlx1"));
								}
//								String sql_xjdwlx2 = "select isnull(count(*),0) as xjdwlx2 from uf_syssyjl where syrlx='3' and sysmc = " + sysid + searchwhere;
								String sql_xjdwlx2 = "select isnull(count(DISTINCT syrdw),0) as xjdwlx2 from uf_syssyjl where syrlx='3' and sysmc = " + sysid + searchwhere;
								rs_xjdwlx2.executeSql(sql_xjdwlx2);
								String xjdwlx2 = "";
								while (rs_xjdwlx2.next()) {
									xjdwlx2 = Util.null2String(rs_xjdwlx2.getString("xjdwlx2"));
								}
//								String sql_xjdwlx3 = "select isnull(count(*),0) as xjdwlx3 from uf_syssyjl where syrlx='4' and sysmc = " + sysid + searchwhere;
								String sql_xjdwlx3 = "select isnull(count(DISTINCT syrdw),0) as xjdwlx3 from uf_syssyjl where syrlx='4' and sysmc = " + sysid + searchwhere;
								rs_xjdwlx3.executeSql(sql_xjdwlx3);
								String xjdwlx3 = "";
								while (rs_xjdwlx3.next()) {
									xjdwlx3 = Util.null2String(rs_xjdwlx3.getString("xjdwlx3"));
								}
//								String sql_xjdwlx4 = "select isnull(count(*),0) as xjdwlx4 from uf_syssyjl where syrlx='5' and sysmc = " + sysid + searchwhere;
								String sql_xjdwlx4 = "select isnull(count(DISTINCT syrdw),0) as xjdwlx4 from uf_syssyjl where syrlx='5' and sysmc = " + sysid + searchwhere;
								rs_xjdwlx4.executeSql(sql_xjdwlx4);
								String xjdwlx4 = "";
								while (rs_xjdwlx4.next()) {
									xjdwlx4 = Util.null2String(rs_xjdwlx4.getString("xjdwlx4"));
								}
								int xjhj = Integer.parseInt(xjdwlx1) + Integer.parseInt(xjdwlx2) + Integer.parseInt(xjdwlx3) + Integer.parseInt(xjdwlx4);
								String sql_xjsc = "select isnull(sum(sysc),0.0) as xjsc from uf_syssyjl where sysmc = "+sysid + searchwhere;
								rs_xjsc.executeSql(sql_xjsc);
								String xjsc = "";
								while (rs_xjsc.next()) {
									xjsc = Util.null2String(rs_xjsc.getString("xjsc"));
								}
								String sql_xjsf = "select isnull(sum(sfje),0.0) as xjsf from uf_dxsbsyjl where sbmc in (select id from uf_sysdxsb where sssys = " + sysid + ") " + searchwhere;
								rs_xjsf.executeSql(sql_xjsf);
								String xjsf = "";
								while (rs_xjsf.next()) {
									xjsf = Util.null2String(rs_xjsf.getString("xjsf"));
								}

						%>
						<tr class="xj" align="center">
							<td rowspan="2">
								<%=num%>
							</td>
							<td>
								<span>小计</span>
							</td>
							<td>
								<span><%=xjrc%></span>
							</td>
							<td>
								<span><%=xjdwlx1%></span>
							</td>
							<td>
								<span><%=xjdwlx2%></span>
							</td>
							<td>
								<span><%=xjdwlx3%></span>
							</td>
							<td>
								<span><%=xjdwlx4%></span>
							</td>
							<td>
								<span><%=xjhj%></span>
							</td>
							<td>
								<span><%=xjsc%></span>
							</td>
							<td>
								<span><%=xjsf%></span>
							</td>
						</tr>
						<tr class="Obj" align="center">
							<td>
								<a href="/formmode/view/AddFormMode.jsp?" target="_blank">
									<span><%=sysmc %></span><!-- 实验室名称 -->
								</a>
							</td>
							<td colspan="8">
								<table style="width: 100%;height: 100%">
									<%
										//String sql_dwlx1 = "select syrdw from uf_syssykh where id =(select syrdw from uf_syssyjl where sysmc = " + sysid + " " + searchwhere + " and syrlx='" + dwlx + "')";
										String sql_dwlx1 = "select DISTINCT b.ywdwlx ywdwlx,b.syrdw syrdw,a.syrdw syrdwid from uf_syssyjl a left join uf_syssykh b on a.syrdw=b.id where a.sysmc = " + sysid + searchwhere;
										new BaseBean().writeLog("sql_dwlx1:" + sql_dwlx1);
										rs_syrdw1.executeSql(sql_dwlx1);
										String syrdw = "";
										String ywdwlx = "";
										String syrdwid = "";
										while (rs_syrdw1.next()) {
											syrdw = Util.null2String(rs_syrdw1.getString("syrdw"));
											new BaseBean().writeLog("syrdw" + syrdw);
											ywdwlx = Util.null2String(rs_syrdw1.getString("ywdwlx"));
											syrdwid = Util.null2String(rs_syrdw1.getString("syrdwid"));
											new BaseBean().writeLog("syrdwid:" + syrdwid);
										//表中表明细
											String sql_syrdwrc = "select isnull(sum(rs),0) as syrdwrc from uf_syssyjl where sysmc = " + sysid + " and syrdw= '" + syrdwid +"'" + searchwhere;
											new BaseBean().writeLog("sql_srydwrc:" + sql_syrdwrc);
											rs_syrdwrc.executeSql(sql_syrdwrc);
											String syrdwrc = "";
											while (rs_syrdwrc.next()) {
												syrdwrc = Util.null2String(rs_syrdwrc.getString("syrdwrc"));
											}
											String sql_syrdwsc = "select isnull(sum(sysc),0.0) as syrdwsc from uf_syssyjl where sysmc = " + sysid + " and syrdw='" + syrdwid +"'" + searchwhere;
											new BaseBean().writeLog("sql_srydwsc:" + sql_syrdwsc);
											rs_syrdwsc.executeSql(sql_syrdwsc);
											String syrdwsc = "";
											while (rs_syrdwsc.next()) {
												syrdwsc = Util.null2String(rs_syrdwsc.getString("syrdwsc"));
												new BaseBean().writeLog("syrdwsc:" + syrdwsc);
											}
											String sql_sf_syrdw="select syrdw from uf_syssyjl where sysmc = " + sysid + searchwhere;
											rs_sf_syrdw.executeSql(sql_sf_syrdw);
											String sf_syrdw = "";
											String syrdwsf = "";
											while (rs_sf_syrdw.next()) {
												sf_syrdw = Util.null2String(rs_sf_syrdw.getString("syrdw"));
												new BaseBean().writeLog("sf_syrdw:" + sf_syrdw);
											}

											String sql_syrdwsf = "select ISNULL (SUM(sfje),0.0) as syrdwsf from uf_dxsbsyjl where syrdw = '" + sf_syrdw + "'";
												new BaseBean().writeLog("sql_syrdwsf1:" + sql_syrdwsf);
												rs_syrdwsf.executeSql(sql_syrdwsf);
												while (rs_syrdwsf.next()) {
													syrdwsf = Util.null2String(rs_syrdwsf.getString("syrdwsf"));
													new BaseBean().writeLog("syrdwsf1:" + syrdwsf);
												}


//											String sql_syrdwsf = "select isnull(sfje,0.0) as syrdwsf from uf_dxsbsyjl where sbmc in (select id from uf_sysdxsb where sssys=" + sysid + ") and syrdw=" + syrdwid + searchwhere;
//											String sql_syrdwsf = "select ISNULL (SUM(sfje),0.0) as syrdwsf from uf_dxsbsyjl where syrdw in (select syrdw from uf_syssyjl where sysmc = " + sysid + searchwhere + ")";
//											new BaseBean().writeLog("sql_srydwsf:" + sql_syrdwsf);
//											rs_syrdwsf.executeSql(sql_syrdwsf);
//											String syrdwsf = "";
//											while (rs_syrdwsf.next()) {
//												syrdwsf = Util.null2String(rs_syrdwsf.getString("syrdwsf"));
//												new BaseBean().writeLog("syrdwsf:" + syrdwsf);
//											}
									%>

									<tr>
										<td width="3%">
											<span><%=syrdwrc%></span>
										</td>
										<%
											switch (Integer.parseInt(ywdwlx)){
												case 2:
										%>
										<td width="5%">
											<span><%=syrdw%></span>
										</td>
										<td width="5%">
											<span>&nbsp;</span>
										</td>
										<td width="5%">
											<span>&nbsp;</span>
										</td>
										<td width="5%">
											<span>&nbsp;</span>
										</td>
										<%
												break;
											case 3:
										%>
										<td width="5%">
											<span>&nbsp;</span>
										</td>
										<td width="5%">
											<span><%=syrdw%></span>
										</td>
										<td width="5%">
											<span>&nbsp;</span>
										</td>
										<td width="5%">
											<span>&nbsp;</span>
										</td>
										<%
												break;
											case 4:
										%>
										<td width="5%">
											<span>&nbsp;</span>
										</td>
										<td width="5%">
											<span>&nbsp;</span>
										</td>
										<td width="5%">
											<span><%=syrdw%></span>
										</td>
										<td width="5%">
											<span>&nbsp;</span>
										</td>
										<%
												break;
											case 5:
										%>
										<td width="5%">
											<span>&nbsp;</span>
										</td>
										<td width="5%">
											<span>&nbsp;</span>
										</td>
										<td width="5%">
											<span>&nbsp;</span>
										</td>
										<td width="5%">
											<span><%=syrdw%></span>
										</td>
										<%
													break;
											}
										%>
										<td width="5%">
											<span>&nbsp;</span>
										</td>
										<td width="5%">
											<span><%=syrdwsc%></span>
										</td>
										<td width="5%">
											<span><%=syrdwsf%></span>
										</td>
									</tr>
									<%
										}
									%>
								</table>
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
	</form>
	<SCRIPT language="javascript" src="/js/datetime_wev8.js"></script>
	<SCRIPT language="javascript" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
	<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
	<script language="javascript" src="/js/jquery/jquery_wev8.js"></script>
	<script type="text/javascript">
        function doSearch(){
            document.SearchForm.submit();
        }

        function exportExcel(){
            window.location.href="/weavernorth/gky/syskfgxqktj_excel.jsp?searchwhere=<%=searchwhere%>";
            //document.getElementById("excels").src = "jskfzxxm_excel1.jsp?datasql=" + datasql;
        }

	</script>
</div>
<jsp:include page="/systeminfo/commonTabFoot.jsp"></jsp:include>
</BODY>
</html>
