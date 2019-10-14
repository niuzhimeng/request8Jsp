<%@ page import="com.alibaba.druid.util.Base64" %>
<%@ page import="com.google.gson.Gson" %>
<%@ page import="com.google.gson.JsonObject" %>
<%@ page import="com.google.gson.JsonParser" %>
<%@ page import="com.google.gson.reflect.TypeToken" %>
<%@ page import="com.weavernorth.gaoji.ConsumerImpl" %>
<%@ page import="com.weavernorth.gaoji.sap.action.vo.POTableVo" %>
<%@ page import="com.weavernorth.gaoji.util.Utils" %>
<%@ page import="com.weavernorth.gaoji.vo.*" %>
<%@ page import="weaver.conn.RecordSet" %>
<%@ page import="weaver.general.BaseBean" %>
<%@ page import="weaver.general.TimeUtil" %>
<%@ page import="java.io.BufferedReader" %>
<%@ page import="java.io.IOException" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.concurrent.ExecutorService" %>
<%@ page import="java.util.concurrent.Executors" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<jsp:useBean id="RequestManager" class="weaver.workflow.request.RequestManager" scope="page"/>
<jsp:useBean id="flowDocss" class="weaver.workflow.request.RequestDoc" scope="session"/>
<jsp:useBean id="DocComInfo" class="weaver.docs.docs.DocComInfo" scope="page"/>
<jsp:useBean id="Doccoder" class="weaver.docs.docs.DocCoder" scope="page"/>

