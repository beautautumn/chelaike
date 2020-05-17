/**
 * 包含easyui的扩展和常用的jQuery方法扩展.
 * @author 尔演&Eryan eryanwcp@gmail.com
 * @version 2013-05-26
 */

//Easyui 扩展

/**
 * 定义全局对象，easyui的扩展命名空间.
 */
var eu = $.extend({}, eu);


eu.confirmMsg=function(msg,url){
	$.messager.confirm('确认操作',msg,function(r){  
    	if (r){     	   		
        	$.ajax({    
              type:'post',        
              url:url,    
              data:"",    
              cache:false,    
              async : false, //默认为true 异步     
              success:function(data){
        		if(data.code=="0")
        		{	
        			alert(data.msg);
        		}
        		else
        		{
        	        alert(data.msg);
        	        window.location.href=window.location.href;
        		}
              }
          });          
         
    	}  
	});  
}
/**
 * 弹出窗口 提示信息.
 * @param msg 消息内容
 */
eu.showMsg = function(msg) {
    $.messager.show({
        title: '提示信息！',
        msg: msg,
        timeout: 3000,
        showType: 'show' //null,slide,fade,show.
    });
}

/**
 * 弹出窗口 提示信息.
 * @param msgString
 * @param msgType info,error,question,warning
 */
eu.showAlertMsg = function(msgString, msgType) {
	$.messager.alert('提示信息！', msgString, msgType);
}

eu.showAlertMsgWithCallback = function(msgString, msgType,callback) {
	$.messager.alert('提示信息！', msgString, msgType,callback);
}

/**
 * 带进度条提示信息
 * @param msg 消息内容
 * @param time 超时时间(毫秒值)
 */
eu.showProMsg = function(msg,time) {
	$.messager.progress({
		title:'提示信息！',
		msg:msg
	});
	setTimeout(function(){
		$.messager.progress('close');
	},time);
}


/**
 * 添加页面到指定选项卡.
 * @param tabs 选项卡对象,或者选项卡的id
 * @param title 标题
 * @param url 链接地址
 * @param closeAble 是否允许关闭
 * @param iconCls 图标
 */
eu.addTab = function(tabs,title,url,closeAble,iconCls, reload){
	var closable = true;
	if(undefined != typeof closeAble){
		closable = closeAble;
	}
	//如果tabs是字符串类型则代表选项卡的id
	if(typeof tabs == 'string'){
		tabs = $('#'+tabs).tabs();
	}
	if(iconCls == 'undefined'){
		iconCls = '';
	}
	//如果当前title的tab不存在则创建一个tab
	if(!tabs.tabs('exists',title)){
		tabs.tabs('addIframeTab',{      
		    tab:{title:title,closable:closable,iconCls:iconCls,cache:true},      
		    iframe:{src:url}      
		});    
	}else {
		if(reload){
            tabs.tabs('refreshIframeTab',{
                tab:{title:title,closable:closable,iconCls:iconCls,cache:true},
                iframe:{src:url}
            });
            tabs.tabs('select', title);
		}else{
            tabs.tabs('select', title);
        }
    }
}

eu.refreshTab=function(tabs,title){	
	var selectedTab=tabs.tabs('getTab',title);
	var tab;
	if(selectedTab){
		tab = selectedTab;
	}else{
		tab = layout_center_tabs.tabs('getSelected');
	}
	var href = tab.panel('options').href;
	if (href) {/*说明tab是以href方式引入的目标页面*/
		var index = layout_center_tabs.tabs('getTabIndex', tab);
		layout_center_tabs.tabs('getTab', index).panel('refresh');
	} else {/*说明tab是以content方式引入的目标页面*/
		var panel = tab.panel('panel');
		var iframe = panel.find('iframe');
		layout_center_tabs.tabs('updateIframeTab',{      
			which:tab.panel('options').title,
			iframe:{src:iframe[0].src}
		}); 
	}
}

/**
 * 扩展easyui属性 dategrid表头居中.
 */
eu.datagridHeaderCenter = function() {
    $(".datagrid-header div").css('textAlign', 'center');
}
/**
 * easyui title居中
 */
eu.panelCenter = function() {
    $(".panel-title").css('text-align', 'center');
}

/**
 * 
 * @requires jQuery,EasySSH,jQuery cookie plugin
 * 
 * 更换EasySSH主题的方法
 * 
 * @param themeName
 *            主题名称
 */
eu.changeTheme = function(themeName) {
	var $easyuiTheme = $('#easyuiTheme');
	var url = $easyuiTheme.attr('href');
	var href = url.substring(0, url.indexOf('themes')) + 'themes/' + themeName + '/easyui.css';
	$easyuiTheme.attr('href', href);

	var $iframe = $('iframe');
	if ($iframe.length > 0) {
		for ( var i = 0; i < $iframe.length; i++) {
			var ifr = $iframe[i];
			$(ifr).contents().find('#easyuiTheme').attr('href', href);
		}
	}

	$.cookie('easyuiThemeName', themeName, {
		expires : 7
	});
};

/**
 * 列表点击不选择
 * @param id datagrid的ID
 * @param rowIndex
 * @param rowData
 */
eu.unSelected = function(id,rowIndex,rowData){
	var selected = $('#'+id).datagrid('getSelections');
	// 获取所有选中的行数组，如果里边有这个，不选中 否则选中
	if(jQuery.inArray(rowData,selected)!=-1){
		$('#'+id).datagrid('unselectRow',rowIndex);
	} else {
		$('#'+id).datagrid('selectRow',rowIndex);
	}
}

/**
 * combo方法扩展 禁止手工改变输入框的值
 * 启用或禁用文本域
 */
