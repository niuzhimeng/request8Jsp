// 询比价流程-服务类
<script type="text/javascript">
    var mxbNum6 = 'submitdtlid5'; // 明细表6
    // ===========明细表6字段
    var zbgys6 = 'field15985'; // 中标供应商

    jQuery(document).ready(function () {
        checkCustomize = function () {
            var params = {};
            // 拼接明细表6
            var mx6Array = [];
            var mx6Val = $("#" + mxbNum6).val().split(",");
            var mx6Length = mx6Val.length;
            for (var i = 0; i < mx6Length; i++) {
                var zbgys6Val = $("#" + zbgys6 + '_' + mx6Val[i]).val();
                mx6Array.push({
                    'zbgys6Val': zbgys6Val.trim()
                });
            }
            params['mx6Array'] = mx6Array;

            var myJson = JSON.stringify(params);
            var flag = false;
            $.ajax({
                type: "post",
                url: "/workflow/request/zhongsha/crm/XunJiaBack.jsp",
                cache: false,
                async: false,
                data: {"myJson": myJson},
                success: function (myData) {
                    myData = myData.replace(/\s+/g, "");
                    var myJson = jQuery.parseJSON(myData);
                    if (true === myJson.state) {
                        flag = true;
                    } else {
                        window.top.Dialog.alert(myJson.msg);
                    }
                }
            });
            return flag;
        };
    });
</script>

// 询比价流程-物资类（暂不上线，待定）
<script type="text/javascript">
    var mxbNum6 = 'submitdtlid5'; // 明细表6
    // ===========明细表6字段
    var zbgys6 = 'field16005'; // 中标供应商
    // ===========主表字段
    var zbgysA = 'field16012'; // 中标供应商A
    var zbgysB = 'field16013'; // 中标供应商B
    var zbgysC = 'field16014'; // 中标供应商C
    var zbgysD = 'field16015'; // 中标供应商D
    var zbgysE = 'field16016'; // 中标供应商E

    jQuery(document).ready(function () {
        checkCustomize = function () {
            var map = {
                "1": zbgysA,
                "2": zbgysB,
                "3": zbgysC,
                "4": zbgysD,
                "5": zbgysE,
            };

            var params = {};
            // 拼接明细表6
            var mx6Array = [];
            var mx6Val = $("#" + mxbNum6).val().split(",");
            var mx6Length = mx6Val.length;
            for (var i = 0; i < mx6Length; i++) {
                var zbgys6Val = $("#" + zbgys6 + '_' + mx6Val[i]).val();
                var gysVal = $("#" + map[zbgys6Val]).val();

                mx6Array.push({
                    'zbgys6Val': gysVal
                });
            }
            params['mx6Array'] = mx6Array;

            var myJson = JSON.stringify(params);
            var flag = false;
            $.ajax({
                type: "post",
                url: "/workflow/request/zhongsha/crm/XunJiaBack.jsp",
                cache: false,
                async: false,
                data: {"myJson": myJson},
                success: function (myData) {
                    myData = myData.replace(/\s+/g, "");
                    var myJson = jQuery.parseJSON(myData);
                    if (true === myJson.state) {
                        flag = true;
                    } else {
                        window.top.Dialog.alert(myJson.msg);
                    }
                }
            });
            return flag;
        };
    });
</script>


