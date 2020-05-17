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

  $(document).ready(function(){
       $("#valuationDate").val(new Date().format('yyyy-MM-dd'));  
       $("#valuationFee").blur(function(){
			var price = $(this).val();
			if(price>0){
  	  			$("#valuationFee").val(parseFloat(price).toFixed(2));
				$("#financingMax").val((price*per).toFixed(2));
			}
       });
       $.ajax({
    	   type: "POST",
			url:ctutil.bp()+"/api/che300_getBrand.action",
			data:{},
			dataType:"JSON",
			success: function(data) {
			  var type = typeof(data);
			  if(type=="string"){
				  data =eval('(' + data + ')');
			  }
			  var brandList = data.brand_list;
			  var html="<option value=''>请选择</option>";
			  $.each(brandList,function(i,brand){
				  html+="<option value='"+brand.brand_id+"'>"+brand.brand_name+"</option>";
			  });
			  $("#brand").html(html);
			}
       });
	})
	
	
	function do_submit(){
	  var valuationFee = $("#valuationFee").val();
		if(!str.test(valuationFee)){
			$("#valuationFee").focus();
			alert("请评估车辆");
			return;
		}
		var data ="";
		data = $("#myForm").serialize();
		ajaxPost(data);
	}
	
	function ajaxPost(data){
		$.ajax({
				cache: false,
				type: "POST",
				url:ctutil.bp()+"/loan/loanEval!doLoanEvaluate.action",
				data:data,
				async: false,
				error: function() {
				html = "数据请求失败";
				},
				success: function(data) {
				  if(data=="success"){
					  alert("保存成功！");
					  api.get("loanEval",1).close();
					  W.query1();  
				  }else{
					  alert("保存失败,请重试！");
				  }
				}
			});
	}
	
	function getSeries(){
		var id = $("#brand").val();
		$.ajax({
			type:"get",
			url:ctutil.bp()+"/api/che300_getSeries.action",
			data:{brandId:id},
			dataType:"JSON",
			success:function(data){
				var html="<option value=''>请选择</option>";
				var init="<option value=''>请选择</option>";
				var seriesList = data.series_list;
				$.each(seriesList,function(i,series){
					html+="<option value='"+series.series_id+"'>"+series.series_name+"</option>";
				});
				$("#series").html(html);
				$("#model").html(init);
			}
		});
	}
	
	function getModel(){
		var id = $("#series").val();
		$.ajax({
			type:"get",
			url:ctutil.bp()+"/api/che300_getModel.action",
			data:{seriesId:id},
			dataType:"JSON",
			success:function(data){
				var html="<option value=''>请选择</option>"
				var modelList = data.model_list;
				$.each(modelList,function(i,model){
					var minYear = model.min_reg_year;
					var maxYear = model.max_reg_year;
					html+="<option value='"+model.model_id+"' min='"+minYear+"' max='"+maxYear+"'>"+model.model_name+"</option>";
				});
				$("#model").html(html);
			}
		});
	}
	
	function eval2(){
		var model_id = $("#model").val();
		var regist_month = $("#year").val();
		var mile_count = $("#mile").val();
		if(model_id==""){
			$("#model").focus();
			alert("请选择车型");
			return;
		}
		if(regist_month == ""){
			$("#regist").focus();
			alert("请选择上牌日期");
			return;
		}
		if(!str.test(mile_count)){
			$("#mile").focus();
			alert("请输入正确的行驶里程");
			$("#mile").val("");
			return;
		}
		$.ajax({
			type:"get",
			url:ctutil.bp()+"/api/che300_getUsedCarPrice.action",
			data:{modelId:model_id,regDate:regist_month,mile:mile_count,zone:11},
			dataType:"JSON",
			success:function(data){
				var status = data.status;
				var price = data.eval_price;
				if(status=="1"){
					if(price == "暂无报价"){
						alert(price);
					}else{
						$("#valuationFee").val(parseFloat(price).toFixed(2));
						$("#financingMax").val((price*per).toFixed(2));
					}
				}else{
					if(price == "暂无报价"){
						alert(price);
						$("#valuationFee").val("");
						$("#financingMax").val("");
					}else{
						alert("在线评估失败")
					}
				}
			}
		});
	}
	
	function initYear(){
		var model=$("#model").val();
		var min = $("#model option:selected").attr("min");
		var max = $("#model option:selected").attr("max");
		var html = "<option value =''>请选择</option>";
		for(var i = min;i<=max;i++){
			html+="<option value='"+i+"-01'>"+i+"</option>";
		}
		$("#year").html(html);
	}
	
