<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"
	language="java"%>
<%@taglib uri="/struts-tags" prefix="s"%>
<%@ include file="/common/taglibs.jsp"%>
<%@ include file="/common/meta.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
  <head>    
    <title>拍卖商品信息</title>
    
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">

	<meta name="viewport" content="width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no">        <!-- <meta name="viewport" content="width=device-width, initial-scale=1.0, minimum-scale=0.5, maximum-scale=2.0, user-scalable=yes" /> -->        
	<meta name="apple-mobile-web-app-capable" content="yes" />        
	<meta name="apple-mobile-web-app-status-bar-style" content="black" />        
	<meta name="format-detection" content="telephone=no" />

	<style>
		body{margin:0;}
		*{font-family:"微软雅黑";}
		.item_con{margin: 10px 10px;}
		.sale-info-item{width: 50%;float: left;margin: 8px 0;}
		.sale-info-item .info-value {
			color: #333;
			font-size: 14px;
			line-height: 14px;
			/*margin-top: 10px;*/
			float:left;
		}
		.sale-info-item .info-key {
			color: #999;
			font-size: 12px;
			line-height: 12px;
			float:left;
			width:55px;
			text-align:right;
			padding:0 5px 0 0;
		}
		.big{width:100%;}
		/*.big .info-key{text-align:center;}*/
		.header{height:45px;background:#086fd2;text-align:center;font-weight:bold;line-height:45px;font-size:20px;}
		.promo_wrap {
			position: relative;
			padding-bottom: 5px;
		}
		.main_promo {
			padding-bottom: 5px;
			overflow: hidden;
			width: 100%;
			min-height: 130px;
		}
		.main_promo img {
			/*position: absolute;
			top: 0;
			left: 0;*/
			width: 100%;
			height: 130px;
			padding: 0px;
		}
		.banPic{
			position:absolute;
			top: 0;
			left: 0;
			text-align:center;
			width:100%;
			height:100%;
		}
		.vname{position:absolute; bottom:10px;left:0;width:100%;font-size:15px;color:#fff;height:25px;line-height:25px;}
		.opc{position:absolute; bottom:10px;left:0;width:100%;background:#000;filter: alpha(opacity=50);-moz-opacity: 0.50;opacity: 0.50;height:25px;}
		.vbig{margin:10px 0 0 5px;clear:both;}
	</style>
	<script type="text/javascript">
		$(document).ready(function(){
			var bannerCount=0,
			$banPic=$(".banPic"),
			banPicLength=$banPic.length;
			bannerFadeShow(bannerCount,$banPic,banPicLength);
		});
		function bannerFadeShow(bannerCount,$banPic,banPicLength){
			if(bannerCount==banPicLength){
				bannerCount=0;
			};
			$banPic.eq(bannerCount).fadeIn().siblings().fadeOut();
			bannerCount++;
			banTimer=setTimeout(function(){bannerFadeShow(bannerCount,$banPic,banPicLength);}, 2000);
		}
	</script>

  </head>
  
  <body>
	<div class="header">拍卖商品信息</div>
	<div>
		<div class="promo_wrap">
			<div class="main_promo">
				<div id="JS_promoContent">
					<c:forEach var="pic" items="${vehiclePic}" varStatus="status">
						<div class="banPic"><a href="#"><img width="100%" height="100%" src="${pic.picUrl}" alt="" /></a></div>
					</c:forEach>
				</div>
			</div>
			<div class="opc"></div>
			<div class="vname">&nbsp;&nbsp;&nbsp;&nbsp;${vehicle.brand.name}&nbsp;&nbsp;${vehicle.series.name}&nbsp;&nbsp;${vehicle.kind.name}</div>
		</div>
	</div>
	<div class="detail">
		<div class="item_con">
			<div class="sale-info-item">
				<div class="info-key">车身颜色:</div>
				<div class="info-value">${vehicle.carColor}</div>
			</div>
			<div class="sale-info-item">
				<div class="info-key">车&nbsp;&nbsp;牌&nbsp;&nbsp;号:</div>
				<div class="info-value">${trade.oldLicenseCode}</div>
			</div>


			<div class="sale-info-item">
				<div class="info-key">内饰颜色:</div>
				<div class="info-value">${vehicle.upholsteryColor}</div>
			</div>
			<div class="sale-info-item">
				<div class="info-key">发动机号:</div>
				<div class="info-value">${vehicle.engineNumber}</div>
			</div>


			<div class="sale-info-item">
				<div class="info-key">排&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;量:</div>
				<div class="info-value">${vehicle.outputVolume}<c:if test="${vehicle.outputVolumeU==1}">T</c:if></div>
			</div>
			<div class="sale-info-item">
				<div class="info-key">出厂日期:</div>
				<div class="info-value"><fmt:formatDate value="${vehicle.factoryDate}" pattern="yyyy-MM-dd"/></div>
			</div>



			<div class="sale-info-item">
				<div class="info-key">变&nbsp;&nbsp;速&nbsp;&nbsp;箱:</div>
				<div class="info-value">
					<c:choose>
						<c:when test="${vehicle.gearType=='0'}">手动</c:when>
						<c:when test="${vehicle.gearType=='1'}">自动</c:when>
						<c:when test="${vehicle.gearType=='2'}">手自一体</c:when>
						<c:when test="${vehicle.gearType=='3'}">其它</c:when>
					</c:choose>
				</div>
			</div>
			<div class="sale-info-item">
				<div class="info-key">首次上牌:</div>
				<div class="info-value">${vehicle.registMonth}</div>
			</div>


			<div class="sale-info-item">
				<div class="info-key">环保标准:</div>
				<div class="info-value">
					<c:choose>
						<c:when test="${vehicle.envLevel=='0'}">国1</c:when>
						<c:when test="${vehicle.envLevel=='1'}">国2</c:when>
						<c:when test="${vehicle.envLevel=='2'}">国3</c:when>
						<c:when test="${vehicle.envLevel=='3'}">国4</c:when>
						<c:when test="${vehicle.envLevel=='4'}">国5</c:when>
					</c:choose>
				</div>
			</div>
			<div class="sale-info-item">
				<div class="info-key">年审到期:</div>
				<div class="info-value">${vehicle.checkValidMonth}</div>
			</div>


			<div class="sale-info-item">
				<div class="info-key">车身类型:</div>
				<div class="info-value">
					<c:choose>
						<c:when test="${vehicle.vehicleType=='0'}">轿车</c:when>
						<c:when test="${vehicle.vehicleType=='1'}">跑车</c:when>
						<c:when test="${vehicle.vehicleType=='2'}">越野车</c:when>
						<c:when test="${vehicle.vehicleType=='3'}">商务车</c:when>
					</c:choose>
				</div>
			</div>
			<div class="sale-info-item">
				<div class="info-key">交&nbsp;&nbsp;强&nbsp;&nbsp;险:</div>
				<div class="info-value">${vehicle.issurValidDate}</div>
			</div>


			<div class="sale-info-item">
				<div class="info-key">里&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;程:</div>
				<div class="info-value">${vehicle.mileageCount}公里</div>
			</div>
			<div class="sale-info-item">
				<div class="info-key">商&nbsp;&nbsp;业&nbsp;&nbsp;险:</div>
				<div class="info-value">${vehicle.commIssurValidDate}</div>
			</div>


			<div class="sale-info-item">
				<div class="info-key">使用性质:</div>
				<div class="info-value">
					<c:choose>
						<c:when test="${vehicle.usedType=='0'}">非运营</c:when>
						<c:when test="${vehicle.usedType=='1'}">运营</c:when>
						<c:when test="${vehicle.usedType=='2'}">营转非</c:when>
					</c:choose>
				</div>
			</div>
			<div class="sale-info-item">
				<div class="info-key">新车价格:</div>
				<div class="info-value">${vehicle.newcarPrice}元</div>
			</div>


			<%-- <div class="sale-info-item">
				<div class="info-key">收购价格:</div>
				<div class="info-value">${trade.acquPrice}元</div>
			</div> --%>


			<div class="sale-info-item big">
				<div class="info-key">车&nbsp;&nbsp;架&nbsp;&nbsp;号:</div>
				<div class="info-value">${vehicle.shelfCode}</div>
			</div>
			<div class="sale-info-item big">
				<div class="info-key">车况描述:</div>
				<div class="info-value vbig">${vehicle.condDesc}</div>
			</div>
		</div>
	</div>
  </body>
</html>