// 询比价流程-物资类(金额计算) 第一节点
<script type="text/javascript">
    var dwsl = 'field16006'; // 询比价单位数量
    var pjbj = 'field16293'; // 平均报价

    var zja = 'field15350'; // 总价a
    var zjb = 'field15354'; // 总价b
    var zjc = 'field15358'; // 总价c
    var zjd = 'field15362'; // 总价d
    var zje = 'field15366'; // 总价e

    var zjf = 'field16235'; // 总价f
    var zjg = 'field16236'; // 总价g
    var zjh = 'field16237'; // 总价h
    var zji = 'field16238'; // 总价i
    var zjj = 'field16239'; // 总价j

    var zjsz = [zja, zjb, zjc, zjd, zje,
        zjf, zjg, zjh, zji, zjj];
    jQuery(document).ready(function () {
        $("#" + dwsl).bindPropertyChange(function () {
            myJs();
        });
        for (var i = 0; i < zjsz.length; i++) {
            $("#" + zjsz[i]).bindPropertyChange(function () {
                myJs();
            });
        }
    });

    // 计算平均值
    function myJs() {
        var sl = Number($("#" + dwsl).val()) + 1; // 选择客户的数量
        var allCont = 0; // 供应商价格总和
        var count0 = 0;
        for (var i = 0; i < sl; i++) {
            var curVVal = $("#" + zjsz[i]).val() * 100;
            if (curVVal == 0) {
                count0++;
            }
            allCont += curVVal;
        }
        var pjs = 0; // 平均值
        if (allCont > 0) {
            allCont = allCont / 100;
            sl -= count0;
            pjs = (allCont / sl).toFixed(2);
        }
        $("#" + pjbj).val(pjs);
        $("#" + pjbj + 'span').html(pjs);
    }
</script>

// 询比价流程-物资类(金额计算) 第三节点
<script type="text/javascript">
    var dwsl = 'field16006'; // 询比价单位数量
    var bjje = 'field15477'; // 报价金额
    var gysmc = 'field16528'; // 供应商名称

    var config = {
        '1': 'field15350', // 总价a
        '2': 'field15354', // 总价b
        '3': 'field15358', // 总价c
        '4': 'field15362', // 总价d
        '5': 'field15366', // 总价e

        '6': 'field16235', // 总价f
        '7': 'field16236', // 总价g
        '8': 'field16237', // 总价h
        '9': 'field16238', // 总价i
        '10': 'field16239', // 总价j
    };

    var configName = {
        '1': 'field16012', // 供应商名称a
        '2': 'field16013', // 供应商名称b
        '3': 'field16014', // 供应商名称c
        '4': 'field16015', // 供应商名称d
        '5': 'field16016', // 供应商名称e

        '6': 'field16220', // 供应商名称f
        '7': 'field16222', // 供应商名称g
        '8': 'field16224', // 供应商名称h
        '9': 'field16226', // 供应商名称i
        '10': 'field16228', // 供应商名称j
    };

    // 黄色明细表字段
    var mxbNum6 = 'submitdtlid5'; // 明细表6
    var cxgys = 'field16296'; // 参选供应商

    $(function () {
        appendButton();
    });

    function newButton() {
        // 增加黄色明细表行数
        var dwslVal = Number($("#" + dwsl).val()) + 1;
        // 查询当前明细行
        var currentRows;
        var mxbObj = $("#" + mxbNum6);
        var mxbObjVal = mxbObj.val();
        if (mxbObjVal === '') {
            currentRows = 0;
        } else {
            currentRows = mxbObj.val().split(",").length;
        }

        for (var j = 0; j < dwslVal; j++) {
            addRow5(5);
        }
        var currentMxs = mxbObj.val().split(",");
        var gysmcNum = 1;
        for (var i = 0; i < dwslVal; i++) {
            $("#" + cxgys + '_' + currentMxs[currentRows]).val(gysmcNum);
            $("#" + bjje + '_' + currentMxs[currentRows]).val($("#" + config[gysmcNum.toString()]).val());

            var gysRel = $("#" + configName[gysmcNum.toString()]).val();
            $("#" + gysmc + '_' + currentMxs[currentRows]).val(gysRel);
            // var title = $("#" + configName[gysmcNum.toString()] + 'span').children('a').attr('title');
            // var mya = "<a title=\"" + title + "\" href=\"/formmode/view/AddFormMode.jsp?type=0&amp;modeId=67&amp;formId=-232&amp;billid=" + gysRel + "\" target=\"_blank\">" + title + "</a>";
            $("#" + gysmc + '_' + currentMxs[currentRows] + 'span').html($("#" + configName[gysmcNum.toString()] + 'span').children('a').clone());

            gysmcNum++;
            currentRows++;
        }
    }

    function appendButton() {
        jQuery("#collect").append("<input id=\"collect\" type=\"button\" value=\"报价数据汇总\" onclick=\"newButton();\" class=\"e8_btn_top_first\">");
    }
