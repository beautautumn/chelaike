<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ include file="/common/taglibs.jsp"%>
<%@ include file="/common/meta.jsp"%>
<%@taglib uri="/struts-tags" prefix="s" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<title></title>	
	<link rel="stylesheet" type="text/css" href="${ctx}/css/style.css" />
	<link rel="stylesheet" type="text/css" href="${ctx}/js/plugins/lhgdialog/skins/mac.css" />
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
  	<script >
  		var api = frameElement.api, W = api.opener;
  		//关闭对话框
		function closeWin(){
			api.get("fee_detail",1).close();
		}
  	</script>
    
</head>
<body>
	<div class="box" style="text-align:center;">
	<table  style="margin:auto; width:95%;margin-top:15px;" border='1'>
		<tr style="width:500px;">
<!--		<tr width="500px" align="center">-->
			<td style="text-align:center;text-valign:center;width:75px;height:35px;"><font size="50px">费用名称</font></td>
			<td style="text-align:center;text-valign:center;width:75px;height:35px;"><font size="10">分摊数额(元)</font></td>
			<td style="text-align:center;text-valign:center;width:150px;height:35px;"><font size="10">分摊人/分摊时间</font></td>
			<td style="text-align:center;text-valign:center;width:200px;height:35px;"><font size="10">分摊备注</font></td>
		</tr>
		<s:iterator value="agencyDetailBills">
		<tr width="500px">
			<td style="text-align:center;text-valign:center;width:125px;height:35px;"><font size="10"><s:property value="feeItem.itemName"/></font></td>
			<td style="text-align:center;text-valign:center;width:125px;height:35px;"><font size="10"><s:property value="feeValue/100"/></font></td>
			<td style="text-align:center;text-valign:center;width:125px;height:35px;"><font size="10"><s:property value="staff.name"/>/<fmt:formatDate value="${operTime}" type="date"/></font></td>
			<td style="text-align:center;text-valign:center;width:125px;height:35px;"><font size="10"><s:property value="remark"/></font></td>
		</tr>
		</s:iterator>
	</table>
	</div>
</body>
</html>
