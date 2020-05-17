<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ include file="/common/taglibs.jsp"%>
<%@ include file="/common/meta.jsp"%>
<%@taglib uri="/struts-tags" prefix="s" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
  <title></title>	
	<link rel="stylesheet" type="text/css" href="${ctx}/css/style.css" />
	<link rel="stylesheet" type="text/css" href="${ctx}/js/plugins/lhgdialog/skins/mac.css" />
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
  </head>
  <script >
     function do_submit(){
      var api = frameElement.api, W = api.opener;
      var data =""; 
      var row = $("#row").attr("value");
		  data+=row+"|";
     data+=$("#itemIds").val()+"|";
     var feeValue=$("#feeValue").val();
     if(feeValue==""||feeValue==0){
      alert("请填写费用金额");
      return;
     }else{
      data+=feeValue+"|";
     }
     data+=$("#staffId").val()+"|";
     var date =$("#date").val();
     if(date==""){
      alert("请选择计费日期");
      return;
     }else{
      data+=date+"|";
     }
     data+=$("#remark").val();
     api.get('rectFeePage').do_get_edit(data);
   	 api.get("editFee",1).close();
     }
  </script>
  <body>
  	<form id="">
  		<div style="text-align:center;margin-top:20px;">
  			<table>
  				<tr style="width:500px;">
  					<td class="text-r" width="100px;">费用科目:</td>
  					<td width="150px;">
  					<select id="itemIds"  name="itemIds" style="width:150px;" value="${itemIds}" >
							<s:iterator value="feeItems">
								<option <s:if test="itemIds==id">selected</s:if> value="<s:property value="id"/>,<s:property value="itemName"/>"><s:property value="itemName"/></option>
							</s:iterator>
					</select>
  					</td>
  					<td class="text-r" style="width:300px;" >费用金额:
  						<input   value="${feeValue}" id="feeValue" name="feeValue" onkeyup="value=value.replace(/[^(\d||/.)]/g,'')" />元
  					</td>
  				</tr>
  				<tr style="width:500px;height:50px;">
            <td class="text-r" width="100px;">计费人:</td>
            <td width="150px;">
            <select id="staffId"  name="staffId" style="width:150px;" value="${staffId}">
              <s:iterator value="staffs">
                <option <s:if test="staffId==id">selected</s:if> value="<s:property value="id"/>,<s:property value="name"/>"><s:property value="name"/></option>
              </s:iterator>
          </select>
            </td>
            <td class="text-r" style="width:300px;" >计费日期:
            <input type="text" value="${date}" id="date" name="date"  onclick="WdatePicker()" onblur="setEndDate();"/>
            </td>
          </tr>
  			</table>
  		</div>
  		<br/>
  		<div style="text-align:center;">
  			<table>
  				<tr style="width:500px;height:120px;">
  					<td class="text-r" width="100px;">费用备注:
  					</td>
  					<td class="text-r" >
  						<input value="${remark}" name="remark" id="remark" style="width:450px;height:120px">
<!--					<textarea value="${remark}" name="remark" id="remark" style="width:450px;height:120px"></textarea>-->
  					</td>
  				</tr>
  				<input  type="hidden" value="${row}" id="row"/>
  			</table>
  		</div>
  	</form>
  </body>
</html>