<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@taglib uri="/struts-tags" prefix="s"%>
<%@ include file="/common/taglibs.jsp"%>
<%@ include file="/common/meta.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>修改系统参数</title>
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
	var api = frameElement.api, W = api.opener;
	var reg=/0|^[1-9]\d{0,20}$/;
	
	function checkIntValue(){
		if(!reg.test($("#intValue").val())){
	         alert("系统参数值必须是正整数或者0，请重新输入");
	         return ;
	   }
	
	}
	
	
	function do_submit(){
		if(!reg.test($("#intValue").val())){
	         alert("系统参数值必须是正整数或者0，请重新输入");
	         return ;
	   }
	
		var data = "";
		data = $("#myForm").serialize();
		

		$.ajax({
				cache: false,
				type: "POST",
				url:ctutil.bp()+"/sys/params_list_updateParams.action",
				data:data,
				async: false,
				error: function() {
				html = "数据请求失败";
				},
				success: function(data) {
				  if(data=="success"){
					  alert("保存成功！");
					  api.get("updateParamsPage", 1).close();
					  W.query1();  //刷新副页面
				  }else{
					  alert("保存失败！");
					  api.get("updateParamsPage", 1).close();
				  }
				}
			});
	}
	
	
	
</script>

</head>
<body>
	<form id="myForm">	
		<div style="text-align:center;margin-top:20px;margin-left:60px;">
			<input type="hidden" id="id" name="paramsBean.id" value="${params.id}"/>
  			<table>
  				<tr style="width:500px;">
  					<td id="totalCountText" class="text-r" style="width:100px;" >系统参数名称：</td>
  					<td class="text-l" width="200px;">
  						<s:if test="params.paramName=='contract_first_recv_over'">
  							<input type="text" id="paramName" name="paramsBean.paramName" value="合同首次收款期限" style="background-color:#F0F0F0"  readonly="readonly" ></input>
  						
  						</s:if>
  						<s:if test="params.paramName=='contract_continue_recv_over'">
  						  	<input type="text" id="paramName" name="paramsBean.paramName" value="合同中途收款期限" style="background-color:#F0F0F0"  readonly="readonly" ></input>
  						</s:if>
  						<s:if test="params.paramName=='contract_normal_recv_over'">
  						  	<input type="text" id="paramName" name="paramsBean.paramName" value="合同正常收款到期期限" style="background-color:#F0F0F0"  readonly="readonly" ></input>
  						</s:if>
  						<s:if test="params.paramName=='contract_continue_remind'">
  						  	<input type="text" id="paramName" name="paramsBean.paramName" value="已收款合同后续提醒时间" style="background-color:#F0F0F0"  readonly="readonly" ></input>
  						</s:if>
  						<s:if test="params.paramName=='contract_normal_recv_remind'">
  						  	<input type="text" id="paramName" name="paramsBean.paramName" value="合同到期提醒时间" style="background-color:#F0F0F0"  readonly="readonly" ></input>
  						</s:if>
  						<s:if test="params.paramName=='nothing'">
  						  	<input type="text" id="paramName" name="paramsBean.paramName" value="不应该显示的参数" style="background-color:#F0F0F0"  readonly="readonly" ></input>
  						</s:if>
  						<s:if test="params.paramName=='evaluate_persent'">
  						  	<input type="text" id="paramName" name="paramsBean.paramName" value="融资车辆出场风险系数" style="background-color:#F0F0F0"  readonly="readonly" ></input>
  						</s:if>
  						
  					</td>
  				</tr>
  				<tr style="width:500px;">
  					<td class="text-r" width="100px;">&nbsp;</td>
  				</tr>
  				<tr style="width:500px;">
  					<td class="text-r" style="width:100px;" >系统参数值:<span class="red">*</span></td>
  					<td class="text-l" width="200px;">
  						<c:choose>
  							<c:when test="${params.paramName=='evaluate_persent' }">
  								<input type="text" id="intValue"  name="paramsBean.intValue" value="${params.intValue}" onblur="checkIntValue();">&nbsp;%</input>
  							</c:when>
  							<c:otherwise>
  								<input type="text" id="intValue"  name="paramsBean.intValue" value="${params.intValue}" onblur="checkIntValue();">&nbsp;天</input>
  							</c:otherwise>
  						</c:choose>
  					</td>
  				</tr>
  				<tr style="width:500px;">
  					<td class="text-r" width="100px;">&nbsp;</td>
  				</tr>
  				
  				
  			</table>
  		</div>
	</form>					
</body>
</html>
