/*
*老客户判断
*/
var customer_validate = (function() {

	var _check_type;
	
	var _api;
	var _w;
	
	var _current_dialog;

    var _show_old_cust_dialog=function (left,top,identity_id,identity_name,regular_cust_tag
					,findState, custId, custName, infoDesc, followStaff,ownerName) 
    {
            if(findState == 1){
                //如果当前状态为老客户允许录入，显示选择输入对话框
                var content = "该号码在系统中已有如下数据，请选择处理方式：<br>"+
                	"客户名称："+ custName +", 信息提示："+ infoDesc +" ,跟进人："+ followStaff;
                _show_input_old_cust_dialog(content,left,top,identity_id,identity_name,regular_cust_tag,custId,custName,ownerName);
            } else if(findState == 2){
                //如果当前状态为老客户不允许录入，显示禁止输入选择对话框
            	var content = "该号码在系统中已有如下数据，不能输入重复信息：<br>"+
                	"客户名称："+ custName +", 信息提示："+ infoDesc +" ,跟进人："+ followStaff;                
                _show_disabled_old_cust_dialog(content,left,top,identity_id,identity_name,regular_cust_tag,custId,custName,ownerName);
            }
    } 
    
    var _set_old_cust_val=function(identity_id,identity_name,regular_cust_tag,cust_id,cust_name,owner_name){
        	//alert("the identity_id is :"+identity_id+" identity_name is :"+identity_name+" regular_cust_tag is :"+regular_cust_tag );
        	//alert("the cust_id is :"+cust_id+" cust_name is :"+cust_name+" owner_name is :"+owner_name );
        	$("#"+identity_id).val(cust_id);
        	if(_check_type==0){
        		$("#"+identity_name).val(cust_name);
        	}else if(_check_type==1){
        		$("#"+identity_name).val(owner_name);
        	}
        	
        	document.getElementById("regular_cust_tag").checked = true;
    }
    
    var _set_old_cust_val_dialog=function(identity_id,identity_name,regular_cust_tag,cust_id,cust_name,owner_name){
    	
    		
 			//var form_dialog = _api.get("the_list_dialog").content.frames["the_list_dialog"];
 			//console.log("The document.getElementById(identity_name).value is :", document.getElementById(identity_name).value);
 			//console.log("The document.body.innerHTML is :", document.body.innerHTML);
 			//console.log("The the_list_dialog is :", _api.get("the_list_dialog").content);
    		var form_dialog = _api.get("the_list_dialog").content.document.getElementsByName('the_list_dialog')[0].contentWindow ;
    		//console.log("The form_dialog is :",form_dialog);
    		
    		form_dialog.document.getElementById(identity_id).value=cust_id;
        	if(_check_type==0){
        		form_dialog.document.getElementById(identity_name).value=cust_name;
        	}else if(_check_type==1){
        		form_dialog.document.getElementById(identity_name).value=owner_name;
        	}        	
        	document.getElementById("regular_cust_tag").checked = true;
    }
    
    var _clean_old_cust_val=function(identity_id,identity_name,regular_cust_tag,cust_id,cust_name,owner_name){
    	//alert("the identity_id is :"+identity_id+" identity_name is :"+identity_name+" regular_cust_tag is :"+regular_cust_tag );
    	if(document.getElementById(identity_id))
    		document.getElementById(identity_id).value="";
    	if(document.getElementById(identity_name))
    		document.getElementById(identity_name).value="";
    	if(document.getElementById(regular_cust_tag))
    		document.getElementById(regular_cust_tag).checked = false;
    }   
    
    var _clean_old_cust_val_dialog=function(identity_id,identity_name,regular_cust_tag,cust_id,cust_name,owner_name){
    	if( !_api.get('the_list_dialog') || !_api.get('the_list_dialog') )
	    	alert( '请先打开窗口' );
	    else {
	    
	    
	    	//var form_dialog = _api.get("the_list_dialog").content.frames["the_list_dialog"];
	    	var form_dialog = _api.get("the_list_dialog").content.document.getElementsByName('the_list_dialog')[0].contentWindow ;
	    	if(form_dialog.document.getElementById(identity_id))
    			form_dialog.document.getElementById(identity_id).value="";
    		if(form_dialog.document.getElementById(identity_name))
    			form_dialog.document.getElementById(identity_name).value="";
    		if(form_dialog.document.getElementById(regular_cust_tag))
    			form_dialog.document.getElementById(regular_cust_tag).checked = false;   
	    }	 
    }            
    
    var _show_input_old_cust_dialog =function(content,left,top,identity_id,identity_name,regular_cust_tag,cust_id,cust_name,owner_name){ 

  			if(_api!=null){
  			_current_dialog=_w.$.dialog({
                id:'customer_input_dialog',
    			left: left,
    			top:top,
    			title:'老客户提示',
    			content: content,
    			max: false,
    			min: false,    			
    			lock:false,   
    			parent:_api,			
    			button: [
        			{
            			name: '老客户',
            			callback: function(){
            				if(ctutil.get_browse()=='firefox'){
            					_set_old_cust_val_dialog(identity_id,identity_name,regular_cust_tag,cust_id,cust_name,owner_name);
            				}else{
            					_set_old_cust_val(identity_id,identity_name,regular_cust_tag,cust_id,cust_name,owner_name);
            				}            				
            			},
            			focus: true
        			},
        			{
            			name: '新客户',
            			callback: function(){
            				if(ctutil.get_browse()=='firefox'){
            					_clean_old_cust_val_dialog(identity_id,identity_name,regular_cust_tag,cust_id,cust_name,owner_name);
            				}else{
            					_clean_old_cust_val(identity_id,identity_name,regular_cust_tag,cust_id,cust_name,owner_name);
            				}    
            			}
        			},
        			{
            			name: '取消'
        			}
    			]
			});  	
			
				
  			}else{
  			$.dialog({
                id:'customer_input_dialog',
    			left: left,
    			top:top,
    			title:'老客户提示',
    			content: content,
    			max: false,
    			min: false,
    			button: [
        			{
            			name: '老客户',
            			callback: function(){
            				_set_old_cust_val(identity_id,identity_name,regular_cust_tag,cust_id,cust_name,owner_name);
            			},
            			focus: true
        			},
        			{
            			name: '新客户',
            			callback: function(){
            				_clean_old_cust_val(identity_id,identity_name,regular_cust_tag,cust_id,cust_name,owner_name);
            			}
        			},
        			{
            			name: '取消'
        			}
    			]
			});  			
  			}
     
   }
        
   var _show_disabled_old_cust_dialog=function (content,left,top,identity_id,identity_name,regular_cust_tag,cust_id,cust_name,owner_name){
 			if(_w!=null){
 			 _current_dialog=_w.$.dialog({
                id:'customer_disable_dialog',
    			left: left,
    			top:top,
    			title:'老客户提示',
    			content: content,
    			max: false,
    			min: false,    
    			lock:false, 	
    			parent:_api,		
    			button: [        			
        			{
            			name: '确定',
            			callback: function(){
            				if(ctutil.get_browse()=='firefox'){
            					_clean_old_cust_val_dialog(identity_id,identity_name,regular_cust_tag,cust_id,cust_name,owner_name);
            				}else{
            					_clean_old_cust_val(identity_id,identity_name,regular_cust_tag,cust_id,cust_name,owner_name);
            				} 
            			}
        			},
        			{
            			name: '取消'
        			}
    			]
			});  
 			}else{
 			$.dialog({
                id:'customer_disable_dialog',
    			left: left,
    			top:top,
    			title:'老客户提示',
    			content: content,
    			max: false,
    			min: false,    			
    			button: [        			
        			{
            			name: '确定',
            			callback: function(){
							_clean_old_cust_val(identity_id,identity_name,regular_cust_tag,cust_id,cust_name,owner_name);
            			}
        			},
        			{
            			name: '取消'
        			}
    			]
			});   			
 			}
        
    } 
    
    return {
   		/*判断是否是老客户
   			*identity_value 电话号码或者身份证
   			*left  位置
   			*top top位置
   			*obj_type  0-车源；1-客源
   			*check_type  0-电话；1-身份证
   			*identity_id 客户节点id 按钮事件需要
   			*identity_name 客户节点名称 按钮事件需要
   			*regular_cust_tag 老客户复选框id
   	    */
		check_old_cust_identity:function (identity_value,left,top,obj_type,check_type,identity_id,identity_name,regular_cust_tag){
			_check_type=check_type;
	        var params = {"identityId":identity_value,"objId":"0","objType":obj_type,"chkType":check_type};
	       
	        $.getJSON(sy.bp()+"/acquMgr/acqu!getDuplicateInfoByIndentityId.action?"+new Date(),params,function(data){
		    	console.log("the code is :%s",data.code);
		    	if(data.code == 0) {		            	
		        	$("#"+regular_cust_tag).attr("checked",false);   
		            return;
		        }else{
		        	$("#"+identity_id).val("");	        
	        		$("#"+regular_cust_tag).attr("checked",false); 
			        _show_old_cust_dialog(left,top,identity_id,identity_name,regular_cust_tag,
			        	data.code,data.custId, data.custName,data.infoDesc, data.staffName,data.ownerName);
			       
		        }
	       });
       	},
		check_old_cust_identity_dialg:function (identity_value,left,top,obj_type,check_type,identity_id,identity_name,regular_cust_tag,api,w){
			_check_type=check_type;
			_api=api;
			_w=w;
	        var params = {"identityId":identity_value,"objId":"0","objType":obj_type,"chkType":check_type};
	       
	        $.getJSON(sy.bp()+"/acquMgr/acqu!getDuplicateInfoByIndentityId.action?"+new Date(),params,function(data){
		    	console.log("the code is :%s",data.code);
		    	if(data.code == 0) {		            	
		        	$("#"+regular_cust_tag).attr("checked",false);   
		            return;
		        }else{
		        	$("#"+identity_id).val("");	        
	        		$("#"+regular_cust_tag).attr("checked",false); 
			        _show_old_cust_dialog(left,top,identity_id,identity_name,regular_cust_tag,
			        	data.code,data.custId, data.custName,data.infoDesc, data.staffName,data.ownerName);
			       
		        }
	       });
       	}         	
    };
})();
