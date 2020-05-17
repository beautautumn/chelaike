<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@taglib uri="/struts-tags" prefix="s"%>
<%@ include file="/common/taglibs.jsp"%>
<%@ include file="/common/meta.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>分摊记录</title>
<link rel="stylesheet" type="text/css" href="${ctx}/css/style.css" />
<script type="text/javascript" src="${ctx}/js/common/syUtil.js"></script>
<script type="text/javascript" src="${ctx}/js/common/ctutil.js"></script>
<script type="text/javascript" src="${ctx}/js/common/menu.js"></script>
<script type="text/javascript" src="${ctx}/js/plugins/My97DatePicker/WdatePicker.js"></script>
<script>
	
</script>
</head>
<body>
	<div class="box">
	<br/>
	 	<div style="margin:0 auto;border:1px solid #000;width:700px;height:325px">
				<div style="margin:0 auto;overflow:hidden;border:0px;width:700px;height:35px">
					<table border="1" style="width:680px">
							<tr border="1" align="center">
								<td width="50px" height="33px" align="center"><b>分摊商户</b></td>
								<td width="65px"><b>分摊区域</b></td>
								<td width="150px"><b>合同有效期</b></td>
								<td width="120px"><b>分摊数额（元）</b></td>
								<td width="130px"><b>备注</b></td>
							</tr>
					</table>
				</div>	
				<div style="margin:0 auto;border:1px;overflow:scroll;width:700px;height:290px">
						<table id="agencytable" border="1" style="width:680px">
						  <s:iterator value="agencyDetailBillsBeans">
							<tr style='border:1px solid #000;'>
							<td width='50px'>&nbsp;<s:property value="agencyDetailBills.contractArea.contract.agency.agencyName" /></td>
							<td width='65px'>&nbsp;<s:property value="agencyDetailBills.contractArea.siteArea.areaName" />-<s:property value="agencyDetailBills.contractArea.areaNo" /></td>
							<td width='150px'>&nbsp;<s:property value="contractDate"/></td>
							<td width='120px'>&nbsp;<s:property value="feeValue"/></td>
							<td width='130px'>&nbsp;<s:property value="agencyDetailBills.remark"/></td>
							</tr>
						  </s:iterator>
						</table>
				</div>
				
		</div>
	</div>
</body>
</html>

