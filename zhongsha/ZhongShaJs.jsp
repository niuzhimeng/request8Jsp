<script type="text/javascript">
    // 取值数组 金额, 合同类型
    var vars = ["field14136", "field14212"];
    // ============ 赋值字段 ============
    // 审批级别
    var spjb = 'field14213';
    // 授权金额明细
    var sqjemx = 'field14160';
    // 关联交易
    var gljy = 'field14161';

    jQuery(document).ready(function () {
        $("#" + spjb).attr("disabled", true);
        $("#" + gljy).attr("disabled", true);
        $("#" + sqjemx).attr('readonly', 'readonly');

        jQuery('#field14136').blur(carry);
        jQuery('#field14212').click(carry);

        checkCustomize = function () {
            $("#" + spjb).attr("disabled", false);
            $("#" + gljy).attr("disabled", false);
            return true;
        };

        jsAOP(window, {
            'doSave_nNew': {
                before: function () {
                    return bianJi();
                }
            }
        });
    });

    function carry() {
        var flag = true;
        for (var i = 0; i < vars.length; i++) {
            var myValue = jQuery('#' + vars[i]).val();
            if (myValue == '' || myValue == null || myValue == undefined) {
                flag = false;
            }
        }

        if (flag) {
            // 金额, 合同类型, 拼成一串（逗号分隔）
            var message = '';
            for (var j = 0; j < vars.length; j++) {
                message += jQuery('#' + vars[j]).val() + ',';
            }

            $.post("/workflow/request/zhongsha/ZhongShaBack.jsp", {
                "message": message
            }, function (data) {
                var data = data.replace(/\s+/g, "");
                var datas = data.split(',');

                jQuery('#' + sqjemx).val(datas[0]);
                jQuery('#' + spjb).val(datas[1]);
                jQuery('#' + gljy).val(datas[2]);

            });
        }
    }

    function jsAOP(obj, handlers) {
        if (typeof obj == 'function') {
            obj = obj.prototype;
        }
        for (var methodName in handlers) {
            var _handlers = handlers[methodName];
            for (var handler in _handlers) {
                if ((handler == 'before' || handler == 'after') && typeof _handlers[handler] == 'function') {
                    eval(handler)(obj, methodName, _handlers[handler]);
                }
            }
        }

        //方法执行前
        function before(obj, method, f) {
            var original = obj[method];
            obj[method] = function () {
                var isSubmit = f.apply(this, arguments);
                if (!isSubmit) return false;
                return original.apply(this, arguments);
            }
        }

        //方法执行后
        function after(obj, method, f) {
            var original = obj[method];
            obj[method] = function () {
                original.apply(this, arguments);
                return f.apply(this, arguments);
            }
        }
    }

    function bianJi() {
        $("#" + spjb).attr("disabled", false);
        $("#" + gljy).attr("disabled", false);
        return true;
    }
</script>


// DBN差旅及用车流程

