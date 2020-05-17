/*
车辆目录实现选择品牌后弹出品牌对话框，选中品牌后自动弹出车型对话框
品牌对话框包含首字母、车型对话框里面有厂商、车系
*/
var catalogue = (function() {

    return {
        //从服务器加载品牌html
        loadBrandHtml : function(node_id){
        	$.ajax ({
                type: "POST",
                url: sy.bp()+"/core/catalogue_brandLoad.action" ,
                data: "",
                success: function(data) {   
                    $("#"+node_id).html(data);
                }
            });
        },
         //从服务器加载车系html
        loadSeriesHtml : function(node_id,brand_code){
        	$.ajax ({
                type: "POST",
                url: sy.bp()+"/core/catalogue_seriesLoad.action" ,
                data: "brand_code="+brand_code,
                success: function(data) {   
                    $("#"+node_id).html(data);
                }
            });
        },
         //从服务器加载车型html
        loadStyleHtml : function(node_id,series_code){
        	$.ajax ({
                type: "POST",
                url: sy.bp()+"/core/catalogue_styleLoad.action" ,
                data: "series_code="+series_code,
                success: function(data) {   
                    $("#"+node_id).html(data);
                }
            });
        },           
        //选择品牌
        selectBrandValue:function(brand_div_id,series_div_id,node_name_id,node_value_id,node_name,node_value){
        	$("#"+brand_div_id).css('display','none');
        	$("#"+series_div_id).css('display','none');
        	$("#"+node_name_id).val(node_name);
        	$("#"+node_value_id).val(node_value);
        	
        	this.loadSeriesHtml(series_div_id,node_value);
        	this.displayBlock(series_div_id);
        },        
        //选择车系
        selectSeriesValue:function(series_div_id,style_div_id,node_name_id,node_value_id,node_name,node_value){
        	$("#"+style_div_id).css('display','none');
        	$("#"+series_div_id).css('display','none');
        	$("#"+node_name_id).val(node_name);
        	$("#"+node_value_id).val(node_value);
            this.show_catalogue_style();
        	//this.loadStyleHtml(series_div_id,node_value);
        	//this.displayBlock(series_div_id);
        },
       
        //选择车型
        selectStyleValue:function(series_div_id,style_div_id,node_name_id,node_value_id,node_name,node_value){
        	console.log("the node_name_id is %s,the node_value_id is %s,the node_name is %s,the node_value is %s",node_name_id,node_value_id,node_name,node_value);
        	$("#"+node_name_id).val(node_name);
        	$("#"+node_value_id).val(node_value);
            document.getElementById(node_value_id).value=node_value;
        	$("#"+series_div_id).css('display','none');
        	$("#"+style_div_id).css('display','none');
        },        
        displayBlock:function(div_id){
        	$("#"+div_id).css('display','block');
        },     
        
        displayBrandBlock:function(div_id){
        	if($("#"+div_id).css('display')=='block'){        		
        		$("#"+div_id).css('display','none');
        	}else{
        		$("#"+div_id).css('display','block');
        		
        	}        	
        	$("#series_block_div").css('display','none');
        	$("#style_block_div").css('display','none');
        },    
        
        displaySeriesBlock:function(div_id){
        	if($("#"+div_id).css('display')=='block'){
        		
        		$("#"+div_id).css('display','none');
        	}else{
        		$("#"+div_id).css('display','block');
        		
        	}
        	
        	$("#brand_block_div").css('display','none');
        	$("#style_block_div").css('display','none');
        },    
        
        displayStyleBlock:function(div_id){
        	if($("#"+div_id).css('display')=='block'){
        		
        		$("#"+div_id).css('display','none');
        	}else{
        		$("#"+div_id).css('display','block');
        		
        	}
        	
        	$("#brand_block_div").css('display','none');
        	$("#series_block_div").css('display','none');        	
        },


        show_catalogue_style:function (){
            var seriesCode=$("#seriesCode").val();
            this.loadStyleHtml('style_block_div',seriesCode);
            this.displayBlock('style_block_div');      
        },

        show_catalogue_series:function (series_block_div){
            var brandCode=$("#brandCode").val();
            this.loadSeriesHtml('series_block_div',brandCode);
            this.displayBlock('series_block_div');      
        },        

        init_click:function(e){
            if(!e){
              var e = window.event;
            }
            //获取事件点击元素
            var targ = e.target;
            //获取元素名称
            var tname = targ.tagName;
            if(!e.srcElement)return;
            var name=e.srcElement.id;
            if(name&&name!=""){
                if(name=="brandName"){              
                    $("#series_block_div").css('display','none');
                    $("#style_block_div").css('display','none');
                    $("#choose_car_color_div").css('display','none');
                    $("#choose_old_color_div").css('display','none');
                    $("#choose_uphlosert_color_div").css('display','none');                     
                }else if(name=='seriesName'){
                    $("#brand_block_div").css('display','none');
                    $("#style_block_div").css('display','none');
                    $("#choose_car_color_div").css('display','none');
                    $("#choose_old_color_div").css('display','none');
                    $("#choose_uphlosert_color_div").css('display','none');                        
                }else if(name=='styleName'){
                    $("#series_block_div").css('display','none');
                    $("#brand_block_div").css('display','none');
                    $("#choose_car_color_div").css('display','none');
                    $("#choose_old_color_div").css('display','none');
                    $("#choose_uphlosert_color_div").css('display','none');                        
                }else if(name=='carColor'){
                    $("#choose_old_color_div").css('display','none');
                    $("#choose_uphlosert_color_div").css('display','none');                      
                }else if(name=='oldColor'){
                    $("#choose_car_color_div").css('display','none');
                    $("#choose_uphlosert_color_div").css('display','none');                       
                }else if(name=='upholsteryColor'){
                    $("#choose_car_color_div").css('display','none');
                    $("#choose_old_color_div").css('display','none');                     
                }
            }else{
                $("#brand_block_div").css('display','none');
                $("#series_block_div").css('display','none');
                $("#style_block_div").css('display','none');
                $("#choose_car_color_div").css('display','none');
                $("#choose_old_color_div").css('display','none');
                $("#choose_uphlosert_color_div").css('display','none');                
            }

        }  


    };
})();
