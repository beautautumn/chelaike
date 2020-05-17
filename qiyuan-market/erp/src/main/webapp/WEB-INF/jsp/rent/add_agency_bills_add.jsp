<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@taglib uri="/struts-tags" prefix="s"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ include file="/common/taglibs.jsp"%>
<%@ include file="/common/meta.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>物业总费分摊</title>
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
	var agencyName;
	var jsonArr=new Array();
	var contractArea;
	//*************提交数据到父窗口*************************************
	function do_submit(){
     var api = frameElement.api, W = api.opener;
     var data ="";
     var areaId=$("#areaId").val();
     var agencyId=$("#agencyId").val();
     if(agencyId==0){
    	 alert("请选择分摊商户！");
    	 return;
     }
     var contractAreaId=$("#contractArea").val();
     if(contractAreaId==0){
    	 alert("请选择分摊区域！");
    	 return;
     }
     var startDate=$("#startDate").val();
     var endDate=$("#endDate").val();
     var feeValue=$("#feeValue").val();
     var remark=$("#remark").val();
    	var reg=new RegExp("'","g");
		var reg2=new RegExp('"',"g");
    	remark=remark.replace(reg,'%27');
    	remark=remark.replace(reg2,'%28');
		var reg3=new RegExp("\n","g");
	  	remark=remark.replace(reg3,'');
		if(remark.length>255){
    	 alert("分摊备注   过长！");
    	 return;
     }
     data+="[{'areaId':'"+areaId+"','agencyId':'"+agencyId+"','agencyName':'"+agencyName+"','contractAreaId':" +
    		 "'"+contractAreaId+"','contractArea':'"+contractArea+"','date':" +
     		"'"+startDate+"至"+endDate+"','feeValue':'"+feeValue+"','remark':'"+remark+"'}]";
     api.get('managerFee').insertByAdd(data);
   	 api.get("agencyBillsAdd",1).close();
    }
	
	//************选择商户后弹出页面选择合同---->返回合同Id****************
	function selectAgency(text){
	//一个商户对于一个合同，通过选择的商户ID查找对应的合同ID.
	    agencyName = text;
		var agencyId = $("#agencyId").val();
		$("#startDate").val("");
		$("#endDate").val("");
		$("#areaId").val("");
		while($("#contractArea").children().length>1){
			$("#contractArea").find("option").eq(1).remove();
		}
		if(agencyId==0){
			$("#startDate").val('');
			$("#endDate").val('');
			return;
		}
		getContractArea(agencyId);
	}
	//根据商户ID查询商户签署的所有场地区域
	function getContractArea(agencyId){
		$.ajax({
				cache: false,
				type: "POST",
				url:ctutil.bp()+"/rent/agencyBillsAction!findContractArea.action",
				data:"agencyId="+agencyId,
				async: false,
				error: function() {
				alert("发送请求失败！");
				},
				success: function(data) {
					if(data=='error'){
						alert("系统异常！");
					}else{
						jsonArr=eval(data);
						if(jsonArr.length>0){
							for(var j=0;j<jsonArr.length;j++){
								$("#contractArea").append("<option value='"+jsonArr[j].contractAreaId+"'>"+jsonArr[j].contractAreaName+"</option>");
							}
						}
					}
				}
			});
	}
	
	//************接收合同id----->查询合同时间*****************************
	function findContractDate(text){
		contractArea=text;
		var contractAreaId=$("#contractArea").val();
		if(contractAreaId==0){
			$("#startDate").val("");
			$("#endDate").val("");
			$("#areaId").val("");
			return;
		}
		for(var i=0;i<jsonArr.length;i++){
			if(jsonArr[i].contractAreaId==contractAreaId){
				$("#areaId").val(jsonArr[i].areaId);
				$("#startDate").val(jsonArr[i].startDate);
				$("#endDate").val(jsonArr[i].endDate);
			}
		}
	}
</script>
</head>
<body  style=" text-align:center">
<form id="myForm">	
<div class="box">
		<table>
			<tr>
				<input type="hidden" id="areaId" />
				<td>
					<table>	
						<tr>
							<td class="text-r" width="100">分摊商户：</td>
							<td>
								<select id="agencyId" class="input w200" onchange="selectAgency(this.options[this.selectedIndex].text)">
										<option value='0'>请选择</option>
									<s:iterator value="agencys">
										<option value="<s:property value='id'/>"><s:property value="agencyName"/></option>
									</s:iterator>
								</select>
							</td>
						</tr>
						<tr>
							<td class="text-r" width="100">分摊区域：</td>
							<td>
								<select id="contractArea" class="input w200" onchange="findContractDate(this.options[this.selectedIndex].text)">
										<option value='0'>请选择</option>
								</select>
							</td>
						</tr>
						<tr>
							<td class="text-r">合同有效期：</td>
							<td>
								<input type="text" id="startDate" style="width:91px;background-color:#F0F0F0" readonly="readonly" />
								&nbsp;-&nbsp;&nbsp;<input type="text" id="endDate" style="width:91px;background-color:#F0F0F0" readonly="readonly"/>
							</td>
						</tr>
						<tr>
							<td class="text-r">分摊数额：</td>
							<td><input id="feeValue" class="input w200" type="text"  onkeyup="value=value.replace(/[^(\d||/.)]/g,'')"/>元</td>
						</tr>
						<tr>
							<td class="text-r">分摊备注：</td>
							<td>
								<textarea id="remark" style="width: 300px; height:100px"></textarea>
							</td>
						</tr>
					</table>
				</td>
				<td></td>
			</tr>
		</table>
</form>					
</body>
</html>
