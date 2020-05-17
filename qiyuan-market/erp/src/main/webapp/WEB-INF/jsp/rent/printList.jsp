<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@taglib uri="/struts-tags" prefix="s"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ include file="/common/taglibs.jsp"%>
<%@ include file="/common/meta.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title></title>
<link rel="stylesheet" type="text/css" href="${ctx}/css/style.css" />
<script type="text/javascript" src="${ctx}/js/common/syUtil.js"></script>
<script type="text/javascript" src="${ctx}/js/common/ctutil.js"></script>
<script type="text/javascript" src="${ctx}/js/common/menu.js"></script>
<script type="text/javascript" src="${ctx}/js/common/select.js"></script>
<script type="text/javascript" src="${ctx}/js/common/jquery.json-2.4.js"></script>
<script type="text/javascript" src="${ctx}/js/business/vehicle/vehicle_vin.js"></script>
<script type="text/javascript" src="${ctx}/js/pages/catalogue/catalogue.js"></script>
<script type="text/javascript" src="${ctx}/js/pages/region/region.js"></script>
<script type="text/javascript" src="${ctx}/js/common/validator/validator.js"></script>
<script type="text/javascript" src="${ctx}/js/plugins/My97DatePicker/WdatePicker.js"></script>
<script type="text/javascript">
	function do_submit(){
		if (confirm('确定打印吗？')) 
		{      
			window.print();  
		　　}   
	}
</script>
</head>
<body  style=" text-align:center">
<form id="myForm">	
	<div class="box" id="myPrintArea" style="margin:0 auto;width:500px;height:280px">
		<div><table><tr><td height="30px" ></td></tr></table></div>
		<div align="left">
			<tr>
			<b>商户：</b><td>${agencyName}</td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			<b>区域：</b><td>${areaName}</td>
			</tr>
		</div>
		<div>
			<table id="datatable2" style="border:1px solid #000;">
				<tr border="1">
					<td style="border:1px solid #000;">费用科目</td>
					<td style="border:1px solid #000;width:60px"><b>金额（元）</b></td>
					<td style="border:1px solid #000;width:60px"><b>计费日期</b></td>
					<td style="border:1px solid #000;width:60px"><b>计费方式</b></td>
					<td style="border:1px solid #000;"><b>备注</b></td>
				</tr>
				<s:iterator value="agencyDetailBills">
				<tr border="1">
					<td height="30px" style="border:1px solid #000;">${feeItem.itemName}</td>
					<td style="border:1px solid #000;"><fmt:formatNumber type="number" value="${feeValue/100}" pattern="#.00"/></td>
					<td style="border:1px solid #000;"><fmt:formatDate value="${operTime}" type="date"/></td>
					<td style="border:1px solid #000;" value="${feeType}">
					<s:if test="feeType==1">独立计费</s:if><s:else>分摊计费</s:else>
					</td>
					<td style="border:1px solid #000;"  >${remark}&nbsp;</td>
				</tr>
				</s:iterator>
			</table>
		</div>
		<div align="left">
			<br/>
			<b>总额（元）：</b><fmt:formatNumber type="number" value="${totalFees/100}" pattern="#.00"/>
		</div>
		<div align="right">
			<b>收费日期：</b>${recvTime}
		</div>
	</div>

</form>					
</body>
</html>
