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
		var backTime=$("#backTime").val();
		var backDesc=$("#backDesc").val();
		if(backTime==''){
			alert("退回时间   不能为空！");
			return;
		}
		if(backDesc==''){
			alert("退回原因   不能为空！");
			return;
		}else if(backDesc.length>255){
			alert("退回原因   过长！");
			return;
		}
		data="shopContractId="+$("#contractId").val()
			+"&contractBean.backDesc="+backDesc
			+"&contractBean.backTime="+backTime;
		$.ajax({
				cache: false,
				type: "POST",
				url:ctutil.bp()+"/rent/shopContractAction!doContractBack.action",
				data:data,
				async: false,
				error: function() {
				html = "数据请求失败";
				},
				success: function(data) {
				  if(data=="success"){
					  alert("保存成功！");
					  api.get("contractBackPage", 1).close();
					  W.query1();  //刷新副页面
				  }else if(data=="error"){
					  alert("保存失败！");
					  api.get("contractBackPage", 1).close();
				  }else{
					  alert(data);
					  api.get("contractBackPage", 1).close();
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
					<input type="hidden" class="input w200" id="contractId" value="${shopContractId}"/>
				
				<tr> 
					<td class="text-r">退回时间:</td>
					<td><input type="text" class="input w200" id="backTime" onClick="WdatePicker()" value="${recvDate }"/></td>
				</tr>
				<tr>
					<td class="text-r">退回原因:</td>
					<td>
						<textarea id="backDesc" style="width:280px;height:110px"></textarea>
					</td>
				</tr>
		</table>		
	
</div>		
</form>					
</body>
</html>
