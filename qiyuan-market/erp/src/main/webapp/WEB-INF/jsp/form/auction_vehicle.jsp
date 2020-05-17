<%@ page language="java" pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ include file="/common/taglibs.jsp"%>
<%@ include file="/common/meta.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>大公市场</title>
    <meta name="keywords" content="关键词">
    <meta name="description" content="描述">
    <link rel="shortcut icon" href="favicon.ico">
    <script type="text/javascript" src="${ctx}/js/common/jquery.json-2.4.js"></script>
	<script type="text/javascript" src="${ctx}/js/plugins/jquery/jquery.js"></script>
    <script src="${ctx}/js/highcharts.js"></script>
	<script src="${ctx}/js/static/modules/exporting.js"></script>
	<script type="text/javascript">
		$(function () {
		    $('#container').highcharts({
		        title: {
		            text: '拍卖车辆统计报表',
		            x: -20 //center
		        },
		        subtitle: {
		            text: '2014',
		            x: -20
		        },
		        xAxis: {
		            categories: ['一月', '二月', '三月', '四月', '五月', '六月',
		                '七月', '八月', '九月', '十月', '十一月', '十二月']
		        },
		        yAxis: {
		            title: {
		                text: '拍卖量'
		            },
		            plotLines: [{
		                value: 0,
		                width: 1,
		                color: '#808080'
		            }]
		        },
		        tooltip: {
		            valueSuffix: '台'
		        },
		        legend: {
		            layout: 'vertical',
		            align: 'right',
		            verticalAlign: 'middle',
		            borderWidth: 0
		        },
		        series: [{
		            name: '10万元以下',
		            data: [120, 170, 130, 140, 170, 240, 130, 150, 170, 140, 170, 220]
		        }, {
		            name: '10万到20万',
		            data: [140, 220, 170, 110, 110, 180, 230, 190, 150, 180, 220, 240]
		        }, {
		            name: '20万到30万',
		            data: [110, 230, 220, 120, 190, 250, 220, 210, 160, 170, 110, 210]
		        }, {
		            name: '30万以上',
		            data: [220, 130, 160, 170, 250, 180, 110, 160, 130, 220, 190, 180]
		        }]
		    });
		});
	</script>
</head>
<body>
	<div id="container" style="min-width: 310px; height: 400px; margin: 0 auto"></div>
</body>
</html>