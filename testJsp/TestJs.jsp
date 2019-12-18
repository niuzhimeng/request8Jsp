<script src="/workflow/request/testJsp/shauter_wev8.js"></script>
<script type="text/javascript">
    let xlk = '7029';
    $(function () {
        changeFieldShowattr(xlk, "3", "0");//1、编辑 2、必填 3、只读; 0主表 1明细表
    })
</script>

<script type="text/javascript">
    var zbbs = "#field7514";//主办部室
    var cbbs = "#field7515";//承办部室
    var jtld = "#field7516";//集团领导
    var gdw = "#field6577";//各单位
    var gd = "#field7529";//归档

    var zbbsV = "#field6517";//主办部室值
    var cbbsV = "#field6518";//承办部室值
    var jtldV = "#field6526";//集团领导值
    var gdwV = "#field6527";//各单位值

    jQuery(zbbs).click(function () {
        if (jQuery(zbbs).is(":checked") == true && jQuery("#field6517span").text() != "") {
            jQuery(zbbsV + "span").html("");
            jQuery("#field6517spanimg").html("<img align=\"bsmiddle\" src=\"/images/BacoError_wev9.png\">");
        } else if (jQuery(zbbs).is(":checked") == true) {
            //设置必填
            jQuery("field6517spanimg").html("<img align=\"bsmiddle\" src=\"/images/BacoError_wev9.png\">");
        } else {

            jQuery(zbbsV).val("");
            jQuery(zbbsV + "span").html("");
            jQuery("#field6517spanimg").html("");
        }

    });

    jQuery(cbbs).click(function () {
        if (jQuery(cbbs).is(":checked") == true && jQuery("#field6518span").text() != "") {
            jQuery(cbbsV + "span").html("");
            jQuery("field6518spanimg").html("<img align=\"bsmiddle\" src=\"/images/BacoError_wev9.png\">");
        } else if (jQuery(cbbs).is(":checked") == true) {
            //设置必填
            jQuery("#field6518spanimg").html("<img align=\"bsmiddle\" src=\"/images/BacoError_wev9.png\">");
        } else {

            jQuery(cbbsV).val("");
            jQuery(cbbsV + "span").html("");
            jQuery("#field6518spanimg").html("");
        }

    });

    jQuery(jtld).click(function () {
        if (jQuery(jtld).is(":checked") == true && jQuery("#field6526span").text() != "") {
            jQuery(jtldV + "span").html("");
            jQuery("#field6526spanimg").html("<img align=\"bsmiddle\" src=\"/images/BacoError_wev9.png\">");
        } else if (jQuery(jtld).is(":checked") == true) {
            jQuery("#field6526spanimg").html("<img align=\"bsmiddle\" src=\"/images/BacoError_wev9.png\">");
        } else {
            jQuery(jtldV).val("");
            jQuery(jtldV + "span").html("");
            jQuery("#field6526spanimg").html("");
        }

    });

    jQuery(gdw).click(function () {
        if (jQuery(gdw).is(":checked") == true && jQuery("#field6527span").text() != "") {
            jQuery(gdwV + "span").html("");
            jQuery("#field6527spanimg").html("<img align=\"bsmiddle\" src=\"/images/BacoError_wev9.png\">");
        } else if (jQuery(gdw).is(":checked") == true) {
            jQuery("#field6527spanimg").html("<img align=\"bsmiddle\" src=\"/images/BacoError_wev9.png\">");
        } else {
            jQuery(gdwV).val("");
            jQuery(gdwV + "span").html("");
            jQuery("#field6527spanimg").html("");
        }
    });

    checkCustomize = function () {
        var value1 = jQuery(zbbsV).val();
        var value2 = jQuery(cbbsV).val();
        var value3 = jQuery(jtldV).val();
        var value4 = jQuery(gdwV).val();

        if ((jQuery(zbbs).is(":checked") == true && value1 != "") || (jQuery(cbbs).is(":checked") == true && value2 != "") || (jQuery(jtld).is(":checked") == true && value3 != "") || (jQuery(gdw).is(":checked") == true && value4 != "")) {
            return true;
        } else {
            alert("流转信息填写不完善");
            return false;
        }
    }
</script>