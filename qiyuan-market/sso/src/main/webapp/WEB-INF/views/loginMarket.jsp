<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ include file="common/taglibs.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<link rel="stylesheet" type="text/css" href="${path}/static/css/login_market.css">
	<script type="text/javascript" src="${ctx}/static/js/jquery-1.10.2.min.js"></script>
    <script src="${ctx}/static/js/blueimp-md5/1.1.0/md5.min.js"></script>
    <title>启辕·汽车连锁商城市场管理系统-登录</title>
	<script type="text/javascript">
//        window.onload = function(){
//            var userName = localStorage.getItem('marketUser');
//            var passWord = localStorage.getItem('marketPwd');
//            if(userName && passWord){
//                $('#username').val(userName);
//                $('#password').val(passWord);
//            }else{
//                setTimeout(function(){
//                    $('#username').val('');
//                    $('#password').val('');
//                },10);
//            }
//        }
		// 登录
		function login() {
//            if($("#rempwd").is(':checked')){
//                localStorage.setItem('marketUser',$('#username').val());
//                localStorage.setItem('marketPwd',$('#password').val());
//            }else {
//                localStorage.removeItem('marketUser');
//                localStorage.removeItem('marketPwd');
//            }
			var login_linkbutton = $("#login_linkbutton");
			login_linkbutton.attr("disabled","disabled");
			$.ajax({
				url:'${ctx}/loginMarket',
				type:"post",
				data:{username:$("#username").val(),password:md5($("#password").val())},
				success:function(Data){
					if (Data.success){
                        window.location = "/erp/login!mainMarket.action";//操作结果提示
					}else {
					    alert( Data.data.message)
//						$.messager.show({
//			                title: '提示信息',
//			                msg: Data.data.message,
//			                showType: 'show'
//			            });
						login_linkbutton.removeAttr("disabled");
					}
				}
			});
			/* $.post('${ctx}/login',{username:$().val(),password:$().val()}, function(data) {
				if (data.success == success){
					window.location = data.data.obj;//操作结果提示
				}else {
					login_linkbutton.linkbutton({  
					    text:'登录' ,
					    disabled:false
					}); 
					$('#validateCode').val('');
					eu.showMsg(data.data.message);
					//refreshCheckCode();
				}
			}, 'json'); */
		}
	</script>
</head>
<body>

  <div class="login-content">
    <div class="center">
      <div class="left">
        <p class="logo"><img src="${ctx}/static/img/logo_market.png"></p>
        <p class="text"><img src="${ctx}/static/img/yyd-market.png"></p>
      </div>
      <div class="right">
        <p class="login-title"><img src="${ctx}/static/img/title-market.png"></p>
        <p class="login-user"><label><img src="${ctx}/static/img/user.png"/></label><input type="text" name="" placeholder="账号" id="username"></p>
        <p class="login-user"><label><img src="${ctx}/static/img/pwd.png"/></label><input type="password" name="" placeholder="密码" id="password"  onkeydown="if(event.keyCode==13)login()"></p>
        <p class="login-select" style="display:none"><input type="checkbox" name="" id="rempwd"><label>记住密码</label></p>
        <p style="text-align: center;"><span class="login-btn" type="submit" id="login_linkbutton" onclick="login();">登录</span></p>
        <p style="color:#fff;text-align: center;line-height: 50px;margin-top:30px;font-size: 14px;">车来客<sup>®</sup>提供技术支持</p>
      </div>
    </div>
  </div>


</body>
</html>