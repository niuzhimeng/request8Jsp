<%@ include file="/systeminfo/init_wev8.jsp" %>
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <link rel="stylesheet" href="/workflow/request/xinTai/images/index.min.css?v=1556193941140">
</head>

<div class="wea-new-top-wapper">
    <div class="ant-col-14" style="padding-left: 20px; line-height: 20px;display: inline;">
        <div style="display: inline; float: left">
            <img style="margin-top: 8px" width="40px" height="40px"
                 src="/workflow/request/xinTai/images/workflow_analyze.png"/>
        </div>
        <div style="display: inline; float: left; margin-top: 18px">
            <p class="wea-f14">扫码查询</p>
        </div>
    </div>

</div>
<div class="ant-col-10"
     style="text-align: right; line-height: 50px; padding-right: 14px; position: absolute; right: 0px; width: auto;">
    <div class="wea-new-top-drop-menu wea-right-menu" style="display: none;"><span class="wea-new-top-drop-btn"><i
            class="icon-button icon-New-Flow-menu"></i></span></div>
</div>
</div>

<div class="wf-scanworkflow-content">
    <div class="ant-tabs ant-tabs-top ant-tabs-card" style="width: 600px; margin: 0 auto">
        <div class="ant-tabs ant-tabs-top ant-tabs-card" style="width: 600px; margin: 0 auto">
            <input onclick="myClear()" id="myInput" type="text"
                   value="" style="margin-left: 20px; margin-top: 200px; color: #848484; width: 570px; height: 30px;"
                   autocomplete="off"/>
        </div>
    </div>

    <script type="text/javascript">
        $(function () {
            var doInput = jQuery("#myInput");
            doInput.focus();
            doInput.blur(function () {
                doInput.val('请选中后进行扫码')
            });

            doInput.keyup(function (event) {
                if (event.keyCode === 13) {
                    var requestId = doInput.val();
                    var workFlowUrl = "/workflow/request/ViewRequest.jsp?requestid=" + requestId + "&_workflowtype=&isovertime=0";
                    window.open(workFlowUrl);
                }
            })
        });

        function myClear() {
            jQuery("#myInput").val('')
        }
    </script>

    <style type="text/css">
        .wea-f14 {
            font-size: 14px;
            font-family: "微软雅黑", "微软雅黑", "Microsoft YaHei", Helvetica, Tahoma, sans-serif;
        }

        input:focus {
            border-color: #7dcae9;
            outline: 0;
            -webkit-box-shadow: inset 0 1px 1px rgba(0, 0, 0, .075), 0 0 1px rgba(102, 175, 233, .6);
            box-shadow: inset 0 1px 1px rgba(0, 0, 0, .075), 0 0 1px rgba(102, 175, 233, .6)
        }

        .wf-scanworkflow-content .wf-scanworkflow-title {
            text-align: center;
            margin: 20px 0;
            font-size: 16px;
        }

        .wf-scanworkflow-content .wf-scanworkflow-subTitle {
            text-align: center;
            color: red;
            margin: 20px 0;
        }

        .wf-scanworkflow-content .wf-scanworkflow-scanCode {
            margin: 30px auto;
            text-align: center;
        }

        .wea-new-top-wapper {
            font-weight: 500;
            white-space: nowrap;
            overflow: hidden;
            -o-text-overflow: ellipsis;
            text-overflow: ellipsis;
            background-color: #f9f9f9;
            border-bottom: 1px solid #eaeaea;
            border-bottom-width: 1px;
            border-bottom-style: solid;
            border-bottom-color: rgb(234, 234, 234);
            position: relative;
        }

        .wf-scanworkflow-content .wf-scanworkflow-tip {
            text-align: center;
            font-size: 13px;
            font-family: "Arail", "Microsoft YaHei", "宋体", sans-serif;
            margin-top: 30px;
        }

        .wea-input-normal .ant-input {
            height: inherit;
            min-height: 30px;
            font-size: inherit;
            padding: 0;
            padding-left: 5px;
            border-radius: 0;
        }

        .wea-new-top-wapper .wea-new-top .wea-new-top-title {
            font-weight: 500;
            color: #484848;
            white-space: nowrap;
            overflow: hidden;
            -o-text-overflow: ellipsis;
            text-overflow: ellipsis;
        }

    </style>
