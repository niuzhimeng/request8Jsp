<%@ page import="com.alibaba.fastjson.JSONArray" %>
<%@ page import="com.alibaba.fastjson.JSONObject" %>
<%@ page import="weaver.conn.RecordSet" %>
<%@ page import="weaver.general.BaseBean" %>
<%@ page import="weaver.general.Util" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<%
    // 变化发票字段
    String diffVal = Util.null2String(request.getParameter("diffVal"));
    // 全部发票字段
    String allVal = Util.null2String(request.getParameter("allVal"));
    // 申请人
    String sqrVal = Util.null2String(request.getParameter("sqrVal"));

    BaseBean baseBean = new BaseBean();
    baseBean.writeLog("FinanceAddFtBack.jsp 收到diffVal： " + diffVal + " 申请人： " + sqrVal + ", allVal: " + allVal);

    JSONObject allObject = addRow(diffVal);
    out.clear();
    out.print(allObject.toJSONString());
%>

<%!

    /**
     * 增加明细行
     * @param diffVal 增量发票uuid
     */
    private JSONObject addRow(String diffVal) {
        BaseBean baseBean = new BaseBean();
        JSONObject AllObject = new JSONObject();
        try {
            // 全部发票字段
            String[] split1 = diffVal.split(",");
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
            JSONArray mainArrays = new JSONArray();
            while (recordSet.next()) {
                JSONObject mainObject = new JSONObject();
                String invoiceNo = recordSet.getString("invoiceNo");
                String invoicecode = recordSet.getString("INVOICECODE");
                String invoiceTypeName = recordSet.getString("invoiceTypeName");
                String salerName = recordSet.getString("salerName");
                String uuid = recordSet.getString("uuid");
                String currencyTypeName = recordSet.getString("currencyTypeName");
                String totalAmount = recordSet.getString("totalAmount");
                String invoiceAmount = recordSet.getString("invoiceAmount");
                String taxAmount = recordSet.getString("taxAmount");
                String isdeductible = recordSet.getString("ISDEDUCTIBLE");

                mainObject.put("invoiceNo", invoiceNo);
                mainObject.put("uuid", uuid);
                mainObject.put("invoiceTypeName", invoiceTypeName);
                mainObject.put("salerName", salerName);
                mainObject.put("currencyTypeName", currencyTypeName);

                mainObject.put("totalAmount", totalAmount);
                mainObject.put("invoiceAmount", invoiceAmount);
                mainObject.put("taxAmount", taxAmount);
                mainObject.put("isdeductible", isdeductible);
                mainArrays.add(mainObject);

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

            AllObject.put("arrays", arrays);
            AllObject.put("mainArrays", mainArrays);
        } catch (Exception e) {
            baseBean.writeLog("FinanceAddFtBack.jsp addRowAndCounts异常： " + e);
        }
        return AllObject;
    }
%>