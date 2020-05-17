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
		var data = new Array();
		var agencyId=$("#agencyId").val();
		if(agencyId==0){
			alert("请选择场地区域");
			return;
		}else{
		data[0]=agencyId;
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
     	var remark=$("#remark").val();
     	 if(remark.length>200){
		 alert("备注不得查过200字,请重新填写");  
		 return;   
     	}else{
     	data[2]=remark;
     	}
     	api.get('piLiangJiFei').do_get_agencybill(data);
     	api.get("addShangHu",1).close();

		
	}
</script>

</head>
<body>
<form id="myForm">	
<div >
			<table>	
					<input type="hidden" class="input w200" id="contractId" name="contract.id" value="${contract.id}"/>
				<tr >
					<td class="text-r" width="80px;" height="30px;">商户名称:&nbsp;&nbsp;&nbsp;</td>
					<td width="300">
						<select id="agencyId" class="input w200" name="agencyId">
								<option value='0'>请选择</option>
							<s:iterator value="agencys">
								<option value="<s:property value='id'/>,<s:property value="agencyName"/>"><s:property value="agencyName"/></option>
							</s:iterator>
						</select>
					</td>
				</tr>
				<tr > 
					<td class="text-r" width="80px;" height="30px;" >计费金额: &nbsp;&nbsp;&nbsp;</td>
					<td><input type="text" class="input w200" id="feeValue" name="feeValue" onkeyup="value=value.replace(/[^(\d||/.)]/g,'')" />&nbsp;&nbsp;元</td>
				</tr>
				
				<tr height="100px;">
					<td class="text-r" width="80px;" height="100px;" valign="top">收款备注:&nbsp;&nbsp;&nbsp;</td>
					<td>
						<textarea name="remark" id="remark" style="width:350px;height:100px" ></textarea>
					</td>
				</tr>
				
		</table>		
	
</div>		
</form>					
</body>
</html>
