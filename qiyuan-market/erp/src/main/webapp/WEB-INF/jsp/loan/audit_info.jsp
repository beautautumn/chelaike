<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"
	language="java"%>
<%@taglib uri="/struts-tags" prefix="s"%>
<%@ include file="/common/taglibs.jsp"%>
<%@ include file="/common/meta.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
		<title>车辆信息修改</title>
		<link rel="stylesheet" type="text/css" href="${ctx}/css/style.css" />
		<script type="text/javascript" src="${ctx}/js/common/syUtil.js"></script>
		<script type="text/javascript" src="${ctx}/js/common/ctutil.js"></script>
		<script type="text/javascript" src="${ctx}/js/common/jquery.json-2.4.js"></script>
		<script type="text/javascript" src="${ctx}/js/plugins/jquery/jquery.js"></script>
		<script type="text/javascript" src="${ctx}/js/plugins/bootstrap-3.0.3/js/bootstrap.min.js"></script>
		<script type="text/javascript" src="${ctx}/js/plugins/jstree/_lib/jquery.cookie.js"></script>
		<script type="text/javascript" src="${ctx}/js/plugins/jstree/_lib/jquery.hotkeys.js"></script>
		
		<link rel="stylesheet" type="text/css" 	href="${ctx}/js/plugins/jquery/uploadifive/uploadifive.css" />
   	<link rel="stylesheet" type="text/css" href="${ctx}/js/plugins/jquery-easyui/themes/default/easyui.css" />
	  <link rel="stylesheet" type="text/css" href="${ctx}/js/plugins/jquery-easyui/themes/icon.css" />
	  <link rel="stylesheet" type="text/css" href="${ctx}/js/plugins/jquery-easyui/demo/demo.css" />
	  
	  <script type="text/javascript" src="${ctx}/js/plugins/jquery-easyui/jquery-1.6.min.js"></script>
	  <script type="text/javascript" src="${ctx}/js/plugins/jquery-easyui/jquery.easyui.min.js"></script>



<script type="text/javascript">
               
	var api = frameElement.api, W = api.opener;
	function do_submit(){	
		var data = $("#myForm").serialize();		
		ajaxPost(data);
	}
	
	function ajaxPost(data2){
	  var url1 =ctutil.bp()+"/loan/loanEval!doAuditInfo.action";
	  $.ajax({
			cache: false,
			type: "POST",
			url:url1,
			data:data2,
			async: false,
			error: function() {
			  html = "数据请求失败";
			},
			success: function(data) {
			  if(data=="success"){
				  alert("保存成功！");
				  api.get("auditInfo",1).close();
				  W.query1();  
			  }else if(data=="again"){
				  alert("您已审核！");
			  }else{
				  alert("保存失败,请重试！");
			  }
			}
		});
	}              
               
</script>

</head>
<body>
		<form id="myForm">
			<input type='hidden' id="tradeId" name="tradeId" value="${trade.id}" />
			<div class="box">
				<table>
					<tr>
						<td class="text-r" width="100px" id="areaTotal">
							商户名称:
						</td>
						<td width="100px">
							${trade.agency.agencyName}
						</td>
						<td class="text-r"  width="100px">
							条码编号:
						</td>
						<td width="200px" >
							${trade.barCode}
						</td>
					</tr>
					<tr>
						<td class="text-r" width="100px" id="areaTotal">
							品牌:
						</td>
						<td>
							${trade.vehicle.brand.name }
						</td>
						<td class="text-r"  width="100px">
							车系:
						</td>
						<td width="200px"  >
							${trade.vehicle.series.name }
						</td>		
					</tr>
          			<tr>
						<td class="text-r"  width="100px">
							车型:
						</td>
						<td width="200px" >
							${trade.vehicle.kind.name }
						</td>				 
						<td class="text-r"  width="100px">
							发动机号:
						</td>
						<td width="200px" >
							${trade.vehicle.engineNumber}
						</td>							
					</tr>
					<tr>
						<td class="text-r"  width="100px">
							车架号:
						</td>
						<td width="200px"  >
							${trade.vehicle.shelfCode}
						</td>		
						<td class="text-r"  width="100px">
							车牌号:
						</td>
						<td width="200px" >
							${trade.oldLicenseCode}
						</td>								
					</tr>
					
					<tr>
					   <td class="text-r" width="180">审核结果:</td>
		               <td colspan="3">
		               		<font color="red">通过审核</font>
		                   <!-- <input name="checkOut.checkResult" type="radio" value="0" checked="checked"/>通过
		                   &nbsp;&nbsp;
		                   <input name="checkOut.checkResult" type="radio" value="1" />未通过 -->
		               </td>
					</tr>
					<tr>
					   <td class="text-r" width="180">审核备注:</td>
		               <td colspan="3">
		                   <textarea name="checkOut.resultDesc" id="resultDesc" style="width:500px" class="pz-area">${checkOut.resultDesc}</textarea>
		               </td>
					</tr>
				</table>
			</div>
		</form>
	</body>
</html>
