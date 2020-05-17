<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@taglib uri="/struts-tags" prefix="s"%>
<%@ include file="/common/taglibs.jsp"%>
<%@ include file="/common/meta.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>合同修改</title>
<link rel="stylesheet" type="text/css" href="${ctx}/css/style.css" />
<script type="text/javascript" src="${ctx}/js/common/syUtil.js"></script>
<script type="text/javascript" src="${ctx}/js/common/ctutil.js"></script>
<script type="text/javascript" src="${ctx}/js/common/menu.js"></script>
<script type="text/javascript" src="${ctx}/js/plugins/My97DatePicker/WdatePicker.js"></script>

<script>
	var regFloat=/^[0-9]+(\.[0-9]+)?$/; 
	Date.prototype.format =function(format){
		var o = {
		"M+" : this.getMonth()+1, //month
		"d+" : this.getDate(), //day
		"h+" : this.getHours(), //hour
		"m+" : this.getMinutes(), //minute
		"s+" : this.getSeconds(), //second
		"q+" : Math.floor((this.getMonth()+3)/3), //quarter
		"S" : this.getMilliseconds() //millisecond
		}
		if(/(y+)/.test(format)) format=format.replace(RegExp.$1,
		(this.getFullYear()+"").substr(4- RegExp.$1.length));
		for(var k in o)if(new RegExp("("+ k +")").test(format))
		format = format.replace(RegExp.$1,
		RegExp.$1.length==1? o[k] :
		("00"+ o[k]).substr((""+ o[k]).length));
		return format;
	}
	
	var api = frameElement.api, W = api.opener;
	$(function(){
		$("#signDate").val(new Date().format('yyyy-MM-dd'));
		$("#startDate").val('${contract.startDate}'.substring(0,10));
		$("#endDate").val('${contract.endDate}'.substring(0,10));
		
		$("#recvCycle option").each(function(){
  			if($(this).val()=='${contract.recvCycle}'){
  				$(this).attr('selected',true);
  			}
  		});
		
		getRecvCycle();
  	
  	});
  	
  	function getRecvCycle(){
  		$("#recvCycle option").each(function(){
			var monthTotalFeeAll=0.00;
			if($(this).attr('selected')=='selected'){
				if($(this).val()=='-1'){
					$("#everyRecvFee").val('');
				}else if($(this).val()=='0'){
					if($("#contractAreas tr").length>1){
						for(var i=1;i<$("#contractAreas tr").length;i++){
							
							monthTotalFeeAll+=parseFloat(parseFloat($("#contractAreas tr:eq("+i+") td:eq("+3+")").attr('monthtotalfee')).toFixed(2));
						}
					}
					$("#everyRecvFee").val(parseFloat(monthTotalFeeAll*3).toFixed(2));
					$("#depositFee").val(parseFloat(monthTotalFeeAll).toFixed(2));					
				}else if($(this).val()=='1'){
					if($("#contractAreas tr").length>1){
						for(var i=1;i<$("#contractAreas tr").length;i++){
							monthTotalFeeAll+=parseFloat(parseFloat($("#contractAreas tr:eq("+i+") td:eq("+3+")").attr('monthtotalfee')).toFixed(2));
						}
					}
					$("#everyRecvFee").val(parseFloat(monthTotalFeeAll*6).toFixed(2));
					$("#depositFee").val(parseFloat(monthTotalFeeAll).toFixed(2));	
				}else if ($(this).val()=='2'){
					if($("#contractAreas tr").length>1){
						for(var i=1;i<$("#contractAreas tr").length;i++){
							monthTotalFeeAll+=parseFloat(parseFloat($("#contractAreas tr:eq("+i+") td:eq("+3+")").attr('monthtotalfee')).toFixed(2));
						}
					}
				
					$("#everyRecvFee").val(parseFloat(monthTotalFeeAll*12).toFixed(2));
					$("#depositFee").val(parseFloat(monthTotalFeeAll).toFixed(2));	
				}
			
			}
  		});
  	
  	}

	var areaNoAll="";
	function openSiteArea(){
		if($("#contractAreas tr").length>1){
				for(var i=1;i<$("#contractAreas tr").length;i++){
					if(i==$("#contractAreas tr").length-1){
						areaNoAll+=$("#contractAreas tr:eq("+i+") td:eq("+4+")").attr('areano')+",";
					}
					
				}
		}
		menu.create_child_dialog_identy(api,W,'getChangeSitePage','选择场地区域',
    		'/rent/contractListAction!toChangeSelectSiteArea.action?areaNoAll='+areaNoAll,
    		400,350,true);
    }
    function doGetSitePage(date){
    	var result=date.split(";");
		var areaName=result[0];
		var rentType=(result[1]=='0')?('按面积'):('按单位');
		var totalCount=result[2];
		var monthRentFee=result[3];
		var leaseCount=result[4];
		var monthTotalFee=result[5];
		var areaNo=result[6];
		var carCount=result[7];
		var id=result[8];
		$("#contractAreas").append(
		"<tr align='center'>"+
			"<td style='text-align:center;text-valign:center;width:50px;height:35px;' monthrentfee = '"+monthRentFee+"' id = '"+id+"' areaname='"+areaName+"' >"+areaName+"</td>"+
			"<td style='text-align:center;text-valign:center;width:50px;height:35px;' renttype = '"+result[1]+"' >"+rentType+"</td>"+
			"<td style='text-align:center;text-valign:center;width:50px;height:35px;' leasecount = '"+leaseCount+"' >"+leaseCount+"</td>"+
			"<td style='text-align:center;text-valign:center;width:50px;height:35px;' monthtotalfee = '"+monthTotalFee+"' >"+monthTotalFee+"</td>"+
			"<td style='text-align:center;text-valign:center;width:50px;height:35px;' areano = '"+areaNo+"' >"+areaNo+"</td>"+
			"<td style='text-align:center;text-valign:center;width:50px;height:35px;' carcount = '"+carCount+"' >"+carCount+"</td>"+
			"<td style='text-align:center;text-valign:center;width:50px;height:35px;' ><a onclick='deleteCurrentRow(this);'>删除</a></td>"+	
		"</tr>"
		);
		getMonthTotalFeeAll();
    }
    
    function getMonthTotalFeeAll(){
    	var all=0.00;
		if($("#recvCycle option:selected").val()=='-1'){
			if($("#contractAreas tr").length>1){
				for(var i=1;i<$("#contractAreas tr").length;i++){
					all+=parseFloat(parseFloat($("#contractAreas tr:eq("+i+") td:eq("+3+")").attr('monthtotalfee')).toFixed(2));
				}
			}
			$("#depositFee").val(all);
			$("#everyRecvFee").val('');
		}else if($("#recvCycle option:selected").val()=='0'){
			if($("#contractAreas tr").length>1){
				for(var i=1;i<$("#contractAreas tr").length;i++){
					all+=parseFloat(parseFloat($("#contractAreas tr:eq("+i+") td:eq("+3+")").attr('monthtotalfee')).toFixed(2));
				}
			}
			$("#depositFee").val(all);
			$("#everyRecvFee").val(parseFloat(all*3).toFixed(2));				
		}else if($("#recvCycle option:selected").val()=='1'){
			if($("#contractAreas tr").length>1){
				for(var i=1;i<$("#contractAreas tr").length;i++){
					all+=parseFloat(parseFloat($("#contractAreas tr:eq("+i+") td:eq("+3+")").attr('monthtotalfee')).toFixed(2));
				}
			}
			$("#depositFee").val(all);
			$("#everyRecvFee").val(parseFloat(all*6).toFixed(2));
		}else if ($("#recvCycle option:selected").val()=='2'){
			if($("#contractAreas tr").length>1){
				for(var i=1;i<$("#contractAreas tr").length;i++){
					all+=parseFloat(parseFloat($("#contractAreas tr:eq("+i+") td:eq("+3+")").attr('monthtotalfee')).toFixed(2));
				}
			}
			$("#depositFee").val(all);
			$("#everyRecvFee").val(parseFloat(all*12).toFixed(2));
		}
		
    
    }
    
    function setEndDate(){
    	if(!$("#startDate").val()==''){
    		var d=$("#startDate").val();
    		d=d.replace(/-/g, '/');
    		var now=new Date(d);
			var time=now.getTime();
			time+=1000*60*60*24*365;
			now.setTime(time);
			$("#endDate").val(now.getFullYear()+"-"+(now.getMonth()+1)+"-"+now.getDate());
		}
	}
	function checkDepositFee(){
		if($("#depositFee").val()==''||$("#depositFee").val()=='0.00'){
			alert("请输入保证金！");
			return;
		}else{
			if(!regFloat.test($("#depositFee").val())){
	            alert("保证金必须是正整数或者小数，请重新输入");
	            return ;
	        }
		}
	}

    
    
	function deleteCurrentRow(obj){ 
		if(confirm("是否删除此条记录？")==true){
  			var tr=obj.parentNode.parentNode; 
			var tbody=tr.parentNode; 
			tbody.removeChild(tr); 
			getMonthTotalFeeAll();
  		}else{
  			return;
  		}
		
	} 
	
	function do_submit(){
		if($("#startDate").val()==''){
			alert("请输入合同起始日！");
			return;
		}
		if($("#endDate").val()==''){
			alert("请输入合同终止日！");
			return;
		}
		if($("#startDate").val() >= $("#endDate").val()){
            alert('合同起始日不能晚于合同终止日！');           
            return ;
        }
		if($("#recvCycle").val()=='-1'){
			alert("请选择合同收款周期！");
			return;
		}
		if($("#everyRecvFee").val()==''||$("#everyRecvFee").val()=='0.00'){
			alert("请输入每次收款金额！");
			return;
		}
		if($("#depositFee").val()==''||$("#depositFee").val()=='0.00'){
			alert("请输入保证金！");
			return;
		}else{
			if(!regFloat.test($("#depositFee").val())){
	            alert("保证金必须是正整数或者小数，请重新输入");
	            return ;
	        }
		}
		if($("#signDate").val()==''){
			alert("请输入合同签订日！");
			return;
		}
		if($("#marketSignName").val()==''){
			alert("请输入市场签署人！");
			return;
		}
		if($("#agencySignName").val()==''){
			alert("请输入商户签署人！");
			return;
		}
		if($("#remark").val().length>255){
			alert("合同其他说明过长！");
			return;
		}
		var index=0;
		for(var i=1;i<$("#contractAreas tr").length;i++){
		
			
			html1 = "<input type='hidden' name='contractAreas["+index+"].siteArea.id' value='"+parseInt($("#contractAreas tr:eq("+i+") td:eq("+0+")").attr('id'))+"'/>";

			html2 = "<input type='hidden' name='contractAreas["+index+"].leaseCount' value='"+$("#contractAreas tr:eq("+i+") td:eq("+2+")").attr('leasecount')+"'/>";

			html3 = "<input type='hidden' name='contractAreas["+index+"].monthRentFee' value='"+parseInt(parseFloat($("#contractAreas tr:eq("+i+") td:eq("+0+")").attr('monthrentfee'))*100)+"'/>";

			html4 = "<input type='hidden' name='contractAreas["+index+"].monthTotalFee' value='"+parseInt(parseFloat($("#contractAreas tr:eq("+i+") td:eq("+3+")").attr('monthtotalfee'))*100)*+"'/>";

			html5 = "<input type='hidden' name='contractAreas["+index+"].areaNo' value='"+$("#contractAreas tr:eq("+i+") td:eq("+4+")").attr('areaNo')+"'/>";

			html6 = "<input type='hidden' name='contractAreas["+index+"].carCount' value='"+$("#contractAreas tr:eq("+i+") td:eq("+5+")").attr('carCount')+"'/>";
			
			$("#contractAreas").append(html1);
			$("#contractAreas").append(html2);
			$("#contractAreas").append(html3);
			$("#contractAreas").append(html4);
			$("#contractAreas").append(html5);
			$("#contractAreas").append(html6);
			index++;
		
		}
		var data = "";
		data = $("#myForm").serialize();

		$.ajax({
				cache: false,
				type: "POST",
				url:ctutil.bp()+"/rent/contractListAction!changeContract.action",
				data:data,
				async: false,
				error: function() {
				html = "数据请求失败";
				},
				success: function(data) {
				  if(data=="success"){
					  alert("保存成功！");
					  api.get("changeContractPage", 1).close();
					  W.query1();  //刷新副页面
				  }else{
					  alert("保存失败！");
					  api.get("changeContractPage", 1).close();
				  }
				}
			});
		
		
	}

