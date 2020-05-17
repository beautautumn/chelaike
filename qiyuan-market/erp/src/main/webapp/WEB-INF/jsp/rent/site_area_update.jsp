<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@taglib uri="/struts-tags" prefix="s"%>
<%@ include file="/common/taglibs.jsp"%>
<%@ include file="/common/meta.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>编辑场地</title>
<link rel="stylesheet" type="text/css" href="${ctx}/css/style.css" />
<script type="text/javascript" src="${ctx}/js/common/syUtil.js"></script>
<script type="text/javascript" src="${ctx}/js/common/ctutil.js"></script>
<script type="text/javascript" src="${ctx}/js/common/menu.js"></script>
<script type="text/javascript" src="${ctx}/js/common/select.js"></script>
<script type="text/javascript" src="${ctx}/js/common/jquery.json-2.4.js"></script>
<script type="text/javascript" src="${ctx}/js/business/vehicle/vehicle_vin.js"></script>
<script type="text/javascript" src="${ctx}/js/pages/catalogue/catalogue.js"></script>
<script type="text/javascript" src="${ctx}/js/pages/region/region.js"></script>
<script type="text/javascript" src="${ctx}/js/common/validator/validator.js"></script>

<script>
	var coutReg = /^[0-9]+(\.[0-9]+)?$/;
	var numReg =  /^[0-9]+(\.[0-9]+)?$/;
	var nameCheckResult = "";
	var areaTotalResult = "";
	var monthMeterResult = "";
	var unitTotalResult = "";
	var monthUnitResult = "";
	var carPortResult = "";
	var api = frameElement.api, W = api.opener;
//	function changeType(i){
//			if(i==0){
//				$("#totalUnitCount").val("");
//				$("#monthUnitRentFee").val("");
//				$("#siteTotal").attr("style", "display:''");
//				$("#monthMeterFee").attr("style", "display:''");
//				$("#areaTotal").attr("style", "display:''");
//				$("#areaTotalSite").attr("style", "display:''");
//				$("#feeMeter").attr("style", "display:''");
//				$("#feeMonthMeter").attr("style", "display:''");
//
//				$("#totalUnit").attr("style", "display:none");
//				$("#monthUnitFee").attr("style", "display:none");
//				$("#unitCarPort").attr("style", "display:none");
//				$("#unitTotal").attr("style", "display:none");
//				$("#unitTotalStandard").attr("style", "display:none");
//				$("#feeUnit").attr("style", "display:none");
//				$("#feeMonthUnit").attr("style", "display:none");
//				$("#allowCarport").attr("style", "display:none");
//			}
//			if(i==1){
//				$("#totalCount").val("");
//				$("#monthRentFee").val("");
//				$("#siteTotal").attr("style", "display:none");
//				$("#monthMeterFee").attr("style", "display:none");
//				$("#areaTotal").attr("style", "display:none");
//				$("#areaTotalSite").attr("style", "display:none");
//				$("#feeMeter").attr("style", "display:none");
//				$("#feeMonthMeter").attr("style", "display:none");
//
//				$("#totalUnit").attr("style", "display:''");
//				$("#monthUnitFee").attr("style", "display:''");
//				$("#unitCarPort").attr("style", "display:''");
//				$("#unitTotal").attr("style", "display:''");
//				$("#unitTotalStandard").attr("style", "display:''");
//				$("#feeUnit").attr("style", "display:''");
//				$("#feeMonthUnit").attr("style", "display:''");
//				$("#allowCarport").attr("style", "display:''");
//			}
//	}
    function changeType(i){
        if (i == 1){
            $('#totalUnit').show();
            $('#siteTotal').hide();
        }else{
            $('#totalUnit').hide();
            $('#siteTotal').show();
        }
    }
	
	function checkAreaTotal(inputValue){
		areaTotalResult = "ok";
		var val = $(inputValue).val()
            if(!numReg.test(val)){
            	alert("输入的数值不正确！");
            	areaTotalResult = "fail";
            	return ;
            }else{
				return ;
			}
	}
	
	function checkMonthMeter(inputValue){
		monthMeterResult = "ok";
		var val = $(inputValue).val()
            if(!coutReg.test(val)){
            	alert("输入的数值不正确！");
            	monthMeterResult = "fail";
            	return ;
            }else{
				return ;
			}
	}
	
	function checkUnitTotal(inputValue){
		unitTotalResult = "ok";
		var val = $(inputValue).val()
            if(!numReg.test(val)){
            	alert("输入的数值不正确！");
            	unitTotalResult = "fail";
            	return ;
            }else{
				return ;
			}
	}
	
	function checkMonthUnit(inputValue){
		monthUnitResult = "ok";
		var val = $(inputValue).val()
            if(!coutReg.test(val)){
            	alert("输入的数值不正确！");
            	monthUnitResult = "fail";
            	return ;
            }else{
				return ;
			}
	}
	
 
	
	function checkName(siteName){
		nameCheckResult = "ok";
		var val = $(siteName).val();
		if(val == null || val == ""){
            		alert("场地区域名称不能为空！");
            		nameCheckResult = "fail";
            		return;
            	}
            	var reg = /^[\u4E00-\u9FA5A-Za-z0-9_]{1,20}$/;
            	if(!reg.test(val)){
            		alert("场地区域名称格式不正确！");
            		nameCheckResult = "fail";
            		return;
            	}
	}
	
	
	
	function do_submit(){
		var flag =true;
		var data ="";
		var areaName = $("#areaName").val();
		var remark = $("#remark").val();
		var radioChoise = $('input:radio[name="siteArea.rentType"]:checked').val();
		if(radioChoise==0){
			var totalCount = $("#totalCount").val();
			var monthRentFee = $("#monthRentFee").val();
			if(areaName=="" || areaName==null || totalCount=="" || totalCount==null || monthRentFee=="" || monthRentFee==null){
				alert("表单未填写完整！");
			}else if(nameCheckResult=="fail" || areaTotalResult=="fail" || monthMeterResult=="fail") {
				alert("表单填写不正确！");
			}else{
				data = $("#myForm").serialize();
				ajaxPost(data);
			}
		}else{
			var totalCount = $("#totalUnitCount").val();
			var monthRentFee = $("#monthUnitRentFee").val();
			if(areaName=="" || areaName==null || totalCount=="" || totalCount==null || monthRentFee=="" || monthRentFee==null ){
				alert("表单未填写完整！");
			}else if(nameCheckResult=="fail" || unitTotalResult=="fail" || monthUnitResult=="fail" ) {
				alert("表单填写不正确！");
			}else{
				data = $("#myForm").serialize();
				ajaxPost(data);
			}
		}
	}
	
	function ajaxPost(data){
		$.ajax({
				cache: false,
				type: "POST",
				url:ctutil.bp()+"/rent/siteArea_update.action",
				data:data,
				async: false,
				error: function() {
				html = "数据请求失败";
				},
				success: function(data) {
				  if(data=="success"){
					  alert("保存成功！");
					  api.get("update_site",1).close();
					  W.query1();  //刷新页面
				  }else{
					  alert("保存失败！");
					  api.get("update_site",1).close();
					   W.query1();
				  }
				}
			});
	}
	
	function checkType(){
		var rentStyle = $("#rentType").val();
		var inputStyle = $("*[name='siteArea.rentType']");
		   for (var i=0; i<inputStyle.length; i++){ 
				if (inputStyle[i].value==rentStyle) { 
					inputStyle[i].checked= true; 
					changeType(rentStyle);
					break;
				} 
		   } 
	}
	
