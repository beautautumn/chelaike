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
		var data= new Array();
		var areaId=$("#areaId").val();
		if(areaId==0){
			alert("请选择场地区域");
			return;
		}
		else{
		data[0]=areaId;
		}
		var feeValue=$("#feeValue").val();
		if(feeValue==''){
			alert("请填写金额");
			return;
		}
		if(feeValue>100000){
     		alert("填写费用金额过大，请重填");
     		return;
     	}
     	else{
     	data[1]=feeValue;
     	}
		api.get('piLiangJiFei').do_get_addShanghuByArea(data);
		api.get('addShangHuByArea',1).close();
		
//		data="contractId="+$("#contractId").val()
//			+"&recvFeeBean.asOfDate="+asOfDate
//			+"&recvFeeBean.recvFee="+recvFee
//			+"&recvFeeBean.recvDepositFee="+recvDepositFee
//			+"&recvFeeBean.recvDate="+recvDate
//			+"&recvFeeBean.staffId="+staffId
//			+"&recvFeeBean.remark="+remark;
//		$.ajax({
//				cache: false,
//				type: "POST",
//				url:ctutil.bp()+"/rent/contractPaymentAction!doRectFee.action",
//				data:data,
//				async: false,
//				error: function() {
//				html = "数据请求失败";
//				},
//				success: function(data) {
//				  if(data=="success"){
//					  alert("保存成功！");
//					  api.get("rectFeePage", 1).close();
//					  W.query1();  //刷新副页面
//				  }else{
//					  alert("保存失败！");
//					  api.get("rectFeePage", 1).close();
//				  }
//				}
//			});
		
		
	}
</script>

</head>
<body>
<form id="myForm">	
<div >
			<table>	
					<input type="hidden" class="input w200" id="contractId" name="contract.id" value="${contract.id}"/>
				<tr >
					<td class="text-r" width="80px;" height="40px;">场地区域:&nbsp;&nbsp;&nbsp;</td>
					<td width="300">
						<select id="areaId" class="input w200" name="">
								<option value='0'>请选择</option>
							<s:iterator value="siteAreas">
								<option value="<s:property value='id'/>"><s:property value="areaName"/></option>
							</s:iterator>
						</select>
					</td>
				</tr>
				<tr > 
					<td class="text-r" width="80px;" height="30px;" >计费金额: &nbsp;&nbsp;&nbsp;</td>
					<td><input type="text" class="input w200" id="feeValue" name="feeValue" onkeyup="value=value.replace(/[^(\d||/.)]/g,'')"/>&nbsp;&nbsp;元</td>
				</tr>
		</table>		
	
</div>		
</form>					
</body>
</html>
