<%@ page import="weaver.conn.RecordSetDataSource" %>
<%@ page import="weaver.integration.util.HTTPUtil" %>
<%@ page import="java.util.regex.Matcher" %>
<%@ page import="java.util.regex.Pattern" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<script type="text/javascript" language="javascript">
    window.onload = function () {
        document.getElementById("loginForm").submit();
    }

</script>
<%
    // 单点SFA系统
    RecordSetDataSource recordSet = new RecordSetDataSource("orcl");
    recordSet.execute("select * from cus_fielddata where id = " + user.getUID());
    String loginid = "";
    if (recordSet.next()) {
        loginid = recordSet.getString("field9");
    }

    String url = "http://sfa.redstarwine.com/eispcasserver/login?service=http://sfa.redstarwine.com/eisp-mdm//mainFrame";

    String returnHtml = HTTPUtil.doGet(url);

    String group = "";
    if (returnHtml != null && !"".equals(returnHtml)) {
        String reg = "name=\"execution\" value=\"(.*?)\"/>";
        Pattern pattern = Pattern.compile(reg);
        Matcher matcher = pattern.matcher(returnHtml);
        if (matcher.find()) {
            group = matcher.group(1);
        }
    }
    if (group.length() < 20) {
        group = "16c07f8b-a211-43ad-9821-405bf5b1c6ef_ZXlKaGJHY2lPaUpJVXpVeE1pSjkuTUdNd1NrWktiVU42ZUZOelptTnRVVkUzYTFoeEwzZ3ZhWGd3U0hwWGNqZG1ObEp0YkRJclpGZFBlSEpHVTJSM2FYWk1PVVZVYm5GYWVHRm9VRXBwVkdaeVREbFBkbGx6YUhWdldrSmhibnBaTkVKWk9EQkpiREF2VDIwdlZ6aG9XakJ0ZGtobmRXbE1VVmd5Y0VJdmEzQXJWWE4xTjJGNlQwaHRWMHhuYjJ4NWJIazJOSFo2YjJaaFlscEpMekJwT1RCc0wyaDJXREV6YVdWMlREQk5lbXc0VlRBM1dTODVaM3BUU1dabFkweERNRXBDVm1OSE1DOTZkV2xsY1dOR1NsTlNOVk5DYWsxYU4zWXdZVTFxVG5aS2JGSXhOakJOWVROdVYwTTRSMnR0VEdGRmRXZEVjRGxyZGxkMFEwMDNWRWRMUzNNMFdGVXJaMmw1WVZkcldGY3dkVmxsYTNFd2RWQlFlblU0VmsxNmVWZFdXRGRQWVdkV2FXcG9WVVZrYkdSSVNFb3lVV1V6UVhvMmMwcEVaMWRLYWtkSE5tdERVR0l2WlVSRVZVSTBRemxSZURKVlFYZGtZMmczSzIxd2NVUTJWRk42VUVSa1JIVTNNVlI0UlRaQlkzVklOR3R5WVVaSVEwOXFhMHhhU2tnMFlUUm5jazVFUmxWRlQwNTBUa0U0Vm5KbVNubDRNbTR4UjBwSFlsSTBWWEJqZWxndlNXTXpXSE4wV0ZONGVXTm5Ta1JJUkRCd1ppODFjVGhTWWs1UWVUQkpXakJWUVRaM0wyVTJNVzlzTjNsVk55OU1RMFEyWVU5U1VHNDFiM1V4WlV4SU1HYzVTV1kzZDBOblRqZEhRWG8zZWtjeFZXTm5LMHRGUjJoTlpGaENhRGx4Tm1GNE1ISmxWbGRQV1c1QmFIb3hWVGRYT0ZoQ1ZWQTFVWGQ1WVd3dlYyMVRRMGh0WWtSd2RtdEpjVUZDTTFOWFdsUTJhWEp4ZEZsR1ZWbzFOMlIyUVZSV2NEQjRNR1Z6UVN0eWExRXhRM1ZuZDNsNGMzUjZUakpuT0hVelRtSlVSR2R2VW1KeU5WUTFaM1l3TjFJMWRYbHZhVnBsWW5oTGExUnJjMU5yVVhveVpIWlpNekUwVGxGeVUxRjVNRE4zTlhOS01pdFZUbVZhTm1nNFNIbFljSFpHWmxsSVJHNUROVWd2YWt4bVVuUlphRFJ5UzBOblNEZDVUMWRuYVZkRVMwaHFkVWxrYTNCWFZrSllhMlZCWjI1WVNHWlVWeTlTSzBKT2JHazNjMDgxVWxZMlUzVlJUa3BwYkZSRWFGZHFRV1Y0YjA5M2JHZGlUMEpYU1U5a01VZ3hTREp5UWs5UlpuRnVPRzFyYWl0b1pqZGFTSGx2YURkS04yUm5URGN4WTFsV1YzQlFkRWxZVWt4ck4wYzFaVWRHYUVsek9ITmtRVVZZUlc5VFRqVmFaRVJXVVhCMmFXeEdSWEoxY1RZNU5qVXhhMU14VmxkeFRVZFhibUp6Tmsxb1pXTmFOVWcwVEdORmVucFdPVEkzTm5wUlExTlFiR0UzUTFoM2FscFBSekV2UWs4Mk9FRnlTRkZCVUd0UE1uRmlXRGRTWXpOQ1FrRmlUbFZDTHpKWWVuRm9RMDVMY0UxaGJVOWthV0ZFUzJ4UVIyY3dWSEJOTXl0T2JGWjBZVlV2YUZoRGNEUmxabXBDU0dWS2JsQkZVUzlPYkRBd05IQm5lV05aTlRsQ1NrTlBRVmRwTm1SdGRVeHJkMloxUW5Wdk5HZzVLMXBsTkU1aGNXVkRjRmxQUVVvNVYwSmpaR1puWWxCV2QyNW5RMXBPTHpoM1YydFVNVnAwSzJGYVdpczVTQ3RxZW1JellVcENhMFpDU1dkVmNWVXJRVUptZW0weGJIVk5OVnBRWkZSVVpFbHBVM2M0SzFnMlNFaDVUMDB2UlZWTU0wZEdSalZWVjNjMGNWRXJPVlJwU1hKeVFVMWhhVVYzWmpCb2JUUlRiSEJSY1hka1YwMXNXWGh0TjFNdlFXRkRTazlWU200eFpGWmljR1oxU1c4cll6QnJabkJpWmtRM2NEUjBVelpKZG1vck5VMU9aMFJEYXpkcGQyZEtaamxpTW5BMlMxTkJORTQyU1hkNVFqUnVRek5hYkM5Q1psUnJPRkIzZUc5SVl6WjVhRXhUWW5CUUwzRlRTbFJ5VG5ocVpEazBiRmhZYUdaRk1tZFpNREp5TURoTlN6bDNiRzVKYzBKaFZVOUNSeTkwTmtkWE5tWm5VbmhxVUU1cUwwazBWRmhYYUdsdVZpc3lZMm9yYUZsNGIzZzJhVFJFVVd4eFVVOVNkVkExWVRSa1RUWnpVR1ZNWkU5RFpHUjNlRWhaVkVkVmVUTkRVQzk0ZVhOeE5uRk1jMnhrVkdJMFEwRm5PV3h2UjNKdWNsVjFRbXd6VDJ4SWIyMUpUVWRQWm5wbmNraFpVMlpzZWt4dVVubFlVMkZRZW1Vd1NsTTJObXcyUjI5TVdsUnFjUzlRYkVKVlVtSTRaM3BJWW5ObmNqaFNXU3RhYUdOelNsUmhXbHBtV2tGRE4xaENZazQyZEdKdVZYVXpiazV0UTJOdmVIbzRiVkp0YVZoeFEzaDVSMk5RVlZGQk5GVnNlVTFMVTFJNFVtOUJUVmx1ZG1acWQzRjRUMjlyTURrcldVNVdaRU5OYTNGT1NYaHRaakJEU2t0RlMxcEhZbEoyWTFaemVsVnFNWGhXZGpaak9FeE5iMjFZZUdkck5UZFRVMlpYY1V4RFZHSkhZWFZ1TkUxT2MwMTViSGc1UjNsNGRXMUpMMHQxV2taa1kxWkZSVUkyY2k4eWEwRlVSM3B4YkU0eFpVRjVVMFZUZG5oRFUwdGxjU3RzTld4UVdXSkZNRFo0TVZKVVdETlZOek13UTJvelFrcGhNa3BwTjNOblQwSXlXVzF2ZDFZelEwRlVialozYjNOTllYcEVRMDFXSzB0UVkyUlFiVVptY21wd01qQnBVVVZOYUhscFpqSnNVbXRKUTFKaGVVZExVbVEzYzJ4TmMweFpUWFF4ZHpSeFpHWlVRelZqV0UxTldtb3paVTltTXpWSldrRmhXRkZKT1drMVJrNTZTRUlyWTFsV2EyVndSa052YkVGM01rdGtUMVZsV21OcU4wSnFWbkJ6TlVwTlRqQktha2hSTTA5V1MyeFhlVWh3Y1hkeWIzWm1WaXRNTkRGUVZuUmFjMmcwTldGRVdXbG5ZMjQ1YUZFeVF6TnBWalJXY0RkTU9FeGlhMHhDUWs1NFRqSktXbVl4UVhZNE1pOVhTa0ZZUjNSU1Jtb3dURFJyWkUwMFZFdzVVWFZxZEZJMFIybGliMkpUZEZrek0waDBOVzlGZEVNeVdsUkNlQzl0ZWpRd2JFNU5WMHRaVmxkMGEycEhkME5CTmpCS01qSktMM2R6ZVZNMVRGbGllRWxDTkVoblUzQnBhRkEzTDI5Q1JVbzBaUzg0V0VKNE0zZEdRV2RRUkRkRU5FMTNjMmhsYnpVelJ5dE1abEZaYUZWc1lqTlBibVUzT1V0VUwyVjZUMVJ0Ukcxek5uZEVNSEZQTWsxUFNUTXdkV0Z0TkVRek5YSkRObXRRU1VoS1dtZEhjWGRvTURjMVF6UkxZVkZNV0hab2RFZ3dkRVJNY25sWlNXMVdZM2hCZVZkb1YwRlJaMVJvZGpOcWExbzNWbTFtYUVsUk9FOU5WWEpvUTNock5Vd3hORUpXVlhsV05uUlhZMlJHUjJOSE5saGtWVFYwWmpsdGNHdHFaRFJLY1RSTU1VMDNRVkJsUXpCck5EVk1aa3RQWWxoblEzaHZRbkExV2pFNWVEWTBibFJoYzFJNFEweHZjVTlVTWxWa1ltbFJSM3BhVmxab05rUnZOVWhaUmxNeGFGWkhUbVI2U2pKaFpIVXhaa2RyY0VWM1JUQlNiemR0UjFOa1ZHOTVPRWN6T0VWSldWWkRWVWczSzBkeVlUVm5abmt5UVRrdmJtUjNSSGQyZDNaeVRISnZMM2N4ZDFOM1lXdDVXbVZaSzNOM2VtNU1jWFpEWmtGUmVFcDVOMHR1V25ST1pDOTVhaTlRVTNkSVlraFNVbUV4ZDBFM1kxcFlTekYzZFc1SFJHc3JhVFU1UW1wbWVGUmtWMnBCY2pKaE1rdE1XWGhoYjA1elVVOW5ZWFpMYkdsTE5VWnhjVmRYZDNoRFNHTmxUbkpYYTFScWMyUlZNazVFWm1VdmQwbGtjblpOZUZKNWJXZERVRUZOZVdVMFIzZDFXVVpHWW01eFQyNVlORGhLU2xkT1JVZENNWGhpTkVrM2JESlZXRXgyWjFOM1VYTlBiMHRaWmtjeWMyMXdNRlJtVEZCU1NVVm5jMWs0UFEub25yWW9jbWdsX3lGSWxoS0RSQlNtTHJzNFJyZVh6U0lHVlNTZHlhd200bmhuSk1LYTlzZXpUU2Vud0VNZDNEUVlMLV91Y3FZRWsxWGNCVWtjb0JEOUE=";
    }

    String strFinal = "dea3cdbe10c327ec87c6058f8b48cc7b"; // 约定字符串
    String password = loginid + strFinal;

%>

<html>
<body>
<form id="loginForm"
      action="http://sfa.redstarwine.com/eispcasserver/login?service=http://sfa.redstarwine.com/eisp-mdm//mainFrame"
      method="post" style="display:none">
    <input type="hidden" id="username" name="username" value="<%=loginid%>"/>
    <input type="hidden" id="password" name="password" value="<%=password%>"/>
    <input type="hidden" id="execution" name="execution"
           value="<%=group%>"/>
    <input type="hidden" id="_eventId" name="_eventId" value="submit"/>
    <input type="button" class="login-sign" name="" id="" value="跳转到sfa"/>
</form>
</body>
</html>




