
var track = (function() {

    var _original_page_elements=[];

    var _differ_page_elements=[];

    var _page_track_result="";

    return {
    	
        get_page_track_result:function(){
            _page_track_result="";
            var elements=this.get_differ_elements();
            for(var i=0;i<elements.length;i++){
                if(!(elements[i].name=="locateId"||elements[i].name=="province"||elements[i].name=="city"
                    ||elements[i].name=="oldProvince"||elements[i].name=="oldCity"||elements[i].name=="groupId"
                    ||elements[i].name=="buyDepart"||elements[i].name=="ownerDepart"))
                {
                	_page_track_result+=elements[i].text;
                    _page_track_result+=elements[i].value+",";
                }
            }
            return _page_track_result;
        },
        get_differ_elements:function(){
            var new_elements_array=this.load_page_elements();
            if(_differ_page_elements.length>0)
                _differ_page_elements=[];
            for(var i=0;i<_original_page_elements.length;i++){
                var original_object=_original_page_elements[i];
                for(var j=0;j<new_elements_array.length;j++){
                    if(original_object.text==new_elements_array[j].text
                        &&original_object.value!=new_elements_array[j].value){
                        var dif_object=new Object();
                        dif_object.text=original_object.text;
                        if(original_object.value!=undefined){
                            dif_object.value=original_object.value+"-->"+new_elements_array[j].value;
                        }else dif_object.value="-->"+new_elements_array[j].value;
                        
                        dif_object.name=original_object.name;
                        _differ_page_elements[_differ_page_elements.length]=dif_object;
                        break;
                    }
                }
            }
            return _differ_page_elements;
        },    	 

        init_original_page_elements:function(){
            if(_original_page_elements.length>0)
                _original_page_elements=[];
            _original_page_elements=this.load_page_elements();
        },
               
        load_page_elements:function () {
            var labels=document.getElementsByTagName("label");
            var object_array=[];
            for(var i=0;i<labels.length;i++){             
                if(labels[i].getAttribute("rel")&&labels[i].getAttribute("rel")!=""){

                  var label_text=labels[i].innerHTML;
                  var rel=labels[i].getAttribute("rel");
                  var rels=rel.split(",");
                  var object=new Object(); 
                  object.text=label_text; 
                  object.value="";
                  for(var j=0;j<rels.length;j++){
                    var object_prop=rels[j].split("#");
                    if(object_prop.length<2){
                    }                                                        
                    var object_value="";
                    if(object_prop[1]=="p"){             
                        object_value=$("#"+object_prop[0]).val();
                    }else if(object_prop[1]=="r"){
                        var radio=$("input[type='radio'][id^='"+object_prop[0]+"']:checked");
                        object_value=this.search_node_label_by_for(object_prop[0]+""+radio.val());                      
                    }else if(object_prop[1]=="s"){
                        object_value=$("#"+object_prop[0]).val();                        
                    }else if(object_prop[1]=="es"){
                        var comboname=document.getElementById(object_prop[0]).getAttribute("comboname");
                        if(comboname&&document.getElementsByName(comboname)[0].value!=undefined){
                            object_value=document.getElementsByName(comboname)[0].value;
                        }
                    }else if(object_prop[1]=="c"){
                        var object_value="";  
                        var boxs = document.getElementsByName(object_prop[0]);
                        if(boxs&&boxs.length>0){
                            for (var b=0;b<boxs.length; b++){
                                if(boxs[b].checked){   
                                    object_value=this.search_node_label_by_for(object_prop[0]+""+boxs[b].value);
                                    object_value=ctutil.trim(object_value);
                                    if(object_value==''){
                                        object_value="是";
                                    }
                                    object_value+=","
                                }
                            }      
                            if(object_value!=''){
                                object_value=object_value.substring(0,object_value.length-1); 
                            }  
                        } 
                    }  
                    object.name=object_prop[0];
                    if(object.value!=""){
                        object.value=object.value+" ,"+ object_value; 
                    }else{
                        object.value=object_value; 
                    }                                                
                  }
                object_array[object_array.length]=object;
              }
            }
            return object_array;           
        },

        search_node_label_by_for:function(value){
            var labels=document.getElementsByTagName("label");
            for(var i=0;i<labels.length;i++){
                if(labels[i].getAttribute("for")==value){
                    return labels[i].innerHTML;
                }
            }
        }

    };
})();