<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%@include file="/common/taglibs.jsp"%>
<%@include file="/common/meta.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"  "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<title>列表页面</title>
		<meta http-equiv="pragma" content="no-cache" />
		<meta http-equiv="cache-control" content="no-cache" />
		<meta http-equiv="expires" content="0" />
		<meta http-equiv="keywords" content="keyword1,keyword2,keyword3" />
		<meta http-equiv="description" content="This is my page" />
		    	<link href="${path}/common/css/reset.css" rel="stylesheet" type="text/css" />
    	<link href="${path}/common/css/public.css" rel="stylesheet" type="text/css" />		
		<link type="text/css" rel="stylesheet"
			href="${path}/common/js/easyui/themes/default/easyui.css" />
		<link type="text/css" rel="stylesheet"
			href="${path}/common/js/easyui/themes/icon.css" />
		<script type="text/javascript"
			src="${ctx}/common/js/easyui/jquery-1.8.0.min.js"></script>
		<script type="text/javascript"
			src="${path}/common/js/easyui/jquery.easyui.min.js"></script>
		<script type="text/javascript"
			src="${path}/common/js/easyui/locale/easyui-lang-zh_CN.js"></script>			
<style>
textarea
{
width:100%;
height:100%;
display:block;
}
</style>

<script type="text/javascript">
var api = frameElement.api, W = api.opener;
	function do_submit() {
		
		document.forms[0].submit();

	}
	
</script>
	</head>

	<body>
			<!--box-center-->
			 <form action="${ctx}/list/view!viewEdit.action" method="post">
			   
				<table style="width:100%;height:100%;"> 
					<tr>
						<td class="align">
							报表编码：
						</td>
						<td >
							<input type="text" readonly name="view.dynamicViewId" value="${view.dynamicViewId}"/>
						</td>
					</tr>				
					<tr>
						<td class="align">
							sql配置：
						</td>
						<td >
							<textarea  name="view.mainQueryTable" style="height:300px;" rows="30" >${view.mainQueryTable }</textarea>
						</td>
					</tr>		
					<tr>
						<td class="align">
							条件配置：
						</td>
						<td >
							<textarea  cols="" rows="50" style="height:500px;" name="view.queryDef" >${view.queryDef }</textarea>
						</td>
					</tr>							
					<tr>
						<td class="align" style="width:10%;">
							表列配置：
						</td>
						<td >
							<textarea  cols="40" rows="40" style="height:400px;" name="view.tableColDef" >${view.tableColDef }</textarea>
						</td>
					</tr>


					<tr>
						<td class="align">
							状态按钮：
						</td>
						<td >
							<textarea  cols="" rows="10" style="height:100px;" name="view.stateQueryBtnDef" >${view.stateQueryBtnDef }</textarea>
						</td>
					</tr>

					<tr>
						<td class="align">
							操作按钮：
						</td>
						<td >
							<textarea  cols="" rows="5" style="height:100px;" name="view.optBtnDef" >${view.optBtnDef }</textarea>
						</td>
					</tr>
					<tr>
						<td class="align">
							页面config：
						</td>
						<td >
							<textarea  cols="" rows="10" style="height:150px;" name="view.pageConfigDef" >${view.pageConfigDef }</textarea>
						</td>
					</tr>										
	
					<tr>
						<td class="align" style="width:10%;">
							 表属性：
						</td>
						<td >
							<textarea  cols="" rows="5" style="height:100px;" name="view.tablePropertyDef" >${view.tablePropertyDef }</textarea>
						</td>
					</tr>	
				</table>
				</form>			
		</div>
	</body>
</html>
<script type="text/javascript">
	 	if(${winIsClose}){
	 	    alert("操作成功");
	 	    //parent.refresh_window();
	 		//cancel();
	 		api.get("page_view_detail",1).close();
	 	}		
</script>
