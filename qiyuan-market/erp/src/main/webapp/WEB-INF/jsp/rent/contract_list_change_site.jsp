<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@taglib uri="/struts-tags" prefix="s"%>
<%@ include file="/common/taglibs.jsp"%>
<%@ include file="/common/meta.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>选择场地区域</title>
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
	var reg = /^[0-9]+(\.[0-9]+)?$/; 
	var regFloat=/^[0-9]+(\.[0-9]+)?$/; 
	
	$(function(){
		$("#areaNoAll").val('+${areaNoAll}+');
		getChange();
  	
  	});
	function getChange(){
		$("#sitearea option").each(function(){
			if($(this).attr('selected')=='selected'){
	  			if($(this).attr('renttype')=='0'){
	  				$("#totalCountText").html("区域总面积：");
	  				$("#freeCountText").html("可租用面积：");
	  				$("#monthRentFeeText").html("月平米租金：<span class='red'>*</span>");
	  				$("#leaseCountText").html("租用面积：<span class='red'>*</span>");
	  				$("#totalCount").val($(this).attr('totalcount'));
	  				$("#freeCount").val($(this).attr('freecount'));
	  				$("#monthRentFee").val($(this).attr('monthrentfee'));
	  				$("#leaseCount").val('');
	  				$("#monthTotalFee").val('');
	  				$("#areaNo").val('');
	  				$("#carCount").val('').prop("readonly", false).removeAttr("disabled").css("background-color","");
	  				

	  			}
	  			if($(this).attr('renttype')=='1'){
	  				$("#totalCountText").html("区域单位数：");
	  				$("#freeCountText").html("可租用单位数：");
					$("#monthRentFeeText").html("月单位租金：<span class='red'>*</span>");
	  				$("#leaseCountText").html("租用单位：<span class='red'>*</span>");
	  				$("#totalCount").val($(this).attr('totalcount'));
	  				$("#freeCount").val($(this).attr('freecount'));
	  				$("#monthRentFee").val($(this).attr('monthrentfee'));
	  				$("#leaseCount").val('');
	  				$("#monthTotalFee").val('');
	  				$("#areaNo").val('');
	  				$("#carCount").val('0').prop("readonly", true).attr("disabled", "disabled").css("background-color","F0F0F0");
	  			}
			
			}
		
		});
	
	}
	function getMonthTotalFee(){
		if($("#siteArea option:selected").attr('renttype')=='0'){
			if($("#leaseCount").val()==''){
				alert("租用面积不能为空");
				return;
			}else{
				if(!reg.test($("#leaseCount").val())){
	            	alert("租用面积必须是正整数，请重新输入");
	            	return ;
	            }else{
	            	if(parseInt($("#leaseCount").val())>parseInt($("#freeCount").val())){
	            		alert("租用面积超过可租用面积，请重新输入");
	            		return ;
	            	}
	            }
			}
		}else{
			if($("#leaseCount").val()==''){
				alert("租用单位不能为空");
				return;
			}else{
				if(!reg.test($("#leaseCount").val())){
	            	alert("租用单位必须是正整数，请重新输入");
	            	return ;
	            }else{
	            	if(parseInt($("#leaseCount").val())>parseInt($("#freeCount").val())){
	            		alert("租用单位超过可租用单位，请重新输入");
	            		return ;
	            	}else{
	            		$("#carCount").val($("#leaseCount").val()*parseInt($("#siteArea option:selected").attr('carcount')));
	            	}
	            }
			}
		}
		$("#monthTotalFee").val((parseFloat($("#leaseCount").val())*parseFloat($("#monthRentFee").val())).toFixed(2));
		
		
	}
	function getMonthRentFee(){
		if($("#siteArea option:selected").attr('renttype')=='0'){
			if($("#monthRentFee").val()==''){
				alert("月平米租金不能为空");
				return;
			}else{
				if(!regFloat.test($("#monthRentFee").val())){
	            	alert("月平米租金必须是正整数或者小数，请重新输入");
	            	return ;
	            }
			}
		}else{
			if($("#monthRentFee").val()==''){
				alert("月单位租金不能为空");
				return;
			}else{
				if(!regFloat.test($("#monthRentFee").val())){
	            	alert("月单位租金必须是正整数或者小数，请重新输入");
	            	return ;
	            }
			}
			
		}
		$("#monthRentFee").val(parseFloat($("#monthRentFee").val()).toFixed(2));
		if($("#leaseCount").val()==''){
			return;
		}else{
			if(!reg.test($("#leaseCount").val())){
	            	alert("租用单位必须是正整数，请重新输入");
	            	return ;
	            }else{
	            	if(parseInt($("#leaseCount").val())>parseInt($("#freeCount").val())){
	            		alert("租用单位超过总单位，请重新输入");
	            		return ;
	            	}
	            }
		}
		$("#monthTotalFee").val((parseFloat($("#leaseCount").val())*parseFloat($("#monthRentFee").val())).toFixed(2));
		
	}
	
	function getAreaNo(){
		
		if($("#areaNo").val()==''){
			alert("场地编号不能为空");
			return;
		}else{
	       	if(checkAreaNo()){
	       		alert("场地编号与之前操作的场地编号有重复，请重新输入");
	            return ;
	       	}
		}
	        	
	}
	
	function getCarCount(){
		if($("#carCount").val()==''||$("#carCount").val()=='0'){
			alert("车位数不能为空");
			return;
		}else{
			if(!reg.test($("#carCount").val())){
	            alert("车位数必须是正整数，请重新输入");
	            return ;
	        }
		}
	}

	function checkAreaNo(){
	
		var flag=false;
		var areaNoList= $("#areaNoAll").val().split(",");
		for(var i=0;i<areaNoList.length;i++){
			if(parseInt($("#areaNo").val())==parseInt(areaNoList[i])){
				flag = true;
			}
		}
		return flag;
	}
	
	
	function do_submit(){
		var areaNoList= $("#areaNoAll").val().split(",");
		
		if($("#siteArea option:selected").val()=='-1'){
			alert("请选择场地区域");
			return;
		}
		if($("#siteArea option:selected").attr('renttype')=='0'){
		
			if($("#totalCount").val()==''){
				alert("区域总面积不能为空");
				return;
			}else{
				if(!reg.test($("#totalCount").val())){
	            	alert("区域总面积必须是整数，请重新输入");
	            	return ;
	            }
			}
			if($("#monthRentFee").val()==''){
				alert("月平米租金不能为空");
				return;
			}else{
				if(!regFloat.test($("#monthRentFee").val())){
	            	alert("月平米租金必须是整数或者小数，请重新输入");
	            	return ;
	            }
			}
			if($("#leaseCount").val()==''){
				alert("租用面积不能为空");
				return;
			}else{
				if(!reg.test($("#leaseCount").val())){
	            	alert("租用面积必须是整数，请重新输入");
	            	return ;
	            }else{
	            	if(parseInt($("#leaseCount").val())>parseInt($("#freeCount").val())){
	            		alert("租用面积超过可租用面积，请重新输入");
	            		return ;
	            	}
	            }
			}
			if($("#carCount").val()==''||$("#carCount").val()=='0'){
				alert("车位数不能为空");
				return;
			}else{
				if(!reg.test($("#carCount").val())){
	            	alert("车位数必须是整数，请重新输入");
	            	return ;
	        	}
			}
		}else{
			if($("#totalCount").val()==''){
				alert("区域单位数不能为空");
				return;
			}else{
				if(!reg.test($("#totalCount").val())){
	            	alert("区域单位数必须是整数，请重新输入");
	            	return ;
	            }
			}
			if($("#monthRentFee").val()==''){
				alert("月单位租金不能为空");
				return;
			}else{
				if(!regFloat.test($("#monthRentFee").val())){
	            	alert("月单位租金必须是整数或者小数，请重新输入");
	            	return ;
	            }
			}
			if($("#leaseCount").val()==''){
				alert("租用单位不能为空");
				return;
			}else{
				if(!reg.test($("#leaseCount").val())){
	            	alert("租用单位必须是整数，请重新输入");
	            	return ;
	            }else{
	            	if(parseInt($("#leaseCount").val())>parseInt($("#freeCount").val())){
	            		alert("租用面积超过可租用单位，请重新输入");
	            		return ;
	            	}
	            }
			}
			if($("#carCount").val()==''||$("#carCount").val()=='0'){
				alert("车位数不能为空，请输入租用单位，车位数会根据租用单位自动计算");
				return;
			}else{
				if(!reg.test($("#carCount").val())){
	            	alert("车位数必须是整数，请重新输入");
	            	return ;
	        	}
			}
		}
		if($("#monthTotalFee").val()==''){
			alert("月租金不能为空");
			return;
		}
		if($("#areaNo").val()==''){
			alert("场地编号不能为空");
			return;
		}else{
	       	if(checkAreaNo()){
	       		alert("场地编号与之前操作的场地编号有重复，请重新输入");
	            return ;
	       	}
		}
		
		var date=$("#siteArea option:selected").attr('areaname')+","+
				 $("#siteArea option:selected").attr('renttype')+","+
				 $("#totalCount").val()+","+
				 $("#monthRentFee").val()+","+
				 $("#leaseCount").val()+","+
				 $("#monthTotalFee").val()+","+
				 $("#areaNo").val()+","+
				 $("#carCount").val()+","+$("#siteArea").val();

		api.get('changeContractPage').doGetSitePage(date);
   		api.get("getChangeSitePage",1).close();
	}
