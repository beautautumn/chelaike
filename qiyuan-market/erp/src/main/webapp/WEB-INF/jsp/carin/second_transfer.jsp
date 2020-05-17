<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"	language="java"%>
<%@taglib uri="/struts-tags" prefix="s"%>
<%@ include file="/common/taglibs.jsp"%>
<%@ include file="/common/meta.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<title>销售过户</title>
		<link rel="stylesheet" type="text/css" href="${ctx}/css/style.css" />
		<script type="text/javascript" src="${ctx}/js/common/syUtil.js"></script>
		<script type="text/javascript" src="${ctx}/js/common/ctutil.js"></script>
		<script type="text/javascript" src="${ctx}/js/common/jquery.json-2.4.js"></script>
		<script type="text/javascript" src="${ctx}/js/plugins/jquery/jquery.js"></script>
		<script type="text/javascript" src="${ctx}/js/plugins/bootstrap-3.0.3/js/bootstrap.min.js"></script>
		<script type="text/javascript" src="${ctx}/js/plugins/jstree/_lib/jquery.cookie.js"></script>
		<script type="text/javascript" src="${ctx}/js/plugins/jstree/_lib/jquery.hotkeys.js"></script>
		<link rel="stylesheet" type="text/css"	href="${ctx}/js/plugins/jquery/uploadifive/uploadifive.css" />
		<script	src="${ctx}/js/plugins/jquery/uploadifive/jquery.uploadifive.js"></script>

<style type="text/css">
.message_box {
	width: 300px;
	height: 120px;
	overflow: hidden;
}

.message_box_t {
	width: 25px;
	padding-left: 275px;
	background: url(../img/message_box_top.png);
	height: 20px;
	padding-top: 10px;
}

.message_box_m {
	width: 280px;
	padding: 10px;
	background: url(../img/message_box_body.png);
	text-align: left;
	line-height: 35px;
	font-size: 14px;
}

.message_box_b {
	width: 300px;
	background: url(../img/message_box_bottom.png);
	height: 30px;
}
</style>

<script>
	  var api = frameElement.api, W = api.opener;
    var bSaved=false;
	
	function do_submit()
  {
		var data = $("#myForm").serialize();
		ajaxPost(data);
	}
	
	function ajaxPost(data2){
	  var url1 =ctutil.bp()+"/carin/vehicleInput!doSecondTransfer.action";
	  $.ajax({
				cache: false,
				type: "POST",
				url:url1,
				data:data2,
				async: false,
				error: function() {
				  html = "数据请求失败";
				},
				success: function(data) {
				  if(data=="success"){
					  alert("保存成功！");
					  api.get("secondTransfer",1).close();
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
    <form id="myForm">
      <input type="hidden" id="trade.id"   name="trade.id"  value="${trade.id}" readonly="readonly" />        
      <div class="box">
        <table>
          <tr>
            <td class="text-r" width="100px">
              <span class="red">*</span>条码编号：
            </td>
            <td width="400px">
              <input class="input w200" id="barCode" name="trade.barCode" value="${trade.barCode}"  style="background-color:#F0F0F0" />
            </td>
          </tr>
        </table>
        <table>
          <tr>
            <td class="text-r" width="100px" id="areaTotal">
              商户名称
            </td>
            <td width="400px">
              <input class="input w200" id="agencyName"  style="background-color:#F0F0F0"  name="agencyName"  value="${trade.agency.agencyName}" readonly="readonly" />
            </td>
          </tr>
          <tr>
            <td class="text-r" width="100px" id="feeMeter">
              品牌车系:
            </td>
            <td width="400px">
              <input class="input w200" id="totalNum" name="trade.vehicle.brand.name"  value="${trade.vehicle.brand.name} ${trade.vehicle.series.name}"    style="background-color:#F0F0F0" readonly="readonly" />
            </td>
          </tr>
          <tr>
            <td class="text-r" width="100px" id="feeMeter">
              车牌号:
            </td>
            <td width="400px">
              <input class="input w200" id="unusedNum" name="trade.oldlicenseCode" value="${trade.oldLicenseCode}"  style="background-color:#F0F0F0" readonly="readonly" />
            </td>
          </tr>

        </table>
      </div>

    </form>

 

	</body>
</html>
