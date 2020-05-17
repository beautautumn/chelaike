<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@taglib uri="/struts-tags" prefix="s"%>
<%@ include file="/common/taglibs.jsp"%>
<%@ include file="/common/meta.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>商户离场</title>
<link rel="stylesheet" type="text/css" href="${ctx}/css/style.css" />
<script type="text/javascript" src="${ctx}/js/common/syUtil.js"></script>
<script type="text/javascript" src="${ctx}/js/common/ctutil.js"></script>
<script type="text/javascript" src="${ctx}/js/common/menu.js"></script>
<script type="text/javascript" src="${ctx}/js/common/select.js"></script>
<script type="text/javascript" src="${ctx}/js/common/jquery.json-2.4.js"></script>
<script type="text/javascript" src="${ctx}/js/business/vehicle/vehicle_vin.js"></script>
<script type="text/javascript" src="${ctx}/js/pages/catalogue/catalogue.js"></script>
<script type="text/javascript" src="${ctx}/js/pages/region/region.js"></script>
<script type="text/javascript" src="${ctx}/js/common/validator/validator.js"></script>
<script type="text/javascript" src="${ctx}/js/plugins/My97DatePicker/WdatePicker.js"></script>
<script>
	var api = frameElement.api, W = api.opener;
	
	function do_submit(data){
		$.ajax({
			cache: false,
			type: "POST",
			url:ctutil.bp()+"/rent/contractListAction!doPassWorking.action",
			data:{contractId:$("#contractId").val()},
			async: false,
			error: function() {
			html = "数据请求失败";
			},
			success: function(data) {
			  if(data=="success"){
				  alert("保存成功！");
				  api.get("workingPage",1).close();
				  W.query1();  
			  }else{
				  alert("保存失败！");
				  api.get("workingPage",1).close();
				  W.query1();
			  }
			}
		});
	}
	
</script>

</head>
<body>
<input type="hidden" id="contractId" value="${contractId}" />
</body>
</html>
