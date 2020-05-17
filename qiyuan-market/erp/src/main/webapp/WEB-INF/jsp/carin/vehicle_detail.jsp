<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"
	language="java"%>
<%@taglib uri="/struts-tags" prefix="s"%>
<%@ include file="/common/taglibs.jsp"%>
<%@ include file="/common/meta.jsp"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<!-- <meta name="viewport"
	content="width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no"> -->
<meta name="viewport" content="width=device-width, initial-scale=1.0, minimum-scale=0.5, maximum-scale=2.0, user-scalable=yes" />
<meta name="apple-mobile-web-app-capable" content="yes" />
<meta name="apple-mobile-web-app-status-bar-style" content="black" />
<meta name="format-detection" content="telephone=no" />
<title>车辆信息修改</title>
<link rel="stylesheet" type="text/css" href="${ctx}/css/style.css" />
<script type="text/javascript" src="${ctx}/js/common/syUtil.js"></script>
<script type="text/javascript" src="${ctx}/js/common/ctutil.js"></script>
<script type="text/javascript" src="${ctx}/js/common/jquery.json-2.4.js"></script>
<script type="text/javascript" src="${ctx}/js/plugins/jquery/jquery.js"></script>
<script type="text/javascript"
	src="${ctx}/js/plugins/bootstrap-3.0.3/js/bootstrap.min.js"></script>
<script type="text/javascript"
	src="${ctx}/js/plugins/jstree/_lib/jquery.cookie.js"></script>
<script type="text/javascript"
	src="${ctx}/js/plugins/jstree/_lib/jquery.hotkeys.js"></script>

<link rel="stylesheet" type="text/css"
	href="${ctx}/js/plugins/jquery/uploadifive/uploadifive.css" />
<link rel="stylesheet" type="text/css"
	href="${ctx}/js/plugins/jquery-easyui/themes/default/easyui.css" />
<link rel="stylesheet" type="text/css"
	href="${ctx}/js/plugins/jquery-easyui/themes/icon.css" />
<link rel="stylesheet" type="text/css"
	href="${ctx}/js/plugins/jquery-easyui/demo/demo.css" />

<script type="text/javascript"
	src="${ctx}/js/plugins/jquery-easyui/jquery-1.6.min.js"></script>
<script type="text/javascript"
	src="${ctx}/js/plugins/jquery-easyui/jquery.easyui.min.js"></script>




