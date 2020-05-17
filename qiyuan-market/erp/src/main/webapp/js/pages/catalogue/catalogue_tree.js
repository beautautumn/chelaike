
var catalogue_tree = (function() {

    var _tree_data_str;

    return {
        //从服务器加载品牌html
        load_catalogue_series_tree_json : function(node_id){
           var scriptUrl = ctutil.bp()+"/saleSource/catalogue_tree_seriesTreeLoad.action";                
            $.ajax({
                url: scriptUrl,
                type: 'get',                
                async: false,
                success: function(data) {
                    _tree_data_str=data;
                } 
            });     
        },
        check_catalogue_series:function(id){
            var node = $('#catalogue_series').tree('find',id);
            $('#catalogue_series').tree('expandTo', node.target).tree('select', node.target).tree('check', node.target);
        },

        check_catalogue_series_auto:function(value){
            var id_array=this.combin_check_catalogue_value(value);
            this.check_catalogue_series_array(id_array);
        },

        check_catalogue_series_array:function(id_array){
            for(var i=0;i<id_array.length;i++){
                this.check_catalogue_series(id_array[i]);
            }
        },   

        combin_check_catalogue_value:function(value){
            var id_array=[];
            var values=value.split(",");
            for(var i=0;i<values.length;i++){
                var nodes=values[i].split("#");
                if(nodes.length==2){
                    if(nodes[1]==0){
                        id_array[id_array.length]="brand_"+nodes[0];
                    }else if(nodes[1]==1){
                        id_array[id_array.length]="factory_"+nodes[0];
                    }else if(nodes[1]==2){
                        id_array[id_array.length]="series_"+nodes[0];
                    }                                
                }
            }
            return id_array;
        },  

        init_tree:function(json_data,check_value,cascade_value){
            $("#catalogue_series").tree({
                checkbox:check_value,
                cascadeCheck:cascade_value,
                data:json_data
            });   
        },
        load_tree_data_str:function(){
            return _tree_data_str;
        }
     
    }
})();