$.extend($.fn.combo.methods, {
	/**
	 * 禁用combo文本域
	 * @param {Object} jq
	 * @param {Object} param stopArrowFocus:是否阻止点击下拉按钮时foucs文本域
	 * stoptype:禁用类型，包含disable和readOnly两种方式
	 */
	disableTextbox : function(jq, param) {
		return jq.each(function() {
			param = param || {};
			var textbox = $(this).combo("textbox");
			var that = this;
			var panel = $(this).combo("panel");
			var data = $(this).data('combo');
			if (param.stopArrowFocus) {
				data.stopArrowFocus = param.stopArrowFocus;
				var arrowbox = $.data(this, 'combo').combo.find('span.combo-arrow');
				arrowbox.unbind('click.combo').bind('click.combo', function() {
					if (panel.is(":visible")) {
						$(that).combo('hidePanel');
					} else {
						$("div.combo-panel").panel("close");
						$(that).combo('showPanel');
					}
				});
				textbox.unbind('mousedown.mycombo').bind('mousedown.mycombo', function(e) {
						e.preventDefault();
				});
			}
			textbox.prop(param.stoptype?param.stoptype:'disabled', true);
			data.stoptype = param.stoptype?param.stoptype:'disabled';
		});
	},
	/**
	 * 还原文本域
	 * @param {Object} jq
	 */
	enableTextbox : function(jq) {
		return jq.each(function() {
			var textbox = $(this).combo("textbox");
			var data = $(this).data('combo');
			if (data.stopArrowFocus) {
				var that = this;
				var panel = $(this).combo("panel");
				var arrowbox = $.data(this, 'combo').combo.find('span.combo-arrow');
				arrowbox.unbind('click.combo').bind('click.combo', function() {
					if (panel.is(":visible")) {
						$(that).combo('hidePanel');
					} else {
						$("div.combo-panel").panel("close");
						$(that).combo('showPanel');
					}
					textbox.focus();
				});
				textbox.unbind('mousedown.mycombo');
				data.stopArrowFocus = null;
			}
			textbox.prop(data.stoptype, false);
			data.stoptype = null;
		});
	}
});

/**
 * EasyUI from方法扩展
 */
$.extend($.fn.form.methods, {
	/**
	 * getData 获取数据接口
	 * 使用示例:$('#ff').form('getData',true);
	 * @param {Object} jq
	 * @param {Object} params 设置为true的话，会把string型"true"和"false"字符串值转化为boolean型。
	 */
    getData: function(jq, params){
        var formArray = jq.serializeArray();
        var oRet = {};
        for (var i in formArray) {
            if (typeof(oRet[formArray[i].name]) == 'undefined') {
                if (params) {
                    oRet[formArray[i].name] = (formArray[i].value == "true" || formArray[i].value == "false") ? formArray[i].value == "true" : formArray[i].value;
                }
                else {
                    oRet[formArray[i].name] = formArray[i].value;
                }
            }
            else {
                if (params) {
                    oRet[formArray[i].name] = (formArray[i].value == "true" || formArray[i].value == "false") ? formArray[i].value == "true" : formArray[i].value;
                }
                else {
                    oRet[formArray[i].name] += "," + formArray[i].value;
                }
            }
        }
        return oRet;
    },
    /**
     * 将form表单 启用/禁用
     * $('#fm').form('disable', true);	 // 禁用
     * $('#fm').form('disable', false); // 启用
     * @param jq
     * @param isDisabled 是否禁用（禁用 true 启用 false）
     */
    disable:function(jq, isDisabled){
    	var formId = jq.attr('id');
    	var attr="disable"; 
    	var attr_r = true;
        if(!isDisabled){  
           attr="enable";
           attr_r = false;
        }  
        $("form[id='"+formId+"'] :text").attr("disabled",isDisabled);  
        $("form[id='"+formId+"'] textarea").attr("disabled",isDisabled);  
        $("form[id='"+formId+"'] select").attr("disabled",isDisabled);  
        $("form[id='"+formId+"'] :radio").attr("disabled",isDisabled);  
        $("form[id='"+formId+"'] :checkbox").attr("disabled",isDisabled);  
          
        //禁用jquery easyui中的下拉选（使用input生成的combox）  
        $("#" + formId + " input[class='combobox-f combo-f']").each(function () {  
            if (this.id) {  
                $("#" + this.id).combobox(attr); 
                $("#" + this.id).combobox('readonly',attr_r);
            }  
        });  
        //禁用jquery easyui中的下拉选（使用select生成的combox）  
        $("#" + formId + " select[class='combobox-f combo-f']").each(function () {  
            if (this.id) {  
                $("#" + this.id).combobox(attr);  
                $("#" + this.id).combobox('readonly',attr_r);
            }  
        });  
        //禁用jquery easyui中的日期组件dataBox  
        $("#" + formId + " input[class='datebox-f combo-f']").each(function () {  
            if (this.id) {  
                $("#" + this.id).datebox(attr);  
               $("#" + this.id).datebox('readonly',attr_r);
            }  
        });  
    }
});

/**  
 * 扩展EasyUI tabs方法
 * addIframeTab方法的参数包含以下属性：
 * 名称	参数类型	描述以及默认值
 * tab	object	该参数是对象，其属性列表同于tabs自带add方法的入参属性列表
 * iframe.src	string	目标框架页面的地址，必填项
 * iframe.height	string	框架标签iframe的高度，默认值为'100%'
 * iframe.width	string	框架标签iframe的宽度，默认值为'100%'
 * iframe.frameBorder	number	框架标签iframe的边框宽度，默认值为0
 * iframe.message	string	加载中效果显示的消息，默认值为'页面加载中...'
 * which string/number 更新方法updateIframeTab tab标题或索引号
 */ 
