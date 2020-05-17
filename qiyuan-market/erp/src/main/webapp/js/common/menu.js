
var menu = (function() {

    var _instance_dialog_api;
    return {
        get_dialog_instance : function(){
            return _instance_dialog_api;
        },
        create_dialog_identy_remote : function(id,title,url,width,height,lock,outLink){
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
                    var dialog = this;
                    var handleResult = function (event) {
                        if (event.data === 'success') {
                            window.top.removeEventListener('message', handleResult)
                            dialog.iframe.api.get("detail_dialog", 1).close();
                            window.query1();
                        }
                    }
                    window.top.addEventListener('message', handleResult, false)
                    this.iframe.contentWindow.postMessage("save", "*");
                    return false;
                },
                cancelVal: '关闭',
                cancel: true
            });
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
        create_model_max_dialog_identy : function(id,title,url,outLink){
            var contenturl = 'url:'+ctutil.bp()+url;
            if(outLink){
                contenturl = 'url:'+url;
            }
            _instance_dialog_api=$.dialog({
                id: id,
                content: contenturl,
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
                okVal:cancelval||'驳回',
                ok: function(obj){
                    // this.content.do_submit();
                    this.content.do_reject();
                    return false;
                },
                /*cancelVal: '关闭',
                cancel: true*/

                // button({
                //     name: 'login',
                //     callback: function(){},
                //     disabled: false,
                //     focus: true
                // })
            });
            _instance_dialog_api.button({
                name: okval || '通过',
                callback: function(){
                    this.content.do_pass();
                },
                disabled: false,
                focus: true
            });
        },
        create_pic_dialog_identy : function(api,W,id,title,url,lock){
            var maxHeight = parent.innerHeight-63;
            var maxWidth = parent.innerWidth-22;
            console.log(maxHeight);
            var contentStr = '<div style="max-width:'+maxWidth+'px;max-height:'+maxHeight+'px;overflow: auto;"><img src="'+url+'" style="max-width: '+maxWidth+'px"/></div>';
            _instance_dialog_api=W.$.dialog({
                id: id,
                content: contentStr,
                title:title,
                parent:api,
                min:false,
                lock:lock
            });
        },
        create_dialog_identy_logout : function(id,title,content,width,height,lock){
            _instance_dialog_api=$.dialog({
                id: id,
                content: content,
                title:title,
                width:width,
                height:height,
                lock:lock,
                max: false,
                min: false,
                ok: function(){
                    window.do_submit();
                    return false;
                },
                cancelVal: '关闭',
                cancel: true
            });
        },
    };
})();
