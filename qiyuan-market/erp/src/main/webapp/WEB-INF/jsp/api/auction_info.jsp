<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"
	language="java"%>
<%@taglib uri="/struts-tags" prefix="s"%>
<%@ include file="/common/taglibs.jsp"%>
<%@ include file="/common/meta.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
		<title>拍卖商品信息</title>
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


<style>
	ul{list-style:none;}
	ul li{float: left;width: 220px;margin: 0px 12px;display: inline;}
	ul li .t{display: block;width: 202px;height:200px;border: 1px #dbdbdb solid;text-align: center;padding: 8px;font-size: 12px;font-family: "Microsoft YaHei";margin-bottom: 10px;}
	.pz-area{margin-bottom:4px;}
	body{padding-top:0;}

</style>
<script type="text/javascript">
 	 //var api = frameElement.api, W = api.opener;

   $(document).ready(function(){
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
                          $('#kind').combobox('clear');  
                          var url = ctutil.bp()+"/sys/comm!getSeriesList.action?brandId="+rec.id;      
                          $('#series').combobox('reload', url);  
                          $('#brandName').val(rec.name); 
                   }
               });

       $('#series').combobox({
               panelHeight:400,
               editable:false,
               url:ctutil.bp()+"/sys/comm!getSeriesList.action?brand=0",    
               valueField:'id',    
               textField:'name',
               onSelect: 
                   function(rec){   
                          $('#kind').combobox('clear');  
                          var url = ctutil.bp()+"/sys/comm!getKindList.action?seriesId="+rec.id;      
                          $('#kind').combobox('reload', url);  
                          $('#seriesName').val(rec.name); 
                   }
               });   
               
       $('#kind').combobox({
               panelHeight:400,
               editable:false,
               onSelect: 
                   function(rec){   
                       $('#kindName').val(rec.name); 
                   }
               }); 
               
        //车辆数据回显到界面
        $('#brand').combobox('setValue','${vehicle.brand.id}');  
        
        var url = ctutil.bp()+"/sys/comm!getSeriesList.action?brandId=${vehicle.brand.id}";      
        $('#series').combobox('reload', url);  
        $('#series').combobox('setValue','${vehicle.series.id}');  
        
        var url1 = ctutil.bp()+"/sys/comm!getKindList.action?seriesId=${vehicle.series.id}";      
        $('#kind').combobox('reload', url1);  
        $('#kind').combobox('setValue','${vehicle.kind.id}');  
        $('#brandName').val('${vehicle.brandName}');
        $('#seriesName').val('${vehicle.seriesName}');
        $('#kindName').val('${vehicle.kindName}');
              
        $('#carColor').combobox('setValue','${vehicle.carColor}');
        $('#upholsteryColor').combobox('setValue','${vehicle.upholsteryColor}');
        $('#outputVolume').combobox('setValue','${vehicle.outputVolume}');
		//init_attaches();
   });

   function init_attaches() {
      var picList = eval('${pics}');   
      if(picList != undefined) {
        for(i=0; i < picList.length; i++) {
			var pic = picList[i];
            var html = rebuild_display_html(pic.showOrder, pic.picAddr, "", pic.picId, pic.showOrder);
			$("#li_new").before(html);
		}
	  }
   }
   function rebuild_display_html(show_order, pic_addr, display_name, pic_id, show_tag)
    {
        var html = "";
        html += "<li id='li_"+ pic_id +"'><div class='t'>" +
                  "<span>" +
                    "<img src='"+ pic_addr +"'/>" +
                  "</span>" + display_name + "</div>" +
                  "<div class='fl'>";
        var first_pic_id = "setFirstPic_" + pic_id;
        return html;
    }
   
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
               
	/*function do_submit()
	{	
	  $("#kindName").val($("#kind").combobox('getText'));
	  $("#seriesName").val($("#series").combobox('getText'));
	  $("#brandName").val($("#brand").combobox('getText'));
	  
		var data = $("#myForm").serialize();		
		ajaxPost(data);
	}*/
	
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
							<!--<input class="input w200" id="trade.agency.agencyName" name="trade.agency.agencyName" value="${trade.agency.agencyName}" style="background-color:#F0F0F0"/>-->
							<label>${trade.agency.agencyName}</label>
						</td>
						<td class="text-r"  width="100px">
							条码编号:
						</td>
						<td width="200px" >
							<!--<input class="input w200" id="trade.barCode" name="trade.barCode" value="${trade.barCode}" style="background-color:#F0F0F0"/>-->
							<label>${trade.barCode}</label>
						</td>
					</tr>
          <tr>
      			<td class="text-r" width="100px" id="feeMeter">
							品牌:
						</td>
            <td >
 	            <!--<input class="easyui-combobox" style="width:200px;" id="brand" name="vehicle.brand.id" data-options="required:true,valueField:'id',textField:'name'" />-->
				<label>${vehicle.brand.name}</label>
					  </td>						 
      			<td class="text-r" width="100px" id="feeMeter">
							车系:
						</td>
            <td >
 	            <!--<input class="easyui-combobox"  style="width:200px;"  id="series" name="vehicle.series.id" data-options="required:true,valueField:'id',textField:'name'" />-->
				<label>${vehicle.series.name}</label>
					  </td>		
      			<td class="text-r" width="100px" id="feeMeter">
							车型:
						</td>
            <td >
 	            <!--<input class="easyui-combobox"  style="width:200px;"  id="kind" name="vehicle.kind.id" data-options="required:true,valueField:'id',textField:'name'" />-->
				<label>${vehicle.kind.name}</label>
					  </td>							
					</tr>
					<tr>
						<td class="text-r"  width="100px">
							车架号:
						</td>
						<td width="200px"  >
							<!--<input class="input w200 easyui-validatebox" data-options="required:true,missingMessage:'请输入车架号'" id="vehicle.shelfCode" name="vehicle.shelfCode" value="${vehicle.shelfCode}" />-->
							<label>${vehicle.shelfCode}</label>
						</td>		
						<td class="text-r"  width="100px">
							车牌号:
						</td>
						<td width="200px" >
							<!--<input class="input w200" id="trade.oldLicenseCode" name="trade.oldLicenseCode" value="${trade.oldLicenseCode}" />-->
							<label>${trade.oldLicenseCode}</label>
						</td>				 
						<td class="text-r"  width="100px">
							发动机号:
						</td>
						<td width="200px" >
							<!--<input class="input w200" id="vehicle.engineNumber" name="vehicle.engineNumber" value="${vehicle.engineNumber}" />-->
							<label>${vehicle.engineNumber}</label>
						</td>							
					</tr>
					<tr>
						<td class="text-r"  width="100px">
							公里数:
						</td>
						<td width="200px" >
							<!--<input class="input w200" style="width:160px;" id="mileageCount" name="vehicle.mileageCount" value="${vehicle.mileageCount}" />-->
							<label>${vehicle.mileageCount}</label>公里
						</td>							
						<td class="text-r"  width="100px">
							排量:
						</td>
						<td width="200px" >
							<!--<input class="easyui-combobox" style="width:120px;" id="outputVolume" name="vehicle.outputVolume" data-options="panelHeight:400,valueField: 'value',textField: 'label',data:outputVolumeA" required="true"/>-->
							<label>${vehicle.outputVolume}</label>
							<c:choose>
								<c:when test="${vehicle.outputVolumeU==1}">
									T
								</c:when>
								<c:otherwise>
									L
								</c:otherwise>
							</c:choose>
						</td>						
						<td class="text-r"  width="100px">
							首次上牌:
						</td>
						<td width="200px" >
							<label>${vehicle.registMonth}</label>
						</td>	
				
					</tr>
					
					<tr>
						<td class="text-r"  width="100px">
							车身颜色:
						</td>
						<td width="200px" >
							<!--<input class="easyui-combobox" style="width:200px;" id='carColor' name="vehicle.carColor" data-options="valueField: 'value',textField: 'label',data:carColorA" required="true"/>-->
							<label>${vehicle.carColor}</label>
						</td>					
						<td class="text-r"  width="100px">
							内饰颜色:
						</td>
						<td width="200px" >
							<!--<input class="easyui-combobox"  style="width:200px;" id="upholsteryColor" name="vehicle.upholsteryColor" data-options="valueField: 'value',textField: 'label',data:upholsteryColorA" required="true"/>-->
							<label>${vehicle.upholsteryColor}</label>
						</td>	
						<td class="text-r"  width="100px">
							变速箱:
						</td>
						<td width="200px" >
						  <!--<s:radio list="#{'0':'手动','1':'自动','2':'手自一体','3':'其他'}" id="gearType" name="vehicle.gearType" theme="simple" />-->
						  <label><c:choose>
							<c:when test="${vehicle.gearType=='0'}">手动</c:when>
							<c:when test="${vehicle.gearType=='1'}">自动</c:when>
							<c:when test="${vehicle.gearType=='2'}">手自一体</c:when>
							<c:when test="${vehicle.gearType=='3'}">其它</c:when>
						  </c:choose></label>
						</td>		
					</tr>
					<tr>
						<td class="text-r"  width="100px">
							环保标准:
						</td>					  
				    <td>
				      <!--<s:radio list="#{'0':'国1','1':'国2','2':'国3','3':'国4','4':'国5'}" id="envLevel" name="vehicle.envLevel" theme="simple"></s:radio>&nbsp;&nbsp;-->
					  <label><c:choose>
							<c:when test="${vehicle.envLevel=='0'}">国1</c:when>
							<c:when test="${vehicle.envLevel=='1'}">国2</c:when>
							<c:when test="${vehicle.envLevel=='2'}">国3</c:when>
							<c:when test="${vehicle.envLevel=='3'}">国4</c:when>
							<c:when test="${vehicle.envLevel=='4'}">国5</c:when>
						  </c:choose></label>
				    </td>
						<td class="text-r"  width="100px">
							出厂日期:
						</td>
						<td width="200px" >
						<!--<input class="date w200 easyui-validatebox" value="<fmt:formatDate value="${vehicle.factoryDate}"
							pattern="yyyy-MM-dd"/>" id="factoryDate" name="vehicle.factoryDate" onclick="WdatePicker({lang:'zh-cn'});"
							data-options="required:true,missingMessage:'请选择出厂日期',validType:['minLength[1]']"/>				-->		
							<label><fmt:formatDate value="${vehicle.factoryDate}" pattern="yyyy-MM-dd"/></label>
					  </td>					
						<td class="text-r"  width="100px">
							车身类型:
						</td>					  
				    <td>
				      <!--<s:radio list="#{'0':'轿车','1':'跑车','2':'越野车','3':'商务车'}" name="vehicle.vehicleType"	id="vehicleType" theme="simple"></s:radio>-->
					  <label><c:choose>
							<c:when test="${vehicle.vehicleType=='0'}">轿车</c:when>
							<c:when test="${vehicle.vehicleType=='1'}">跑车</c:when>
							<c:when test="${vehicle.vehicleType=='2'}">越野车</c:when>
							<c:when test="${vehicle.vehicleType=='3'}">商务车</c:when>
						  </c:choose></label>
				    </td>
					</tr>
					<tr>
						<td class="text-r"  width="100px">
							交强险:
						</td>
						<td width="200px" >
              <!--<input id="issurValidDate" class="date w200 easyui-validatebox"	data-options="required:true,missingMessage:'请选择交强险到期日',validType:['minLength[1]']"
							  name="vehicle.issurValidDate" value="${vehicle.issurValidDate}"
							  onclick="WdatePicker({lang:'zh-cn', dateFmt:'yyyy-MM'});"/>-->					  
							  <label>${vehicle.issurValidDate}</label>
					  </td>	
						<td class="text-r"  width="100px">
							年审到期:
						</td>
						<td width="200px" >
						   <!--<input class="date w200 easyui-validatebox" id="checkValidMonth" name="vehicle.checkValidMonth"
							  	data-options="required:true,missingMessage:'请选择年审到期',validType:['minLength[1]']"
								  value="${vehicle.checkValidMonth}" onclick="WdatePicker({lang:'zh-cn', dateFmt:'yyyy-MM'});" />-->
								  <label>${vehicle.checkValidMonth}</label>
					  </td>							
						<td class="text-r"  width="100px">
							商业险日期:
						</td>
						<td width="200px" >
					  	<!--<input id="commIssurValidDate" class="date w200 easyui-validatebox"	name="vehicle.commIssurValidDate" value="${vehicle.commIssurValidDate}"
							  data-options="required:true,missingMessage:'请选择商业险到期',validType:['minLength[1]']"
							  onclick="WdatePicker({lang:'zh-cn', dateFmt:'yyyy-MM'});"/>-->
							  <label>${vehicle.commIssurValidDate}</label>
					  </td>										
					</tr>
					<tr>
						<td class="text-r"  width="100px">
							使用性质:
						</td>					  
				    <td>
  						<!--<s:radio list="#{'0':'非营运','1':'营运','2':'营转非'}" id="usedType" name="vehicle.usedType" theme="simple"></s:radio>-->
						<label><c:choose>
							<c:when test="${vehicle.usedType=='0'}">非运营</c:when>
							<c:when test="${vehicle.usedType=='1'}">运营</c:when>
							<c:when test="${vehicle.usedType=='2'}">营转非</c:when>
						  </c:choose></label>
				    </td>						
						<td class="text-r"  width="100px">
							新车价格:
						</td>
						<td width="200px" >
							<!--<input class="input w200"  style="width:180px;" id="vehicle.newcarPrice" name="vehicle.newcarPrice" value="${vehicle.newcarPrice}" />元-->
							<label>${vehicle.newcarPrice}元</label>
						</td>		
						<td class="text-r"  width="100px"></td>
						<td width="200px"></td>
						<%-- <td class="text-r"  width="100px">
							收购价格:
						</td>
						<td width="200px" >
							<!--<input class="input w200"  style="width:180px;" id="trade.acquPrice" name="trade.acquPrice" value="${trade.acquPrice}" />元-->
							<label>${trade.acquPrice}元</label>
						</td>				     --%>
					</tr>
					<tr>
					   <td class="text-r" width="180">车况描述:</td>
             <td colspan="5">
                 <p name="vehicle.condDesc" id="condDesc" style="width:200px">${vehicle.condDesc}</p>
             </td>
					</tr>
					<tr>
						<td class="text-r" width="180">车辆图片:</td>
						<td colspan="5">
							<ul>
								<c:forEach var="pic" items="${vehiclePic}" varStatus="sta">
									<li id='li_${pic.id}'>
										<div class='t'>
											<span><img height="100%" width="100%" src='${pic.picUrl}'/></span>
										</div>
									</li>
								</c:forEach>
							</ul>
						</td>
					</tr>
				</table>
			</div>
		</form>
	</body>
</html>
