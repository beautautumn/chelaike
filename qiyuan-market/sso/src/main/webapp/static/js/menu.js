
var menu = (function() {

    var _instance_dialog_api;
    return {    	
        get_dialog_instance : function(){
            return _instance_dialog_api;
        },
        create_dialog_identy : function(id,title,url,width,height,lock,outLink){
            var contenturl = 'url:'+ctutil.bp()+url;
            if(outLink){
                contenturl = 'url:'+url;
            }
			_instance_dialog_api=$.dialog({
    			id: id,    
    			content: contenturl,
    			title:title,
    			width:width,
    			height:height,
    			lock:lock,
    			max: false,
    		    min: false,
				ok: function(){
					this.content.do_submit();
					return false;
    			},
    			cancelVal: '关闭',
    			cancel: true 
			});         			
        },   
        create_model_dialog_identy : function(id,title,url,width,height,lock){
            _instance_dialog_api=$.dialog({
                id: id,    
    			max: false,
    		    min: false,                
                content: 'url:'+ctutil.bp()+url,
                title:title,
                width:width,
                height:height
            });                     
        },                
        create_child_dialog_identy : function(api,W,id,title,url,width,height,lock){
            _instance_dialog_api=W.$.dialog({
                id: id,   
    			max: false,
    		    min: false,
                content: 'url:'+ctutil.bp()+url,
                title:title,
                parent:api,
                width:width,
                height:height,
                lock:lock,
                ok: function(){
                    this.content.do_submit();
                    return false;
                },
                cancelVal: '关闭',
                cancel: true 
            });
        },                    
        create_max_dialog_identy : function(id,title,url){
        	_instance_dialog_api=$.dialog({
        		id: id,    
        		content: 'url:'+ctutil.bp()+url,
                max: false,
                min: false,                
        		title:title,
        		lock:true,
        		ok: function(){
        			this.content.do_submit();
        			return false;
        		},
        		cancelVal: '关闭',
        		cancel: true         			
        	}).max();;        			
        },
        create_model_max_dialog_identy : function(id,title,url){
            _instance_dialog_api=$.dialog({
                id: id,    
                content: 'url:'+ctutil.bp()+url,
                max: false,
                min: false,                
                title:title,
                lock:false                   
            }).max();;                  
        },//2014-04-22                    
        create_max_dialog_withCancel_identy : function(id,title,url){
        	_instance_dialog_api=$.dialog({
        		id: id,    
        		content: 'url:'+ctutil.bp()+url,
                max: false,
                min: false,                
        		title:title,
        		lock:true,
        		ok: function(){
        			this.content.do_confirm();
        			return false;
        		},
        		cancelVal: '取消',
        		cancel: function(){
        			this.content.do_cancel();
        			return false;
        		}        			
        	}).max();;        			
        },
        create_detail_dialog : function(id,title,url,width,height,lock,outLink){
            var contenturl = 'url:'+ctutil.bp()+url;
            if(outLink){
                contenturl = 'url:'+url;
            }
			_instance_dialog_api=$.dialog({
    			id: id,    
    			content: contenturl,
    			title:title,
    			width:width,
    			height:height,
    			lock:lock,
    			max: false,
    		    min: false,
    			cancelVal: '关闭',
    			cancel: true 
			});         			
        },
        create_dialog_identy_cust : function(id,title,url,width,height,lock,outLink,okval,cancelval){
            var contenturl = 'url:'+ctutil.bp()+url;
            if(outLink){
                contenturl = 'url:'+url;
            }
            _instance_dialog_api=$.dialog({
                id: id,
                content: contenturl,
                title:title,
                width:width,
                height:height,
                lock:lock,
                max: false,
                min: false,
                okVal:okval||'确定',
                ok: function(){
                    // this.content.do_submit();
                    this.content.do_pass();
                    return false;
                },
                cancelVal: cancelval||'拒绝',
                cancel: function(){
                    this.content.do_reject();
                    return false;
                }
            });
        }
    };
})();
