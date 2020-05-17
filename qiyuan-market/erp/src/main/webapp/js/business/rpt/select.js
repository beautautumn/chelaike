
var select = (function() {

    return {

    	remove_options:function (selectObj)
        {
            if (typeof selectObj != 'object')
            {
                selectObj = document.getElementById(selectObj);
            }  
            // 原有选项计数
            var len = selectObj.options.length;
            for (var i=0; i < len; i++)
            {   
                // 移除当前选项
                selectObj.options[i] = null;
            }

        },
        
        set_select_option:function (_selectObj, optionList, firstOption, selected)
        {
            //alert(_selectObj);
            console.log("the objecit is:"+_selectObj);
            //if (typeof selectObj != 'object'){
                selectObj = document.getElementById(_selectObj);
            //}          
            // 清空选项
            this.remove_options(selectObj); 
            $("#"+_selectObj).html('');  

            // 选项计数
            var start = 0;             
            // 如果需要添加第一个选项
            if (firstOption)
            {
                selectObj.options[0] = new Option(firstOption, '');
          
                // 选项计数从 1 开始
                start ++;
            }          
            var len = optionList.length;          
            for (var i=0; i < len; i++)
            {
                if(optionList[i].tag==1){
                    var group = document.createElement('optgroup');
                    group.label = optionList[i].name;
                    selectObj.appendChild(group);
                }else {
                    // 设置 option
                    selectObj.options[start] = new Option(optionList[i].name, optionList[i].id);          
                    // 选中项
                    if(selected == optionList[i].id)
                    {
                        selectObj.options[start].selected = true;
                    }          
                    // 计数加 1
                    start ++;                    
                }
            }          
        }
        
    };
})();