<%
    /**
     * 接收MDM数据
     */
    BaseBean baseBean = new BaseBean();
    Gson gson = new Gson();
    //固定长度线程池
    ExecutorService executorService = Executors.newFixedThreadPool(5);
    try {
        String poauth = request.getHeader("Authorization");
        baseBean.writeLog("Authorization --- " + poauth);
        String userPwd = baseBean.getPropValue("poMutualConn", "oaAuthPwd");
        String byteArrayToBase64 = Base64.byteArrayToBase64(userPwd.getBytes());
        String oaauth = "Basic " + byteArrayToBase64;
        baseBean.writeLog("oaauth --- " + oaauth);
        //外部访问凭证校验，校验通过执行操作
        if (poauth != null && oaauth.equals(poauth.trim())) {
            SimpleDateFormat dateformat1 = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
            String json = getPostData(request.getReader());
            baseBean.writeLog("接收到MDM数据 ========= " + TimeUtil.getCurrentTimeString() + "接收的数据：" + json);
            JsonObject jsonObject = new JsonParser().parse(json).getAsJsonObject();
            String tableStr = jsonObject.get("Table").toString();

            List<OrganizationVo> organizationVoList = new ArrayList<>();//机构集合
            List<PersonVo> personVoList = new ArrayList<>();//人员集合
            if (jsonObject.get("Table").isJsonArray()) {
                List<POTableVo> pOTableVoList = gson.fromJson(tableStr, new TypeToken<List<POTableVo>>() {
                }.getType());

                if (pOTableVoList != null && pOTableVoList.size() > 0) {
                    String btype = pOTableVoList.get(0).getBtype().trim();
                    String bdataString = pOTableVoList.get(0).getBdata().trim();

                    String bguid = pOTableVoList.get(0).getBguid().trim();
                    int insertBtype = Integer.parseInt(btype);
                    String source = pOTableVoList.get(0).getBsource().trim();
                    int bsource = Integer.parseInt(source);
                    String destination = pOTableVoList.get(0).getBdestination().trim();
                    int bdestination = Integer.parseInt(destination);
                    String bdatetime = pOTableVoList.get(0).getBdatetime().trim();
                    String status = pOTableVoList.get(0).getBstatus().trim();
                    int bstatus = Integer.parseInt(status);
                    String bcallback = "";
                    String bversion = pOTableVoList.get(0).getBversion().trim();
                    String bdatahash = pOTableVoList.get(0).getBdatahash().trim();
                    String bkeys = pOTableVoList.get(0).getBkeys().trim();
                    String insertBkeys = "";
                    if (bkeys.length() < 95) {
                        insertBkeys = bkeys;
                    } else {
                        insertBkeys = bkeys.substring(0, 95);
                    }
                    String insertBdata = "";
                    if (tableStr.length() < 3500) {
                        insertBdata = tableStr;
                    } else {
                        insertBdata = tableStr.substring(0, 3500);
                    }

                    //更新流程日志表
                    StringBuilder insertSql = new StringBuilder("");
                    insertSql.append("insert into uf_sapData(bguid, btype, bsource, bdestination, bdatetime, bstatus, bcallback, bversion, bdatahash, bkeys, bdata, createtime, modifytime) values (");
                    insertSql.append("'" + bguid + "'," + insertBtype + "," + bsource + "," + bdestination + ",'" + bdatetime + "'," + bstatus + ",'" + bcallback + "','" + bversion + "','" + bdatahash + "','" + insertBkeys + "','" + insertBdata + "','" + dateformat1.format(new Date()) + "','" + dateformat1.format(new Date()) + "'");
                    insertSql.append(")");
                    baseBean.writeLog("接收MDM主数据SQL： " + insertSql.toString());
                    RecordSet recordSet = new RecordSet();
                    //recordSet.execute(insertSql.toString());
                }

                for (POTableVo pOTableVo : pOTableVoList) {
                    String btype = pOTableVo.getBtype().trim();
                    String bdataString = pOTableVo.getBdata().trim();

                    JsonObject bdata = new JsonParser().parse(bdataString).getAsJsonObject();
                    String data = bdata.get("data").toString();
                    //data = data.substring(1, data.length() - 1);//数组转为对象
                    if ("1071".equals(btype)) {
                        //机构
                        List<OrganizationVo> voList = gson.fromJson(data, new TypeToken<List<OrganizationVo>>() {
                        }.getType());
                        for (OrganizationVo vo : voList) {
                            organizationVoList.add(vo);
                        }
                        //OrganizationVo organizationVo = gson.fromJson(data, OrganizationVo.class);
                        //organizationVoList.add(organizationVo);
                    } else if ("1029".equals(btype)) {
                        //人员
                        List<PersonVo> voList = gson.fromJson(data, new TypeToken<List<PersonVo>>() {
                        }.getType());
                        for (PersonVo vo : voList) {
                            personVoList.add(vo);
                        }
                        //PersonVo personVo = gson.fromJson(data, PersonVo.class);
                        //personVoList.add(personVo);
                    } else {
                        consumerData(btype, data);
                    }
                }
            } else if (jsonObject.get("Table").isJsonObject()) {
                JsonObject tableObj = jsonObject.get("Table").getAsJsonObject();
                String btype = tableObj.get("btype").getAsString().trim();//数据类型
                String bdataString = tableObj.get("bdata").getAsString().trim();//内容

                String bguid = tableObj.get("bguid").isJsonNull() ? "" : tableObj.get("bguid").getAsString();
                int insertBtype = Integer.parseInt(btype);
                String source = tableObj.get("bsource").isJsonNull() ? "" : tableObj.get("bsource").getAsString();
                int bsource = Integer.parseInt(source);
                String destination = tableObj.get("bdestination").isJsonNull() ? "" : tableObj.get("bdestination").getAsString();
                int bdestination = Integer.parseInt(destination);
                String bdatetime = tableObj.get("bdatetime").isJsonNull() ? "" : tableObj.get("bdatetime").getAsString();
                String status = tableObj.get("bstatus").isJsonNull() ? "" : tableObj.get("bstatus").getAsString();
                int bstatus = Integer.parseInt(status);
                String bcallback = "";
                String bversion = tableObj.get("bversion").isJsonNull() ? "" : tableObj.get("bversion").getAsString();
                String bdatahash = tableObj.get("bdatahash").isJsonNull() ? "" : tableObj.get("bdatahash").getAsString();
                String bkeys = tableObj.get("bkeys").isJsonNull() ? "" : tableObj.get("bkeys").getAsString();
                String insertBkeys = "";
                if (bkeys.length() < 95) {
                    insertBkeys = bkeys;
                } else {
                    insertBkeys = bkeys.substring(0, 95);
                }
                String insertBdata = "";
                if (bdataString.length() < 3500) {
                    insertBdata = bdataString;
                } else {
                    insertBdata = bdataString.substring(0, 3500);
                }

                //更新流程日志表
                StringBuilder insertSql = new StringBuilder("");
                insertSql.append("insert into uf_sapData(bguid, btype, bsource, bdestination, bdatetime, bstatus, bcallback, bversion, bdatahash, bkeys, bdata, createtime, modifytime) values (");
                insertSql.append("'" + bguid + "'," + insertBtype + "," + bsource + "," + bdestination + ",'" + bdatetime + "'," + bstatus + ",'" + bcallback + "','" + bversion + "','" + bdatahash + "','" + insertBkeys + "','" + insertBdata + "','" + dateformat1.format(new Date()) + "','" + dateformat1.format(new Date()) + "'");
                insertSql.append(")");
                baseBean.writeLog("接收MDM主数据SQL： " + insertSql.toString());
                RecordSet recordSet = new RecordSet();
                //recordSet.execute(insertSql.toString());

                JsonObject bdata = new JsonParser().parse(bdataString).getAsJsonObject();
                String data = bdata.get("data").toString();
                //data = data.substring(1, data.length() - 1);//数组转为对象
                if ("1071".equals(btype)) {
                    //机构
                    List<OrganizationVo> voList = gson.fromJson(data, new TypeToken<List<OrganizationVo>>() {
                    }.getType());
                    for (OrganizationVo vo : voList) {
                        organizationVoList.add(vo);
                    }
                    //OrganizationVo organizationVo = gson.fromJson(data, OrganizationVo.class);
                    //organizationVoList.add(organizationVo);
                } else if ("1029".equals(btype)) {
                    //人员
                    List<PersonVo> voList = gson.fromJson(data, new TypeToken<List<PersonVo>>() {
                    }.getType());
                    for (PersonVo vo : voList) {
                        personVoList.add(vo);
                    }
                    //PersonVo personVo = gson.fromJson(data, PersonVo.class);
                    //personVoList.add(personVo);
                } else {
                    consumerData(btype, data);
                }
            }

            if (organizationVoList.size() > 0) {
                //organizationVoList.forEach(a -> baseBean.writeLog(a.toString()));
                organization(organizationVoList);
            }

            if (personVoList.size() > 0) {
                PersonRunnable personRunnable = new PersonRunnable();
                personRunnable.setPersonVoList(personVoList);
                baseBean.writeLog("此次同步人员数量： " + personVoList.size());
                executorService.execute(personRunnable);
                // person(personVoList);
            }
            out.clear();
            out.print("sucess");
        } else {
            out.clear();
            out.print("访问凭证校验不通过");
        }
    } catch (Exception e) {
        baseBean.writeLog("接收到MDM数据异常： " + e);
        out.clear();
        out.print(e);
    } finally {
        executorService.shutdown();
    }

