<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%@include file="/common/taglibs.jsp"%>
<%@include file="/common/meta.jsp"%>
<%
	try {
		String viewId = request.getParameter("viewId") == null ? (String) request
				.getAttribute("viewId")
				: request.getParameter("viewId");
		String param = request.getParameter("param") == null ? (String) request
				.getAttribute("param")
				: request.getParameter("param");
%>
<!DOCTYPE html>
<html>
<head>
	<title> ${title }</title>
	<meta http-equiv="pragma" content="no-cache" />
	<meta http-equiv="cache-control" content="no-cache" />
	<meta http-equiv="expires" content="0" />
	<script type="text/javascript" src="${ctx}/js/common/ctutil.js"></script>
	<script type="text/javascript" src="${ctx}/js/common/syUtil.js"></script>
	<script type="text/javascript" src="${ctx}/js/common/menu.js"></script>
	<script type="text/javascript" src="${ctx}/js/business/rpt/select.js"></script>
<style type="text/css">
	form {
    	margin: 0;
    	padding: 5px 0 0px;
	}
.stock_table {
  border: 0;
  width: 100%;
}
.stock_table p a{ 
    font-size: 13px;
    font-weight:bold;
}

.stock_fee_table {
  border: 0;
  width: 100%;
}

.stock_fee_table p a{ 
    font-size: 13px;
    text-decoration:underline;
    color: #81BEF7;
}

/**
.car_search li {
    color: #666666;
    float: left;
    font-size: 13px;
    text-align: center;
}

.car_search .brand {
    margin: -20 0 5 -40 ;
}

.car_search_list {
    width: 210px;
}

.car_search_list li {
    display: inline;
    height: 90px;
}

.car_search_list .brand {
    text-align: left;
}

.car_search_list_dll {
    float: left;
    height: 10px;
}
.car_search_list .brand p {
	margin:10 0 4 0;
    float: left;   
    height: 5px;
}
.brand p a{	
    font-size: 13px;
    font-weight:bold;
}
.car_search_list .brand span {
    float: left;
}
.car_search_list .brand dt {
    height: 22px;
}
*/

/*.format_btn a:hover{ */
	/*background:#ffcc99; */
/*} */

</style>
	<link rel="stylesheet" type="text/css" href="/sso/static/css/overui.css" />
<body>
	<div class="top-work" id="toolBar">
		<div class="search" style="width:100%">
			${formHtml} 
			   ${conditionSelectHiddenHtml}
<div style="padding: 3px; height: auto;" id="userListtb" class="datagrid-toolbar">
	<div name="searchColums">

      <c:if test="${conditionInputHtml!=null}">${conditionInputHtml}</c:if>
		<div class="over-cell" style="margin-top:10px;margin-bottom:0px;">
		  <c:if test="${not empty conditionInputHtml}">
			<a href="javascript:search();"  id="page_model_find" class="easyui-linkbutton" data-options="iconCls:'icon-search'" style="width:70px">查询</a>
		   </c:if>
		   <a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-print'" onclick="javascript:exportExcel()" style="width:70px">导出</a>
			<c:if test="${dialogHtml!=null}">${dialogHtml}</c:if>
		</div>
    </div>
   </div>
				</form>
			</div>		
	</div>  
<div class="easyui-layout" fit="true" style="margin: 0px;border: 0px;overflow: hidden;width:100%;height:100%;">
	<div data-options="region:'center',border:false,split:true" style="padding: 0px; height: 100%;width:100%; overflow-y: hidden;" align="left">	
		<table id="tbgrid" data-options="toolbar:'#toolBar'">
			<thead>
				<tr>
				 ${headHtml}
				</tr>
			</thead>
		</table>
	</div>
</div>




<script>



function getRequestParamsStr(){
      var result="";
      var inputs=document.getElementsByName("rptForm")[0].getElementsByTagName("input");
      for(var j=0;j<inputs.length;j++){
      	var name=inputs[j].getAttribute("name");
      	if(name!=null&&inputs[j].value!=null){
      		result+="&";
      		result+=name;
      		result+="=";
      		result+=inputs[j].value;
      	 	//alert("name is :"+name+" value is :"+queryParams[name]);
      	}
      } 
  
      var selects =document.getElementsByName("rptForm")[0].getElementsByTagName("select");
      for(var j=0;j<selects.length;j++){
      	var name=selects[j].getAttribute("name");
      	if(name!=null&&selects[j].value!=null){
      		result+="&";
      		result+=name;
      		result+="=";
      		result+=selects[j].value;      	 	
      	 
      	}
      }   
      return result; 
}

$(document).ready(function() {		 			
		 	var condStr;
		 	var lastIndex;
		 	if(document.getElementsByName("rptForm").condStr){
			 	condStr=document.getElementsByName("rptForm")[0].condStr.value;
		 	}
            var inputParams=getRequestParamsStr();                     
		 	$('#tbgrid').datagrid({
		 		/**
			 	rowStyler:function(index,row){
			 		var style='';
			        if (row.ware_day&&row.ware_day<=2){			        	
			        	style='color:red;font-weight:bold;';    			        	    
			 		}
			        return style;
			    },
			    */
				pagination:true,
			    pageSize:20,
			    pageList: [10,20,50,100,150,200,500],
			    fit:${pageTableInfo.fit},
			    singleSelect: ${pageTableInfo.singleSelect},
			    fitColumns: ${pageTableInfo.fitColumns},
			    striped:true,
			    onClickCell:function(rowIndex, field, value){
			    	//console.log("the rowIndex is %s,the field is %s,the value is %s",rowIndex,field,value);
			    	the_click_cell_field=field;
			    },			    
		        onClickRow:function(index,data){
					onClickRow(index);
				},  								    		 
			    url:'${ctx}/list/page!queryPageData.action?*=1'+inputParams
			});	 			
 					 	
			$("#page_model_find").click(function(){
				query1();
			});
			
			function findRequestParam(data){
				$.post("${ctx}/list/page!findRequestParamByViewId.action?viewId=<%=viewId%>",{},function(rdata){
					var obj = eval('(' + rdata + ')');  
					var value=data[obj.colField];
					if(obj.formatter=='formatterCommonLink'){
						viewDetail(value);
					}else if(obj.formatter=='formatterParentLink'){	
						//代办不需要点击行事件					
						//viewByRightCode(data.todo_id,data.right_code);
					}
				});
			}
			/**
			$(".chzn-select").chosen();			
			$(".chzn-select").chosen().change(
				function(){
					var newValue=$(this).children('option:selected').val();
					changeSilblingDiv(newValue);
				}		
			);
			*/	
				
});	
 		
	</script>


 <script type="text/javascript">
        var editIndex = undefined;
        var clickIndex=undefined;

        function endEditing(){
            if (editIndex == undefined){return true}
            if ($('#tbgrid').datagrid('validateRow', editIndex)){
                var ed = $('#tbgrid').datagrid('getEditor', {index:editIndex,field:'stat_month'});
                //var productname = $(ed.target).combobox('getText');
                //$('#tbgrid').datagrid('getRows')[editIndex]['productname'] = productname;
                $('#tbgrid').datagrid('endEdit', editIndex);
                editIndex = undefined;
                return true;
            } else {
                return false;
            }
        }

        function onClickRow(index){
        	clickIndex=index;
        	console.log("the index is :"+index+" editIndex is :"+editIndex);
            if (editIndex != index){
                if (endEditing()){
                    $('#tbgrid').datagrid('selectRow', index)
                            .datagrid('beginEdit', index);
                    editIndex = index;
                } else {
                    $('#tbgrid').datagrid('selectRow', editIndex);
                }
            }
        }

        function append(){
        	//eu.showProMsg('正在提交数据...');
        	
        	var now=new Date()
        	var date=now.getFullYear()+"/"+(now.getMonth()+1);
        	console.log("the pay_date is :",date);
            if (endEditing()){
                $('#tbgrid').datagrid('appendRow',{stat_month:date});
                editIndex = $('#tbgrid').datagrid('getRows').length-1;
                console.log("the editIndex is :"+editIndex);
                $('#tbgrid').datagrid('selectRow', editIndex)
                        .datagrid('beginEdit', editIndex);
            }
        }


        function accept(){
        	
            var rows = $('#tbgrid').datagrid('getChanges');
            /**
            for(var i=0;i<rows.length;i++){
                console.log("the sb is :"+rows[i].sb);
            }
            */
            //boolean editTag=endEditing();
            //console.log("the editTag is :"+editTag);

            var inserted =$('#tbgrid').datagrid('getChanges', "inserted");
            var deleted = $('#tbgrid').datagrid('getChanges', "deleted");
            var updated = $('#tbgrid').datagrid('getChanges', "updated");

           	//console.log("the inserted is :%o",inserted);
           	//console.log("the deleted is :%o",deleted);
           	//console.log("the updated is :%o",updated);           	
            if (endEditing()){
                $('#tbgrid').datagrid('acceptChanges');
            }              
            console.log("the clickIndex is :",clickIndex);
            if(clickIndex==undefined ){
            	var rowlen=$('#tbgrid').datagrid("getRows").length;
            	//console.log("the rowlen is :",rowlen);
            	clickIndex=rowlen-1;
            }
          

			var row = $('#tbgrid').datagrid('getData').rows[clickIndex];
			console.log("the row.sb is :%o",row);

			var locateId=$("#locateName").val();
			//console.log("the locateId val is %o",locateId);
			row.locateId=locateId;
			 $.ajax({    
              type:'post',        
              url:'${ctx}/stock/cost_operate_saveCost.action',    
              data:row,    
              cache:false,    
              dataType:'json',
              async : false, //默认为true 异步     
              success:function(data){
                if(data){
                  alert('操作成功');
                  //window.location.href=window.location.href;
                }else{
                  alert('操作失败');
                }   
              }    
          });   
           		
			
        }
        function getChanges(){
            var rows = $('#tbgrid').datagrid('getChanges');
            alert(rows.length+' rows are changed!');
        }
    </script>	
</html>


<script type="text/javascript">

<c:if test="${sessionScope.sessionInfo==null}">
	top.location.href="${ctx}/index.jsp";
</c:if>

var optionValue="";

var the_click_cell_field="";

/**
 * 查询方法
 */
function query(){
		var viewId=$("#viewId").val();
    	$('#tbgrid').datagrid('options').url='${ctx}/list/page!queryPageData.action?viewId=<%=viewId%><%--<%=param%>--%>&mainSelect='+optionValue;
		var queryParams=$('#tbgrid').datagrid('options').queryParams;
		var params=getRequestParams(queryParams);
 		var condStr=document.getElementsByName("rptForm")[0].condStr.value;
 		queryParams.condStr=condStr;
		$('#tbgrid').datagrid('reload');
}
/**
 * 当选中左边的下拉框时候出发查找配置的其他页面标签，比如input、select
 */
function changeSilblingDiv(optionValue){
	var viewId=$("#viewId").val();
    var parameter = {};	
	   	parameter["viewId"]=viewId;
	   	parameter["optionValue"]=optionValue;
	$("#_mainSelect").val(optionValue);
		    	
	$.post("${ctx}/list/page!querySiblingHtml.action",parameter,function(data){
	      showSilb(data);
	});
}
/**
 * 展现配置的页面标签
 */
function showSilb(data) {
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
}
/**
 * 查询时获取调用参数
 */
function getRequestParams(queryParams){
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
}



function queryConditon(){
    query();
}

function linkToTab(tabTitle, tabUrl, menuId){
    eu.addTab(window.parent.layout_center_tabs,tabTitle,tabUrl,true);
//    eu.addTab(window.parent.layout_center_tabs,'车辆管理','http://official.7ycar.com:8080/erp/list/page!toRptIndex.action?1=1'+'&viewId='+'101'+'&checkerId='+'5',true);
//    parent.getMenu('menu101');
    parent.getMenu(menuId);
}

function query1(){
	$(".btn").each(function(){
		var text=$(this).text();
		$(this).removeClass("cur");
		$(this).html(text);	
	});		
	var viewId=$("#viewId").val();
	$('#tbgrid').datagrid('options').url='${ctx}/list/page!queryPageData.action?viewId=<%=viewId%><%--<%=param%>--%>&mainSelect='+optionValue;
	//var opts=$('#tbgrid').datagrid('options');
	//console.log("%o",opts);
	var queryParams=$('#tbgrid').datagrid('options').queryParams;
	var params=getRequestParams(queryParams);
	if(document.getElementsByName("rptForm")[0].condStr)
		document.getElementsByName("rptForm")[0].condStr.value="";
 	queryParams.condStr="";
 	//alert("queryParams.mainSelect is : "+queryParams.mainSelect);
	$('#tbgrid').datagrid('reload');
}

function queryConditonDef(){
	$("input[name='condStr']").val("");
    query();
}

var search = search || function search() {}
/**
 * 状态按钮查询
 */
function queryState(no){
	var preNo=$("input[name='condStr']").val();
	if(preNo!=no){
		$(".btn").each(function(){
			var text=$(this).text();
			$(this).removeClass("cur");
			$(this).html(text);		
			
		});	
	}
	//alert($("#btn_"+no).attr('class'));
	if(!$("#btn_"+no).hasClass("cur")){
		$("#btn_"+no).addClass("cur");
		var text=$("#btn_"+no).text();
		$("#btn_"+no).html('<img src="${ctx}/common/version_1.0/images/fast-btn.png" />'+text);		
	}
	
	$("input[name='condStr']").val(no);
	query();
}
/**
 * 样式修饰
 */
function formatterCommonLink(value){
	return "<a style=\"color:#1b4797;text-decoration:underline\" href=\"javascript:viewDetail('"+value+"')\">"+value+"</a>";
}

function formatterActionLink(value,rec){
	var id=getActionId(value,rec);
	return "<a class=\"easyui-linkbutton\" href=\"javascript:showDialog('"+id+"','show_button','"+value+"')\">"+value+"</a>";   	  
}

function formatterSourceAuditLink(value,rec){
	var id=rec.source_id;
	return "<a class=\"easyui-linkbutton\" href=\"javascript:validateSourceFollowLink('"+id+"','"+value+"')\">"+value+"</a>";		
}

function validateSourceFollowLink(id,value){
	$.post("${ctx}/followMgr/follow!verifyAuditRight.action",{"followObjType":"1"},function(data){
		if(data=="no"){
			alert("您暂无权限，请联系管理员!");
		}else if(data=="yes"){
			showDialog(id,'show_button',value)
		}
	});		
}


function formatterActionParentLink(value,rec){
	
	var id=getActionId(value,rec);
	return "<a class=\"easyui-linkbutton\" href=\"javascript:refreh_parent_url('"+id+"','show_button','"+value+"')\">"+value+"</a>";
}

function formatterActionNewTabLink(value,rec){
	
	var id=getActionId(value,rec);
	return "<a class=\"easyui-linkbutton\" href=\"javascript:new_tab_url('"+id+"','show_button','"+value+"')\">"+value+"</a>";
}

function formatterParentLink(data,rowData){
 	return '<a href="javascript:void(0);" onclick="javascript:viewByRightCode(\''+rowData.todo_obj_id+'\',\''+rowData.right_code+'\')">'+data+'</a> ';   	 	
}





function stockCellStyler(value,row,index){
     if (value > 90){
     	return 'background-color:red;color:#000;';
     }else if(value>10&&value<=45){
     	return 'background-color:#ffee00;color:#000;';
     }else if(value>45&&value<=90){
     	return 'background-color:#A020F0;color:#000;';
     }else{
     	return value;
     }     
}

function refreh_parent_url(key,type,displayname){
	var viewId=$("#viewId").val();
    var parameter = {};	
	   	parameter["viewId"]=viewId;
	   	parameter["key"]=key;
		parameter["type"]=type;
		
	$.getJSON("${ctx}/list/page!queryLinkUrl.action",parameter,function(data){
	    menu.refresh_center_iframe(data.dialogUrl);
	});
}

function new_tab_url(key,type,displayname){
	var viewId=$("#viewId").val();
    var parameter = {};	
	   	parameter["viewId"]=viewId;
	   	parameter["key"]=key;
		parameter["type"]=type;
		
	$.getJSON("${ctx}/list/page!queryLinkUrl.action",parameter,function(data){
	    menu.open_new_tab(data.dialogUrl);
	});
}

function formatterWinDialogLink(value,rec){
	var id=getActionId(value,rec);
return "<a class=\"easyui-linkbutton\" href=\"javascript:new_win_dialog_url('"+id+"','show_button','"+value+"')\">"+value+"</a>";
}

function new_win_dialog_url(key,type,displayname){
	var viewId=$("#viewId").val();
    var parameter = {};	
	   	parameter["viewId"]=viewId;
	   	parameter["key"]=key;
		parameter["type"]=type;
		
	$.getJSON("${ctx}/list/page!queryLinkUrl.action",parameter,function(data){
	    menu.show_win_max_dialog(data.dialogTitle,data.dialogUrl);
	});
}


/**
 * 根据行数据获取动作id
 */
function getActionId(value,rec){
	
	var id;
	if(rec.order_chg_id!=undefined){
		id=rec.order_chg_id;
		return id;
	}
	if(rec.claim_id!=undefined){
		id=rec.claim_id;
		return id;
	}	
	if(rec.source_id!=undefined){
		id=rec.source_id;
		return id;
	}
	if(rec.sale_id!=undefined){
		id=rec.sale_id;
		return id;
	}
	if(rec.refund_id!=undefined){
		id=rec.refund_id;
		return id;
	}	
	if(rec.acquisition_id!=undefined){
		id=rec.acquisition_id;		
		return id;
	}
	if(rec.vehicle_id!=undefined){
		id=rec.vehicle_id;
		return id;		
	}
	if(rec.satisfaction_id!=undefined){
		id=rec.satisfaction_id;
		return id;
	}
	if(rec.maintain_id!=undefined){
		id=rec.maintain_id;
		return id;
	}	
	if(rec.id!=undefined){
		id=rec.id;
		return id;
	}	
	return id;
}



function viewByRightCode(id,rightCode){
	$.ajax ({
    	type: "POST",
        url: "${ctx}/list/page!queryOperateLinkUrlFromTodo.action" ,
        data: 'rightCode=' + rightCode,
        success: function(callback) {    //提交成功后的回调            
            if(callback){
            	var data_obj=eval("("+callback+")");
            	//window.location.href='${ctx}'+data_obj.url+"&id="+id+"&current_id="+data_obj.current_id+"&parent_id="+data_obj.parent_id;
            	var url=data_obj.url+"&id="+id;
	            console.log("the data is %o",data_obj);
	            parent.second_level_refresh(data_obj.parent_id,data_obj.current_id,url,data_obj.menu_text);
            }
            	//window.location.href='${ctx}'+callback+"&id="+id+"&current_id="+${current_id}+"&parent_id="+${parent_id};
            	//window.location.href='${ctx}'+callback+"&id="+id;
            	
       	}
   	});
}



/**
 * 操作按钮对话框展现
 */
function showDialog(key,type,displayname){

	var viewId=$("#viewId").val();
    var parameter = {};	
	   	parameter["viewId"]=viewId;
	   	parameter["key"]=key;
		parameter["type"]=type;
		
	$.getJSON("${ctx}/list/page!queryLinkUrl.action",parameter,function(data){
		console.log(data);
 		var url="/"+data.dialogUrl;	      		
	    menu.show_list_dialog(data.dialogTitle+'['+key+']',url,parseInt(data.dialogWidth),parseInt(data.dialogHeight),true,true,true);
	});
}
/**
 * 详情页面展现
 */
function viewDetail(data){
	var viewId=$("#viewId").val();
    var parameter = {};	
	   	parameter["viewId"]=viewId;
	   	parameter["key"]=data;
	$.post("${ctx}/list/page!queryLinkUrl.action",parameter,function(data){

	      <c:choose>
	      	<c:when test="${currentId!=null}">
	      		var url="${ctx}"+"/"+data+"&currentId="+${currentId};
	      		changeUrl(url);
	      	</c:when>
	      	<c:otherwise>
	      		var url="${ctx}"+"/"+data;
	      		changeUrl(url);
	      	</c:otherwise>
	      </c:choose>
	      $("div[id='showDetail']").css({"display":"block"});
	});
}

function clearObj(object){

}

function changeUrl(url){
	var vIfr=document.getElementById("ifrObj");
	vIfr.src=url;
}

//2014-04-22
function get_dialog_instance(){
        return menu.get_dialog_instance();
    }



/**
 * 导出方法
 */
function exportExcel(){
	var viewId=$("#viewId").val();
	$('#tbgrid').datagrid('options').url='${ctx}/list/page!queryPageData.action?viewId=<%=viewId%><%=param%>&mainSelect='+optionValue;
	var queryParams=$('#tbgrid').datagrid('options').queryParams;
	var params=getRequestParams(queryParams);
	//var optionValue=document.getElementsByName("rptForm")[0].mainSelect.value;
	//document.getElementsByName("rptForm")[0].condStr.value="";
 	queryParams.condStr=document.getElementsByName("rptForm")[0].condStr.value;	
 	
	$.ajax ({
    	type: "POST",
        url: "${ctx}/list/page!doHandleDataExport.action" ,
        data: queryParams,
        success: function(callback) {    //提交成功后的回调         
            window.location.href="${ctx}/fileDownLoad?"+callback
       	}
   	}); 	
}

/**
function series_select_load(value,cascade_select_id,first_option){
	if(value!=""){
 		$.ajax ({
    	    type: "POST",
    	    url: sy.bp()+"/core/catalogue_factorySeriesLoad.action" ,
    	    data: "brand_code="+value,
    	    success: function(data) {              
    	        var list = eval('(' + data + ')');
    	        console.log("%o",list);
    	        select.set_select_option(cascade_select_id,list,first_option);
    	    }
    	});
	}else{
        $("#"+cascade_select_id).html('');  
 		selectObj.options[0] = new Option('===请选择===', '');     
	}
}
*/

function formatterView(value,rowData,rowIndex){
    var url="${ctx}/sys/staff_view.action";
    var operaterHtml = "<a class='easyui-linkbutton' iconCls='icon-add' plain='true' " +
               "onclick='view(\""+url+"\")' >查看</a>"
       +"<a class='easyui-linkbutton' iconCls='icon-edit' plain='true' href='#' " +
               "onclick='edit("+rowIndex+");' >编辑</a>";
    return operaterHtml;
}


function view(url){
	var title="test";
    if(window.parent.layout_center_tabs){
        eu.addTab(window.parent.layout_center_tabs,title,url,true);
    }
}
function marketAreaLoad(value, cascade_select_id, first_option) {
    if (value != "") {
        $.ajax({
            type: "POST",
            url: sy.bp() + "/rent/siteArea_listAreaByMarket.action",
            data: "marketId=" + value,
            success: function (data) {
                var list = eval('(' + data + ')');
                console.log("%o", list);
                select.set_select_option(cascade_select_id, list, first_option);
            }
        });
    } else {
        $("#" + cascade_select_id).html('');
        selectObj.options[0] = new Option('请选择区域', '');
    }
}
function seriesLoad(value, cascade_select_id, first_option) {
    if (value != "") {
        $.ajax({
            type: "POST",
            url: sy.bp() + "/mtype/mtype_serieslist.action",
            data: "brandName=" + value,
            success: function (data) {
                var list = eval('(' + data + ')');
                console.log("%o", list);
                select.set_select_option(cascade_select_id, list, first_option);
            }
        });
    } else {
        $("#" + cascade_select_id).html('<option>请选择车系</option>');
        selectObj.options[0] = new Option(first_option, '');
    }
    modelLoad("", "modelSelect","请选择车型");
}
function modelLoad(value, cascade_select_id, first_option) {
    if (value != "") {
        $.ajax({
            type: "POST",
            url: sy.bp() + "/mtype/mtype_modellist.action",
            data: "seriesName=" + value+"&brandName="+$('#brandSelect').val(),
            success: function (data) {
                var list = eval('(' + data + ')');
                console.log("%o", list);
                select.set_select_option(cascade_select_id, list, first_option);
            }
        });
    } else {
        $("#" + cascade_select_id).html('');
        $("#" + cascade_select_id).get(0).options[0] = new Option(first_option, '');
    }
}
$(document).ready(function () {
    if(!$('#brandSelect')){
        return;
    }
    $.ajax({
        type: "POST",
        url: sy.bp() + "/mtype/mtype_brandlist.action",
//            data: "marketId=" + value,
        success: function (data) {
            var list = eval('(' + data + ')');
            console.log("%o", list);
            select.set_select_option("brandSelect", list, "请选择品牌");
        }
    });
});
/**

function formatter_publish_site(value,rec){
  var result="";
  var siteStr="";
  console.log("the vehicleId is %o",rec.vehicle_id);
  $.ajax({
          url:sy.bp()+'/stock/site_publish_findStockPublishsByVehicleId.action',
          type:'post',
          data:{'vehicleId':rec.vehicle_id},
          success:function(data){            
            var obj=$.evalJSON(data);
            for(i=0;i<obj.length;i++){
              if(i%3==0){
                siteStr+="<tr>";
              } 
              siteStr+="<td width='%16'>"+obj[i].site+"</td><td width='%16'><img src='"+sy.bp()+"/"+obj[i].state+"'></img></td>";                            
            }
          },
          async:false
        }); 

  result="<div><table style='border:0px;'>"+siteStr+"</table></div>";
  console.log("the result is %o",result);
  return result;
}



    function format_staff_oper_temp(value, rowData, rowIndex) {
        var result = "";
        result+="<div class='format_btn'>";
        result += "<a style='cursor:hand;cursor:pointer;color:#81BEF7;text-decoration:underline ' onclick=\"menu.create_model_max_dialog_identy('viewStock_dialog','车辆查看','/stock/viewStock_prepareViewStock.action?1=1'" + "+'&vehicleId='+" + rowData.vehicle_id + ")\"> " + value + "</a> &nbsp;&nbsp;";
        result+="</div>";

        return result;
    }

    */

${js};

</script>
${operateLinkJs};
<%
	} catch (Exception e) {
	}
%>