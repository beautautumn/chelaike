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


<style>
	.hidden{display:none;}
</style>
<script type="text/javascript">
 	 var api = frameElement.api, W = api.opener;
 	 $(document).ready(function(){
 		$("input[name='leaveType']").click(function(){
 			var val = $(this).val();
 			if(val=='0'){
 				$(".hidden").hide();
 				$("#leaveDays").val("");
 				$("#leaveDate").val("");
 			}else{
 				$(".hidden").show();
 			}
 		});
 	 });

	function do_submit()
	{
		var type = $("input:checked[name='leaveType']").val();
		var days = $("#leaveDays").val();
		var date = $("#leaveDate").val();
		var desc = $("#approveDesc").val();
		if(type!="0"){
			if(days==""){
				alert("请输入出场天数！");
				return;
			}
			if(date==""){
				alert("请选择出场日期！");
				return;
			}
		}
		if(desc==""){
			alert("请输入审批说明！");
			return;
		}
		var url1 =ctutil.bp()+"/carin/vehicleInput!doAuditVehicle.action";
	  	$.ajax({
				cache: false,
				type: "POST",
				url:url1,
				data:{approveDesc:desc,tradeId:$("#tradeId").val(),leaveType:type,leaveDays:days,leaveDate:date},
				async: false,
				error: function() {
				  html = "数据请求失败";
				},
				success: function(data) {
				  if(data=="success"){
					  alert("保存成功！");
					  api.get("auditVehicle",1).close();
					  W.query1();  
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
		  <input type='hidden' id="tradeId" name="trade.id"  value="${tradeId}"/>		
			<div class="box">
				<table>
					<tr>
						<td class="text-r" width="100px" id="areaTotal">
							<font color="red">*</font>出场类型:
						</td>
						<td colspan="5">
							<input type="radio" value="0" name="leaveType" checked="checked"/><label>交易离场</label>
							<input type="radio" value="1" name="leaveType"/><label>试驾</label>
							<input type="radio" value="2" name="leaveType"/><label>维修</label>
							<input type="radio" value="3" name="leaveType"/><label>美容</label>
							<input type="radio" value="9" name="leaveType"/><label>其它</label>
						</td>
					</tr>
					<tr class="hidden">
						<td class="text-r"  width="100px">
							<font color="red">*</font>出场天数:
						</td>
						<td width="200px" colspan="5">
							<input class="input w200" id="leaveDays" name="leaveDays"/>
						</td>
					</tr>
          			<tr class="hidden">
						<td class="text-r"  width="100px">
							出场日期:
						</td>
						<td width="200px" colspan="5">
							<input class="date w200 easyui-validatebox" id="leaveDate" name="leaveDate" onclick="WdatePicker({lang:'zh-cn'});"
							data-options="required:true,missingMessage:'请选择出场日期',validType:['minLength[1]']"/>
						</td>
					</tr>	
					<tr>
						<td class="text-r" width="180"><font color="red">*</font>审批说明:</td>
			            <td colspan="5">
			                <textarea  id="approveDesc" style="width:500px;height:150px;" class="pz-area"></textarea>
			            </td>
					</tr>
				</table>
			</div>
		</form>
	</body>
</html>
