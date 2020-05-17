<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@taglib uri="/struts-tags" prefix="s"%>
<%@ include file="/common/taglibs.jsp"%>
<%@ include file="/common/meta.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>修改密码</title>
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
<link rel="stylesheet" type="text/css" href="${ctx}/js/plugins/jquery/uploadifive/uploadifive.css"/>
<script src="${ctx}/js/plugins/jquery/uploadifive/jquery.uploadifive.js"></script> 
<style type="text/css">
.message_box{ width:300px;height:120px;overflow:hidden;}
.message_box_t{ width:25px; padding-left:275px; background:url(../img/message_box_top.png); height:20px; padding-top:10px;}
.message_box_m{ width:280px; padding:10px; background:url(../img/message_box_body.png);text-align:left; line-height:35px; font-size:14px;}
.message_box_b{ width:300px; background:url(../img/message_box_bottom.png); height:30px;}
</style>
<script>
	var api = frameElement.api, W = api.opener;
	function checkPwd(pwd){
		var val = $(pwd).val();
		var val1 = $("#confPwd").val();
		if(val == null || val == ""){
			$(".pwd1error").html("密码不能为空").show();
			return;
		}else if(val != val1){
			$(".pwd1error").html("两次输入密码不一致，请重新输入").show();
			return;
		}else{
			$(".pwd1error").html("").hide();
			$(".pwd2error").html("").hide();
		}
	}
	
	function checkConfPwd(pwd){
		var val = $(pwd).val();
		var val1 = $("#pwd").val();
		if(val == null || val == ""){
			$(".pwd2error").html("密码不能为空").show();
			return;
		}else if(val != val1){
			$(".pwd2error").html("两次输入密码不一致，请重新输入").show();
			return;
		}else{
			$(".pwd1error").html("").hide();
			$(".pwd2error").html("").hide();
		}
	}

	
	function do_submit(){
		var str1 = $(".pwd1error").html();
		var str2 = $(".pwd2error").html();
		if(str1!="" || str2!=""){
			alert("表单填写不正确！");
			return;
		}
		var data = $("#myForm").serialize();
		ajaxPost(data);
	}
	
	function ajaxPost(data){
		$.ajax({
				cache: false,
				type: "POST",
				url:ctutil.bp()+"/rent/agency_doChgPwd.action",
				data:data,
				async: false,
				error: function() {
				html = "数据请求失败";
				},
				success: function(data) {
				  if(data=="success"){
					  alert("保存成功！");
					  api.get("chg_pwd",1).close();
					  W.query1();  
				  }else{
					  alert("保存失败！");
					  api.get("chg_pwd",1).close();
					  W.query1();
				  }
				}
			});
	}
</script>

</head>
<body>
<form id="myForm">	
<div class="box">
	<input type="hidden" class="input w200" name="agencyId" value="${agency.id}"/>
			<table>	
				<tr>
					<td class="text-r" width="80px" ><span class="red">*</span>密码：</td>
					<td width="400px"><input class="input w200" type="password" id="pwd" name="agency.pwd" value="" onblur="checkPwd(this);"/><font class="pwd1error" color="red" style="display:none;">密码不能为空</font></td>
				</tr>
				<tr>
					<td class="text-r" width="80px" ><span class="red">*</span>确认密码：</td>
					<td width="400px"><input class="input w200" type="password" id="confPwd" name="confPwd" value="" onblur="checkConfPwd(this);"/><font class="pwd2error" color="red" style="display:none;">密码不能为空</font></td>
				</tr>
			</table>
</div>	
</body>
</html>
