<%@ page import="com.weavernorth.taide.kaoQin.kqmx.timedTask.TimedKqmx" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page"/>
<%@ include file="/systeminfo/init_wev8.jsp" %>


<%
    new TimedKqmx().execute();
    out.print("考勤明细同步完成。" + TimeUtil.getCurrentTimeString());
%>

<script src="/workflow/request/testJsp/shauter_wev8.js"></script>
<script type="text/javascript">
    var xqhtksrq = 'field13825'; // 原合同结束日期
    var xqlx = 'field13862'; // 续签类型
    var xqhtjsrq = 'field13827'; // 续签合同结束日期
    var qianZhui = '13827'; // 续签合同结束日期 - 后缀

    jQuery(document).ready(function () {

        jQuery('#' + xqlx).change(function () {
            var xqhtjsrqVal = jQuery('#' + xqhtksrq).val();
            var date = new Date(xqhtjsrqVal);
            var xqlxVal = jQuery('#' + xqlx).val();

            shuXingChange(xqlxVal); // 修改字段属性

            if (0 == xqlxVal) {
                // 有固定期限劳动合同
                date.setFullYear(date.getFullYear() + 3);
                jQuery('#' + xqhtjsrq).val(date.format("yyyy-MM-dd"));
                jQuery('#' + xqhtjsrq + 'span').html(date.format("yyyy-MM-dd"));
            } else if (1 == xqlxVal) {
                // 无固定期限劳动合同
                jQuery('#' + xqhtjsrq).val('9999-12-31');
                jQuery('#' + xqhtjsrq + 'span').html('9999-12-31');
            } else if (3 == xqlxVal) {
                // 退休返聘协议
                date.setFullYear(date.getFullYear() + 1);
                jQuery('#' + xqhtjsrq).val(date.format("yyyy-MM-dd"));
                jQuery('#' + xqhtjsrq + 'span').html(date.format("yyyy-MM-dd"));
            }else {
                jQuery('#' + xqhtjsrq).val('');
                jQuery('#' + xqhtjsrq + 'span').html('');
            }

        });

        function shuXingChange(xqlxVal) {
            if (0 == xqlxVal || 1 == xqlxVal || 3 == xqlxVal) {
                // 只读
                changeFieldShowattr(qianZhui, "3", "0", '-1');//1、编辑 2、必填 3、只读; 0主表 1明细表
            }else {
                // 编辑
                changeFieldShowattr(qianZhui, "2", "0", '-1');//1、编辑 2、必填 3、只读; 0主表 1明细表
            }
        }
    })
</script>