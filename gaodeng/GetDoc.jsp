<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="com.alibaba.fastjson.JSONArray" %>
<%@ page import="com.alibaba.fastjson.JSONObject" %>
<%@ page import="ln.LN" %>
<%@ page import="weaver.conn.RecordSet" %>
<%@ page import="weaver.crm.Maint.CustomerInfoComInfo" %>
<%@ page import="weaver.docs.category.DocTreeDocFieldComInfo" %>
<%@ page import="weaver.docs.category.MainCategoryComInfo" %>
<%@ page import="weaver.docs.category.SecCategoryComInfo" %>
<%@ page import="weaver.docs.category.SubCategoryComInfo" %>
<%@ page import="weaver.docs.docs.DocComInfo" %>
<%@ page import="weaver.docs.webservices.DocInfo" %>
<%@ page import="weaver.general.*" %>
<%@ page import="weaver.hrm.OnLineMonitor" %>
<%@ page import="weaver.hrm.User" %>
<%@ page import="weaver.hrm.company.DepartmentComInfo" %>
<%@ page import="weaver.hrm.resource.ResourceComInfo" %>
<%@ page import="weaver.share.ShareManager" %>
<%@ page import="weaver.systeminfo.SysMaintenanceLog" %>
<%@ page import="weaver.systeminfo.SystemEnv" %>

<%@ page import="weaver.systeminfo.language.LanguageComInfo" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Calendar" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Map" %>

<%
    BaseBean baseBean = new BaseBean();
    try {
        String flowStr = "OA_DOC";
        String loginId = request.getParameter("loginId");
        String token = request.getParameter("token");
        String currentTime = request.getParameter("currentTime");
        String getCounts = request.getParameter("getCounts");
        // 文档类型(最新文件 002, 社内要闻 003, 部门动态 004)
        String documentType = request.getParameter("documentType");

        int defaultCounts = 5;
        if (getCounts != null && !"".equals(getCounts)) {
            defaultCounts = Integer.parseInt(getCounts);
        }


        baseBean.writeLog("门户系统获取oa文档 Start============ " + " " + TimeUtil.getCurrentTimeString());
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

        RecordSet recordSet = new RecordSet();
        recordSet.executeQuery("select mlmc from uf_portal_type where yslx = '" + documentType + "'");
        StringBuilder idBuilder = new StringBuilder();
        if (recordSet.next()) {
            String mlmc = recordSet.getString("mlmc");
            String[] splits = mlmc.split(",");
            for (String str : splits) {
                idBuilder.append("'").append(str).append("',");
            }

            if (idBuilder.length() > 3) {
                idBuilder.deleteCharAt(idBuilder.length() - 1);
            }
        } else {
            JSONObject errObject = new JSONObject();
            errObject.put("status", "1");
            errObject.put("message", "文档类型不存在。");
            out.clear();
            out.print(errObject.toJSONString());
            return;
        }

        // 登录
        RecordSet rs = new RecordSet();
        rs.executeSql("select * from HrmResource where loginid = lower('" + loginId + "') and status < 4 and (accounttype !=1 or accounttype is null)");

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

        User user_new = null;
        if (rs.next()) {
            request.getSession().invalidate();
            // OA有相关人员
            User user = (User) request.getSession(true).getAttribute("weaver_user@bean");
            // 用户session不存在 或者 用户session中的用户名和此次登录的用户名不一致，要重启构造用户session

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
            // OA中查无此人，必须重新登录
            JSONObject errObject = new JSONObject();
            errObject.put("status", "1");
            errObject.put("message", "登录名不存在。");
            out.clear();
            out.print(errObject.toJSONString());
            return;
        }

        long start = System.currentTimeMillis();
        DocInfo[] list = getList(user_new, 1, defaultCounts, idBuilder.toString());
        long resultTime = System.currentTimeMillis() - start;
        baseBean.writeLog("获取文档返回总数量： " + list.length + ", 耗时： " + resultTime / 1000);

        JSONObject jsonObjectAll = new JSONObject();
        JSONArray jsonArray = new JSONArray();
        String oaUrl;
        for (DocInfo docInfo : list) {
            oaUrl = "http://10.1.11.23/gaodeng?forwardUrl=/docs/docs/DocDsp.jsp?id=" + docInfo.getId() + "&isOpenFirstAss=0";
            JSONObject jsonObject = new JSONObject();
            jsonObject.put("docId", docInfo.getId());
            jsonObject.put("docName", docInfo.getDocSubject());
            jsonObject.put("creatorName", docInfo.getDoccreatername());
            jsonObject.put("createDate", docInfo.getDoccreatedate() + " " + docInfo.getDoccreatetime());
            jsonObject.put("openUrl", oaUrl);
            jsonObject.put("fromSys", "OA");

            jsonArray.add(jsonObject);

        }
        jsonObjectAll.put("status", "0");
        jsonObjectAll.put("message", "认证成功。");
        jsonObjectAll.put("flowInfo", jsonArray);

        baseBean.writeLog("返回的xml： " + jsonObjectAll.toJSONString());

        response.setHeader("Content-Type", "application/json;charset=UTF-8");
        out.clear();
        out.print(jsonObjectAll.toJSONString());
    } catch (Exception e) {
        baseBean.writeLog("获取文档异常： " + e);
    }