</script>

</head>
<body>
<form id="myForm">
	<input type="hidden" name="tradeId" id="tradeId" value="${tradeId}" />
  <input type="hidden" name="financing.id" id="financing.id" value="${financing.id}" /> 	
	<div class="box">
		<table>
		    <tr>
		      <td colspan="2" style="text-align:center">
		      	${trade.vehicle.brandName}-${trade.vehicle.seriesName}-${trade.vehicle.kindName} ${trade.vehicle.registMonth} ${trade.vehicle.mileageCount}公里
		      </td>
		    </tr>
		    <tr>
		    	<td class="text-r" width="100px">
		    		<font color="red">*</font>品牌：
		    	</td>
		    	<td width="400px">
		    		<select id="brand" class="input w200" name="brand" onchange="getSeries();">
		    			<option value="">请选择</option>
		    		</select>
		    	</td>
		    </tr>
		    <tr>
		    	<td class="text-r" width="100px">
		    		<font color="red">*</font>车系：
		    	</td>
		    	<td width="400px">
		    		<select id="series" class="input w200" name="series" onchange="getModel();">
		    			<option value="">请选择</option>
		    		</select>
		    	</td>
		    </tr>
		    <tr>
		    	<td class="text-r" width="100px">
		    		<font color="red">*</font>车型：
		    	</td>
		    	<td width="400px">
		    		<select id="model" class="input w200" name="model" onchange="initYear()">
		    			<option value="">请选择</option>
		    		</select>
		    	</td>
		    </tr>
		    <tr>
		    	<td class="text-r" width="100px">
		    		<font color="red">*</font>上牌年份：
		    	</td>
		    	<td width="400px">
		    		<select id="year" class="w200">
		    			<option value="">请选择</option>
		    		</select>
		    	</td>
		    </tr>
		    <tr>
		    	<td class="text-r" width="100px">
		    		<font color="red">*</font>行驶里程：
		    	</td>
		    	<td width="400px">
		    		<input class="input w200" id="mile"  name=""   />万公里&nbsp;&nbsp;&nbsp;<input type="button" class="eval" onclick="eval2()" value="估价" style="color:blue;"/>
		    	</td>
		    </tr>
		    <tr><td>&nbsp;</td><td>&nbsp;</td></tr>
			<tr>
				<td class="text-r" width="100px">
					车辆估值：
				</td>
				<td width="400px">
					<input class="input w200" id="valuationFee"  name="valuationFee"   />万
					<font color="red">(估值来源：估值系统)</font>
				</td>
			</tr>
			<tr>
				<td class="text-r" width="100px">
					融资上限：
				</td>
				<td width="400px">
					<input class="input w200" id="financingMax" name="financingMax"  onchange="if(isNaN(this.value)){alert('请输入合法数字!');this.value='';$('#financingMax').focus();}"/>万
				</td>
			</tr>				 
			<tr>
				<td class="text-r" width="100px" >
					估值人：
				</td>
				<td width="400px">
					<select id="financing.staffByValuationStaff.id" class="input w200" name="financing.staffByValuationStaff.id">
					    <option value='0'>请选择</option>
						<s:iterator value="staffs">
						   <s:if test="id==staffId">
								<option value="<s:property value='id'/>" selected><s:property value="name"/></option>
						   </s:if>
						   <s:else>
						   		<option value="<s:property value='id'/>"><s:property value="name"/></option>
						   </s:else>
						</s:iterator>
				 	</select>
				</td>
			</tr>
	        <tr style="width:200px;height:35px;">
	            <td class="text-r" width="200px;">估值日期: &nbsp; </td>
	            <td width="200px;">
	              <input style="width:200px;height:25px;"  type="text"  id="valuationDate" name="financing.valuationDate"  onclick="WdatePicker()" />
	            </td>
	        </tr>
            <tr style="width:200px;height:90px;">
  				<td class="text-r" width="200px;" valign="top" style="padding-top:10">估值说明: &nbsp;&nbsp;&nbsp;</td>				
				<td>
				  <textarea name="financing.valuationDesc" id="financing.valuationDesc" style="width:200px;height:80px;"></textarea>
  				</td>
  		    </tr>  

		</table>
	</div>
</form>
</body>
</html>
