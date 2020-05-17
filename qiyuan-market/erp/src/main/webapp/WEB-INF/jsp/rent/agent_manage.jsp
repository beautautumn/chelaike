<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@taglib uri="/struts-tags" prefix="s"%>
<%@ include file="/common/taglibs.jsp"%>
<%@ include file="/common/meta.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>经纪人管理</title>
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

<script>
	var api = frameElement.api, W = api.opener;
	var nameCheck = "";
	var idCardCheck = "";
	var idReg = /^[1-9]\d{5}[1-9]\d{3}((0\d)|(1[0-2]))(([0|1|2]\d)|3[0-1])\d{4}$/;
	var nameReg = /^[\u4E00-\u9FA5A-Za-z0-9_]{1,20}$/;
 
	
	function checkResult(){
		
		var val = $("#agentName").val();
		if(val == null || val == "" || !nameReg.test(val)){
           	alert("经纪人名称格式不正确！");
       		return;
        }
		var val = $("#agentIdCard").val();
		if(val ==null ||  val == "" || !idReg.test(val)){
           		alert("经纪人身份证格式不正确！");
           		return;
        }        
		var data = "";
		data = $("#addAgent").serialize();
		$.ajax({
			cache: false,
			type: "POST",
			url:ctutil.bp()+"/rent/agent_add.action",
			data:data,
			async: false,
			error: function() {
			html = "数据请求失败";
			},
			success: function(data) {
			  if(data=="success"){
				  alert("添加成功！");
				  $("#queryAgent").submit();
			  }else{
				  alert("添加失败！");
			  }
			}
		});
	}
	
	function deleteAgent(id){
		var agencyId = $("#modifyAgencyId").val();
		var data = "agencyId="+agencyId+"&agentId="+id;
		$.ajax({
				cache: false,
				type: "POST",
				url:ctutil.bp()+"/rent/agent_delete.action",
				data:data,
				async: false,
				error: function() {
				html = "数据请求失败";
				},
				success: function(data) {
				  if(data=="success"){
					  alert("删除成功！");
					  $("#queryAgent").submit();
				  }else{
					  alert("删除失败！");
				  }
				}
			});
	}
	
	function updateAgent(input){
		$(input).parent().parent().find("input[id='idCard']").removeAttr("readonly").attr("style", "width:95%");
		$(input).parent().parent().find("input[id='name']").removeAttr("readonly").attr("style", "width:95%");
		$(input).val("完成");
		$(input).attr("onclick","save(this)");
	}
	
	function save(input){
		var id = $(input).parent().parent().find("input[id='id']").val();
		var name = $(input).parent().parent().find("input[id='name']").val();
		if(name==null || name==""){
			alert("经纪人名称不能为空！");
			return;
		}else{
			if(!nameReg.test(name)){
            		alert("经纪人名称不正确！");
            		return;
            }
		}
		var idCard = $(input).parent().parent().find("input[id='idCard']").val();
		if(idCard==null || idCard==""){
			alert("经纪人身份证不能为空！");
			return;
		}else{
			if(!idReg.test(idCard)){
            		alert("经纪人身份证格式不正确！");
            		return;
            }
		}
		var data = "agentId="+id+"&agentName="+name+"&agentIdCard="+idCard;
		$.ajax({
				cache: false,
				type: "POST",
				url:ctutil.bp()+"/rent/agent_singleUpdate.action",
				data:data,
				async: false,
				error: function() {
				html = "数据请求失败";
				},
				success: function(data) {
				  if(data=="success"){
					  alert("修改成功！");
					  $("#queryAgent").submit();
				  }else{
					  alert("修改失败！");
				  }
				}
			});
	}
	
	function do_submit(){
		$("#hiddenDiv").empty();
		var itemIndex = 0;
		var html1 = "";
		var inputList = $("#listAgent").find("input[type!='button']");
		for ( var j = 0; j < inputList.length; j++) {
			if(j % 3 == 0){
				html1 = "<input type='hidden' name='agentList["+itemIndex+"].id' value='"+inputList[j].value+"'/>";
			}
			if(j % 3 == 1){
				if(!nameReg.test(inputList[j].value)){
					alert("经纪人名称格式不正确！");
            		return;
            	}
				html1 = "<input type='hidden' name='agentList["+itemIndex+"].name' value='"+inputList[j].value+"'/>";
			}
			if(j % 3 == 2){
				if(!idReg.test(inputList[j].value)){
					alert("经纪人身份证格式不正确！");
            		return;
            	}
				html1 = "<input type='hidden' name='agentList["+itemIndex+"].idCard' value='"+inputList[j].value+"'/>";
				itemIndex++;
			}
			$("#hiddenDiv").append(html1); 
		}
				var data = "";
				data = $("#modifyAgent").serialize();
				$.ajax({
					cache: false,
					type: "POST",
					url:ctutil.bp()+"/rent/agent_update.action",
					data:data,
					async: false,
					error: function() {
					html = "数据请求失败";
					},
					success: function(data) {
					if(data=="success"){
						alert("修改成功！");
						api.get("manage_agent",1).close();
						  W.query1();
					 }else{
						alert("修改失败！");
						api.get("manage_agent",1).close();
						  W.query1();
					 }
					}
				});
	}
	
