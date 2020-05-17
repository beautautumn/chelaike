<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@taglib uri="/struts-tags" prefix="s"%>
<%@ include file="/common/taglibs.jsp"%>
<%@ include file="/common/meta.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>车位使用情况</title>
<link rel="stylesheet" type="text/css" href="${ctx}/css/style.css" />
<script type="text/javascript" src="${ctx}/js/common/syUtil.js"></script>
<script type="text/javascript" src="${ctx}/js/common/ctutil.js"></script>
<script type="text/javascript" src="${ctx}/js/common/menu.js"></script>
<script type="text/javascript" src="${ctx}/js/plugins/My97DatePicker/WdatePicker.js"></script>
<script>
 
</script>
</head>
<body>
	<form id="my_form">
	<div id="tab">
		<div class="box">
			<table style="width:800px">	

  				<tr>
  					<td colspan="2">
  						<table style="margin:auto; width:95%;margin-top:15px;" border='1' name="carOperHises" id="carOperHises">
							<tr style="width:780px;">
								<td style="text-align:center;text-valign:center;width:30px;height:35px;"><font size="10px">操作类型</font></td>
								<td style="text-align:center;text-valign:center;width:30px;height:35px;"><font size="10px">操作人</font></td>
								<td style="text-align:center;text-valign:center;width:60px;height:35px;"><font size="50px">操作时间</font></td>
								<td style="text-align:center;text-valign:center;width:50px;height:35px;"><font size="30px">操作前空车位</font></td>
								<td style="text-align:center;text-valign:center;width:50px;height:35px;"><font size="30px">操作后空车位</font></td>
								<td style="text-align:center;text-valign:center;width:100px;height:35px;"><font size="60px">操作说明</font></td>								
							</tr>
							<s:iterator value="carOperHises">
								<tr>
									<td style="text-align:center;text-valign:center;width:10px;height:35px;">
									   <font size="10px">
									      <c:if test="${operTag==0}">入场</c:if>
                        <c:if test="${operTag==1}">离场</c:if>
									      <c:if test="${operTag==2}">手工调整</c:if>
								       </font></td>								
									<td style="text-align:center;text-valign:center;width:10px;height:35px;"><font size="10px">${staff.name}</font></td>
									<td style="text-align:center;text-valign:center;width:50px;height:35px;"><font size="50px"><fmt:formatDate value="${operTime}" type="both" pattern="yyyy.MM.dd hh:mm" /></font></td>
									<td style="text-align:center;text-valign:center;width:50px;height:35px;"><font size="10px">${beforCount}</font></td>
									<td style="text-align:center;text-valign:center;width:50px;height:35px;"><font size="10px">${afterCount}</font></td>
									<td style="text-align:center;text-valign:center;width:100px;height:35px;"><font size="10px">${operDesc}</font></td>
								</tr>
							</s:iterator>
						</table>
  					</td>
  				</tr>
			</table>
		</div>
  	</div>
	</form>
    
</body>
</html>
