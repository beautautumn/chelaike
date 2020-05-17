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
     function do_submit(){  
     var data="";
      var agencyId =$("#agencyId").val();
      var endDate = $("#endDate").val();
      if(endDate==""){
        alert("请填写清算完成时间");
        return;
      }
      var staffId=$("#staffId").val();
        
      var clearingDesc=$("#clearingDesc").val();
      if(clearingDesc.length>200){
        alert("完成说明不能超过200字，请重新填写");
        return;
      }
      var data="agencyId="+agencyId+"&endDate="+endDate+"&staffId="+staffId+"&clearingDesc="+clearingDesc;
      $.ajax({    
              type:'post',        
              url:'${ctx}/rent/clearAgencyAction!clearAgency.action',    
              data:data,   
              cache:false,    
              async : false, //默认为true 异步     
              success:function(data){
                    if(data=="success"){
                    alert("清算商户成功");  
                    api.get('toClear',1).close();
                  	W.query1(); 
                    }else{
                    alert("清算商户失败");
                    api.get('toClear',1).close();
                    }      
              }    
          });  

     }
  </script>
  <body>
  	<form id="">
  		<td ><input type="hidden" name="agencyId" id="agencyId" value="${agencyId}" /></td>
  		<div style="text-align:center;margin-top:10px;">
  	    <table >
            <tr style="width:500px;height:35px;">
            <td class="text-r" width="200px;">清算开始日期:*&nbsp;&nbsp;&nbsp;</td><td width="250px;"><input style="background-color:#F0F0F0;width:180px;height:25px;" readonly="readonly" type="text"  id="clearStartDate" name="clearStartDate"  value="${clearStartDate}"/></td>
            <td width="150px;"></td><td width="220px;"></td>
          </tr>
          <tr style="width:500px;height:35px;">
            <td class="text-r" width="200px;">清算完成日期:*&nbsp;&nbsp;&nbsp;</td><td width="250px;"><input style="width:180px;height:25px;"  type="text"  id="endDate" name="endDate"  onclick="WdatePicker()" onblur="setEndDate();" value="${date}"/></td>
            <td width="150px;"></td><td width="220px;"></td>
          </tr>
  		  <tr style="width:500px;height:35px;">
  			 <td class="text-r" width="200px;">清算完成人:&nbsp;&nbsp;&nbsp;</td>
  			 <td width="250px;">
  					<select id="staffId"  name="staffId"  style="width:180px;height:25px;" value="${staffId}">
							<s:iterator value="staffs">
								<option <s:if test="staffId==id">selected</s:if> value="<s:property value="id"/>"><s:property value="name"/></option>
							</s:iterator>
					</select>
  			 </td>
  		   </tr>
  		   <tr style="width:600px;height:90px;">
  				<td class="text-r" width="350px;" valign="top" style="padding-top:10">完成说明:&nbsp;&nbsp;&nbsp;</td>				
  				<td class="text-r" width="400px;">
				<textarea name="clearingDesc" id="clearingDesc" style="width:400px;height:80px;"></textarea>
  				</td>
  		   </tr>
  	 	</table>
  		</div>
  	</form>
  </body>
</html>