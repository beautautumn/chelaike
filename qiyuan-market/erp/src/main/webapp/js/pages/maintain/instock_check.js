/**
*入库质检的函数
*/
instock_check=(function(){

	var _isomerism_quality_maintain_items=function(item_list){
			var result=[];
			console.log("the item_list is :%o",item_list);
			for(var i=0;i<item_list.length;i++){
				var itemSubList=item_list[i].itemSubList;
				//console.log("the itemSubList is :%o",itemSubList);
				for(var j=0;j<itemSubList.length;j++){
					var item=new Object();
					item.itemName=itemSubList[j].itemName;
					item.itemCode=itemSubList[j].itemCode;
					item.itemType=item_list[i].type;
					item.checkDesc=itemSubList[j].checkDesc;
					item.materialFee=itemSubList[j].materialFee;
					item.laborFee=itemSubList[j].laborFee;
					item.laborHours=itemSubList[j].laborHours;
					result.push(item);
				}
			}
			return result;
	};

	var _get_checked_matain_items=function(){
		var chk_value=[];
  		$('input[name="quality_check"]:checked').each(function(){  
   			chk_value.push($(this).val());  
  		}); 
  		return chk_value;
	};


	var _get_quality_maintain_item_list=function(){
			var chk_value=_get_checked_matain_items();
			var maintainItems=[];
  			console.log("the chk_value is %o",chk_value);   			
  			if(chk_value.length>0){
  				for(var i=0;i<chk_value.length;i++){
  					var maintainItem=new Object;
  					maintainItem.itemCode=chk_value[i];
  					maintainItem.itemType=parseInt($("#item_type_"+chk_value[i]).val());
  					maintainItem.itemName=$("#item_name_"+chk_value[i]).html();
  					maintainItem.checkDesc=$("#check_desc_"+chk_value[i]).html();
  					maintainItem.laborFee=parseInt($("#labor_fee_"+chk_value[i]).val());
					maintainItem.materialFee=parseInt($("#material_fee_"+chk_value[i]).val());
					maintainItem.laborHours=parseInt($("#labor_hours_"+chk_value[i]).val());

					var reg = /[\r\n]/g; 
					maintainItem.itemName=maintainItem.itemName.replace(reg,""); 
					maintainItem.checkDesc=maintainItem.checkDesc.replace(reg,""); 
					reg = /\s/g;
					maintainItem.itemName=maintainItem.itemName.replace(reg,""); 
					maintainItem.checkDesc=maintainItem.checkDesc.replace(reg,""); 					
					maintainItems.push(maintainItem);
  				}
  			}	
  			return maintainItems;	
	};

	var _set_quality_matin_fee=function(){
			var chk_value=_get_checked_matain_items();
			var laborFee=0;
			var materialFee=0;
			var laborHours=0;
  			console.log("the chk_value is %o",chk_value);   			
  			if(chk_value.length>0){
  				for(var i=0;i<chk_value.length;i++){
  					laborFee+=parseInt($("#labor_fee_"+chk_value[i]).val());
					materialFee+=parseInt($("#material_fee_"+chk_value[i]).val());
					laborHours+=parseInt($("#labor_hours_"+chk_value[i]).val());					
					
  				}
  			}	
  			$("#repairHoursFee").val(laborFee);	
  			$("#repairMaterialFee").val(materialFee);	
  			$("#sumRepairtFee").val(materialFee+laborFee);
	};

	var _get_isomerism_hotsport_items=function(item_list){
		var items=_get_isomerism_quality_maintain_items();	
		var result=[];
		for(var i=0;i<items.length;i++){
			if(items[i].type==0||items[i].type==1||items[i].type==2||items[i].type==3){
				result.push(items[i]);
			}
		}
		return result;
	};

	var _verify_material_fee=function(){
		var items=_get_isomerism_quality_maintain_items();
		for(var i=0;i<items.length;i++){
			if(items[i].materialFee==""){
				return "请填写材料费、";
			}
		}
		return "";

	};

	var _verify_labor_fee=function(){
		var items=_get_isomerism_quality_maintain_items();
		for(var i=0;i<items.length;i++){
			if(items[i].laborFee==""){
				return "请填写工时费、";
			}
		}
		return "";
	};	

	var _verify_labor_hours=function(){
		var items=_get_isomerism_quality_maintain_items();
		for(var i=0;i<items.length;i++){
			if(items[i].laborHours==""){
				return "请填写工时、";
			}
		}
		return "";
	};		

	var _get_isomerism_quality_maintain_items=function(){
		var items=_get_quality_maintain_items();
		return _isomerism_quality_maintain_items(items);
	};

	var _get_material_fee=function(){
		var sum_fee=0;
		var items=_get_isomerism_quality_maintain_items();
		for(var i=0;i<items.length;i++){
			if(items[i].materialFee!=""){
				sum_fee+=parseInt(items[i].materialFee);
			}
		}
		return sum_fee;
	};

	var _get_labor_fee=function(){
		var sum_fee=0;
		var items=_get_isomerism_quality_maintain_items();
		for(var i=0;i<items.length;i++){
			if(items[i].laborFee!=""){
				sum_fee+=parseInt(items[i].laborFee);
			}
		}
		return sum_fee;
	};		
	var _get_quality_maintain_items=function(){
			var items=[];
			var condition_tb=document.getElementById("repairItems");
        	
        	var item;
        	for(var i=1;i<condition_tb.rows.length;i++) {        		
        		var rowspan=condition_tb.rows[i].cells[0].getAttribute("rowspan");
        		//console.log("the rowspan is :%s",rowspan);
        		if(rowspan>0){
        			item=new Object();
                	var types=condition_tb.rows[i].getAttribute("name").split("_");
                	var typeName=condition_tb.rows[i].cells[0].innerHTML;
                	item.type=types[1];
                	item.typeName=typeName;  
                	var itemSubList=[];
                	//console.log("the type is %s",item.type,"typeName is :%s",typeName);
                	
                	var itemSubObject=new Object(); 	
                	var itemName=condition_tb.rows[i].cells[1].innerHTML;
                	var inputs=condition_tb.rows[i].cells[2].getElementsByTagName("input")[0].getAttribute("id").split("_");
                	itemSubObject.itemName=itemName;
                	itemSubObject.itemCode=inputs[1];
                	//console.log("the itemCode is %s",item.itemCode,"itemName is :%s",itemName);
                	var checkDesc=condition_tb.rows[i].cells[2].getElementsByTagName("input")[0].value;
                	itemSubObject.checkDesc=checkDesc;
					var laborFee=condition_tb.rows[i].cells[3].getElementsByTagName("input")[0].value; 
					itemSubObject.laborFee=laborFee; 
					var materialFee=condition_tb.rows[i].cells[4].getElementsByTagName("input")[0].value; 
					itemSubObject.materialFee=materialFee;   
					var laborHours=condition_tb.rows[i].cells[5].getElementsByTagName("input")[0].value;   
					itemSubObject.laborHours=laborHours; 
					itemSubList.push(itemSubObject); 
					item.itemSubList=itemSubList;  
					items.push(item);   	      			
        		}else{
                	var itemSubObject=new Object(); 	
                	var itemName=condition_tb.rows[i].cells[0].innerHTML;
                	var inputs=condition_tb.rows[i].cells[1].getElementsByTagName("input")[0].getAttribute("id").split("_");
                	itemSubObject.itemCode=inputs[1];
                	itemSubObject.itemName=itemName;
                	var checkDesc=condition_tb.rows[i].cells[1].getElementsByTagName("input")[0].value;
                	itemSubObject.checkDesc=checkDesc;
					var laborFee=condition_tb.rows[i].cells[2].getElementsByTagName("input")[0].value; 
					itemSubObject.laborFee=laborFee;
					var materialFee=condition_tb.rows[i].cells[3].getElementsByTagName("input")[0].value; 
					itemSubObject.materialFee=materialFee;  
					var laborHours=condition_tb.rows[i].cells[4].getElementsByTagName("input")[0].value;   
					itemSubObject.laborHours=laborHours; 
					item.itemSubList.push(itemSubObject);
        		}                 	
        	} 
        return items;
	};	
		
	

	var _get_result_json=function(subType,staffId,rightCode){
		console.log("the rightCode is %s",rightCode);
		var passengerNum=$("#passengerNum").val();
		var transferTag=$("#transferTag").val();
		var gearsTypeTag=$("input[name='gearsTypeTag']:checked").val();
		var evalItem=$("#evalItem").val();
		var acquisitionId=$("#hdAcquisitionId").val();
		var phoneNumber=$("#phoneNumber").val();
		var commIssurValidTag=$("#commIssurValidTag").val();
		var otherAttachment=$("#otherAttachment").val();
		var maintRecordTag=$("input[name='maintRecordTag']:checked").val();
		var purchaseTaxTag=$("input[name='purchaseTaxTag']:checked").val();
		var licenseCodeTag=$("input[name='licenseCodeTag']:checked").val();
		var toolBoxTag;
		if($("#toolBoxTag").get(0).checked){
			toolBoxTag=1;
		}else{
			toolBoxTag=0;
		}
		var issurValidTag=$("input[name='issurValidTag']:checked").val();
		var ashtrayTag;
		if($("#ashtrayTag").get(0).checked){
			ashtrayTag=1;
		}else{
			ashtrayTag=0;
		}
		var checkValidMonth=$("#checkValidMonth").val();
		var cigarLighterTag;
		if($("#cigarLighterTag").get(0).checked){
			cigarLighterTag=1;
		}else{
			cigarLighterTag=0;
		}
		var originalManualTag;
		if($("#originalManualTag").get(0).checked){
			originalManualTag=1;
		}else{
			originalManualTag=0;
		}
		var warrantyTag=$("input[name='warrantyTag']:checked").val();
		var drivingLicenseTag=$("input[name='drivingLicenseTag']:checked").val();
		var navigateDiskTag;
		if($("#navigateDiskTag").get(0).checked){
			navigateDiskTag=1;
			
		}else{
			navigateDiskTag=0;
		}
		var commIssurValidDate=$("#commIssurValidDate").val();
		var checkValidTag='';
		var aidKitTag;
		if($("#aidKitTag").get(0).checked){
			aidKitTag=1;
			
		}else{
			aidKitTag=0;
		}
		var antennaTag;
		if($("#antennaTag").get(0).checked){
			antennaTag=1
		}else{
			antennaTag=0;
		}
		var standardEquip=$("#standardEquip").val();
		var issurValidDate=$("#issurValidDate").val();
		var carKeys=$("input[name='carKeys']:checked").val();
		var environmentTag=$("input[name='environmentTag']:checked").val();
		var custEquip=$("#custEquip").val();
		var spareWheelTag;
		if($("#spareWheelTag").get(0).checked){
			spareWheelTag=1;
			
		}else{
			spareWheelTag=0
		}
		var extinguisherTag;
		if($("#extinguisherTag").get(0).checked){
			extinguisherTag=1;
		}else{
			extinguisherTag=0
		}
		var registrationCertTag=$("input[name='registrationCertTag']:checked").val();
		var invoiceTag=$("input[name='invoiceTag']:checked").val();
		var commIssurFee=$("#commIssurFee").val();
		var maintainMileage='';
		var triangleTag;
		if($("#triangleTag").get(0).checked){
			triangleTag=1;
		}else{
			triangleTag=0;
		}
		var newcarPrice=$("#newcarPrice").val();
		var maintManualTag;
		if($("#maintManualTag").get(0).checked){
			maintManualTag=1;			
		}else{			
			maintManualTag=0;
		}
		var upholsteryColor=$("#upholsteryColor").val();
		var environmentalLevel=$("input[name='environmentalLevel']:checked").val();
		var smellTag=$("input[name='smellTag']:checked").val();
		var oldLicenseCode=$("#oldLicenseCode").val();
		//热点和机电检查 的部分
		var hotareaItems=evaluate_hotspot.get_hostpot_items_all();
		var conditions=evaluate_hotspot.get_condition_result();
		//var conditions=[];
		var oldColor=$("#oldColor").val();
		var motorCode=$("#motorCode").val();

		
		var fuelType=$("input[name='fuelType']:checked").val();
		var regularCustTag;
		if($("#regularCustTag").get(0).checked){
			regularCustTag=1;
			
		}else{
			regularCustTag=0;
			
		}
		//下面是maintainInfo
		var planEndDateStr=$("#planEndDate").val();
		var maintainHoursFee=$("#maintainHoursFee").val();
		var maintainId=$("#maintainId").val();
		var settlePrice='';		
		var shelveMaintainDesc=$("#shelveMaintainDesc").val();
		var repairMaterialFee=$("#repairMaterialFee").val();
		var repairHoursFee=$("#repairHoursFee").val();
		var repairFinishDateStr=$("#repairFinishDate").val();
		var repairMaintainDesc=$("#repairMaintainDesc").val();
		var maintainMaterialFee=$("#maintainMaterialFee").val();
		var usedType=$("input[name='usedType']:checked").val();
		var obdTag;
		if($("#obdTag").get(0).checked){
			obdTag=1;			
		}else{
			obdTag=0;			
		}
		var custName=$("#custName").val();
		var carColor=$("#carColor").val();
		var vinCheckTag=$("#vinCheckTag").combobox("getValue");
		var registMonth=$("#registMonth").val();
		var surfaceGrade=$("#surfaceGrade").combobox("getValue");
		var outputVolume=$("#outputVolume").val();
        var modelCode=$("#styleCode").val();
		var carDoorNum=$("#carDoorNum").val();
		var catalogueName=$("#brandName").val()+"-"+$("#seriesName").val()+"-"+$("#styleName").val();
		var sellPoint='';
		var infoSource=$("#selInfoSource").combobox("getValue");
		var carType=$("input[name='carType']:checked").val();
		var factoryMonth=$("#factoryMonth").val();
		var brandCode=$("#brandCode").val();
		var stainTag=$("input[name='stainTag']:checked").val();
		var custId=$("#hdCustId").val();
		var actualMileage=$("#actualMileage").val();
		var driverKind=$("#driverKind").combobox("getValue");
		
		//
		var acquSourceId=$("#hdAcquSourceId").val();
		var shelfGrade=$("#shelfGrade").combobox("getValue");
		var mileageCount=$("#mileageCount").val();
		var colorChgTag;
		if($("#colorChgTag").get(0).checked){
			colorChgTag=1;
			
		}else{
			colorChgTag=2;
			
		}
		var upholsteryGrade=$("#upholsteryGrade").combobox("getValue");
		var shelfCode=$("#shelfCode").val();
		var turboCharger;
		if($("#turboCharger").get(0).checked){
			turboCharger=1;			
		}else{
			turboCharger=0;			
		}
		//subType	
		var machineGrade=$("#machineGrade").combobox("getValue");
		var seriesCode=$("#seriesCode").val();
		var maintainShelves=[];
		var editType='';
		var comprehensiveGrade=$("#comprehensiveGrade").combobox("getValue");

		//维修质检通过标记
		var maintainTag=$("input[name='maintainTag']:checked").val();

		console.log("the maintainTag is %s,",maintainTag);

  		var maintainItems=[];
  		if(rightCode==702){
  			console.log("begin _get_isomerism_quality_maintain_items");
  			maintainItems=_get_isomerism_quality_maintain_items();//入库维修质检
  		}else if(rightCode==722){//维修质检
			maintainItems=_get_quality_maintain_item_list();
  			console.log("the maintainItems is %o",maintainItems);
  		}    	
		
		return {
			'passengerNum':passengerNum,
			'transferTag':transferTag,
			'gearsTypeTag':gearsTypeTag,
			'evalItem':evalItem,
			'acquisitionId':acquisitionId,
			'phoneNumber':phoneNumber,
			'credenteBean':{
				'commIssurValidTag':commIssurValidTag,
				'otherAttachment':otherAttachment,
				'maintRecordTag':maintRecordTag,
				'purchaseTaxTag':purchaseTaxTag,
				'licenseCodeTag':licenseCodeTag,
				'toolBoxTag':toolBoxTag,
				'issurValidTag':issurValidTag,
				'ashtrayTag':ashtrayTag,
				'checkValidMonth':checkValidMonth,
				'cigarLighterTag':cigarLighterTag,
				'originalManualTag':originalManualTag,
				'warrantyTag':warrantyTag,
				'drivingLicenseTag':drivingLicenseTag,
				'navigateDiskTag':navigateDiskTag,
				'commIssurValidDate':commIssurValidDate,
				'checkValidTag':checkValidTag,
				'aidKitTag':aidKitTag,
				'antennaTag':antennaTag,
				'standardEquip':standardEquip,
				'issurValidDate':issurValidDate,
				'carKeys':carKeys,
				'environmentTag':environmentTag,
				'custEquip':custEquip,
				'spareWheelTag':spareWheelTag,
				'extinguisherTag':extinguisherTag,
				'registrationCertTag':registrationCertTag,
				'invoiceTag':invoiceTag,
				'commIssurFee':commIssurFee,
				'maintainMileage':maintainMileage,
				'triangleTag':triangleTag,
				'newcarPrice':newcarPrice,
				'maintManualTag':maintManualTag
			},
			'upholsteryColor':upholsteryColor,
			'environmentalLevel':environmentalLevel,
			'smellTag':smellTag,
			'oldLicenseCode':oldLicenseCode,
			'hotareaItems':hotareaItems,//待填充
			'oldColor':oldColor,
			'conditions':conditions,//待填充
			'motorCode':motorCode,
			'maintainItems':maintainItems,//待填充
			'fuelType':fuelType,
			'regularCustTag':regularCustTag,
			'maintainInfo':{
				'planEndDateStr':planEndDateStr,
				'maintainHoursFee':maintainHoursFee,
				'maintainId':maintainId,
				'settlePrice':settlePrice,
				'repairHoursFee':repairHoursFee,
				'repairMaterialFee':repairMaterialFee,
				'shelveMaintainDesc':shelveMaintainDesc,
				'repairFinishDateStr':repairFinishDateStr,
				'repairMaintainDesc':repairMaintainDesc,
				'maintainMaterialFee':maintainMaterialFee
			},
			'maintainTag':maintainTag,
			'usedType':usedType,
			'obdTag':obdTag,
			'custName':custName,
			'carColor':carColor,
			'vinCheckTag':vinCheckTag,
			'registMonth':registMonth,
			'surfaceGrade':surfaceGrade,
			'outputVolume':outputVolume,
			'modelCode':modelCode,
			'carDoorNum':carDoorNum,
			'catalogueName':catalogueName,
			'sellPoint':sellPoint,
			'infoSource':infoSource,
			'carType':carType,
			'factoryMonth':factoryMonth,
			'brandCode':brandCode,
			'stainTag':stainTag,
			'custId':custId,
			'actualMileage':actualMileage,
			'driverKind':driverKind,
			'staffId':staffId,
			'acquSourceId':acquSourceId,
			'shelfGrade':shelfGrade,
			'mileageCount':mileageCount,
			'colorChgTag':colorChgTag,
			'upholsteryGrade':upholsteryGrade,
			'shelfCode':shelfCode,
			'turboCharger':turboCharger,
			'subType':subType,
			'machineGrade':machineGrade,
			'seriesCode':seriesCode,
			'maintainShelves':maintainShelves,
			'editType':editType,
			'comprehensiveGrade':comprehensiveGrade
			
		};
		
	}
	

	return {

		verify_fee:function(){
			var material_fee_msg=_verify_material_fee();
			var labor_fee_msg=_verify_labor_fee();
			var labor_hours=_verify_labor_hours();
			return material_fee_msg+labor_fee_msg+labor_hours;
		},
		//计算合计费用包括材料、工时
		sum_fee:function(){
			this.sum_material_fee();
			this.sum_labor_fee();
		},
		//清除费用
		clean_fee:function(){
			$("#maintainMaterialFee").val('');
			$("#maintainHoursFee").val('');
			$("#sumFee").val('');
		},		

		//合计材料费求和
		sum_material_fee:function(){
			var sum_fee=_get_material_fee();	
			$("#maintainMaterialFee").val(sum_fee);
			var labor_fee=$("#maintainHoursFee").val();
			if(labor_fee){
				$("#sumFee").val(sum_fee+parseInt(labor_fee));
			}else{
				$("#sumFee").val(sum_fee);
			}					
		},

		//合计工时费求和
		sum_labor_fee:function(){
			var sum_fee=_get_labor_fee();
			$("#maintainHoursFee").val(sum_fee);
			var material_fee=$("#maintainMaterialFee").val();
			if(material_fee){
				$("#sumFee").val(sum_fee+parseInt(material_fee));
			}else{
				$("#sumFee").val(sum_fee);
			}				
		},


		/**
		* 获取已经选择的维修质检
		*/
		get_quality_maintain_result:function(){ 
			var items= _get_isomerism_quality_maintain_items();     
			console.log("the get_quality_maintain_result result is :%o",items); 	
        	return items;
    	},		

		/**
		* 车况检车同步,首先同步热点数据，然后同步机电类别项目
		*/
		vehicle_cond_check_syn:function(){	
			var hotspot_list=evaluate_hotspot.get_hostpot_items_all();

			console.log("vehicle_cond_check_syn -->the hotspot_list is %o",hotspot_list);
			this.render_hostpot_result_div(hotspot_list);
			var conditions=evaluate_hotspot.get_condition_result();
			console.log("vehicle_cond_check_syn-->the conditions is %o",conditions);
			this.render_condition_result_div(conditions);
			this.clean_fee();

		},

		/**
		* 渲染热点结果数据
		*/
		render_hostpot_result_div:function(hotareaItems){
			//首先清除列表
			$("#repairItems tr:not(:first)").remove();
			//重新渲染热点div			
			for(j=0;j<hotareaItems.length;j++){
				var type;
				var hotareaItem=hotareaItems[j];
				if(hotareaItem.type==0){
					type='骨架(左前)';
				}else if(hotareaItem.type==1){
					type='骨架(右后)';
				}else if(hotareaItem.type==2){
					type='外观';
				}else if(hotareaItem.type==3){
					type='内饰';
				}else if(hotareaItem.type==4){
					type='机电';
				}
				if($("tr[name='type_"+hotareaItem.type+"']").length==0){
					var html="<tr id='"+itemTrId+"' name='type_"+hotareaItem.type+"'>"+
					"<td class='list-num' id='type_"+hotareaItem.type+"' rowspan='1'>"+type+"</td>"+
					"<td class='list-num' id='itemName_"+itemTrId+"' > "+hotareaItem.itemName+"</td>"+
					"<td class=list-num'>"+
						"<input type='text' id='checkDesc_"+itemTrId+"' value='"+hotareaItem.itemTypeName+"' class='input w300'/>"+
					"</td>"+
					"<td class='list-num'>"+
						"<input type='text' id='laborFee_"+itemTrId+"' class='input w100'  onblur='javascript:instock_check.sum_labor_fee();'/>"+
					"</td>"+
					"<td class='list-num'>"+
						"<input type='text' id='materialFee_"+itemTrId+"' class='input w100'   onblur='javascript:instock_check.sum_material_fee();'/>"+
					"</td>"+
					"<td class='list-num'>"+
						"<input type='text' id='laborHours_"+itemTrId+"' class='input w100'/>"+
					"</td>"+
					"<td class='list-num'>"+
						"<input type='button' value='删除' class='btn' onclick='instock_check.deleteItem("+hotareaItem.type+","+itemTrId+")' />"+
					"</td>"+
				"</tr>";
					var row=$(html);
					$("#repairItems").append(row);
					itemTrId++;
					
				}else{
					var rows=parseInt($("#type_"+hotareaItem.type).attr('rowspan'));
					rows=rows+1;
					$("#type_"+hotareaItem.type).attr('rowspan',rows);
					var html="<tr id='"+itemTrId+"'  name='type_"+hotareaItem.type+"'>"+
					"<td class='list-num' id='itemName_"+itemTrId+"' >"+hotareaItem.itemName+"</td>"+
					"<td class=list-num'>"+
						"<input type='text' id='checkDesc_"+itemTrId+"' value='"+hotareaItem.itemTypeName+"' class='input w300'/>"+
					"</td>"+
					"<td class='list-num'>"+
						"<input type='text'id='laborFee_"+itemTrId+"'  class='input w100'  onblur='javascript:instock_check.sum_labor_fee();'/>"+
					"</td>"+
					"<td class='list-num'>"+
						"<input type='text' id='materialFee_"+itemTrId+"'  class='input w100'  onblur='javascript:instock_check.sum_material_fee();'/>"+
					"</td>"+
					"<td class='list-num'>"+
						"<input type='text' id='laborHours_"+itemTrId+"' class='input w100'/>"+
					"</td>"+
					"<td class='list-num'>"+
						"<input type='button' value='删除' onclick='instock_check.deleteItem("+hotareaItem.type+","+itemTrId+")'  class='btn' />"+
					"</td>"+
					"</tr>";
					$("tr[name='type_"+hotareaItem.type+"']:last").after($(html));
					itemTrId++;					
				}			
			}
		},
		/**
		* 渲染机电检查条件结果
		*/
		render_condition_result_div:function(conditions){
			//机电检查同步
			for(i=0;i<conditions.length;i++){
				var condition=conditions[i];
				var itemCode=condition.itemCode;
				var checkKind=condition.checkKind;
				var checkDesc=condition.checkDesc;
				$("input[name='checkKind_"+itemCode+"'][value="+checkKind+"]").attr('checked',true);
				$("#checkDesc_"+itemCode).val(checkDesc);
			}	
			//机电
			for(k=0;k<conditions.length;k++){
				var type='机电';
				var condition=conditions[k];
				var itemCode=condition.itemCode;
				var itemName=condition.itemName;
				if($("tr[name='type_4']").length==0){
					var html="<tr id='"+itemTrId+"'  name='type_4'>"+
					"<td class='list-num' id='type_4' rowspan='1'>"+type+"</td>"+
					"<td class='list-num' id='itemName_"+itemTrId+"' > "+itemName+"</td>"+
					"<td class=list-num'>"+
						"<input type='text' id='checkDesc_"+itemTrId+"'  value='"+condition.checkDesc+"' class='input w300'/>"+
					"</td>"+
					"<td class='list-num'>"+
						"<input type='text' id='laborFee_"+itemTrId+"' class='input w100' onblur='javascript:instock_check.sum_labor_fee();'/>"+
					"</td>"+
					"<td class='list-num'>"+
						"<input type='text' id='materialFee_"+itemTrId+"' class='input w100' onblur='javascript:instock_check.sum_material_fee();'/>"+
					"</td>"+
					"<td class='list-num'>"+
						"<input type='text' id='laborHours_"+itemTrId+"' class='input w100'/>"+
					"</td>"+
					"<td class='list-num'>"+
						"<input type='button' value='删除' onclick='instock_check.deleteItem(4,"+itemTrId+")'  class='btn' />"+
					"</td>"+
					"</tr>";
					var row=$(html);
					$("#repairItems").append(row);
					itemTrId++;									
				}else{
					var rows=parseInt($("#type_4").attr('rowspan'));
					rows=rows+1;
					$("#type_4").attr('rowspan',rows);
					var html="<tr id='"+itemTrId+"' name='type_4'>"+
					"<td class='list-num' id='itemName_"+itemTrId+"' >"+itemName+"</td>"+
					"<td class=list-num'>"+
						"<input type='text' id='checkDesc_"+itemTrId+"' value='"+condition.checkDesc+"' class='input w300'/>"+
					"</td>"+
					"<td class='list-num'>"+
						"<input type='text' id='laborFee_"+itemTrId+"'  class='input w100' onblur='javascript:instock_check.sum_labor_fee();'/>"+
					"</td>"+
					"<td class='list-num'>"+
						"<input type='text' id='materialFee_"+itemTrId+"'  class='input w100' onblur='javascript:instock_check.sum_material_fee();'/>"+
					"</td>"+
					"<td class='list-num'>"+
						"<input type='text' id='laborHours_"+itemTrId+"'  class='input w100'/>"+
					"</td>"+
					"<td class='list-num'>"+
						"<input type='button' value='删除' onclick='instock_check.deleteItem(4,"+itemTrId+")' class='btn' />"+
					"</td>"+
					"</tr>";
					$("tr[name='type_4']:last").after($(html));
					itemTrId++;							
				}
			}
		},
		//与评估质检同步
		sameWithEval :function(hotareaItems,conditions){
			this.render_hostpot_result_div(hotareaItems);
			this.render_condition_result_div(conditions);
			this.set_comment_instock_check();					
		},
		set_comment_instock_check:function(){
			//评分同步
			$("#comprehensiveGrade").combobox('select',jsonObj.comprehensiveGrade);
			$("#surfaceGrade").combobox('select',jsonObj.surfaceGrade);
			$("#upholsteryGrade").combobox('select',jsonObj.upholsteryGrade);
			$("#shelfGrade").combobox('select',jsonObj.shelfGrade);
			$("#machineGrade").combobox('select',jsonObj.machineGrade);
			
			//特记事项同步
			$("#evalItem").html(jsonObj.evalItem);
			//同步污渍和异味
			$("input[name='stainTag'][value="+jsonObj.stainTag+"]").attr('checked',true);
			$("input[name='smellTag'][value="+jsonObj.smellTag+"]").attr('checked',true);	
		},
		deleteItem:function(type,itemTrId){
			var typeName;
			if(type==0){
				typeName='骨架(左前)';
			}
			if(type==1){
				typeName='骨架(右后)';
			}
			if(type==2){
			typeName='外观';
			}
			if(type==3){
			typeName='内饰';
			}
			if(type==4){
			typeName='机电';
			}
			if(type==5){
			typeName='其他';
			}
			if($("tr[name='type_"+type+"']").length==1){
			$("#"+itemTrId).remove();
		}else if($("tr[name='type_"+type+"']:first").attr('id')==''+itemTrId){//如果它是它所属类别的第一行,
			//将类别列加到第二行上,并且跨行数减1,最后删除目标行
			var rows=$("#type_"+type).attr('rowspan');
			rows=parseInt(rows)-1;
			var html="<td class='list-num' id='type_"+type+"' rowspan='"+rows+"'>"+typeName+"</td>";
			$("tr[name='type_"+type+"']:eq(1)").prepend($(html));
			$("#"+itemTrId).remove();
		}else{
			$("#"+itemTrId).remove();
			var rows=$("#type_"+type).attr('rowspan');
			rows=parseInt(rows)-1;
			$("#type_"+type).attr('rowspan',rows);
		}

		this.sum_fee();			
	},
	
	//点新增项目按钮
	add_item:function(type,itemCode,itemName){
		var typeName;
		if(type==0){
		typeName='骨架左前';
		}
		if(type==1){
			typeName='骨架右后';
		}
		if(type==2){
			typeName='外观';
		}
		if(type==3){
			typeName='内饰';
		}
		if(type==4){
			typeName='机电';
		}
		if(type==5){
			typeName='其他';
		}
		
			if($("tr[name='type_"+type+"']").length==0){
					var html="<tr id='"+itemTrId+"' name='type_"+type+"'>"+
					"<td class='list-num' id='type_"+type+"' rowspan='1'>"+typeName+"</td>"+
					"<td class='list-num'id='itemName_"+itemTrId+"'> "+itemName+"</td>"+
					"<td class=list-num'>"+
						"<input type='text' id='checkDesc_"+itemTrId+"' class='input w300'/>"+
					"</td>"+
					"<td class='list-num'>"+
						"<input type='text' id='laborFee_"+itemTrId+"'  class='input w100'/>"+
					"</td>"+
					"<td class='list-num'>"+
						"<input type='text' id='materialFee_"+itemTrId+"'  class='input w100'/>"+
					"</td>"+
					"<td class='list-num'>"+
						"<input type='text' id='laborHours_"+itemTrId+"'  class='input w100'/>"+
					"</td>"+
					"<td class='list-num'>"+
						"<input type='button' value='删除' class='btn' onclick='instock_check.deleteItem("+type+","+itemTrId+")' />"+
					"</td>"+
				"</tr>";
					var row=$(html);
					$("#repairItems").append(row);
					itemTrId++;
					   
					
			}else{
				var rows=parseInt($("#type_"+type).attr('rowspan'));
				rows=rows+1;
				$("#type_"+type).attr('rowspan',rows);
				var html="<tr id='"+itemTrId+"'  name='type_"+type+"'>"+
					"<td class='list-num' id='itemName_"+itemTrId+"'>"+itemName+"</td>"+
					"<td class=list-num'>"+
						"<input type='text' id='checkDesc_"+itemTrId+"' class='input w300'/>"+
					"</td>"+
					"<td class='list-num'>"+
						"<input type='text' id='laborFee_"+itemTrId+"'  class='input w100'/>"+
					"</td>"+
					"<td class='list-num'>"+
						"<input type='text' id='materialFee_"+itemTrId+"'  class='input w100'/>"+
					"</td>"+
					"<td class='list-num'>"+
						"<input type='text' id='laborHours_"+itemTrId+"' class='input w100'/>"+
					"</td>"+
					"<td class='list-num'>"+
						"<input type='button' value='删除' onclick='instock_check.deleteItem("+type+","+itemTrId+")'  class='btn' />"+
					"</td>"+
				"</tr>";
				$("tr[name='type_"+type+"']:last").after($(html));
				itemTrId++;
						
			}
			
		},
		
		save_condition_result:function(itemCode){
			//解决chrome下不支持endsWith的bug
			String.prototype.endsWith = function(pattern) {
    			var d = this.length - pattern.length;
    			return d >= 0 && this.lastIndexOf(pattern) === d;
			};			

			$("#checkDesc_"+itemCode).val('');
			
			$("input[name='result_"+itemCode+"_"+0+"']").each(function(){
				if(this.checked){
					$("input[name='checkKind_"+itemCode+"'][value='0']").get(0).checked=true;
					$("#checkDesc_"+itemCode).val($("#checkDesc_"+itemCode).val()+$(this).val()+",");
					
				}
			});
			
			$("input[name='result_"+itemCode+"_"+1+"']").each(function(){
				if(this.checked){
					$("input[name='checkKind_"+itemCode+"'][value='1']").get(0).checked=true;
					
					$("#checkDesc_"+itemCode).val($("#checkDesc_"+itemCode).val()+$(this).val()+",");
					
				}
			});
			
			$("input[name='result_"+itemCode+"_"+2+"']").each(function(){
				if(this.checked){
					$("input[name='checkKind_"+itemCode+"'][value='2']").get(0).checked=true;
					$("#checkDesc_"+itemCode).val($("#checkDesc_"+itemCode).val()+$(this).val()+",");
				}
			});
			
			if($("#checkDesc_"+itemCode).val().endsWith(',')){
				$("#checkDesc_"+itemCode).val($("#checkDesc_"+itemCode).val().substring(0,$("#checkDesc_"+itemCode).val().length-1));
				
			}
			hide('HMF',itemCode);

			evaluate_hotspot.render_condition_data_item_div();
		},
		
		setQuickStandardEquip:function(quickStandardConfig){
			$("#standardEquip").val(quickStandardConfig);
			
		},
		
		setQuickCustEquip:function(quickCustConfig){
			$("#custEquip").val(quickCustConfig);
		},
			
			
			
		sub_check:function(staffId,rightCode){
			
			var item=_get_result_json(2,staffId,rightCode);
			var alertMsg="";
			alertMsg=this.verify_fee();
			if(alertMsg!=""){
				sy.messagerAlert("提交入库-->费用验证",alertMsg);
				return ;
			}		
			if(item.comprehensiveGrade==''){
				alertMsg+="请选择综合评估结论\n";
			}else if(item.surfaceGrade==''){
				alertMsg+="请选择外观评估结论\n";
			}else if(item.upholsteryGrade==''){
				alertMsg+="请选择内饰评估结论\n";				
			}else if(item.shelfGrade==''){
				alertMsg+="请选择骨架评估结论\n";				
			}else if(item.machineGrade==''){
				alertMsg+="请选择机电评估结论\n";				
			}else if(item.maintainInfo.maintainMaterialFee==''){
				alertMsg+="请填写合计材料费\n";
			}else if(item.maintainInfo.maintainHoursFee==''){
				alertMsg+="请填写合计工时费\n";
			}else if(item.maintainInfo.planEndDateStr==''){
				alertMsg+="请填写预计完工日\n";				
			}	

			if(alertMsg!=''){
				sy.messagerAlert("提交入库",alertMsg);
				return ;
			}
			var result_json=$.toJSON(item);//subType是2
			console.log("提交入库json is :%s",result_json);

        	$.ajax ({
                type: "POST",
                url: sy.bp()+"/maintainMgr/quality_doWarehouse.action" ,
                data: {jsonString:result_json}, 
                success: function(callback) {    //提交成功后的回调
                	if(callback=="success"){
						sy.messagerAlert("提交入库-结果","提交入库成功");
						//history.back();
						alert("提交入库成功");
						opener.location.reload();                        
                        window.close();
                	}else{
                		sy.messagerAlert("提交入库-结果","提交入库失败");
                	}
                   
                }
            });		
		},
		save_draft:function(staffId,rightCode){
			var result_json=$.toJSON(_get_result_json(1,staffId,rightCode));//subType是1
			console.log("提交草稿json is :%s",result_json);
        	$.ajax ({
                type: "POST",
                url: sy.bp()+"/maintainMgr/quality_doWarehouse.action" ,
                data: {jsonString:result_json}, 
                success: function(callback) {    //提交成功后的回调
                	if(callback=="success"){
						//sy.messagerAlert("保存草稿-结果","提交草稿成功");
						//opener.location.reload();                        
                        //window.close();						
						alert("提交草稿成功");
						opener.location.reload();                        
						window.close();                        
                	}else{
                		sy.messagerAlert("保存草稿-结果","提交草稿失败");
                	}
                   
                }
            });				
		},

		maintain_refresh_fee:function(){
			_set_quality_matin_fee();
		},

		maintain_check:function(staffId,rightCode){

			_set_quality_matin_fee();	
			var item=_get_result_json(2,staffId,rightCode);

			console.log("the item is %o",item);

			var alertMsg="";			

			//console.log("the repairHoursFee is %s,item.maintainTag is :%s,",item.repairHoursFee,item.maintainTag);
			if(item.maintainInfo.repairHoursFee==''){
				alertMsg+="请选择结算工时费\n";
			}else if(item.maintainInfo.repairMaterialFee==''){
				alertMsg+="请选择结算材料费\n";
			}else if(item.maintainInfo.repairFinishDateStr==''){
				alertMsg+="请选择实际完工\n";				
			}else if(item.maintainTag==""||item.maintainTag==undefined){
				alertMsg+="请选择验收结果\n";	
			}

			if(alertMsg!=''){
				sy.messagerAlert("质检评估",alertMsg);
				return ;
			}
			var result_json=$.toJSON(item);//subType是2
			console.log("提交入库json is :%s",result_json);

        	$.ajax ({
                type: "POST",
                url: sy.bp()+"/maintainMgr/quality_doMaintainCheck.action" ,
                data: {jsonString:result_json}, 
                success: function(callback) {    //提交成功后的回调
                	if(callback=="success"){
						//sy.messagerAlert("维修质检-结果","维修质检库成功",window.close());						
						//history.back();
						alert("维修质检库成功");
						opener.location.reload();                        
						window.close();
                        						
                	}else{
                		sy.messagerAlert("维修质检-结果","维修质检库失败");
                	}
                   
                }
            });		
		},
		maintain_check_draft:function(staffId,rightCode){
			var result_json=$.toJSON(_get_result_json(1,staffId,rightCode));//subType是1
			console.log("提交草稿json is :%s",result_json);
        	$.ajax ({
                type: "POST",
                url: sy.bp()+"/maintainMgr/quality_doMaintainCheck.action" ,
                data: {jsonString:result_json}, 
                success: function(callback) {    //提交成功后的回调
                	if(callback=="success"){
						//sy.messagerAlert("保存草稿-结果","提交草稿成功");
						alert("提交草稿成功");
						opener.location.reload();                        
                        window.close();						
                	}else{
                		sy.messagerAlert("保存草稿-结果","提交草稿失败");
                	}
                   
                }
            });				
		}	
	}	
})();