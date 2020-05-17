<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/common/taglibs.jsp"%>
<%-- <%@taglib uri="/struts-tags" prefix="s"%>
<%@ include file="/common/meta.jsp"%> --%>
<!DOCTYPE html>
<html>
<head>
<title>车辆信息录入</title>
<script type="text/javascript" charset="utf-8">
    var ctx = "${ctx}";
</script>
<meta http-equiv="pragma" content="no-cache">
<meta http-equiv="cache-control" content="no-cache">
<meta http-equiv="expires" content="0">
<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
<meta http-equiv="description" content="This is my page">

<meta name="viewport" content="width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no">
<!-- <meta name="viewport" content="width=device-width, initial-scale=1.0, minimum-scale=0.5, maximum-scale=2.0, user-scalable=yes" /> -->
<meta name="apple-mobile-web-app-capable" content="yes" />
<meta name="apple-mobile-web-app-status-bar-style" content="black" />
<meta name="format-detection" content="telephone=no" />
<link rel="stylesheet" type="text/css" href="${ctx}/css/default.css" />
<link rel="stylesheet" type="text/css" href="${ctx}/phone/css/style.css" />
<link rel="stylesheet" type="text/css" href="${ctx}/phone/css/master.css" />
<script src="${ctx}/phone/mobiscroll/js/jquery-1.9.1.min.js"></script>
<script type="text/javascript" src="${ctx}/js/common/ctutil.js"></script>
<script type="text/javascript" src="${ctx}/phone/js/megapix-image.js"></script>
<script type="text/javascript" src="${ctx}/phone/js/vehicle_input_phone.js"></script>
    
<link href="${ctx}/phone/mobiscroll/css/mobiscroll.custom-2.5.0.min.css" rel="stylesheet" type="text/css" />
<script src="${ctx}/phone/mobiscroll/js/mobiscroll.custom-2.5.0.min.js" type="text/javascript"></script>