$.extend($.fn.tabs.methods, {   
    /**
     * 加载iframe内容  
     * @param  {jq Object} jq     [description]  
     * @param  {Object} params    params.which:tab的标题或者index;params.iframe:iframe的相关参数  
     * @return {jq Object}        [description]  
     */  
    loadTabIframe:function(jq,params){   
        return jq.each(function(){   
            var $tab = $(this).tabs('getTab',params.which);   
            if($tab==null) return;   
  
            var $tabBody = $tab.panel('body');   
  
            //销毁已有的iframe   
            var $frame=$('iframe', $tabBody);   
            if($frame.length>0){   
                $frame[0].contentWindow.document.write('');   
                $frame[0].contentWindow.close();   
                $frame.remove();   
                if($.browser.msie){   
                    CollectGarbage();   
                }   
            }   
            $tabBody.html('');   
  
            $tabBody.css({'overflow':'hidden','position':'relative'});      
            var $mask = $('<div style="position:absolute;z-index:2;width:100%;height:100%;background:#ccc;z-index:1000;opacity:0.3;filter:alpha(opacity=30);"><div>').appendTo($tabBody);      
            var $maskMessage = $('<div class="mask-message" style="z-index:3;width:auto;height:16px;line-height:16px;position:absolute;top:50%;left:50%;margin-top:-20px;margin-left:-92px;border:2px solid #d4d4d4;padding: 12px 5px 10px 30px;background: #ffffff url(\''
            		+ctx+'/js/plugins/jquery/easyui-1.3.4/themes/default/images/loading.gif\') no-repeat scroll 5px center;">'
            		+ (params.iframe.message || '页面加载中...') + '</div>').appendTo($tabBody);
			var $containterMask = $('<div style="position:absolute;width:100%;height:100%;z-index:1;background:#fff;"></div>').appendTo($tabBody);      
            var $containter = $('<div style="position:absolute;width:100%;height:100%;z-index:0;"></div>').appendTo($tabBody);      
     
            var iframe = document.createElement("iframe");      
            iframe.src = params.iframe.src;      
            iframe.frameBorder = params.iframe.frameBorder || 0;      
            iframe.height = params.iframe.height || '100%';      
            iframe.width = params.iframe.width || '100%';      
            var finist =function(){
            	$([$mask[0],$maskMessage[0]]).fadeOut(params.iframe.delay || 'slow',function(){   
                    $(this).remove();   
                    if($(this).hasClass('mask-message')){   
                        $containterMask.fadeOut(params.iframe.delay || 'slow',function(){   
                            $(this).remove();   
                        });   
                    }   
                }); 
            }
            if (iframe.attachEvent){   
                iframe.attachEvent("onload", finist);   
            } else {   
                iframe.onload = finist;   
            }        
            $containter[0].appendChild(iframe);   
        });   
    },   
     /**
     * 增加iframe模式的标签页    
     * @param {[type]} jq     [description]    
     * @param {[type]} params [description]    
     */     
    addIframeTab:function(jq,params){      
        return jq.each(function(){      
            if(params.tab.href){      
                delete params.tab.href;      
            }      
            $(this).tabs('add',params.tab);     
            $(this).tabs('loadTabIframe',{'which':params.tab.title,'iframe':params.iframe});         
        });      
    },
    refreshIframeTab:function(jq,params){
        return jq.each(function(){
            if(params.tab.href){
                delete params.tab.href;
            }
            // $(this).tabs('add',params.tab);
            $(this).tabs('loadTabIframe',{'which':params.tab.title,'iframe':params.iframe});
        });
    },
    /**
     * 更新tab的iframe内容  
     * @param  {jq Object} jq     
     * @param  {Object} params   which:tab标题或索引号
     * @return {jq Object}     
     */  
    updateIframeTab:function(jq,params){      
        return jq.each(function(){     
            params.iframe = params.iframe || {};   
            if(!params.iframe.src){   
                var $tab = $(this).tabs('getTab',params.which);   
                if($tab==null) return;   
                var $tabBody = $tab.panel('body');   
                var $iframe = $tabBody.find('iframe');   
                if($iframe.length===0) return;   
                $.extend(params.iframe,{'src':$iframe.attr('src')});   
            }   
            $(this).tabs('loadTabIframe',params);         
        });      
    } ,
    /**
     * 设置tab标题
     * 使用方法：
     *   var tab = $('#tt').tabs('getSelected');
     *   $('#tt').tabs('setTabTitle',{tab:tab,title:"New Title"});
     * @param jq
     * @param opts
     * @returns {*}
     */
    setTabTitle:function(jq,opts){
        return jq.each(function(){
            var tab = opts.tab;
            var options = tab.panel("options");
            var tab = options.tab;
            options.title = opts.title;
            var title = tab.find("span.tabs-title");
            title.html(opts.title);
        });
    }
});  


/**
 * 使panel和datagrid在加载时提示
 * 
 * @author 尔演@Eryan eryanwcp@gmail.com
 * 
 * @requires jQuery,EasyUI
 * 
 */
$.fn.panel.defaults.loadingMessage = '加载中....';
$.fn.datagrid.defaults.loadMsg = '加载中....';
/**
 * 
 * @requires jQuery,EasyUI
 * 
 * 避免验证tip屏幕跑偏
 */
var removeEasyuiTipFunction = function() {
	window.setTimeout(function() {
		$('div.validatebox-tip').remove();
	}, 0);
};
$.fn.panel.defaults.onClose = removeEasyuiTipFunction;
$.fn.window.defaults.onClose = removeEasyuiTipFunction;
$.fn.dialog.defaults.onClose = removeEasyuiTipFunction;

