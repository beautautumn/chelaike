<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"
	language="java"%>
<%@taglib uri="/struts-tags" prefix="s"%>
<%@ include file="/common/taglibs.jsp"%>
<%@ include file="/common/meta.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
		<title>车辆信息修改</title>
		<link rel="stylesheet" type="text/css" href="${ctx}/css/style.css" />
		<script type="text/javascript" src="${ctx}/js/common/syUtil.js"></script>
		<script type="text/javascript" src="${ctx}/js/common/ctutil.js"></script>
		<script type="text/javascript" src="${ctx}/js/common/jquery.json-2.4.js"></script>
		<script type="text/javascript" src="${ctx}/js/plugins/jquery/jquery.js"></script>
		<script type="text/javascript" src="${ctx}/js/plugins/bootstrap-3.0.3/js/bootstrap.min.js"></script>
		<script type="text/javascript" src="${ctx}/js/plugins/jstree/_lib/jquery.cookie.js"></script>
		<script type="text/javascript" src="${ctx}/js/plugins/jstree/_lib/jquery.hotkeys.js"></script>
		
		<link rel="stylesheet" type="text/css" 	href="${ctx}/js/plugins/jquery/uploadifive/uploadifive.css" />
   	<link rel="stylesheet" type="text/css" href="${ctx}/js/plugins/jquery-easyui/themes/default/easyui.css" />
	  <link rel="stylesheet" type="text/css" href="${ctx}/js/plugins/jquery-easyui/themes/icon.css" />
	  <link rel="stylesheet" type="text/css" href="${ctx}/js/plugins/jquery-easyui/demo/demo.css" />
	  
	  <script type="text/javascript" src="${ctx}/js/plugins/jquery-easyui/jquery-1.6.min.js"></script>
	  <script type="text/javascript" src="${ctx}/js/plugins/jquery-easyui/jquery.easyui.min.js"></script>



