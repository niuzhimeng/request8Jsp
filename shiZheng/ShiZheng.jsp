<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<jsp:useBean id="RequestManager" class="weaver.workflow.request.RequestManager" scope="page"/>
<jsp:useBean id="flowDocss" class="weaver.workflow.request.RequestDoc" scope="session"/>
<jsp:useBean id="DocComInfo" class="weaver.docs.docs.DocComInfo" scope="page"/>
<jsp:useBean id="Doccoder" class="weaver.docs.docs.DocCoder" scope="page"/>
<%@ include file="/systeminfo/init_wev8.jsp" %>

<script type="text/javascript">

    $(function () {
        $("#xieCheng").append("<input id=\"jiaoYan\" type=\"button\" value=\"校验\" class=\"e8_btn_top_first\" onclick = \"tiaoZahun()\">");
    });

    function tiaoZahun() {
        window.open("/workflow/request/taide/PaiBan.jsp");
    }
</script>




<script type="text/javascript" language="javascript" src="/FCKEditor/FCKEditorExt_wev8.js"></script>
<%--<script type="text/javascript" language="JavaScript" src="/workflow/request/testJsp/test.js"></script>--%>
<html>
<script src="/workflow/request/testJsp/shauter_wev8.js"></script>
<script src="/workflow/request/testJsp/cw.js"></script>
<script type="text/javascript">
    jQuery(document).ready(function () {
        var liuLanId = 'field10870';
        var controled = '10871';
        _C.run2(liuLanId, function (p) {
            if (p.v.o == undefined) {
                return;
            }
            var nowLine = p.r.substring(1);
            var a = jQuery('#' + liuLanId + p.r).val();
            if (a == 'C006' || a == 'V000') {
                changeFieldShowattr(controled, "2", "1", nowLine);//1、编辑 2、必填 3、只读; 0主表 1明细表
            } else {
                changeFieldShowattr(controled, "1", "1", nowLine);//编辑
            }
        });
    })
</script>

<script src="/workflow/request/testJsp/cw.js"></script>
<script type="text/javascript">
    var test1 = 'field6552';

    $(function () {
        _C.run2(test1, change);
    });

    function change() {
        var a = $("#" + test1).val();
        if (a === '0') {
            $("#htzw").attr('class', "edesign_hide");
        } else {
            $("#htzw").attr('class', "");
        }
    }
</script>


<script src="/workflow/request/testJsp/shauter_wev8.js"></script>
<script type="text/javascript">
    $(function () {
        var xwfs = 'field10563';//行文方式
        var zsdw = '10555';//主送单位
        var zsbm = '10556';//主送部门

        _C.run2(xwfs, change);

        function change(p) {
            var xwfsVal = $("#" + xwfs).val();
            if (xwfsVal !== '1' && xwfsVal !== '0') {
                $("#zsdw").show();
                $("#zsbm").show();
                changeFieldShowattr(zsdw, "2", "0", -1);
                changeFieldShowattr(zsbm, "2", "0", -1);
            } else if (xwfsVal === '0') {
                //上行文
                $("#zsdw").show();
                changeFieldShowattr(zsdw, "2", "0", -1);
                $("#zsbm").hide();
                changeFieldShowattr(zsbm, "1", "0", -1);
            } else if (xwfsVal === '1') {
                //下行文
                $("#zsdw").hide();
                changeFieldShowattr(zsdw, "1", "0", -1);
                $("#zsbm").show();
                changeFieldShowattr(zsbm, "2", "0", -1);
            }
        }

    })
</script>


------------------------------------------