</script>


// 检维修结算流程, 明细第一行“项目名称”赋值给主表“项目名称”（1节点执行）
<script src="/workflow/request/zhongsha/cw.js"></script>
<script type="text/javascript">
    var mxbNum1 = 'submitdtlid0'; // 明细表1
    var xmmcDetail = 'field16451'; // 项目名称-明细表
    var xmmcMain = 'field6605'; // 项目名称-主表
    jQuery(document).ready(function () {
        _C.run2(mxbNum1, fuZhi);
        _C.run2(xmmcDetail, fuZhi);
    });

    function fuZhi(p) {
        if (p.v.o === undefined) {
            return;
        }
        var split = $("#" + mxbNum1).val().split(',');
        var mx1Val = $("#" + xmmcDetail + "_" + split[0]).val();
        $("#" + xmmcMain).val(mx1Val);
    }
</script>

// 浏览按钮给默认值
<script type="text/javascript">
    var fzzd = 'field16302'; // 被赋值字段
    jQuery(document).ready(function () {
        setTimeout(function () {
            $('#' + fzzd + '_0').val(17);
            $('#' + fzzd + '_0span').html('<a title="" href="/formmode/view/AddFormMode.jsp?type=0&amp;modeId=64&amp;formId=-227&amp;billid=17" target="_blank">公司实景展示-库房</a>');
            $('#' + fzzd + '_1').val(18);
            $('#' + fzzd + '_1span').html('<a title="" href="/formmode/view/AddFormMode.jsp?type=0&amp;modeId=64&amp;formId=-227&amp;billid=18" target="_blank">其他</a>');
        }, 1000);

    });
</script>

<script src="/workflow/request/zhongsha/cw.js"></script>
<script type="text/javascript">
    var mxbNum1 = 'submitdtlid0'; // 明细表1

    var xmmcDetail = 'field16439';   // 项目名称-明细表
    var xmmcMain = 'field16441';    // 项目名称-主表

    var gdhDetail = 'field15621';   // 工单号-明细表
    var gdhMain = 'field16440';    // 工单号主表

    jQuery(document).ready(function () {
        _C.run2(mxbNum1, fuZhi);
        _C.run2(xmmcDetail, fuZhi);
    });

    function fuZhi(p) {
        if (p.v.o === undefined) {
            return;
        }
        var split = $("#" + mxbNum1).val().split(',');
        var mx1Val = $("#" + xmmcDetail + "_" + split[0]).val();
        $("#" + xmmcMain).val(mx1Val);
    }
</script>

