<script type="text/javascript">
    var tbrId = 'field7093';//填报人id(主表)

    var xmjl = 'field7105';//项目经理
    var xm = 'field7096';//姓名

    var ejbm = 'field7110';//二级部门
    var sjbm = 'field7095';//三级部门
    var gh = 'field7097';//工号
    var rylb = 'field7098';//人员类别
    var bmgg = 'field7099';//部门公共

    var xmbh = 'field7114';//项目编号
    var xmmc = 'field7100';//项目名称
    var ywfx = 'field7117';//业务方向
    var gsqzzj = 'field7101';//工时权重总计
    var sm = 'field7102';//说明

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
            alert(data)
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







