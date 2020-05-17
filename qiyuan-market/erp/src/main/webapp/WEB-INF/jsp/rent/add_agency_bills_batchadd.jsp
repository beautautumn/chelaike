<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@taglib uri="/struts-tags" prefix="s"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ include file="/common/taglibs.jsp"%>
<%@ include file="/common/meta.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>批量添加</title>
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
<script>
var api = frameElement.api, W = api.opener;
function do_submit(){
	var siteAreaId = $("#siteAreaId").val();
	if(siteAreaId==0){
		alert("请选择场地区域！");
		return;
	}
	$.ajax({
				cache: false,
				type: "POST",
				url:ctutil.bp()+"/rent/agencyBillsAction!findContractByAreaId.action",
				data:"areaId="+siteAreaId,
				async: false,
				error: function() {
				alert("发送请求失败！");
				},
				success: function(data) {
					if(data=="error"){
						alert("操作失败！");
					}else{
						api.get('managerFee').insertByAdd(data);
						api.get("agencyBillsBatchAdd",1).close();
					}
				}
			});
}
</script>
</head>
<body  style=" text-align:center">
<form id="myForm">	
<div class="box">
		<table>
			<tr>
				<input type="hidden" id="contractId" />
				<td>
					<table>	
						<tr height="30px"></tr>
						<tr>
							<td class="text-r" width="100">场地区域：</td>
							<td>
								<select id="siteAreaId" class="input w200" onchange="selectContract(this.value,this.options[this.selectedIndex].text)">
										<option value='0'>请选择</option>
									<s:iterator value="siteAreas">
										<option value="<s:property value='id'/>"><s:property value="areaName"/></option>
									</s:iterator>
								</select>
							</td>
						</tr>
						
					</table>
				</td>
				<td></td>
			</tr>
		</table>
</form>					
</body>
</html>