<script type="text/javascript" src="/js/cw.js"></script>
<script src="/workflow/request/testJsp/shauter_wev8.js"></script>
<script type="text/javascript">
    var xwfs = 'field11538';//行文方式
    var zsdw = '11183';//主送单位
    var zsbm = '11184';//主送部门

    var wjlx = "#field11519";//法文类型
    var qz = "#field11540";//前缀
    var bt = "#field11541";//标题
    var fwbt = "#requestname";//发文标题
    jQuery(document).ready(function () {
        cus_ConvertSelectToRadio("field11528,field11527,field11535,field11527,field7307");
        //插入图片，需要在页面中添加对应ID，如icon1
        jQuery("#icon1").html('<img id="img1" src="/page/resource/userfile/image/icon/001.png" width="35" height="35"  /> ');
        jQuery("#icon2").html('<img id="img2" src="/page/resource/userfile/image/icon/002.png" width="35" height="35" /> ');
        jQuery("#icon3").html('<img id="img3" src="/page/resource/userfile/image/icon/003.png" width="35" height="35" /> ');
        jQuery("#icon4").html('<img id="img4" src="/page/resource/userfile/image/icon/007.png" width="35" height="35" /> ');
        jQuery("#icon5").html('<img id="img5" src="/page/resource/userfile/image/icon/005.png" width="35" height="35" /> ');
        jQuery("#icon6").html('<img id="img6" src="/page/resource/userfile/image/icon/006.png" width="35" height="35" /> ');
        jQuery("#icon7").html('<img id="img7" src="/page/resource/userfile/image/icon/007.png" width="35" height="35" /> ');
        //alert("0");

        jQuery(qz).hide();

        _C.run2('field11519', fz);
        _C.run2('field11541', fz);
    });

    function fz(p) {
        //动作
        var a = jQuery(wjlx).val();
        if (a == 3) {
            jQuery(qz).val("北京市市政六建设工程有限公司");
            jQuery(qz + "span").html("北京市市政六建设工程有限公司");
        } else if (a == 1) {
            jQuery(qz).val("中共北京市市政六建设工程有限公司委员会");
            jQuery(qz + "span").html("中共北京市市政六建设工程有限公司委员会");
        } else if (a == 2) {
            jQuery(qz).val("中共北京市市政六建设工程有限公司纪律检查委员会");
            jQuery(qz + "span").html("中共北京市市政六建设工程有限公司纪律检查委员会");
        } else {
            jQuery(qz).val("");
            jQuery(qz + "span").html("");
        }

        var qzValue = jQuery(qz).val();
        var btValue = jQuery(bt).val();

        if (a == 1 || a == 2 || a == 3) {
            jQuery(fwbt).val(qzValue + btValue);
            jQuery(fwbt + "span").html(qzValue + btValue);
        } else {
            jQuery(fwbt).val(btValue);
            jQuery(fwbt + "span").html(btValue);
        }
    }

    function isContains(str, substr) {
        return str.indexOf(substr) == 0;
    }

    checkCustomize = function () {
        var wjlxValue = jQuery(wjlx).val();//文件类型值
        var fwbtValue = jQuery(fwbt).val();//发文标题值

        var str1 = isContains(fwbtValue, "中共北京市市政六建设工程有限公司委员会");
        var str2 = isContains(fwbtValue, "中共北京市市政六建设工程有限公司纪律检查委员会");
        var str3 = isContains(fwbtValue, "北京市市政六建设工程有限公司");

        if ((wjlxValue == 1 && str1) || (wjlxValue == 2 && str2) || (wjlxValue == 3 && str3) || wjlxValue == 0) {
            return true;
        } else {
            alert("标题样式不正确");
            return false;
        }
    }
</script>
<style>
    input {
        border: 0px !important;
    }

    select {
        width: 90%;
        border: 0px !important;
    }

    textarea {
        width: 98% !important;
        border: 1px solid #4a86e8;
    }

    .textarea {
        min-height: 72px !important;
        height: 100% !important;
        width: 98% !important;
        border: 1px solid #4a86e8 !important;
    }

    .e8_innerShow {
        border: 0px !important;
    }

    .e8_outScroll {
        border: 0px !important;
    }
</style>








