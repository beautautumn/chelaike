<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@taglib uri="/struts-tags" prefix="s"%>
<%@ include file="/common/taglibs.jsp"%>
<%@ include file="/common/meta.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>商户清算</title>
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
	$(function(){
		$("#clearingStartDate").val(new Date().format('yyyy-MM-dd'));
		
		$("#staffByClearingStartStaff option").each(function(){
  			if($(this).val()=='${currentStaffId}'){
  				$(this).attr('selected',true);
  			}
  		});
		
	});
		
	function do_submit(){
		if($("#clearingReason").val()=='-1'){
			alert("请选择清算原因！");
			return;
		}
		if($("#clearingDesc").val().length>255){
			alert("清算说明过长！");
			return;
		}
		var data = "";
		data = $("#myForm").serialize();
		$.ajax({
				cache: false,
				type: "POST",
				url:ctutil.bp()+"/rent/contractListAction!countContract.action",
				data:data,
				async: false,
				error: function() {
				html = "数据请求失败";
				},
				success: function(data) {
				  if(data=="success"){
					  alert("保存成功！");
					  api.get("countContractPage", 1).close();
					  W.query1();  //刷新副页面
				  }else if(data=="error"){
					  alert("保存失败！");
					  api.get("countContractPage", 1).close();
				  }else{
					  alert(data);
					  api.get("countContractPage", 1).close();
				  }
				}
			});
	}
		
  	
  
	
	
</script>

</head>
<body>
<form id="myForm">	
<div style="text-align:center;margin-top:20px;margin-left:60px;">
			<input type="hidden" id="contractId" name="contractId" value="${contractId}"></input>
  			<table>
  				<tr style="width:400px;">
  					<td class="text-r" width="100px;">清算原因：<span class="red">*</span></td>
  					<td width="150px;">
  						<select id="clearingReason" class="input w150" name="contractBean.clearingReason.id">
			   				<option value='-1' >请选择</option>
							<s:iterator value="reasons">
								<option value="<s:property value='id'/>"  >
									${name}
								</option>
							</s:iterator>
                   		</select>
  					</td>
  				</tr>
  				<tr style="width:400px;">
  					<td class="text-r" width="100px;">&nbsp;</td>
  				</tr>
  				<tr style="width:400px;">
  					<td id="totalCountText" class="text-r" style="width:100px;" >清算日期：</td>
  					<td class="text-l" width="150px;">
  						<input type="text" id="clearingStartDate" name="contractBean.clearingStartDate" style="background-color:#F0F0F0"  readonly="readonly"  ></input>
  					</td>
  				</tr>
  				<tr style="width:400px;">
  					<td class="text-r" width="100px;">&nbsp;</td>
  				</tr>
  				<tr style="width:400px;">
  					<td class="text-r" width="100px;">清算发起人：<span class="red">*</span></td>
  					<td width="150px;">
  						<select id="staffByClearingStartStaff" class="input w100" name="contractBean.staffByClearingStartStaff.id">
			   				<option value='-1' >请选择</option>
							<s:iterator value="staffs">
								<option value="<s:property value='id'/>"  >
									${name}
								</option>
							</s:iterator>
                   		</select>
  					</td>
  				</tr>
  				<tr style="width:400px;">
  					<td class="text-r" width="100px;">&nbsp;</td>
  				</tr>
  				<tr style="width:400px;">
  					<td id="totalCountText" class="text-r" style="width:100px;" >清算说明：</td>
  					<td class="text-l" width="150px;">
  						<textarea  id="clearingDesc" name="contractBean.clearingDesc" style="width:200px" height="200px"></textarea>
  					</td>
  				</tr>
  			</table>
  		</div>
  		
	
</form>					
</body>
</html>
