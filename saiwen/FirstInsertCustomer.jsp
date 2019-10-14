<%@ page import="com.weavernorth.saiwen.timed.SubjectTimed" %>
<%@ page import="weaver.general.TimeUtil" %>
<%@ page import="com.weavernorth.saiwen.myWeb.WebUtil" %>
<%@ page import="org.dom4j.Document" %>
<%@ page import="org.dom4j.DocumentHelper" %>
<%@ page import="org.dom4j.Element" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="weaver.conn.RecordSet" %>
<%@ page import="weaver.general.BaseBean" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<%
    String MODE_ID = "20";
    BaseBean baseBean = new BaseBean();
    String myXml = "<?xml version=\"1.0\" encoding=\"utf‐16\"?>\n" +
            "<Cbo_SupplierBankAccount_Query_Model>\n" +
            "</Cbo_SupplierBankAccount_Query_Model>";
    try {
        int insertCount = 0;
        int updateCount = 0;
        String currentTimeString = TimeUtil.getCurrentTimeString();
        baseBean.writeLog("定时获取客户信息 Start ================== " + currentTimeString);
        // 获取客户信息
        String returnXml = WebUtil.getCustomer(myXml);

        Document doc = DocumentHelper.parseText(returnXml);
        Element rootElt = doc.getRootElement();
        List resultList = rootElt.element("BankAccountList").elements();
        baseBean.writeLog("客户信息返回共计：" + resultList.size() + " 条");

        // 此次新增数据id集合
        List<String> addIdList = new ArrayList<String>();

        RecordSet recordSet = new RecordSet();
        RecordSet insertSet = new RecordSet();
        RecordSet updateSet = new RecordSet();
        recordSet.executeQuery("select supplier_id from uf_customer");
        // 已有数据的id集合
        List<String> idList = new ArrayList<String>(recordSet.getCounts());
        while (recordSet.next()) {
            idList.add(recordSet.getString("supplier_id"));
        }

        Element myElement;
        Object[] parameter = new Object[14];
        for (Object tableObj : resultList) {
            myElement = (Element) tableObj;
            parameter[0] = myElement.elementTextTrim("OrgName");
            parameter[1] = myElement.elementTextTrim("OrgCode");
            parameter[2] = myElement.elementTextTrim("Supplier_Name");
            parameter[3] = myElement.elementTextTrim("Supplier_Code");
            parameter[4] = myElement.elementTextTrim("Bank_Code");

            parameter[5] = myElement.elementTextTrim("Bank_Name");
            parameter[6] = myElement.elementTextTrim("SupplierBankAccount_Code");
            parameter[7] = myElement.elementTextTrim("OrgID");
            String supplierId = myElement.elementTextTrim("Supplier_ID");
            parameter[8] = supplierId;

            parameter[9] = MODE_ID;
            parameter[10] = "1";
            parameter[11] = "0";
            parameter[12] = TimeUtil.getCurrentTimeString().substring(0, 10);
            parameter[13] = TimeUtil.getCurrentTimeString().substring(11);

            if (idList.contains(supplierId)) {
                updateSet.executeUpdate("update uf_customer set org_name = ?, org_code = ?, supplier_name = ?, supplier_code = ?," +
                                "bank_code = ?, bank_name = ?, supplier_bank_account = ?, org_id = ?, modedatacreatedate = ?," +
                                "modedatacreatetime = ? where supplier_id = ?",
                        parameter[0], parameter[1], parameter[2], parameter[3],
                        parameter[4], parameter[5], parameter[6], parameter[7], parameter[12], parameter[13], supplierId);
                updateCount++;
            } else {
                idList.add(supplierId);
                addIdList.add(supplierId);
                insertSet.executeUpdate("insert into uf_customer(org_name, org_code, supplier_name, supplier_code, bank_code, " +
                        "bank_name, supplier_bank_account, org_id, supplier_id," +
                        "formmodeid,modedatacreater,modedatacreatertype,modedatacreatedate,modedatacreatetime) " +
                        "values(?,?,?,?,?, ?,?,?,?, ?,?,?,?,?)", parameter);
                insertCount++;
            }
        }

        baseBean.writeLog("新增： " + insertCount + ", 更新： " + updateCount);
        baseBean.writeLog("定时获取客户信息 End ================== " + TimeUtil.getCurrentTimeString());
    } catch (Exception e) {
        baseBean.writeLog("定时获取客户信息 Error: " + e);
    }


%>
























