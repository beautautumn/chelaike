<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ include file="/common/taglibs.jsp"%>
<%@ include file="/common/meta.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<title>用户登录</title>	
	<link rel="stylesheet" type="text/css" href="css/css.css" />
	<script type="text/javascript">
		var loginForm;
		var login_linkbutton;
		$(function(){
			loginForm = $('#loginForm').form();
			$('#loginName').focus();
			//refreshCheckCode();
		});
//刷新验证码
function refreshCheckCode() { 
	//加上随机时间 防止IE浏览器不请求数据
	var url = '${ctx}/servlet/ValidateCodeServlet?'+ new Date().getTime();
    $('#validateCode_img').attr('src',url); 
}
// 登录
function login() { 
	if(loginForm.form('validate')){
		login_linkbutton = $('#login_linkbutton').linkbutton({  
		    text:'正在登录...' ,
		    disabled:true
		});
		$.post('${ctx}/login!login.action',$.serializeObject(loginForm), function(data) {
			if (data.code ==1){
				window.location = data.obj;//操作结果提示
			}else {
				login_linkbutton.linkbutton({  
				    text:'登录' ,
				    disabled:false
				}); 
				$('#validateCode').val('');
				eu.showMsg(data.msg);
				//refreshCheckCode();
			}
		}, 'json');
	}
}
</script>
</head>
<body>
	
<div id="wrap">

  <div id="header">
    <div class="box">
      <div class="logo"><a href="#"><img src="${ctx}/img/logo.png" /></a></div>
      <div class="clear"></div>
    </div>
  </div>
  
  <div id="mainer">
    <div class="loginmain">
      <div class="box">
        <div class="loginl">
          <ul id="lslider">
            <li><a href="#"><img src="${ctx}/img/loginban1.png" /></a></li>
            <li><a href="#"><img src="${ctx}/img/loginban2.png" /></a></li>
          </ul>
          <div id="lslider-nav"></div>
        </div>
        <div class="loginr">
          <h2>轻松管理库存，从此开始！</h2>
          <div class="loginform">
            <ul>
              <li><span>帐号：</span><input name="" type="text" class="input1" /></li>
              <li><span>密码：</span><input name="" type="password" class="input2" /></li>
              <li><span>&nbsp;</span><a href="#">忘记密码？</a></li>
              <li><span>&nbsp;</span><input name="" type="submit" class="btn" value="登 录" /></li>
              <div class="clear"></div>
            </ul>
          </div>
        </div>
        <div class="clear"></div>
      </div>
    </div>
    <div class="clear"></div>
  </div>
  <div id="footer">
    <div class="box">
      <div class="copy">Copyright@ 2011-2014 Inc. All Rights Reserved. 苏ICP备11051678号-3</div>
    </div>
  </div>
</div>

</body>
</html>
