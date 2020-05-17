/**
*地区级联实现省市的级联
**/
var region = (function() {

    return {
   		/*从服务器加载省份编码以及名称*/
        load_province : function(province, city, valid_tag){
 			var provinceId = $('#'+province).combobox({
           		url: sy.bp()+"/core/region_provinceLoad.action?validTag=" + valid_tag,
            	editable:false,
            	valueField:'id',
            	textField:'name',
            	onSelect:function(record){
                	$('#'+city).combobox({
                    	disabled:false,
                    	editable:false,
                    	url: sy.bp()+"/core/region_cityLoad.action?code="+record.id+"&validTag="+valid_tag,
                    	valueField:'id',
                    	textField:'name'
                	}).combobox('clear');
            	}
        	});
        },
        //选中省份
        select_province:function(province,province_code) {
        	if(province_code>0){
        		$('#'+province).combobox('select',province_code);
        	}
        	
        },
        //选中城市
        select_city:function(province,city,province_code,city_code) {
        	if(city_code>0){
        		console.log("city_code is "+city_code);
               	$('#'+city).combobox({
                	disabled:false,
                    editable:false,
                    url: sy.bp()+"/core/region_cityLoad.action?code="+province_code,
                    valueField:'id',
                    textField:'name'
                }).combobox('clear');  
                this.select_province(province,province_code);      
            	$('#'+city).combobox('select',city_code);        	
        	}
        }               
    };
})();
