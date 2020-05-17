<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@taglib uri="/struts-tags" prefix="s"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ include file="/common/taglibs.jsp"%>
<%@ include file="/common/meta.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>物业总费分摊</title>
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
<script type="text/javascript" src="${ctx}/js/plugins/My97DatePicker/WdatePicker.js"></script>
<script>
	var contractAreaId = new Array();
	var api = frameElement.api, W = api.opener;
  		//打开子页面
  		//单个添加
		function openAdd(){
			menu.create_child_dialog_identy(api,W,'agencyBillsAdd','新增分摊记录',
	    	'/rent/agencyBillsAction!toAgencyBillsAdd.action',
	    	500,250,true);
    	}
  		//批量添加
		function openBatchAdd(){
			menu.create_child_dialog_identy(api,W,'agencyBillsBatchAdd','批量添加',
	    	'/rent/agencyBillsAction!toAgencyBillsBatchAdd.action',
	    	390,120,true);
    	}
  		
  		function insertByAdd(data){
  			data=eval(data);
  			if(data.length<1){
  				alert("无在场商户！");
  			}
  			for(var i=0;i<data.length;i++){
  				if(contractAreaId[(data[i].contractAreaId)]=='true'){
  					alert("您已添加了商户场地:"+data[i].agencyName+"-"+data[i].contractArea+" ！");
  					continue;
  				}
  				contractAreaId[(data[i].contractAreaId)]='true';
  				var element="<tr style='border:1px solid #000;'>"+
  							"<td style='display:none'>"+data[i].contractAreaId+"</td>" +
							"<td style='display:none'>"+data[i].areaId+"</td>" +
							"<td style='display:none'>"+data[i].agencyId+"</td>" +
							"<td width='50px'>"+data[i].agencyName+"</td>" +
							"<td width='65px'>"+data[i].contractArea+"</td>" +
							"<td width='150px'>"+data[i].date+"</td>" +
							"<td width='120px'><input type='text' style='height:25px;width:120px' value='"+data[i].feeValue+"'/></td>" +
							"<td width='130px'><input type='text' width='120px' style='height:25px'/></td>" +
							"<td><a onclick='del(this,"+data[i].contractAreaId+")'>删除</a></td>" +
							"</tr>";
				$("#agencytable").append(element);
				if(data[i].remark!=''){
					var reg=new RegExp("%27","g");
					var reg2=new RegExp("%28","g");
	  				var remark=data[i].remark.replace(reg,"'");
	  				remark=remark.replace(reg2,'"');
	  				$("#agencytable").find("tr").last().find("td").eq(7).find("input").eq(0).val(remark);
				}
  			}
  		}
  		function del(obj,Id){
  			if(confirm("是否删除此条记录？")==true){
  				var tr=obj.parentNode.parentNode;
	  			var table=tr.parentNode;
	  			table.removeChild(tr);
	  			contractAreaId[Id]='false';
  			}else{
  				return;
  			}
  		}
  		function checkFrom(){
  			if($("#staffId").val()=='0'){
  				alert("请选择分摊人！");
  				return 'false';
  			}
  			if($("#operTime").val()==''){
  				alert("请选择分摊时间！");
  				return 'false';
  			}
  			var sumData=0;
  			$("#agencytable tr").each(function(){
					 sumData+=Number($(this).find("td").eq(6).find("input").eq(0).val());	  				
	  			});
  			if(sumData-$("#totalFee").val()!=0){
  				alert("分摊金额不等于费用总金额！");
  				return 'false';
  			}
  		}
  		function do_submit(){
  			if(checkFrom()){
  				return;
  			}
  			var str = catchData();
  			
  			if(str==''){
  				alert("请添加需要分摊的商户！");
  				return;
  			}
			$.ajax({
				cache: false,
				type: "POST",
				url:ctutil.bp()+"/rent/agencyBillsAction!doAgencyBills.action",
				data:"jsonStr="+str,
				async: false,
				error: function() {
				alert("发送请求失败！");
				},
				success: function(data) {
					if(data=="success"){
						alert("分摊成功！");
						api.get("managerFee",1).close();
						W.query1();
					}else{
						alert("分摊失败！");
						api.get("managerFee",1).close();
					}
				}
			});
  		}
  		
  		function catchData(){
  			var data=new Array();
  			var i=0;
  			$("#agencytable tr").each(function(){
  				data[i]=new Array();
  				data[i][0] = $(this).find("td").eq(1).html();//区域id
  				data[i][1] = $(this).find("td").eq(2).html();//商户id
				data[i][2] = $("#managerFeeId").val();		 //物业总费用id
				data[i][3] = $("#staffId").val();			 //分摊人id
				data[i][4] = $(this).find("td").eq(6).find("input").eq(0).val();//分摊金额
				data[i][5] = $(this).find("td").eq(7).find("input").eq(0).val();//分摊备注
				data[i][6] = $("#operTime").val();//分摊时间
				data[i][7] = $("#feeItemId").val();//费用科目Id
				data[i][8] = $(this).find("td").eq(0).html();//签署区域
				i++;
  			});
  			if(i==0){
  				return '';
  			}else{
  				return JSON.stringify(data);
  			}
  		}
  		
  		function autoAlign(){
  			var totalFee=$("#totalFee").val();
  			var i=0;
  			$("#agencytable tr").each(function(){
				i++;
  			});
  			if(i>0){
	  			var share=(totalFee/i).toFixed(2);
	  			$("#agencytable tr").each(function(){
					 $(this).find("td").eq(6).find("input").eq(0).val(share);	  				
	  			});
  			}
  		}
  		function sameItemAdd(managerFeeId){
  			$.ajax({
				cache: false,
				type: "POST",
				url:ctutil.bp()+"/rent/agencyBillsAction!sameItemAdd.action",
				data:"managerFeeId="+managerFeeId,
				async: false,
				error: function() {
				alert("发送请求失败！");
				},
				success: function(data) {
					if(data=='error'){
						alert("批量复制失败！");
						return;
					}else if(data=='null'){
						alert("上月没有分摊记录，请手动分摊！");
						return;
					}else{
						insertByAdd(data);
					}
				}
			});
  		}
