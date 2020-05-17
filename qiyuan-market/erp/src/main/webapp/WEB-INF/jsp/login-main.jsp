<%@ page import="com.ct.erp.common.utils.GlobalConfigUtil" %>
<%@ page language="java" pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>

<%@ include file="/common/taglibs.jsp"%>
<%--<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">--%>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>启辕·汽车连锁商城管理系统</title>
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

	<%-- north顶部Logo区域 --%>
	<script type="text/javascript">
        //注销
        function logout() {
            menu.create_dialog_identy_logout('logout','确认提示','您确定要退出系统吗？',400,100,true);
            <%--$.messager.confirm('确认提示！', '您确定要退出系统吗？', function(r) {--%>
                <%--if (r) {--%>
                    <%--window.location.href = "${ctx}/login!logout7y.action";--%>
                <%--}--%>
            <%--});--%>
        }
        function do_submit(){
            window.location.href = "${ctx}/login!logout.action";
		}

        function openAccountTab() {
            var title = "个人账号";
            setTab(title,"${ctx}/sys/staff_account.action",title);
            getMenu(title);
            //eu.addTab('layout_center_tabs', "账号信息", "${ctx}/sys/staff_account.action", true, 'undefined');
		}
		function openAnnouncementTab(){
            var title = "公告管理";
            setTab(title,"${ctx}/list/page!toRptIndex.action?viewId=611&rightCode=notice_manager",title);
            getMenu(title);
		}

        function openAboutUs(){
		    var title = '联系我们';
            setTab(title,"${ctx}/contact-us.jsp",title);
            getMenu(title);
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
	<div class="header">
		<div class="logo">
			<img src="/sso/static/img/slogan.png" />
		</div>
        <div class="system-name">车来客市场管理平台</div>
		<div class="header-right">
			<ul class="top-nav">
				<c:forEach  var="rightInList" items="${sessionScope.sessionInfo.sysrightList}">
					<c:if test="${rightInList.rightCode == 'notice_manager'}">
						<c:set var="noticeShow" value="true"></c:set>
					</c:if>
					<c:if test="${rightInList.rightCode == 'user_manage_platform'}">
						<c:set var="accountShow" value="true"></c:set>
					</c:if>
					<c:if test="${rightInList.rightCode == 'contact_us'}">
						<c:set var="usShow" value="true"></c:set>
					</c:if>
				</c:forEach>
				<c:if test="${accountShow}">
					<li onclick="openAccountTab()" class="nav-top-account">
						<img src="/sso/static/img/avatar.png" />
						<span>${sessionScope.sessionInfo.userName}</span>
					</li>
				</c:if>
				<c:if test="${noticeShow}">
					<li onclick="openAnnouncementTab()">
						<p>
							<span>公告</span>
							<span class="nav-top-notice"></span>

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
	<div data-options="region:'center',split:false,href:'${ctx}/fileRedirect.action?toPage=center.jsp'" style="overflow: hidden;z-index: 10;box-sizing: border-box;padding: 80px 10px 10px 10px;background-color: #f5f5f5;">
	</div>

	  <%-- west菜单栏 --%>
	<div data-options="region:'west',title:'${menuText}',split:false,href:'${ctx}/fileRedirect.action?toPage=west.jsp&menuId=<%=menuId%>'" class="menu-yf"
		style="width: 200px;overflow: hidden;padding-top:70px;box-sizing: border-box">
	</div>

	
	<%-- south底部 --%>
	<%--<div data-options="region:'south',border:false,split:false,href:'${ctx}/fileRedirect.action?toPage=south.jsp'"--%>
		<%--style="height: 20px;overflow: hidden;">--%>
	<%--</div>--%>
    <% request.setAttribute("DesktopUrl", GlobalConfigUtil.get("desktopUrl")); %>
    <iframe src="${DesktopUrl}/app_viewer?token=${crmToken}" frameborder="0" style="display: none;"></iframe>
	<%--<iframe src="http://desktop.qiyuan.chelaike.com/app_viewer?token=AutobotsAuth%20eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxLCJzZXR0aW5ncyI6eyJtYWNfYWRkcmVzc19sb2NrIjpmYWxzZSwiZGV2aWNlX251bWJlcl9sb2NrIjpmYWxzZSwiY3Jvc3Nfc2hvcF9yZWFkIjpmYWxzZSwiY3Jvc3Nfc2hvcF9lZGl0IjpmYWxzZSwiY3Jvc3Nfc2hvcF9yZWFkX3N0YXRpc3RpYyI6ZmFsc2V9LCJwYXNzd29yZF9kaWdlc3QiOiIkMmEkMTAkLmU0a2djR2N6aHlNWEFIRjc5Z2FKZXN0bHV1WklqaldGTGNTWWFqeDJnZjExZHFWakw5bS4iLCJhdXRob3JpdGllcyI6Ijk0Y2Y1MjBmMTY0YTMyNGNlZDc4ZjU2NDMyODdmNzg4LXYzLjAuMCIsImNyb3NzX3Nob3BfYXV0aG9yaXRpZXMiOiJkNzUxNzEzOTg4OTg3ZTkzMzE5ODAzNjNlMjQxODljZSJ9.0D_tJ5hUW8NudXjKN9p8mYUnMk96e83W2U39bOT3eiw" frameborder="0" style="display: none;"></iframe>--%>
</body>
</html>