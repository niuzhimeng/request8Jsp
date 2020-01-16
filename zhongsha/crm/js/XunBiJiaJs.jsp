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
        },1000);

    });
</script>