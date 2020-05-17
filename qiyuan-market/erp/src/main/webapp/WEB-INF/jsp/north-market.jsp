<%@ page language="java" pageEncoding="UTF-8" contentType="text/html; charset=UTF-8"%>
<%--<script type="text/javascript" src="${ctx}/js/common/ctutil.js"></script>--%>
<script type="text/javascript" src="${ctx}/js/common/menu.js"></script>
<script type="text/javascript">

    //注销
    function logout() {
        $.messager.confirm('确认提示！', '您确定要退出系统吗？', function(r) {
            if (r) {
                window.location.href = "${ctx}/login!logout7y.action";
            }
        });
    }
    function editLoginUserPassword(){
        //弹出对话窗口
        menu.create_dialog_identy('change_pwd_dialog','修改密码','/sys/accountInfo_toChangePwd.action',500,150,true);
    }


    function create_dialog(title,url){
        //menu.create_model_max_dialog_identy("id",title,url);
        window.location.href='${ctx}'+url;
    }

    function change_first_level_menu(url,obj){
        var click_text=obj.getAttribute("text");
        //console.log(click_text);
        //$(".t").text(click_text);
        window.location.href=url;
    }
</script>
<div class="header theme1">
	<div class="logo">LOGO</div>
	<div class="title">启辕•二手车交易市场管理平台</div>
	<div class="header-right">
		<div class="top-bar">
			<span style="color:#989898;margin-right:20px;">您好，${sessionScope.sessionInfo.userName}</span>
			<div class="attention">
				<span>关注启辕</span>
				<div class="erweima">
					<img src="/sso/static/img/erweima.png">
					<p>扫一扫，即刻关注！</p>
				</div>
			</div>
		</div>
		<ul class="top-nav">
			<li>
				<p>
					<span>消息</span>
					<span class="nav-top-msg"></span>

				</p>
			</li>
			<li>
				<p>
					<span>公告</span>
					<span class="nav-top-notice"></span>

				</p>
			</li>
			<li>
				<p>
					<span>账户</span>
					<span class="nav-top-user"></span>

				</p>
			</li>
			<li class="contact-us">
				<p>
					<span>关于我们</span>
					<span class="nav-top-us"></span>

				</p>
			</li>
			<li onclick="logout()">
				<p>
					<span>退出</span>
					<span class="nav-top-out"></span>
				</p>
			</li>
		</ul>
	</div>
</div>