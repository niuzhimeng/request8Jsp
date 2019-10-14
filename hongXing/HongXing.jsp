<%@ page import="org.apache.commons.lang.StringUtils" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea" %>
<%@ taglib uri="/WEB-INF/tld/browser.tld" prefix="brow" %>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page"/>
<script type="text/javascript" src="/js/select/script/jquery-1.8.3.min_wev8.js"></script>
<%@ include file="/systeminfo/init_wev8.jsp" %>

<%

%>
<script type="text/javascript">
    jQuery(document).ready(function () {
        checkCustomize = function () {
            var flag = false;
            var kyys = 'field14212';//可用预算
            var sqje = 'field14214';//本次申请金额
            var kyysVal = $("#" + kyys).val();
            var sqjeVal = $("#" + sqje).val();

            if (parseFloat(sqjeVal) <= parseFloat(kyysVal)) {
                flag = true;
            } else {
                flag = false;
                window.top.Dialog.alert('【本次申请金额】不能超过【项目可用预算】');
            }
            return flag;
        }
    })
</script>

<script type="text/javascript">
    jQuery(document).ready(function () {
        checkCustomize = function () {
            var flag = false;
            var zfje = 'field14231';//支付金额
            var kzfje = 'field14229';//可支付金额
            var zfjeVal = $("#" + zfje).val();
            var kzfjeVal = $("#" + kzfje).val();

            if (parseFloat(zfjeVal) <= parseFloat(kzfjeVal)) {
                flag = true;
            } else {
                flag = false;
                window.top.Dialog.alert('【支付金额】不能超过【可支付金额】');
            }
            return flag;
        }
    })
</script>

<script src="/workflow/request/testJsp/cw.js"></script>
<script type="text/javascript">
    var chaiLv_csjbid = 'field10085';//交通城市级别
    var chaiLv_jtgjzdid = 'field6514';//交通工具

    var zhuSu_csjbid = 'field10084';//住宿城市级别
    var zhuSu_rjfyid = 'field6990';//住宿日均费用

    var canYin_csjbid = 'field10086';//餐饮市级别
    var canYin_rjjeid = 'field6532';//餐饮人均金额

    var zfjeid = 'field8619';//支付金额
    var jkjeid = 'field8620';//借款金额
    var sjfkid = 'field6503';//本次报销金额

    var jtfhgid = 'field8618';//交通费是否合规
    var zsfhgid = 'field8616';//住宿费是否合规
    var cyfhgid = 'field8617';//餐饮费是否合规

    var successInfo = '标准内';
    var errorInfo = '标准外';

    var tbr;
    jQuery(document).ready(function () {
        //国栋代码-----------------start---------------
        jQuery("#field10148").bindPropertyChange(function () {
            var fycdzt = jQuery("#field10148").val();
            //发送请求
            $.post("/workflow/request/gaoji/FycdztUnionFycdcm.jsp", {
                "fycdzt": fycdzt
            }, function (data) {
                var data = data.replace(/\s+/g, "");
                if (data == 'true') {
                    changeFieldShowattr("10149", "2", "0", -1);//修改字段属性
                } else {
                    changeFieldShowattr("10149", "3", "0", -1);
                }
            });
        });
        //----------------------------end----------------
        $("#" + jtfhgid).attr('readonly', 'readonly');
        $("#" + zsfhgid).attr('readonly', 'readonly');
        $("#" + cyfhgid).attr('readonly', 'readonly');
        $("#" + zfjeid).attr('readonly', 'readonly');
        tbr = $("#field6495").val();
        //交通表
        _C.run2(chaiLv_csjbid, chaiLv);
        _C.run2(chaiLv_jtgjzdid, chaiLv);

        //住宿表==============
        _C.run2(zhuSu_csjbid, zhuSu);
        _C.run2(zhuSu_rjfyid, zhuSu);

        //餐饮表==============
        _C.run2(canYin_csjbid, canYin);
        _C.run2(canYin_rjjeid, canYin);

        //计算金额
        _C.run2(sjfkid, jisuan);

        function jisuan(p) {
            if (p.v.o == undefined) {
                return;
            }
            var fkfs = $("#" + jkjeid).val();//借款金额
            var sjfk = $("#" + sjfkid).val();//本次报销金额
            var myResult = sjfk - fkfs;
            if (myResult >= 0) {
                $("#" + zfjeid).val(myResult);
            } else {
                $("#" + zfjeid).val(0);
            }
        }
    });

    function chaiLv(p) {
        if (p.v.o == undefined) {
            return;
        }
        //遍历明细表
        var nums = $("#submitdtlid0").val().split(',');
        var allStr = '';
        for (var i = 0; i < nums.length; i++) {
            var csjb = $("#" + chaiLv_csjbid + '_' + nums[i]).val().trim();//城市级别
            var jtgj = $("#" + chaiLv_jtgjzdid + '_' + nums[i]).val().trim();//交通工具
            if (csjb != '' && jtgj != '') {
                allStr += csjb + ',' + jtgj + '#'
            }
        }
        //发送请求
        if (allStr.trim() != '') {
            $.post("/workflow/request/gaoji/ChaiLvCheckBack.jsp", {
                "allStr": allStr,
                "tbr": tbr,
                "type": "chaiLv"
            }, function (data) {
                var data = data.replace(/\s+/g, "");
                if (data == 'yes') {
                    $("#" + jtfhgid).val(successInfo);
                } else {
                    $("#" + jtfhgid).val(errorInfo);
                }
            });
        }
    }

    function zhuSu(p) {
        if (p.v.o == undefined) {
            return;
        }
        //遍历明细表
        var nums = $("#submitdtlid1").val().split(',');
        var allStr = '';
        for (var i = 0; i < nums.length; i++) {
            var csjb = $("#" + zhuSu_csjbid + '_' + nums[i]).val().trim();//城市级别
            var rjfy = $("#" + zhuSu_rjfyid + '_' + nums[i]).val().trim();//日均费用
            if (csjb != '' && rjfy != '') {
                allStr += csjb + ',' + rjfy + '#'
            }
        }
        if (allStr.trim() != '') {
            //发送请求
            $.post("/workflow/request/gaoji/ChaiLvCheckBack.jsp", {
                "allStr": allStr,
                "tbr": tbr,
                "type": "zhuSu"
            }, function (data) {
                var data = data.replace(/\s+/g, "");
                if (data == 'yes') {
                    $("#" + zsfhgid).val(successInfo);
                } else {
                    $("#" + zsfhgid).val(errorInfo);
                }
            });
        }
    }

    function canYin(p) {
        if (p.v.o == undefined) {
            return;
        }
        //遍历明细表
        var nums = $("#submitdtlid2").val().split(',');
        var allStr = '';
        for (var i = 0; i < nums.length; i++) {
            var csjb = $("#" + canYin_csjbid + '_' + nums[i]).val().trim();
            var rjje = $("#" + canYin_rjjeid + '_' + nums[i]).val().trim();
            if (csjb != '' && rjje != '') {
                allStr += csjb + ',' + rjje + '#'
            }
        }
        if (allStr.trim() != '') {
            //发送请求
            $.post("/workflow/request/gaoji/ChaiLvCheckBack.jsp", {
                "allStr": allStr,
                "tbr": tbr,
                "type": "canYin"
            }, function (data) {
                var data = data.replace(/\s+/g, "");
                if (data == 'yes') {
                    $("#" + cyfhgid).val(successInfo);
                } else {
                    $("#" + cyfhgid).val(errorInfo)
                }
            });
        }
    }
</script>





