<%@ page language="java" pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ include file="/common/taglibs.jsp"%>
<%--<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">--%>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>启辕·汽车连锁商城市场管理系统</title>
<%@ include file="/common/meta.jsp"%>
	<link rel="stylesheet" type="text/css" href="/sso/static/css/index.css" />
	<link rel="stylesheet" type="text/css" href="/sso/static/css/overui.css" />
	<script type="text/javascript" src="${ctx}/js/common/menu.js"></script>
</head>
<%

        String menuId = request.getParameter("menuId") == null ? (String) request
                .getAttribute("menuId"):request.getParameter("menuId");
%>

<body id="indexLayout" class="easyui-layout" style="height: 100%;width: 100%;overflow-y: hidden;">
	
	<noscript>
		<div style="position: absolute; z-index: 100000; height: 2046px; top: 0px; left: 0px; width: 100%; background: white; text-align: center;">
			<img src="${ctx}/img/noscript.gif" alt='请开启脚本支持!' />
		</div>
	</noscript>
	<script type="text/javascript">

        //注销
        function logout() {
            menu.create_dialog_identy_logout('logout','确认提示','您确定要退出系统吗？',400,100,true);
            <%--$.messager.confirm('确认提示！', '您确定要退出系统吗？', function(r) {--%>
                <%--if (r) {--%>
                    <%--window.location.href = "${ctx}/login!logoutMarket.action";--%>
                <%--}--%>
            <%--});--%>
        }
        function do_submit(){
            window.location.href = "${ctx}/login!logoutMarket.action";
        }
        function editLoginUserPassword(){
            //弹出对话窗口
            menu.create_dialog_identy('change_pwd_dialog','修改密码','/sys/accountInfo_toChangePwd.action',500,150,true);
        }

        function openAccountTab() {
            var title = "个人账号";
            setTab(title,"${ctx}/sys/staff_account.action",title);
            getMenu(title);
            //eu.addTab('layout_center_tabs', "账号信息", "${ctx}/sys/staff_account.action", true, 'undefined');
        }
        function openAnnouncementTab(){
            var title = "公告管理";
            setTab(title,"${ctx}/list/page!toRptIndex.action?viewId=612&rightCode=notice_manager_market",title);
            getMenu(title);
        }

        function openAboutUs(){
            var title = '联系我们';
            setTab(title,"${ctx}/contact-us.jsp",title);
            getMenu(title);
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

	<%-- north顶部Logo区域 --%>
	<%--<div data-options="region:'north',border:false,split:false,href:'${ctx}/login!northMarket.action?menuId=${menuId}'"--%>
		<%--style="height: 90px;overflow: hidden;z-index: 100000;">--%>
	<%--</div>--%>
	<div class="header theme1">
		<div class="logo"></div>
		<%--<div class="title">启辕汽车连锁商城市场管理系统</div>--%>
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
				<%--<li>
					<p>
						<span>消息</span>
						<span class="nav-top-msg"></span>

					</p>
				</li>--%>
				<c:forEach  var="rightInList" items="${sessionScope.sessionInfo.sysrightList}">
					<c:if test="${rightInList.rightCode == 'notice_manager_market'}">
						<c:set var="noticeShow" value="true"></c:set>
					</c:if>
					<c:if test="${rightInList.rightCode == 'user_manage_market'}">
						<c:set var="accountShow" value="true"></c:set>
					</c:if>
					<c:if test="${rightInList.rightCode == 'contact_us'}">
						<c:set var="usShow" value="true"></c:set>
					</c:if>
				</c:forEach>
				<c:if test="${noticeShow}">
					<li onclick="openAnnouncementTab()">
						<p>
							<span>公告</span>
							<span class="nav-top-notice"></span>

						</p>
					</li>
				</c:if>
				<c:if test="${accountShow}">
					<li onclick="openAccountTab()">
						<p>
							<span>账户</span>
							<span class="nav-top-user"></span>

						</p>
					</li>
				</c:if>
				<c:if test="${usShow}">
					<li class="contact-us" onclick="openAboutUs()">
						<p>
							<span>关于我们</span>
							<span class="nav-top-us"></span>
						</p>
					</li>
				</c:if>
				<li onclick="logout()">
					<p>
						<span>退出</span>
						<span class="nav-top-out"></span>
					</p>
				</li>
			</ul>
		</div>
	</div>
	
 
	<%-- center主面板 --%>
	<div data-options="region:'center',split:false,href:'${ctx}/fileRedirect.action?toPage=center.jsp'" style="overflow: hidden;z-index: 10;box-sizing: border-box;padding: 100px 10px 10px 10px;background-color: #f5f5f5;">
	</div>

	  <%-- west菜单栏 --%>
	<div data-options="region:'west',title:'${menuText}',split:false,href:'${ctx}/fileRedirect.action?toPage=west-market.jsp&menuId=<%=menuId%>'"
		style="width: 200px;overflow: hidden;padding-top:90px;box-sizing: border-box;" class="menu-yf">
	</div>

	
	<%-- south底部 --%>
	<%--<div data-options="region:'south',border:false,split:false,href:'${ctx}/fileRedirect.action?toPage=south.jsp'"--%>
		<%--style="height: 20px;overflow: hidden;">--%>
	<%--</div>--%>


</body>
</html>