</head>
<body>
	<form id="myForm">
		<input type='hidden' id="vehicle.id" name="vehicle.id"
			value="${vehicle.id}" /> <input type='hidden' id="trade.id"
			name="trade.id" value="${trade.id}" /> <input type='hidden'
			id="brandName" name="vehicle.brandName" /> <input type='hidden'
			id="seriesName" name="vehicle.seriesName" /> <input type='hidden'
			id="kindName" name="vehicle.kindName" />
		<div class="box">
			<table>
				<tr>
					<td width="15%" class="text-r" id="areaTotal">商户名称:</td>
					<td width="30%"><span>${trade.agency.agencyName}</span></td>
				</tr>
				<tr>
					<td class="text-r" width="15%">条码编号:</td>
					<td width="30%"><span>${trade.barCode}</span></td>
				</tr>
				<tr>
					<td class="text-r" width="15%">寄卖车辆:</td>
					<td width="40%"><span><c:choose>
							<c:when test="${trade.consignTag=='0' }">是</c:when>
							<c:otherwise>否</c:otherwise>
						</c:choose></span></td>
				</tr>
				<tr>
					<td class="text-r" width="15%" id="feeMeter">品牌:</td>
					<td width="40%"><span>${vehicle.brand.name }</span></td>
				</tr>
				<tr>
					<td class="text-r" width="15%" id="feeMeter">车系:</td>
					<td width="40%"><span>${vehicle.series.name }</span></td>
				</tr>
				<tr>
					<td class="text-r" width="15%" id="feeMeter">车型:</td>
					<td width="40%"><span>${vehicle.kind.name }</span></td>
				</tr>
				<tr>
					<td class="text-r" width="15%">车架号:</td>
					<td width="40%"><span>${vehicle.shelfCode}</span></td>
				</tr>
				<tr>
					<td class="text-r" width="15%">车牌号:</td>
					<td width="40%"><span>${trade.oldLicenseCode}</span></td>
				</tr>
				<tr>
					<td class="text-r" width="15%">发动机号:</td>
					<td width="40%"><span>${vehicle.engineNumber}</span></td>
				</tr>
				<tr>
					<td class="text-r" width="15%">公里数:</td>
					<td width="40%"><span>${vehicle.mileageCount}</span>公里</td>
				</tr>
				<tr>
					<td class="text-r" width="15%">排量:</td>
					<td width="40%">
						<span>${vehicle.outputVolume }</span>
						<c:choose>
							<c:when test="${vehicle.outputVolumeU=='1' }">T</c:when>
							<c:otherwise>L</c:otherwise>
						</c:choose>
					</td>
				</tr>
				<tr>
					<td class="text-r" width="15%">首次上牌:</td>
					<td width="40%"><span>${vehicle.registMonth}</span></td>
				</tr>
				<tr>
					<td class="text-r" width="15%">车身颜色:</td>
					<td width="40%"><span>${vehicle.carColor }</span></td>
				</tr>
				<tr>
					<td class="text-r" width="15%">内饰颜色:</td>
					<td width="40%"><span>${vehicle.upholsteryColor }</span></td>
				</tr>
				<tr>
					<td class="text-r" width="15%">变速箱:</td>
					<td width="40%"><span><c:choose>
							<c:when test="${vehicle.gearType=='0' }">手动</c:when>
							<c:when test="${vehicle.gearType=='1' }">自动</c:when>
							<c:when test="${vehicle.gearType=='2' }">手自一体</c:when>
							<c:when test="${vehicle.gearType=='3' }">其他</c:when>
						</c:choose></span></td>
				</tr>
				<tr>
					<td class="text-r" width="15%">环保标准:</td>
					<td width="40%"><span><c:choose>
							<c:when test="${vehicle.envLevel=='0' }">国1</c:when>
							<c:when test="${vehicle.envLevel=='1' }">国2</c:when>
							<c:when test="${vehicle.envLevel=='2' }">国3</c:when>
							<c:when test="${vehicle.envLevel=='3' }">国4</c:when>
							<c:when test="${vehicle.envLevel=='4' }">国5</c:when>
						</c:choose></span></td>
				</tr>
				<tr>
					<td class="text-r" width="15%">出厂日期:</td>
					<td width="40%"><span><fmt:formatDate value="${vehicle.factoryDate}"
							pattern="yyyy-MM-dd"/></span></td>
				</tr>
				<tr>
					<td class="text-r" width="15%">车身类型:</td>
					<td width="40%"><span><c:choose>
							<c:when test="${vehicle.vehicleType=='0' }">轿车</c:when>
							<c:when test="${vehicle.vehicleType=='1' }">跑车</c:when>
							<c:when test="${vehicle.vehicleType=='2' }">越野车</c:when>
							<c:when test="${vehicle.vehicleType=='3' }">商务车</c:when>
						</c:choose></span></td>
				</tr>
				<tr>
					<td class="text-r" width="15%">交强险:</td>
					<td width="40%"><span>${vehicle.issurValidDate}</span></td>
				</tr>
				<tr>
					<td class="text-r" width="15%">年审到期:</td>
					<td width="40%"><span>${vehicle.checkValidMonth}</span></td>
				</tr>
				<tr>
					<td class="text-r" width="15%">商业险日期:</td>
					<td width="40%"><span>${vehicle.commIssurValidDate}</span></td>
				</tr>
				<tr>
					<td class="text-r" width="15%">使用性质:</td>
					<td width="40%"><span><c:choose>
							<c:when test="${vehicle.usedType=='0' }">非运营</c:when>
							<c:when test="${vehicle.usedType=='1' }">运营</c:when>
							<c:when test="${vehicle.usedType=='2' }">营转非</c:when>
						</c:choose></span></td>
				</tr>
				<tr>
					<td class="text-r" width="15%">新车价格:</td>
					<td width="40%"><span>${vehicle.newcarPrice}</span>元</td>
				</tr>
				<tr>
					<td class="text-r" width="15%">现售价:</td>
					<td width="40%"><span>${trade.showPrice}</span>元</td>
				</tr>
				<tr>
					<td class="text-r" width="15%">车况描述:</td>
					<td width="40%"><p style="width: 100%">${vehicle.condDesc}</p>
					</td>
				</tr>
				<tr>
					<td colspan="2">车辆图片:</td>
				</tr>
				<c:forEach items="${vehiclePic }" var="pic">
					<tr>
						<td colspan="2"><img width="100%" src="${pic.smallPicUrl }"/></td>
					</tr>
				</c:forEach>
			</table>
		</div>
	</form>
</body>
</html>
