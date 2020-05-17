vehicle_consume= (function() {


	return {
		choose_color_value:function(value,choose_div_id,hidden_div_id){
			$("#"+choose_div_id).val(value);
			$("#"+hidden_div_id).hide();
		},
		show_color_div:function(show_div_id){
			$("#"+show_div_id).show();
		},		
		change_issur_Tag:function(){
    		if($("input[name='qualityJsonBean.credenteBean.issurValidTag']:checked").val() == 1){
    			$("#issurdate1").css("display","");
    			$("#issurdate2").css("display","");
    		} else {
    			$("#issurdate1").css("display","none");
    			$("#issurdate2").css("display","none");
    		}
		},
        change_comm_issur:function(){
        	if($("input[name='qualityJsonBean.credenteBean.commIssurValidTag']:checked").val() == 1){
    			$("#commdate1").css("display","");
    			$("#commdate2").css("display","");
    			$("#commdate3").css("display","");
    		} else {
    			$("#commdate1").css("display","none");
    			$("#commdate2").css("display","none");
    			$("#commdate3").css("display","none");
    		}
        },

		set_vehicle_info:function(jsonString){
			var jsonObj = $.evalJSON(jsonString);
		},
		set_evalute_info:function(jsonString){

		},
		set_customer_info:function(jsonString){

		},

		set_catalogue_name:function(){
        	var brandCode=$("#brandCode").val();
        	var seriesCode=$("#seriesCode").val();
        	var modelCode=$("#styleCode").val();
        	$.ajax({
        	    url:sy.bp()+'/maintainMgr/quality_getVehicleInfoByCodes.action',
        	    type: 'get', 
        	    data:{'brandCode':brandCode,'seriesCode':seriesCode,'modelCode':modelCode},               
        	    async: false,
        	    success: function(data) {
        	        var vehicleInfos= data.split('|');
        	        $("#brandName").val(vehicleInfos[0]);
        	        $("#seriesName").val(vehicleInfos[1]);
        	        $("#styleName").val(vehicleInfos[2]);
        	    } 
        	});
		},

		open_standard_equip:function(){
        	menu.show_list_dialog('厂家标准配置','/maintainMgr/quality_toStandardEquip.action?equipType=1&standardEquip='+$("#standardEquip").val(),700,500);        
        },
        open_cust_equip:function(){
        	menu.show_list_dialog('车主个性配置','/maintainMgr/quality_toCustEquip.action?equipType=1&custEquip='+$("#custEquip").val(),700,300);
        },

		open_dialog_standard_equip:function(api,w){
        	menu.show_wdg_on_dialog(api,w,'厂家标准配置','/maintainMgr/quality_toStandardEquip.action?equipType=1&standardEquip='+$("#standardEquip").val(),700,500);        
        },
        open_dialog_cust_equip:function(api,w){
        	menu.show_wdg_on_dialog(api,w,'车主个性配置','/maintainMgr/quality_toCustEquip.action?equipType=1&custEquip='+$("#custEquip").val(),700,300);
        },        

       	set_quick_standard_equip:function(quickStandardConfig){
			$("#standardEquip").val(quickStandardConfig);			
		},
		
		set_quick_cust_equip:function(quickCustConfig){
			$("#custEquip").val(quickCustConfig);
		},

		set_instock_check_default_value:function(jsonString){
			var jsonObj = $.evalJSON(jsonString);
			$("#acquSourceId").val(jsonObj.acquSourceId);
			$("#brandCode").val(jsonObj.brandCode)
			$("#seriesCode").val(jsonObj.seriesCode),
			$("#styleCode").val(jsonObj.modelCode),
			$("#carColor").val(jsonObj.carColor);
			if(jsonObj.oldColor!=""){
				$("#colorChgTag").attr("checked", true);				
			}
			$("#oldColor").val(jsonObj.oldColor);
			console.log("jsonObj.gearsTypeTag is %s ",jsonObj.gearsTypeTag);
			console.log("jsonObj.fuelType is %s ",jsonObj.fuelType);
			if (jsonObj.gearsTypeTag != -1) {
				$("input[name='qualityJsonBean.gearsTypeTag'][value=" + jsonObj.gearsTypeTag + "]").attr("checked", true);
			}
			//内饰颜色
			$("#upholsteryColor").val(jsonObj.upholsteryColor);
			
			if(jsonObj.obdTag==1){
				$("#obdTag").attr('checked',true);
			}			
			//核定载客人数
			$("#passengerNum").val(jsonObj.passengerNum);
			if (jsonObj.outputVolume == 0) {
				$("#outputVolume").val("");
			} else {
				var outpuVolume=jsonObj.outputVolume+"";
				if(outpuVolume.split(".").length==1){
					$("#outputVolume").val(outpuVolume+".0");
				}else{
					$("#outputVolume").val(outpuVolume);
				}
				
			}
			if (jsonObj.turbocharger == 1) {
				$("#turboCharger").attr("checked", true);
			}
			if (jsonObj.carType != -1) {
				$("input[name='qualityJsonBean.carType'][value=" + jsonObj.carType + "]").attr("checked", true);
			}
			$("#oldLicenseCode").val(jsonObj.oldLicenseCode);
			$("#motorCode").val(jsonObj.motorCode);
			$("#shelfCode").val(jsonObj.shelfCode);
			$("#registMonth").val(jsonObj.registMonth);
			$("#factoryMonth").val(jsonObj.factoryMonth);
			$("#registerNum").val(jsonObj.registerNum);
			

			if(jsonObj.vinCheckTag!=0)
				$("#vinCheckTag").combobox('select',jsonObj.vinCheckTag);//车架号检查
			if(jsonObj.motorCheckTag!=0)
				$("#motorCheckTag").combobox('select',jsonObj.motorCheckTag);//车架号检查			
			if (jsonObj.usedType != -1) {
				$("input[name='qualityJsonBean.usedType'][value=" + jsonObj.usedType + "]").attr("checked", true);//使用类型
			}
			$("#transferTag").val(jsonObj.transferTag);
			
			$("#driverKind").combobox('select',jsonObj.driverKind);
			
			$("#carDoorNum").val(jsonObj.carDoorNum);
			if (jsonObj.environmentalLevel != -1) {
				$("input[name='qualityJsonBean.environmentalLevel'][value=" + jsonObj.environmentalLevel + "]").attr("checked", true);
			}
			if (jsonObj.usedKind != -1) {
				$("input[name='qualityJsonBean.usedKind'][value=" + jsonObj.usedKind + "]").attr("checked", true);
			}			
			
			if (jsonObj.mileageCount == 0) {
				$("#mileageCount").val("");
			} else {
				$("#mileageCount").val(jsonObj.mileageCount);
			}
			if (jsonObj.actualMileage == 0) {
				$("#actualMileage").val("");
			} else {
				$("#actualMileage").val(jsonObj.actualMileage);
			}
			if (jsonObj.credenteBean.maintRecordTag != -1) {
				$("input[name='qualityJsonBean.credenteBean.maintRecordTag'][value=" + jsonObj.credenteBean.maintRecordTag + "]").attr("checked", true);
			}
			if (jsonObj.credenteBean.maintainMileage != -1) {
				$("#maintainMileage").val(jsonObj.credenteBean.maintainMileage);
			}
			
			if (jsonObj.credenteBean.warrantyTag != -1) {
				$("input[name='qualityJsonBean.credenteBean.warrantyTag'][value=" + jsonObj.credenteBean.warrantyTag + "]").attr("checked", true);
			}
			if (jsonObj.fuelType != -1) {
				$("input[name='qualityJsonBean.fuelType'][value=" + jsonObj.fuelType + "]").attr("checked", true);
			}
			
			console.log("the issurValidTag is %o",jsonObj.credenteBean.issurValidTag );
			if (jsonObj.credenteBean.issurValidTag != -1) {
				$("input[name='qualityJsonBean.credenteBean.issurValidTag'][value=" + jsonObj.credenteBean.issurValidTag + "]").attr("checked", true);
				if(jsonObj.credenteBean.issurValidTag==1){
					$("#issurdate1").css("display","");
    				$("#issurdate2").css("display","");
				}
			}
			$("#issurValidDate").val(jsonObj.credenteBean.issurValidDate);
			if (jsonObj.credenteBean.commIssurValidTag != -1) {
				$("input[name='qualityJsonBean.credenteBean.commIssurValidTag'][value=" + jsonObj.credenteBean.commIssurValidTag + "]").attr("checked", true);
				if(jsonObj.credenteBean.commIssurValidTag==1){
					$("#commdate1").css("display","");
    				$("#commdate2").css("display","");
    				$("#commdate3").css("display","");
				}
			}
			$("#commIssurValidDate").val(jsonObj.credenteBean.commIssurValidDate);
			if (jsonObj.credenteBean.commIssurFee == 0) {
				$("#commIssurFee").val("");
			} else {
				$("#commIssurFee").val(jsonObj.credenteBean.commIssurFee);
			}
			$("#checkValidMonth").val(jsonObj.credenteBean.checkValidMonth);
			//console.log("the qualityJsonBean.credenteBean.drivingLicenseTag is %o",jsonObj.credenteBean.checkValidMonth);
			if (jsonObj.credenteBean.drivingLicenseTag != -1) {
				$("input[name='qualityJsonBean.credenteBean.drivingLicenseTag'][value=" + jsonObj.credenteBean.drivingLicenseTag + "]").attr("checked", true);
			}
			if (jsonObj.credenteBean.registrationCertTag != -1) {
				$("input[name='qualityJsonBean.credenteBean.registrationCertTag'][value=" + jsonObj.credenteBean.registrationCertTag + "]").attr("checked", true);
			}
			if (jsonObj.credenteBean.licenseCodeTag != -1) {
				$("input[name='qualityJsonBean.credenteBean.licenseCodeTag'][value=" + jsonObj.credenteBean.licenseCodeTag + "]").attr("checked", true);
			}
			
			if (jsonObj.credenteBean.carKeys != -1) {
				$("input[name='qualityJsonBean.credenteBean.carKeys'][value=" + jsonObj.credenteBean.carKeys + "]").attr("checked", true);
			}
			if (jsonObj.credenteBean.purchaseTaxTag != -1) {
				$("input[name='qualityJsonBean.credenteBean.purchaseTaxTag'][value=" + jsonObj.credenteBean.purchaseTaxTag + "]").attr("checked", true);
			}
			if (jsonObj.credenteBean.environmentTag != -1) {
				$("input[name='qualityJsonBean.credenteBean.environmentTag'][value=" + jsonObj.credenteBean.environmentTag + "]").attr("checked", true);
			}
			if (jsonObj.credenteBean.invoiceTag != -1) {
				$("input[name='qualityJsonBean.credenteBean.invoiceTag'][value=" + jsonObj.credenteBean.invoiceTag + "]").attr("checked", true);
			}
			if (jsonObj.credenteBean.newcarPrice == 0) {
				$("#newcarPrice").val("");
			} else {
				$("#newcarPrice").val(jsonObj.credenteBean.newcarPrice);
			}
			console.log("the jsonObj.credenteBean.originalManualTag  is %s",jsonObj.credenteBean.originalManualTag );
			if (jsonObj.credenteBean.originalManualTag == 1) {
				$("#originalManualTag").attr("checked", true);
			}
			if (jsonObj.credenteBean.maintManualTag == 1) {
				$("#maintManualTag").attr("checked", true);
			}
			if (jsonObj.credenteBean.triangleTag == 1) {
				$("#triangleTag").attr("checked", true);
			}
			if (jsonObj.credenteBean.spareWheelTag == 1) {
				$("#spareWheelTag").attr("checked", true);
			}
			if (jsonObj.credenteBean.extinguisherTag == 1) {
				$("#extinguisherTag").attr("checked", true);
			}
			if (jsonObj.credenteBean.aidKitTag == 1) {
				$("#aidKitTag").attr("checked", true);
			}
			if (jsonObj.credenteBean.ashtrayTag == 1) {
				$("#ashtrayTag").attr("checked", true);
			}
			if (jsonObj.credenteBean.cigarLighterTag == 1) {
				$("#cigarLighterTag").attr("checked", true);
			}
			if (jsonObj.credenteBean.antennaTag == 1) {
				$("#antennaTag").attr("checked", true);
			}
			if (jsonObj.credenteBean.toolBoxTag == 1) {
				$("#toolBoxTag").attr("checked", true);
			}
			if (jsonObj.credenteBean.navigateDiskTag == 1) {
				$("#navigateDiskTag").attr("checked", true);
			}
			$("#otherAttachment").val(jsonObj.credenteBean.otherAttachment);
			var standardConfig = jsonObj.standardEquip;
			//if (standardConfig.indexOf("$") > 0) {
				//standardConfig = standardConfig.replace(/\$/g, "&");
			//}
			$("#standardEquip").val(standardConfig);
			$("#custEquip").val(jsonObj.custEquip);
		},


		do_consume_eval_vehicle:function(jsonStr){
			
			var checkbox_param="";
			
			if ($("#obdTag").is(":checked")){
 				$("#obdTag").val(1);
			}else{
				$("#obdTag").val(0);
			}	
			
			if ($("#originalManualTag").is(":checked"))
				$("#originalManualTag").val(1);
			else {
				checkbox_param+="&qualityJsonBean.credenteBean.originalManualTag=0";
				$("#originalManualTag").val(0);				
			}
			if ($("#maintManualTag").is(":checked"))
				$("#maintManualTag").val(1);
			else {
				checkbox_param+="&qualityJsonBean.credenteBean.maintManualTag=0";
				$("#maintManualTag").val(0);
			}
			if ($("#triangleTag").is(":checked"))
				$("#triangleTag").val(1);
			else{
				checkbox_param+="&qualityJsonBean.credenteBean.triangleTag=0";
				$("#triangleTag").val(0);
			}
			if ($("#spareWheelTag").is(":checked"))
				$("#spareWheelTag").val(1);
			else {
				checkbox_param+="&qualityJsonBean.credenteBean.spareWheelTag=0";
				$("#spareWheelTag").val(0);
			}
			if ($("#extinguisherTag").is(":checked"))
				$("#extinguisherTag").val(1);
			else {
				checkbox_param+="&qualityJsonBean.credenteBean.extinguisherTag=0";
				$("#extinguisherTag").val(0);	
			}
			
			if ($("#aidKitTag").is(":checked"))
				$("#aidKitTag").val(1);
			else{
				checkbox_param+="&qualityJsonBean.credenteBean.aidKitTag=0";
				$("#aidKitTag").val(0);				
			}
			if ($("#ashtrayTag").is(":checked"))
				$("#ashtrayTag").val(1);
			else{
				checkbox_param+="&qualityJsonBean.credenteBean.ashtrayTag=0";
				$("#ashtrayTag").val(0);
			}
			if ($("#cigarLighterTag").is(":checked"))
				$("#cigarLighterTag").val(1);
			else{
				checkbox_param+="&qualityJsonBean.credenteBean.cigarLighterTag=0";
				$("#cigarLighterTag").val(0);
			}
			if ($("#antennaTag").is(":checked"))
				$("#antennaTag").val(1);
			else{
				checkbox_param+="&qualityJsonBean.credenteBean.antennaTag=0";
				$("#antennaTag").val(0);
			}
			if ($("#toolBoxTag").is(":checked"))
				$("#toolBoxTag").val(1);
			else {
				checkbox_param+="&qualityJsonBean.credenteBean.toolBoxTag=0";
				$("#toolBoxTag").val(0);	
			}
			
			if ($("#navigateDiskTag").is(":checked")){
				$("#navigateDiskTag").val(1);
			}else {	
				checkbox_param+="&qualityJsonBean.credenteBean.navigateDiskTag=0";
				$("#navigateDiskTag").val(0);
			}
			

			console.log("originalManualTag check",$("#originalManualTag").is(":checked"));
			//说明书
			if ($("#originalManualTag").is(":checked")){
 				$("#originalManualTag").val(1);
			}
			console.log("the originalManualTag after is %o",$("#originalManualTag").val());
        	//保修手册
			if ($("#maintManualTag").is(":checked")){
 				$("#maintManualTag").val(1);
			}
        	//三脚架
        	$("input[type='checkbox'][name='qualityJsonBean.credenteBean.triangleTag']:checked").each(function(i) {
        	    $("#triangleTag").val(1);
        	});
        	//备胎
        	$("input[type='checkbox'][name='qualityJsonBean.credenteBean.spareWheelTag']:checked").each(function(i) {
        	    $("#spareWheelTag").val(1);
        	});
        	//灭火器
        	$("input[type='checkbox'][name='qualityJsonBean.credenteBean.extinguisherTag']:checked").each(function(i) {
        	    $("#extinguisherTag").val(1);
        	});
        	//急救包
        	$("input[type='checkbox'][name='qualityJsonBean.credenteBean.aidKitTag']:checked").each(function(i) {
        	    $("#aidKitTag").val(1);
        	});
        	//烟灰缸
        	$("input[type='checkbox'][name='qualityJsonBean.credenteBean.ashtrayTag']:checked").each(function(i) {
        	    $("#ashtrayTag").val(1);
        	});
        	//点烟器
        	var cigarLighterTag = 0;
        	$("input[type='checkbox'][name='qualityJsonBean.credenteBean.cigarLighterTag']:checked").each(function(i) {
        	    $("#cigarLighterTag").val(1);
        	});
        	//天线
        	$("input[type='checkbox'][name='qualityJsonBean.credenteBean.antennaTag']:checked").each(function(i) {
        	   $("#antennaTag").val(1);
        	});
        	//随车工具
        	$("input[type='checkbox'][name='qualityJsonBean.credenteBean.toolBoxTag']:checked").each(function(i) {
        	    $("#toolBoxTag").val(1);
        	});
        	//导航卡/光盘
        	$("input[type='checkbox'][name='qualityJsonBean.credenteBean.navigateDiskTag']:checked").each(function(i) {
        	    $("#navigateDiskTag").val(1);
        	});			
			var params=$("#form").serialize();
			console.log("the result_json is %o",params);		
			var  result;
        	$.ajax ({
                type: "POST",
                url: sy.bp()+"/eval/core_doVehicleDetialConsume.action" ,
                data: params+checkbox_param, 
                async: false,
                success: function(callback) {    //提交成功后的回调
                	console.log("the callback is %s",callback);
                	result=callback;                   
                }
            });	
            return result;			
		}		
	};
})();