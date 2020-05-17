<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ include file="/common/taglibs.jsp"%>
<%@ include file="/common/meta.jsp"%>
<%@taglib uri="/struts-tags" prefix="s" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
  <title></title>	
	<link rel="stylesheet" type="text/css" href="${ctx}/css/style.css" />
	<link rel="stylesheet" type="text/css" href="${ctx}/js/plugins/lhgdialog/skins/mac.css" />
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
  </head>
  <script >
     function do_submit(){
     var s=<%=session.getAttribute("")%>;
     var api = frameElement.api, W = api.opener;
     var data = new Array();
     var feeItemId = $("#feeItemId").val();
     if(feeItemId==0){
     alert("请选择费用科目");
     return;
     }else{
     data[0]=feeItemId;
     }
     var feeValue = $("#feeValue").val();
     if(feeValue==''){
     	alert("请填写金额");
     	return;
     }
     if(feeValue>100000){
     alert("填写费用金额过大，请重填");
     return;
     }else{
     data[1]=feeValue;
     }
	 var staff=$("#staffId").val();
	 if(staff==0){
	 alert("请选择计费人");
	 return;
	 }else{
	 data[2]=staff;
	 }    
	 var recvTime=$("#recvTime").val();
	 if(recvTime==''){
	 alert("请选择计费日期");
	 return;
	 }else{
	 data[3]=recvTime;
	 } 
     var remark =$("#remark").val();
     if(remark==''){
     remark='';
     }
     if(remark.length>200){
	 alert("备注不得查过200字,请重新填写"); 
	 return;    
     }else{
     data[4]=remark;
     }
     api.get('rectFeePage').do_get_agencybill(data);
   	 api.get("addFee",1).close();
     }
  </script>
  <body>
  	<form id="">
  		<td ><input type="hidden" name="name" id="name" value="${name}" /></td>
  		<div style="text-align:center;margin-top:20px;">
  			<table>
  				<tr style="width:500px;">
  					<td class="text-r" width="100px;">费用科目:</td>
  					<td width="150px;">
  					<select id="feeItemId"  name="feeItemId" style="width:150px;">
								<option value='0'>请选择</option>
							<s:iterator value="feeItems">
								<option value="<s:property value="id"/>,<s:property value="itemName"/>"><s:property value="itemName"/></option>
							</s:iterator>
					</select>
  					</td>
  					<td class="text-r" style="width:300px;" >费用金额:
  						<input   value="${contractBean.everyRecvFee }" id="feeValue" name="feeValue" onkeyup="value=value.replace(/[^(\d||/.)]/g,'')" />元
  					</td>
  				</tr>
  				<tr style="width:500px;height:50px;">
  					<td class="text-r" width="100px;">计费人:</td>
  					<td width="150px;">
  					<select id="staffId"  name="staffId" style="width:150px;">
								<option value='0'>请选择</option>
							<s:iterator value="staffs">
								<option value="<s:property value="id"/>,<s:property value="name"/>"><s:property value="name"/></option>
							</s:iterator>
					</select>
  					</td>
  					<td class="text-r" style="width:300px;" >计费日期:
						<input type="text" value="${date}" id="recvTime" name="startDate"  onclick="WdatePicker()" onblur="setEndDate();"/>
  					</td>
  				</tr>
  			</table>
  		</div>
  		<br/>
  		<div style="text-align:center;">
  			<table>
  				<tr style="width:500px;height:120px;">
  					<td class="text-r" width="100px;">费用备注:
  					</td>
  					<td class="text-r" >
					<textarea name="remark"   id="remark" style="width:450px;height:120px"></textarea>
  					</td>
  				</tr>
  			</table>
  		</div>
  	</form>
  </body>
</html>