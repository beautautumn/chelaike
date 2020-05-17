vehicle_equip= (function() {

	return {

		open_standard_equip:function(){
        	menu.show_list_dialog('厂家标准配置','/maintainMgr/quality_toStandardEquip.action?equipType=0&standardEquip='+$("#standardEquip").val(),700,500);        
        },
        open_cust_equip:function(){
        	menu.show_list_dialog('车主个性配置','/maintainMgr/quality_toCustEquip.action?equipType=0&custEquip='+$("#custEquip").val(),700,300);
        },

		open_dialog_standard_equip:function(api,w,equipType){
        	menu.show_wdg_on_dialog(api,w,'厂家标准配置','/maintainMgr/quality_toStandardEquip.action?equipType='+equipType+'&standardEquip='+$("#standardEquip").val(),700,500);        
        },
        open_dialog_cust_equip:function(api,w,equipType){
        	menu.show_wdg_on_dialog(api,w,'车主个性配置','/maintainMgr/quality_toCustEquip.action?equipType='+equipType+'&custEquip='+$("#custEquip").val(),700,300);
        },        

       	set_quick_standard_equip:function(quickStandardConfig){
			$("#standardEquip").val(quickStandardConfig);			
		},
		
		set_quick_cust_equip:function(quickCustConfig){
			$("#custEquip").val(quickCustConfig);
		}

		
	};
})();