</script>
	<link rel="stylesheet" type="text/css" href="/sso/static/css/overui.css" />
</head>
<body onLoad="checkType()">
<div class="over-content">
	<form id="myForm">
		<input id="marketId" name="siteArea.market.marketId" type="hidden" value="${marketId}"/>
		<input type="hidden"  id="rentType" value="${siteArea.rentType}"/>
		<input type="hidden" class="input w200" name="siteAreaId" value="${siteArea.id}"/>
		<div class="over-cell">
			<label>区域名称：</label>
			<input  class="over-input" id="areaName" name="siteArea.areaName" value="${siteArea.areaName}"onblur="checkName(this);"/>
		</div>
		<div class="over-cell" >
			<label><span class="red">*</span>租赁类型：</label>
			<label>
				<input id="type1" type="radio"  name="siteArea.rentType" value="0" checked="checked" onclick="changeType(0);"/>
				按面积</label>
			<label>
				<input id="type2"  type="radio" name="siteArea.rentType" value="1" onclick="changeType(1);"/>
				按车位</label>
		</div>
		<div id="siteTotal">
			<div class="over-cell" >
				<label><span class="red">*</span>区域面积：</label>
				<span class="over-span"><input  id="totalCount" name="siteAreaBean.totalCount" value="${siteArea.totalCount}" onblur="checkAreaTotal(this);"/><b>平米</b></span>
			</div>
			<div class="over-cell" >
				<label><span class="red">*</span>租金：</label>
				<span class="over-span" style="padding-right:70px"><input  id="monthRentFee" name="siteAreaBean.monthRentFee" value="${siteArea.monthRentFee/100.0}" onblur="checkMonthMeter(this);"/><b style="width:70px;">元/平米/月</b></span>
			</div>
		</div>
		<div id="totalUnit" style="display:none">
			<div class="over-cell" >
				<label><span class="red">*</span>车位数：</label>
				<span class="over-span"><input  id="totalUnitCount" name="siteAreaBean.unitTotalCount" value="${siteArea.totalCount}" onblur="checkUnitTotal(this);"/><b>个</b></span>
			</div>
			<div class="over-cell">
				<label><span class="red" id="monthUnitFee">*</span>租金：</label>
				<span class="over-span"><input  id="monthUnitRentFee" name="siteAreaBean.unitMonthRentFee" value="${siteArea.monthRentFee/100.0}" onblur="checkMonthUnit(this);"/><b>元/个</b></span>
			</div>
		</div>
		<div class="over-cell">
			<label style="float: left;margin-right: 4px;">地理位置：</label>
			<textarea id="remark"class="over-textarea" name="siteArea.remark"/>${siteArea.remark}</textarea>
		</div>
	</form>