</script>

</head>
<body  style=" text-align:center">
<form id="myForm">	
<div class="box">
		<table>
			<tr>
				<td></td>
				<td>
					<table>	
						<tr>
							<input type="text" id="managerFeeId" style="display: none" value="${managerFee.id}"/>
							<input type="text" id="feeItemId" style="display:none" value="${managerFee.feeItem.id}"/>
							<td class="text-r" width="120">物业总费用名称：</td>
							<td><input class="input w200" type="text" value="${managerFee.feeItem.itemName}" style="background-color:#F0F0F0" readonly="readonly"/></td>
							<td class="text-r" width="120">费用总金额：</td>
							<td><input id="totalFee" class="input w200" type="text" value="${managerFeeBean.totalFee}" style="background-color:#F0F0F0" readonly="readonly"/>元</td>
						</tr>
						<tr>
							<td class="text-r" width="120">费用发生开始日期：</td>
							<td><input class="input w200" type="text" value="${managerFeeBean.beginDate}" style="background-color:#F0F0F0" readonly="readonly"/></td>
							<td class="text-r" width="120">费用发生结束日期：</td>
							<td><input class="input w200" type="text" value="${managerFeeBean.endDate}" style="background-color:#F0F0F0" readonly="readonly"/></td>
						</tr>
						<tr>
							<td class="text-r" width="120">分摊日期：</td>
							<td><input id="operTime" class="input w200" type="text" value="${managerFeeBean.operTime}" onClick="WdatePicker()"/></td>
							<td class="text-r" width="120">分摊人：</td>
							<td>
								<select id="staffId" class="input w200" name="recvFeeBean.staffId">
										<option value='0'>请选择</option>
									<s:iterator value="staffs">
										<option <s:if test="id==staff.id">selected=" selected"</s:if>  value="<s:property value='id'/>"><s:property value="name"/></option>
									</s:iterator>
								</select>
							</td>
						</tr>
					</table>
				</td>
				<td></td>
			</tr>
			<tr>
				<td></td>
				<td>
					<table>
						<tr>
							<td width="100"><b>商户分摊：</b></td>
							<td align="center" width="400">
								<input type="button" value="新增分摊记录" onclick="openAdd()"/>
								<input type="button" value="按区域批量添加" onclick="openBatchAdd()"/>
								<input type="button" value="上月同科目批量复制" onclick="sameItemAdd(${managerFee.id})"/>
							</td>
							<td>
								<input type="button" value="按比例自动对齐" onclick="autoAlign()"/>
							</td>
						</tr>
					</table>	
				</td>
				<td></td>
			</tr>
			<tr>
				<td></td>
				<td>
					
				</td>
				<td></td>
			</tr>
		</table>
		<div style="margin:0 auto;border:1px solid #000;width:700px;height:325px">
				<div style="margin:0 auto;overflow:hidden;border:0px;width:700px;height:35px">
					<table border="1" style="width:680px">
							<tr border="1" align="center">
								<td width="50px" height="33px" align="center"><b>分摊商户</b></td>
								<td width="65px"><b>分摊区域</b></td>
								<td width="150px"><b>合同有效期</b></td>
								<td width="120px"><b>分摊数额</b></td>
								<td width="130px"><b>备注</b></td>
								<td><b>操作</b></td>
							</tr>
					</table>
				</div>	
				<div style="margin:0 auto;border:1px;overflow:scroll;width:700px;height:290px">
						<table id="agencytable" border="1" style="width:680px">
							<%--<tr border="1">
								<td width="80px">分摊商户</td>
								<td width="180px">2013-05-01至2014-05-01</td>
								<td width="140px">
									<input type="text"  class="input w100"/>
								</td>
								<td width="140px">
									<input type="text"  class="input w100"/>
								</td>
								<td>操作</td>
							</tr>
						--%></table>
						</div>
					</div>
		
					
	
			
	
</div>		
</form>					
</body>
</html>
