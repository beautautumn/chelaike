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
  		var api = frameElement.api, W = api.opener;
  	 function print(){
  		 var totalDepositFee1=$("#totalDepositFee1").val();//剩余押金
  		 var totalFees1 = $("#totalFees1").val();//应收款
  			var checked = $("#checkbox");
  			if(checked.attr('checked')){
  				//押金大于应收款
  				if(Number(totalDepositFee1)>=Number(totalFees1)){
  					$("#totalFees").val(0);
  					$("#totalDepositFee").val(Number(totalDepositFee1)-Number(totalFees1));
  				}else{
  					$("#totalFees").val(Number(totalFees1)-Number(totalDepositFee1));
  					$("#totalDepositFee").val(0);
  				}
  			}else{
  				$("#totalFees").val(totalFees1);
  				$("#totalDepositFee").val(totalDepositFee1);
  			}
  	 }
     function do_submit(){
      var recvFee = $("#recvFee").val();//实收款
      var totalFees = $("#totalFees").val();//应收款
      var agencyId =$("#agencyId").val();
      var AgencyBillsId=$("#AgencyBillsId").val();
      var totalDepositFee=$("#totalDepositFee").val();//剩余押金
      if(recvFee==""){
        alert("请填写实收款");
        return;
      }
       var recvTime=$("#recvTime").val();
       if(recvTime==''){
        alert("请选择计费日期");
       return;
      }
      var staffId=$("#staffId").val();
        data+=staffId+",";
      var remark=$("#remark").val();
      if(remark.length>200){
        alert("费用备注不能超过200字，请重新填写");
        return;
      }
      var data="AgencyBillsId="+AgencyBillsId+"&recvTime="+recvTime+"&staffId="+staffId+"&remark="+remark+"&recvFee="+recvFee;
       /* if(document.getElementById("checkbox").checked){
 		var sum=Number(totalDepositFee)+Number(recvFee);
        if(sum>=Number(totalFees)){
        	data+="&deduction=true";
        }else{
        	alert("实收款应大于等于应收款,请重新填写实收款");
        	return;
        }
		}else{ */
		if(Number(recvFee)>=Number(totalFees)){
			data+="&deduction=false";
		}else{
			alert("实收款应大于等于应收款,请重新填写实收款");
			return;
		}
		/* } */
      $.ajax({    
              type:'post',        
              url:'${ctx}/rent/agencyDetailBillsAction!CollectFees.action',    
              data:data,   
              cache:false,    
              async : false, //默认为true 异步     
              success:function(data){
                    if(data=="success"){
                    alert("收费成功");  
                    api.get('collectFess',1).close();
                  	W.query1(); 
                    }else{
                    alert("收费失败");
                    api.get('collectFess',1).close();
                    }      
              }    
          });  
     }
  </script>
  <body>
  	<form id="">
  		<td ><input type="hidden" name="agencyId" id="agencyId" value="${agencyId}" /><input type="hidden" name="AgencyBillsId" id="AgencyBillsId" value="${AgencyBillsId}"/></td>
  		<div style="text-align:center;margin-top:10px;">
  	    <table >
          <tr style="width:500px;height:35px;">
            <td class="text-r" width="200px;">应收款(元):&nbsp;&nbsp;&nbsp;</td>
            <td width="250px;">
            <input style="width:180px;height:25px;background-color:#F0F0F0;" type="text" readonly="readonly" id="totalFees" name="totalFees"  value="${totalFees}" />
            </td>
            <input type="hidden" value="${totalFees}" id="totalFees1">
            <td width="150px;"></td><td width="220px;"></td>
          </tr>
          <%-- <tr style="width:500px;height:35px;">
            <td class="text-r" width="200px;">剩余押金(元):&nbsp;&nbsp;&nbsp;</td>
            <td width="250px;">
            <input style="width:180px;height:25px;background-color:#F0F0F0;" type="text" readonly="readonly" id="totalDepositFee" name="totalDepositFee"  value="${totalDepositFee}" />
            </td>
            <input  value="${totalDepositFee}" type="hidden"  id="totalDepositFee1">
            <td width="150px;"></td><td width="220px;"></td>
          </tr> --%>
          <tr style="width:500px;height:35px;">
            <td class="text-r" width="200px;">实收款(元):<span class="red">*</span>&nbsp;&nbsp;&nbsp;</td>
            <td width="250px;"><input style="width:180px;height:25px;" type="text"  id="recvFee" name="recvFee"  onkeyup="value=value.replace(/[^(\d||/.)]/g,'')" />
            	&nbsp;&nbsp;&nbsp;
            <%-- <input id="checkbox" type="checkbox" value="${agency.state}" <s:if test="agency.state==104||agency.state==105">onclick="print();"</s:if><s:else>onclick="return false;"</s:else> >&nbsp;是否抵扣押金 --%>
<%--            <s:if test="agency.state==104||agency.state==105"><input id="checkbox" type="checkbox" onclick="print();">&nbsp;是否抵扣押金</s:if>--%>
            </td>
            <td width="150px;"></td><td width="220px;"></td>
          </tr>
          <tr style="width:500px;height:35px;">
            <td class="text-r" width="200px;">收款日期:<span class="red">*</span>&nbsp;&nbsp;&nbsp;</td><td width="250px;"><input style="width:180px;height:25px;"  type="text"  id="recvTime" name="recvTime"  onclick="WdatePicker()" onblur="setEndDate();" value="${date}"/></td>
            <td width="150px;"></td><td width="220px;"></td>
          </tr>
  		  <tr style="width:500px;height:35px;">
  			 <td class="text-r" width="200px;">计费人:&nbsp;&nbsp;&nbsp;</td>
  			 <td width="250px;">
  					<select id="staffId"  name="staffId"  style="width:180px;height:25px;" value="${staffId}">
							<s:iterator value="staffs">
								<option <s:if test="staffId==id">selected</s:if> value="<s:property value="id"/>"><s:property value="name"/></option>
							</s:iterator>
					</select>
  			 </td>
  		   </tr>
  		   <tr style="width:600px;height:90px;">
  				<td class="text-r" width="350px;" valign="top" style="padding-top:10">费用备注:&nbsp;&nbsp;&nbsp;</td>				
  				<td class="text-r" width="400px;">
				<textarea name="remark" id="remark" style="width:400px;height:80px;"></textarea>
  				</td>
  		   </tr>
  	 	</table>
  		</div>
  	</form>
  </body>
</html>