</head>
<body>
    
    <div class="vInfo">
        <nav class="nav-final" id="nav_miniHeader">
            <p>车辆登记</p>
        </nav>
        
        <div class="step clearfix" id="div_step"></div>
        <!--步骤1 begin-->
        <div id="div_step1">
            <div class="h2-title">
                <span class="line"></span>车辆基本（${agency.agencyName }）
            </div>
            <form id="myForm" action="">
                <input type="hidden" name="trade.agency.id" value="${agency.id }" /> 
                <div class="list-infor01">
                    <ul>
                        <%-- <li style="background-color: #dddee3;">
                          <a class="anchor" id="anchor4"></a> 
                          <a href="javascript:void(0);"> 
                              <span class="red-star">*</span> 
                              <span class="caption">商户名称:</span> 
                              <span class="colors-area"> 
                                  <span class="text" id="agencyText">${agency.agencyName }</span> 
                              </span>
                        </a>
                            <div class="error fn-hide" id="colorTip"></div></li> --%>
                        <li><a href="javascript:selectBrand();" id="selectBrand">
                                <span class="red-star">*</span> 
                                <span class="caption">品牌:</span>
                                <span class="colors-area">
                                <span id="carName" class="font12"></span>
                                <i class="arrow-right"></i>
                                <input type="hidden" id="brandId" name="vehicle.brand.id" value="" />
                                <input type='hidden' id="brandName" name="vehicle.brandName" /></span>
                        </a>
                            <div class="error fn-hide" id="brandTip">
                                <i class="error-icon"></i>
                            </div></li>
                        <li><a class="anchor" id="anchor4"></a> 
                          <a href="javascript:;"> 
                              <span class="caption">车系:</span> 
                              <span class="colors-area"><span class='text' id="seriesNameText"></span></span>
                              <i class="arrow-right"></i>
                              <input type='hidden' id="seriesName" name="vehicle.seriesName" />
                              <input type='hidden' id="seriesVal" name="vehicle.series.id" />
                              <select id="seriesId" class="input vin-code color-select" onchange="seriesSelect()">
                            </select>
                        </a>
                            <div class="error fn-hide" id="colorTip"></div></li>
                        <li><a class="anchor" id="anchor4"></a> 
                          <a href="javascript:;"> 
                              <span class="caption">车型:</span> 
                              <span class="colors-area"><span class='text' id="kindNameText"></span></span>
                              <i class="arrow-right"></i>
                                  <input type="hidden" id="kindVal" name="vehicle.kind.id"/>
                                  <input type='hidden' id="kindName" name="vehicle.kindName" />
                              <select id="kindId" class="input vin-code color-select"  name="color-select" onchange="kindSelect()">
                              </select>
                        </a>
                            <div class="error fn-hide" id="colorTip"></div></li>
                        <li><a href="javascript:;"> 
                              <span class="caption">车架号:</span>
                              <span class="icon-mark"></span> 
                              <input type="text" class="input vin-code" id="shelfCode" name="vehicle.shelfCode"/></a></li>
                        <li><a href="javascript:;"> 
                              <span class="caption">发动机号:</span>
                              <span class="icon-mark"></span> 
                              <input type="text" class="input vin-code" id="engineNumber" name="vehicle.engineNumber"/></a></li>
                        <li><a href="javascript:;"> 
                              <span class="caption">首次上牌:</span>
                              <span class="icon-mark"></span> 
                              <i class="arrow-right"></i>
                              <input type="text" class="input vin-code" id="registMonth" name="vehicle.registMonth"/></a></li>
                        <li><a href="javascript:;"> 
                              <span class="fn-right">万公里</span>
                              <span class="caption">公里数:</span>
                              <span class="icon-mark"></span> 
                              <input type="text" class="input vin-code" name="vehicle.mileageCount"></a></li>
                        <li><a href="javascript:;"> 
                              <span class="fn-right"><input type="checkbox" name="vehicle.outputVolumeU" value="1" />涡轮</span>
                              <span class="caption">排量:</span><span class="icon-mark"></span> 
                                <input type="text" class="input vin-code" name="vehicle.outputVolume"/></a></li>
                        <li><a href="javascript:;"> 
                              <span class="caption">车牌号:</span>
                              <span class="icon-mark"></span> 
                              <input type="text" class="input vin-code" name="trade.oldLicenseCode" /></a></li>
                        <li><a href="javascript:;">
                              <span class="caption">车身颜色:</span>
                              <span class="colors-area"><span class='text' id="carColorText"></span></span>
                              <i class="arrow-right"></i>
                              <select id="carColorSelect" name="vehicle.carColor" class="input vin-code color-select">
                                <option value="">选择颜色</option>
                                <option value="黑色">黑色</option>
                                <option value="白色">白色</option>
                                <option value="紫色">紫色</option>
                                <option value="红色">红色</option>
                                <option value="蓝色">蓝色</option>
                                <option value="绿色">绿色</option>
                                <option value="黄色">黄色</option>
                                <option value="香槟色">香槟色</option>
                                <option value="银灰色">银灰色</option>
                                <option value="深灰色">深灰色</option>
                                <option value="橙色">橙色</option>
                                <option value="棕色">棕色</option>
                                <option value="其它">其它</option>
                            </select>
                        </a></li>
                        <li><a href="javascript:;"><span class="caption">内饰颜色:</span>
                                <span class="colors-area"><span class='text' id="upholsteryColorText"></span></span>
                                <i class="arrow-right"></i>
                                <select id="upholsteryColorSelect" name="vehicle.upholsteryColor" class="input vin-code color-select">
                                    <option value="">选择颜色</option>
                                    <option value="黑色">黑色</option>
                                    <option value="白色">白色</option>
                                    <option value="紫色">紫色</option>
                                    <option value="红色">红色</option>
                                    <option value="蓝色">蓝色</option>
                                    <option value="绿色">绿色</option>
                                    <option value="黄色">黄色</option>
                                    <option value="香槟色">香槟色</option>
                                    <option value="银灰色">银灰色</option>
                                    <option value="深灰色">深灰色</option>
                                    <option value="橙色">橙色</option>
                                    <option value="棕色">棕色</option>
                                    <option value="其它">其它</option>
                                </select>
                        </a></li>
                        <li><a href="javascript:;">
                              <span class="caption">变速箱:</span>
                              <span class="colors-area"><span class='text' id="gear_typeText"></span></span>
                              <i class="arrow-right"></i>
                              <select id="gear_typeSelect" name="vehicle.gear_type" class="input vin-code color-select">
                                    <option value="">--选择--</option>
                                    <option value="manual">手动挡</option>
                                    <option value="auto">自动挡</option>
                                    <option value="manual_automatic">手自一体</option>
                                    <option value="other">其他</option>
                              </select>
                              
                        </a></li>
                        <li><a href="javascript:;">
                              <span class="caption">出厂日期:</span>
                              <span class="icon-mark"></span> 
                              <i class="arrow-right"></i>
                                <input type="text" class="input vin-code" id="factoryDate" name="vehicle.factoryDate"/>
                                </a></li>
                        <li><a href="javascript:;"><span class="caption">交强险:</span><span
                                class="icon-mark"></span> 
                                <i class="arrow-right"></i>
                                <input type="text" class="input vin-code" id="issurValidDate" name="vehicle.issurValidDate" /></a></li>
                        <li><a href="javascript:;"><span class="caption">年审到期:</span><span
                                class="icon-mark"></span> 
                                <i class="arrow-right"></i>
                                <input type="text" class="input vin-code" id="checkValidMonth" name="vehicle.checkValidMonth"/></a></li>
                        <li><a href="javascript:;"><span class="caption">商业险到期:</span><span
                                class="icon-mark"></span>
                                <i class="arrow-right"></i>
                                <input type="text" class="input vin-code" id="commIssurValidDate" name="vehicle.commIssurValidDate"/></a></li>
                        <li><a href="javascript:;">
                              <span class="caption">使用性质:</span>
                              <span class="colors-area"><span class='text' id="usedTypeText"></span></span>
                              <i class="arrow-right"></i>
                                <select id="usedTypeSelect" name="vehicle.usedType" class="input vin-code color-select">
                                    <option value="">--选择--</option>
                                    <option value="personal_use">非营运</option>
                                    <option value="business_use">营运</option>
                                    <option value="b2p_use">营转非</option>
                                    <option value="rental_use">公户</option>
                              </select>
                        </a></li>
                        <li><a href="javascript:;"> 
                                <span class="fn-right">万元</span>
                                <span class="caption">新车价格:</span>
                                <input type="text" class="input vin-code" name="vehicle.newcarPrice"/></a></li>
                        <li><a href="javascript:;"> 
                                <span class="fn-right">万元</span>
                                <span class="caption">收购价格:</span>
                                <span class="icon-mark"></span>
                                <input type="text" class="input vin-code" name="trade.acquPrice" /></a></li>
                        <li><a href="javascript:;"> 
                                <span class="fn-right">万元</span>
                                <span class="caption">展示价格:</span>
                                <span class="icon-mark"></span> 
                                <input type="text" class="input vin-code" name="trade.showPrice"/></a></li>
                        <li><a href="javascript:;"> 
                              <span class="fn-right font12" id="span_remarkNum">0/1000</span> 
                              <span class="caption">车况描述</span>
                           </a> 
                           <textarea name="vehicle.condDesc" cols="30" rows="10" class="textarea"></textarea></li>
                    </ul>
                </div>
            </form>
        </div>
        <div class="btm-c-box">
            <ul>
                <li><a href="javascript:do_submit();" id="a_step1" class="btn">提交</a></li>
                <!-- <li><a href="javascript:ajaxSendImagePost(213,123,1);" class="btn">提交tup</a></li> -->
            </ul>
        </div>
        		
        <div class="wrap">
       		<ul>
       			<li class="click">
                    <a href="javascript:;" id="i_papers">
                        <span class="caption">上传车辆图片</span><span class="font12 font-small">（左前45°、右后45°等照片）</span>
                    </a>
                    <div class="error fn-hide" id="credentialsTip"></div>
               	</li>
            </ul>
            <input type="hidden" id="tradeId" name="trade.id" value="" />
            <input type="hidden" id="vehicleId" name="vechile.id" value="" />
            <div id="companyCodeImgLi" class="check-line1" style="padding-top: 10px;"> </div>
        </div>
    </div>
	
	<div class="bAndS" style="display: none;">
		<div class="w-nav">
			<h2 class="w-nav-title">选品牌</h2>
			<a onclick="goBack()" href="javascript:;" class="w-nav-back"><i
				class="w-icon-arrow w-arrow-left"></i><span>返回</span></a>
			<div class="w-nav-mini"></div>
		</div>
		<div class="step clearfix" id="div_step"></div>
		<div class="w-main"></div>
	</div>
</body>
</html>