%>

<%!
    /**
     * 机构信息处理
     * @param HrmSubCompanyV1 机构信息集合
     */
    private void organization(List<OrganizationVo> HrmSubCompanyV1) {
        String zwid = "2903";//所属职务id  测试环境2903 生产环境2908
        BaseBean baseBean = new BaseBean();
        ConsumerImpl consumer = new ConsumerImpl();
        //分部集合
        List<HrmSubCompany> hrmSubCompanyList = new ArrayList<>();
        //部门集合
        List<HrmDepartment> hrmDepartmentList = new ArrayList<>();
        //岗位集合
        List<HrmJobTitles> hrmJobTitlesList = new ArrayList<>();
        //HrmSubCompanyV1.sort(Comparator.comparing(OrganizationVo::getGRADE));
        for (OrganizationVo vo : HrmSubCompanyV1) {
            if ("UN".equals(vo.getCODESETID())) {
                //单位（分部）
                HrmSubCompany hrmSubCompany = new HrmSubCompany();
                hrmSubCompany.setHrguid(vo.getGUIDKEY());//HR唯一键
                hrmSubCompany.setSubname(vo.getCODEITEMDESC());//名称
                hrmSubCompany.setSfmd(Utils.definedChange(vo.getSFMD()));//是否门店
                hrmSubCompany.setSubcode(vo.getCODEITEMID());//编码
                hrmSubCompany.setSfxzjg(Utils.definedChange(vo.getSFXZJG()));//是否行政机构 1：是  2：否
                hrmSubCompany.setGrade(vo.getGRADE());//层级
                hrmSubCompany.setStatus(vo.getStatusChange());//可用状态 可用：1  非可用：0
                hrmSubCompany.setSupsubcode(vo.getPARENTID());//父编码

                hrmSubCompanyList.add(hrmSubCompany);
            } else if ("UM".equals(vo.getCODESETID())) {
                //部门
                HrmDepartment hrmDepartment = new HrmDepartment();
                hrmDepartment.setHrguid(vo.getGUIDKEY());//HR唯一键
                hrmDepartment.setDepname(vo.getCODEITEMDESC());//名称
                hrmDepartment.setSfmd(Utils.definedChange(vo.getSFMD()));//是否门店
                hrmDepartment.setDepcode(vo.getCODEITEMID());//编码
                hrmDepartment.setSfxzjg(Utils.definedChange(vo.getSFXZJG()));//是否行政机构 1：是  2：否
                hrmDepartment.setGrade(vo.getGRADE());//层级
                hrmDepartment.setStatus(vo.getStatusChange());//可用状态 可用：1  非可用：0
                hrmDepartment.setSupdepcode(vo.getPARENTID());//父编码

                hrmDepartmentList.add(hrmDepartment);
            } else if ("@K".equals(vo.getCODESETID())) {
                //岗位
                HrmJobTitles hrmJobTitles = new HrmJobTitles();
                hrmJobTitles.setHrguid(vo.getGUIDKEY());//HR唯一键
                hrmJobTitles.setJobtitlecode(vo.getCODEITEMID());//编码
                hrmJobTitles.setJobtitlename(vo.getCODEITEMDESC());//名称
                hrmJobTitles.setJobactivityid(zwid);//所属职务id 写死

                hrmJobTitlesList.add(hrmJobTitles);
            }
        }
        if (hrmSubCompanyList.size() > 0) {
            baseBean.writeLog("分部处理开始======================数量： " + hrmSubCompanyList.size());
            consumer.operateFenbu(hrmSubCompanyList);
        }
        if (hrmDepartmentList.size() > 0) {
            baseBean.writeLog("部门处理开始======================数量： " + hrmDepartmentList.size());
            consumer.operateBumen(hrmDepartmentList);
        }
        if (hrmJobTitlesList.size() > 0) {
            baseBean.writeLog("岗位处理开始======================");
            consumer.hrmJobTitles(hrmJobTitlesList);
        }
    }

    /**
     * 人员信息处理
     * @param personVoList 人员信息集合
     */
    private void person(List<PersonVo> personVoList) {
        ConsumerImpl consumer = new ConsumerImpl();
        BaseBean baseBean = new BaseBean();
        //人员集合
        List<HrmResource> hrmSubCompanyList = new ArrayList<>();
        //人员对象赋值
        for (PersonVo vo : personVoList) {
            HrmResource hrmResource = new HrmResource();
            hrmResource.setHrguid(vo.getGUIDKEY());//HR唯一键
            hrmResource.setWorkcode(vo.getSTAFFNUMBER());//员工编号
            hrmResource.setLastname(vo.getLASTNAME());//员工姓名
            hrmResource.setSex(Utils.sexChange(vo.getSEX()));//员工性别
            hrmResource.setLoginid(vo.getEMAIL());//系统登录号
            hrmResource.setCertificatenum(vo.getIDCARD());//身份证号

            hrmResource.setMobile(vo.getPHONE());//手机号码
            hrmResource.setStatus(vo.getSTATUS());//员工状态
            hrmResource.setLocation(vo.getLOCATION());//工作地点
            hrmResource.setEmail(vo.getEMAIL());//邮箱
            hrmResource.setManagerCode(vo.getDIRECTLEADER());//直接上级编码

            vo.getJOBACTIVITIENAME();//职位名称
            vo.getJOBLEVEL();//职位等级
            vo.getANNUALLEAVE();//年假结余
            vo.getCOMPANY();//单位
            hrmResource.setSeclevel(vo.getSECLEVEL());//安全等级

            hrmResource.setCreatedate(vo.getENTRYDATEChange());//入职时间
            hrmResource.setStartdate(vo.getDATEFIELDChange());//合同生效时间
            hrmResource.setEnddate(vo.getENDDATEChange());//合同结束时间
            hrmResource.setLaborrelation(vo.getLABORRELATION());//合同主体（合同签订单位）=================建模表
            hrmResource.setBankaccount(vo.getBANKACCOUNT());//银行账户

            hrmResource.setAccountcity(vo.getACCOUNTCITY());//开户城市
            hrmResource.setOpeningbank(vo.getOPENINGBANK());//开户行
            hrmResource.setSubbranchmess(vo.getSUBBRANCHMESS());//支行信息                =================建模表
            hrmResource.setDepcode(vo.getDEPCODE());//所属部门编号
            hrmResource.setJobtitlecode(vo.getJOBTITLECODE());//岗位编码

            vo.getSAPCOST();//成本中心对应SAP

            hrmSubCompanyList.add(hrmResource);
        }

        if (hrmSubCompanyList.size() > 0) {
            baseBean.writeLog("人员处理开始======================数量： " + hrmSubCompanyList.size());
            consumer.operateRenYuan(hrmSubCompanyList);
        }
    }

    /**
     *  数据字典处理
     * @param btype 数据类型
     * @param bdata 数据内容
     */
    private static void consumerData(String btype, String bdata) {

        ConsumerImpl consumer = new ConsumerImpl();
        Gson gson = new Gson();
        if ("1067".equals(btype)) {
            //供应商
        } else if ("1048".equals(btype)) {
            //成本中心（费用承担部门）
            List<UfWfqybm> ufWfqybmList = new ArrayList<>();
            List<CostCenterVo> costCenterVoList = gson.fromJson(bdata, new TypeToken<List<CostCenterVo>>() {
            }.getType());
            for (CostCenterVo vo : costCenterVoList) {
                UfWfqybm ufWfqybm = new UfWfqybm();
                ufWfqybm.setHrguid(vo.getGUIDKEY());//HR唯一键
                ufWfqybm.setCompanycode(vo.getCOMPANYCODE());//父编码
                ufWfqybm.setCode(vo.getCODE());//编码
                ufWfqybm.setFullname(vo.getFULLNAME());//机构名称
                ufWfqybm.setStatus(vo.getSTATUS());//可用状态
                ufWfqybmList.add(ufWfqybm);
            }
            consumer.operateWfqybm(ufWfqybmList);
        } else if ("1056".equals(btype)) {
            //内部订单（费用承担项目）
            List<UfNbdd> ufNbddList = new ArrayList<>();
            List<InternalOrderVo> internalOrderVoList = gson.fromJson(bdata, new TypeToken<List<InternalOrderVo>>() {
            }.getType());
            for (InternalOrderVo vo : internalOrderVoList) {
                UfNbdd ufNbdd = new UfNbdd();
                ufNbdd.setCode(vo.getAUFNR());//编码
                ufNbdd.setValue(vo.getKTEXT());//名称
                ufNbddList.add(ufNbdd);
            }
            consumer.operateNbdd(ufNbddList);
        } else if ("1073".equals(btype)) {
            //公司代码（费用承担主体）
            List<UfWfqyzt> ufWfqyztList = new ArrayList<>();
            List<CompanyCodeVo> companyCodeVoList = gson.fromJson(bdata, new TypeToken<List<CompanyCodeVo>>() {
            }.getType());
            for (CompanyCodeVo vo : companyCodeVoList) {
                UfWfqyzt ufWfqyzt = new UfWfqyzt();
                ufWfqyzt.setBm(vo.getCODE());//编码
                ufWfqyzt.setWfqyzt(vo.getNAME());//名称
                ufWfqyztList.add(ufWfqyzt);
            }
            consumer.operateWfqyzt(ufWfqyztList);
        }
    }

    private static String getPostData(BufferedReader reader) throws IOException {
        StringBuilder stringBuilder = new StringBuilder();
        String str;
        while ((str = reader.readLine()) != null) {
            stringBuilder.append(str);
        }
        return new String(stringBuilder).replaceAll("\\s*", "");
    }
%>