</div>
<%--<form id="myForm">--%>
    <%--<input id="marketId" name="siteArea.market.marketId" type="hidden" value="${marketId}"/>--%>
<%--<div class="box">--%>
	<%--<input type="hidden" class="input w200" id="rentType" value="${siteArea.rentType}"/>--%>
	<%--<input type="hidden" class="input w200" name="siteAreaId" value="${siteArea.id}"/>--%>
			<%--<table>	--%>
				<%--<tr>--%>
					<%--<td class="text-r" width="100px" ><span class="red">*</span>区域名称：</td>--%>
					<%--<td width="400px" ><input class="input w200" id="areaName" name="siteArea.areaName" value="${siteArea.areaName}"onblur="checkName(this);"/></td>--%>
				<%--</tr>--%>
				<%--<tr>--%>
					<%--<td class="text-r"><span class="red">*</span>租赁类型：</td>--%>
						<%--<td width="text-r">--%>
						<%--<label>--%>
						<%--<input id="type1" type="radio" name="siteArea.rentType" value="0" checked="checked" onclick="changeType(0);"/>--%>
						<%--按面积</label>--%>
						<%--<label>--%>
						<%--<input id="type2"  type="radio" name="siteArea.rentType" value="1" onclick="changeType(1);"/>--%>
						<%--按车位</label>--%>
						<%--</td>--%>
				<%--</tr>		--%>
				<%--<tr id="siteTotal">--%>
					<%--<td class="text-r" id="areaTotal"><span class="red">*</span>区域面积:</td>--%>
					<%--<td id="areaTotalSite"><input class="input w200" id="totalCount" name="siteAreaBean.totalCount" value="${siteArea.totalCount}" onblur="checkAreaTotal(this);"/> 平米</td>--%>
				<%--</tr>--%>
				<%--<tr id="monthMeterFee">		--%>
					<%--<td class="text-r" id="feeMeter"><span class="red">*</span>租金:</td>--%>
					<%--<td id="feeMonthMeter"><input class="input w200" id="monthRentFee" name="siteAreaBean.monthRentFee" value="${siteArea.monthRentFee/100.0}" onblur="checkMonthMeter(this);"/> 元</td>--%>
				<%--</tr>--%>
				<%--<tr id="totalUnit">			--%>
					<%--<td class="text-r" id="unitTotal" style="display: none;"><span class="red">*</span>车位数:</td>--%>
					<%--<td id="unitTotalStandard" style="display: none;"><input class="input w200" id="totalUnitCount" name="siteAreaBean.unitTotalCount" value="${siteArea.totalCount}" onblur="checkUnitTotal(this);"/> 个</td>--%>
				<%--</tr>--%>
				<%--<tr id="monthUnitFee">		--%>
					<%--<td class="text-r" id="feeUnit" style="display: none;"><span class="red">*</span>租金:</td>--%>
					<%--<td id="feeMonthUnit" style="display: none;"><input class="input w200" id="monthUnitRentFee" name="siteAreaBean.unitMonthRentFee" value="${siteArea.monthRentFee/100.0}" onblur="checkMonthUnit(this);"/> 元</td>--%>
				<%--</tr>--%>
	 <%----%>
				<%--<tr> --%>
					<%--<td class="text-r">地理位置:</td>--%>
					<%--<td><textarea id="remark" style="width:280px;height:120px" name="siteArea.remark"/>${siteArea.remark}</textarea></td>--%>
				<%--</tr>--%>
		<%--</table>--%>
<%--</div>		--%>
<%--</form>					--%>
</body>
</html>
