<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"
	language="java"%>
<%@taglib uri="/struts-tags" prefix="s"%>
<%@ include file="/common/taglibs.jsp"%>
<%@ include file="/common/meta.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<title>融资-商户预收款</title>
	<link rel="stylesheet" type="text/css" href="${ctx}/css/style.css" />
	<script type="text/javascript" src="${ctx}/js/common/syUtil.js"></script>
	<script type="text/javascript" src="${ctx}/js/common/ctutil.js"></script>
	<script type="text/javascript" src="${ctx}/js/common/jquery.json-2.4.js"></script>
	<script type="text/javascript" src="${ctx}/js/plugins/jquery/jquery.js"></script>
	<script type="text/javascript" src="${ctx}/js/plugins/bootstrap-3.0.3/js/bootstrap.min.js"></script>
	<script type="text/javascript" src="${ctx}/js/plugins/jstree/_lib/jquery.cookie.js"></script>
	<script type="text/javascript" src="${ctx}/js/plugins/jstree/_lib/jquery.hotkeys.js"></script>
	<link rel="stylesheet" type="text/css" href="${ctx}/js/plugins/jquery/uploadifive/uploadifive.css" />
	<script src="${ctx}/js/plugins/jquery/uploadifive/jquery.uploadifive.js"></script>
    <script type="text/javascript" src="${ctx}/js/plugins/My97DatePicker/WdatePicker.js"></script>
 
<script>
	var picIndex = 0;
	var nameCheckResult = "";
	var phoneCheckResult = "";
	var userCheckResult = "";
	var api = frameElement.api, W = api.opener;
	var str = /^[0-9]+(\.[0-9]+)?$/;
	var per = ${finance};

	
	
	function do_submit(){
		ajaxPost();
	}
	
	function ajaxPost(){
		var fee = $("#valuationFee").val();
		if(fee==""){
			alert("请输入估值");
			return;
		}
		$.ajax({
				cache: false,
				type: "POST",
				url:ctutil.bp()+"/loan/loanEval!doEvalute.action",
				data:{valuationFee:fee,tradeId:$("#tradeId").val()},
				async: false,
				error: function() {
				html = "数据请求失败";
				},
				success: function(data) {
				  if(data=="success"){
					  alert("保存成功！");
					  api.get("eval",1).close();
					  W.query1();
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
	<input type="hidden" name="tradeId" id="tradeId" value="${tradeId}" />
	<div class="box">
		<table>
			<tr><td>&nbsp;</td><td>&nbsp;</td></tr>
		    <tr>
		      <td colspan="2" style="text-align:center">
		      	${trade.vehicle.brandName}-${trade.vehicle.seriesName}-${trade.vehicle.kindName} ${trade.vehicle.registMonth} ${trade.vehicle.mileageCount}公里
		      </td>
		    </tr>
			<tr>
				<td class="text-r" width="100px">
					<font color="red">*</font>车辆估值：
				</td>
				<td width="400px">
					<input class="input w200" id="valuationFee"  name="trade.valuationFee" />万
				</td>
			</tr>
		</table>
	</div>
</form>
</body>
</html>
