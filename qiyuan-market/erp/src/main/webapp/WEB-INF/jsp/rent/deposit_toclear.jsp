<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@taglib uri="/struts-tags" prefix="s"%>
<%@ include file="/common/taglibs.jsp"%>
<%@ include file="/common/meta.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>押金清算</title>
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
	var feeCheckResult = "";
	var api = frameElement.api, W = api.opener;
	function changeType(i){
		if(i==0){
			$("#breachDesc").val("");
			$("#settlementDesc").val("");
			$("#descForDefault").attr("style", "display:none");
			$("#descDefault").attr("style", "display:none");
			$("#descBreach").attr("style", "display:none");
		}
		if(i==1){
			$("#breachDesc").val("");
			$("#settlementDesc").val("");
			$("#descForDefault").attr("style", "display:''");
			$("#descDefault").attr("style", "display:''");
			$("#descBreach").attr("style", "display:''");
		}
	}
	
	function checkFee(inputValue){
		feeCheckResult = "ok";
		var val = $(inputValue).val();
		var reg = /^(-?\d+)(\.\d+)?$/;
            if(!reg.test(val)){
            	alert("输入的数值不正确！");
            	feeCheckResult = "fail";
            	return ;
            }
	}
	
	function do_submit(){
		if(confirm("请确认该合同相关费用已结清！")){
			var data ="";
			if(feeCheckResult=="fail") {
				alert("表单填写不正确！");
			}else{
				data = $("#myForm").serialize();
				ajaxPost(data);
			}
		}else{
			return;
		}
	}
	
	function ajaxPost(data){
		$.ajax({
				cache: false,
				type: "POST",
				url:ctutil.bp()+"/rent/deposit_update.action",
				data:data,
				async: false,
				error: function() {
				html = "数据请求失败";
				},
				success: function(data) {
				  if(data=="success"){
					  alert("保存成功！");
					  api.get("clear_deposit",1).close();
					  W.query1();  
				  }else{
					  alert("保存失败！");
					  api.get("clear_deposit",1).close();
					  W.query1();
				  }
				}
			});
	}
	
	function myfunction(){
		var staff = $("#staffName").val();
		var s = $("#settlementStaffId");
		for(var i=0;i<s.length;i++){
			if(s.options[i].value==staff){
			 	s.options[i].selected = true;
            	break;
			}
		}
	}
	
</script>

</head>
<body onload="myFuncion();">
<form id="myForm">	
<div class="box">
	<input type="hidden" id="staffName" value="${staff.name}"/>
	<input type="hidden" name="agency.id" value="${agency.id}"/>
	<input type="hidden" name="contract.id" value="${contract.id}"/>
			<table>	
				<tr>
					<td class="text-r" width="100px"></td>
					<td width="text-r">
						<span class="red">请确认该合同相关费用已结清！</span>
					</td>
				</tr>
				<tr>		
					<td class="text-r">原始押金:</td>
					<td width="400px"><input class="input w200" id="depositFee"  value="${depositFee/100}" readonly="readonly"/> 元</td>
				</tr>
				<tr>		
					<td class="text-r">应退押金:</td>
					<td ><input class="input w200" id="actualFee"  value="${actualFee/100}" readonly="readonly"/> 元</td>
				</tr>
				<tr>		
					<td class="text-r">实退押金:</td>
					<td ><input class="input w200" id="backDepositFee" name="depositBean.backDepositFee" value="${payedDepositFee/100}" onblur="checkFee(this);" /> 元</td>
				</tr>
				<tr>		
					<td class="text-r">结算日期:</td>
					<td ><input class="input w200" id="settlementDate" name="depositBean.settlementDate" value="${currDate}" onclick="WdatePicker()"/></td>
				</tr>
				<tr>		
					<td class="text-r"><span class="red">*</span>清算人:</td>
					<td >
					<select id="settlementStaffId" name="depositBean.settlementStaffId">
						<s:iterator value="staffList">
							<option value="${id}">${name}</option>
						</s:iterator>
					</select>
					</td>
				</tr>
				<tr> 
					<td class="text-r">清算完成说明:</td>
					<td><textarea id="clearedDesc" style="width:280px;height:100px" name="contract.clearedDesc" /></textarea></td>
				</tr>
		</table>
</div>		
</form>					
</body>
</html>
