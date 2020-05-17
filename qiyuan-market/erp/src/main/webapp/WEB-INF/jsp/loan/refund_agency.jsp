<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"
	language="java"%>
<%@taglib uri="/struts-tags" prefix="s"%>
<%@ include file="/common/taglibs.jsp"%>
<%@ include file="/common/meta.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<title>商户退款</title>
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
       $("#payDate").val(new Date().format('yyyy-MM-dd'));
       var transferFee =$('#transferFee').val(); 
       if(transferFee>0)
       {
         $('#transferFee').attr("readOnly","readOnly");    
         $('#transferFee').css("background-color","#F0F0F0");       
       } 
    })
	
	function checkValue(a){
	 	if(a.checked==true){
		 		a.value=1;
			 }else{
			 	a.value=0;
		  	}
 	}
    //应付商户款=销售价格-应还款本金-应还款利息-过户费用；  
	function calcFee(){
	  var salePrice=$('#salePrice').val()*10000;
	  var repayBaseFee = $('#repayBaseFee').val()*10000;
	  var repayInterest =  $('#repayInterest').val();
	  var transferFee =$('#transferFee').val(); 
	  var payedAgencyFee =$('#payedAgencyFee').val(); 
	  
	  $('#payAgencyTotalFee').val(parseInt(salePrice-repayBaseFee-repayInterest-transferFee));
	  var payAgencyTotalFee =$('#payAgencyTotalFee').val();
	  $('#curPayFee').val(payAgencyTotalFee-payedAgencyFee);
	  
	}
	
	function do_submit(){
  		var data ="";
		data = $("#myForm").serialize();
		ajaxPost(data);
	}
	
	function ajaxPost(data){
		$.ajax({
				cache: false,
				type: "POST",
				url:ctutil.bp()+"/loan/loanEval!doRefundAgency.action",
				data:data,
				async: false,
				error: function() {
				  html = "数据请求失败";
				},
				success: function(data) {
				  if(data=="success"){
					  alert("保存成功！");
					  api.get("refundAgency",1).close();
					  W.query1();  
				  }else{
					  alert("保存失败,请重试！");
				  }
				}
			});
	}
	
	function refundCount(){
		var transfee = $("#transferFee").val();
		var refundfee = $("#refundFee").val();
		if(transfee!=""){
			refundfee = refundfee-transfee;
			$("#refundFee").val(refundfee);
			$("#curPayFee").val(refundfee);
		}
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
                          处置价格：
        </td>
        <td width="400px">
          <input class="input w200" id="disposalPrice" name="disposalPrice"  style="background-color:#F0F0F0"  readonly="readonly" value='${disposalPrice}' /> 万
        </td>
      </tr> 
       
      <tr>
        <td class="text-r" width="100px">
                          已收处置款：
        </td>
        <td width="400px">
          <input class="input w200" id="recvDisposalFee" name="recvDisposalFee"  style="background-color:#F0F0F0"  readonly="readonly"  value='${recvDisposalFee}'    /> 万  
        </td>
      </tr> 
      <tr>
        <td class="text-r" width="100px">
                          用款天数：
        </td>
        <td width="400px">
          <input class="input w200" id="financing.usedDays" name="financing.usedDays"  style="background-color:#F0F0F0"  readonly="readonly"  value='${financing.usedDays}'    /> 天  
        </td>
      </tr>  
      <tr>
        <td class="text-r" width="100px">
                          预收金额：
        </td>
        <td width="400px">
          <input class="input w200" id="prepareFee" name="prepareFee"  style="background-color:#F0F0F0"  readonly="readonly"   value="${prepareFee}"/> 万
        </td>
      </tr>             
      <tr>
        <td class="text-r" width="100px">
                           应还款本金：
        </td>
        <td width="400px">
          <input class="input w200" id="repayBaseFee" name="repayBaseFee"  style="background-color:#F0F0F0"  readonly="readonly"  value='${repayBaseFee}' /> 万
        </td>
      </tr>
      <tr>
        <td class="text-r" width="100px">
                          贷款利率(%)：
        </td>
        <td width="400px">
          <input class="input w200" id="loanRate" name="financing.loanRate" style="background-color:#F0F0F0"  readonly="readonly"  value='${financing.loanRate}'   />  
        </td>
      </tr>              
      <tr>
        <td class="text-r" width="100px">
                           应还款利息：
        </td>
        <td width="400px">
          <input class="input w200" id="recvInterest" name="recvInterest"  style="background-color:#F0F0F0"  readonly="readonly"  value="${financing.recvInterest}" /> 元
        </td>
      </tr>
      <tr>
        <td class="text-r" width="100px">
                          过户费：
        </td>
        <td width="400px">
          <input class="input w200" id="transferFee" name="transferFee" value="${financing.transferFee}" onblur="refundCount()" /> 元
        </td>
      </tr>       
       <tr>
        <td class="text-r" width="100px">
                           应退商户款：
        </td>
        <td width="400px">
          <input class="input w200" id="refundFee" name="refundFee" value="${financing.refundFee}" style="background-color:#F0F0F0"  readonly="readonly" /> 元
        </td>
      </tr>       
       <tr>
        <td class="text-r" width="100px">
                           已退商户款：
        </td>
        <td width="400px">
          <input class="input w200" id="refundedFee" name="refundedFee" value='${financing.refundedFee==null?0:financing.refundedFee}'  style="background-color:#F0F0F0"  readonly="readonly" /> 元  
        </td>
      </tr>  
      
      <tr>
        <td class="text-r" width="100px">
                           本次退款：
        </td>
        <td width="400px">
          <input class="input w200" id="curPayFee" name="curPayFee"  value='${financing.refundFee-financing.refundedFee}' /> 元
        </td>
      </tr> 
      <tr>
        <td class="text-r" width="100px">
        </td>
        <td width="400px">
          <input name="financing.refundOverTag"  type="checkbox" value="0" onclick="checkValue(this);" />全部退完
        </td>
      </tr> 

                          
	  <tr>
				<td class="text-r" width="100px" >
				     付款人：
				</td>
				<td width="400px">
					<select id="refundAgencyHis.staff.id" class="input w200" name="refundAgencyHis.staff.id">
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
          <td class="text-r" width="200px;">付款日期: &nbsp; </td>
          <td width="200px;">
            <input style="width:200px;height:25px;"  type="text"  id="payDate" name="refundAgencyHis.refundDate"  onclick="WdatePicker()" />
          </td>
      </tr>
      <tr style="width:200px;height:90px;">
          <td class="text-r" width="200px;" valign="top" style="padding-top:10">付款说明: &nbsp;&nbsp;&nbsp;</td>       
          <td>
          <textarea name="refundAgencyHis.refundDesc" id="refundAgencyHis.refundDesc" style="width:200px;height:80px;"></textarea>
          </td>
      </tr> 
	</table>
	
	
	<table style="margin:auto; width:95%;margin-top:15px;" border='0'>
			<tr >
				<td> 
				   退款历史: 
				</td>
			</tr>
	</table>
		<table style="margin:auto; width:95%;margin-top:15px;" border='1' name="contractAreas" id="contractAreas">
			<tr style="width:500px;">
				<td style="text-align:center;text-valign:center;width:50px;height:35px;"><font size="10px">退款人</font></td>
				<td style="text-align:center;text-valign:center;width:50px;height:35px;"><font size="10px">退款日期</font></td>
				<td style="text-align:center;text-valign:center;width:50px;height:35px;"><font size="10px">退款金额</font></td>
				<td style="text-align:center;text-valign:center;width:50px;height:35px;"><font size="10px">退款说明</font></td>
			</tr>
		  <c:if test="${empty refundAgencyHises}">
					<tr align="center">
						<td bgcolor="#ffffff">
							&nbsp;
						</td>
						<td bgcolor="#ffffff">
							无退款记录
						</td>
						<td bgcolor="#ffffff">
							&nbsp;
						</td>
						<td bgcolor="#ffffff">
							&nbsp;
						</td>
					</tr>
			</c:if>
			<c:if test="${not empty refundAgencyHises}">
				<c:forEach items="${refundAgencyHises}" var="op">
					<tr align="center">
						<td bgcolor="#ffffff">
							${op.staff.name}
						</td>
						<td bgcolor="#ffffff">
							<fmt:formatDate value="${op.refundDate}"
								pattern="yyyy-MM-dd" />
						</td>

						<td bgcolor="#ffffff">
							${op.refundFee}元
						</td>
						<td bgcolor="#ffffff" width="175px">
							${op.refundDesc}
						</td>
					</tr>
				</c:forEach>

			</c:if>			 
		</table>	
		
		
	</div>
</form>
</body>
</html>
