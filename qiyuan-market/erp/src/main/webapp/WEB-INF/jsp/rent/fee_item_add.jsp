<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@taglib uri="/struts-tags" prefix="s"%>
<%@ include file="/common/taglibs.jsp"%>
<%@ include file="/common/meta.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>新增收费科目</title>
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

<script>
	var api = frameElement.api, W = api.opener;

	function do_submit(){
	  var itemGroup=$("select option:selected");
	  if(itemGroup==-1)
	  {
	    $('#itemGroup').focus();
	    alert("请选择科目分组!");
	    return;
	  }	
		var itemName = $("#itemName").val();
    if(itemName=="")
    {
      $('#itemName').focus();
      alert("请录入科目名称!");
      return;
    } 
		var data = $("#myForm").serialize();
    ajaxPost(data);
	}
	
	function ajaxPost(data){
		$.ajax({
				cache: false,
				type: "POST",
				url:ctutil.bp()+"/rent/feeItem_add.action",
				data:data,
				async: false,
				error: function() {
				html = "数据请求失败";
				},
				success: function(data) {
				  if(data=="success"){
					  alert("保存成功！");
					  api.get("new_feeItem",1).close();
					  W.query1();  
				  }else{
					  alert("保存失败！");
					  api.get("new_feeItem",1).close();
					  W.query1();
				  }
				}
			});
	}
	
	
</script>

</head>
<body>
<form id="myForm">	
<div class="box">
			<table>	
        <tr>
          <td class="text-r" width="100px" ><span class="red">*</span>科目分组：</td>                    
          <td width="300px">
              <select id="itemGroup" name="feeItem.itemGroup">
                 <option value="运营科目">运营科目</option>
                 <option value="物业科目">物业科目</option>
              </select>       
          </td>
        </tr>
        <tr>
					<td class="text-r" width="100px" ><span class="red">*</span>科目名称：</td>
					<td width="300px"><input class="input w200" id="itemName" name="feeItem.itemName" value="${feeItem.itemName}"onblur="checkName(this);"/></td>
				</tr>
				<tr> 
					<td class="text-r">备注:</td>
					<td><textarea id="itemDesc" style="width:280px;height:120px" name="feeItem.itemDesc" value="${feeItem.itemDesc}"/></textarea></td>
					<td id="remarkText"></td>
				</tr>
		</table>
</div>		
</form>					
</body>
</html>
