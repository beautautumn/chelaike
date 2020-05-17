<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%@include file="/common/taglibs.jsp"%>
<%@include file="/common/meta.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"  "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<title>商户认证</title>
		<meta http-equiv="pragma" content="no-cache" />
		<meta http-equiv="cache-control" content="no-cache" />
		<meta http-equiv="expires" content="0" />
		<meta name="viewport"
			content="width=device-width, user-scalable=no, initial-scale=1">	
        <link href="${ctx}/js/plugins/bootstrap-3.0.3/css/bootstrap.min.css" rel="stylesheet"
			type="text/css">
 		<link rel="stylesheet" type="text/css"
			href="${ctx}/css/auth.css" />
			<script type="text/javascript" src="${ctx}/js/common/jquery.json-2.4.js"></script>
			
	</head> 
  <body> 
   <script type="text/javascript">
 function subForm()
 { 
   
     var tel = $('#tel').val().trim(); 
     var authCode= $('#authorzation_code').val();
     var reg = /^1[3|4|5|7|8|9]\d{9}$/;
     if (tel == '') { 
		   $('#cont_msgTip').html('请输入手机号...');
			setTimeout(function() {
				$('#cont_msgTip').html('&nbsp;').slideDown('slow');
			}, 1200);
			return false;
	  }else if(!reg.test(tel)){
			$('#cont_msgTip').html('请输入有效的手机号码');
		 	setTimeout(function() {
				$('#cont_msgTip').html('&nbsp;').slideDown('slow');
			}, 1200);
			return false;
	  }else if(authCode ==''){
			$('#cont_msgTip').html('请输入授权码');
		 	setTimeout(function() {
				$('#cont_msgTip').html('&nbsp;').slideDown('slow');
			}, 1200);
			return false;
	  }
		 
	     $('#subbtn').attr("disabled", true);
	     $('#cont_msgTip').html('正在提交...');
 

  	   var params = {"tel": tel, "authCode":authCode};
	 	$.post('${ctx}/wx/view!saveAgencyAuth.action',params,function(data){
			var obj=$.evalJSON(data);
			alert(obj.msg);  
				 $('#cont_msgTip').html('&nbsp;').slideDown('slow');
			if(obj.success){
				//跳转地址
				window.location.href = '${ctx}/carin/vehicleInput!toVehicleInputPhone.action';
			}else{
				 $('#subbtn').attr("disabled", false);
			} 
		});
 } 
 
</script>

</head>

<body>
	<div class="menu_header">
		<div class="menu_topbar">
			<strong class="head-title">认证</strong>
		</div>
	</div>
	<form class="form" method="post" name="khForm" id="khForm"
		enctype="multipart/form-data">
		<input name="formhash" id="formhash" value="3fce26a4" type="hidden">
		<input name="insetmb" id="insetmb" value="1" type="hidden">
		<div class="contact-info" style="margin-top:50px;">
			<ul>

				<li>
					<table style="padding: 0; margin: 0; width: 100%;">
						<tbody> 
							<tr> 
							     <td>
									<div class="ui-input-text">
										<input id="authorzation_code" name="authorzation_code" placeholder="请输入授权码" required
											class="ui-input-text" type="text" >
									</div>
								 </td>
								
							</tr> 
							<tr>
							   
									 <td>
										<div class="ui-input-text">
											<input id="tel" name="tel" placeholder="请输入手机号" required
												class="ui-input-text" type="tel" >
										</div>
									 </td>
							</tr>
						</tbody>
					</table>
				</li>
			</ul>
  
		</div>
		<div style="text-align:center"> 
			<span id="cont_msgTip" style="color:#f15b6c;"> &nbsp; </span>
		</div>
		<div class="footReturn">

			<input id="subbtn" class="submit" value="提交" style="width: 100%"
				type="button" onclick="subForm()">
		</div>
	</form>


</body>
 
</html>
