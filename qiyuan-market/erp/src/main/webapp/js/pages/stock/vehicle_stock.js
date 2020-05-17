vehicle_stock= (function() {


	return {
		choose_color_value:function(value,choose_div_id,hidden_div_id){
			$("#"+choose_div_id).val(value);
			$("#"+hidden_div_id).hide();
		},
		show_color_div:function(show_div_id){
			$("#"+show_div_id).show();
		},		
		change_issur_Tag:function(){
    		if($("input[name='qualityJsonBean.issurValidTag']:checked").val() == 1){
    			$("#issurdate1").css("display","");
    			$("#issurdate2").css("display","");
    		} else {
    			$("#issurdate1").css("display","none");
    			$("#issurdate2").css("display","none");
    		}
		},
        change_comm_issur:function(){
        	if($("input[name='qualityJsonBean.commIssurValidTag']:checked").val() == 1){
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
        	        //$("#styleName").val(vehicleInfos[2]);
        	    } 
        	});
		},


		set_vehicle_stock_value:function(jsonString){
			var jsonObj = $.evalJSON(jsonString);
			console.log(jsonObj);
			$("#acquSourceId").val(jsonObj.acquSourceId);
			$("#brandCode").val(jsonObj.brandCode)
			$("#seriesCode").val(jsonObj.seriesCode),
			$("#styleCode").val(jsonObj.styleCode),
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
			if(jsonObj.usedKind==1){
				$("#usedKind").attr('checked',true);
			}					
			if(jsonObj.consignTag==1){
				$("#consignTag").attr('checked',true);
			}					
			//核定载客人数
			$("#passengerNum").val(jsonObj.passengerNum);
			if (jsonObj.outputVolume&&jsonObj.outputVolume == 0) {
				$("#outputVolume").val("");
			} else if(jsonObj.outputVolume&&jsonObj.outputVolume != 0){
				var outpuVolume=jsonObj.outputVolume+"";
				if(outpuVolume.split(".").length==1){
					$("#outputVolume").val(outpuVolume+".0");
				}else{
					$("#outputVolume").val(outpuVolume);
				}				
			}
			if (jsonObj.turboCharger == 1) {
				$("#turboCharger").attr("checked", true);
			}
			if (jsonObj.chkSameAsMileageCount == 1) {
				$("#chkSameAsMileageCount").attr("checked", true);
			}			
			
			if (jsonObj.carType != -1) {
				$("input[name='qualityJsonBean.carType'][value=" + jsonObj.carType + "]").attr("checked", true);
			}
			$("#oldLicensecode").val(jsonObj.oldLicensecode);
			$("#newLicensecode").val(jsonObj.newLicensecode);
			$("#licensecode").val(jsonObj.licensecode);
			$("#motorCode").val(jsonObj.motorCode);
			$("#shelfCode").val(jsonObj.shelfCode);
			$("#registMonth").val(jsonObj.registMonth);
			$("#factoryMonth").val(jsonObj.factoryMonth);
			$("#registerNum").val(jsonObj.registerNum);

			$("#custName").val(jsonObj.custName);
			$("#phoneNumber").val(jsonObj.phoneNumber);
			$("#buyPrice").val(jsonObj.buyPrice);
			$("#wholeSalePrice").val(jsonObj.wholeSalePrice);
			$("#bottomPrice").val(jsonObj.bottomPrice);

			$("#newCarRefprice").val(jsonObj.newCarRefprice);
			$("#showPrice").val(jsonObj.showPrice);
			$("#internetPrice").val(jsonObj.internetPrice);		

			$("#buyStaffName").val(jsonObj.buyStaffName);
			$("#staffName").val(jsonObj.staffName);
			$("#ownerName").val(jsonObj.ownerName);		
			$("#buyTime").val(jsonObj.buyTime);
			$("#instockTime").val(jsonObj.instockTime);	

			$("#onshelveTime").val(jsonObj.onshelveTime);
			$("#licenseCode").val(jsonObj.licenseCode);
			$("#partBuyTime").val(jsonObj.partBuyTime);	
			$("#fullBuyTime").val(jsonObj.fullBuyTime);								
			$("#styleName").val(jsonObj.carModelName);	
			$("#businessCode").val(jsonObj.businessCode);	
			$("#partnerPerson").val(jsonObj.partnerPerson);	

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

			if (jsonObj.mileageUnit != -1) {
				$("input[name='qualityJsonBean.mileageUnit'][value=" + jsonObj.mileageUnit + "]").attr("checked", true);
			}	
			$("#sellPoint").val(jsonObj.sellPoint);
			/**
			if (jsonObj.usedKind != -1) {
				$("input[name='qualityJsonBean.usedKind'][value=" + jsonObj.usedKind + "]").attr("checked", true);
			}	
			*/		
			
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
			if (jsonObj.maintRecordTag != -1) {
				$("input[name='qualityJsonBean.maintRecordTag'][value=" + jsonObj.maintRecordTag + "]").attr("checked", true);
			}
			if (jsonObj.maintainMileage != -1) {
				$("#maintainMileage").val(jsonObj.maintainMileage);
			}
			
			if (jsonObj.warrantyTag != -1) {
				$("input[name='qualityJsonBean.warrantyTag'][value=" + jsonObj.warrantyTag + "]").attr("checked", true);
			}
			if (jsonObj.fuelType != -1) {
				$("input[name='qualityJsonBean.fuelType'][value=" + jsonObj.fuelType + "]").attr("checked", true);
			}
			
			console.log("the issurValidTag is %o",jsonObj.issurValidTag );
			if (jsonObj.issurValidTag != -1) {
				$("input[name='qualityJsonBean.issurValidTag'][value=" + jsonObj.issurValidTag + "]").attr("checked", true);
				if(jsonObj.issurValidTag==1){
					$("#issurdate1").css("display","");
    				$("#issurdate2").css("display","");
				}
			}
			$("#issurValidDate").val(jsonObj.issurValidDate);
			if (jsonObj.commIssurValidTag != -1) {
				$("input[name='qualityJsonBean.commIssurValidTag'][value=" + jsonObj.commIssurValidTag + "]").attr("checked", true);
				if(jsonObj.commIssurValidTag==1){
					$("#commdate1").css("display","");
    				$("#commdate2").css("display","");
    				$("#commdate3").css("display","");
				}
			}
			$("#commIssurValidDate").val(jsonObj.commIssurValidDate);
			if (jsonObj.commIssurFee == 0) {
				$("#commIssurFee").val("");
			} else {
				$("#commIssurFee").val(jsonObj.commIssurFee);
			}
			$("#checkValidMonth").val(jsonObj.checkValidMonth);
			//console.log("the qualityJsonBean.drivingLicenseTag is %o",jsonObj.checkValidMonth);
			if (jsonObj.drivingLicenseTag != -1) {
				$("input[name='qualityJsonBean.drivingLicenseTag'][value=" + jsonObj.drivingLicenseTag + "]").attr("checked", true);
			}
			if (jsonObj.registrationCertTag != -1) {
				$("input[name='qualityJsonBean.registrationCertTag'][value=" + jsonObj.registrationCertTag + "]").attr("checked", true);
			}
			if (jsonObj.licenseCodeTag != -1) {
				$("input[name='qualityJsonBean.licenseCodeTag'][value=" + jsonObj.licenseCodeTag + "]").attr("checked", true);
			}
			
			if (jsonObj.carKeys != -1) {
				$("input[name='qualityJsonBean.carKeys'][value=" + jsonObj.carKeys + "]").attr("checked", true);
			}
			if (jsonObj.purchaseTaxTag != -1) {
				$("input[name='qualityJsonBean.purchaseTaxTag'][value=" + jsonObj.purchaseTaxTag + "]").attr("checked", true);
			}
			/**
			if (jsonObj.environmentTag != -1) {
				$("input[name='qualityJsonBean.environmentTag'][value=" + jsonObj.environmentTag + "]").attr("checked", true);
			}
			*/
			if (jsonObj.invoiceTag != -1) {
				$("input[name='qualityJsonBean.invoiceTag'][value=" + jsonObj.invoiceTag + "]").attr("checked", true);
			}
			if (jsonObj.consignTag != -1) {
				$("input[name='qualityJsonBean.consignTag'][value=" + jsonObj.consignTag + "]").attr("checked", true);
			}
			if (jsonObj.archiveStatus != -1) {
				$("input[name='qualityJsonBean.archiveStatus'][value=" + jsonObj.archiveStatus + "]").attr("checked", true);
			}	
			
			
			if (jsonObj.keysModelTag != -1) {
				$("input[name='qualityJsonBean.keysModelTag'][value=" + jsonObj.keysModelTag + "]").attr("checked", true);
			}
			if (jsonObj.colorEqualTag != -1) {
				$("input[name='qualityJsonBean.colorEqualTag'][value=" + jsonObj.colorEqualTag + "]").attr("checked", true);
			}	
			if (jsonObj.tireEqualTag != -1) {
				$("input[name='qualityJsonBean.tireEqualTag'][value=" + jsonObj.tireEqualTag + "]").attr("checked", true);
			}	

			if (jsonObj.remodelTag != -1) {
				$("input[name='qualityJsonBean.remodelTag'][value=" + jsonObj.remodelTag + "]").attr("checked", true);
			}
			if (jsonObj.windowModuleTag != -1) {
				$("input[name='qualityJsonBean.windowModuleTag'][value=" + jsonObj.windowModuleTag + "]").attr("checked", true);
			}
			$("#ltpValidDate").val(jsonObj.ltpValidDate);
			$("#maintRecord").val(jsonObj.maintRecord);
			$("#otherMisMaterial").val(jsonObj.otherMisMaterial);
			$("#headsetNum").val(jsonObj.headsetNum);
			$("#remoteNum").val(jsonObj.remoteNum);
			$("#carPhoneNum").val(jsonObj.carPhoneNum);
			$("#datalineNum").val(jsonObj.datalineNum);
			$("#motorCodeLocate").val(jsonObj.motorCodeLocate);
			$("#shelfCodeLocate").val(jsonObj.shelfCodeLocate);						
			
			if (jsonObj.newcarPrice == 0) {
				$("#newcarPrice").val("");
			} else {
				$("#newcarPrice").val(jsonObj.newcarPrice);
			}
			if (jsonObj.originalManualTag == 1) {
				$("#originalManualTag").attr("checked", true);
			}
			if (jsonObj.maintManualTag == 1) {
				$("#maintManualTag").attr("checked", true);
			}						
			if (jsonObj.triangleTag == 1) {
				$("#triangleTag").attr("checked", true);
			}
			if (jsonObj.spareWheelTag == 1) {
				$("#spareWheelTag").attr("checked", true);
			}
			if (jsonObj.extinguisherTag == 1) {
				$("#extinguisherTag").attr("checked", true);
			}
			if (jsonObj.aidKitTag == 1) {
				$("#aidKitTag").attr("checked", true);
			}
			if (jsonObj.ashtrayTag == 1) {
				$("#ashtrayTag").attr("checked", true);
			}
			if (jsonObj.cigarLighterTag == 1) {
				$("#cigarLighterTag").attr("checked", true);
			}
			if (jsonObj.antennaTag == 1) {
				$("#antennaTag").attr("checked", true);
			}
			if (jsonObj.toolBoxTag == 1) {
				$("#toolBoxTag").attr("checked", true);
			}
			if (jsonObj.navigateDiskTag == 1) {
				$("#navigateDiskTag").attr("checked", true);
			}
			$("#otherAttachment").val(jsonObj.otherAttachment);
			var standardConfig = jsonObj.standardEquip;
			//if (standardConfig.indexOf("$") > 0) {
				//standardConfig = standardConfig.replace(/\$/g, "&");
			//}
			$("#standardEquip").val(standardConfig);
			$("#custEquip").val(jsonObj.custEquip);

			$("#buyObjectName").val(jsonObj.buyObjectName);
			$("#buyObjectPhone").val(jsonObj.buyObjectPhone);
			$("#extraAddPrice").val(jsonObj.extraAddPrice);
			$("#discountRate").val(jsonObj.discountRate);
			$("#newCarHandprice").val(jsonObj.newCarHandprice);
			$("#acquDesc").val(jsonObj.acquDesc);
			$("#masterInfo").val(jsonObj.masterInfo);			
			$("#repairFee").val(jsonObj.repairFee);		
			if (jsonObj.fdlsTag == 1) {
				$("#fdlsTag").attr("checked", true);
			}
			if (jsonObj.fdlsbsTag == 1) {
				$("#fdlsbsTag").attr("checked", true);
			}
			if (jsonObj.navigateDiskTag == 1) {
				$("#navigateDiskTag").attr("checked", true);
			}
			if (jsonObj.jackTag == 1) {
				$("#jackTag").attr("checked", true);
			}
			if (jsonObj.trailerHookTag == 1) {
				$("#trailerHookTag").attr("checked", true);
			}
			if (jsonObj.toolkitTag == 1) {
				$("#toolkitTag").attr("checked", true);
			}	
			if (jsonObj.wrenchTag == 1) {
				$("#wrenchTag").attr("checked", true);
			}	
			//console.log("partener is "+jsonObj.partner);
			if(jsonObj.partner!=undefined&&jsonObj.partner!=""){
				var partnerArray=jsonObj.partner.split(",");
 				for(var i=0;i<partnerArray.length;i++){
 					$("#partner_"+partnerArray[i]).attr("checked",'true');
 				}
			}

			$("#brandName").val(jsonObj.brandName);	
			$("#seriesName").val(jsonObj.seriesName);
			$("#yearName").val(jsonObj.yearName);		
			$("#styleName").val(jsonObj.styleName);	
			$("#styleCode").val(jsonObj.styleCode);	
			console.log(jsonObj.styleName);
			if(jsonObj.sellStyleCode){
				$("#sellStyleName").val(jsonObj.sellStyleName);	
				$("#sellStyleCode").val(jsonObj.sellStyleCode);					
			}
			$("#newCarDepciatRate").val(jsonObj.newCarDepciatRate);	
			$("#internerDepciatRate").val(jsonObj.internerDepciatRate);	
			$("#internetAveragePrice").val(jsonObj.internetAveragePrice);

			$("#lender").val(jsonObj.lender);		
							
		},
		
		validate_vehicle_stock:function(){
			var brandCode=$("#brandCode").val();
			var seriesCode=$("#seriesCode").val();
			var buyDepart=$("#buyDepart").val();
			if(brandCode==''){
				alert("请选择品牌");
				return ;
			}
			if(seriesCode==''){
				alert("请选择车系");
				return ;
			}	
			/**
			if(buyDepart==''){
				alert("请选择收购公司");
				return ;
			}	
			*/								
		},


		do_vehicle_stock_push:function(jsonStr){
			this.validate_vehicle_stock();
			var checkbox_param="";		

			if ($("#fdlsTag").is(":checked")){
 				$("#fdlsTag").val(1);
			}else{
				$("#fdlsTag").val(0);
				checkbox_param+="&qualityJsonBean.fdlsTag=0";
			}	
			if ($("#fdlsbsTag").is(":checked")){
 				$("#fdlsbsTag").val(1);
			}else{
				$("#fdlsbsTag").val(0);
				checkbox_param+="&qualityJsonBean.fdlsbsTag=0";
			}	
			if ($("#wrenchTag").is(":checked")){
 				$("#wrenchTag").val(1);
			}else{
				$("#wrenchTag").val(0);
				checkbox_param+="&qualityJsonBean.wrenchTag=0";
			}	
			if ($("#jackTag").is(":checked")){
 				$("#jackTag").val(1);
			}else{
				$("#jackTag").val(0);
				checkbox_param+="&qualityJsonBean.jackTag=0";
			}						
			if ($("#toolkitTag").is(":checked")){
 				$("#toolkitTag").val(1);
			}else{
				$("#toolkitTag").val(0);
				checkbox_param+="&qualityJsonBean.toolkitTag=0";
			}				
					
			if ($("#originalManualTag").is(":checked")){
 				$("#originalManualTag").val(1);
			}else{
				$("#originalManualTag").val(0);
				checkbox_param+="&qualityJsonBean.originalManualTag=0";
			}		

			if ($("#maintManualTag").is(":checked")){
 				$("#maintManualTag").val(1);
			}else{
				$("#maintManualTag").val(0);
				checkbox_param+="&qualityJsonBean.maintManualTag=0";
			}										
				
			if ($("#usedKind").is(":checked")){
 				$("#usedKind").val(1);
			}else{
				$("#usedKind").val(0);
				checkbox_param+="&qualityJsonBean.usedKind=0";
			}		

			if ($("#obdTag").is(":checked")){
 				$("#obdTag").val(1);
			}else{
				$("#obdTag").val(0);
				checkbox_param+="&qualityJsonBean.obdTag=0";
			}						
			
			if ($("#colorChgTag").is(":checked")){
 				$("#colorChgTag").val(1);
			}else{
				$("#colorChgTag").val(0);
				checkbox_param+="&qualityJsonBean.colorChgTag=0";
			}	
			if ($("#turboCharger").is(":checked")){
 				$("#turboCharger").val(1);
			}else{
				$("#turboCharger").val(0);
				checkbox_param+="&qualityJsonBean.turboCharger=0";
			}	

			if ($("#triangleTag").is(":checked"))
				$("#triangleTag").val(1);
			else{
				checkbox_param+="&qualityJsonBean.triangleTag=0";
				$("#triangleTag").val(0);
			}
			if ($("#spareWheelTag").is(":checked"))
				$("#spareWheelTag").val(1);
			else {
				checkbox_param+="&qualityJsonBean.spareWheelTag=0";
				$("#spareWheelTag").val(0);
			}
			if ($("#extinguisherTag").is(":checked"))
				$("#extinguisherTag").val(1);
			else {
				checkbox_param+="&qualityJsonBean.extinguisherTag=0";
				$("#extinguisherTag").val(0);	
			}
			
			if ($("#aidKitTag").is(":checked"))
				$("#aidKitTag").val(1);
			else{
				checkbox_param+="&qualityJsonBean.aidKitTag=0";
				$("#aidKitTag").val(0);				
			}
			/**
			if ($("#ashtrayTag").is(":checked"))
				$("#ashtrayTag").val(1);
			else{
				checkbox_param+="&qualityJsonBean.ashtrayTag=0";
				$("#ashtrayTag").val(0);
			}
			if ($("#antennaTag").is(":checked"))
				$("#antennaTag").val(1);
			else{
				checkbox_param+="&qualityJsonBean.antennaTag=0";
				$("#antennaTag").val(0);
			}			
			*/
			if ($("#cigarLighterTag").is(":checked"))
				$("#cigarLighterTag").val(1);
			else{
				checkbox_param+="&qualityJsonBean.cigarLighterTag=0";
				$("#cigarLighterTag").val(0);
			}

			if ($("#toolBoxTag").is(":checked"))
				$("#toolBoxTag").val(1);
			else {
				checkbox_param+="&qualityJsonBean.toolBoxTag=0";
				$("#toolBoxTag").val(0);	
			}
			
			if ($("#navigateDiskTag").is(":checked")){
				$("#navigateDiskTag").val(1);
			}else {	
				checkbox_param+="&qualityJsonBean.navigateDiskTag=0";
				$("#navigateDiskTag").val(0);
			}
			
        	var partner_str="";
          	var partners = document.getElementsByName("partners");				   				
   			for (var i=0;i<partners.length; i++){
        		if(partners[i].checked){   
        			partner_str+=partners[i].value+",";		
        		}
    		}      
          	if(partner_str!=''){
   				partner_str=partner_str.substring(0,partner_str.length-1); 
   				checkbox_param+="&qualityJsonBean.partner="+partner_str;
          	} 	

			var operate_differ_str=track.get_page_track_result();
			if(operate_differ_str!=""){
				checkbox_param+="&qualityJsonBean.operateDifferStr="+operate_differ_str;	
			}          	
			var params=$("#form").serialize();
			console.log("the result_json is %o",params);		
			var  result;
			//data: params+checkbox_param, 

			var json=params+checkbox_param;
			console.log(json);
        	$.ajax ({
                type: "POST",
                url: sy.bp()+"/stock/vehicle_doVehicleStockPush.action" ,
                data: params+checkbox_param, 
                async: false,
                success: function(callback) {    //提交成功后的回调
                	console.log("the callback is %s",callback);
                	result=callback;                   
                }
            });	
            return result;			
		},	
		/**
		*收购入库、收购修改
		*/
		do_vehicle_stock_acqu:function(jsonStr){
			this.validate_vehicle_stock();
			var checkbox_param="";						
			/**
			if ($("#colorChgTag").is(":checked")){
 				$("#colorChgTag").val(1);
			}else{
				$("#colorChgTag").val(0);
				checkbox_param+="&qualityJsonBean.colorChgTag=0";
			}	
			*/
			if ($("#turboCharger").is(":checked")){
 				$("#turboCharger").val(1);
			}else{
				$("#turboCharger").val(0);
				checkbox_param+="&qualityJsonBean.turboCharger=0";
			}				
        	var partner_str="";
          	var partners = document.getElementsByName("partners");				   				
   			for (var i=0;i<partners.length; i++){
        		if(partners[i].checked){   
        			partner_str+=partners[i].value+",";		
        		}
    		}      
          	if(partner_str!=''){
   				partner_str=partner_str.substring(0,partner_str.length-1); 
   				checkbox_param+="&qualityJsonBean.partner="+partner_str;
          	} 	
			var params=$("#form").serialize();
			console.log("the result_json is %o",params);		
			var  result;
			//data: params+checkbox_param, 
			var json=params+checkbox_param;

			var operate_differ_str=track.get_page_track_result();
			if(operate_differ_str!=""){
				checkbox_param+="&qualityJsonBean.operateDifferStr="+operate_differ_str;	
			}
			
			console.log(json);
        	$.ajax ({
                type: "POST",
                url: sy.bp()+"/stock/vehicle_doVehicleStockAcqu.action" ,
                data: params+checkbox_param, 
                async: false,
                success: function(callback) {    //提交成功后的回调
                	console.log("the callback is %s",callback);
                	result=callback;                   
                }
            });	
            return result;			
		},

		/**
		*牌证入库、修改
		*/
		do_vehicle_stock_license:function(jsonStr){
			//this.validate_vehicle_stock();
			var checkbox_param="";

			if ($("#fdlsTag").is(":checked")){
 				$("#fdlsTag").val(1);
			}else{
				$("#fdlsTag").val(0);
				checkbox_param+="&qualityJsonBean.fdlsTag=0";
			}	
			if ($("#fdlsbsTag").is(":checked")){
 				$("#fdlsbsTag").val(1);
			}else{
				$("#fdlsbsTag").val(0);
				checkbox_param+="&qualityJsonBean.fdlsbsTag=0";
			}	
			if ($("#wrenchTag").is(":checked")){
 				$("#wrenchTag").val(1);
			}else{
				$("#wrenchTag").val(0);
				checkbox_param+="&qualityJsonBean.wrenchTag=0";
			}	
			if ($("#jackTag").is(":checked")){
 				$("#jackTag").val(1);
			}else{
				$("#jackTag").val(0);
				checkbox_param+="&qualityJsonBean.jackTag=0";
			}						
			if ($("#toolkitTag").is(":checked")){
 				$("#toolkitTag").val(1);
			}else{
				$("#toolkitTag").val(0);
				checkbox_param+="&qualityJsonBean.toolkitTag=0";
			}				
					

			if ($("#originalManualTag").is(":checked")){
 				$("#originalManualTag").val(1);
			}else{
				$("#originalManualTag").val(0);
				checkbox_param+="&qualityJsonBean.originalManualTag=0";
			}		

			if ($("#maintManualTag").is(":checked")){
 				$("#maintManualTag").val(1);
			}else{
				$("#maintManualTag").val(0);
				checkbox_param+="&qualityJsonBean.maintManualTag=0";
			}										
				
			if ($("#usedKind").is(":checked")){
 				$("#usedKind").val(1);
			}else{
				$("#usedKind").val(0);
				checkbox_param+="&qualityJsonBean.usedKind=0";
			}						

			if ($("#obdTag").is(":checked")){
 				$("#obdTag").val(1);
			}else{
				$("#obdTag").val(0);
				checkbox_param+="&qualityJsonBean.obdTag=0";
			}						
						
			if ($("#turboCharger").is(":checked")){
 				$("#turboCharger").val(1);
			}else{
				$("#turboCharger").val(0);
				checkbox_param+="&qualityJsonBean.turboCharger=0";
			}	

			if ($("#triangleTag").is(":checked"))
				$("#triangleTag").val(1);
			else{
				checkbox_param+="&qualityJsonBean.triangleTag=0";
				$("#triangleTag").val(0);
			}
			if ($("#spareWheelTag").is(":checked"))
				$("#spareWheelTag").val(1);
			else {
				checkbox_param+="&qualityJsonBean.spareWheelTag=0";
				$("#spareWheelTag").val(0);
			}
			if ($("#extinguisherTag").is(":checked"))
				$("#extinguisherTag").val(1);
			else {
				checkbox_param+="&qualityJsonBean.extinguisherTag=0";
				$("#extinguisherTag").val(0);	
			}
			
			if ($("#aidKitTag").is(":checked"))
				$("#aidKitTag").val(1);
			else{
				checkbox_param+="&qualityJsonBean.aidKitTag=0";
				$("#aidKitTag").val(0);				
			}

			if ($("#cigarLighterTag").is(":checked"))
				$("#cigarLighterTag").val(1);
			else{
				checkbox_param+="&qualityJsonBean.cigarLighterTag=0";
				$("#cigarLighterTag").val(0);
			}
			/**
			if ($("#antennaTag").is(":checked"))
				$("#antennaTag").val(1);
			else{
				checkbox_param+="&qualityJsonBean.antennaTag=0";
				$("#antennaTag").val(0);
			}
			if ($("#ashtrayTag").is(":checked"))
				$("#ashtrayTag").val(1);
			else{
				checkbox_param+="&qualityJsonBean.ashtrayTag=0";
				$("#ashtrayTag").val(0);
			}			
			*/
			if ($("#toolBoxTag").is(":checked"))
				$("#toolBoxTag").val(1);
			else {
				checkbox_param+="&qualityJsonBean.toolBoxTag=0";
				$("#toolBoxTag").val(0);	
			}
			
			if ($("#navigateDiskTag").is(":checked")){
				$("#navigateDiskTag").val(1);
			}else {	
				checkbox_param+="&qualityJsonBean.navigateDiskTag=0";
				$("#navigateDiskTag").val(0);
			}        	
			var operate_differ_str=track.get_page_track_result();
			if(operate_differ_str!=""){
				checkbox_param+="&qualityJsonBean.operateDifferStr="+operate_differ_str;	
			}			
			var params=$("#form").serialize();
			console.log("the result_json is %o",params);		
			var  result; 
			var json=params+checkbox_param;

			console.log(json);
        	$.ajax ({
                type: "POST",
                url: sy.bp()+"/stock/vehicle_doVehicleStockLicense.action" ,
                data: params+checkbox_param, 
                async: false,
                success: function(callback) {    //提交成功后的回调
                	console.log("the callback is %s",callback);
                	result=callback;                   
                }
            });	
            return result;			
		},

		do_vehicle_stock_finance:function(jsonStr){
			var checkbox_param="";				
        	var partner_str="";
          	var partners = document.getElementsByName("partners");				   				
   			for (var i=0;i<partners.length; i++){
        		if(partners[i].checked){   
        			partner_str+=partners[i].value+",";		
        		}
    		}      
          	if(partner_str!=''){
   				partner_str=partner_str.substring(0,partner_str.length-1); 
   				checkbox_param+="&qualityJsonBean.partner="+partner_str;
          	} 	
			var operate_differ_str=track.get_page_track_result();
			if(operate_differ_str!=""){
				checkbox_param+="&qualityJsonBean.operateDifferStr="+operate_differ_str;	
			}          	
			var params=$("#form").serialize();
			console.log("the result_json is %o",params);		
			var  result;
			//data: params+checkbox_param, 
			var json=params+checkbox_param;
			console.log(json);
        	$.ajax ({
                type: "POST",
                url: sy.bp()+"/stock/vehicle_doVehicleStockFinance.action" ,
                data: params+checkbox_param, 
                async: false,
                success: function(callback) {    //提交成功后的回调
                	console.log("the callback is %s",callback);
                	result=callback;                   
                }
            });	
            return result;			
		},

		do_vehicle_stock_price_adjust:function(jsonStr){
			var checkbox_param="";	
			var operate_differ_str=track.get_page_track_result();
			if(operate_differ_str!=""){
				checkbox_param+="&qualityJsonBean.operateDifferStr="+operate_differ_str;	
			}														
			var params=$("#form").serialize();
			console.log("the result_json is %o",params);		
			var  result;
			//data: params+checkbox_param, 
			var json=params+checkbox_param;
			console.log(json);
        	$.ajax ({
                type: "POST",
                url: sy.bp()+"/stock/vehicle_doVehicleStockPriceAdjust.action" ,
                data: params+checkbox_param, 
                async: false,
                success: function(callback) {    //提交成功后的回调
                	console.log("the callback is %s",callback);
                	result=callback;                   
                }
            });	
            return result;			
		},
		do_vehicle_stock_product:function(jsonStr){
			var checkbox_param="";		
			var operate_differ_str=track.get_page_track_result();
			if(operate_differ_str!=""){
				checkbox_param+="&qualityJsonBean.operateDifferStr="+operate_differ_str;	
			}													
			var params=$("#form").serialize();
			console.log("the result_json is %o",params);		
			var  result;
			//data: params+checkbox_param, 
			var json=params+checkbox_param;
			console.log(json);
        	$.ajax ({
                type: "POST",
                url: sy.bp()+"/stock/vehicle_doVehicleStockProduct.action" ,
                data: params+checkbox_param, 
                async: false,
                success: function(callback) {    //提交成功后的回调
                	console.log("the callback is %s",callback);
                	result=callback;                   
                }
            });	
            return result;			
		},
		do_vehicle_stock_sale_price:function(jsonStr){
			var checkbox_param="";		
			var operate_differ_str=track.get_page_track_result();
			if(operate_differ_str!=""){
				checkbox_param+="&qualityJsonBean.operateDifferStr="+operate_differ_str;	
			}													
			var params=$("#form").serialize();
			console.log("the result_json is %o",params);		
			var  result;
			//data: params+checkbox_param, 
			var json=params+checkbox_param;
			console.log(json);
        	$.ajax ({
                type: "POST",
                url: sy.bp()+"/stock/vehicle_doVehicleStockSalePrice.action" ,
                data: params+checkbox_param, 
                async: false,
                success: function(callback) {    //提交成功后的回调
                	console.log("the callback is %s",callback);
                	result=callback;                   
                }
            });	
            return result;			
		},
		do_vehicle_stock_price_modulus:function(jsonStr){
			var checkbox_param="";		
			var operate_differ_str=track.get_page_track_result();
			if(operate_differ_str!=""){
				checkbox_param+="&qualityJsonBean.operateDifferStr="+operate_differ_str;	
			}													
			var params=$("#form").serialize();
			console.log("the result_json is %o",params);		
			var  result;
			//data: params+checkbox_param, 
			var json=params+checkbox_param;
			console.log(json);
        	$.ajax ({
                type: "POST",
                url: sy.bp()+"/stock/vehicle_doVehicleStockPriceModulus.action" ,
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