%>

<%!
    public DocInfo[] getList(User var1, int var2, int var3, String idList) throws Exception {
        User var4 = var1;
        ArrayList var5 = new ArrayList();
        if (var4 != null) {
            RecordSet var6 = new RecordSet();
            ShareManager var7 = new ShareManager();
            DocComInfo var8 = new DocComInfo();
            MainCategoryComInfo var9 = new MainCategoryComInfo();
            SubCategoryComInfo var10 = new SubCategoryComInfo();
            SecCategoryComInfo var11 = new SecCategoryComInfo();
            DepartmentComInfo var12 = new DepartmentComInfo();
            LanguageComInfo var13 = new LanguageComInfo();
            CustomerInfoComInfo var14 = new CustomerInfoComInfo();
            ResourceComInfo var15 = new ResourceComInfo();
            String var16 = "";
            if (var6.getDBType().equals("oracle")) {
                var16 = " t1.*,t2.sharelevel,t3.doccontent from DocDetail t1," + var7.getShareDetailTableByUser("doc", var4) + " t2,DocDetailContent t3 where t1.id = t2.sourceid and t1.id = t3.docid ";
            } else {
                var16 = " t1.*,t2.sharelevel from DocDetail t1," + var7.getShareDetailTableByUser("doc", var4) + " t2 where t1.id = t2.sourceid ";
            }

            var16 = var16 + " and ((docstatus = 7 and (sharelevel>1 or (t1.doccreaterid=" + var4.getUID() + ")) ) or t1.docstatus in ('1','2','5')) ";
            var16 = var16 + "  and seccategory!=0 and (ishistory is null or ishistory = 0) ";
            var16 = var16 + " order by doclastmoddate desc,doclastmodtime desc,id desc";
            // 如果不是oracle数据库，用下面语句
            // var16 = var16 + " and seccategory in(" + idList + ") order by doclastmoddate desc,doclastmodtime desc,id desc";
            boolean var17 = false;
            boolean var18 = false;
            String var22;
            String var23;
            if (var2 > 0 && var3 > 0) {
                int var29;
                int var30;
                if (var6.getDBType().equals("oracle")) {
                    var29 = var2 * var3 + 1;
                    var30 = (var2 - 1) * var3;
                    var16 = " select " + var16;
                    var16 = "select * from ( select row_.*, rownum rownum_ from ( " + var16 + " ) row_ where row_.seccategory in(" + idList + ") and rownum < " + var29 + ") where rownum_ > " + var30;
                } else if (var2 > 1) {
                    var29 = var3 * var2;
                    var30 = var3;
                    int var21 = this.getDocCountByUser(var4);
                    if (var29 > var21) {
                        var29 = var21;
                        var30 = var21 - var3 * (var2 - 1);
                    }

                    var22 = "order by doclastmoddate asc,doclastmodtime asc,id asc";
                    var23 = "order by doclastmoddate desc,doclastmodtime desc,id desc";
                    var16 = " select top " + var30 + " * from ( select top " + var30 + " * from (  select  top " + var29 + " " + var16 + " " + ") tbltemp1 " + var22 + " ) tbltemp2 " + var23;
                } else {
                    var16 = " select top " + var3 + var16;
                }
            } else {
                var16 = " select " + var16;
            }

            var6.executeSql(var16);
            new BaseBean().writeLog("获取文档执行sql： " + var16);

            long start = System.currentTimeMillis();
            while (var6.next()) {
                DocInfo var31 = new DocInfo();
                var31.setId(Util.getIntValue(Util.null2String(var6.getString("id"))));
                var31.setDocType(Util.getIntValue(Util.null2String(var6.getString("doctype")), 1));
                var22 = Util.null2String(var6.getString("docsubject"));
                var22 = var22.replaceAll("\n", "");
                var31.setDocSubject(var22);
                var31.setDocCode(Util.null2String(var6.getString("docCode")));
                var31.setDocPublishType(Util.getIntValue(Util.null2String(var6.getString("docpublishtype")), 1));
                var23 = "";
                if (var31.getDocPublishType() == 2) {
                    var23 = SystemEnv.getHtmlLabelName(227, var4.getLanguage());
                } else if (var31.getDocPublishType() == 3) {
                    var23 = SystemEnv.getHtmlLabelName(229, var4.getLanguage());
                } else {
                    var23 = SystemEnv.getHtmlLabelName(58, var4.getLanguage());
                }

                var31.setPublishable(var23);
                var31.setDocEdition(Util.getIntValue(Util.null2String(var6.getString("docEdition")), 0));
                var31.setDocEditionId(Util.getIntValue(Util.null2String(var6.getString("docEditionId"))));
                var31.setDocEditionStr(var8.getEditionView(var31.getId()));
                var31.setDocStatus(Util.getIntValue(Util.null2String(var6.getString("docstatus"))));
                var31.setDocStatusStr(var8.getStatusView(var31.getId(), var4));
                var31.setMaincategory(var6.getInt("maincategory"));
                var31.setMaincategoryStr(var9.getMainCategoryname(var31.getMaincategory() + ""));
                var31.setSubcategory(var6.getInt("subcategory"));
                var31.setSubcategoryStr(var10.getSubCategoryname(var31.getSubcategory() + ""));
                var31.setSeccategory(var6.getInt("seccategory"));
                var31.setSeccategoryStr(var11.getSecCategoryname(var31.getSeccategory() + ""));
                var31.setDocdepartmentid(var6.getInt("docdepartmentid"));
                var31.setDocdepartmentStr(var12.getDepartmentname(var31.getDocdepartmentid() + ""));
                var31.setDoclangurage(var6.getInt("doclangurage"));
                var31.setDoclangurageStr(var13.getLanguagename(var31.getDoclangurage() + ""));
                var31.setKeyword(Util.null2String(var6.getString("keyword")));
                var31.setDoccreaterid(var6.getInt("doccreaterid"));
                var31.setDoccreatertype(Util.getIntValue(Util.null2String(var6.getString("docCreaterType"))));
                var31.setDoccreatername(var31.getDoccreatertype() == 1 ? var15.getResourcename(var31.getDoccreaterid() + "") : var14.getCustomerInfoname(var31.getDoccreaterid() + ""));
                var31.setDoccreatedate(Util.null2String(var6.getString("doccreatedate")));
                var31.setDoccreatetime(Util.null2String(var6.getString("doccreatetime")));
                var31.setDoclastmoduserid(var6.getInt("doclastmoduserid"));
                var31.setDoclastmodusertype(Util.getIntValue(Util.null2String(var6.getString("docLastModUserType"))));
                var31.setDoclastmodusername(var31.getDoclastmodusertype() == 1 ? var15.getResourcename(var31.getDoclastmoduserid() + "") : var14.getCustomerInfoname(var31.getDoclastmoduserid() + ""));
                var31.setDoclastmoddate(Util.null2String(var6.getString("doclastmoddate")));
                var31.setDoclastmodtime(Util.null2String(var6.getString("doclastmodtime")));
                var31.setDocapproveuserid(var6.getInt("docapproveuserid"));
                var31.setDocapproveusertype(Util.getIntValue(Util.null2String(var6.getString("docApproveUserType"))));
                var31.setDocapproveusername(var31.getDocapproveusertype() == 1 ? var15.getResourcename(var31.getDocapproveuserid() + "") : var14.getCustomerInfoname(var31.getDocapproveuserid() + ""));
                var31.setDocapprovedate(Util.null2String(var6.getString("docapprovedate")));
                var31.setDocapprovetime(Util.null2String(var6.getString("docapprovetime")));
                var31.setDocinvaluserid(var6.getInt("docInvalUserId"));
                var31.setDocinvalusertype(Util.getIntValue(Util.null2String(var6.getString("docInvalUserType"))));
                var31.setDocinvalusername(var31.getDocinvalusertype() == 1 ? var15.getResourcename(var31.getDocinvaluserid() + "") : var14.getCustomerInfoname(var31.getDocinvaluserid() + ""));
                var31.setDocinvaldate(Util.null2String(var6.getString("docInvalDate")));
                var31.setDocinvaltime(Util.null2String(var6.getString("docInvalTime")));
                var31.setDocarchiveuserid(var6.getInt("docarchiveuserid"));
                var31.setDocarchiveusertype(Util.getIntValue(Util.null2String(var6.getString("docArchiveUserType"))));
                var31.setDocarchiveusername(var31.getDocarchiveusertype() == 1 ? var15.getResourcename(var31.getDocarchiveuserid() + "") : var14.getCustomerInfoname(var31.getDocarchiveuserid() + ""));
                var31.setDocarchivedate(Util.null2String(var6.getString("docarchivedate")));
                var31.setDocarchivetime(Util.null2String(var6.getString("docarchivetime")));
                var31.setDoccanceluserid(var6.getInt("docCancelUserId"));
                var31.setDoccancelusertype(Util.getIntValue(Util.null2String(var6.getString("docCancelUserType"))));
                var31.setDoccancelusername(var31.getDoccancelusertype() == 1 ? var15.getResourcename(var31.getDoccanceluserid() + "") : var14.getCustomerInfoname(var31.getDoccanceluserid() + ""));
                var31.setDoccanceldate(Util.null2String(var6.getString("docCancelDate")));
                var31.setDoccanceltime(Util.null2String(var6.getString("docCancelTime")));
                var31.setMaindoc(var6.getInt("mainDoc"));
                var31.setMaindocname(var31.getMaindoc() == var31.getId() ? SystemEnv.getHtmlLabelName(524, var4.getLanguage()) + SystemEnv.getHtmlLabelName(58, var4.getLanguage()) : var8.getDocname(var31.getMaindoc() + ""));
                Map var24 = this.getChildDocInfo(var31);
                var31.setChilddoc((int[]) ((int[]) var24.get("childdocids")));
                var31.setChiledocname((String[]) ((String[]) var24.get("chiledocnames")));
                var31.setOwnerid(var6.getInt("ownerid"));
                var31.setOwnertype(Util.getIntValue(Util.null2String(var6.getString("ownerType"))));
                var31.setOwnername(var31.getOwnertype() == 1 ? var15.getResourcename(var31.getOwnerid() + "") : var14.getCustomerInfoname(var31.getOwnerid() + ""));
                var31.setInvalidationdate(Util.null2String(var6.getString("invalidationdate")));
                Map var25 = this.getDummy(var31);
                var31.setDummyIds((int[]) ((int[]) var25.get("dummyIds")));
                var31.setDummyNames((String[]) ((String[]) var25.get("dummyNames")));
                var31.setHrmresid(var6.getInt("hrmresid"));
                var31.setAssetid(var6.getInt("assetid"));
                var31.setCrmid(var6.getInt("hrmresid"));
                var31.setItemid(var6.getInt("itemid"));
                var31.setProjectid(var6.getInt("projectid"));
                var31.setFinanceid(var6.getInt("financeid"));
                if (var31.getDocType() == 2) {
                    Map var26 = this.getExtDocInfo(var31);
                    var31.setVersionId(Util.getIntValue((String) var26.get("versionId")));
                    var31.setImagefileId(Util.getIntValue((String) var26.get("imageFileId")));
                }

                var31.setIsreply(var6.getString("isreply"));
                var31.setReplydocid(var6.getInt("replydocid"));
                var31.setAccessorycount(var6.getInt("accessorycount"));
                var31.setReplaydoccount(var6.getInt("replaydoccount"));
                var5.add(var31);
            }
            long resultTime = System.currentTimeMillis() - start;
            new BaseBean().writeLog("文档循环执行时间： " + resultTime / 1000);
        }

        DocInfo[] var27 = new DocInfo[var5.size()];

        for (int var28 = 0; var28 < var5.size(); ++var28) {
            var27[var28] = (DocInfo) var5.get(var28);
        }

        return var27;
    }

    private Map getChildDocInfo(DocInfo var1) throws Exception {
        ArrayList var2 = new ArrayList();
        ArrayList var3 = new ArrayList();
        RecordSet var4 = new RecordSet();
        boolean var5 = true;
        String var6 = "";
        int var10;
        if (var1.getDocEditionId() > -1) {
            var4.executeSql(" select id,docSubject from DocDetail where doceditionid = " + var1.getDocEditionId() + " and doceditionid > 0  and (isHistory<>'1' or isHistory is null or isHistory='') order by docedition desc ");
            var4.next();
            var10 = Util.getIntValue(var4.getString("id"));
            var6 = Util.null2String(var4.getString("docSubject"));
        } else {
            var10 = var1.getId();
            var6 = var1.getDocSubject();
        }

        if (var10 > 0) {
            var2.add(var10 + "");
            var3.add(var6);
            boolean var7 = true;
            String var8 = "";
            var4.executeSql(" select id,docSubject from DocDetail where id <> " + var10 + " and mainDoc = " + var10 + " and (isHistory<>'1' or isHistory is null or isHistory='') order by id asc ");

            while (var4.next()) {
                int var11 = Util.getIntValue(var4.getString("id"));
                var8 = Util.null2String(var4.getString("docSubject"));
                if (var11 > 0) {
                    var2.add(var11 + "");
                    var3.add(var8);
                }
            }
        }

        int[] var12 = new int[var2.size()];

        for (int var13 = 0; var13 < var2.size(); ++var13) {
            var12[var13] = Util.getIntValue((String) var2.get(var13));
        }

        String[] var14 = new String[var3.size()];

        for (int var9 = 0; var9 < var3.size(); ++var9) {
            var14[var9] = (String) var3.get(var9);
        }

        HashMap var15 = new HashMap();
        var15.put("childdocids", var12);
        var15.put("chiledocnames", var14);
        return var15;
    }

    private Map getDummy(DocInfo var1) throws Exception {
        HashMap var2 = new HashMap();
        DocTreeDocFieldComInfo var3 = new DocTreeDocFieldComInfo();
        RecordSet var4 = new RecordSet();
        String var5 = "select catelogid from DocDummyDetail where docid=" + var1.getId();
        var4.executeSql(var5);
        ArrayList var6 = new ArrayList();
        ArrayList var7 = new ArrayList();

        while (var4.next()) {
            int var8 = Util.getIntValue(Util.null2String(var4.getString(1)));
            if (var8 > 0) {
                var6.add(var8 + "");
                var7.add(Util.null2String(var3.getTreeDocFieldName(var8 + "")));
            }
        }

        int[] var11 = new int[var6.size()];

        for (int var9 = 0; var9 < var6.size(); ++var9) {
            var11[var9] = Util.getIntValue((String) var6.get(var9));
        }

        String[] var12 = new String[var7.size()];

        for (int var10 = 0; var10 < var7.size(); ++var10) {
            var12[var10] = (String) var7.get(var10);
        }

        var2.put("dummyIds", var11);
        var2.put("dummyNames", var12);
        return var2;
    }

    private Map getExtDocInfo(DocInfo var1) throws Exception {
        HashMap var2 = new HashMap();
        RecordSet var3 = new RecordSet();
        String var4 = "";
        var4 = "select * from DocImageFile where docid=" + var1.getId() + " and (isextfile <> '1' or isextfile is null) order by versionId desc";
        var3.executeSql(var4);
        var3.next();
        int var5 = Util.getIntValue(var3.getString("versionId"), 0);
        int var6 = Util.getIntValue(var3.getString("imagefileid"));
        if (var5 == 0) {
            var3.executeSql("select * from DocImageFile where docid=" + var1.getId() + " order by versionId desc");
            if (var3.next()) {
                var5 = Util.getIntValue(var3.getString("versionId"), 0);
                var6 = Util.getIntValue(var3.getString("imagefileid"));
            }
        }

        var2.put("versionId", var5 + "");
        var2.put("imageFileId", var6 + "");
        return var2;
    }

    public int getDocCountByUser(User var1) throws Exception {
        if (var1 != null) {
            RecordSet var2 = new RecordSet();
            ShareManager var3 = new ShareManager();
            String var4 = "";
            if (var2.getDBType().equals("oracle")) {
                var4 = " from DocDetail t1," + var3.getShareDetailTableByUser("doc", var1) + " t2,DocDetailContent t3 where t1.id = t2.sourceid and t1.id = t3.docid ";
            } else {
                var4 = " from DocDetail t1," + var3.getShareDetailTableByUser("doc", var1) + " t2 where t1.id = t2.sourceid ";
            }

            var4 = var4 + " and ((docstatus = 7 and (sharelevel>1 or (t1.doccreaterid=" + var1.getUID() + ")) ) or t1.docstatus in ('1','2','5')) ";
            var4 = var4 + "  and seccategory!=0 and (ishistory is null or ishistory = 0) ";
            var4 = " select count(*) as c " + var4;
            new BaseBean().writeLog("getDocCount: sql = " + var4);
            var2.executeSql(var4);
            if (var2.next()) {
                return var2.getInt("c");
            }
        }

        return 0;
    }

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



