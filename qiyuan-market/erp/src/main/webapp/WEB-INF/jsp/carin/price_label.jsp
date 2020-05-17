<%@ page language="java" pageEncoding="UTF-8"
	contentType="text/html; charset=UTF-8"%>
<%@ include file="/common/taglibs.jsp"%>
<!DOCTYPE HTML>
<html lang="en">
<head>
	<meta charset="UTF-8">
    <meta content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=0;" name="viewport" />
	<title>${agency.agencyName}</title>
    <link rel="stylesheet" href="${ctx}/priceLabel/css/label-all.css" />
     <script type="text/javascript" src="${ctx}/js/plugins/jquery-easyui/jquery-1.6.min.js"></script>
    <script src="${ctx}/priceLabel/js/label.js"></script>
    <script src="${ctx}/priceLabel/js/plugin.js"></script>
    <script src="${ctx}/priceLabel/js/pl_common.js"></script>
</head>
<body>
<div class="print">
		<div class="content">
			<div class="title">车辆展示认证</div>
			<div class="logo"><img src="${ctx}/priceLabel/img/logo.jpg" style="width:200px;"/></div>
			<div class="print_div">
				<div class="v_model"><label>车型：</label><span>${vehicle.seriesName}&nbsp;&nbsp;${vehicle.kindName}</span></div>
			</div>
			<div class="print_div">
				<div class="price"><label>新车价格：</label><span style="text-decoration:line-through;">${vehicle.newcarPrice}</span>元</div>
				<div class="price sale"><label>销售价格：</label><span style="font-size:95px;line-height:100px;">${trade.showPrice}</span>元</div>
			</div>
			<div class="print_div">
				<div class="stit">车况信息</div>
				<div class="left"><label>初登日期：</label><span>${vehicle.registMonth}</span></div>
				<div class="right"><label>行驶里程：</label><span>${vehicle.mileageCount/10000.0}万公里</span></div>
				<div class="left"><label>使用性质：</label><span>
					<c:choose>
						<c:when test="${vehicle.usedType=='personal_use'}">非运营</c:when>
						<c:when test="${vehicle.usedType=='business_use'}">运营</c:when>
						<c:when test="${vehicle.usedType=='b2p_use'}">营转非</c:when>
						<c:when test="${vehicle.usedType=='rental_use'}">公户</c:when>
					</c:choose>
				</span></div>
				<div class="right"><label>颜色：</label><span>${vehicle.carColor}</span></div>
				<div class="clear"></div>
			</div>
			<div class="print_div">
				<div class="stit">车辆信息</div>
				<div class="left"><label>车型：</label><span>${vehicle.series.vehicleType }</span></div>
				<div class="right"><label>变速方式：</label><span>
					<c:choose>
						<c:when test="${vehicle.gearType=='manual'}">手动</c:when>
						<c:when test="${vehicle.gearType=='auto'}">自动</c:when>
						<c:when test="${vehicle.gearType=='manual_automatic'}">手自一体</c:when>
						<c:when test="${vehicle.gearType=='other'}">其它</c:when>
					</c:choose>
				</span></div>
				<div class="left"><label>环保标准：</label><span>
					<c:choose>
						<c:when test="${vehicle.envLevel=='guo_1'}">国1</c:when>
						<c:when test="${vehicle.envLevel=='guo_2'}">国2</c:when>
						<c:when test="${vehicle.envLevel=='guo_3'}">国3</c:when>
						<c:when test="${vehicle.envLevel=='guo_4'}">国4</c:when>
						<c:when test="${vehicle.envLevel=='guo_5'}">国5</c:when>
					</c:choose>
				</span></div>
				<div class="right"><label>发动机：</label><span>
					${vehicle.outputVolume}
					<c:choose>
						<c:when test="${vehicle.outputVolumeU==1}">T</c:when>
						<c:otherwise>L</c:otherwise>
					</c:choose>
				</span></div>
				<div class="clear"></div>
			</div>
			<div class="print_div">
				<div class="desc">
					<div class="stit">备注：</div>
					<p>${vehicle.condDesc }</p>
					<span>本证手写无效，仅限指定展示区内使用</span>
				</div>
				<div class="qrcode">
					<div><img src="${ctx}/carin/vehicleInput!qrCode.action?qrCode=${localhost}/carin/vehicleInput!toVehicleDetail.action?tradeId=${trade.id}&width=180&height=180"/></div>
					<p>扫一扫&nbsp;&nbsp;&nbsp;&nbsp;关注更多车辆信息</p>
				</div>
				<div class="clear"></div>
			</div>
			<%-- <div class="print_div">
				<div class="left tit"><img src="${ctx}/priceLabel/img/logo.png"/></div>
				<div class="right tit"><img src="${ctx}/carin/vehicleInput!qrCode.action?qrCode=${localhost}/carin/vehicleInput!toVehicleDetail.action?tradeId=${trade.id}&width=80&height=80"/></div>
			</div>
			<div class="print_div">
				<div class="left"><label>品牌：</label><span>${vehicle.brandName}</span></div>
				<div class="right"><label>车型：</label><span>${vehicle.kindName}</span></div>
			</div>
			<div class="price"><label>销售价格：</label><span>${trade.showPrice}元</span></div>
			<div class="print_div">
				<div class="left"><label>排量：</label><span>${vehicle.outputVolume}
					<c:choose>
						<c:when test="${vehicle.outputVolumeU==1}">T</c:when>
						<c:otherwise>L</c:otherwise>
					</c:choose>
				</span></div>
				<div class="right"><label>公里数：</label><span>${vehicle.mileageCount}</span></div>
			</div>
			<div class="print_div">
				<div class="left"><label>变速箱形式</label><span>
					<c:choose>
						<c:when test="${vehicle.gearType==0}">手动</c:when>
						<c:when test="${vehicle.gearType==1}">自动</c:when>
						<c:when test="${vehicle.gearType==2}">手自一体</c:when>
						<c:when test="${vehicle.gearType==3}">其它</c:when>
					</c:choose>
				</span></div>
				<div class="right"><label>驱动方式：</label><span></span></div>
			</div>
			<div class="print_div">
				<div class="left"><label>环保标准：</label><span>
					<c:choose>
						<c:when test="${vehicle.envLevel==0}">国1</c:when>
						<c:when test="${vehicle.envLevel==1}">国2</c:when>
						<c:when test="${vehicle.envLevel==2}">国3</c:when>
						<c:when test="${vehicle.envLevel==3}">国4</c:when>
						<c:when test="${vehicle.envLevel==4}">国5</c:when>
					</c:choose>
				</span></div>
				<div class="right"><label>使用性质：</label><span>
					<c:choose>
						<c:when test="${vehicle.usedType==0}">非运营</c:when>
						<c:when test="${vehicle.usedType==1}">运营</c:when>
						<c:when test="${vehicle.usedType==2}">营转非</c:when>
					</c:choose>
				</span></div>
			</div>
			<div class="print_div">
				<div class="left"><label>初登日期：</label><span>${vehicle.registMonth}</span></div>
				<div class="right"><label>年审到期：</label><span>${vehicle.checkValidMonth}</span></div>
			</div>
			<div class="check"><label>外观检测：</label><p></p></div>
			<div class="check"><label>内饰检测：</label><p></p></div>
			<div class="check"><label>动力检测：</label><p></p></div>
			<div class="check"><label>事故排查：</label><p></p></div>
			<div class="print_div">
				<div class="left"><label>车商：</label><span>${agency.agencyName}</span></div>
				<div class="right"><label>展台编号：</label><span></span></div>
			</div> --%>
		</div>
		<div class="print_tab">
            <div class="print_click" onclick="printLabel();"><img src="${ctx}/priceLabel/img/img_click_print.png" /></div>
        </div>
	</div>
</body>
</html>