<script type="text/javascript">
    // 提交前验证是否大于4小时 ||  大于24小时
    // 去向
    var yc = "field14320";
    //用车 日期
    var startdate = "field14316";
    //用车 时间
    var starttime = "field14336";

    var yc_value = "";
    var startdate_value = "";
    var starttime_value = "";
    //是否允许提交
    var flag = "";
    //用车时   日期 + 时间
    var startdatetime = "";

    //页面加载事件
    $(function () {
        checkCustomize = function () {
            //初始化flag
            flag = true;
            startdate_value = $("#" + startdate).val();
            starttime_value = $("#" + starttime).val();
            //用车时间
            startdatetime = startdate_value + " " + starttime_value;
            //用车   1：市区   2：外皋
            yc_value = $("#" + yc).val();
            if (yc_value == 1) {
                //alert(startdatetime + "====0====" + formatDateTime(getnowdatetime2()));
                if (startdatetime < formatDateTime(getnowdatetime2())) {
                    top.Dialog.alert("市区用车需提前4小时申请");
                    flag = false;
                }
            } else if (yc_value == 2) {
                //alert(startdatetime+"====2===="+formatDateTime(getnowdatetime24()));
                if (startdatetime < formatDateTime(getnowdatetime24())) {
                    top.Dialog.alert("外埠用车需提前24小时申请");
                    flag = false;
                }
            }
            return flag;
        }
    });

    //获取系统当前时间 并加4小时
    function getnowdatetime2() {
        //1. js获取当前时间
        var date = new Date();
        //2. 获取当前分钟
        var min = date.getMinutes();
        //3. 设置当前时间+5分钟：把当前分钟数+5后的值重新设置为date对象的分钟数
        date.setMinutes(min + 4 * 60);
        //4. 测试
        //return date.toLocaleString();
        // alert('当前时间 加4小时： ' + formatDateTime(date))
        return date;
    }

    //获取系统当前时间 并加24小时
    function getnowdatetime24() {
        //1. js获取当前时间
        var date = new Date();
        //2. 获取当前分钟
        var min = date.getMinutes();
        //3. 设置当前时间+5分钟：把当前分钟数+5后的值重新设置为date对象的分钟数
        date.setMinutes(min + 24 * 60);
        //4. 测试
        //return date.toLocaleString();
        return date;
    }

    //将date转为 yyyy-mm-dd hh-mm 格式
    function formatDateTime(date) {
        var y = date.getFullYear();
        var m = date.getMonth() + 1;
        m = m < 10 ? ('0' + m) : m;
        var d = date.getDate();
        d = d < 10 ? ('0' + d) : d;
        var h = date.getHours();
        h = h < 10 ? ('0' + h) : h;
        var minute = date.getMinutes();
        minute = minute < 10 ? ('0' + minute) : minute;
        return y + '-' + m + '-' + d + ' ' + h + ':' + minute;
    }


</script>

2019-07-09 js控制标签页

<script type="text/javascript">
    // 下拉框
    var xlk = 'field14363';
    // 团队建设费
    var tdjsf = 'tab_2';
    // 业务招待费
    var ywzdf = 'tab_7';
    // 申请缘由
    var sqyy = 'tab_6';

    var myValue;
    jQuery(function () {
        jQuery("#" + tdjsf).hide();
        jQuery("#" + ywzdf).hide();
        myValue = $("#" + xlk).val();
        $("#" + xlk).bindPropertyChange(function () {
            myValue = $("#" + xlk).val();
            bind(myValue);
        });
        setTimeout("bind(myValue)", 500)

    });

    function bind(value) {
        // 业务招待费
        if (value == 7) {
            jQuery("#" + sqyy).hide();
            jQuery("#" + tdjsf).hide();
            jQuery("#" + ywzdf).show();
            jQuery("#" + ywzdf).click();
        } else if (value == 14) {
            // 团体建设费
            jQuery("#" + sqyy).hide();
            jQuery("#" + ywzdf).hide();
            jQuery("#" + tdjsf).show();
            jQuery("#" + tdjsf).click();

        } else {
            jQuery("#" + tdjsf).hide();
            jQuery("#" + ywzdf).hide();
            jQuery("#" + sqyy).show();
            jQuery("#" + sqyy).click();
        }
    }
</script>

// DBN合同变更流程 新增审批级别判定

