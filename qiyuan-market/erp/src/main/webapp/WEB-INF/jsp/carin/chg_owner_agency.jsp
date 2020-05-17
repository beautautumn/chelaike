<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@taglib uri="/struts-tags" prefix="s"%>
<%@ include file="/common/taglibs.jsp"%>
<%@ include file="/common/meta.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>车辆转移</title>
<link rel="stylesheet" type="text/css" href="${ctx}/css/style.css" />
<script type="text/javascript" src="${ctx}/js/common/syUtil.js"></script>
<script type="text/javascript" src="${ctx}/js/common/ctutil.js"></script>
<script type="text/javascript" src="${ctx}/js/common/menu.js"></script>
<script type="text/javascript" src="${ctx}/js/plugins/My97DatePicker/WdatePicker.js"></script>

<link rel="stylesheet" type="text/css" href="${ctx}/js/plugins/jquery-easyui/themes/default/easyui.css" />
<link rel="stylesheet" type="text/css" href="${ctx}/js/plugins/jquery-easyui/themes/icon.css" />

<script>
	var check = false;
  $(document).ready(function(){
      $("#operTime").val(new Date().format('yyyy-MM-dd'));
      $('#agencyId').combobox({
			panelHeight : 200,
			editable : true,
			url : ctutil.bp() + "/sys/comm!getAgencyList.action",
			valueField : 'id',
			textField : 'name',
			onSelect : function(rec) {
				checkPort();
			}
		});
  });
	var api = frameElement.api, W = api.opener;

	function do_submit(){
		if(!check){
			alert("该商户车位数已满");
			return;
		}
	  var agencyId=$("input[name='agencyId']").val();
	  if(agencyId==null||agencyId==""||agencyId==-1)
	  {
	    alert("请选择要转移的商户！");
	    return;
	  }
  	var data ="";
    data = $("#myForm").serialize();
	  ajaxPost(data);
  }
	
	function ajaxPost(data){
		$.ajax({
				cache: false,
				type: "POST",
				url:ctutil.bp()+"/carin/vehicleInput!doChgOwnerAgency.action",
				data:data,
				async: false,
				error: function() {
				  html = "数据请求失败";
				},
				success: function(data) {
				  if(data=="success"){
					  alert("保存成功！");
					  api.get("chgOwnerAgency",1).close();
					  W.query1();  
				  }else{
					  alert("保存失败,请重试！");
				  }
				}
			});
	}
	
	function checkPort(){
		var id = $("input[name='agencyId']").val();
		$.ajax({
			url:ctutil.bp()+"/carin/vehicleInput!checkCarport.action",
			data:{agencyId:id},
			success:function(data){
				if(data=="success"){
					check=true;
				  }else{
					  alert("该商户车位数已满");
					  check=false;
				  }
			}
		});
	}
</script>
</head>
<body>
	<form id="myForm">
	<input type="hidden" id="tradeId" name="tradeId" value="${tradeId}" ></input>
 
  <div class="box">
		<table>
					<tr>
						<td class="text-r" width="100px" id="areaTotal">
							商户名称
						</td>
						<td width="400px">
							<input class="easyui-combobox" style="width: 200px;" id="agencyId" name="agencyId" />
							<%-- <select id="agencyId" class="input w100" name="agencyId" onchange="checkPort()">
								<option value='-1'>
									请选择
								</option>
								<s:iterator value="agencys">
									<option value="<s:property value='id'/>">
										${agencyName}
									</option>
								</s:iterator>
							</select> --%>
						</td>
					</tr>		
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
		  </tr>
		  <tr>
          <td class="text-r" width="200px;">操作日期: </td>
          <td width="200px;">
            <input style="width:200px;height:25px;"  type="text"  id="operTime" name="carOperHis.operTime"  onclick="WdatePicker()" />
          </td>
      </tr>
      <tr style="width:200px;">
          <td class="text-r" width="200px;" >操作说明:</td>       
          <td >
          <input name="carOperHis.operDesc" id="carOperHis.operDesc" style="width:200px;"></input>
          </td>
      </tr> 
		</table>
    </div>
   </div>
	</form>
</body>
</html>
