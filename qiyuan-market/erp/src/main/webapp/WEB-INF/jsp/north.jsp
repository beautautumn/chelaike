<%@ page language="java" pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ include file="/common/taglibs.jsp"%>
<title>后台管理主界面</title>
<script type="text/javascript" src="${ctx}/js/common/jquery.cycle.all.min.js"></script>
<script type="text/javascript" src="${ctx}/js/common/main.js"></script>
<script type="text/javascript" src="${ctx}/js/common/syUtil.js"></script>
<script type="text/javascript" src="${ctx}/js/common/ctutil.js"></script>
<script type="text/javascript" src="${ctx}/js/common/menu.js"></script>
<!--[if IE 6]>
<script type="text/javascript" src="${ctx}/js/common/png.js"></script>
<script type="text/javascript" src="${ctx}/js/common/pngs.js"></script>
<![endif]-->
<link href="${path}/css/layer.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="${ctx}/js/common/layer.js"></script>
<link rel="stylesheet" type="text/css" href="${ctx}/css/css.css" />
<input type="hidden" name="menuText" id="menuText" value="${menuText}"/>
<%

        String menuId = request.getParameter("menuId") == null ? (String) request
                .getAttribute("menuId"):request.getParameter("menuId");
%>
<%@ include file="top.jsp" %>

<c:if test="${not empty todoLogs}">
<div id="mymessage">
	<div id="mes_close">
		<span class="tips_title">待办事项</span>
		<a id="message_close" title="点击关闭" href="javascript:void(0);"></a>
	</div>
	<div class="list">
		<ul class="new_list">
			<c:forEach var="bean" items="${todoLogs}" varStatus="status" >
				<li class="info">
					<a onclick='javascript:eu.addTab(layout_center_tabs,"${bean.sysmenu.menuText}","${ctx}${bean.sysmenu.url}",true,"undefined")'>
						${bean.todoTitle } 
						${bean.staffByCreateStaff.name}  
						<fmt:formatDate  value="${bean.createTime}"   pattern="MM-dd HH:mm"></fmt:formatDate >
					</a>
				</li>			
			</c:forEach> 
		</ul>	
	</div>
	<div class="index_tips_bottom">
		<a href="javascript:void(0);" 
			onclick=""
			class="get_reward"  >查看更多</a>
		</div>
</div>
</c:if>