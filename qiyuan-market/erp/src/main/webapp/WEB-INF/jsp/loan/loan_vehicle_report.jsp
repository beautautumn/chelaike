<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"
	language="java"%>
<%@taglib uri="/struts-tags" prefix="s"%>
<%@ include file="/common/taglibs.jsp"%>
<%@ include file="/common/meta.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<title>融资-车辆检测报告</title>
	<link rel="stylesheet" type="text/css" href="${ctx}/css/style.css" />
	<script type="text/javascript" src="${ctx}/js/common/syUtil.js"></script>
	<script type="text/javascript" src="${ctx}/js/common/ctutil.js"></script>
	<script type="text/javascript" src="${ctx}/js/common/jquery.json-2.4.js"></script>
	<script type="text/javascript" src="${ctx}/js/plugins/jquery/jquery.js"></script>
	<script type="text/javascript" src="${ctx}/js/plugins/bootstrap-3.0.3/js/bootstrap.min.js"></script>
	<script type="text/javascript" src="${ctx}/js/plugins/jstree/_lib/jquery.cookie.js"></script>
	<script type="text/javascript" src="${ctx}/js/plugins/jstree/_lib/jquery.hotkeys.js"></script>
	<link rel="stylesheet" type="text/css" href="${ctx}/js/plugins/jquery/uploadifive/uploadifive.css" />
	<script src="${ctx}/js/plugins/jquery/uploadifive/jquery.uploadifive.js"></script>
  <script type="text/javascript" src="${ctx}/js/plugins/My97DatePicker/WdatePicker.js"></script>
 
<script>
 
	var api = frameElement.api, W = api.opener;

  $(document).ready(function(){
 
 	})
	
	function do_submit(){
	   api.get("detectingReportPage",1).close();
     W.query1();  
	}
	function deleterep(id){
		if(confirm("是否删除质检报告？")){
			$.ajax({
				cache: false,
		        type: "POST",
				url:ctutil.bp()+"/loan/loanEval!deleterep.action",
				data:{tradeId:id},
				async: false,
				success:function(data){
					if(data=="success"){
						alert("删除成功");
						api.get("detectingReportPage",1).close();
						W.query1();
					}else{
						alert("删除失败");
						api.get("detectingReportPage",1).close();
						W.query1();
					}
				}
			});
		}
	}
	
</script>

</head>
<body>
<form id="myForm">
   <div id="img">
      <c:if test="${pic ==null}">
         &nbsp;没有检测报告！
      </c:if>  
      <c:if test="${pic !=null}">
        <img src="${pic.smallPicUrl}" width="400" height="400" style="margin:20px 0 0 20px"  />
        <input type="button" value="删除" onclick="deleterep(${tradeId})"/>
      </c:if>
   </div>    
</form>
</body>
</html>