</script>

</head>
<body>
	<form action="agent_toManage.action" id="queryAgent" method="post">	
		<div class="box">
			<input type="hidden" class="input w200" name="agencyId" value="${agencyId}"/>
			<table>	
				<tr>
					<td class="text-r" width="100px" >经纪人名称：</td>
					<td><input class="input w150" id="name" name="agentName" value="${agentName}" /></td>
					<td><input type="submit" value="查询" /></td>	
				</tr>
			</table>
		</div>
	</form>
	<form action="agent_toManage.action" id="addAgent" method="post">	
		<div class="box">
			<input type="hidden" name="agencyId" value="${agencyId}"/>
			<table>	
				<tr>
					<td class="text-r" width="100px" ><span class="red">*</span>经纪人名称：</td>
					<td><input class="input w150" id="agentName" name="agent.name" value="${agent.name}" onblur="checkName(this);"/></td>
					<td class="text-r" width="100px" ><span class="red">*</span>身份证号码：</td>
					<td><input class="input w200" id="agentIdCard" name="agent.idCard" value="${agent.idCard}" onblur="checkIdCard(this);"/></td>
					<td><input type="button" value="新增" onclick="checkResult();"/></td>
				</tr>
			</table>
		</div>
	</form>		
	<form action="agent_toManage.action" id="modifyAgent" method="post">
		<div id="hiddenDiv" style="display:none;"></div>
		<input type="hidden" id="modifyAgencyId" value="${agencyId}"/>	
		<div class="box">
			<table style="margin:auto; width:95%;margin-top:15px;" border='1px' frame=box rules=all id="listAgent">
			<tr style="width:500px;">
				<td style="text-align:center;text-valign:center;width:50px;height:35px;"><font size="10px">经纪人名称</font></td>
				<td style="text-align:center;text-valign:center;width:50px;height:35px;"><font size="10px">身份证号码</font></td>
				<td style="text-align:center;text-valign:center;width:50px;height:35px;"><font size="10px">操作</font></td>
			</tr>
			<s:iterator  value="listAgent">
				<tr style="width:500px;">
					<input type="hidden" id="id" value="${id}" />
					<td style="text-align:center;text-valign:center;width:50px;height:35px;">
						<input type="text" style="text-align:center;width: 100%; height: 100%;border:0pt;" id="name" value="${name}" readonly="readonly"  /> 
					</td>
					<td style="text-align:center;text-valign:center;width:50px;height:35px;">
						<input type="text" style="text-align:center;width: 100%; height: 100%;border:0pt;" id="idCard" value="${idCard}" readonly="readonly"  />
					</td>
					<td style="text-align:center;text-valign:center;width:50px;height:35px;">
						<input type="button" value="编辑" onclick="updateAgent(this);" />
						<input type="button" value="删除" onclick="deleteAgent(<s:property value="id"/>);" />
					</td>
				</tr>
			</s:iterator>
		</table>
		</div>
	</form>		
	
</body>
</html>
