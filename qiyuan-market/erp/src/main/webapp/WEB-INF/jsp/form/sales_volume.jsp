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
		            text: '销售量报表',
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
		                text: '销售量'
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
		            name: '张力',
		            data: [12, 15, 21, 14, 17, 24, 13, 15, 26, 14, 17, 22]
		        }, {
		            name: '李明',
		            data: [14, 22, 17, 15, 11, 18, 23, 19, 24, 18, 22, 24]
		        }, {
		            name: '薛峰',
		            data: [11, 23, 22, 11, 19, 25, 27, 21, 16, 17, 21, 21]
		        }, {
		            name: '蔡丽',
		            data: [22, 13, 16, 17, 25, 17, 11, 16, 13, 21, 19, 18]
		        }]
		    });
		});
	</script>
</head>
<body>
	<div id="container" style="min-width: 310px; height: 400px; margin: 0 auto"></div>
</body>
</html>