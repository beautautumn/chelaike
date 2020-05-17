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
		            type: 'column'
		        },
		        title: {
		            text: '拍卖量与销售量统计'
		        },
		        /* subtitle: {
		            text: 'Source: WorldClimate.com'
		        }, */
		        xAxis: {
		            categories: ['一月', '二月', '三月', '四月', '五月', '六月',
		 		                '七月', '八月', '九月', '十月', '十一月', '十二月']
		        },
		        yAxis: {
		            min: 0,
		            title: {
		                text: '成交量'
		            }
		        },
		        tooltip: {
		            headerFormat: '<span style="font-size:10px">{point.key}</span>',
		            pointFormat: '' +
		                '',
		            footerFormat: '<table><tbody><tr><td style="color:{series.color};padding:0">{series.name}: </td><td style="padding:0"><b>{point.y} 辆</b></td></tr></tbody></table>',
		            shared: true,
		            useHTML: true
		        },
		        plotOptions: {
		            column: {
		                pointPadding: 0.2,
		                borderWidth: 0
		            }
		        },
		        series: [{
		            name: '拍卖量',
		            data: [499, 715, 506, 829, 544, 476, 735, 848, 616, 994, 956, 544]

		        }, {
		            name: '销售量',
		            data: [836, 788, 985, 934, 606, 845, 605, 304, 912, 835, 706, 923]

		        }]
		    });
		});
	</script>
</head>
<body>
	<div id="container" style="min-width: 310px; height: 400px; margin: 0 auto"></div>
</body>
</html>