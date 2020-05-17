/**
*
*热点数据操作类
*
*/
evaluate_hotspot = (function() {


    /**
    * 动态生成热点数据结果页面
    */
    var _generate_condition_data_html=function (conditions){

        console.log("_generate_condition_data_html the conditions is %o",conditions);
        var length=conditions.length;
        var return_html="";
        if(length>0){
                var img_str_html="";
                if(conditions[0].imgUrl&&conditions[0].imgUrl!=""){
                    img_str_html=conditions[0].imgUrl;
                }else{
                    img_str_html=sy.bp()+"/images/u462_normal.png";
                }


                var out_tr="<tr id=\"item_result_"+4+"\">"+
                    "<td rowspan=\""+length+"\" class=\"list-num\" >机电</td>"+
                    "<td class=\"list-num\">"+conditions[0].itemName+"</td>"+
                    "<td class=\"list-num\"><input type=\"text\" value=\""+conditions[0].checkDesc+"\" class=\"input w630\"/></td>"+
                    //"<td class=\"list-num\"><img src=\""+img_str_html+"\" /></td>"+
                    "<td class=\"list-num\"><input id=\"file_upload_" + conditions[0].itemCode + "\" name=\"file_upload_" + conditions[0].itemCode + "\" type=\"file\" multiple=\"false\"></td>"+
                   "</tr>"; 

                   return_html+=out_tr;

                   var script_str="<script type=\"text/javascript\">" +
                    "$(function() {" +
                        "evaluate_hotspot.upload_image("+conditions[0].itemCode+");"+
                    "}); " +
                    "</script>";

                    console.log("the script_str is %s",script_str);

                    return_html+=script_str;
        }
        if(length>1){
            for(var i=1;i<conditions.length;i++){
                if(conditions[i].itemCode){
                    var img_str_html="";
                    if(conditions[i].imgUrl&&conditions[i].imgUrl!=""){
                        img_str_html=conditions[i].imgUrl;
                    }else{
                        img_str_html=sy.bp()+"/images/u462_normal.png";
                    }                
                    var child_tr="<tr>"+
                     "<td class=\"list-num\">"+conditions[i].itemName+"</td>"+
                     "<td class=\"list-num\"><input type=\"text\"  value=\""+conditions[i].checkDesc+"\"  class=\"input w630\"/></td>"+
                     //"<td class=\"list-num\"><img src=\""+img_str_html+"\" /></td>"+
                     "<td class=\"list-num\"><input id=\"file_upload_" + conditions[i].itemCode + "\" name=\"file_upload_" + conditions[i].itemCode + "\" type=\"file\" multiple=\"false\"></td>"+
                     "</tr>"; 
                    return_html+=child_tr;

                    var script_str="<script type=\"text/javascript\">" +
                    "$(function() {" +
                        "evaluate_hotspot.upload_image("+conditions[i].itemCode+");"+
                    "}); " +
                    "</script>";

                    console.log("the script_str is %s",script_str);

                    return_html+=script_str;                    
                }
            }  
        }        
             
        return return_html;
    };    

    /**
    * 动态生成热点数据结果页面
    */
	var _generate_hostspot_data_html=function (type,typeName){

        var itemList=evaluate_comm.get_eval_result_by_type(type);
        //console.log("_generate_hostspot_data_html type is :%s,the itemList is %o",type,itemList);
        var itemIsoList=_isomerism_hostpot_items(itemList);
        //console.log("_generate_hostspot_data_html the itemIsoList is %o",itemIsoList);
        var length=itemIsoList.length;
        var return_html="";
        if(length>0){
                var img_str_html="";
                if(itemIsoList[0].imgUrl&&itemIsoList[0].imgUrl!=""){
                    img_str_html=itemIsoList[0].imgUrl;
                }else{
                    img_str_html=sy.bp()+"/images/u462_normal.png";
                }
                var out_tr="<tr id=\"item_result_"+type+"\">"+
                    "<td rowspan=\""+length+"\" class=\"list-num\" >"+typeName+"</td>"+
                    "<td class=\"list-num\">"+itemIsoList[0].itemName+"</td>"+
                    "<td class=\"list-num\"><input type=\"text\" value=\""+itemIsoList[0].itemTypeName+"\" class=\"input w630\"/></td>"+
                    //"<td class=\"list-num\"><img src=\""+img_str_html+"\" /></td>"+
                    "<td class=\"list-num\"><input id=\"file_upload_" + itemIsoList[0].itemCode + "\" name=\"file_upload_" + itemIsoList[0].itemCode + "\" type=\"file\" multiple=\"false\"></td>"+
                   "</tr>"; 
                   return_html+=out_tr;

                var script_str="<script type=\"text/javascript\">" +
                    "$(function() {" +
                        "evaluate_hotspot.upload_image("+itemIsoList[0].itemCode+");"+
                    "}); " +
                    "</script>";

                    console.log("the script_str is %s",script_str);

                    return_html+=script_str;                   
        }
        if(length>1){
            for(var i=1;i<itemIsoList.length;i++){
               var img_str_html="";
                if(itemIsoList[i].imgUrl&&itemIsoList[i].imgUrl!=""){
                    img_str_html=itemIsoList[i].imgUrl;
                }else{
                    img_str_html=sy.bp()+"/images/u462_normal.png";
                }                
                var child_tr="<tr>"+
                     "<td class=\"list-num\">"+itemIsoList[i].itemName+"</td>"+
                     "<td class=\"list-num\"><input type=\"text\"  value=\""+itemIsoList[i].itemTypeName+"\"  class=\"input w630\"/></td>"+
                     //"<td class=\"list-num\"><img src=\""+img_str_html+"\" /></td>"+
                     "<td class=\"list-num\"><input id=\"file_upload_" + itemIsoList[i].itemCode + "\" name=\"file_upload_" + itemIsoList[i].itemCode + "\" type=\"file\" multiple=\"false\"></td>"+
                     "</tr>"; 
                return_html+=child_tr;

                var script_str="<script type=\"text/javascript\">" +
                   "$(function() {" +
                        "evaluate_hotspot.upload_image("+itemIsoList[i].itemCode+");"+
                   "}); " +
                  "</script>";

                console.log("the script_str is %s",script_str);

                return_html+=script_str;            
            }  
        }        
             
        return return_html;
    };

    //根据损伤类型获得损伤名称
    var _get_exterior_type_name=function(item_type,type){ 
    	if(type==2){
    		if(item_type==0)return "P-划痕/褪色";
    		else if(item_type==1)return "B-凹陷";
    		else if(item_type==2)return "W-重新喷漆";  
    	}else if(type==3){
    		if(item_type==0)return "P-划痕/损伤/褪色";
    		else if(item_type==1)return "B-凹陷/脱落";
    		else if(item_type==2)return "X-断裂/破损/烧焦";     		
    	}else if(type==0||type==1){
    		if(item_type==0)return "B1-凹陷（小）";
    		else if(item_type==1)return "B2-凹陷（中）";
    		else if(item_type==2)return "B3-凹陷（大）";  
    		else if(item_type==3)return "S-生锈";   		
    	}
  	
    };

     //画板着色
    var _draw_hostspot_data =function (item){
        var data = $('#area_'+item.itemCode).mouseout().data('maphilight') || {};
        if(!item.isMultiple)
            data.alwaysOn = !data.alwaysOn;
        else data.alwaysOn=true;
        //不同的类别颜色不一样
        if(item.currentItemType==0){
        	data.fillColor="04819E";
        }else if(item.currentItemType==1){
        	data.fillColor="FF6c00";
        }else if(item.currentItemType==2){
        	data.fillColor="00cc00";
        }else if(item.currentItemType==3){
        	data.fillColor="c30093";
        }
        $('#area_'+item.itemCode).data('maphilight', data).trigger('alwaysOn.maphilight');      
        //console.log("the data.alwaysOn is :%o",data.alwaysOn,"the item.isMultiple is :%o",item.isMultiple);
        if(data.alwaysOn){
            //console.log("the before delete the hostspot_data is :%o",evaluate_comm.get_hotarea_state_obj());
    		evaluate_comm.delete_eval_result(item.itemCode);  
            //console.log("the after delte the hostspot_data is :%o",evaluate_comm.get_hotarea_state_obj()); 
        	evaluate_comm.save_eval_result(item);
        }else if(!item.isMultiple){
        	evaluate_comm.delete_eval_result(item.itemCode); 
            var id="p_"+item.itemCode;
            $("p[id^="+id+"]").remove();
        }
        //console.log("after drawn the hotarea_state_obj is :%o",evaluate_comm.get_hotarea_state_obj());
        return evalItem;
    };

    /**
    *  获得热点对象数据
    */
    var _get_hostpot_data_item =function (type,type_name,item_code, item_name, item_type,item_type_name, 
            hotarea_coord,coordinate_x,coordinate_y){

        //console.log("_get_hostpot_data_item arg:\n type is %s,type_name is :%s",type,type_name);
        var evalItem = new Object();
        evalItem.itemCode = parseInt(item_code);
        evalItem.itemName = item_name;        
        evalItem.type = type;  
        evalItem.typeName=type_name;        
        evalItem.currentItemType=item_type;
        if(!evaluate_comm.is_eval_item_result_exists(item_code,item_type)){ 
            if(evaluate_comm.is_eval_result_exists(item_code)){//如果有该项目、并且没有改损伤类别就添加新的损伤类别
                evalItem=evaluate_comm.get_cur_eval_result(item_code);
                var hostpotItem=new Object;
                hostpotItem.itemType =item_type; 
                hostpotItem.itemTypeName =item_type_name ;           
                //hostpotItem.hotAreaType = hotarea_type; 
                hostpotItem.hotAreaCoord = hotarea_coord; 
                hostpotItem.coordinateX=coordinate_x;   
                hostpotItem.coordinateY=coordinate_y;
                evalItem.hostpotItems.push(hostpotItem);         
                evalItem.isMultiple=true;
            }else{  
                evalItem.hostpotItems=[];  
                var hostpotItem=new Object;
                hostpotItem.itemType =item_type; 
                hostpotItem.itemTypeName =item_type_name ;           
                //hostpotItem.hotAreaType = hotarea_type; 
                hostpotItem.hotAreaCoord = hotarea_coord; 
                hostpotItem.coordinateX=coordinate_x;
                hostpotItem.coordinateY=coordinate_y;                
                evalItem.hostpotItems.push(hostpotItem);
                evalItem.isMultiple=false;
            }        
        }

        //console.log("_get_hostpot_data_item return result is %o",evalItem);
        return evalItem;
    };


    //异构热点数据为可以保存的数据类型，主要用于和pad端同步
    var _isomerism_hostpot_item=function (oitem){
        //console.log("_isomerism_hostpot_item the oitem is :%o",oitem);
        var item=new Object();
        item.itemCode=oitem.itemCode;
        item.itemName=oitem.itemName;
        item.type=oitem.type;
        item.imgUrl=oitem.imgUrl;
        var hostpotitems=oitem.hostpotItems;
        var coordinates="";
        var itemType="";
        var itemTypeName="";

        for(var i=0;i<hostpotitems.length;i++){
            coordinates+=hostpotitems[i].coordinateX+","+hostpotitems[i].coordinateY+"-";
            itemType+=hostpotitems[i].itemType+",";
            itemTypeName+=hostpotitems[i].itemTypeName+",";
        }
        //如果有多个项目需要删除后面的分隔符
        if(hostpotitems.length>0){
            coordinates=coordinates.substring(0,coordinates.length-1);
            itemType=itemType.substring(0,itemType.length-1);
            itemTypeName=itemTypeName.substring(0,itemTypeName.length-1);
        }
        item.coordinates=coordinates;
        item.itemType=itemType;
        item.itemTypeName=itemTypeName;
        return item;
    };

    /**
    *热点json对象转换为可以回写到图片的对象
    *当render_tag=true的时候，着色后动态添加下拉列表
    */
    var _isomerism_hostpotjson_items=function(item_list,render_tag){
        console.log("the item_list is %o,the render_tag is %s",item_list,render_tag);
        var result=[];
        for(var i=0;i<item_list.length;i++){
            var oitem=item_list[i];
            console.log("the oitem is %o",oitem); 
            var evalItem=new Object();
            evalItem.itemCode = oitem.itemCode;
            evalItem.itemName = oitem.itemName;        
            evalItem.type = oitem.type;  
            evalItem.typeName=oitem.itemTypeName;  

            console.log("the oitem.itemType is %s",oitem.itemType); 
            evalItem.hostpotItems=[];
            var itemTypes=oitem.itemType.split(",");
            var itemTypeNames=oitem.itemTypeName.split(",");
            var coordinates=oitem.coordinates.split("-");
            if(itemTypes.length>1){
                evalItem.isMultiple=true;
            }else{
               evalItem.isMultiple=false;
            }                  
            for(var j=0;j<itemTypes.length;j++){
                var hostpotItem=new Object;
                hostpotItem.itemType =itemTypes[j];
                hostpotItem.itemTypeName =itemTypeNames[j];                           
                hostpotItem.hotAreaCoord = '';
                if(coordinates.length>0){
                    var coordinates_item=coordinates[j].split(",");
                    hostpotItem.coordinateX=coordinates_item[0];
                    hostpotItem.coordinateY=coordinates_item[1];
                }              
                evalItem.hostpotItems.push(hostpotItem);
                evalItem.currentItemType=hostpotItem.itemType;
                    //渲染热点数据
                if(render_tag){
                    console.log("begin _render_hotarea_data_item");
                    if(evalItem.type==2)
                        $("input[name='exteriorItemsRadio'][value="+hostpotItem.itemType+"]").attr("checked",true);  //外观损伤类型
                    else if(evalItem.type==3)
                        $("input[name='interiorItemsRadio'][value="+hostpotItem.itemType+"]").attr("checked",true); //内饰损伤类型 
                    else if(evalItem.type==0||evalItem.type==1)
                        $("input[name='leftFrontItemsRaido'][value="+hostpotItem.itemType+"]").attr("checked",true); //左前45、右后45损伤类型

                    console.log("the evalItem.type is %s,the hostpotItem.coordinate_y is %s",evalItem.type,hostpotItem.coordinateY);
                    /**
                    if(evalItem.type==0||evalItem.type==1){
                        hostpotItem.coordinateY=360-hostpotItem.coordinateY;     
                    }else if(evalItem.type==2||evalItem.type==3){
                        hostpotItem.coordinateY=580-hostpotItem.coordinateY;     
                    }  
                    */  
                    console.log("after the evalItem.type is %s,the hostpotItem.coordinate_y is %s",evalItem.type,hostpotItem.coordinateY);
                    _render_hotarea_data_item(evalItem.typeName,evalItem.itemCode, evalItem.itemName, evalItem.type, 
                            hostpotItem.coordinateX, hostpotItem.coordinateY, '', hostpotItem.hotAreaCoord,false);                         
                }                
            }          
            result.push(evalItem);             
        }
        console.log("_isomerism_hostpotjson_items the result is%o ",result);
        return result;
    };

    //异构大类热点数据 
    var _isomerism_hostpot_items=function (oitems){
        var result=[];
        for(var i=0;i<oitems.length;i++){
           	result.push(_isomerism_hostpot_item(oitems[i]));
        }
        return result;
    };


    var _clean_hostpot_result_div=function(type){
        var item_result=document.getElementById("item_result_"+type);
        var hostpot_tab=document.getElementById("hostpot_tab");

        if(item_result){
            var index=[];
            for(var i=0;i<hostpot_tab.rows.length;i++) {
                var id=hostpot_tab.rows[i].getAttribute("id");
                var rowindex=hostpot_tab.rows[i].rowIndex;
                //console.log("id is %s rowindex is ",id,rowindex);
                 if(id==("item_result_"+type)){
                    //console.log("the span is :%o",hostpot_tab.rows[i].cells[0].getAttribute("rowspan"));
                    var rowindex=hostpot_tab.rows[i].rowIndex;
                    var rowspan=parseInt(hostpot_tab.rows[i].cells[0].getAttribute("rowspan"));
                    index.push(rowindex);
                    //console.log("the rowindex is %o",rowspan);
                    if(rowspan>1){
                        for(var a=1;a<rowspan;a++){
                            //console.log("the subrowindex is :%o",a);
                            index.push(parseInt(rowindex)+a);
                        }
                    }
                }
            }
            //console.log("index %o",index);
            for(var i=0;i<index.length;i++){
                //console.log("after index  is :%o",index[i]);   
                hostpot_tab.deleteRow(index[i]-i);
               //console.log("after delete  is :%o",hostpot_tab.innerHTML);   
            }
        }        
    };

    //点击的热点渲染到图片上面
    var _render_hotarea_data_item=function (type_name,item_code, item_name, type, 
            coordinate_x, coordinate_y, hotarea_type, hotarea_coord,render_div_flag) 
        {
            //console.log("the type is %s,the item_code is %s,the typename is %s,",type,item_code,type_name);
            var item_type;
            if(type==2)
                item_type=$("input[name='exteriorItemsRadio']:checked").val();//外观损伤类型
            else if(type==3)
                item_type=$("input[name='interiorItemsRadio']:checked").val();//内饰损伤类型   
            else if(type==0||type==1)
                item_type=$("input[name='leftFrontItemsRaido']:checked").val();//左前45、右后45损伤类型 
            //console.log("the item_type is ",item_type);
            if(!item_type){
                sy.messagerAlert("操作提示",type_name+"--》请先选择损伤类型!");
                return ;
            }

            console.log("the coordinate_y is %s,item_code is %s",coordinate_y,item_code);
            var _coordinate_y;
            if(type==0||type==1){
                _coordinate_y=360-coordinate_y;     
            }else if(type==2||type==3){
                _coordinate_y=580-coordinate_y;     
            }    
            console.log("after the coordinate_y is %s,item_code is %s",coordinate_y,item_code);

            var img=document.getElementById("img_"+type);
            var item_type_name=_get_exterior_type_name(parseInt(item_type),type) ;//损伤类型名称      
            var item=_get_hostpot_data_item(type,type_name,item_code,item_name,item_type,item_type_name,hotarea_coord,coordinate_x,coordinate_y);
            //console.log("the item is :%o",item); 
            var id="p_"+item_code;

            var show_name=item_type_name.split("-")[0];
            var item_code_text="";
            var final_show_name="";
            if(document.getElementById(id)){
                item_code_text=document.getElementById(id).innerHTML;
                final_show_name+=item_code_text;
                final_show_name+="-";
                final_show_name+=show_name;
                //console.log("the innertext is :%o",item_code_text);
                var cur_itemcode_div=document.getElementById(id);
                cur_itemcode_div.parentNode.removeChild(cur_itemcode_div);
            }else final_show_name=show_name;
                
            var p_html="<p  id='"+id+"'>"+final_show_name+"</p>";
                
            //console.log("the id is ",id,"the shwoname is :",show_name,"p_html is ", p_html,"type is :",type);
            $("#drawDiv_"+type).append(p_html);

            $("#"+id).css("margin","0px 0px "+_coordinate_y+"px "+coordinate_x+"px");

            //console.log("the image html is %o",$("#drawDiv_"+type).html());

            //画板画数据
            item=_draw_hostspot_data(item);  

            if(render_div_flag){                    
                //重新渲染热点结果div
                _render_hostpot_result_div(type,type_name);   
            }
                
    } ;


        //重新渲染热点结果div
    var _render_hostpot_result_div=function (type,type_name){

            var html=_generate_hostspot_data_html(type,type_name);
            //console.log("the html is :%o",html);

            _clean_hostpot_result_div(type);
            //console.log("after delete the innerhtml is :%o",hostpot_tab.innerHTML);   
            var slibling_node=document.getElementById("item_result_title");
            if(html!=""){
                $(html).insertAfter(slibling_node); 
            }            
            //console.log("after the innerhtml is :%o",hostpot_tab.innerHTML);    
    };

    var _render_condition_result_div=function (conditons){

            var html=_generate_condition_data_html(conditons);
            console.log("the html is :%o",html);

            _clean_hostpot_result_div(4);
            //console.log("after delete the innerhtml is :%o",hostpot_tab.innerHTML);   
            var slibling_node=document.getElementById("item_result_title");
            if(html!=""){
                $(html).insertAfter(slibling_node); 
            }            
            //console.log("after the innerhtml is :%o",hostpot_tab.innerHTML);    
    };

    /**
    *  获取元素的坐标
    */
    var _get_coordinate_event=function (event,type){
            var result=new Object();
            var img=document.getElementById("img_"+type);
            var point=ctutil.get_mouse_point(event);
            var x=point.x-ctutil.get_page_x(img);
            var y=point.y-ctutil.get_page_y(img);
            var coordinate_y=0;  
            result.coordinate_x=x;
            result.coordinate_y=y+15;  
            return result ;                   
    };

    var _upload_image=function(id){
        console.log("the id is %s",id);
        $('#file_upload_'+id).uploadify(
        {
            'formData'      :   {"localFileName":"","localFileSize":0},
            'fileDesc'      :   '支持格式:jpg/gif/jpeg/png.',
            'fileExt'       :   '*.jpg;*.gif;*.jpeg;*.png',
            'sizeLimit'     :   1024 * 1024,
            'auto'          :   true,
            'fileObjName'   :   'localFile', 
            'buttonText'    :   '选择图片',
            'buttonImage'   :   '../common/images/images/upload_img.jpg',
            //'width'         :   '80', 
            //'height'        :   '80',
            'swf'           :   sy.bp()+'/js/plugins/upload/uploadify.swf',
            'uploader'      :   'evaluate_uploadEvalImages.action',
            'onUploadStart' : function(file) {
                $('#file_upload_'+id).uploadify('settings', 'formData', 
                    {'localFileName':file.name,
                     'localFileSize':file.size,
                    }
                );
           },
           'onSelect': function(file) {
                if(file.size > 1024 * 1024 * 3){
                    alert("上传文件大小不能超过3MB!");
                }
           },
           'onUploadSuccess': function(file, data, response) {
                //var attach =  eval('(' + data + ')');
                console.log("the attach is %o",data);
                var img_html="<input type ='hidden' name ='img_url_"+id+"' id='img_url_"+id+"' value='"+data+"'/>";
                var img_url=document.getElementById("img_url_"+id);
                if(img_url){
                    img_url.parentNode.removeChild(img_url);
                }
                $("#file_upload_"+id).append(img_html);

                var item=evaluate_comm.get_cur_eval_result(id);
                if(item){
                    item.imgUrl=data;
                }
           }           
        });          
    };

	return {


        upload_image:function(id){
            _upload_image(id);
        },
        /**
        * 获取已经选择的机电检查项
        */
        get_condition_result:function(){
            var condition_tb=document.getElementById("condition_tb");
            var conditions=[];
            for(var i=1;i<condition_tb.rows.length;i++) {
                var item=new Object();
                var itemName=condition_tb.rows[i].cells[0].innerHTML;
                //console.log("the itemName is %s",itemName);
                item.itemName=itemName;
                var inputs=condition_tb.rows[i].cells[1].getElementsByTagName("input");
                //console.log("the itemCodeRadios length  is %s",inputs.length);
                for (var j=0;j<inputs.length;j++){
                    if(inputs[j].getAttribute("type")=='radio'&&inputs[j].checked) {
                        //console.log("the checkKind is %s",inputs[j].value);                   
                        var names=inputs[j].getAttribute("name").split("_");
                        //console.log("the itemcode is %o",parseInt(names[1]));
                        item.itemCode=parseInt(names[1]);
                        item.checkKind=inputs[j].value;
                    }                   
                }
                inputs=condition_tb.rows[i].cells[2].getElementsByTagName("input");
                for (var j=0;j<inputs.length;j++){
                    if(inputs[j].getAttribute("type")=='text') {
                        //console.log("the checkdesc is %s",inputs[j].value);   
                        item.checkDesc=inputs[j].value;
                    }                   
                }   
                if(item.itemCode&&document.getElementById("img_url_"+item.itemcode)){
                    item.imgUrl=document.getElementById("img_url_"+item.itemcode).value;
                }    
                //如果填了机电描述信息
                if(item.checkKind)  {
                    conditions.push(item);
                }                                                
            }  
            return conditions;    
        },        

        //已经初始化好的数据重新渲染到图片上面
        render_hotarea_data_init:function(item_list,render_flag){
            console.log("the item_list is %o",item_list);
            _isomerism_hostpotjson_items(item_list,render_flag);
        },
        //渲染机电条件div
        render_condition_data_item_div:function () 
        {            
            var conditions=this.get_condition_result(); 
            console.log("the conditions is %o",conditions);
            //过滤itemCode为空的项目
            var result=[];
            for(var i=0;i<conditions.length;i++){
                if(conditions[i].itemCode&&conditions[i].checkKind){
                    result.push(conditions[i]);
                }
            }
            console.log("the result is %o",result);
            _render_condition_result_div(result);
        } ,         

		/**
     	* 渲染点击的热点区域,渲染完成后刷新热点div
     	*/
    	render_hotarea_data_item:function (event,type_name,item_code, item_name, type, 
        	project_damage_items, project_damage_level, hotarea_type, hotarea_coord) 
    	{
    		//console.log("the type is %s,the item_code is %s,the typename is %s,",type,item_code,type_name);    		
            var point=_get_coordinate_event(event,type);//获取鼠标事件坐标
            var item_list=this.get_hostpot_items_all();//获取所有的热点数据
            console.log("before the item_list is :%o",item_list);
            console.log("render_hotarea_data_item the point is :%o",point);
            //渲染热点数据
            _render_hotarea_data_item(type_name,item_code, item_name, type, 
                    point.coordinate_x, point.coordinate_y, hotarea_type, hotarea_coord,true);        
    	} ,    
        /**
        * 渲染热点数据，不刷新热点div 
        *
        */
        render_hotarea_data_item_nodiv:function (event,type_name,item_code, item_name, type, 
            project_damage_items, project_damage_level, hotarea_type, hotarea_coord) 
        {
            //console.log("the type is %s,the item_code is %s,the typename is %s,",type,item_code,type_name);           
            var point=_get_coordinate_event(event,type);//获取鼠标事件坐标
            var item_list=this.get_hostpot_items_all();//获取所有的热点数据
            console.log("before the item_list is :%o,the size is %s",item_list,item_list.length);
            //渲染热点数据
            _render_hotarea_data_item(type_name,item_code, item_name, type, 
                    point.coordinate_x, point.coordinate_y, hotarea_type, hotarea_coord,false);        
        } ,         	
        /**
        * 根据类别获取热点数据
        */
        get_hostpot_items_by_type:function(type){
            var oitem_list=evaluate_comm.get_eval_result_by_type(type);
            //console.log("type is :%s,the itemList is %o",type,oitem_list);
            return _isomerism_hostpot_items(oitem_list);
        },
        /**
        * 返回js缓存中所有的热点数据
        */
        get_hostpot_items_all:function(){            
            var oitem_list=evaluate_comm.get_hotarea_state_obj();
            return _isomerism_hostpot_items(oitem_list);
        },        
        /**
         * 首先清除热点展现，然后清除js缓存数据
         * 如果有热点名称，也需要清除
         * type 大类【外观、内饰】
         * deltag 【是否需要删除缓存标记以及结果页面标记】
         * 
         */
        clean_eval_result_by_type_deltag: function(type,deltag) {  
            var hotspot_result=evaluate_comm.get_eval_result_by_type(type);         
            for(var i=0; i< hotspot_result.length; i++) {
                var item_code=hotspot_result[i].itemCode;
                if(hotspot_result[i].type==type) {
                     var data = $('#area_'+item_code).mouseout().data('maphilight') || {};                
                     data.alwaysOn = false;
                     $('#area_'+item_code).data('maphilight', data).trigger('alwaysOn.maphilight'); 
                }
            }
            //如果设置了缓存标识，首先删除缓存数据、然后清除热点上面的字体、然后清除结果页面
            if(deltag){
                for(var i=0; i< hotspot_result.length; i++) {
                    if(hotspot_result[i].type==type) {
                        hotspot_result.splice(i, 1);
                    }
                }   
                $("#drawDiv_"+type).html('');//清除显示的字体
                _clean_hostpot_result_div(type);//清除大类的热点结果页面                
            }           
        }    
	};
})();