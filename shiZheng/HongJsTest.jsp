<!-- script代码，如果需要引用js文件，请使用与HTML中相同的方式。 -->
<script type="text/javascript" src="/js/cw.js"></script>
<script type="text/javascript">
    var tzlx = "#field12028";//通知类型
    var qz = "#field12029";//前缀
    var bt = "#field12030";//标题
    var fwbt = "#requestname";//发文标题

    jQuery(document).ready(function () {
        cus_ConvertSelectToRadio("field7325,field12028");
        //插入图片，需要在页面中添加对应ID，如icon1
        jQuery("#icon1").html('<img id="img1" src="/page/resource/userfile/image/icon/001.png" width="35" height="35"  /> ');
        jQuery("#icon2").html('<img id="img2" src="/page/resource/userfile/image/icon/002.png" width="35" height="35" /> ');
        jQuery("#icon3").html('<img id="img3" src="/page/resource/userfile/image/icon/003.png" width="35" height="35" /> ');
        jQuery("#icon4").html('<img id="img4" src="/page/resource/userfile/image/icon/007.png" width="35" height="35" /> ');
        jQuery("#icon5").html('<img id="img5" src="/page/resource/userfile/image/icon/005.png" width="35" height="35" /> ');
        jQuery("#icon6").html('<img id="img6" src="/page/resource/userfile/image/icon/006.png" width="35" height="35" /> ');
        jQuery("#icon7").html('<img id="img7" src="/page/resource/userfile/image/icon/007.png" width="35" height="35" /> ');

        jQuery(qz).hide();

        _C.run2('field12028', fz);
        _C.run2('field12030', fz);

    });

    function fz(p) {
        //动作
        var a = jQuery(tzlx).val();
        if (a == 0) {
            jQuery(qz).val("北京市政建设集团有限责任公司");
            jQuery(qz + "span").html("北京市政建设集团有限责任公司");
        } else if (a == 1) {
            jQuery(qz).val("中共北京市政建设集团有限责任公司委员会");
            jQuery(qz + "span").html("中共北京市政建设集团有限责任公司委员会");
        } else {
            jQuery(qz).val("");
            jQuery(qz + "span").html("");
        }

        var qzValue = jQuery(qz).val();
        var btValue = jQuery(bt).val();

        if (a == 0 || a == 1) {
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
        var wjlxValue = jQuery(tzlx).val();//文件类型值
        var fwbtValue = jQuery(fwbt).val();//发文标题值

        var str1 = isContains(fwbtValue, "中共北京市政建设集团有限责任公司委员会");
        var str0 = isContains(fwbtValue, "北京市政建设集团有限责任公司");

        if ((wjlxValue == 1 && str1) || (wjlxValue == 0 && str0)) {

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


