<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@taglib uri="/struts-tags" prefix="s"%>
<%@ include file="/common/taglibs.jsp"%>
<%@ include file="/common/meta.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>调整空车位</title>
<link rel="stylesheet" type="text/css" href="${ctx}/css/style.css" />
<script type="text/javascript" src="${ctx}/js/common/syUtil.js"></script>
<script type="text/javascript" src="${ctx}/js/common/ctutil.js"></script>
<script type="text/javascript" src="${ctx}/js/common/menu.js"></script>
<script type="text/javascript" src="${ctx}/js/plugins/My97DatePicker/WdatePicker.js"></script>
<script>
  $(document).ready(function(){
      $("#operTime").val(new Date().format('yyyy-MM-dd'));
  })
	var api = frameElement.api, W = api.opener;
   
  function chk(obj){
    $("#tradeId").val(obj.id);  
  }
	
	function do_submit(){
  	var data ="";
  	var tradeId=$("#tradeId").val();
  	if(tradeId=="")
  	{
  	  alert("请选择要删除的车辆！");
  	  return;
  	}
  	if (confirm("确定删除编号为"+tradeId+"的车辆信息吗，删除后将无法恢复！"))
  	{
  	  data = $("#myForm").serialize();
		  ajaxPost(data);
  	} 
  }
	
	function ajaxPost(data){
		$.ajax({
				cache: false,
				type: "POST",
				url:ctutil.bp()+"/carin/vehicleInput!doChgCarPort.action",
				data:data,
				async: false,
				error: function() {
				  html = "数据请求失败";
				},
				success: function(data) {
				  if(data=="success"){
					  alert("保存成功！");
					  api.get("chgCarPort",1).close();
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
	<input type="hidden" id="tradeId" name="tradeId" ></input>
 	<div id="tab">
		<div class="box">
			<table style="width:95%;margin-top:15px;margin-bottom:15px;border:1" >	
  				<tr>  
								<td style="text-align:center;text-valign:center;width:30px;height:35px;"><strong>编号</strong></td>
								<td style="text-align:center;text-valign:center;width:30px;height:35px;"><strong>品牌车系</strong></td>
								<td style="text-align:center;text-valign:center;width:100px;height:35px;"><strong>操作</strong></td>								
					</tr>
					<c:if test="${empty tradeList }">
					  <tr><td></td><td style="text-align:center;text-valign:center;width:10px;height:35px;" colpan=3><font color="red">没有可调整的库存车辆！</font></td><td></td></tr>
					</c:if>
					<c:if test="${tradeList!=null}">
					  <s:iterator value="tradeList">
						<tr>						
									<td style="text-align:center;text-valign:center;width:10px;height:35px;"> ${id} </td>
									<td style="text-align:center;text-valign:center;width:50px;height:35px;"> ${vehicle.brandName}${vehicle.seriesName} </td>
									<td style="text-align:center;text-valign:center;width:100px;height:35px;"> 
									   <input type="radio" id="${id}" name="del" onclick="chk(this);"></input>标记删除
									</td>
 				  	</tr>
					  </s:iterator>
					</c:if>
			</table>
		</div>
    <div class="box">
		<table>
    	<tr>
				<td class="text-r" width="100px" >
				     操作人:
				</td>
				<td width="200px">
					<select id="carOperHis.staff.id" class="input w200" name="carOperHis.staff.id">
					    <option value='0'>请选择</option>
						<s:iterator value="staffs">
						   <s:if test="id==staffId">
								<option value="<s:property value='id'/>" selected><s:property value="name"/></option>
						   </s:if>
						   <s:else>
						   		<option value="<s:property value='id'/>"><s:property value="name"/></option>
						   </s:else>
						</s:iterator>
				 	</select>
				</td>
		 
          <td class="text-r" width="200px;">操作日期: </td>
          <td width="200px;">
            <input style="width:200px;height:25px;"  type="text"  id="operTime" name="carOperHis.operTime"  onclick="WdatePicker()" />
          </td>
      </tr>
      <tr style="width:200px;">
          <td class="text-r" width="200px;" >操作说明:</td>       
          <td colspan='3'>
          <input name="carOperHis.operDesc" id="carOperHis.operDesc" style="width:640px;"></input>
          </td>
      </tr> 
		</table>
    </div>
   </div>
	</form>
</body>
</html>
