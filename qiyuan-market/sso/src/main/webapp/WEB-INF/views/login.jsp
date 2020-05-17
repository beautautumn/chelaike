<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ include file="common/taglibs.jsp"%>
<%--<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">--%>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
  <link rel="stylesheet" type="text/css" href="${path}/static/css/login.css">
    <script type="text/javascript" src="${ctx}/static/js/jquery-1.10.2.min.js"></script>
    <script type="text/javascript" src="${ctx}/static/easyui/plugins/jquery.messager.js"></script>
  <script src="${ctx}/static/js/blueimp-md5/1.1.0/md5.min.js"></script>
    <title>车来客市场管理平台</title>
	<script type="text/javascript">
		// 登录
		function login() {
			var login_linkbutton = $("#login_linkbutton");
			login_linkbutton.attr("disabled","disabled");
			$.ajax({
				url:'${ctx}/login',
				type:"post",
				data:{username:$("#username").val(),password:md5($("#password").val())},
				success:function(Data){
					if (Data.success){
						window.location = "/erp/login!main.action";//操作结果提示
					}else {
					    alert(Data.data.message);
						login_linkbutton.removeAttr("disabled");
					}
				}
			});
		}
	</script>
</head>
<body>
<div class="login-content">
  <div class="center">
    <div class="right">
      <p class="login-brand"><img src="${ctx}/static/img/brand.png"></p>
      <p class="login-title"><img src="${ctx}/static/img/title.png"></p>
      <p class="login-note">登录/Sing In</p>
      <p class="login-user"><input type="text" id="username" name="" placeholder="用户名"></p>
      <p class="login-user"><input type="password" id="password" name="" placeholder="密码" onkeydown="if(event.keyCode==13)login()"></p>
      <p class="login-select" style="display: none;"><input type="checkbox" name="rempwd" id="rempwd" ><label>记住密码</label></p>
      <p><span class="login-btn" type="submit" id="login_linkbutton" onclick="login();">登录</span></p>
      <p><a class="register-new" href="http://market-crm.chelaike.com/signup">新用户注册</a></p>
    </div>
  </div>
</div>
</body>
</html>