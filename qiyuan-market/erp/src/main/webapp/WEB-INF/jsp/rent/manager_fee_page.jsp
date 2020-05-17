<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@taglib uri="/struts-tags" prefix="s"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ include file="/common/taglibs.jsp"%>
<%@ include file="/common/meta.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>新增分摊总额</title>
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
		var feeItemId = $("#feeItemId").val();
		if(feeItemId == '0'){
			alert("请选择   费用科目！");
			return;
		}
		var beginDate = $("#beginDate").val();
		if(beginDate == ''){
			alert("请输入   费用发生开始日期！");
			return;
		}
		var endDate = $("#endDate").val();
		if(endDate == ''){
			alert("请输入   费用发生结束日期！");
			return;
		}
		var totalFee = $("#totalFee").val();
		if(totalFee==''){
			alert("请输入   费用总额！");
			return;
		}
		var remark = $("#remark").val();
		if(remark.length>255){
			alert("输入   费用备注   过长！");
		}
		data="managerFeeId="+$("#managerFeeId").val()
			+"&managerFeeBean.feeItemId="+feeItemId
			+"&managerFeeBean.beginDate="+beginDate
			+"&managerFeeBean.endDate="+endDate
			+"&managerFeeBean.totalFee="+totalFee
			+"&managerFeeBean.remark="+remark;
		$.ajax({
				cache: false,
				type: "POST",
				url:ctutil.bp()+"/rent/managerFeeAction!doAddManagerFee.action",
				data:data,
				async: false,
				error: function() {
				html = "数据请求失败";
				},
				success: function(data) {
				  if(data=="success"){
					  alert("保存成功！");
					  api.get("managerFee", 1).close();
					  W.query1();  //刷新副页面
				  }else{
					  alert("保存失败！");
					  api.get("managerFee", 1).close();
				  }
				}
			});
		
		
	}
</script>

</head>
<body>
<form id="myForm">	
<div class="box">
			<table>	
				<tr>
					<td width="40px"></td>
					<td>
						<table>
							<input type="hidden" id="managerFeeId" value="${managerFee.id}"/>
							<tr>
								<td class="text-r" width="120">费用科目:<span class="red">*</span></td>
								<td width="300">
									<select id="feeItemId" class="input w200">
											<option value='0'>请选择</option>
										<s:iterator value="feeItems">
											<option <s:if test="id==managerFeeBean.feeItemId">selected</s:if> value="<s:property value='id'/>" ><s:property value="itemGroup"/> <s:property value="itemName"/></option>
										</s:iterator>
									</select>
								</td>
							</tr>
							<tr> 
								<td class="text-r">费用发生开始日期:<span class="red">*</span></td>
								<td><input type="text" class="input w200" id="beginDate" onClick="WdatePicker()"  value="${managerFeeBean.beginDate}"/></td>
							</tr>
							<tr> 
								<td class="text-r">费用发生结束日期:<span class="red">*</span></td>
								<td><input type="text" class="input w200" id="endDate" onClick="WdatePicker()" value="${managerFeeBean.endDate}"/></td>
							</tr>
								
							<tr> 
								<td class="text-r">费用总额:<span class="red">*</span></td>
								<td><input type="text" class="input w200" id="totalFee" onkeyup="value=value.replace(/[^(\d||/.)]/g,'')" value="${managerFeeBean.totalFee}"/>元</td>
							</tr>
							<tr>
							</tr>
							<tr>
								<td class="text-r">费用备注:</td>
								<td>
									<textarea id="remark" style="width:280px;height:120px">${managerFeeBean.remark}</textarea>
								</td>
							</tr>
						</table>
					</td>
					<td></td>
				</tr>
		</table>		
	
</div>		
</form>					
</body>
</html>
