/**
 *   ①申请人为报销人：报销总金额（bxzje1）与报销明细（主表）中预算值（ys1）进行校验，如报销总金额大于预算值，则不能完成提交。
 *    ②申请人不为报销人：报销总金额（bxzje2）与报销明细（明细表）中预算值（ys）进行校验，如表中同一成本中心的报销金额之和大于该成本中心预算值，则不能完成提交。
 *    ③若表中预算值（ys和ys1）为空（null或0），则不进行提交校验
 *    ④申请人不为报销人：开支明细金额合计值（jebhs1））应与报销明细金额合计值（bxzje2）一致，否则不能完成提交。
 */
// 报销人字段--下拉框
var bxr_id = "";
// 预算—-单人报销
var ys_dr_id = "";
// 报销总金额-单人报销
var bxzje_dr_id = "";
// 费用科目-单人报销
var fykm_dr_id = "";
// 成本中心-单人报销
var cczx_dr_id = "";
// 报销总金额-多人报销
var bxzje_nodr_id = "field10235";
//报销金额不含税
var bx_jebhs = "";


//页面加载事件
$(function () {

    //jQuery("#budget_dr").append("<input type=\"button\" class=\"e8_btn_top_first\" _disabled=\"true\" value=\"预算(多人)\" title=\"预算(多人)\"  onclick=\"budget_dr(); return false;\" style=\"max-width: 100px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;\">");
    var prop = new Prop();
    //获取配置文件中的字段id
    bxr_id = prop.getVal("wf_request", "bx_sfwbxr");
    ys_dr_id = prop.getVal("wf_request", "bx_ys_dr");
    bxzje_dr_id = prop.getVal("wf_request", "bx_bxzje_dr");
    fykm_dr_id = prop.getVal("wf_request", "bx_fykm_dr");
    cczx_dr_id = prop.getVal("wf_request", "bx_cczx_dr");
    bxlx_id = "field10254";
    bx_jebhs = prop.getVal("wf_request", "bx_jebhs");
    //绑定    费用科目-单人报销
    /*$("#"+fykm_dr_id).bindPropertyChange(function() {
        var fykm = $("#"+fykm_dr_id).val();
        var cczx = $("#"+cczx_dr_id).val();
        var ys = getbudget(fykm,cczx);
        cus_setInputFieldValue(ys_dr_id,ys);
    });
    //绑定    成本中心-单人报销
    $("#"+cczx_dr_id).bindPropertyChange(function() {
        var fykm = $("#"+fykm_dr_id).val();
        var cczx = $("#"+cczx_dr_id).val();
        var ys = getbudget(fykm,cczx);
        cus_setInputFieldValue(ys_dr_id,ys);
    });*/
    // 对报销明细表"添加按钮"添加绑定事件
    //var key = getdetailNum();
    //wfDetail.doAdd(1,1,0,false);
    //提交前验证，未履行金额不能小于0
    var checkCustomizeOld = checkCustomize;
    checkCustomize = function () {
        // 提交标识  判断是否允许提交
        var flag = true;
        var bxr_value = $("#" + bxr_id).val();
        var ys_dr_value = $("#" + ys_dr_id).val();
        var bxzje_dr_value = $("#" + bxzje_dr_id).val();
        var bxzje_nodr_value = $("#" + bxzje_nodr_id).val();
        var bxlx_value = $("#" + bxlx_id).val();
        // add by lyl 20180907 排除过滤条件职工薪酬-福利费-XXX不做预算校验 begin
        //金额不含税
        var bx_jebhs_value = $("#" + bx_jebhs).val();

        var fykm = $("#" + fykm_dr_id + "span").find("a").text();

        if (fykm.indexOf("职工薪酬-福利费") == (-1) && fykm != "其他应付款-外部单位-其他" && fykm.indexOf("专项应付款") == (-1)) {


            // ①申请人为报销人：报销总金额（bxzje1）与报销明细（主表）中预算值（ys1）进行校验，如报销总金额大于预算值，则不能完成提交。

            if (bxr_value == "0") {
                //③若表中预算值（ys和ys1）为空（null或0），则不进行提交校验
                if (ys_dr_value != "" && ys_dr_value != null) {
                    //bxzje_dr_value  改为 bx_jebhs_value(金额不含税)
                    if ((parseFloat(bx_jebhs_value) > parseFloat(ys_dr_value)) && bxlx_value * 1 == 0) {
                        //alert(bx_jebhs_value);
                        top.Dialog.alert("报销金额超过预算，请核对！");
                        flag = false;
                    }
                }

            }
            // add by lyl 20180907 排除过滤条件职工薪酬-福利费-XXX不做预算校验 end
            //②申请人不为报销人：报销总金额（bxzje2）与报销明细（明细表）中预算值（ys）进行校验，如表中同一成本中心的报销金额之和大于该成本中心预算值，则不能完成提交。
            else if (bxr_value == "1") {
                // 开支明细金额合计值
                var kzmxje = $("#field11715").val();
                // 报销明细金额合计值
                var bxmxje = $("#field11718").val();
                if ((parseFloat(kzmxje) != parseFloat(bxmxje)) && bxlx_value * 1 == 0) {
                    top.Dialog.alert("开支明细金额合计值 与 报销明细金额合计值不一致，请核对！");
                    flag = false;
                }

            }
        }


        if (bxr_value != "1" && bxr_value != "0") {

            alert("请选择是否为报销人本人。");
            return false;
        }


        if (flag) {

            // 返回值msg为false
            return checkCustomizeOld();
        } else {
            return false;
        }
    }

});

