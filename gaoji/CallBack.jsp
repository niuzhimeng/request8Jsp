<%@ page import="com.google.gson.JsonObject" %>
<%@ page import="com.google.gson.JsonParser" %>
<%@ page import="weaver.conn.RecordSet" %>
<%@ page import="weaver.general.BaseBean" %>
<%@ page import="weaver.general.TimeUtil" %>
<%@ page import="java.io.BufferedReader" %>
<%@ page import="java.io.IOException" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>
<%@ page import="com.alibaba.druid.util.Base64" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<jsp:useBean id="RequestManager" class="weaver.workflow.request.RequestManager" scope="page"/>
<jsp:useBean id="flowDocss" class="weaver.workflow.request.RequestDoc" scope="session"/>
<jsp:useBean id="DocComInfo" class="weaver.docs.docs.DocComInfo" scope="page"/>
<jsp:useBean id="Doccoder" class="weaver.docs.docs.DocCoder" scope="page"/>


<%
    /**
     * sap回调jsp
     */
    BaseBean baseBean = new BaseBean();
    try {
        String poauth = request.getHeader("Authorization");
        baseBean.writeLog("Authorization --- " + poauth);
        String userPwd = baseBean.getPropValue("poMutualConn","oaAuthPwd");
        String byteArrayToBase64 = Base64.byteArrayToBase64(userPwd.getBytes());
        String oaauth = "Basic " + byteArrayToBase64;
        baseBean.writeLog("oaauth --- " + oaauth);
        //外部访问凭证校验，校验通过执行操作
        if (poauth != null && oaauth.equals(poauth.trim())) {
            String json = getPostData(request.getReader());

            baseBean.writeLog("sap回调接口执行 --- " + TimeUtil.getCurrentTimeString() + "接收的数据：" + json);
            SimpleDateFormat dateformat1 = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
            JsonObject jsonObject1 = new JsonParser().parse(json).getAsJsonObject();
            JsonObject jsonObject = jsonObject1.get("Table").isJsonNull() ? new JsonObject() : jsonObject1.get("Table").getAsJsonObject();

            String bguid = jsonObject.get("bguid").isJsonNull() ? "" : jsonObject.get("bguid").getAsString();
            String type = jsonObject.get("btype").isJsonNull() ? "" : jsonObject.get("btype").getAsString();
            int btype = Integer.parseInt(type);
            String source = jsonObject.get("bsource").isJsonNull() ? "" : jsonObject.get("bsource").getAsString();
            int bsource = Integer.parseInt(source);
            String destination = jsonObject.get("bdestination").isJsonNull() ? "" : jsonObject.get("bdestination").getAsString();
            int bdestination = Integer.parseInt(destination);
            String bdatetime = jsonObject.get("bdatetime").isJsonNull() ? "" : jsonObject.get("bdatetime").getAsString();
            String status = jsonObject.get("bstatus").isJsonNull() ? "" : jsonObject.get("bstatus").getAsString();
            int bstatus = Integer.parseInt(status);
            String bcallback = "";
            String bversion = jsonObject.get("bversion").isJsonNull() ? "" : jsonObject.get("bversion").getAsString();
            String bdatahash = jsonObject.get("bdatahash").isJsonNull() ? "" : jsonObject.get("bdatahash").getAsString();
            String bkeys = jsonObject.get("bkeys").isJsonNull() ? "" : jsonObject.get("bkeys").getAsString();
            String bdata = jsonObject.get("bdata").isJsonNull() ? "" : jsonObject.get("bdata").getAsString();
            String insertBkeys = "";
            if(bkeys.length() < 95){
                insertBkeys = bkeys;
            } else {
                insertBkeys = bkeys.substring(0,95);
            }
            String insertBdata = "";
            if(bdata.length() < 3500){
                insertBdata = bdata;
            } else {
                insertBdata = bdata.substring(0,3500);
            }

            //更新流程日志表
            StringBuilder insertSql = new StringBuilder("");
            insertSql.append("insert into uf_sapData(bguid, btype, bsource, bdestination, bdatetime, bstatus, bcallback, bversion, bdatahash, bkeys, bdata, createtime, modifytime) values (");
            insertSql.append("'"+bguid+"',"+btype+","+bsource+","+bdestination+",'"+bdatetime+"',"+bstatus+",'"+bcallback+"','"+bversion+"','"+bdatahash+"','"+insertBkeys+"','"+insertBdata+"','"+dateformat1.format(new Date())+"','"+dateformat1.format(new Date())+"'");
            insertSql.append(")");
            baseBean.writeLog("sap回调SQL： " + insertSql.toString());
            RecordSet recordSet = new RecordSet();
            recordSet.execute(insertSql.toString());
            out.clear();
            out.print("success");
        } else {
             out.clear();
             out.print("访问凭证校验不通过");
         }

    } catch (Exception e) {
        baseBean.writeLog("sap回调接口处理异常： " + e);
        out.clear();
        out.print("error");
    }

%>

<%!
    private static String getPostData(BufferedReader reader) throws IOException {
        StringBuilder stringBuilder = new StringBuilder();
        String str;
        while ((str = reader.readLine()) != null) {
            stringBuilder.append(str);
        }
        return new String(stringBuilder).replaceAll("\\s*", "");
    }
%>





