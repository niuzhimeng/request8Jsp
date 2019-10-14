<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<div class="ant-row wea-new-top">
    <div class="ant-col-14" style="padding-left: 20px; line-height: 50px;">
        <div class="wea-new-top-title wea-f14">
            <div class="icon-circle-base" style="background: rgb(0, 121, 222);"><i class="icon-portal-workflow"></i>
            </div>
            <span class="wea-new-top-title-breadcrumb" style="vertical-align: middle;"><span>扫码查询</span></span>
        </div>
    </div>
    <div class="ant-col-10"
         style="text-align: right; line-height: 50px; padding-right: 14px; position: absolute; right: 0px; width: auto;">
        <div class="wea-new-top-drop-menu wea-right-menu" style="display: none;"><span class="wea-new-top-drop-btn"><i
                class="icon-button icon-New-Flow-menu"></i></span>
        </div>
    </div>
</div>


<div class="wf-scanworkflow-content">
    <div class="wf-scanworkflow-title">请使用扫码枪扫描二维码或条形码</div>
    <div class="wf-scanworkflow-subTitle">注：系统只能识别对应流程ID的二维码/条形码</div>
    <div class="wf-scanworkflow-scanCode"><img src="/images/ecology9/workflow/codedome.png"></div>
    <div class="ant-tabs ant-tabs-top ant-tabs-card">
        <div role="tablist" class="ant-tabs-bar" tabindex="0">
            <div class="ant-tabs-nav-container ">
                <div class="ant-tabs-nav-wrap">
                    <div class="ant-tabs-nav-scroll">
                        <div class="ant-tabs-nav">
                            <div class="ant-tabs-ink-bar"
                                 style="transform: translate3d(0px, 0px, 0px); width: 90px; display: block;"></div>
                            <div role="tab" aria-disabled="false" aria-selected="true"
                                 class=" ant-tabs-tab-active ant-tabs-tab">
                                <div class="ant-tabs-tab-inner">逐个处理</div>
                            </div>
                            <div role="tab" aria-disabled="false" aria-selected="false" class=" ant-tabs-tab">
                                <div class="ant-tabs-tab-inner">批量处理</div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="ant-tabs-content">
            <div role="tabpanel" aria-hidden="false" class="ant-tabs-tabpane">
                <div class="wf-scanworkflow-tab-content-wrap">
                    <div class="wea-input-normal  ">
                        <span class="ant-input-wrapper">
                            <input inputtype="NORMAl" type="text" autocomplete="off" class="ant-input" value="">
                        </span>
                        <input type="hidden" value="">
                    </div>
                </div>
                <div class="wf-scanworkflow-tip">使用扫描枪扫描二维码或条形码可自动打开条码对应的流程</div>
            </div>
        </div>
    </div>
</div>

