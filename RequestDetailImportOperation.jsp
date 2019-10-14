
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util,java.net.*"%>
<%@ page import="weaver.file.FileUploadToPath" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RequestDetailImport" class="weaver.workflow.request.RequestDetailImport" scope="page"/>
<%
    FileUploadToPath fu = new FileUploadToPath(request) ;
String f_weaver_belongto_userid=fu.getParameter("f_weaver_belongto_userid");
String f_weaver_belongto_usertype=fu.getParameter("f_weaver_belongto_usertype");
user = HrmUserVarify.getUser(request, response, f_weaver_belongto_userid, f_weaver_belongto_usertype) ;
int userid = user.getUID();
    String src = Util.null2String(fu.getParameter("src"));
    int requestid = Util.getIntValue(fu.getParameter("requestid"));
    if( !src.equals("save") || requestid == -1 ) {
        out.print("<script>wfforward('/notice/RequestError.jsp');</script>");
    }else{
        out.print("<script>try{");
        String errmsg=RequestDetailImport.ImportDetail(fu,user);
        if(!errmsg.equals("")){
            out.print("alert('"+errmsg+"');");
        }else{
            out.print("top.Dialog.alert('"+SystemEnv.getHtmlLabelName(25750, user.getLanguage())+"');");
        }
		out.print("parent.close();top.window.location.href='ViewRequest.jsp?f_weaver_belongto_userid=" + userid + "&f_weaver_belongto_usertype=" + f_weaver_belongto_usertype +"&requestid="+requestid+"';");
         out.print("}catch(e){}");
        out.print("</script>");
    }
%>