<!DOCTYPE html>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea" %>
<%@ taglib uri="/WEB-INF/tld/browser.tld" prefix="brow" %>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page"/>
<%@ include file="/systeminfo/init_wev8.jsp" %>
//入职流程
<script type="text/javascript">
    var yglx = 'field9474';//用工类型
    var yjbm = 'field9475';//所属一级部门
    jQuery(document).ready(function () {
        checkCustomize = function () {
            var flag = false;
            var yglxVal = jQuery("#" + yglx).val();
            var yjbmVal = jQuery("#" + yjbm).val();
            if (parseFloat(yglxVal) !== 0) {
                //只校验正式员工
                return true;
            }

            $.ajax({
                type: "post",
                url: "/workflow/request/huaLian/CheckBack.jsp",
                cache: false,
                async: false,
                data: {"xqrsVal": 1, "yjbmVal": yjbmVal},
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


<script type="text/javascript">
    var xqrs = 'field8188';//需求人数
    var yjbm = 'field9445';//所属一级部门
    jQuery(document).ready(function () {
        checkCustomize = function () {
            var flag = false;
            var xqrsVal = jQuery("#" + xqrs).val();
            var yjbmVal = jQuery("#" + yjbm).val();
            if (parseFloat(xqrsVal) <= 0) {
                window.top.Dialog.alert('需求人数不能小于或等于0。');
                return false;
            }

            $.ajax({
                type: "post",
                url: "/workflow/request/huaLian/CheckBack.jsp",
                cache: false,
                async: false,
                data: {"xqrsVal": xqrsVal, "yjbmVal": yjbmVal},
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

调动流程js

<script type="text/javascript">
    var yjbm = 'field9545'; // 变动后一级部门
    jQuery(document).ready(function () {
        checkCustomize = function () {
            var flag = false;
            var xqrsVal = 1;
            var yjbmVal = jQuery("#" + yjbm).val();

            $.ajax({
                type: "post",
                url: "/workflow/request/huaLian/CheckBack.jsp",
                cache: false,
                async: false,
                data: {"xqrsVal": xqrsVal, "yjbmVal": yjbmVal},
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

<!-- HR04 -->
<script type="text/javascript">
    var xqrs = 'field8183'; // 需求人数
    var fb = 'field8181'; // 所属分部
    jQuery(document).ready(function () {
        checkCustomize = function () {
            var flag = false;
            var xqrsVal = jQuery("#" + xqrs).val();
            var fbVal = jQuery("#" + fb).val();
            if (parseFloat(xqrsVal) <= 0) {
                window.top.Dialog.alert('需求人数不能小于或等于0。');
                return false;
            }
            alert(fbVal)
            // 总部不做控制
            if (parseFloat(fbVal) == 5) {
                return true;
            }
            $.ajax({
                type: "post",
                url: "/workflow/request/huaLian/CheckBack.jsp",
                cache: false,
                async: false,
                data: {"xqrsVal": xqrsVal, "fbVal": fbVal},
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


<!-- 人事管理 - HR-07调动（借调）审批流程 -->
<script type="text/javascript">
    var drfb = 'field9598'; // 调入分部
    jQuery(document).ready(function () {
        checkCustomize = function () {
            var flag = false;
            var xqrsVal = 1; // 需求人数
            var drfbVal = jQuery("#" + drfb).val();
            var lxVal = jQuery("#field7148").val(); // 类型，只有0需要校验
            if (parseFloat(lxVal) == 0) {
                $.ajax({
                    type: "post",
                    url: "/workflow/request/huaLian/CheckBack.jsp",
                    cache: false,
                    async: false,
                    data: {"xqrsVal": xqrsVal, "fbVal": drfbVal},
                    success: function (data) {
                        var data = data.replace(/\s+/g, "");
                        if ('true' == data) {
                            flag = true;
                        } else {
                            window.top.Dialog.alert(data);
                        }
                    }
                });
            } else {
                flag = true;
            }
            return flag;
        };
    })
</script>


