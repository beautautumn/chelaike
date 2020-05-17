<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%@include file="/taglibs.jsp"%>
<!DOCTYPE html>
<html>
<head>
		<base href="<%=basePath%>" />
		<title></title>
		<meta http-equiv="pragma" content="no-cache" />
		<meta http-equiv="cache-control" content="no-cache" />
		<meta http-equiv="expires" content="0" />
		<meta http-equiv="keywords" content="keyword1,keyword2,keyword3" />
		<meta http-equiv="description" content="This is my page" />
	<link type="text/css" rel="stylesheet" href="${ctx}/js/plugins/chosen/chosen.css" />        
    <link rel="stylesheet" type="text/css" href="${ctx}/js/plugins/jquery-ui/themes/icon.css">
	<link rel="stylesheet" type="text/css" href="${ctx}/js/plugins/jquery-ui/themes/bootstrap/easyui.css" >
	<link rel="stylesheet" type="text/css" href="${ctx}/css/style.css" />
	<link rel="stylesheet" type="text/css" href="${ctx}/css/lumebox.css" />		
	<script type="text/javascript" src="${ctx}/js/plugins/jquery-ui/jquery.min.js"></script>	
	<script type="text/javascript" src="${ctx}/js/plugins/jquery-ui/jquery.easyui.min.js"></script>
	<script type="text/javascript" src="${ctx}/js/plugins/jquery-ui/jquery.cookie.js"></script>
	<script type="text/javascript" src="${ctx}/js/common/ctutil.js"></script>
	<script type="text/javascript" src="${ctx}/js/common/syUtil.js"></script>
	<script type="text/javascript" src="${ctx}/js/common/menu.js"></script>
	<script type="text/javascript" src="${ctx}/js/plugins/jquery-ui/locale/easyui-lang-zh_CN.js"></script>
	<script type="text/javascript" src="${ctx}/js/plugins/My97DatePicker/WdatePicker.js"></script>
	<script type="text/javascript" src="${ctx}/js/plugins/lumebox/jquery.lumebox.js"></script>	
	<script type="text/javascript" src="${ctx}/js/plugins/chosen/chosen.jquery.js" ></script>	
	<script type="text/javascript" src="${ctx}/js/plugins/lhgdialog/lhgdialog.min.js?skin=mac" ></script>
	<script type="text/javascript" src="${ctx}/js/business/rpt/select.js"></script>
    <script type="text/javascript" src="${ctx}/js/pages/catalogue/catalogue_tree.js"></script>

	<script type="text/javascript">
	var api = frameElement.api, W = api.opener;

    function do_submit(){

        var sourceId=$("#sourceId").val();
 		var nodes = $('#catalogue_series').tree('getChecked');
        var text = '';
        var value = '';
        for(var i=0; i<nodes.length; i++){
            if (text != '') {
            	text += ',';
            }
            if (value != '') {
            	value+=',';
            }            
            text += nodes[i].text;          
           if (nodes[i].attributes){
           		if(nodes[i].attributes.id)
                	value +=nodes[i].attributes.id;
                if(nodes[i].attributes.type)
                    value += "#"+nodes[i].attributes.type;                
           }             
        }
        W.set_choose_text_value(text,value); 
        api.get("the_list_dialog",1).close();
    }

</script>
<script type="text/javascript">

	$( document ).ready(function() {   

        catalogue_tree.init_tree(W.get_catalogue_tree_json(),true,false);
        var value=W.get_choose_tree_value();
        catalogue_tree.check_catalogue_series_auto(value);    
    });
</script>
</head>
<body>
<ul id="catalogue_series" class="easyui-tree"></ul>
</body>