<script type="text/javascript">
 	 var api = frameElement.api, W = api.opener;

   $(document).ready(function(){
	   $("#barCode").blur(function(){
		   var value = $(this).val();
		   if(value != ""){
			   $.ajax({
				   type:"get",
				   url:ctutil.bp()+"/carin/vehicleInput!checkBarCode.action",
				   data:{barCode:value},
				   dataType:"json",
				   success:function(data){
					   if(data){
						   alert("条码编号重复，请重新录入");
						   $(".barCode").focus();
					   }
				   }
			   });
		   }
	   });
       if('${vehicle.outputVolumeU}' ==1)
       {
         $("#outputVolumeU").attr("checked",true);
       }
      $('#brand').combobox({
               panelHeight:400,
               editable:false,
               url:ctutil.bp()+"/sys/comm!getBrandList.action",
               valueField:'id',
               textField:'name',
               groupField:'group',
               onSelect:
                   function(rec){
                          $('#series').combobox('clear');
                          $('#kind').combobox("loadData",[]);
                          $('#kind').combobox('clear');
                          var url = ctutil.bp()+"/sys/comm!getSeriesList.action?brandId="+rec.id;
                          $('#series').combobox('reload', url);
                          $('#series').combobox("setValue","");
                          $('#brandName').val("");
                   }
               });

      $('#brand').combobox('setValue','${vehicle.brand.id}');
       $('#series').combobox({
               panelHeight:400,
               editable:false,
               url:ctutil.bp()+"/sys/comm!getSeriesList.action?brandId=${vehicle.brand.id}",
               valueField:'id',
               textField:'name',
               onLoadSuccess:function(){
            	   /* if($("#brand").combobox('getText')=="${vehicle.brand.id}" && $("#brandName").val()!=""){ */
            	   if("${vehicle.brand.id}"!=""){
            		   if($("#brand").combobox('getText')=="${vehicle.brand.name}" || $("#brand").combobox('getText')=="${vehicle.brand.id}"){
	                 	   $('#series').combobox('setValue','${vehicle.series.id}');
            		   }else{
            			   $('#series').combobox('clear');
            		   }
            	   }else{
            		   $('#series').combobox('clear');
            	   }
               },
               onSelect:
                   function(rec){
                          $('#kind').combobox('clear');
                          var url = ctutil.bp()+"/sys/comm!getKindList.action?seriesId="+rec.id;
                          $('#kind').combobox('reload', url);
                          $('#seriesName').val("");
                   }
               });
               
       $('#kind').combobox({
               panelHeight:400,
               editable:false,
               url:ctutil.bp()+"/sys/comm!getKindList.action?seriesId=${vehicle.series.id}",
               valueField:'id',
               textField:'name',
               onLoadSuccess:function(){
            	   /* if($("#series").combobox('getText')=="${vehicle.series.name}" && $("#seriesName").val()!=""){ */
            	   if("${vehicle.series.name}"!=""){
            		   if($("#series").combobox('getText')=="${vehicle.series.name}"){
	                       $('#kind').combobox('setValue','${vehicle.kind.id}');
            		   }else{
            			   $('#kind').combobox('clear');
            		   }
            	   }else{
            		   $('#kind').combobox('clear');
            	   }
               },
               onSelect:
                   function(rec){
                       $('#kindName').val(rec.name);
                   }
               });

        //车辆数据回显到界面
        /* $('#brand').combobox('setValue','${vehicle.brand.id}'); */
        

        /* var url = ctutil.bp()+"/sys/comm!getSeriesList.action?brandId=${vehicle.brand.id}"; */
        /* $('#series').combobox('reload', url); */

        /* var url1 = ctutil.bp()+"/sys/comm!getKindList.action?seriesId=${vehicle.series.id}"; */
        /* $('#kind').combobox('reload', url1); */
        $('#brandName').val('${vehicle.brandName}');
        $('#seriesName').val('${vehicle.seriesName}');
        $('#kindName').val('${vehicle.kindName}');

        $('#carColor').combobox('setValue','${vehicle.carColor}');
        $('#upholsteryColor').combobox('setValue','${vehicle.upholsteryColor}');
        $('#outputVolume').combobox('setValue','${vehicle.outputVolume}');
        
   });
   
   function onChk(a){
     if(a.checked)
     {
       a.value=1;
     }
     else
     {
       a.value=0;
     }
   }
   
   var carColorA=[{"label": "黑色","value": "黑色"},{"label": "白色","value": "白色"}
              ,{"label": "红色","value": "红色"},{"label": "紫色","value": "紫色"}
              ,{"label": "灰色","value": "灰色"},{"label": "蓝色","value": "蓝色"}
              ,{"label": "橙色","value": "橙色"},{"label": "银色","value": "银色"}
              ,{"label": "绿色","value": "绿色"},{"label": "黄色","value": "黄色"}
              ,{"label": "棕色","value": "棕色"},{"label": "米色","value": "米色"}
              ,{"label": "金色","value": "金色"},{"label": "褐色","value": "褐色"}
              ,{"label": "其它","value": "其它"}
            ];
   var upholsteryColorA=[{"label": "双色","value": "双色"},{"label": "米黄","value": "米黄"}
              ,{"label": "米灰","value": "米灰"},{"label": "红色","value": "红色"}
              ,{"label": "黑色","value": "黑色"},{"label": "棕色","value": "棕色"}
            ];
   var outputVolumeA=[{"label":"1.0","value":"1.0"},{"label":"1.2","value":"1.2"},
               {"label":"1.4","value":"1.4"},{"label":"1.6","value":"1.6"},
               {"label":"1.8","value":"1.8"},{"label":"2.0","value":"2.0"},
               {"label":"2.2","value":"2.2"},{"label":"2.4","value":"2.4"},
               {"label":"3.0","value":"3.0"},{"label":"4.0","value":"4.0"}
               ];
               
	function do_submit()
	{	
	  $("#kindName").val($("#kind").combobox('getText'));
	  $("#seriesName").val($("#series").combobox('getText'));
	  $("#brandName").val($("#brand").combobox('getText'));
	  var shelf=$("#shelfCode").val();
	  if(shelf==""){
		  alert("请输入车架号！");
		  return;
	  }
	  
		var data = $("#myForm").serialize();		
		ajaxPost(data);
	}
	
	function ajaxPost(data2){
	  var url1 =ctutil.bp()+"/carin/vehicleInput!doVehicleInfo.action";
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
					  api.get("vehicleInfo",1).close();
					  W.query1();  
				  }else{
					  alert("保存失败,请重试！");
				  }
				}
			});
	}       
	
	function checkShelfCode(){
		var shelfCode = $("#shelfCode").val();
		var tradeId = ${tradeId}
		$.ajax({
			url:ctutil.bp()+"/carin/vehicleInput!checkShelfCode.action",
			data:{shelfCode:shelfCode,type:"edit",tradeId:tradeId},
			type:"post",
			success:function(data){
				if(data=='true'){
				   alert("车架号重复，请重新录入");
				   $("#shelfCode").focus();
				}
			}
		});
	}
               
               
