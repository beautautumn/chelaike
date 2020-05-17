vehicle_vin= (function() {

	var _vehicle_object;
	var _set_vehicle_info=function(jsonObj){	


			_set_catalogue_name(jsonObj);			
			if (jsonObj.gearboxCode != -1) {
				$("input[name='stockBean.vehicle.gearsTypeTag'][value=" + jsonObj.gearboxCode + "]").attr("checked", true);
			}
			
			//核定载客人数
			if(jsonObj.seatNumber>0)
				$("#passengerNum").val(jsonObj.seatNumber);
			if (jsonObj.displacement&&jsonObj.displacement == 0) {
				$("#outputVolume").val("");
			} else if(jsonObj.displacement&&jsonObj.displacement != 0){
				var outpuVolume=jsonObj.displacement+"";
				if(outpuVolume.split(".").length==1){
					$("#outputVolume").val(outpuVolume+".0");
				}else{
					$("#outputVolume").val(outpuVolume);
				}				
			}
		
			if (jsonObj.vehicleTypeCode != -1) {
				$("input[name='stockBean.vehicle.carType'][value=" + jsonObj.vehicleTypeCode + "]").attr("checked", true);
			}			
			//2014-04-17
			// if(jsonObj.registYearMonth!="")
			// 	$("#registMonth").val(jsonObj.registYearMonth);
						
			if (jsonObj.usedType != -1) {
				$("input[name='stockBean.vehicle.usedType'][value=" + jsonObj.usedType + "]").attr("checked", true);//使用类型
			}			
			if(jsonObj.driverTypeCode>=0)		
				$("#driverKind").combobox('select',jsonObj.driverTypeCode);
			
			// if(jsonObj.doorNumber>0)$("#carDoorNum").val(jsonObj.doorNumber);
			if (jsonObj.environmentalStandardCode != -1) {
				$("input[name='stockBean.vehicle.environmentalLevel'][value=" + jsonObj.environmentalStandardCode + "]").attr("checked", true);
			}

			if (jsonObj.fuelTypeCode != -1) {
				$("input[name='stockBean.vehicle.fuelType'][value=" + jsonObj.fuelTypeCode + "]").attr("checked", true);
			}
			
			/**
			if (jsonObj.environmentTag != -1) {
				$("input[name='qualityJsonBean.environmentTag'][value=" + jsonObj.environmentTag + "]").attr("checked", true);
			}
			*/
			// if(jsonObj.safetyEquipment!="")
				// $("#standardEquip").val(jsonObj.safetyEquipment);	

	
	};


	var _set_catalogue_name=function(data){		
        if(data.brandCode>0)$("#brandCode").val(data.brandCode);
        if(data.seriesCode>0)$("#seriesCode").val(data.seriesCode);   
        if(data.brandName!="")$("#brandName").val(data.brandName);
        if(data.seriesName!="")$("#seriesName").val(data.seriesName);     
        // if(data.styleName!="")$("#styleName").val(data.styleName);
        //并且styleCode为空
        $("#styleCode").val('');
        $("#styleName").val('款式');

	};


	var _combin_vehicle_info=function(data){
		var result="";
		if(data.brandName!="")result+=(" 品牌："+data.brandName+"\n");
		if(data.seriesName!="")result+=(" 车系："+data.seriesName+"\n");
		if(data.styleName!="")result+=(" 车型："+data.styleName+"\n");
		if(data.registYearMonth!="")result+=(" 上牌日期："+data.registYearMonth+"\n");
		if(data.displacement!="")result+=(" 排量："+data.displacement+"\n");
		if(data.gearbox!="")result+=(" 档型："+data.gearbox+"\n");
		if(data.driverType!="")result+=(" 驱动方式:"+data.driverType+"\n");
		if(data.fuelType!="")result+=(" 燃油类型："+data.fuelType+"\n");
		if(data.vehicleType!="")result+=" 车辆类型："+data.vehicleType+"\n";
		if(data.environmentalStandard!="")result+=" 环保标准："+data.environmentalStandard+"\n";
		if(data.seatNumber!="")result+=" 核定载客："+data.seatNumber+"\n";		
		return result;		
	};


	return {

		load_vehicle_info:function(){
			var key=$("#shelfCode").val();
			console.log(key);
			if(!key){
				alert("请填写车架号");
				return ;
			}			
			this.load_vehicle_info_by_shelfcode(key);
		},

		load_vehicle_info_by_shelfcode:function(key){
			//var key ="LSVFF26R1D2020825";

			var params="rel=2&key="+key;
			var  vehicle_info="";
        	$.ajax ({
                type: "POST",
                url: sy.bp()+"/stock/vehicle_loadVehicleInfoByShelfCode.action" ,
                data: params, 
                async: false,
                success: function(data) {    //提交成功后的回调
                	console.log("the data is %s",data);
                	var object = $.evalJSON(data);
                	console.log("return =0"+object.returnCode);
                	if(object.returnCode=="0"){
                		
                		var confirm_str=_combin_vehicle_info(object);       
                		//2014-04-14
                		if(confirm("请确认VIN码数据:\n"+confirm_str)){
                			_set_vehicle_info(object);
                		}
                	}else{
                		alert("未查询到相应记录！");
                	}              
                }
            });			
		}
	};
})();