<script type="text/javascript">
    // 取值数组 金额, 合同类型
    var vars = ["field13946", "field14455"];
    // ============ 赋值字段 ============
    // 审批级别
    var spjb = 'field14454';
    // 授权金额明细
    var sqjemx = 'field13924';
    // 关联交易
    var gljy = 'field13954';

    // 原合同号
    var yhth = 'field13935';
    // 新同号
    var xhth = 'field13936';

    jQuery(document).ready(function () {
        $("#" + spjb).attr("disabled", true);
        $("#" + gljy).attr("disabled", true);
        $("#" + sqjemx).attr('readonly', 'readonly');

        jQuery('#field13946').blur(carry);
        jQuery('#field14455').click(carry);

        // 合同号处理
        $("#" + yhth).bindPropertyChange(function () {
            var bgq = $("#" + yhth).val();
            var bgh = bgq.substr(0, bgq.length - 1) + "" + (parseInt((bgq.substr(bgq.length - 1, 1))) + 1);
            $("#" + xhth).val(bgh);
            $("#" + xhth + "span").html(bgh);
        });

        checkCustomize = function () {
            $("#" + spjb).attr("disabled", false);
            $("#" + gljy).attr("disabled", false);
            return true;
        };

        jsAOP(window, {
            'doSave_nNew': {
                before: function () {
                    return bianJi();
                }
            }
        });
    });

    function carry() {
        var flag = true;
        for (var i = 0; i < vars.length; i++) {
            var myValue = jQuery('#' + vars[i]).val();
            if (myValue == '' || myValue == null || myValue == undefined) {
                flag = false;
            }
        }

        if (flag) {
            // 金额, 合同类型, 拼成一串（逗号分隔）
            var message = '';
            for (var j = 0; j < vars.length; j++) {
                message += jQuery('#' + vars[j]).val() + ',';
            }

            $.post("/workflow/request/zhongsha/ZhongShaBack.jsp", {
                "message": message
            }, function (data) {
                var data = data.replace(/\s+/g, "");
                var datas = data.split(',');

                jQuery('#' + sqjemx).val(datas[0]);
                jQuery('#' + spjb).val(datas[1]);
                jQuery('#' + gljy).val(datas[2]);

            });
        }
    }

    function jsAOP(obj, handlers) {
        if (typeof obj == 'function') {
            obj = obj.prototype;
        }
        for (var methodName in handlers) {
            var _handlers = handlers[methodName];
            for (var handler in _handlers) {
                if ((handler == 'before' || handler == 'after') && typeof _handlers[handler] == 'function') {
                    eval(handler)(obj, methodName, _handlers[handler]);
                }
            }
        }

        //方法执行前
        function before(obj, method, f) {
            var original = obj[method];
            obj[method] = function () {
                var isSubmit = f.apply(this, arguments);
                if (!isSubmit) return false;
                return original.apply(this, arguments);
            }
        }

        //方法执行后
        function after(obj, method, f) {
            var original = obj[method];
            obj[method] = function () {
                original.apply(this, arguments);
                return f.apply(this, arguments);
            }
        }
    }

    function bianJi() {
        $("#" + spjb).attr("disabled", false);
        $("#" + gljy).attr("disabled", false);
        return true;
    }
</script>

子流程 将主流程pdf以附件形式带过来

<script type="text/javascript">
    // 主流程表名
    var mainTableName = 'formtable_main_47';
    // 子流程表名
    var sonTableName = 'formtable_main_27';
    // 主流程附件字段名
    var mainFj = 'fj';
    // 子流程附件字段名
    var sonFj = 'xgfj';

    $(document).ready(function () {
        var requestId = jQuery("input[name='requestid']").val();

        jQuery.ajax({
            cache: false,
            async: false,
            data: {
                "requestId": requestId,
                "mainTableName": mainTableName,
                "sonTableName": sonTableName,
                "mainFj": mainFj,
                "sonFj": sonFj
            },
            url: "/workflow/request/zhongsha/UpdateSonFlowFjBack.jsp",
            success: function (data) {
                var result = eval(data);
                result = $.trim(result);
                if (result != 1) {
                    window.onload = function () {
                        if (location.search.indexOf("?") == -1) {
                            location.href += "?myurl";
                        } else if (location.search.indexOf("myurl") == -1) {
                            location.href += "&myurl";
                        }
                    }
                }
            },
            error: function () {
                top.Dialog.alert("请联系管理员！");
            }
        });

    });
</script>

<!-- script代码，如果需要引用js文件，请使用与HTML中相同的方式。 -->
<script type="text/javascript">
    //页面加载完成事件
    jQuery(document).ready(function () {
        var selectObj = jQuery("#field6225");
        var controlDetailFun = function (vthis) {
            if (jQuery(vthis).val() == "1") {
                cus_ShowAreaByName("_detailarea");    //封装的根据name属性显示区域方法
            } else {
                cus_HideAreaByName("_detailarea");    //封装的根据name属性显示区域方法
            }
        }
        selectObj.bindPropertyChange(controlDetailFun);
        controlDetailFun(selectObj[0]);
    });
</script>

<!-- script代码，如果需要引用js文件，请使用与HTML中相同的方式。 -->
<script type="text/javascript">
    //单元格命名为_detailarea，默认隐藏；选择框id为fieldid
    jQuery(document).ready(function () {
        var selectObj = jQuery("#fieldid");
        var controlDetailFun = function (vthis) {
            if (jQuery(vthis).val() == "1") {
                cus_ShowAreaByName("_detailarea");    //1时显示，0时隐藏
            } else {
                cus_HideAreaByName("_detailarea");
            }
        }
        selectObj.bindPropertyChange(controlDetailFun);
        controlDetailFun(selectObj[0]);
    });