/**
 * 
 * @requires jQuery,EasyUI
 * 
 * 为datagrid、treegrid增加表头菜单，用于显示或隐藏列，注意：冻结列不在此菜单中
 */
var createGridHeaderContextMenu = function(e, field) {
	e.preventDefault();
	var grid = $(this);/* grid本身 */
	var headerContextMenu = this.headerContextMenu;/* grid上的列头菜单对象 */
	if (!headerContextMenu) {
		var tmenu = $('<div style="width:100px;"></div>').appendTo('body');
		var fields = grid.datagrid('getColumnFields');
		for ( var i = 0; i < fields.length; i++) {
			var fildOption = grid.datagrid('getColumnOption', fields[i]);
			var title = fildOption.title;
			var field = fildOption.field;
			if(field == 'ck'){
				title = "全选";		
			}
			if (!fildOption.hidden) {
				$('<div iconCls="icon-ok" field="' + fields[i] + '"/>').html(title).appendTo(tmenu);
			} else {
				$('<div iconCls="icon-empty" field="' + fields[i] + '"/>').html(title).appendTo(tmenu);
			}
		}
		headerContextMenu = this.headerContextMenu = tmenu.menu({
			onClick : function(item) {
				var field = $(item.target).attr('field');
				if (item.iconCls == 'icon-ok') {
					if(fields.length>1){
						grid.datagrid('hideColumn', field);
						$(this).menu('setIcon', {
							target : item.target,
							iconCls : 'icon-empty'
						});
					}
					
				} else {
					grid.datagrid('showColumn', field);
					$(this).menu('setIcon', {
						target : item.target,
						iconCls : 'icon-ok'
					});
				}
			}
		});
	}
	headerContextMenu.menu('show', {
		left : e.pageX,
		top : e.pageY
	});
};
$.fn.datagrid.defaults.onHeaderContextMenu = createGridHeaderContextMenu;
$.fn.treegrid.defaults.onHeaderContextMenu = createGridHeaderContextMenu;

/**
 * 
 * @requires jQuery,EasyUI
 * 
 * 防止panel/window\dialog组件超出浏览器边界
 * @param left
 * @param top
 */
var easyuiPanelOnMove = function(left, top) {
	var l = left;
	var t = top;
	if (l < 1) {
		l = 1;
	}
	if (t < 1) {
		t = 1;
	}
	var width = parseInt($(this).parent().css('width')) + 14;
	var height = parseInt($(this).parent().css('height')) + 14;
	var right = l + width;
	var buttom = t + height;
	var browserWidth = $(document).width();
	var browserHeight = $(document).height();
	if (right > browserWidth) {
		l = browserWidth - width;
	}
	if (buttom > browserHeight) {
		t = browserHeight - height;
	}
	$(this).parent().css({/* 修正面板位置 */
		left : l,
		top : t
	});
};
$.fn.dialog.defaults.onMove = easyuiPanelOnMove;
$.fn.window.defaults.onMove = easyuiPanelOnMove;
$.fn.panel.defaults.onMove = easyuiPanelOnMove;

/**
 * @author 尔演@Eryan eryanwcp@gmail.com
 * 
 * @requires jQuery,EasyUI
 * 
 * panel关闭时回收内存，主要用于layout使用iframe嵌入网页时的内存泄漏问题
 */
$.fn.panel.defaults.onBeforeDestroy = function() {
	var frame = $('iframe', this);
	try {
		if (frame.length > 0) {
			frame[0].contentWindow.document.write('');
			frame[0].contentWindow.close();
			frame.remove();
			if ($.browser.msie) {
				CollectGarbage();
			}
		}
	} catch (e) {
	}
};

/**
 * 
 * @requires jQuery,EasyUI
 * 
 * 扩展datagrid，添加动态增加或删除Editor的方法,提示消息、取消提示消息方法
 * 
 * 例子如下，第二个参数可以是数组
 * 
 * datagrid.datagrid('removeEditor', 'cpwd');
 * 
 * datagrid.datagrid('addEditor', [ { field : 'ccreatedatetime', editor : { type : 'datetimebox', options : { editable : false } } }, { field : 'cmodifydatetime', editor : { type : 'datetimebox', options : { editable : false } } } ]);
 * 
 */