</script>
</head>
<body>
<form id="myForm"> 
	<input type="hidden" class="input w200" id="contractId" name="contractId" value="${contractId}"/>
			
	<div  width="100">
			</div>	
	<div  style="text-align:center;">
		<table style="margin:auto; width:95%;margin-top:15px;" border='0'>
			<tr >
				<td>
				场地区域列表:
				<input type="button" style="width:90px;" onclick="javascript:openSiteArea();"  value="添加" />
				</td>
			</tr>
		</table>
		<table style="margin:auto; width:95%;margin-top:15px;" border='1' name="contractAreas" id="contractAreas">
			<tr style="width:500px;">
				<td style="text-align:center;text-valign:center;width:50px;height:35px;"><font size="10px">区域名称</font></td>
				<td style="text-align:center;text-valign:center;width:50px;height:35px;"><font size="10px">类型</font></td>
				<td style="text-align:center;text-valign:center;width:50px;height:35px;"><font size="10px">租用面积/单位</font></td>
				<td style="text-align:center;text-valign:center;width:50px;height:35px;"><font size="10px">月租金(元)</font></td>
				<td style="text-align:center;text-valign:center;width:50px;height:35px;"><font size="10px">场地编号</font></td>
				<td style="text-align:center;text-valign:center;width:50px;height:35px;"><font size="10px">车位数</font></td>
				<td style="text-align:center;text-valign:center;width:50px;height:35px;"><font size="10px">操作</font></td>
			</tr>
			<s:iterator value="contractAreas">
				<tr style="width:500px;">
					<td style="text-align:center;text-valign:center;width:50px;height:35px;" monthrentfee = '${monthRentFee}' id = '${siteArea.id}' areaname='${siteArea.areaName}' >${siteArea.areaName}</td>
					<s:if test="siteArea.rentType==0">
						<td style="text-align:center;text-valign:center;width:50px;height:35px;" renttype = '${siteArea.rentType}' >按面积</td>
					</s:if>
					<s:else>
						<td style="text-align:center;text-valign:center;width:50px;height:35px;" renttype = '${siteArea.rentType}' >按单位</td>
					</s:else>
					<td style="text-align:center;text-valign:center;width:50px;height:35px;" leasecount = '${leaseCount}' >${leaseCount}</td>
					<td style="text-align:center;text-valign:center;width:50px;height:35px;" monthtotalfee = '${monthTotalFee/100}' >${monthTotalFee/100}</td>
					<td style="text-align:center;text-valign:center;width:50px;height:35px;" areano = '${areaNo}' >${areaNo}</td>
					<td style="text-align:center;text-valign:center;width:50px;height:35px;" carcount = '${carCount}' >${carCount}</td>
					<td style="text-align:center;text-valign:center;width:50px;height:35px;" ><a onclick='deleteCurrentRow(this);' >删除</a></td>
				</tr>
			
			</s:iterator>
		</table>
		<br/>
		<div style="text-align:center;margin-top:20px;margin-left:60px;">
  			<table id="contract" name="contract">
  				<tr style="width:500px;">
  					<td class="text-r" width="90px;">合同起始日：<span class="red">*</span></td>
  					<td width="160px;">
  						<input type="text"  id="startDate" name="contractBean.startDate"  value="${contract.startDate }" style="background-color:#F0F0F0"  readonly="readonly" />
  					</td>
  					<td class="text-r" style="width:90px;" >合同终止日：<span class="red">*</span></td>
  					<td class="text-l" width="160px;">
  						<input type="text"  id="endDate" name="contractBean.endDate"  value="${contract.endDate }" style="background-color:#F0F0F0"  readonly="readonly" />
  					</td>
  				</tr>
  				<tr style="width:500px;">
  					<td class="text-r" width="100px;">&nbsp;</td>
  				</tr>
  				<tr style="width:500px;">
  					<td class="text-r" width="90px;">合同收款周期：<span class="red">*</span></td>
  					<td width="160px;">
  						<select class="input w100"  id="recvCycle" name="contractBean.recvCycle" onchange="getRecvCycle()">
			   				<option value="-1">请选择</option>
                			<option value="0">季度</option>
                 			<option value="1">半年</option>
                   			<option value="2">一年</option>
                   		</select>
  					</td>
  					<td class="text-r" style="width:100px;" >每次收款金额：<span class="red">*</span></td>
  					<td class="text-l" width="150px;">
  						<input type="text"  id="everyRecvFee" name="contractBean.everyRecvFee" value="${contract.everyRecvFee/100}" style="background-color:#F0F0F0"  readonly="readonly"  />&nbsp;元
  					</td>
  				</tr>
  				<tr style="width:500px;">
  					<td class="text-r" width="100px;">&nbsp;</td>
  				</tr>
  				<tr style="width:500px;">
  					<td class="text-r" width="100px;">保证金：<span class="red">*</span></td>
  					<td width="150px;">
  						<input type="text" id="depositFee" name="contractBean.depositFee" value="${contract.depositFee/100}" onblur="checkDepositFee();" />&nbsp;元<br />
  					</td>
  					<td class="text-r" style="width:90px;" >合同签订日：<span class="red">*</span>	</td>
  					<td class="text-l" width="160px;">
  						<input type="text"  id="signDate" name="contractBean.signDate"  value="${contract.signDate }"  style="background-color:#F0F0F0"  readonly="readonly"  />
  					</td>
  				</tr>
  				<tr style="width:500px;">
  					<td class="text-r" width="100px;">&nbsp;</td>
  				</tr>
  				<tr style="width:500px;">
  					<td class="text-r" width="100px;">市场签署人：<span class="red">*</span></td>
  					<td width="150px;">
  						<input type="text"  id="marketSignName" name="contractBean.marketSignName" value="${contract.marketSignName }" />
  					</td>
  					<td class="text-r" style="width:100px;" >商户签署人: <span class="red">*</span></td>
  					<td class="text-l" width="150px;">
  						<input type="text"  id="agencySignName" name="contractBean.agencySignName" value="${contract.agencySignName }"/>
  					</td>
  				</tr>
  				
  			</table>
  		</div>
  		<div style="text-align:center;margin-left:60px;">
  			<table>
  				<tr style="width:500px;height:120px;">
  					<td class="text-r" width="100px;">合同其他说明：
  					</td>
  					<td class="text-r" >
						<textarea name="contractBean.remark" id="remark" style="width:380px" height="100px">${contract.remark}</textarea>
  					</td>
  				</tr>
  			</table>
  		</div>
			
</div>		
</form>					
</body>
</html>
