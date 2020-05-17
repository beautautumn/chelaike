<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@taglib uri="/struts-tags" prefix="s"%>
<%@ include file="/common/taglibs.jsp"%>
<%@ include file="/common/meta.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>入驻合同收款</title>
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
		var asOfDate=$("#asOfDate").val();
		if(asOfDate==''){
			alert("本次收款截止日期   不能为空！");
			return;
		}
		var everyRecvFee=$("#everyRecvFee").val();
		var recvFee=$("#recvFee").val();
		if(recvFee==''){
			alert("本次实收款   不能为空！");
			return;
		}/* else if(recvFee!=everyRecvFee){
			alert("收款金额   必须等于   本次应收款！");
			return;
		} */
		var depositFee=$("#depositFee").val();
		var recvDepositFee=$("#recvDepositFee").val();
		if(recvDepositFee==''){
			alert("本次实收押金   不能为空！");
			return;
		}else if(recvDepositFee-(depositFee/10)<0){
			alert("本次实收押金   必须大于等于   本次应补押金10%！");
			return;
		}
		var recvDate=$("#recvDate").val();
		if(recvDate==''){
			alert("收款日期   不能为空！");
			return;
		}
		var staffId=$("#staffId").val();
		if(staffId==0){
			alert("请选择收款人！");
			return;
		}
		var remark=$("#remark").val();
		if(remark.length>255){
			alert("收款备注   过长！");
			return;
		}
		var cycleId = $("#cycleId").val();
		data="contractId="+$("#contractId").val()
			+"&recvFeeBean.asOfDate="+asOfDate
			+"&recvFeeBean.recvFee="+recvFee
			+"&recvFeeBean.recvDepositFee="+recvDepositFee
			+"&recvFeeBean.recvDate="+recvDate
			+"&recvFeeBean.staffId="+staffId
			+"&recvFeeBean.remark="+remark
			+"&recvFeeBean.cycleId="+cycleId;
		
		$.ajax({
				cache: false,
				type: "POST",
				/* url:ctutil.bp()+"/rent/contractPaymentAction!doRectFee.action", */
				url:ctutil.bp()+"/rent/contractPaymentAction!doRecvFee.action",
				data:data,
				async: false,
				error: function() {
				html = "数据请求失败";
				},
				success: function(data) {
				  if(data=="success"){
					  alert("保存成功！");
					  api.get("rectFeePage", 1).close();
					  W.query1();  //刷新副页面
				  }else{
					  alert("保存失败！");
					  api.get("rectFeePage", 1).close();
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
					<input type="hidden" class="input w200" id="contractId" name="contract.id" value="${contract.id}"/>
					<input type="hidden" id="cycleId" name="recvFeeBean.cycleId" value="${cycleRecvFee.id }" />
				<tr>
					<td class="text-r" width="150px" >本次应收款日期：</td>
					<td><input class="input w200" id="asOfDate" readonly="readonly" name="asOfDate" value="<fmt:formatDate value="${cycleRecvFee.planCollectionDate}" pattern="yyyy-MM-dd"/>"/></td>
				</tr>
				<tr>
					<td class="text-r">应收总额：</td>
					<td><input class="input w200" id="planCollectionFee"  readonly="readonly" style="background-color:#F0F0F0" value="${cycleRecvFee.planCollectionFee/100 }"/>元</td>
				</tr>
				<tr>
					<td class="text-r">商户已交金额：</td>
					<td><input class="input w200"  readonly="readonly" style="background-color:#F0F0F0" value="${cycleRecvFee.recvFee/100 }"/>元</td>
				</tr>
				<tr>
					<td class="text-r">本次应收金额：</td>
					<td><input class="input w200"  readonly="readonly" style="background-color:#F0F0F0" value="${(cycleRecvFee.planCollectionFee-cycleRecvFee.recvFee)/100 }"/>元</td>
				</tr>
				
				<tr> 
					<td class="text-r">商户已缴押金:</td>
					<td><input class="input w200" id="payedDepositFee" style="background-color:#F0F0F0" readonly="readonly" value="${contractBean.payedDepositFee }"/>元</td>
				</tr>
				<tr>
					<td class="text-r">本次应补押金:</td>
					<td><input class="input w200" id="depositFee" style="background-color:#F0F0F0" readonly="readonly" value="${contractBean.payedPatchDepositFee }"/>元	</td>
				</tr>
				<tr> 
					<td class="text-r">本次收款:</td>
					<td><input type="text" class="input w200" id="recvFee" name="recvFeeBean.recvFee" onkeyup="value=value.replace(/[^(\d||/.)]/g,'')"
					/>元</td>
				</tr>
				<tr> 
					<td class="text-r">本次收押金:</td>
					<td><input type="text" class="input w200" id="recvDepositFee" name="recvFeeBean.recvDepositFee" onkeyup="value=value.replace(/[^(\d||/.)]/g,'')" value="0" />元</td>
				</tr>
				<tr> 
					<td class="text-r">收款日期:</td>
					<td><input type="text" class="input w200" id="recvDate" name="recvFeeBean.recvDate" onClick="WdatePicker()" value="${recvDate }"/></td>
				</tr>
				<tr>
					<td class="text-r" width="100">收款人:</td>
					<td width="300">
						<select id="staffId" class="input w200" name="contractBean.staffId">
								<option value='0'>请选择</option>
							<s:iterator value="staffs">
							   <s:if test="id==staffId">
									<option value="<s:property value='id'/>" selected><s:property value="name"/></option>
							   </s:if>
							   <s:else>
							   		<option value="<s:property value='id'/>"><s:property value="name"/></option>
							   </s:else>
							</s:iterator>
						</select>
					</td>
				</tr>
				<tr>
					<td class="text-r">收款备注:</td>
					<td>
						<textarea name="contractBean.remark" id="remark" style="width:300px;height:120px"></textarea>
					</td>
				</tr>
				
		</table>		
	
</div>		
</form>					
</body>
</html>
