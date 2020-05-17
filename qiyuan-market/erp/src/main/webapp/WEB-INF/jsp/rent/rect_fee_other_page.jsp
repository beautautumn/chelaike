<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@taglib uri="/struts-tags" prefix="s"%>
<%@ include file="/common/taglibs.jsp"%>
<%@ include file="/common/meta.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>其他费用收取</title>
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
		var otherRecvFee = $("#otherRecvFee").val();
		if(otherRecvFee==0){
			return ;
		}
		var recvFee=$("#recvFee").val();
		if(recvFee==''){
			alert("【实收金额】不能为空！");
			return;
		}else if(parseFloat(recvFee)!=parseFloat(otherRecvFee)){
			alert("【实收金额】必须等于【应收金额】！");
			return;
		}
		
		var staffId=$("#staffId").val();
		if(staffId==0){
			alert("请选择【收款人】！");
			return;
		}
		var remark=$("#remark").val();
		if(remark.length>255){
			alert("【收费说民】过长！");
			return;
		}
		data="contractId="+$("#contractId").val()
			+"&recvFeeBean.recvFee="+recvFee
			+"&recvFeeBean.remark="+remark
			+"&recvFeeBean.staffId="+staffId
		$.ajax({
				cache: false,
				type: "POST",
				url:ctutil.bp()+"/rent/contractPaymentAction!doRectFee.action",
				data:data,
				async: false,
				error: function() {
				html = "数据请求失败";
				},
				success: function(data) {
				  if(data=="success"){
					  alert("保存成功！");
					  api.get("rectFeeOtherPage", 1).close();
					  W.query1();  //刷新副页面
				  }else{
					  alert("保存失败！");
					  api.get("rectFeeOtherPage", 1).close();
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
					<input type="hidden" class="input w200" id="contractId" value="${contractId}"/>
				<tr> 
					<td class="text-r">应收金额:</td>
					<td><input type="text" class="input w200" id="otherRecvFee" style="background-color:#F0F0F0" readonly="readonly"
					<c:if test="${not empty contract.otherRecvFee}">value="${contract.otherRecvFee/100}"</c:if>
					<c:if test="${empty contract.otherRecvFee}">value="0"</c:if>
					/>元</td>
				</tr>
				<tr>
					<td class="text-r">费用说明:</td>
					<td>
						<textarea readonly="readonly" style="background-color:#F0F0F0" style="width:280px;height:60px">${contract.otherFeeDesc}</textarea>
					</td>
				</tr>
				<tr> 
					<td class="text-r">实收金额:</td>
					<td><input type="text" class="input w200" id="recvFee" onkeyup="value=value.replace(/[^(\d||/.)]/g,'')"
					/>元</td>
				</tr>
				<tr>
					<td class="text-r" width="100">收费人:</td>
					<td width="300">
						<select id="staffId" class="input w200">
								<option value='0'>请选择</option>
							<s:iterator value="staffs">
								<option value="<s:property value='id'/>"><s:property value="name"/></option>
							</s:iterator>
						</select>
					</td>
				</tr>
				<tr>
					<td class="text-r">收费说明:</td>
					<td>
						<textarea id="remark" style="width:280px;height:60px"></textarea>
					</td>
				</tr>
		</table>		
	
</div>		
</form>					
</body>
</html>