$.extend($.fn.datagrid.methods, {
	addEditor : function(jq, param) {
		if (param instanceof Array) {
			$.each(param, function(index, item) {
				var e = $(jq).datagrid('getColumnOption', item.field);
				e.editor = item.editor;
			});
		} else {
			var e = $(jq).datagrid('getColumnOption', param.field);
			e.editor = param.editor;
		}
	},
	removeEditor : function(jq, param) {
		if (param instanceof Array) {
			$.each(param, function(index, item) {
				var e = $(jq).datagrid('getColumnOption', item);
				e.editor = {};
			});
		} else {
			var e = $(jq).datagrid('getColumnOption', param);
			e.editor = {};
		}
	},
    /**
     * 动态设置列标题
     * 用法:
     *   $("#dg").datagrid("setColumnTitle",{field:'productid',text:'newTitle'})
     * @param jq
     * @param option
     * @returns {*}
     */
    setColumnTitle: function(jq, option){
        if(option.field){
            return jq.each(function(){
                var $panel = $(this).datagrid("getPanel");
                var $field = $('td[field='+option.field+']',$panel);
                if($field.length){
                    var $span = $("span",$field).eq(0);
                    $span.html(option.text);
                }
            });
        }
        return jq;
    },
    columnMoving: function(jq){
        return jq.each(function(){
            var target = this;
            var cells = $(this).datagrid('getPanel').find('div.datagrid-header td[field]');
            cells.draggable({
                revert:true,
                cursor:'pointer',
                edge:5,
                proxy:function(source){
                    var p = $('<div class="tree-node-proxy tree-dnd-no" style="position:absolute;border:1px solid #ff0000"/>').appendTo('body');
                    p.html($(source).text());
                    p.hide();
                    return p;
                },
                onBeforeDrag:function(e){
                    e.data.startLeft = $(this).offset().left;
                    e.data.startTop = $(this).offset().top;
                },
                onStartDrag: function(){
                    $(this).draggable('proxy').css({
                        left:-10000,
                        top:-10000
                    });
                },
                onDrag:function(e){
                    $(this).draggable('proxy').show().css({
                        left:e.pageX+15,
                        top:e.pageY+15
                    });
                    return false;
                }
            }).droppable({
                    accept:'td[field]',
                    onDragOver:function(e,source){
                        $(source).draggable('proxy').removeClass('tree-dnd-no').addClass('tree-dnd-yes');
                        $(this).css('border-left','1px solid #ff0000');
                    },
                    onDragLeave:function(e,source){
                        $(source).draggable('proxy').removeClass('tree-dnd-yes').addClass('tree-dnd-no');
                        $(this).css('border-left',0);
                    },
                    onDrop:function(e,source){
                        $(this).css('border-left',0);
                        var fromField = $(source).attr('field');
                        var toField = $(this).attr('field');
                        setTimeout(function(){
                            moveField(fromField,toField);
                            $(target).datagrid();
                            $(target).datagrid('columnMoving');
                        },0);
                    }
                });

            // move field to another location
            function moveField(from,to){
                var columns = $(target).datagrid('options').columns;
                var cc = columns[0];
                var c = _remove(from);
                if (c){
                    _insert(to,c);
                }
                $(target).datagrid('reload');

                function _remove(field){
                    for(var i=0; i<cc.length; i++){
                        if (cc[i].field == field){
                            var c = cc[i];
                            cc.splice(i,1);
                            return c;
                        }
                    }
                    return null;
                }
                function _insert(field,c){
                    var newcc = [];
                    for(var i=0; i<cc.length; i++){
                        if (cc[i].field == field){
                            newcc.push(c);
                        }
                        newcc.push(cc[i]);
                    }
                    columns[0] = newcc;
                }
            }
        });
    }
});

//datagrid扩展
/**
 * 合并单元格扩展
 */
var gridautoMergeCellsOptions = {
	autoMergeCells : function (jq, fields) {
		return jq.each(function () {
			var target = $(this);
			if (!fields) {
				fields = target.datagrid("getColumnFields");
			}
			var rows = target.datagrid("getRows");
			var i = 0,
			j = 0,
			temp = {};
			for (i; i < rows.length; i++) {
				var row = rows[i];
				j = 0;
				for (j; j < fields.length; j++) {
					var field = fields[j];
					var tf = temp[field];
					if (!tf) {
						tf = temp[field] = {};
						tf[row[field]] = [i];
					} else {
						var tfv = tf[row[field]];
						if (tfv) {
							tfv.push(i);
						} else {
							tfv = tf[row[field]] = [i];
						}
					}
				}
			}
			$.each(temp, function (field, colunm) {
				$.each(colunm, function () {
					var group = this;
					
					if (group.length > 1) {
						var before,
						after,
						megerIndex = group[0];
						for (var i = 0; i < group.length; i++) {
							before = group[i];
							after = group[i + 1];
							if (after && (after - before) == 1) {
								continue;
							}
							var rowspan = before - megerIndex + 1;
							if (rowspan > 1) {
								target.datagrid('mergeCells', {
									index : megerIndex,
									field : field,
									rowspan : rowspan
								});
							}
							if (after && (after - before) != 1) {
								megerIndex = after;
							}
						}
					}
				});
			});
		});
	}
}
/**
 * grid tooltip参数.
 * onlyShowNowrap	string	是否只有在文字被截断时才显示tip，默认值为false，即所有单元格都显示tip。
 * position	string	tip的位置，默认值为top,可以为top,botom,right,left。
 * tipStyler	object	tip内容的样式，注意要符合jquery css函数的要求。
 * contentStyler	object	整个tip的样式，注意要符合jquery css函数的要求。
 * fields object 要显示的字段 (如果传递了该参数，则参数onlyShowNowrap无效)
 */
