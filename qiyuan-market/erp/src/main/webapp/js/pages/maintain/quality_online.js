
quality_online=(function (){

	var _get_checked_item_code=function(){
		var chk=[];
  		$('input[name="passed_tag"]:checked').each(function(){  
   			chk.push($(this).val());  
  		}); 
  		return chk;
	};

	var _get_checked_item=function(){
			var chk=_get_checked_item_code();
			console.log("the chk is %o",chk);
			var maintainShelves=[];
			for(var i=0;i<chk.length;i++){
				var item=new Object;
  				item.shelveItemCode=chk[i];
				item.passedTag=1;
  				item.shelveProblem=$("#shelve_problem_"+chk[i]).val();
  				maintainShelves.push(item);
			}
			return maintainShelves;
	};

	var _verificat_probems=function(items){
		for(var i=0;i<items.length;i++){
			if(items[i].shelveProblem==""){
				return items[i].shelveItemCode;
			}
		}
		return "";
	}	

	return {
		


		do_quality_online:function(jsonStr){
			var jsonObject = eval("(" + jsonStr + ")");
			jsonObject.maintainShelves=_get_checked_item();
			var problem_verf=_verificat_probems(jsonObject.maintainShelves)
			if(problem_verf!=""){
				sy.messagerAlert("上架质检-验证","请填写选择的问题");
				return;
			}
			var maintainShelveTag=$("input[name='maintainShelveTag']:checked").val(); 
			var shelveMaintainDesc=$("#shelveMaintainDesc").val();
			var beautyFee=$("#beautyFee").val();
			jsonObject.maintainShelveTag=maintainShelveTag;
			jsonObject.maintainInfo.shelveMaintainDesc=shelveMaintainDesc;
			jsonObject.maintainInfo.beautyFee=beautyFee;
			jsonObject.subType=2;
			if(!maintainShelveTag){
				sy.messagerAlert("上架质检-验证","请选择验收结果");
				return;
			}			
			if(jsonObject.maintainShelveTag.length==0){
				sy.messagerAlert("上架质检-验证","请选择维修项目");
				return ;
			}
			if(!jsonObject.maintainInfo.beautyFee){
				sy.messagerAlert("上架质检-验证","请填写美容结算费用");
				return ;
			}	
			var result_json=$.toJSON(jsonObject);//subType是2
			console.log("提交入库json is :%s",result_json);

			
			var  result;
        	$.ajax ({
                type: "POST",
                url: sy.bp()+"/maintainMgr/quality_doOnline.action" ,
                data: {jsonString:result_json}, 
                async: false,
                success: function(callback) {    //提交成功后的回调
                	result=callback;                   
                }
            });	
            return result;			
		}
	}

})();