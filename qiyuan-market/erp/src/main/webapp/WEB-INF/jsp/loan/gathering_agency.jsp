<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"
	language="java"%>
<%@taglib uri="/struts-tags" prefix="s"%>
<%@ include file="/common/taglibs.jsp"%>
<%@ include file="/common/meta.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<title>融资预收</title>
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
       $("#prepareDate").val(new Date().format('yyyy-MM-dd'));
  }) 	
  
  
  function calc(){
		var acquPrice= $('#acquPrice').val();
		var maxFinPrice = $("#financingMax").val();
		var finPrice = $("#financingFee").val();
		if(Number(finPrice)>Number(maxFinPrice)){
			alert("融资金额不得高于最大融资金额！");
			return;
		}
		if (acquPrice==null ||acquPrice =="")
		{
			acquPrice =0;
		}
		var financingFee= $('#financingFee').val();
		if (financingFee==null ||financingFee =="")
		{
			financingFee =0;
		}
		$('#prepareFee').val((acquPrice-financingFee).toFixed(3));
		
  }
  
  
	function do_submit(){
		var maxFinPrice = $("#financingMax").val();
		var finPrice = $("#financingFee").val();
		if($("#loanRate").val()==""){
			$("#loanRate").val("0");
		}
		if(Number(finPrice)>Number(maxFinPrice)){
			alert("融资金额不得高于最大融资金额！");
			return;
		}
		var acquPrice= $('#acquPrice').val();
		if (acquPrice==null ||acquPrice =="")
		{
			acquPrice =0;
		}
		
		var financingFee= $('#financingFee').val();
		if (financingFee==null ||financingFee =="")
		{
			financingFee =0;
		}
		var prepareFee= $('#prepareFee').val();
		if (prepareFee==null ||prepareFee =="")
		{
				prepareFee =0;
		}
	 
		if (acquPrice-prepareFee-financingFee!=0)
		{
			 alert("请确保融资总额+预收金额=收购价格！");
			 $('#financingFee').focus();
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
				url:ctutil.bp()+"/loan/loanEval!doGatheringAgency.action",
				data:data,
				async: false,
				error: function() {
				  html = "数据请求失败";
				},
				success: function(data) {
					if(data=="success"){
						alert("保存成功！");
						api.get("gatheringAgency",1).close();
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
	<input type="hidden" name="tradeId" id="tradeId" value="${tradeId}" />
	<input type="hidden" name="financing.id" id="financing.id" value="${financing.id}" />
  
	<div class="box">
		<table>
		    <tr>
		      <td>
		        &nbsp; &nbsp; &nbsp; &nbsp; 
		      </td>
		    </tr>
			<tr>
				<td class="text-r" width="100px">
					车辆估值：
				</td>
				<td width="400px">
					<input class="input w200" id="valuationFee" style="background-color:#F0F0F0" name="valuationFee" readonly="readonly" value='${valuationFee}' />万
					<font color="red">(估值来源：估值系统)</font>
				</td>
			</tr>
			
			
			<tr>
				<td class="text-r" width="100px">
					最大贷款额：
				</td>
				<td width="400px">
					<input class="input w200" id="financingMax"  style="background-color:#F0F0F0" name="financingMax" value ='${financingMax}' readonly="readonly"  onchange="if(isNaN(this.value)){alert('请输入合法数字!');this.value='';$('#financingMax').focus();}"/>万
				</td>
			</tr>				 
      <tr>
        <td class="text-r" width="100px">
                           估值人：
        </td>
        <td width="400px">
          <input class="input w200" id="financingMax"  style="background-color:#F0F0F0" name="financing.staffByValuationStaff.name" readonly="readonly" value='${financing.staffByValuationStaff.name}' onchange="if(isNaN(this.value)){alert('请输入合法数字!');this.value='';$('#financingMax').focus();}"/>
        </td>
      </tr> 
      <tr style="width:200px;height:90px;">
          <td class="text-r" width="200px;" valign="top" style="padding-top:10">估值说明: &nbsp;&nbsp;&nbsp;</td>       
          <td>
          <textarea name="financing.valuationDesc" readonly="readonly" id="financing.valuationDesc" style="background-color:#F0F0F0;width:200px;height:80px;">${financing.valuationDesc}</textarea>
          </td>
      </tr>  
      <tr>
        <td class="text-r" width="100px">
                          收购价格：
        </td>
        <td width="400px">
          <input class="input w200" id="acquPrice" name="acquPrice"  value='${acquPrice}' onchange="if(isNaN(this.value)){alert('请输入合法数字!');this.value='';$('#financingMax').focus();}"/>万
        </td>
      </tr> 
      <tr>
        <td class="text-r" width="100px">
                          融资金额：
        </td>
        <td width="400px">
          <input class="input w200" id="financingFee" name="financingFee"     onblur="calc();"  onchange="if(isNaN(this.value)){alert('请输入合法数字!');this.value='';$('#financingFee').focus();}"/>万
        </td>
      </tr>       
      <tr>
        <td class="text-r" width="100px">
                          预收金额：
        </td>
        <td width="400px">
          <input class="input w200" id="prepareFee" name="prepareFee"       onchange="if(isNaN(this.value)){alert('请输入合法数字!');this.value='';$('#prepareFee').focus();}"/>万
        </td>
      </tr>       
      <tr>
        <td class="text-r" width="100px">
                          贷款利率(%)：
        </td>
        <td width="400px">
          <input class="input w200" id="loanRate" name="financing.loanRate"     onchange="if(isNaN(this.value)){alert('请输入合法数字!');this.value='';$('#loanRate').focus();}"/>  
        </td>
      </tr>        
                  
			<tr>
				<td class="text-r" width="100px" >
				     收款人：
				</td>
				<td width="400px">
					<select id="financing.staffByPrepareStaff.id" class="input w200" name="financing.staffByPrepareStaff.id">
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
      <tr style="width:200px;height:35px;">
          <td class="text-r" width="200px;">收款日期: &nbsp; </td>
          <td width="200px;">
            <input style="width:200px;height:25px;"  type="text"  id="prepareDate" name="financing.prepareDate"  onclick="WdatePicker()" />
          </td>
      </tr>
      <tr style="width:200px;height:90px;">
          <td class="text-r" width="200px;" valign="top" style="padding-top:10">收款说明: &nbsp;&nbsp;&nbsp;</td>       
          <td>
          <textarea name="financing.prepareDesc" id="financing.prepareDesc" style="width:200px;height:80px;"></textarea>
          </td>
      </tr> 
		</table>
	</div>
</form>
</body>
</html>
