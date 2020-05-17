<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
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
<script type="text/javascript">
var api = frameElement.api, W = api.opener;
$(function(){
	

});
function do_submit(){
	
	if($("#oldPwd").val()==''){
		alert('请填写原密码');
		return;
	}
	if($("#newPwd").val()==''){
		alert('请填写新密码');
		return;
	}
	if($("#newPwdAgain").val()==''){
		alert('请确认新密码');
		return;
	}
	if($("#newPwd").val()!=$("#newPwdAgain").val()){
		alert('请确保两次填写的新密码一致');
		return;
	}

	var param=$("#myForm").serialize();
	// var dialog_object=W.get_dialog_instance();
	// dialog_object.button({id:'ok',disabled: true});
	
	$.post('${ctx}/sys/accountInfo_doChangePwd.action',param,function(data){
		var obj=$.evalJSON(data);
		alert(obj.msg);
		if(obj.code==0){
			return;
		} else
		if(obj.code==1){
			api.get("change_pwd_dialog",1).close();
			return;
		}
	});




}

</script>
</head>
<body>
<form id="myForm">	
<div class="box">
		
			<table>				
				<tr>
					
					<td class="text-r" width="100">账号:</td>
					<td width="200">
						${staff.loginName}
					</td>
				</tr>
				<tr>
					<td class="text-r"><span class="red">*</span>原密码:</td>
					<td><input type="password" class="input w200" id="oldPwd" name="oldPwd"/></td>

				</tr>
				<tr>
					<td class="text-r"><span class="red">*</span>新密码:</td>
					<td><input type="password" class="input w200" id="newPwd" name="newPwd"/></td>
				</tr>
				<tr> 
					<td class="text-r"><span class="red">*</span>确认密码:</td>
					<td><input type="password" class="input w200" id="newPwdAgain"/></td>
				</tr>
				
	</table>
</div>		
</form>					
</body>
</html>