<script src="/workflow/request/testJsp/shauter_wev8.js"></script>
<script type="text/javascript" src="/js/cw.js"></script>
<script type="text/javascript">
    var xwfs = 'field10752';//行文方式
    var zsdw = '10744';//主送单位
    var zsbm = '10745';//主送部门

    var wjlx = "#field10731";//法文类型
    var qz ="#field10754";//前缀
    var bt ="#field10755";//标题
    var fwbt = "#requestname";//发文标题

    jQuery(document).ready(function () {
        cus_ConvertSelectToRadio("field10740,field10739,field10749,field10739,field7307");
        //插入图片，需要在页面中添加对应ID，如icon1
        jQuery("#icon1").html('<img id="img1" src="/page/resource/userfile/image/icon/001.png" width="35" height="35"  /> ');
        jQuery("#icon2").html('<img id="img2" src="/page/resource/userfile/image/icon/002.png" width="35" height="35" /> ');
        jQuery("#icon3").html('<img id="img3" src="/page/resource/userfile/image/icon/003.png" width="35" height="35" /> ');
        jQuery("#icon4").html('<img id="img4" src="/page/resource/userfile/image/icon/007.png" width="35" height="35" /> ');
        jQuery("#icon5").html('<img id="img5" src="/page/resource/userfile/image/icon/005.png" width="35" height="35" /> ');
        jQuery("#icon6").html('<img id="img6" src="/page/resource/userfile/image/icon/006.png" width="35" height="35" /> ');
        jQuery("#icon7").html('<img id="img7" src="/page/resource/userfile/image/icon/007.png" width="35" height="35" /> ');
        //alert("0");

        jQuery(qz).hide();

        _C.run2('field10731',fz);
        _C.run2('field10755',fz);
        _C.run2(xwfs, change);
    });

    function change(p) {
        var xwfsVal = jQuery("#" + xwfs).val();
        if (xwfsVal !== '1' && xwfsVal !== '0') {
            jQuery("#zsdw").show();
            jQuery("#zsbm").show();
            changeFieldShowattr(zsdw, "2", "0", -1);
            changeFieldShowattr(zsbm, "2", "0", -1);
        } else if (xwfsVal === '0') {
            //上行文
            jQuery("#zsdw").show();
            changeFieldShowattr(zsdw, "2", "0", -1);
            jQuery("#zsbm").hide();
            changeFieldShowattr(zsbm, "1", "0", -1);
        } else if (xwfsVal === '1') {
            //下行文
            jQuery("#zsdw").hide();
            changeFieldShowattr(zsdw, "1", "0", -1);
            jQuery("#zsbm").show();
            changeFieldShowattr(zsbm, "2", "0", -1);
        }
    }

    function fz(p){
        //动作
        var a = jQuery(wjlx).val();
        if(a==3){
            jQuery(qz).val("北京市政建设集团有限责任公司机电工程处");
            jQuery(qz+"span").html("北京市政建设集团有限责任公司机电工程处");
        }else if(a==1){
            jQuery(qz).val("中共北京市政建设集团有限责任公司机电工程处支部委员会");
            jQuery(qz+"span").html("中共北京市政建设集团有限责任公司机电工程处支部委员会");
        }else if(a==2){
            jQuery(qz).val("中共北北京市政建设集团有限责任公司机电工程处纪律检查委员会");
            jQuery(qz+"span").html("中共北京市政建设集团有限责任公司机电工程处纪律检查委员会");
        }else{
            jQuery(qz).val("");
            jQuery(qz+"span").html("");
        }

        var qzValue = jQuery(qz).val();
        var btValue = jQuery(bt).val();

        if(a==1||a==2||a==3){
            jQuery(fwbt).val(qzValue+btValue);
            jQuery(fwbt+"span").html(qzValue+btValue);
        }else{
            jQuery(fwbt).val(btValue);
            jQuery(fwbt+"span").html(btValue);
        }
    }

    function isContains(str, substr) {
        return str.indexOf(substr) == 0;
    }

    checkCustomize = function (){
        var  wjlxValue = jQuery(wjlx).val();//文件类型值
        var  fwbtValue = jQuery(fwbt).val();//发文标题值

        var  str1 = isContains(fwbtValue,"中共北京市政建设集团有限责任公司机电工程处支部委员会");
        var  str2 = isContains(fwbtValue,"中共北京市政建设集团有限责任公司机电工程处纪律检查委员会");
        var  str3 = isContains(fwbtValue,"北京市政建设集团有限责任公司机电工程处");

        if((wjlxValue==1 && str1) || (wjlxValue==2 && str2) || (wjlxValue==3 && str3) || wjlxValue==0){
            return true;
        }else{
            alert("标题样式不正确");
            return false;
        }
    }
</script>

<style>
    input{ border: 0px !important; }
    select{ width:90%;border: 0px !important; }
    textarea{ width: 98% !important;border:1px solid #4a86e8; }
    .textarea{min-height:72px !important;height:100% !important; width: 98% !important;border:1px solid #4a86e8 !important; }
    .e8_innerShow{ border: 0px !important; }
    .e8_outScroll{ border: 0px !important; }
</style>













