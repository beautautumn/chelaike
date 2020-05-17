/**
*部门-员工级联
**/
var depart = (function() {

    return {
   		/*从服务器加载省份编码以及名称*/
        load_depart : function(depart,staff,depart_code,staff_cascade){       
 			var departId = $('#'+depart).combobox({
           		url: sy.bp()+"/core/depart_loadCombobox.action?departId="+depart_code,
            	editable:false,
            	valueField:'id',
            	textField:'name',
            	onSelect:function(record){
                    if(staff_cascade){
                        $('#'+staff).combobox({
                            disabled:false,
                            editable:false,
                            url: sy.bp()+"/core/staff_loadCombobox.action?departId="+record.id+"&state=0",
                            valueField:'id',
                            textField:'name'
                        }).combobox('clear');   
                    }

            	}
        	});        
        },
        //选中部门
        select_depart:function(depart,depart_code) {
        	$('#'+depart).combobox('select',depart_code);
        },
        //选中员工
        select_staff:function(depart,staff,depart_code,staff_code) {        	
        	$('#'+staff).combobox({
            	disabled:false,
                editable:false,
                url: sy.bp()+"/core/staff_loadCombobox.action?departId="+depart_code+"&state=0"+"&code="+staff_code,
                valueField:'id',
                textField:'name'
            }).combobox('clear');  
            this.select_depart(depart,depart_code);      
        	$('#'+staff).combobox('select',staff_code);
        }               
    };
})();
