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

function checkType(type){

	if(type==0){
		$("#emailtr").css('display','');
		$("#teltr").css('display','none');
	}
	if(type==1){
		$("#emailtr").css('display','none');
		$("#teltr").css('display','');

	}

}

function do_submit(){
	if($("#loginName").val()==''){
		alert('请填写账号');
		return;
	}

	if($("input[name='findType']").get(0).checked){
		if($("#email").val()==''){
			alert('请填写邮箱');
			return;
		}

	}

	if($("input[name='findType']").get(1).checked){
		if($("#tel").val()==''){
			alert('请填写手机号');
			return;
		}
	}
	if($("#checkCode").val()==''){
		alert('请填写验证码');
		return;
	}
	
	var param=$("#myForm").serialize();
	var dialog_object=api.get("findPwd_dialog",1);
			dialog_object.button({id:'ok',disabled: true});
	$.messager.progress({title:'提示信息',msg:'正在操作中,请稍后'});
	$.post('${ctx}/sys/accountInfo_doFindPwd.action',param,function(data){
		$.messager.progress('close');
		 var obj=$.evalJSON(data);
		 if(obj.code=='0'){
		 	eu.showAlertMsgWithCallback(obj.msg,"info",close_win);
		 }
		 if(obj.code=='1'){
		 	eu.showAlertMsg(obj.msg,"error");		
		 	$("#checkCodeImg").get(0).src='${ctx}/sys/accountInfo_checkcode.action?Math.random()';
		 	dialog_object.button({id:'ok',disabled: false});
		 }
	});
}

function close_win(){
	api.get("findPwd_dialog",1).close();
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
						<input 	name="loginName" id="loginName" class="input w200"/>
					</td>
				</tr>
				<tr>
					<td class="text-r"><span class="red"></span>找回途径:</td>
					<td>
						<input type="radio" name="findType" value="0" onclick="checkType(0);" checked="checked">邮箱
						<input type="radio" name="findType" value="1" onclick="checkType(1);">手机号
					</td>
					<tr id="emailtr">
					<td class="text-r"><span class="red"></span>邮箱:</td>
					<td>
					<input id="email" name="email" class="input w200"/>
					</td>

				</tr>
				</tr>
					<tr id="teltr" style="display:none;">
					<td class="text-r"><span class="red"></span>手机号:</td>
					<td>
					<input id="tel" name="tel" class="input w200"/>
					</td>

				</tr>
				
				<tr>
					<td class="text-r"><span class="red"></span>验证码:</td>
					<td><input  class="input w200" id="checkCode" name="checkCode"/>
						<img src="${ctx}/sys/accountInfo_checkcode.action" id="checkCodeImg" onclick="this.src='${ctx}/sys/accountInfo_checkcode.action?Math.random()';"/>
					</td>
				</tr>
				
				
	</table>
</div>		
</form>					
</body>
</html>
