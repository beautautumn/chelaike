/***********************************************/
/*评估单通用javascript
/*Author : xueyufish
/***********************************************/
evaluate_comm = (function() {
    
    //var HOTAREA_STATE_COOKIE_NAME = "erp_eval_state";   //热点状态Cookie名称
    //var HOTAREA_STATE_COOKIE_PATH = "/erp";   //热点状态Cookie路径
    //var HOTAREA_STATE_COOKIE_DOMAIN = "localhost";   //热点状态Cookie所在域
    var CUR_ADD_OPT = 0;   //当前操作状态：新增
    var CUR_UPDATE_OPT = 1;    //当前操作状态：修改
    var HOTAREA_STATE_NEW = 2;  //当前热点状态为新增
    var HOTAREA_STATE_UPDATE = 3;   //当前热点状态为修改
    var CONDITIONS_STATE_NEW = 4;   //当前工况检查状态为新增
    var CONDITIONS_STATE_UPDATE = 5;   //当前工况检查状态为修改
    
    
    /**
     * //热点评估结果对象
     * [
     *  {"itemCode" : "1", "evalKind" : "...", "evalDesc" : "...", "imgUrl" : "..."}, 
     *  {"itemCode" : "2", "evalKind" : "...", "evalDesc" : "...", "imgUrl" : "..."}, 
     *  {"itemCode" : "3", "evalKind" : "...", "evalDesc" : "...", "imgUrl" : "..."}, 
     *  {"itemCode" : "4", "evalKind" : "...", "evalDesc" : "...", "imgUrl" : "..."}, 
     *  {"itemCode" : "5", "evalKind" : "...", "evalDesc" : "...", "imgUrl" : "..."}, 
     * ]
     */
    //var HOTAREA_STATE_OBJ;
    
    return {
        
        /**
         * 初始化热点状态对象
         */
        new_hotarea_state_obj : function() {
            HOTAREA_STATE_OBJ = [];     
            return HOTAREA_STATE_OBJ;    
        },
    
        
        /**
         * 获取热点状态对象
         */
        get_hotarea_state_obj : function() {
            return HOTAREA_STATE_OBJ;
        },
        
        
        /**
         * 判断热点状态对象是否包含指定的评估项
         */
        is_eval_result_exists : function(item_code) {
            for(var i=0; i< HOTAREA_STATE_OBJ.length; i++) {
                if(HOTAREA_STATE_OBJ[i].itemCode == item_code) {
                    return true;
                }
            }
            return false;
        },

        is_eval_item_result_exists : function(item_code,item_type) {
            for(var i=0; i< HOTAREA_STATE_OBJ.length; i++) {
                if(HOTAREA_STATE_OBJ[i].itemCode == item_code) {
                    var hostpotItems=HOTAREA_STATE_OBJ[i].hostpotItems;
                    for(var j=0;hostpotItems&&j<hostpotItems.length;j++){
                        if(hostpotItems[j].itemType==item_type)
                            return true;
                    }                    
                }
            }
            return false;
        },        
        
        /**
         * 保存json数据至热点状态对象
         */
        save_eval_result : function(result_json) {
            HOTAREA_STATE_OBJ[HOTAREA_STATE_OBJ.length] = result_json;
            return HOTAREA_STATE_OBJ;
        },
        
        /**
         * 从热点对象中删除编码等于评估项编码的条目
         */
        delete_eval_result : function(item_code) {
            var curIndex = -1;
            for(var i=0; i< HOTAREA_STATE_OBJ.length; i++) {
                if(HOTAREA_STATE_OBJ[i].itemCode == item_code) {
                    curIndex = i;
                }
            }
            if(curIndex>-1)
                HOTAREA_STATE_OBJ.splice(curIndex, 1);
            return HOTAREA_STATE_OBJ;
        },     
        /**
        * 根据项目编码查找热点数据
        */
        get_eval_result_item_code : function(item_code) {
            var curIndex = -1;
            for(var i=0; i< HOTAREA_STATE_OBJ.length; i++) {
                if(HOTAREA_STATE_OBJ[i].itemCode == item_code) {
                    return HOTAREA_STATE_OBJ[i];
                }
            }
        },  
        /**
        * 根据项目编码数组查询热点数据
        */
        get_eval_result_item_code_list : function(item_code_list) {
            var result=[];
            for(var i=0; i< HOTAREA_STATE_OBJ.length; i++) {
                for(var j=0;j<item_code_list.length;j++){
                    if(HOTAREA_STATE_OBJ[i].itemCode == item_code_list[j].item_code) {
                        result.push(HOTAREA_STATE_OBJ[i]);
                    }
                }
            }
        },          
        /**
        *  根据大类别查找热点数据，并且以数组形式返回
        */
        get_eval_result_by_type: function(type) {  
            var result=[];        
            for(var i=0; i< HOTAREA_STATE_OBJ.length; i++) {                
                if(HOTAREA_STATE_OBJ[i].type==type) {
                    result.push(HOTAREA_STATE_OBJ[i]);
                }
            }          
            return result;
        }, 
        /**
        *重新渲染评估结果
        *type 大类【外观、内饰】
        *item_type 损伤类别
        */
        render_eval_result_by_type: function(type,itemType) {        	
            for(var i=0; i< HOTAREA_STATE_OBJ.length; i++) {
            	var item_code=HOTAREA_STATE_OBJ[i].itemCode;
                if(HOTAREA_STATE_OBJ[i].type==type&&HOTAREA_STATE_OBJ[i].itemType==itemType) {
                	 var data = $('#area_'+item_code).mouseout().data('maphilight') || {};
                     data.alwaysOn = true;
                     if(itemType==0){
                     	data.fillColor="04819E";
                     }else if(itemType==1){
                     	data.fillColor="FF6c00";
                     }else if(itemType==2){
                     	data.fillColor="00cc00";
                     }else if(itemType==3){
                     	data.fillColor="c30093";
                     }                     
                     $('#area_'+item_code).data('maphilight', data).trigger('alwaysOn.maphilight'); 
                }
            }    	
        },         
        
        /**
         * 从热点状态对象中获取指定的评估项并返回评估结果对象
         * 
         * 如果热点状态对象中不存在则返回null
         */
        get_cur_eval_result : function(item_code) {
            for(var i=0; i< HOTAREA_STATE_OBJ.length; i++) {
                if(HOTAREA_STATE_OBJ[i].itemCode == item_code) {
                	/**
                    evalResult = new Object();
                    evalResult.itemCode = HOTAREA_STATE_OBJ[i].itemCode;
                    evalResult.evalKind = HOTAREA_STATE_OBJ[i].evalKind;
                    evalResult.evalDesc = HOTAREA_STATE_OBJ[i].evalDesc;
                    evalResult.imgUrl = HOTAREA_STATE_OBJ[i].imgUrl;                                   	
                    return evalResult;
                     */
                    //console.log("get_cur_eval_result arg item_code is :%s return result is :%o",  item_code,HOTAREA_STATE_OBJ[i]);
                	return HOTAREA_STATE_OBJ[i];
                }
            }
            return null;
        },
        
        /**
         * 获取当前工况检查状态
         * 
         */
        get_cur_conditions_state : function(item_code) 
        {            
            var val = $("#txtCondition_" + item_code).val();
            if(val == "")
            {
                return CONDITIONS_STATE_NEW;
            } else {
                return CONDITIONS_STATE_UPDATE;
            }
        },
        
        /**
         * 获取当前工况检查结果
         *
         * 返回当前工况检查结果对象(包含其他说明数组和检测项数组)
         */        
        get_cur_conditions_result : function(conditionsItem)
        {
            console.group("get_cur_conditions_result");
            var temp = $("#txtCondition_" + conditionsItem.itemCode).val();
            var page_val = temp.split(",");
            console.log("get_cur_conditions_result, page_val is: %o", page_val);
      
            conditionsResult = new Object();
            conditionsResult.otherItemDesc = _.difference(page_val, conditionsItem.damageItems.split(","));
            conditionsResult.damageItems = _.intersection(page_val, conditionsItem.damageItems.split(","));
            console.log("get_cur_conditions_result, conditionsResult is: %o", conditionsResult);
            console.groupEnd();
            return conditionsResult;
        },
       
        get_cur_add_opt : function() 
        {
            return CUR_ADD_OPT;
        },
        
        get_cur_update_opt : function() 
        {
            return CUR_UPDATE_OPT;
        },
        
        get_hotarea_state_new : function() 
        {
            return HOTAREA_STATE_NEW;
        },
        
        get_hotarea_state_update : function() 
        {
            return HOTAREA_STATE_UPDATE;
        },
        
        get_conditions_state_new : function() 
        {
            return CONDITIONS_STATE_NEW;
        },
        
        get_conditions_state_update : function() 
        {
            return CONDITIONS_STATE_UPDATE;
        }
    };
})();  
