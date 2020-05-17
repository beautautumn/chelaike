
var rpt = (function() {
	var _option_value;
	var _view_id;
	var _param;
	return {
		set_option_value:function(option_value){
			this._option_value=option_value;			
		},
		get_option_value:function(){
			alert(this._option_value);
			return _option_value;
		},		
		set_view_id:function(view_id){
			this._view_id=view_id;
		},		
		set_param:function(param){
			this._param=param;
		},
		search:function(){
			var viewId=$("#viewId").val();
    		$('#tbgrid').datagrid('options').url=sy.bp()+'/rpt/page!queryPageData.action?viewId='+_view_id+_param_+'&mainSelect='+_option_value;
			var queryParams=$('#tbgrid').datagrid('options').queryParams;
			var params=getRequestParams(queryParams);
 			var condStr=document.getElementsByName("rptForm")[0].condStr.value;
 			queryParams.condStr=condStr;
			$('#tbgrid').datagrid('reload');
		},
		change_silbling_div:function (optionValue){
			var viewId=$("#viewId").val();
    		var parameter = {};	
	   			parameter["viewId"]=viewId;
	   			parameter["optionValue"]=optionValue;
			$("#_mainSelect").val(optionValue);		    
			$.post(sy.bp()+"/rpt/page!querySiblingHtml.action",parameter,function(data){
	      		show_slib(data);
			});
		},	
		show_slib:function (data) {
      		var condDiv = document.getElementById("condDiv");
      		var children=condDiv.childNodes;
      		for(var j=0;j<children.length;j++){
         		var selectHtml;
         		if(children[j].nodeName=="INPUT"){
            		condDiv.removeChild(children[j]);
         		}else if(children[j].nodeName=="SELECT"&&children[j].getAttribute("name")!="mainSelect"){
          			condDiv.removeChild(children[j]);
         		}
      		}
      		$("#condDiv").html(data);     
		},			
		get_request_params:function (queryParams){
      		var inputs =document.getElementsByTagName("input");
      		for(var j=0;j<inputs.length;j++){
      			var name=inputs[j].getAttribute("name");
      			if(name!=null&&inputs[j].value!=null){
      	 			queryParams[name]=inputs[j].value;
      	 			//alert("name is :"+name+" value is :"+queryParams[name]);
      			}
      		} 
      		var selects =document.getElementsByTagName("select");
      		for(var j=0;j<selects.length;j++){
      			var name=selects[j].getAttribute("name");
      			if(name!=null&&selects[j].value!=null){
      	 			queryParams[name]=selects[j].value;      	 
      			}
      		}       
      		return queryParams; 
		},		
		search_query:function(){
			$(".btn").each(function(){
				var text=$(this).text();
				$(this).removeClass("cur");
				$(this).html(text);	
			});		
			var viewId=$("#viewId").val();
			$('#tbgrid').datagrid('options').url=sy.bp()+'/rpt/page!queryPageData.action?viewId='+_view_id+_param_+'&mainSelect='+_option_value;
			var queryParams=$('#tbgrid').datagrid('options').queryParams;	
			var params=getRequestParams(queryParams);
			if(document.getElementsByName("rptForm")[0].condStr)
				document.getElementsByName("rptForm")[0].condStr.value="";
 			queryParams.condStr="";
			$('#tbgrid').datagrid('reload');
		},
		search_state:function(no){
			var preNo=$("input[name='condStr']").val();
			if(preNo!=no){
				$(".btn").each(function(){
					var text=$(this).text();
					$(this).removeClass("cur");
					$(this).html(text);					
				});	
			}	
			if(!$("#btn_"+no).hasClass("cur")){
				$("#btn_"+no).addClass("cur");
				var text=$("#btn_"+no).text();
				$("#btn_"+no).html('<img src="${path}/common/version_1.0/images/fast-btn.png" />'+text);		
			}	
			$("input[name='condStr']").val(no);
			query();
		},		
		exoprt_excel:function(){
			var viewId=$("#viewId").val();
			$('#tbgrid').datagrid('options').url=sy.bp()+'/rpt/page!queryPageData.action?viewId='+_view_id+_param_+'&mainSelect='+_option_value;
			var queryParams=$('#tbgrid').datagrid('options').queryParams;
			var params=getRequestParams(queryParams);
			var optionValue=document.getElementsByName("rptForm")[0].mainSelect.value;
			document.getElementsByName("rptForm")[0].condStr.value="";
 			queryParams.condStr="";	 	
			$.ajax ({
	    		type: "POST",
    	    	url: sy.bp()+"/rpt/page!doHandleDataExport.action" ,
        		data: queryParams,
        		success: function(callback) {    //提交成功后的回调         
            		window.location.href="${path}/fileDownLoad?"+callback
       			}
   			}); 	
		},
		change_url:function(){
			var vIfr=document.getElementById("ifrObj");
			vIfr.src=url;
		}
        
    };
})();
