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
		<script type="text/javascript" src="${ctx}/js/common/ctutil.js"></script>
		<script type="text/javascript" src="${ctx}/js/common/syUtil.js"></script>
		<script type="text/javascript" src="${ctx}/js/common/menu.js"></script>	
		<script type="text/javascript">
			
			function formatterCommonLink(value){
				return "<a style=\"color:#8FACEF;text-decoration:underline\" href=\"javascript:viewDetail('"+value+"')\">"+value+"</a>";
			}
			
			function viewDetail(data){
				var url="/list/view!toViewEdit.action?view.dynamicViewId="+data;				
				menu.create_max_dialog_identy("page_view_detail","修改报表",url);
			}
			function open3(url,name,width,height){
				dialog = new Dialog();
				dialog.Width =width;
				dialog.Height = height;
				dialog.Title = name;
				dialog.URL = url;
				dialog.show();
			}	
        	function refresh_window() {
        		
        	}
 			function cancel(){	  			
      			dialog.close();
			}  			
		</script>
	</head>
  
  <body>
<div class="center" style="width:100%;height:100%"> 
    <table id="tt" class="easyui-datagrid"   
            url="${ctx}/list/view!queryPageData.action?pageSize=500"  
            title="报表列表" iconCls="icon-save"   sortOrder="asc"  
            rownumbers="true" pagination="true">  
        <thead>  
            <tr>  
            	<th field="dynamicViewId" width="80" align="right" sortable="true"  formatter="formatterCommonLink">报表id</th> 
            </tr>  
        </thead>  
    </table> 
     </div>
  
  </body>
</html>
