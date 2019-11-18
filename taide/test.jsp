<%--加班流程js 2019-05-10日修改--%>
<%--打卡时间非空校验 + 开始结束时间差值大于1小时--%>
<script type="text/javascript">
    jQuery(document).ready(function () {
        checkCustomize = function () {
            var type = jQuery('#field19927').val(); // 加班类型
            var rank = jQuery('#field19186').val(); // 职级
            var dksj = jQuery('#field22232').val(); // 打卡时间

            var kssj = jQuery('#field22233').val(); // 开始时间
            var kssjs = kssj.split(":");
            var jssj = jQuery('#field22234').val(); // 结束时间
            var jssjs = jssj.split(":");

            if (dksj == null || dksj == '' || dksj == undefined) {
                window.top.Dialog.alert("打卡时间不能为空");
                return false;
            }

            if (rank == "22" && type == "2") {
                window.top.Dialog.alert("经理级不能提平时加班");
                return false;
            }
            if (rank == "24" || rank == "25") {
                window.top.Dialog.alert("总监和副总级以上不能提加班申请");
                return false;
            }

            var dateStart = new Date();
            var dateEnd = new Date();


            dateStart.setHours(kssjs[0]);
            dateStart.setMinutes(kssjs[1]);
            dateStart.setSeconds(0);

            dateEnd.setHours(jssjs[0]);
            dateEnd.setMinutes(jssjs[1]);
            dateEnd.setSeconds(0);

            // 计算时间差, 单位是毫秒
            var minus = dateEnd.getTime() - dateStart.getTime();
            //这里是毫秒，除以1000是秒，除60是分钟再除60是小时
            var hour = minus / (1000 * 60 * 60);

            if (hour < 1) {
                window.top.Dialog.alert("【开始时间】与【结束时间】差值需大于一小时");
                return false;
            }
            return true;
        }
    });
</script>

<script type="text/javascript">
    var wbyid = 'field6952span';
    jQuery(document).ready(function () {
        var wbyDoc = $('#' + wbyid);
        wbyDoc.removeAttr('style');
        wbyDoc.attr('style', 'word-break: keep-all!important; word-wrap: break-word!important; white-space: pre-wrap!important;')
    })
</script>

<script type="text/javascript">
    // 标题id
    var btid = 'field13526span';
    // 正文id
    var wbyid = 'field13479span';

    jQuery(document).ready(function () {
        var wbyDoc = $('#' + wbyid);
        wbyDoc.removeAttr('style');
        wbyDoc.attr('style', 'word-break: keep-all!important; word-wrap: break-word!important; white-space: pre-wrap!important;');

        var btDoc = $('#' + btid);
        btDoc.removeAttr('style');
        btDoc.attr('style', 'word-break: keep-all!important; word-wrap: break-word!important; white-space: pre-wrap!important;');
    })
</script>


<script type="text/javascript">
    $(function () {
        ecodeSDK.rewriteRouteQueue.push({
            fn:(params)=>{
                const {Com,Route,nextState} = params;
                const cpParams = {
                    path:'main/cs/app', //路由地址
                    appId:'${appId}',
                    name:'pageSimple', //具体页面应用id
                    node:'app', //渲染的路由节点，这里渲染的是app这个节点
                    Route,
                    nextState
                }
                if(ecodeSDK.checkPath(cpParams)) {
                    const acParams = {
                        appId:cpParams.appId,
                        name:cpParams.name, //模块名称
                        params, //参数
                        isPage:true, //是否是路由页面
                        noCss:true //是否禁止单独加载css，通常为了减少css数量，css默认前置加载
                    }
//异步加载模块${appId}下的子模块pageSimple
                    return ecodeSDK.getAsyncCom(acParams);
                }
                return Com;
            },
            order:10,
            desc:'这是一新页面纯表单的参考案例'
        });


    })
</script>



