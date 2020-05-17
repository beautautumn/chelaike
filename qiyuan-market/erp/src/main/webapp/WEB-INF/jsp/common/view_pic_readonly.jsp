<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%@include file="/taglibs.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<base href="<%=basePath%>" />
		<title>查看附件</title>
		<meta http-equiv="pragma" content="no-cache" />
		<meta http-equiv="X-UA-Compatible" content="IE=7" />
		<meta http-equiv="cache-control" content="no-cache" />
		<meta http-equiv="expires" content="0" />
		<meta http-equiv="keywords" content="keyword1,keyword2,keyword3" />
		<meta http-equiv="description" content="This is my page" />
		<link href="${path }/common/css/public.css" rel="stylesheet"type="text/css" />
		<script type="text/javascript" language="javascript" src="${path}/common/js/jquery-1.6.2.js"></script>
		<script type="text/javascript" src="${path}/common/js/attention/dialog/zDrag.js"></script>
		<script type="text/javascript" src="${path}/common/js/attention/dialog/zDialog.js"></script>
		<script src="${path}/common/js/select.js" type="text/javascript"></script>
		<script src="${path}/common/js/tanchu_pic.js" type="text/javascript"></script>
		<script src="${path}/common/js/prototype.lite.js" type="text/javascript"></script>
		<script src="${path}/common/js/moo.fx.js" type="text/javascript"></script>
		<script src="${path}/common/js/moo.fx.pack.js" type="text/javascript"></script>
		<script type="text/javascript" src="${path}/common/js/jquery.uploadPreview.js"></script>	
		
		
		<style>
.tab {
	font-weight: bold;
	background: url(${ctx}/common/images/tab_list_bg.png);
	height: 30px;
	line-height: 30px;
	text-align: center;
	color: #313f52;
	font-size: 13px
}
</style>
		<script type="text/javascript">
			var api = frameElement.api, W = api.opener;
			function do_submit(){
				api.get('the_list_dialog',1).close();
			
			}
			
			
    </script>
	</head>
	<body>
		<!--top_right-->
		<div>


			<div class="tc_bottom-img">

				<div class="tabtop-import-img">

					<div id="imgDiv" style="height:410px; overflow:auto; width:785px;">
						<c:if test="${not empty filePath}">
							<img class="imgShow" name="resImg" id="resImg" src="${filePath}" />
						</c:if>
						<c:if test="${empty filePath}">
							没有上传图片。
						</c:if>
						 	
						 	
					</div>
					
				</div>
				

			</div>

		</div>



		<!--top_right over-->
		<script type="text/javascript" language="javascript"
			src="${ctx}/common/js/My97DatePicker/WdatePicker.js" defer="defer"></script>
	</body>
</html>

