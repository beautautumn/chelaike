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
		    	chart: {
		            plotBackgroundColor: null,
		            plotBorderWidth: null,
		            plotShadow: false
		        },
		        title: {
		            text: '商户当前车辆数占比'
		        },
		        tooltip: {
		    	    pointFormat: '{series.name}: <b>{point.percentage:.1f}%</b>'
		        },
		        plotOptions: {
		            pie: {
		                allowPointSelect: true,
		                cursor: 'pointer',
		                dataLabels: {
		                    enabled: true,
		                    color: '#000000',
		                    connectorColor: '#000000',
		                    format: '<b>{point.name}</b>: {point.percentage:.1f} %'
		                }
		            }
		        },
		        series: [{
		            type: 'pie',
		            name: '占比',
		            data: [
		                ['商家一',   45.0],
		                ['商家二',       26.8],
		                {
		                    name: '商家三',
		                    y: 12.8,
		                    sliced: true,
		                    selected: true
		                },
		                ['商家四',    8.5],
		                ['商家五',     6.2],
		                ['商家六',   0.7]
		            ]
		        }]
		    });
		});
	</script>
</head>
<body>
	<div id="container" style="min-width: 310px; height: 500px; margin: 50px auto"></div>
</body>
</html>