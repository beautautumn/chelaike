<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@taglib uri="/struts-tags" prefix="s"%>
<%@ include file="/common/taglibs.jsp"%>
<%@ include file="/common/meta.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>新增其他费用</title>
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
<script type="text/javascript" src="${ctx}/js/plugins/My97DatePicker/WdatePicker.js"></script>
<script>
	var api = frameElement.api, W = api.opener;
	var reg = /^[1-9]\d{0,20}$/;
	var regFloat=/^[0-9]+(\.[0-9]+)?$/; 
	Date.prototype.format =function(format){
		var o = {
		"M+" : this.getMonth()+1, //month
		"d+" : this.getDate(), //day
		"h+" : this.getHours(), //hour
		"m+" : this.getMinutes(), //minute
		"s+" : this.getSeconds(), //second
		"q+" : Math.floor((this.getMonth()+3)/3), //quarter
		"S" : this.getMilliseconds() //millisecond
		}
		if(/(y+)/.test(format)) format=format.replace(RegExp.$1,
		(this.getFullYear()+"").substr(4- RegExp.$1.length));
		for(var k in o)if(new RegExp("("+ k +")").test(format))
		format = format.replace(RegExp.$1,
		RegExp.$1.length==1? o[k] :
		("00"+ o[k]).substr((""+ o[k]).length));
		return format;
	}
	
	
	function getChange(){
		$("#contractId option").each(function(){
			if($(this).attr('selected')=='selected'){
				if($(this).attr('myrow')=='1'){
				
					$("#otherRecvFee").val(parseFloat($(this).attr('otherrecvfee')).toFixed(2));
	  				$("#otherFeeDesc").val($(this).attr('otherfeedesc'));
				}else{
					$("#otherRecvFee").val('');
	  				$("#otherFeeDesc").val('');
				
				}
				
	  			
			}
		
		});
	}
	function checkFee(){
		if($("#otherRecvFee").val()==''){
			alert("费用金额不能为空");
			return;
		}else{
			if(!regFloat.test($("#otherRecvFee").val())){
				alert("费用金额必须是0或者正数");
				return;
			}else{	
				$("#otherRecvFee").val(parseFloat($("#otherRecvFee").val()).toFixed(2));
			}
		}
	}
		
	function do_submit(){
		if($("#contractId").val()=='-1'){
			alert("请选择合同！");
			return;
		}
		if($("#otherRecvFee").val()==''){
			alert("费用金额不能为空");
			return;
		}else{
			if(!regFloat.test($("#otherRecvFee").val())){
				alert("费用金额必须是0或者正数");
				return;
			}else{	
				$("#otherRecvFee").val(parseFloat($("#otherRecvFee").val()).toFixed(2));
			}
		}
		if($("#otherFeeDesc").val().length>255){
			alert("清算说明过长！");
			return;
		}
		var data = "";
		data = $("#myForm").serialize();
		
		$.ajax({
				cache: false,
				type: "POST",
				url:ctutil.bp()+"/rent/agent_dealOtherFee.action",
				data:data,
				async: false,
				error: function() {
				html = "数据请求失败";
				},
				success: function(data) {
				  if(data=="success"){
					  alert("保存成功！");
					  api.get("other_agent", 1).close();
					  W.query1();  //刷新副页面
				  }else{
					  alert("保存失败！");
					  api.get("other_agent", 1).close();
				  }
				}
			});
	}
		
  	
  
	
	
</script>

</head>
<body>
<form id="myForm">	
<div style="text-align:center;margin-top:20px;margin-left:60px;">
  			<table>
  				<tr style="width:400px;">
  					<td class="text-r" width="100px;">选择合同：<span class="red">*</span></td>
  					<td width="150px;">
  						<select id="contractId" class="input w200" name="contractId"  onchange="getChange()">
			   				<option value='-1' myrow="0">请选择</option>
							<s:iterator value="contracts">
								<option value="<s:property value='id'/>" myrow="1" otherrecvfee="${otherRecvFee/100}" otherfeedesc="${otherFeeDesc}" >
									<fmt:formatDate value="${startDate}"   pattern="yyyy-MM-dd"  /> ~<fmt:formatDate value="${endDate}"   pattern="yyyy-MM-dd"  /> 
								</option>
							</s:iterator>
                   		</select>
  					</td>
  				</tr>
  				<tr style="width:400px;">
  					<td class="text-r" width="100px;">&nbsp;</td>
  				</tr>
  				<tr style="width:400px;">
  					<td class="text-r" style="width:100px;" >费用金额：<span class="red">*</span></td>
  					<td class="text-l" width="150px;">
  						<input type="text"  id="otherRecvFee" name="otherRecvFee" onblur="checkFee()" />&nbsp;元
  					</td>
  				</tr>
  				<tr style="width:400px;">
  					<td class="text-r" width="100px;">&nbsp;</td>
  				</tr>
  				<tr style="width:400px;">
  					<td id="totalCountText" class="text-r" style="width:100px;" >费用说明：</td>
  					<td class="text-l" width="150px;">
  						<textarea  id="otherFeeDesc" name="otherFeeDesc" style="width:200px" height="200px"></textarea>
  					</td>
  				</tr>
  			</table>
  		</div>
  		
	
</form>					
</body>
</html>
