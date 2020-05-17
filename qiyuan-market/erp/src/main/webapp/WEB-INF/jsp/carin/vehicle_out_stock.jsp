<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"	language="java"%>
<%@taglib uri="/struts-tags" prefix="s"%>
<%@ include file="/common/taglibs.jsp"%>
<%@ include file="/common/meta.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<title>车辆入场登记</title>
		<link rel="stylesheet" type="text/css" href="${ctx}/css/style.css" />
		<script type="text/javascript" src="${ctx}/js/common/syUtil.js"></script>
		<script type="text/javascript" src="${ctx}/js/common/ctutil.js"></script>
		<script type="text/javascript" src="${ctx}/js/common/jquery.json-2.4.js"></script>
		<script type="text/javascript" src="${ctx}/js/plugins/jquery/jquery.js"></script>
		<script type="text/javascript" src="${ctx}/js/plugins/bootstrap-3.0.3/js/bootstrap.min.js"></script>
		<script type="text/javascript" src="${ctx}/js/plugins/jstree/_lib/jquery.cookie.js"></script>
		<script type="text/javascript" src="${ctx}/js/plugins/jstree/_lib/jquery.hotkeys.js"></script>
		<link rel="stylesheet" type="text/css"	href="${ctx}/js/plugins/jquery/uploadifive/uploadifive.css" />
		<script	src="${ctx}/js/plugins/jquery/uploadifive/jquery.uploadifive.js"></script>

<style type="text/css">
.message_box {
	width: 300px;
	height: 120px;
	overflow: hidden;
}

.message_box_t {
	width: 25px;
	padding-left: 275px;
	background: url(../img/message_box_top.png);
	height: 20px;
	padding-top: 10px;
}

.message_box_m {
	width: 280px;
	padding: 10px;
	background: url(../img/message_box_body.png);
	text-align: left;
	line-height: 35px;
	font-size: 14px;
}

.message_box_b {
	width: 300px;
	background: url(../img/message_box_bottom.png);
	height: 30px;
}
</style>

<script>
	  var api = frameElement.api, W = api.opener;
    var bSaved=false;
    //检测条码的输入规则		
	function do_submit()
	{
		/* var unusedNum=$("input[name='carport.unusedNum']").val();
		if (unusedNum==0)
		{
	       alert("该商户已没有车位,禁止车辆入场!");
	       return ;
		} */
		var data = $("#myForm").serialize();
		ajaxPost(data);
	}
	
	function ajaxPost(data2){
	  var url1 =ctutil.bp()+"/carin/vehicleInput!doVehicleOutStock.action";
	  $.ajax({
				cache: false,
				type: "POST",
				url:url1,
				data:data2,
				async: false,
				error: function() {
				  html = "数据请求失败";
				},
				success: function(data) {
				  if(data=="success"){
					  alert("保存成功！");
					  api.get("vehicleOut",1).close();
					  W.query1();  
				  }else if(data=="unable"){
					  alert("当前出场车辆估价大于在场车辆估价总和，不允许出场！");
				  }else{
					  alert("保存失败,请重试！");
				  }
				}
			});
	}
	
</script>

</head>
<body>
		<form id="myForm">
		  <input type="hidden" id="tradeId"   name="tradeId" readonly="readonly" value="${trade.id}"/>        
			<div class="box">
				<table>
				</table>
				<table>
					<tr>
						<td class="text-r" width="100px" id="areaTotal">
							商户名称
						</td>
						<td width="400px">
							<input class="input w200" id="agencyName"  style="background-color:#F0F0F0"  name="agencyName" value="${trade.agency.agencyName}" readonly="readonly" />
						</td>
					</tr>
					<tr>
						<td class="text-r" width="100px" id="feeMeter">
							已使用车位数:
						</td>
						<td width="400px">
							<input class="input w200" id="usedNum" name="carport.usedNum"   style="background-color:#F0F0F0" value="${carport.usedNum}" readonly="readonly" />
						</td>
					</tr>
					<tr>
						<td class="text-r" width="100px" id="feeMeter">
							未使用车位数:
						</td>
						<td width="400px">
							<input class="input w200" id="unusedNum" name="carport.unusedNum"  style="background-color:#F0F0F0" value="${carport.unusedNum}" readonly="readonly" />
						</td>
					</tr>
					<tr>
						<td class="text-r" width="100px" id="feeMeter">
							品牌:
						</td>
						<td width="400px">
							<input class="input w200" id="brand" name="vehicle.brandName"  style="background-color:#F0F0F0" value="${trade.vehicle.brandName}" readonly="readonly" />
						</td>
					</tr>
					<tr>
						<td class="text-r" width="100px" id="feeMeter">
							车系:
						</td>
						<td width="400px">
							<input class="input w200" id="series" name="vehicle.seriesName"  style="background-color:#F0F0F0" value="${trade.vehicle.seriesName}" readonly="readonly" />
						</td>
					</tr>
					<tr>
						<td class="text-r" width="100px" id="feeMeter">
							车型:
						</td>
						<td width="400px">
							<input class="input w200" id="kind" name="vehicle.kindName"  style="background-color:#F0F0F0" value="${trade.vehicle.kindName}" readonly="readonly" />
						</td>
					</tr>
					<tr>
						<td class="text-r" width="100px" id="feeMeter">
							车牌号:
						</td>
						<td width="400px">
							<input class="input w200" id="lincense" name="vehicle.licenseCode"  style="background-color:#F0F0F0" value="${trade.vehicle.licenseCode}" readonly="readonly" />
						</td>
					</tr>
					<tr>
						<td class="text-r" width="100px" id="feeMeter">
							车架号:
						</td>
						<td width="400px">
							<input class="input w200" id="shelf" name="vehicle.shelfCode"  style="background-color:#F0F0F0" value="${trade.vehicle.shelfCode}" readonly="readonly" />
						</td>
					</tr>
					<tr>
						<td class="text-r" width="100px" id="feeMeter">
							条形码:
						</td>
						<td width="400px">
							<%-- <input class="input w200" id="bar_code" name="trade.barCode"  style="background-color:#F0F0F0" value="${trade.barCode}" readonly="readonly" /> --%>
							<img id="bar_code" name="trade.barCode" src="${ctx}/common/code_barcode.action?barcode=${trade.barCode}"/>
						</td>
					</tr>

				</table>
			</div>

		</form>
 

	</body>
</html>
