<%@ page import="weaver.conn.RecordSet" %>
<%@ page import="weaver.hrm.resource.ResourceComInfo" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<jsp:useBean id="RequestManager" class="weaver.workflow.request.RequestManager" scope="page"/>
<jsp:useBean id="flowDocss" class="weaver.workflow.request.RequestDoc" scope="session"/>
<jsp:useBean id="DocComInfo" class="weaver.docs.docs.DocComInfo" scope="page"/>
<jsp:useBean id="Doccoder" class="weaver.docs.docs.DocCoder" scope="page"/>

<script type="text/javascript">
    jQuery(document).ready(function () {
        var r;
        var arr = ['apple', 'strawberry', 'banana', 'pear', 'apple', 'orange', 'orange', 'strawberry'];

        r = arr.filter(function (element, index, self) {
            return self.indexOf(element) === index;
        });

        alert(r.toString());
    })
</script>

<script type="text/javascript">
    jQuery(document).ready(function () {
        var shuzu = [1, 2, 3];
        shuzu.filter(function (curr, index, arr) {// 当前值， 当前值下标， 过滤的数组
            alert('curr: ' + curr)
            alert('index: ' + index)
            alert('arr: ' + arr)
        })
    })
</script>

<script type="text/javascript">
    // 合计字段
    var allFile = 'field6667';
    jQuery(document).ready(function () {
        checkCustomize = function () {
            var flag = true;
            var allFileVal = jQuery('#' + allFile).val();
            if (allFileVal > 1) {
                window.top.Dialog.alert("权重总计不得超过100%");
                flag = false;
            }
            return flag;
        }
    })
</script>

<script type="text/javascript">
    jQuery(document).ready(function () {
        checkCustomize = function () {
            var flag = false;
            var a = prompt('显示的输入框外的提示', '显示的时输入框内的提示');
            alert(a);
            return flag;
        }
    })
</script>

<script type="text/javascript">
    jQuery(document).ready(function () {
        checkCustomize = function () {
            var flag = true;
            var myVal = $("#field6654").val();
            if (myVal > 100) {
                flag = confirm("是否提交?");
            }
            alert(flag);
            return flag;
        }
    })
</script>

<script type="text/javascript">
    $(function () {
        $("#mxb").css('display', 'none')
    })
</script>


<script src="/js/shauter_wev8.js"></script>
<script src="/workflow/request/testJsp/cw.js"></script>
<script type="text/javascript">
    jQuery(document).ready(function () {
        var zfjeid = 'field6541';//报销金额
        var jkjeid = 'field8664';//借款金额
        var sjfkid = 'field8665';//本次报销金额
        $("#" + sjfkid).attr('readonly', 'readonly');
        //计算金额
        _C.run2(zfjeid, jisuan);

        function jisuan(p) {
            if (p.v.o == undefined) {
                return;
            }
            var fkfs = $("#" + zfjeid).val();//借款金额
            var sjfk = $("#" + jkjeid).val();//本次报销金额
            var myResult = fkfs - sjfk;
            if (myResult >= 0) {
                $("#" + sjfkid).val(myResult);
            } else {
                $("#" + sjfkid).val(0);
            }
        }

        jQuery("#field10150").bindPropertyChange(function () {
            var fycdzt = jQuery("#field10150").val();
            //发送请求
            $.post("/workflow/request/gaoji/FycdztUnionFycdcm.jsp", {
                "fycdzt": fycdzt
            }, function (data) {
                var data = data.replace(/\s+/g, "");
                if (data == 'true') {
                    changeFieldShowattr("10151", "2", "0", -1);//修改字段属性
                } else {
                    changeFieldShowattr("10151", "3", "0", -1);
                }
            });
        });
    })
</script>


<%
    response.sendRedirect("/filesystem\\201803\\Q\\a44af351-12a2-4ab4-a79c-99c59cf59d22.zip");
%>


<!--
<script type="text/javascript">
jQuery(document).ready(function () {
checkCustomize = function () {
var istrue = confirm('确认提交？');
return istrue;
}
})
</script>
-->


<script type="text/javascript">
    /**
     * 不能提交三天之前的流程
     */
    jQuery(document).ready(function () {
        // 拦截提交方法
        jsAOP(window, {
            'doSubmit': {
                before: function () {
                    return checkData();
                }
            }
        });
    });

    // 检查数据
    function checkData() {
        if (checkGL()) {
            return true;
        } else {
            return false;
        }
    }

    function checkGL() {
        var isSuccess = true;
        var ymdate = jQuery("#field7854").val();//页面日期


        var myDate = new Date();
        var dqdate = myDate.toLocaleDateString(); //获取当前日期


        var sArr = ymdate.split("-");
        var eArr = dqdate.split("/");
        var sRDate = new Date(sArr[0], sArr[1], sArr[2]);
        var eRDate = new Date(eArr[0], eArr[1], eArr[2]);
        var days = (sRDate - eRDate) / (24 * 60 * 60 * 1000);

        alert("days:" + days)
        if (days < (-3)) {
            alert("所选日期不能小于系统时间3天");
            return false;
        } else {
            return true;
        }
    }

    function jsAOP(obj, handlers) {
        if (typeof obj == 'function') {
            obj = obj.prototype;
        }
        for (var methodName in handlers) {
            var _handlers = handlers[methodName];
            for (var handler in _handlers) {
                if ((handler == 'before' || handler == 'after')
                    && typeof _handlers[handler] == 'function') {
                    eval(handler)(obj, methodName, _handlers[handler]);
                }
            }
        }

        function before(obj, method, f) {
            var original = obj[method];
            obj[method] = function () {
                var isSubmit = f.apply(this, arguments);
                if (!isSubmit)
                    return false;
                return original.apply(this, arguments);
            }
        }

        function after(obj, method, f) {
            var original = obj[method];
            obj[method] = function () {
                original.apply(this, arguments);
                return f.apply(this, arguments);
            }
        }
    }


</script>


<script type="text/javascript">
    jQuery(document).ready(
        function () {
            jQuery('#innerContentfield6774div').append('<span style="float:none;" name="field6774span" id="field6774span"><img src="/images/BacoError_wev8.gif" align="absMiddle"></span>')
        });
</script>

<script type="text/javascript">
    $(function () {
        //保存
        doSave = function () {
            alert('准备保存')
            return false;
        }
    })
</script>

<script type="text/javascript">
    var getId = 'field74621';
    var insertId = 'field74622';
    $(function () {
        $("#" + getId).bindPropertyChange(function () {
            var val = $("#" + getId).val();
            alert(val)
            $("#" + insertId).val(val);
        })
    })
</script>