// 中沙石化询比价流程（物资） 第一节点 给下拉框赋值
// 带出预选流程供应商名称
<script type="text/javascript">
    // =============== 下拉框赋值
    var dwsl = 'field16530'; // 询比价单位数量
    var xlk = 'field16006'; // 下拉框

    // =============== 明细表隐藏
    var xbjfs = 'field16308'; // 询比价方式

    // =============== 供应商名称赋值
    var yxTableName = 'formtable_main_66_dt2'; // 预选流程表名
    var gysFiled = 'xzgys'; // 预选流程-供应商字段名
    var gysFiledStr = 'gysmc1'; // 预选流程-供应商中文字段名
    var yxlc = 'field15337'; // 预选流程
    var configName = {
        '1': 'field16012', // 供应商名称a
        '2': 'field16013', // 供应商名称b
        '3': 'field16014', // 供应商名称c
        '4': 'field16015', // 供应商名称d
        '5': 'field16016', // 供应商名称e

        '6': 'field16220', // 供应商名称f
        '7': 'field16222', // 供应商名称g
        '8': 'field16224', // 供应商名称h
        '9': 'field16226', // 供应商名称i
        '10': 'field16228', // 供应商名称j
    };
    jQuery(document).ready(function () {
        $("#" + dwsl).bindPropertyChange(function () {
            xlkFuZhi();
        });
        $("#" + xbjfs).bindPropertyChange(function () {
            var xbjfsVal = $("#" + xbjfs).val();
            if (xbjfsVal == 1) {
                $("#yellowRow").hide();
            } else {
                $("#yellowRow").show();
            }
        });

        $("#" + yxlc).bindPropertyChange(function () {
            xlkFuZhi();
            getName();
        });
    });

    function xlkFuZhi() {
        var dwslVal = $("#" + dwsl).val();
        $("#" + xlk).val(dwslVal);
        $("#" + xlk).trigger('change');

    }

    function getName() {
        $.ajax({
            type: "post",
            url: "/workflow/request/zhongsha/crm/YuXuanGetName.jsp",
            cache: false,
            async: true,
            data: {
                "yxlc": $("#" + yxlc).val(),
                'yxTableName': yxTableName,
                "gysFiled": gysFiled,
                "gysFiledStr": gysFiledStr
            },
            dataType: 'json',
            success: function (myData) {
                var gysArray = myData.gysArray;

                var len = gysArray.length;
                for (var i = 0; i < len; i++) {
                    var sz = gysArray[i].split(',');
                    $("#" + configName[i + 1]).val(sz[0]);
                    var mya = "<a title=\"" + sz[1] + "\" href=\"/formmode/view/AddFormMode.jsp?type=0&amp;modeId=67&amp;formId=-232&amp;billid=" + sz[0] + "\" target=\"_blank\">" + sz[1] + "</a>";
                    $("#" + configName[i + 1] + 'span').html(mya);
                }
            }
        });
    }
</script>


// 中沙石化询比价流程（物资） 供应商A节点 明细表【单价字段必填】+ 平均值计算
<script type="text/javascript">
    var dj = 'field15374'; // 单价
    var mxbNum1 = 'submitdtlid0'; // 明细表1

    var dwsl = 'field16006'; // 询比价单位数量
    var pjbj = 'field16293'; // 平均报价

    var zja = 'field15350'; // 总价a
    var zjb = 'field15354'; // 总价b
    var zjc = 'field15358'; // 总价c
    var zjd = 'field15362'; // 总价d
    var zje = 'field15366'; // 总价e

    var zjf = 'field16235'; // 总价f
    var zjg = 'field16236'; // 总价g
    var zjh = 'field16237'; // 总价h
    var zji = 'field16238'; // 总价i
    var zjj = 'field16239'; // 总价j

    var zjsz = [zja, zjb, zjc, zjd, zje,
        zjf, zjg, zjh, zji, zjj];
    jQuery(document).ready(function () {
        checkCustomize = function () {
            var split = $("#" + mxbNum1).val().split(',');
            for (var i = 0; i < split.length; i++) {
                if ($("#" + dj + '_' + split[i]).val() === '') {
                    alert('【单价】字段不能为空。');
                    return false;
                }
            }

            return confirm("提交后无法撤回或修改报价，请确认提交!");
        };

        $("#" + dwsl).bindPropertyChange(function () {
            myJs();
        });
        for (var i = 0; i < zjsz.length; i++) {
            $("#" + zjsz[i]).bindPropertyChange(function () {
                myJs();
            });
        }
    });

    function myJs() {
        var sl = Number($("#" + dwsl).val()) + 1; // 选择客户的数量
        console.log('选择客户数量', sl)
        var allCont = 0; // 供应商价格总和
        var count0 = 0;
        for (var i = 0; i < sl; i++) {
            var curVVal = $("#" + zjsz[i]).val() * 100;
            if (curVVal == 0) {
                count0++;
            }
            allCont += curVVal;
        }
        var pjs = 0; // 平均值
        if (allCont > 0) {
            allCont = allCont / 100;
            sl -= count0;
            pjs = (allCont / sl).toFixed(2);
        }
        $("#" + pjbj).val(pjs);
        $("#" + pjbj + 'span').html(pjs);
    }
</script>

