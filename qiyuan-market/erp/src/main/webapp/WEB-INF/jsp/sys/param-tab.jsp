<%@ page language="java" pageEncoding="UTF-8" contentType="text/html; charset=UTF-8"%>
<%@ include file="/common/taglibs.jsp"%>
<script type="text/javascript" src="${ctx}/js/plugins/jquery/jquery-1.10.2.min.js" charset="utf-8"></script>
<script type="text/javascript" src="${ctx}/js/plugins/jquery-ui/jquery-ui.min.js" charset="utf-8"></script>
<link href="${ctx}/js/plugins/jquery-ui/jquery-ui.min.css" rel="stylesheet" type="text/css">
        <style>
            html {
                font-size:10px;
            }
            .iframetab {
                width:100%;
                height:auto;
                border:0px;
                margin:0px;
                background:url("data/iframeno.png");
                position:relative;
                top:5px;
            }

            .ui-tabs-panel {
                padding:5px !important;
            }

            .openout {
                float:right;
                position:relative;
                top:-28px;
                left:-5px;
            }
        </style>
        <script>
            $(document).ready(function() {
                var $tabs = $('#tabs').tabs();
			
				loadTabFrame("#tabs-1","${ctx}/list/page!toRptIndex.action?viewId=600");
                //get selected tab
                function getSelectedTabIndex() {
                    return $tabs.tabs('option', 'selected');
                }

                //get tab contents
                beginTab = $("#tabs ul li:eq(" + getSelectedTabIndex() + ")").find("a");

                loadTabFrame($(beginTab).attr("href"),$(beginTab).attr("rel"));

                $("a.tabref").click(function() {
                    loadTabFrame($(this).attr("href"),$(this).attr("rel"));
                });

                //tab switching function
                function loadTabFrame(tab, url) {
                    if ($(tab).find("iframe").length == 0) {
                        var html = [];
                        html.push('<div class="tabIframeWrapper">');
                        html.push('<div class="openout"></div><iframe class="iframetab" src="' + url + '">Load Failed?</iframe>');
                        html.push('</div>');
                        $(tab).append(html.join(""));
                        $(tab).find("iframe").height($(window).height()-80);
                    }
                    return false;
                }
            });
        </script>
    </head>
    <body>
        <div id="tabs">
            <ul>
                <li><a class="tabref" href="#tabs-1" rel="${ctx}/list/page!toRptIndex.action?viewId=600">收购渠道配置</a></li>
                <li><a class="tabref" href="#tabs-4" rel="${ctx}/list/page!toRptIndex.action?viewId=604">销售渠道设置</a></li>
                <li><a class="tabref" href="#tabs-2" rel="${ctx}/list/page!toRptIndex.action?viewId=601">车辆等级设置</a></li>
                <li><a class="tabref" href="#tabs-3" rel="${ctx}/list/page!toRptIndex.action?viewId=602">分店信息设置</a></li>
                <li><a class="tabref" href="#tabs-5" rel="${ctx}/list/page!toRptIndex.action?viewId=605">质保等级设置</a></li>
                <!-- //2014-05-20 -->
                <li><a class="tabref" href="#tabs-6" rel="${ctx}/sys/param_toStockWarningConf.action">库存预警设置</a></li>
            </ul>
            <div id="tabs-1" class="tabMain"></div>
            <div id="tabs-2"></div>
            <div id="tabs-3"></div>            
            <div id="tabs-4"></div>            
            <div id="tabs-5"></div>
             <!-- //2014-05-20 -->
            <div id="tabs-6"></div>
        </div> 
    </body>