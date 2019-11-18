<%@ page import="com.alibaba.fastjson.JSONArray" %>
<%@ page import="com.alibaba.fastjson.JSONObject" %>
<%@ page import="weaver.conn.RecordSet" %>
<%@ page import="weaver.general.BaseBean" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.math.BigDecimal" %>
<%@ page import="java.util.Arrays" %>
<%@ page import="java.util.List" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<%
    // 变化发票字段
    String diffVal = Util.null2String(request.getParameter("diffVal"));
    // 全部发票字段
    String allVal = Util.null2String(request.getParameter("allVal"));
    // 申请人
    String sqrVal = Util.null2String(request.getParameter("sqrVal"));
    // 操作类型(1计算未含税金额， 2带出明细行+计算未含税金额)
    String operateType = Util.null2String(request.getParameter("operateType"));
    BaseBean baseBean = new BaseBean();
    baseBean.writeLog("BaoXiaoBack.jsp.jsp 收到diffVal： " + diffVal + " 申请人： " + sqrVal + ", allVal: " + allVal);

    JSONObject allObject = new JSONObject();
    if ("1".equals(operateType)) {
        allObject = calculateCounts(allVal);
    } else if ("2".equals(operateType)) {
        allObject = addRowAndCounts(diffVal, allVal);
    }
    out.clear();
    out.print(allObject.toJSONString());
%>

<%!
    /**
     * 计算选中发票的未含税金额
     * @param allVal 选种发票的uuid
     */
    private JSONObject calculateCounts(String allVal) {
        BaseBean baseBean = new BaseBean();
        JSONObject AllObject = new JSONObject();
        try {
            // 全部发票字段
            String[] split1 = allVal.split(",");
            StringBuilder allValBuilder = new StringBuilder();
            for (String split : split1) {
                allValBuilder.append("'").append(split).append("',");
            }
            allValBuilder.deleteCharAt(allValBuilder.length() - 1);

            RecordSet recordSet = new RecordSet();

            String selectSql = "select * from uf_fpinfo where uuid in (" + allValBuilder.toString() + ")";
            baseBean.writeLog("查询sql： " + selectSql);
            recordSet.executeQuery(selectSql);

            BigDecimal bigDecimal = new BigDecimal("0");
            while (recordSet.next()) {
                String bz = recordSet.getString("currencyTypeCode"); // 币种
                if ("CNY".equals(bz)) { // 只汇总人民币
                    String isDeductible = Util.null2String(recordSet.getString("isDeductible"));
                    String s;
                    if ("Y".equalsIgnoreCase(isDeductible)) {
                        s = Util.null2String(recordSet.getString("reimburseLineTotalAmount"));
                    } else {
                        s = Util.null2String(recordSet.getString("reimbursableAmount"));
                    }

                    if ("".equals(s)) {
                        s = "0";
                    }

                    bigDecimal = bigDecimal.add(new BigDecimal(s));
                }
            }
            baseBean.writeLog("bigDecimal.doubleValue(): " + bigDecimal.doubleValue());
            AllObject.put("allMoney", bigDecimal.doubleValue());
        } catch (Exception e) {
            baseBean.writeLog("FinanceAddBack.jsp calculateCounts异常： " + e);
        }
        return AllObject;
    }

    /**
     * 增加明细行 + 计算未含税金额
     * @param diffVal 增量发票uuid
     * @param allVal 全部选中的发票uuid
     */
    private JSONObject addRowAndCounts(String diffVal, String allVal) {
        BaseBean baseBean = new BaseBean();
        JSONObject AllObject = new JSONObject();
        try {
            // 增加的部分行
            String[] splits = diffVal.split(",");
            List<String> diffList = Arrays.asList(splits);

            // 全部发票字段
            String[] split1 = allVal.split(",");
            StringBuilder allValBuilder = new StringBuilder();
            for (String split : split1) {
                allValBuilder.append("'").append(split).append("',");
            }
            allValBuilder.deleteCharAt(allValBuilder.length() - 1);

            RecordSet recordSet = new RecordSet();
            RecordSet detailSet = new RecordSet();

            String selectSql = "select * from uf_fpinfo where uuid in (" + allValBuilder.toString() + ")";
            baseBean.writeLog("查询sql： " + selectSql);
            recordSet.executeQuery(selectSql);

            JSONArray arrays = new JSONArray();
            BigDecimal bigDecimal = new BigDecimal("0");
            while (recordSet.next()) {
                String invoiceNo = recordSet.getString("invoiceNo");
                String invoicecode = recordSet.getString("INVOICECODE");
                String uuid = recordSet.getString("uuid");
                String bz = recordSet.getString("currencyTypeCode"); // 币种
                if ("CNY".equals(bz)) { // 只汇总人民币
                    String isDeductible = Util.null2String(recordSet.getString("isDeductible"));
                    String s;
                    if ("Y".equalsIgnoreCase(isDeductible)) {
                        s = Util.null2String(recordSet.getString("reimburseLineTotalAmount"));
                    } else {
                        s = Util.null2String(recordSet.getString("reimbursableAmount"));
                    }
                    if ("".equals(s)) {
                        s = "0";
                    }
                    bigDecimal = bigDecimal.add(new BigDecimal(s));
                }
                if (!diffList.contains(recordSet.getString("uuid"))) {
                    continue;
                }
                // 查询明细数据
                if ("Y".equalsIgnoreCase(recordSet.getString("isDeductible"))) {
                    detailSet.executeQuery("select taxAmount, detailTransferTax, taxrate from uf_fpseinfo where uuid = '" + recordSet.getString("uuid") + "'");
                    while (detailSet.next()) {
                        JSONObject xmObject = new JSONObject();
                        xmObject.put("uuid", uuid);
                        xmObject.put("invoiceNo", invoiceNo);
                        xmObject.put("invoicecode", invoicecode);
                        xmObject.put("taxAmount", detailSet.getString("taxAmount"));
                        xmObject.put("detailTransferTax", detailSet.getString("detailTransferTax"));
                        xmObject.put("taxrate", detailSet.getString("taxrate"));
                        arrays.add(xmObject);
                    }
                }
            }

            AllObject.put("allMoney", bigDecimal.doubleValue());
            AllObject.put("arrays", arrays);
        } catch (Exception e) {
            baseBean.writeLog("FinanceAddBack.jsp addRowAndCounts异常： " + e);
        }
        return AllObject;
    }
%>