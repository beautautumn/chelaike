<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%@page import="com.ct.erp.lib.entity.Sysmenu"%>
<%@include file="/taglibs.jsp"%>
<table width="100%" cellspacing="0px" class="info-tab">
		            <tr class="first-t">
		              <td class="list-tit" width ="10%">操作人</td>
			          <td class="list-tit" width ="10%">操作时间</td>
			          <td class="list-tit" width ="10%">操作类型</td>
			          <td class="list-tit" width ="70%">操作描述</td>
		            </tr>
		            <c:if test="${not empty operHisList}">
		            	<c:forEach var="his" items="${operHisList}">
		            		<tr align="center">
				              <td class="list-num">${his.staff.staffName}</td>
					          <td class="list-num"><fmt:formatDate value="${his.operTime}" pattern="yyyy-MM-dd HH:mm"/></td>
							  <td class="list-num">
							     ${his.sysright.rightName}
							  </td>
					          <td class="list-num">${his.operDesc }</td>
				            </tr>
		            	</c:forEach>
		            </c:if>
		            
				  </table>
 