var gridTooltipOptions = {   
		showTooltip : function (jq, params) { 
			if(!params){
				params = {};
			}
	        function showTip(showParams, td, e, dg) {   
	            //无文本，不提示。   
	            if ($(td).text() == "") return;   
	  
	            var options = dg.data('datagrid');   
	            showParams.content = '<div class="tipcontent">' + showParams.content + '</div>';   
	            $(td).tooltip({   
	                content:showParams.content,   
	                trackMouse:true,   
	                position:params.position,   
	                onHide:function () {   
	                    $(this).tooltip('destroy');   
	                },  
	                onUpdate : function(p) {
						var tip = $(this).tooltip('tip');
						if (parseInt(tip.css('width')) > 500) {
							tip.css('width', 500);
						}
					},
	                onShow:function () {   
	                    var tip = $(this).tooltip('tip');   
	                    if(showParams.tipStyler){   
	                        tip.css(showParams.tipStyler);   
	                    }   
	                    if(showParams.contentStyler){   
	                        tip.find('div.tipcontent').css(showParams.contentStyler);   
	                    }   
	                    if (showParams.attachToMouse) {   
	                        fixPosition(tip, params.position, options);   
	                    }   
	                }   
	            }).tooltip('show');   
	  
	        };   
	        function bindEvent(delegateEle,td,grid){
	        	var options = grid.data('datagrid'); 
	        	$(delegateEle).undelegate(td, 'mouseover').undelegate(td, 'mouseout').undelegate(td, 'mousemove').delegate(td, {   
                    'mouseover':function (e) {   
                        if($(this).attr('field')===undefined) return;   
                        options.factContent = $(this).find('>div').clone().css({'margin-left':'-5000px', 'width':'auto', 'display':'inline', 'position':'absolute'}).appendTo('body');   
                        var factContentWidth = options.factContent.width();   
                        params.content = $(this).find('>div').clone().css({'width':'auto'}).html();   
                        if (params.onlyShowInterrupt && params.fields === undefined) {   
                            if (factContentWidth > $(this).width()) {   
                                showTip(params, this, e, grid);   
                            }   
                        } else {   
                            showTip(params, this, e, grid);   
                        }   
                    },   
                    'mouseout':function (e) {   
                        if (options.factContent) {   
                            options.factContent.remove();   
                            options.factContent = null;   
                        }   
                    }   
                }); 
	        };
	        return jq.each(function () {   
	            var grid = $(this);   
	            var options = $(this).data('datagrid');   
	            if (!options.tooltip) {   
	                var panel = grid.datagrid('getPanel').panel('panel');   
	                panel.find('.datagrid-body').each(function () {   
	                    var delegateEle = $(this).find('> div.datagrid-body-inner').length ? $(this).find('> div.datagrid-body-inner')[0] : this;   
	                    if (params.fields && typeof params.fields == 'object') {
	        				$.each(params.fields, function() {
	        					var field = this;
	        					bindEvent(delegateEle,'td[field=' + field + ']',grid);
	        				});
	        			} else {
	        				bindEvent(delegateEle,'td',grid);
	        			}
	                });   
	            }   
	        });  
		},   
	    /**
	     * 关闭消息提示功能  
	     * @param {} jq  
	     * @return {}  
	     */  
	    closeTooltip:function (jq) {   
	        return jq.each(function () {   
	            var data = $(this).data('datagrid');   
	            if (data.factContent) {   
	                data.factContent.remove();   
	                data.factContent = null;   
	            }   
	            var panel = $(this).datagrid('getPanel').panel('panel');   
	            panel.find('.datagrid-body').undelegate('td', 'mouseover').undelegate('td', 'mouseout').undelegate('td', 'mousemove')   
	        });   
	    }   
	};
/**
 * Datagrid扩展方法tooltip 基于Easyui 1.3.3，可用于Easyui1.3.3+
 */
$.extend($.fn.datagrid.methods, gridTooltipOptions,gridautoMergeCellsOptions);

/**
 * Treegrid扩展方法tooltip 基于Easyui 1.3.3，可用于Easyui1.3.3+
 */
$.extend($.fn.treegrid.methods, gridTooltipOptions);

/**
 * 
 * @requires jQuery,EasyUI
 * 
 * 扩展tree，使其可以获取实心节点
 */
$.extend($.fn.tree.methods, {
	getCheckedExt : function(jq) {// 获取checked节点(包括实心)
		var checked = $(jq).tree("getChecked");
		var checkbox2 = $(jq).find("span.tree-checkbox2").parent();
		$.each(checkbox2, function() {
			var node = $.extend({}, $.data(this, "tree-node"), {
				target : this
			});
			checked.push(node);
		});
		return checked;
	},
	getSolidExt : function(jq) {// 获取实心节点
		var checked = [];
		var checkbox2 = $(jq).find("span.tree-checkbox2").parent();
		$.each(checkbox2, function() {
			var node = $.extend({}, $.data(this, "tree-node"), {
				target : this
			});
			checked.push(node);
		});
		return checked;
	},
    /**
     * 获取节点级别
     * 用法：
     *   var node = $('#tree').tree("getSelected");
     *   var lv =  $('#tree').tree("getLevel",node.target);
     * @param jq
     * @param target
     * @returns {number}
     */
    getLevel:function(jq,target){
        var l = $(target).parentsUntil("ul.tree","ul");
        return l.length+1;
    },
    /**
     * 设置参数
     * @param jq
     * @param params
     * @returns {*}
     */
    setQueryParams : function (jq, params) {
        return jq.each(function () {
            $(this).tree("options").queryParams = params;
        });
    }
});

/**
 * 自定义combotree级联选择（适用于jQuery easyui 1.3.2）
 * 父节点选中,子节点将全被选中；子节点选中,所有父节点也将被选中.
 * @param tree combotree下的树tree
 * @param node 选中的节点
 */
eu.myCascadeCheck = function(tree,node) {
	if(tree == 'undefined' || node == 'undefined'){
		return;
	}
	if (node.checked) {
		node.checked = false;
		tree.tree('uncheck', node.target);
	} else {
		node.checked = true;
		tree.tree('check', node.target);
	}

	var tempNode;//被点节点 临时变量
	tempNode = node;
	//循环遍历父节点
	while (tempNode) {
		var parentNode = tree.tree('getParent', tempNode.target);//父节点
		tempNode = parentNode;
		if (tempNode) {
			tree.tree('check', tempNode.target);
		}

	}
	tempNode = node;
	if (tempNode) {
		var childNodes = tree.tree('getChildren', tempNode.target);//得到该节点下的所有节点数组
		var childNode;
		for ( var i = 0; i <= childNodes.length; i++) {
			childNode = childNodes[i];
			if (childNode) {
				if (tempNode.checked) {
					tree.tree('check', childNode.target);
				} else {
					tree.tree('uncheck', childNode.target);
				}

			}
		}

	}
}

/**
 * 
 * @requires jQuery,EasyUI
 * 
 * 扩展tree，使其支持平滑数据格式
 */