</script>

</head>
<body>
		<form id="myForm">
		  <input type='hidden' id="vehicle.id" name="vehicle.id" value="${vehicle.id}" />
		  <input type='hidden' id="trade.id" name="trade.id"  value="${trade.id}"/>			
			<input type='hidden' id="brandName" name="vehicle.brandName" />
			<input type='hidden' id="seriesName" name="vehicle.seriesName" />
			<input type='hidden' id="kindName" name="vehicle.kindName" />
			<div class="box">
				<table>
					<tr>
						<td class="text-r" width="100px" id="areaTotal">
							商户名称:
						</td>
						<td width="100px">
							<input class="input w200" id="trade.agency.agencyName" name="trade.agency.agencyName" value="${trade.agency.agencyName}" readonly="readonly" style="background-color:#F0F0F0"/>
						</td>
						<td class="text-r"  width="100px">
							条码编号:
						</td>
						<td width="200px" >
							<input class="input w200" id="barCode" name="trade.barCode" value="${trade.barCode}"/>
						</td>
						<td class="text-r"  width="100px">
							寄卖车辆：
						</td>
						<td width="200px" >
							<s:radio list="#{'0':'否','1':'是'}" name="trade.consignTag"	id="consignTag" theme="simple"></s:radio>
						</td>
					</tr>
          <tr>
      			<td class="text-r" width="100px" id="feeMeter">
							品牌:
						</td>
            <td >
 	            <input class="easyui-combobox" style="width:200px;" id="brand" name="vehicle.brand.id" data-options="valueField:'id',textField:'name'" />
					  </td>						 
      			<td class="text-r" width="100px" id="feeMeter">
							车系:
						</td>
            <td >
 	            <input class="easyui-combobox"  style="width:200px;"  id="series" name="vehicle.series.id" data-options="valueField:'id',textField:'name'" />
					  </td>		
      			<td class="text-r" width="100px" id="feeMeter">
							车型:
						</td>
            <td >
 	            <input class="easyui-combobox"  style="width:200px;"  id="kind" name="vehicle.kind.id" data-options="valueField:'id',textField:'name'" />
					  </td>							
					</tr>
					<tr>
						<td class="text-r"  width="100px">
							车架号:
						</td>
						<td width="200px"  >
							<input class="input w200 easyui-validatebox" data-options="required:true,missingMessage:'请输入车架号'" id="shelfCode" name="vehicle.shelfCode" value="${vehicle.shelfCode}" onblur="checkShelfCode()" />
						</td>		
						<td class="text-r"  width="100px">
							车牌号:
						</td>
						<td width="200px" >
							<input class="input w200" id="trade.oldLicenseCode" name="trade.oldLicenseCode" value="${trade.oldLicenseCode}" />
						</td>				 
						<td class="text-r"  width="100px">
							发动机号:
						</td>
						<td width="200px" >
							<input class="input w200" id="vehicle.engineNumber" name="vehicle.engineNumber" value="${vehicle.engineNumber}" />
						</td>							
					</tr>
					<tr>
						<td class="text-r"  width="100px">
							公里数:
						</td>
						<td width="200px" >
							<input class="input w200" style="width:160px;" id="mileageCount" name="vehicle.mileageCount" value="${vehicle.mileageCount}" />公里
						</td>							
						<td class="text-r"  width="100px">
							排量:
						</td>
						<td width="200px" >
							<input class="easyui-combobox" style="width:120px;" id="outputVolume" name="vehicle.outputVolume" data-options="panelHeight:400,valueField: 'value',textField: 'label',data:outputVolumeA"/>
							<input type="checkbox" id="outputVolumeU" name="vehicle.outputVolumeU" onclick="onChk(this);" value="${vehicle.outputVolumeU}" />涡轮增压
						</td>						
						<td class="text-r"  width="100px">
							首次上牌:
						</td>
						<td width="200px" >
					  	<input id="registMonth" class="date w200 easyui-validatebox"	name="vehicle.registMonth" value="${vehicle.registMonth}"
							  data-options="validType:['minLength[1]']"
							  onclick="WdatePicker({lang:'zh-cn', dateFmt:'yyyy-MM'});"/>
						</td>	
				
					</tr>
					
					<tr>
						<td class="text-r"  width="100px">
							车身颜色:
						</td>
						<td width="200px" >
							<input class="easyui-combobox" style="width:200px;" id='carColor' name="vehicle.carColor" data-options="valueField: 'value',textField: 'label',data:carColorA"/>
						</td>					
						<td class="text-r"  width="100px">
							内饰颜色:
						</td>
						<td width="200px" >
							<input class="easyui-combobox"  style="width:200px;" id="upholsteryColor" name="vehicle.upholsteryColor" data-options="valueField: 'value',textField: 'label',data:upholsteryColorA"/>
						</td>	
						<td class="text-r"  width="100px">
							变速箱:
						</td>
						<td width="200px" >
						  <s:radio list="#{'manual':'手动','auto':'自动','manual_automatic':'手自一体','other':'其他'}" id="gearType" name="vehicle.gearType" theme="simple" />
						</td>		
					</tr>
					<tr>
						<td class="text-r"  width="100px">
							环保标准:
						</td>					  
				    <td>
				      <s:radio list="#{'guo_1':'国1','guo_2':'国2','guo_3':'国3','guo_4':'国4','guo_5':'国5'}" id="envLevel" name="vehicle.envLevel" theme="simple"></s:radio>&nbsp;&nbsp;
				    </td>
						<td class="text-r"  width="100px">
							出厂日期:
						</td>
						<td width="200px" >
						<input class="date w200 easyui-validatebox" value="<fmt:formatDate value="${vehicle.factoryDate}"
							pattern="yyyy-MM-dd"/>" id="factoryDate" name="vehicle.factoryDate" onclick="WdatePicker({lang:'zh-cn'});"
							data-options="validType:['minLength[1]']"/>						
					  </td>					
						<td class="text-r"  width="100px">
						</td>					  
					    <td>
					    </td>
					</tr>
					<tr>
						<td class="text-r"  width="100px">
							交强险:
						</td>
						<td width="200px" >
              <input id="issurValidDate" class="date w200 easyui-validatebox"	data-options="validType:['minLength[1]']"
							  name="vehicle.issurValidDate" value="${vehicle.issurValidDate}"
							  onclick="WdatePicker({lang:'zh-cn', dateFmt:'yyyy-MM'});"/>					  
					  </td>	
						<td class="text-r"  width="100px">
							年审到期:
						</td>
						<td width="200px" >
						   <input class="date w200 easyui-validatebox" id="checkValidMonth" name="vehicle.checkValidMonth"
							  	data-options="validType:['minLength[1]']"
								  value="${vehicle.checkValidMonth}" onclick="WdatePicker({lang:'zh-cn', dateFmt:'yyyy-MM'});" />
					  </td>							
						<td class="text-r"  width="100px">
							商业险日期:
						</td>
						<td width="200px" >
					  	<input id="commIssurValidDate" class="date w200 easyui-validatebox"	name="vehicle.commIssurValidDate" value="${vehicle.commIssurValidDate}"
							  data-options="validType:['minLength[1]']"
							  onclick="WdatePicker({lang:'zh-cn', dateFmt:'yyyy-MM'});"/>
					  </td>										
					</tr>
					<tr>
						<td class="text-r"  width="100px">
							使用性质:
						</td>					  
				    <td>
  						<s:radio list="#{'personal_use':'非营运','business_use':'营运','b2p_use':'营转非','rental_use':'公户'}" id="usedType" name="vehicle.usedType" theme="simple"></s:radio>
				    </td>						
						<td class="text-r"  width="100px">
							新车价格:
						</td>
						<td width="200px" >
							<input class="input w200"  style="width:180px;" id="vehicle.newcarPrice" name="vehicle.newcarPrice" value="${vehicle.newcarPrice}" />元
						</td>		
						<td class="text-r"  width="100px">
							收购价格:
						</td>
						<td width="200px" >
							<input class="input w200"  style="width:180px;" id="trade.acquPrice" name="trade.acquPrice" value="${trade.acquPrice}" />元
						</td>				    
					</tr>
					<tr>
						<td class="text-r"  width="100px">
							现售价:
						</td>					  
				    <td>
  						<input class="input w200"  style="width:180px;" id="trade.showPrice" name="trade.showPrice" value="${trade.showPrice}" />元
				    </td>						
						<td class="text-r"  width="100px">
						</td>
						<td width="200px" >
						</td>		
						<td class="text-r"  width="100px">
						</td>
						<td width="200px" >
						</td>				    
					</tr>
					<tr>
					   <td class="text-r" width="180">车况描述:</td>
             <td colspan="5">
                 <textarea name="vehicle.condDesc" id="condDesc" style="width:500px" class="pz-area">${vehicle.condDesc}</textarea>
             </td>
					</tr>
				</table>
			</div>
		</form>
	</body>
</html>