</script>

</head>
<body>
<form id="myForm">	
<div style="text-align:center;margin-top:20px;margin-left:60px;">
			<input type="hidden" id="areaNoAll" name="areaNoAll"/>
  			<table>
  				
  				<tr style="width:500px;">
  					<td class="text-r" width="100px;">场地区域：<span class="red">*</span></td>
  					<td width="150px;">
  						<select id="siteArea" class="input w100" name="siteArea" onchange="getChange()">
			   				<option value='-1' >请选择</option>
							<s:iterator value="siteAreas">
								<option value="<s:property value='id'/>" id="${id}"
									areaname="${areaName}" renttype="${rentType}" 
									totalcount="${totalCount}" monthrentfee="${monthRentFee/100}"  carcount="${carCount}" freeCount="${freeCount}" >
									${areaName}
								</option>
							</s:iterator>
                   		</select>
  					</td>
  				</tr>
  				<tr style="width:500px;">
  					<td class="text-r" width="100px;">&nbsp;</td>
  				</tr>
  				<tr style="width:500px;">
  					<td id="totalCountText" class="text-r" style="width:100px;" >区域总面积：</td>
  					<td class="text-l" width="200px;">
  						<input type="text" id="totalCount" name="totalCount" style="background-color:#F0F0F0"  readonly="readonly" disabled="disabled" ></input>
  					</td>
  				</tr>
  				<tr style="width:500px;">
  					<td class="text-r" width="100px;">&nbsp;</td>
  				</tr>
  				<tr style="width:500px;">
  					<td id="freeCountText" class="text-r" style="width:100px;" >可租用面积：</td>
  					<td class="text-l" width="200px;">
  						<input type="text" id="freeCount" name="freeCount" style="background-color:#F0F0F0"  readonly="readonly" disabled="disabled" ></input>
  					</td>
  				</tr>
  				<tr style="width:500px;">
  					<td class="text-r" width="100px;">&nbsp;</td>
  				</tr>
  				<tr style="width:500px;">
  					<td id="monthRentFeeText" class="text-r" style="width:100px;" >月平米租金：<span class="red">*</span></td>
  					<td class="text-l" width="200px;">
  						<input type="text" id="monthRentFee" name="monthRentFee" onblur="javascript:getMonthRentFee()">&nbsp;元</input>
  					</td>
  				</tr>
  				<tr style="width:500px;">
  					<td class="text-r" width="100px;">&nbsp;</td>
  				</tr>
  				<tr style="width:500px;">
  					<td id="leaseCountText" class="text-r" style="width:100px;" >租用面积：<span class="red">*</span></td>
  					<td class="text-l" width="200px;">
  						<input type="text" id="leaseCount" name="leaseCount" onblur="javascript:getMonthTotalFee()"></input>
  					</td>
  				</tr>
  				<tr style="width:500px;">
  					<td class="text-r" width="100px;">&nbsp;</td>
  				</tr>
  				<tr style="width:500px;">
  					<td class="text-r" style="width:100px;" >月租金：<span class="red">*</span></td>
  					<td class="text-l" width="200px;">
  						<input type="text" id="monthTotalFee" style="background-color:#F0F0F0"  readonly="readonly" 
							disabled="disabled" name="monthTotalFee">&nbsp;元</input>
  					</td>
  				</tr>
  				<tr style="width:500px;">
  					<td class="text-r" width="100px;">&nbsp;</td>
  				</tr>
                <tr style="width:500px;">
                  <td class="text-r" style="width:100px;" id='portName'>场地编号：<span class="red">*</span></td>
                  <td class="text-l" width="200px;">
                    <textarea style="width:135px;height:40px"  id="areaNo" name="areaNo"  onkeyup="if(/[;]/.test(this.value)){var str = this.value;this.value =str.substring(0,str.length-1)}" ></textarea>
                  </td>
                </tr>
  				<tr style="width:500px;">
  					<td class="text-r" width="100px;">&nbsp;</td>
  				</tr>
  				<tr style="width:500px;">
  					<td class="text-r" style="width:100px;" >车位数：<span class="red">*</span></td>
  					<td class="text-l" width="200px;">
  						<input type="text"id="carCount" name="carCount" onblur="javascript:getCarCount()">&nbsp;个</input>
  					</td>
  				</tr>
  				
  				
  			</table>
  		</div>
	
</form>					
</body>
</html>
