<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea" %>
<%@ taglib uri="/WEB-INF/tld/browser.tld" prefix="brow" %>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page"/>
<script type="text/javascript" src="/js/select/script/jquery-1.8.3.min_wev8.js"></script>
<%@ include file="/systeminfo/init_wev8.jsp" %>

<script type="text/javascript">
    jQuery(document).ready(function () {
        checkCustomize = function () {
            var flag = false;
            var kyys = 20000; //可用预算
            var sqje = 'field14214';//本次申请金额
            var sqjeVal = jQuery("#" + sqje).val();

            if (parseFloat(sqjeVal) <= parseFloat(kyys)) {
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
    $(function () {
        $('#\\$addbutton0\\$').click(function () {
            $("#field6777span").children("span").children("a").text('');
        })

    })
</script>

<%-- 费控 2018-12-29 --%>
<script type="text/javascript">
    var xmbx = 'field9907'; // 是否为项目报销
    var bm = 'field9893'; // 部门
    var bmChina = 'field14748'; // 部门中文名
    var xmbh = 'field9942'; // 项目编号

    var gslx = 'field13870'; // 归属类型
    var gsdw = 'field13871'; // 归属单位
    $(function () {
        $('#' + xmbx).bindPropertyChange(function () {
            fuZhi();
        });

        $('#\\$addbutton0\\$').click(function () {
            setTimeout("fuZhi()", 500);
        });
    });

    function fuZhi() {
        var checkNums = $("#submitdtlid0").val().split(',');
        var xmbxVal = $('#' + xmbx).val();

        if (0 == xmbxVal) {
            //项目
            for (var i = 0; i < checkNums.length; i++) {
                $("#" + gslx + '_' + checkNums[i]).val(3);

            }
        } else {
            $('#' + xmbh).children('span').children("a").text('');
            // 部门id
            var bmVal = $('#' + bm).val();
            // 部门中文名
            var bmChinaVal = $('#' + bmChina).val();
            for (var checkI = 0; checkI < checkNums.length; checkI++) {
                $("#" + gslx + '_' + checkNums[checkI]).val(1);

                $("#" + gsdw + '_' + checkNums[checkI]).val(bmVal);
                $("#" + gsdw + '_' + checkNums[checkI] + 'span').html('<a href="/hrm/company/HrmDepartmentDsp.jsp?id=' + bmVal + '&amp;f_weaver_belongto_userid=150&amp;f_weaver_belongto_usertype=0" target="_new">' + bmChinaVal + '</a>');
            }
        }
    }
</script>


<script type="text/javascript">
    var tbrId = 'field13794';//部门id(主表)

    var xmjl = 'field13919';//项目经理
    var xm = 'field13798';//姓名

    var ejbm = 'field13924';//二级部门
    var sjbm = 'field13797';//三级部门
    var gh = 'field13799';//工号
    var rylb = 'field13800';//人员类别
    var bmgg = 'field13801';//部门公共

    var xmbh = 'field13802';//项目编号
    var xmmc = 'field13803';//项目名称
    var ywfx = 'field13804';//业务方向
    var gsqzzj = 'field13805';//工时权重总计
    var sm = 'field13806';//说明

    $(function () {
        checkCustomize = function () {
            var flag = false;
            var checkNums = $("#submitdtlid0").val().split(',');
            var allStr = '';
            for (var checkI = 0; checkI < checkNums.length; checkI++) {
                var xmVal = $("#" + xm + '_' + checkNums[checkI]).val();//姓名
                var gsqzzjVal = $("#" + gsqzzj + '_' + checkNums[checkI]).val();//工时
                allStr += xmVal + ',' + gsqzzjVal + '#'

            }
            $.ajax({
                type: "post",
                url: "/workflow/request/daTang/FuZhi.jsp?type=check",
                cache: false,
                async: false,
                data: {"allStr": allStr},
                success: function (data) {
                    var data = data.replace(/\s+/g, "");
                    if ('true' == data) {
                        flag = true;
                    } else {
                        window.top.Dialog.alert(data);
                    }
                }
            });
            return flag;
        };
        //明细表赋值
        var nums = $("#submitdtlid0").val();
        if ('' !== nums) {
            return;
        }
        var tbrVal = $("#" + tbrId).val();
        $.post("/workflow/request/daTang/FuZhi.jsp?type=fuZhi", {
            "tbrId": tbrVal,
        }, function (data) {
            var data = data.replace(/\s+/g, "");
            var myJson = JSON.parse(data);
            //添加明细行
            try {
                for (var i = 0; i < myJson.row; i++) {
                    addRow0(0);
                }
            } catch (e) {
            }
            //赋值
            var nums1 = $("#submitdtlid0").val().split(',');
            for (var j = 0; j < nums1.length; j++) {
                $("#" + ejbm + '_' + nums1[j]).val(myJson.data[j].ejbm);
                $("#" + ejbm + '_' + nums1[j] + 'span').html('<a href="/hrm/company/HrmDepartmentDsp.jsp?id=' + myJson.data[j].ejbm + '&amp;f_weaver_belongto_userid=150&amp;f_weaver_belongto_usertype=0" target="_new">' + myJson.data[j].ejbmChina + '</a>');
                $("#" + sjbm + '_' + nums1[j]).val(myJson.data[j].sjbm);
                $("#" + sjbm + '_' + nums1[j] + 'span').html('<a href="/hrm/company/HrmDepartmentDsp.jsp?id=' + myJson.data[j].sjbm + '&amp;f_weaver_belongto_userid=150&amp;f_weaver_belongto_usertype=0" target="_new">' + myJson.data[j].sjbmChina + '</a>');
                $("#" + gh + '_' + nums1[j]).val(myJson.data[j].gh);

                $("#" + rylb + '_' + nums1[j]).val(myJson.data[j].rylb);
                $("#" + bmgg + '_' + nums1[j]).val(myJson.data[j].bmgg);

                $("#" + xmbh + '_' + nums1[j]).val(myJson.data[j].xmbh);
                $("#" + xmbh + '_' + nums1[j] + 'span').html(myJson.data[j].xmbhChina);

                $("#" + xmmc + '_' + nums1[j]).val(myJson.data[j].xmmc);
                $("#" + ywfx + '_' + nums1[j]).val(myJson.data[j].ywfx);

                $("#" + gsqzzj + '_' + nums1[j]).val(myJson.data[j].gsqzzj);
                $("#" + sm + '_' + nums1[j]).val(myJson.data[j].sm);
                $("#" + xm + '_' + nums1[j]).val(myJson.data[j].xm);
                $("#" + xm + '_' + nums1[j] + 'span').html('<a href="javaScript:openhrm(' + myJson.data[j].xm + ');" onclick="pointerXY(event);">' + myJson.data[j].xmChina + '</a>');
                $("#" + xmjl + '_' + nums1[j]).val(myJson.data[j].xmjl);

                $("#" + xmjl + '_' + nums1[j] + 'span').html('<a href="javaScript:openhrm(' + myJson.data[j].xmjl + ');" onclick="pointerXY(event);">' + myJson.data[j].xmjlChina + '</a>');
            }
        });
    })
</script>


<script type="text/javascript">
    function outExcel(id) {
        $.ajax({
            type: "post",
            url: "/workflow/request/daTang/OutExcel.jsp",
            cache: false,
            async: false,
            data: {"id": id},
            success: function (data) {
                var data = data.replace(/\s+/g, "");
                window.top.Dialog.alert(data);
            }
        });
    }
</script>

<script type="text/javascript">

    var xm = 'field13798'; //姓名
    var gsqzzj = 'field13805'; //工时权重总计

    $(function () {
        checkCustomize = function () {
            var flag = false;
            var checkNums = $("#submitdtlid0").val().split(',');
            var allStr = '';
            for (var checkI = 0; checkI < checkNums.length; checkI++) {
                var xmVal = $("#" + xm + '_' + checkNums[checkI]).val();//姓名
                var gsqzzjVal = $("#" + gsqzzj + '_' + checkNums[checkI]).val();//工时
                allStr += xmVal + ',' + gsqzzjVal + '#'

            }
            $.ajax({
                type: "post",
                url: "/workflow/request/daTang/FuZhi.jsp?type=check",
                cache: false,
                async: false,
                data: {"allStr": allStr},
                success: function (data) {
                    var data = data.replace(/\s+/g, "");
                    if ('true' == data) {
                        flag = true;
                    } else {
                        window.top.Dialog.alert(data);
                    }
                }
            });
            return flag;
        };
    })
</script>

<%-- 明细表监控 --%>
<script src="/workflow/request/testJsp/cw.js"></script>
<script type="text/javascript">
    // 字段1
    var zd1 = 'field6668';
    // 字段2
    var zd2 = 'field6669';
    // 主表字段
    var mainZd = 'fieldXXX';

    jQuery(document).ready(function () {
        checkCustomize = function () {
            var flag = true;
            var mainZdVal = jQuery("#" + mainZd).val();
            if (parseFloat(mainZdVal) == 0) {
                var checkNums = jQuery("#submitdtlid0").val().split(',');
                var row = 1;
                var errInfo = '第';
                for (var checkI = 0; checkI < checkNums.length; checkI++) {
                    var zd1Val = jQuery("#" + zd1 + '_' + checkNums[checkI]).val();
                    var zd2Val = jQuery("#" + zd2 + '_' + checkNums[checkI]).val();
                    if (parseFloat(zd1Val) > parseFloat(zd2Val)) {
                        flag = false;
                        errInfo += ' ' + row + ', ';
                    }
                    row++;
                }
            }
            if (!flag) {
                window.top.Dialog.alert(errInfo + '行数据不规范');
            }
            return flag;
        };
    })
</script>

