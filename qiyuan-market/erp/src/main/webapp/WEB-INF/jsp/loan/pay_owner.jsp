<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"
	language="java"%>
<%@taglib uri="/struts-tags" prefix="s"%>
<%@ include file="/common/taglibs.jsp"%>
<%@ include file="/common/meta.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<title>支付车主</title>
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

	function checkValue(a){
	 	if(a.checked==true){
		 		a.value=1;
			 }else{
			 	a.value=0;
		  	}
 	}
 
	var api = frameElement.api, W = api.opener;
 
  $(document).ready(function(){
       $("#payDate ").val(new Date().format('yyyy-MM-dd'));
  }); 	
		
	function do_submit(){
	    var pay = $("#curPayFee").val();
	    var remain = $("#remainingFee").val();
	    if(Number(pay)>Number(remain)){
	    	alert("支付金额不能多于剩余应付款！");
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
				url:ctutil.bp()+"/loan/loanEval!doPayCarOwner.action",
				data:data,
				async: false,
				error: function() {
				  html = "数据请求失败";
				},
				success: function(data) {
				  if(data=="success"){
					  alert("保存成功！");
					  api.get("payOwner",1).close();
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
                          收购价格：
        </td>
        <td width="400px">
          <input class="input w200" id="trade.acquPrice" name="acquPrice"  style="background-color:#F0F0F0"  readonly="readonly" value='${acquPrice}' onchange="if(isNaN(this.value)){alert('请输入合法数字!');this.value='';$('#financingMax').focus();}"/>万
        </td>
      </tr> 
      <tr>
        <td class="text-r" width="100px">
                          融资金额：
        </td>
        <td width="400px">
          <input class="input w200" id="financingFee" name="financingFee"    style="background-color:#F0F0F0"   readonly="readonly"  value='${financingFee}'  onchange="if(isNaN(this.value)){alert('请输入合法数字!');this.value='';$('#financingFee').focus();}"/>万
        </td>
      </tr>       
      <tr>
        <td class="text-r" width="100px">
                          预收金额：
        </td>
        <td width="400px">
          <input class="input w200" id="prepareFee" name="prepareFee"    style="background-color:#F0F0F0"   readonly="readonly"  value='${prepareFee}'  />万
        </td>
      </tr>       
      <tr>
        <td class="text-r" width="100px">
                          已付收购款：
        </td>
        <td width="400px">
          <input class="input w200" id="payedOwnerFee" name="payedOwnerFee"  style="background-color:#F0F0F0"  readonly="readonly"  value='${payedOwnerFee}'    />万
        </td>
      </tr> 
      <tr>
        <td class="text-r" width="100px">
                           剩余应付款：
        </td>
        <td width="400px">
          <input class="input w200" id="remainingFee" name="remainingFee"  style="background-color:#F0F0F0"  readonly="readonly"  value='${acquPrice-payedOwnerFee}' />万 
        </td>
      </tr>        
      <tr>
        <td class="text-r" width="100px">
                           本次付款：
        </td>
        <td width="400px">
          <input class="input w200" id="curPayFee" name="curPayFee" value='${acquPrice-payedOwnerFee}'    />万
        </td>
      </tr> 
      <tr>
        <td class="text-r" width="100px">
        </td>
        <td width="400px">
          <input name="financing.payOverTag"  type="checkbox" value="0" onclick="checkValue(this);" />全部付完
        </td>
      </tr> 

                          
	  <tr>
				<td class="text-r" width="100px" >
				     付款人：
				</td>
				<td width="400px">
					<select id="payOwnerHis.staff.id" class="input w200" name="payOwnerHis.staff.id">
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
            <input style="width:200px;height:25px;"  type="text"  id="payDate" name="payOwnerHis.payDate"  onclick="WdatePicker()" />
          </td>
      </tr>
      <tr style="width:200px;height:90px;">
          <td class="text-r" width="200px;" valign="top" style="padding-top:10">付款说明: &nbsp;&nbsp;&nbsp;</td>       
          <td>
          <textarea name="payOwnerHis.payDesc" id="payOwnerHis.payDesc" style="width:200px;height:80px;"></textarea>
          </td>
      </tr> 
	</table>
	
	
	<table style="margin:auto; width:95%;margin-top:15px;" border='0'>
			<tr >
				<td> 
				付款历史: 
				</td>
			</tr>
	</table>
		<table style="margin:auto; width:95%;margin-top:15px;" border='1' name="contractAreas" id="contractAreas">
			<tr style="width:500px;">
				<td style="text-align:center;text-valign:center;width:50px;height:35px;"><font size="10px">付款人</font></td>
				<td style="text-align:center;text-valign:center;width:50px;height:35px;"><font size="10px">付款日期</font></td>
				<td style="text-align:center;text-valign:center;width:50px;height:35px;"><font size="10px">付款金额</font></td>
				<td style="text-align:center;text-valign:center;width:50px;height:35px;"><font size="10px">付款说明</font></td>
			</tr>
		  <c:if test="${empty payOwnerHises}">
					<tr align="center">
						<td bgcolor="#ffffff">
							&nbsp;
						</td>
						<td bgcolor="#ffffff">
							&nbsp;
						</td>
						<td bgcolor="#ffffff">
							&nbsp;
						</td>
						<td bgcolor="#ffffff">
							&nbsp;
						</td>
					</tr>
			</c:if>
			<c:if test="${not empty payOwnerHises}">
				<c:forEach items="${payOwnerHises}" var="op">
					<tr align="center">

						<td bgcolor="#ffffff">
							${op.staff.name}
						</td>
						<td bgcolor="#ffffff">
							<fmt:formatDate value="${op.payDate}"
								pattern="yyyy-MM-dd " />
						</td>

						<td bgcolor="#ffffff">
							${op.payFee}元
						</td>
						<td bgcolor="#ffffff" width="175px">
							${op.payDesc}
						</td>
					</tr>
				</c:forEach>

			</c:if>			 
		</table>	
		
		
	</div>
</form>
</body>
</html>
