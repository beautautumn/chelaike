<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"	language="java"%>
<%@taglib uri="/struts-tags" prefix="s"%>
<%@ include file="/common/taglibs.jsp"%>
<%@ include file="/common/meta.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<title>车辆检测</title>
		<link rel="stylesheet" type="text/css" href="${ctx}/css/style.css" />
		<script type="text/javascript" src="${ctx}/js/common/syUtil.js"></script>
		<script type="text/javascript" src="${ctx}/js/common/ctutil.js"></script>


  <script type="text/javascript">
	  var api = frameElement.api, W = api.opener;
	  var id=${tradeId};
	  //检测条码的输入规则		
	function do_submit()
	{
		ajaxPost();
	}
	
	function ajaxPost(){
	  var url1 =ctutil.bp()+"/carin/vehicleInput!doVehicleTest.action";
	  $.ajax({
				cache: false,
				type: "POST",
				url:url1,
				data:{tradeId:id},
				async: false,
				error: function() {
				  html = "数据请求失败";
				},
				success: function(data) {
				  if(data=="success"){
					  alert("保存成功！");
					  api.get("vehicleTest",1).close();
					  W.query1();  
				  }else{
					  alert("保存失败,请重试！");
				  }
				}
			});
	}

  </script>
  
  
  
</head>
<body>

</body>
</html>