// 更新多人报销时的预算信息
function budget_dr() {
    // 费用科目
    var fykm = $("#" + fykm_dr_id).val();
    // 遍历明细表
    for (var i = 0; i < getmaxdetailNum(); i++) {
        var ys = getbudget(fykm, getdtcbzx(i));
        alert(ys);
        // 赋值 预算
        setdtys(i, ys);
    }
}

// 遍历报销明细，获取所有成本中心，并去重
function getallcbzx() {
    var array = new Array();
    // 遍历明细表，获取成本中心，组成数据
    for (var i = 0; i < getmaxdetailNum(); i++) {
        arr[i] = getdtcbzx(i + 1);
        i++;
    }
    return array;
}

// 根据 费用科目、成本中心获取预算
function getbudget(subject, costcenter) {
    if (($("#" + bxr_id).val()) == 0) {
        // 预算值
        var budget = "";
        // 判断科目、成本中心是否均不为空
        if (subject != "" && subject != null && costcenter != "" && subject != costcenter) {
            // 预算值
            var budget = "";
            //ajax请求，获取预算
            jQuery.ajax({
                type: "POST",
                data: "",
                dataType: "text",
                url: "/weavernorth/jsp/WfCost.jsp?subject=" + subject + "&costcenter=" + costcenter,
                cache: false,
                async: false,
                success: function (data) {
                    budget = data.trim();
                },
                error: function () {
                    top.Dialog.alert("获取SAP预算失败，请联系OA管理员！");
                }
            });
        }
    }
    return budget;
}

//将数组遍历去重
function unique(arr) {
    // 遍历arr，把元素分别放入tmp数组(不存在才放)
    var tmp = new Array();
    for (var x = 0; x < arr.length; x++) {
        //该元素在tmp内部不存在才允许追加
        if (tmp.indexOf(arr[x]) == -1) {
            tmp.push(arr[x]);
        }
    }
    return tmp;
}

//获取明细行数
function getmaxdetailNum() {
    // 得到第 2个明细的数据
    var detail = wfDetail.doGet(1);
    // 获取明细数据
    var datas = detail.datas;
    // 获取当前添加的行号
    var keys = datas.length;
    return keys;
}

//获取某一行的明细表成本中心的数据
function getdtcbzx(num) {
    // 得到第 2个明细的数据
    var detail = wfDetail.doGet(1);
    // 获取明细数据
    var datas = detail.datas;
    var cbzx_value = datas[num].wdfield11732;
    // 获取当前添加的行号
    //var keys = datas.length;
    return cbzx_value;
}

//获取某一行的明细表预算的数据
function getdtys(num) {
    // 得到第 2个明细的数据
    var detail = wfDetail.doGet(1);
    // 获取明细数据
    var datas = detail.datas;
    var ys_value = datas[num].wdfield11666;
    return ys_value;
}


//赋值明细表预算值
function setdtys(num, budgetvalue) {
    // 得到第 2个明细的数据
    var detail = wfDetail.doGet(1);
    // 获取明细数据
    var datas = detail.datas;
    datas[num].wdfield11666 = budgetvalue;
    datas[num].wdfield11666span = budgetvalue;

    wfDetail.doSet(1, datas, false, (parseInt(num) + 1), true);
}