$.fn.tree.defaults.loadFilter = function(data, parent) {
	var opt = $(this).data().tree.options;
	var idFiled, textFiled, parentField;
	if (opt.parentField) {
		idFiled = opt.idFiled || 'id';
		textFiled = opt.textFiled || 'text';
		parentField = opt.parentField;
		var i, l, treeData = [], tmpMap = [];
		for (i = 0, l = data.length; i < l; i++) {
			tmpMap[data[i][idFiled]] = data[i];
		}
		for (i = 0, l = data.length; i < l; i++) {
			if (tmpMap[data[i][parentField]] && data[i][idFiled] != data[i][parentField]) {
				if (!tmpMap[data[i][parentField]]['children'])
					tmpMap[data[i][parentField]]['children'] = [];
				data[i]['text'] = data[i][textFiled];
				tmpMap[data[i][parentField]]['children'].push(data[i]);
			} else {
				data[i]['text'] = data[i][textFiled];
				treeData.push(data[i]);
			}
		}
		return treeData;
	}
	return data;
};

/**
 * @requires jQuery,EasyUI
 * 
 * 扩展treegrid，使其支持平滑数据格式
 */
$.fn.treegrid.defaults.loadFilter = function(data, parentId) {
	var opt = $(this).data().treegrid.options;
	var idFiled, textFiled, parentField;
	if (opt.parentField) {
		idFiled = opt.idFiled || 'id';
		textFiled = opt.textFiled || 'text';
		parentField = opt.parentField;
		var i, l, treeData = [], tmpMap = [];
		for (i = 0, l = data.length; i < l; i++) {
			tmpMap[data[i][idFiled]] = data[i];
		}
		for (i = 0, l = data.length; i < l; i++) {
			if (tmpMap[data[i][parentField]] && data[i][idFiled] != data[i][parentField]) {
				if (!tmpMap[data[i][parentField]]['children'])
					tmpMap[data[i][parentField]]['children'] = [];
				data[i]['text'] = data[i][textFiled];
				tmpMap[data[i][parentField]]['children'].push(data[i]);
			} else {
				data[i]['text'] = data[i][textFiled];
				treeData.push(data[i]);
			}
		}
		return treeData;
	}
	return data;
};

/**
 * @requires jQuery,EasyUI
 * 
 * 扩展combotree，使其支持平滑数据格式
 */
$.fn.combotree.defaults.loadFilter = $.fn.tree.defaults.loadFilter;

/**
 * @requires jQuery,EasyUI
 * 
 * 创建一个模式化的dialog
 * 
 * @returns $.modalDialog.handler 这个handler代表弹出的dialog句柄
 * 
 * @returns $.modalDialog.xxx 这个xxx是可以自己定义名称，主要用在弹窗关闭时，刷新某些对象的操作，可以将xxx这个对象预定义好
 */
$.modalDialog = function(options) {
	var opts = $.extend({
		title : '',
		width : 840,
		height : 680,
		modal : true,
		onClose : function() {
			$(this).dialog('destroy');
		}
	}, options);
	opts.modal = true;// 强制此dialog为模式化，无视传递过来的modal参数
	return $.modalDialog.handler = $('<div/>').dialog(opts);
};

/**
 * dialog方法扩展.
 */
$.extend($.fn.dialog.methods, {
    /**
     * dialog移动到指定位置
     * @param jq
     * @param newposition 新位置  {left: 200,top: 100}
     * @returns {*}
     */
    mymove: function(jq, newposition){
        return jq.each(function(){
            $(this).dialog('move', newposition);
        });
    }
});

/**
 * @requires jQuery,EasyUI
 * 
 * 扩展datagrid的editor
 * 
 * 增加带复选框的下拉树
 * 
 * 增加日期时间组件editor
 * 
 * 增加多选combobox组件
 */