</script>

// DBN合同变更流程
<script type="text/javascript">
    // 取值数组 金额, 合同类型
    var vars = ["field13949", "field14455"];
    // ============ 赋值字段 ============
    // 审批级别
    var spjb = 'field14454';
    // 授权金额明细
    var sqjemx = 'field13924';
    // 关联交易
    var gljy = 'field13954';

    // 原合同号
    var yhth = 'field13935';
    // 新同号
    var xhth = 'field13936';

    //审批级别-变更前
    var spjb_bgq = "field14453";
    //审批级别-变更后
    var spjb_bgh = "field14454";
    // 审批判定
    var sppd = 'field14613';
    jQuery(document).ready(function () {
        $("#" + spjb).attr("disabled", true);
        $("#" + gljy).attr("disabled", true);
        $("#" + sqjemx).attr('readonly', 'readonly');

        jQuery('#field13949').blur(carry);
        jQuery('#field14455').click(carry);
        $("#" + spjb_bgq).bindPropertyChange(function () {
            setspjb_value();
        });
        $("#" + spjb_bgh).bindPropertyChange(function () {
            setspjb_value();
        });
        // 合同号处理
        $("#" + yhth).bindPropertyChange(function () {
            var bgq = $("#" + yhth).val();
            var bgh = bgq.substr(0, bgq.length - 1) + "" + (parseInt((bgq.substr(bgq.length - 1, 1))) + 1);
            $("#" + xhth).val(bgh);
            $("#" + xhth + "span").html(bgh);
        });

        checkCustomize = function () {
            $("#" + spjb).attr("disabled", false);
            $("#" + gljy).attr("disabled", false);
            return true;
        };

        jsAOP(window, {
            'doSave_nNew': {
                before: function () {
                    return bianJi();
                }
            }
        });
    });

    function carry() {
        var flag = true;
        for (var i = 0; i < vars.length; i++) {
            var myValue = jQuery('#' + vars[i]).val();
            if (myValue == '' || myValue == null || myValue == undefined) {
                flag = false;
            }
        }

        if (flag) {
            // 金额, 合同类型, 拼成一串（逗号分隔）
            var message = '';
            for (var j = 0; j < vars.length; j++) {
                message += jQuery('#' + vars[j]).val() + ',';
            }

            $.post("/workflow/request/zhongsha/ZhongShaBack.jsp", {
                "message": message
            }, function (data) {
                var data = data.replace(/\s+/g, "");
                var datas = data.split(',');

                jQuery('#' + sqjemx).val(datas[0]);
                jQuery('#' + spjb).val(datas[1]);
                jQuery('#' + gljy).val(datas[2]);

            });
        }
    }

    function setspjb_value() {
        // 变更前 审批级别
        var spjb_bgq_value = $("#" + spjb_bgq).val();
        // 变更后 审批级别
        var spjb_bgh_value = $("#" + spjb_bgh).val();
        if (spjb_bgq_value >= spjb_bgh_value) {
            $("#" + sppd).val(spjb_bgq_value);
        } else {
            $("#" + sppd).val(spjb_bgh_value);
        }
    }

    function jsAOP(obj, handlers) {
        if (typeof obj == 'function') {
            obj = obj.prototype;
        }
        for (var methodName in handlers) {
            var _handlers = handlers[methodName];
            for (var handler in _handlers) {
                if ((handler == 'before' || handler == 'after') && typeof _handlers[handler] == 'function') {
                    eval(handler)(obj, methodName, _handlers[handler]);
                }
            }
        }

        //方法执行前
        function before(obj, method, f) {
            var original = obj[method];
            obj[method] = function () {
                var isSubmit = f.apply(this, arguments);
                if (!isSubmit) return false;
                return original.apply(this, arguments);
            }
        }

        //方法执行后
        function after(obj, method, f) {
            var original = obj[method];
            obj[method] = function () {
                original.apply(this, arguments);
                return f.apply(this, arguments);
            }
        }
    }

    function bianJi() {
        $("#" + spjb).attr("disabled", false);
        $("#" + gljy).attr("disabled", false);
        return true;
    }

</script>






