<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ include file="/common/taglibs.jsp"%>
<%@ include file="/common/meta.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>申请注册</title>
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

			$(function () {          
            
                                                                            
            });

//2014-04-15
function checkAccount(){
	if($("#adminAccount").val()!=''){
		$.ajax({
					url:'${ctx}/sys/accountInfo_checkAccount.action',
					type:'post',
					data:{'adminAccount':$("#adminAccount").val()},
					success:function(data){
							if(data=="0"){
								$("#checkResult").html("√");
							}
							if(data=="1"){
								$("#checkResult").html("该账号已经被注册");
							}
					},
					async:false
				});

	}
	

}



function do_submit(){
	//2014-04-15
	var canSubmit=0;
	if($("#adminAccount").val()!=''){
		$.ajax({
					url:'${ctx}/sys/accountInfo_checkAccount.action',
					type:'post',
					data:{'adminAccount':$("#adminAccount").val()},
					success:function(data){
							if(data=="0"){
								$("#checkResult").html("√");
							}
							if(data=="1"){
								$("#checkResult").html("该账号已经被注册");
								canSubmit=1;
								alert("该用户名已经被注册");
							}
					},
					async:false
				});

	}
	if(canSubmit==1){
		return;
	}
	
	if($("#city").val()==null || $("#city").val()==""){
		eu.showAlertMsg("请选择所属地区", "warning");
		return;
	}
	if($("#corpName").val()==''){
		eu.showAlertMsg("请填写企业名称", "warning");
		$("#corpName").focus();
		return;
	}
	if($("#contactName").val()==''){
		eu.showAlertMsg("请填写联系人", "warning");
		$("#contactName").focus();
		return;
	}
	if($("#contactTel").val()==''){
		eu.showAlertMsg("请填写联系电话", "warning");
		$("#contactTel").focus();
		return;
	}
	//2014-04-14
	if($("#adminAccount").val()==''){
		eu.showAlertMsg("请填写管理员账号", "warning");
		$("#adminAccount").focus();
		return;
	}
	if($("#adminPwd").val()==''){
		eu.showAlertMsg("请填写管理员密码", "warning");
		$("#adminPwd").focus();
		return;
	}
	if($("#adminPwd2").val()==''){
		eu.showAlertMsg("请确认管理员密码", "warning");
		$("#adminPwd2").focus();
		return;
	}
	if($("#adminPwd").val()!=$("#adminPwd2").val()){
		eu.showAlertMsg("两次输入密码不一致", "warning");
		$("#adminPwd2").focus();
		return;
	}

	var param=$("#myForm").serialize();
	var dialog_object=W.get_dialog_instance();
dialog_object.button({id:'ok',disabled: true});
	$.post('${ctx}/sys/accountInfo_doRegist.action',param,function(data){
		if(data=='0000'){
			eu.showAlertMsgWithCallback('操作成功',"info",close_win);
		}else{
			eu.showAlertMsg('操作异常',"error");			
			dialog_object.button({id:'ok',disabled:false});
			return;
		}
	});

}

function close_win(){
	api.get("regist_dialog",1).close();
}
</script>
</head>
<body>
<form id="myForm">	
<div class="box">
		
			<table>				
				<tr>
					
					<td class="text-r" width="100"><span class="red">*</span>所属地区:</td>
					<td width="300">
						<select id="province" style="width:100px;" name="provinceCode"></select>
                        <select id="city"  style="width:100px;"  name="regionCode">
                        </select>  
					</td>
				</tr>
				<tr>
					<td class="text-r"><span class="red">*</span>企业名称:</td>
					<td><input class="input w200" id="corpName" name="corpName"/></td>

				</tr>
				<tr>
					<td class="text-r"><span class="red">*</span>联系人:</td>
					<td><input class="input w200" id="contactName" name="contactName"/></td>
				</tr>
				<tr> 
					<td class="text-r"><span class="red">*</span>联系电话:</td>
					<td><input class="input w200" id="contactTel" name="contactTel"/></td>
				</tr>
				<!-- //2014-04-15 -->
				<tr>
					<td class="text-r"><span class="red">*</span>管理员账号:</td>
					<td><input class="input w200" id="adminAccount" name="adminAccount" onblur="checkAccount();"/>
						<span class="red" id="checkResult"></span>
					</td>
				</tr>
				<tr> 
					<td class="text-r"><span class="red">*</span>管理员密码:</td>
					<td><input type="password" class="input w200" id="adminPwd" name="adminPwd"/></td>
				</tr>
				<tr> 
					<td class="text-r"><span class="red">*</span>确认密码:</td>
					<td><input type="password" class="input w200" id="adminPwd2" name="adminPwd2"/></td>
				</tr>
				<tr>
					<td class="text-r">其他说明:</td>
					<td>
						<textarea name="otherDesc" class="area" style="width:350px;"></textarea>

					</td>
				</tr>
		</table>		
	
</div>		
</form>					
</body>
</html>