$.extend($.fn.datagrid.defaults.editors, {
	combogrid: {
		init: function(container, options){
			var input = $('<input type="text" class="datagrid-editable-input">').appendTo(container); 
			input.combogrid(options);
			return input;
		},
		destroy: function(target){
			$(target).combogrid('destroy');
		},
		getValue: function(target){
			return $(target).combogrid('getValue');
		},
		setValue: function(target, value){
			$(target).combogrid('setValue', value);
		},
		resize: function(target, width){
			$(target).combogrid('resize',width);
		}
	},
	combocheckboxtree : {
		init : function(container, options) {
			var editor = $('<input />').appendTo(container);
			options.multiple = true;
			editor.combotree(options);
			return editor;
		},
		destroy : function(target) {
			$(target).combotree('destroy');
		},
		getValue : function(target) {
			return $(target).combotree('getValues').join(',');
		},
		setValue : function(target, value) {
			$(target).combotree('setValues', $.getList(value));
		},
		resize : function(target, width) {
			$(target).combotree('resize', width);
		}
	},
	datebox: {
        init: function (container, options) {
            var editor = $('<input type="text">').appendTo(container);
            editor.datebox(options);
            return editor;
        },
        destroy: function (target) {
            $(target).datebox('destroy');
        },
        getValue: function (target) {
            return $(target).datebox('getValue');
        },
        setValue: function (target, value) {
            $(target).datebox('setValue', $.formatDate(value,'yyyy-MM-dd'));
        },
        resize: function (target, width) {
            $(target).datebox('resize', width);
        }
    },
	datetimebox : {
		init : function(container, options) {
			var editor = $('<input />').appendTo(container);
			editor.datetimebox(options);
			return editor;
		},
		destroy : function(target) {
			$(target).datetimebox('destroy');
		},
		getValue : function(target) {
			return $(target).datetimebox('getValue');
		},
		setValue : function(target, value) {
			$(target).datetimebox('setValue', $.formatDate(value,'yyyy-MM-dd HH:mm:ss'));
		},
		resize : function(target, width) {
			$(target).datetimebox('resize', width);
		}
	},
	my97 : {   
		init : function(container, options) {
			var editor = $('<input />').appendTo(container);
			editor.my97(options);
			return editor;
		},
		getValue : function(target) {
			return $(target).my97('getValue');
		},
		setValue : function(target, value) {
			$(target).my97('setValue', value);
		},
		setDisabled : function(target, width) {
			$(target).my97('setDisabled', width);
		} 
    } ,
	multiplecombobox : {
		init : function(container, options) {
			var editor = $('<input />').appendTo(container);
			options.multiple = true;
			editor.combobox(options);
			return editor;
		},
		destroy : function(target) {
			$(target).combobox('destroy');
		},
		getValue : function(target) {
			return $(target).combobox('getValues').join(',');
		},
		setValue : function(target, value) {
			$(target).combobox('setValues', $.getList(value));
		},
		resize : function(target, width) {
			$(target).combobox('resize', width);
		}
	},
	numberspinner: {  
        init: function(container, options){  
            var input = $('<input type="text">').appendTo(container);  
            return input.numberspinner(options);  
        },  
        destroy: function(target){  
            $(target).numberspinner('destroy');  
        },  
        getValue: function(target){  
            return $(target).numberspinner('getValue');  
        },  
        setValue: function(target, value){  
            $(target).numberspinner('setValue',value);  
        },  
        resize: function(target, width){  
            $(target).numberspinner('resize',width);  
        }  
    },
    timespinner : {
        init : function (container, options) {
            var input = $('<input/>').appendTo(container);
            input.timespinner(options);
            return input
        },
        getValue : function (target) {
            var val = $(target).timespinner('getValue');
        },
        setValue : function (target, value) {
            $(target).timespinner('setValue', value);
        },
        resize : function (target, width) {
            var input = $(target);
            if ($.boxModel == true) {
                input.resize('resize', width - (input.outerWidth() - input.width()));
            } else {
                input.resize('resize', width);
            }
        }
    },
    password: {
		init: function(container, options) {
			var input = $('<input class="datagrid-editable-input" type="password"/>').appendTo(container);

			if(!$.fn.validatebox.defaults.rules.safepass) {
				$.extend($.fn.validatebox.defaults.rules, {
					safepass: {
						validator: function(value, param) {
							return !(/^(([A-Z]*|[a-z]*|\d*|[-_\~!@#\$%\^&\*\.\(\)\[\]\{\}<>\?\\\/\'\"]*)|.{0,5})$|\s/.test(value));
						},
						message: '密码由字母和数字组成，至少6位'
					}
				});
			}

			input.validatebox(options);
			return input;
		},
		getValue: function(target) {
			alert($(target).val());
			alert(target.value);
			return $(target).val();
		},
		setValue: function(target, value) {
			$(target).val(value);
		},
		resize: function(target, width) {
			var input = $(target);
			if($.boxModel == true) {
				input.width(width - (input.outerWidth() - input.width()));
			} else {
				input.width(width);
			}
		}
	}
});



/**
 * @requires jQuery,EasyUI
 * 
 * 扩展datagrid的datebox、datetimebox格式化
 * 
 */
$.fn.datebox.defaults.formatter = function(date){
    var vDate = new Date(date);
    return vDate.format('yyyy-MM-dd');
}
$.fn.datebox.defaults.parser = function(s) {
	if (!s)
		return new Date();
	var ss = new Date(s).format('yyyy-MM-dd').split('-');
	var y = parseInt(ss[0], 10);
	var m = parseInt(ss[1], 10);
	var d = parseInt(ss[2], 10);
	if (!isNaN(y) && !isNaN(m) && !isNaN(d)) {
		return new Date(y, m - 1, d);
	} else {
		return new Date();
	}
}
$.fn.datetimebox.defaults.formatter = function(date){
    var vDate = new Date(date);
    return vDate.format('yyyy-MM-dd hh:mm:ss');
}
$.fn.datetimebox.defaults.parser = function(s) {
	if (!s)
		return new Date();
	var ss = new Date(s).format('yyyy-MM-dd hh:mm:ss').split('-');
	var y = parseInt(ss[0], 10);
	var m = parseInt(ss[1], 10);
	var d = parseInt(ss[2], 10);
	if (!isNaN(y) && !isNaN(m) && !isNaN(d)) {
		return new Date(y, m - 1, d);
	} else {
		return new Date();
	}
}

/**
 * @requires jQuery,EasyUI
 * 
 * EasyUI组件加载数据通用错误提示
 * 
 * 用于datagrid/treegrid/tree/combogrid/combobox/form加载数据出错时的操作
 */
var easyuiErrorFunction = function(XMLHttpRequest) {
	$.messager.progress('close');
	var data = XMLHttpRequest.responseText;
	if(!data){
		eu.showAlertMsg('服务器无响应.','error');
	}else{
		eu.showAlertMsg(data,'error');
	}
};
$.fn.datagrid.defaults.onLoadError = easyuiErrorFunction;
$.fn.treegrid.defaults.onLoadError = easyuiErrorFunction;
$.fn.tree.defaults.onLoadError = easyuiErrorFunction;
$.fn.combogrid.defaults.onLoadError = easyuiErrorFunction;
$.fn.combobox.defaults.onLoadError = easyuiErrorFunction;
$.fn.form.defaults.onLoadError = easyuiErrorFunction;


/**
 * @requires jQuery
 * 
 * 改变jQuery的AJAX默认属性和方法
 */
$.ajaxSetup({
	type : 'POST',
	error : function(XMLHttpRequest, textStatus, errorThrown) {
		$.messager.progress('close');
		if(!data){
			eu.showAlertMsg('服务器无响应.','error');
		}else{
			eu.showAlertMsg(data,'error');
		}
	}
});
