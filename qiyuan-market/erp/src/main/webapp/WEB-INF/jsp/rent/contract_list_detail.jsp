<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@taglib uri="/struts-tags" prefix="s"%>
<%@ include file="/common/taglibs.jsp"%>
<%@ include file="/common/meta.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>合同详情</title>
<link rel="stylesheet" type="text/css" href="${ctx}/css/style.css" />
<script type="text/javascript" src="${ctx}/js/common/syUtil.js"></script>
<script type="text/javascript" src="${ctx}/js/common/ctutil.js"></script>
<script type="text/javascript" src="${ctx}/js/common/menu.js"></script>
<script type="text/javascript" src="${ctx}/js/plugins/My97DatePicker/WdatePicker.js"></script>
<script>
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
		$("#recvCycle option").each(function(){
  			if($(this).val()=='${contract.recvCycle}'){
  				$(this).attr('selected',true);
  			}
  		});
  		$("#recvCycle").attr("disabled", "disabled").css("background-color","F0F0F0");
  		
  		$("#startDate").val('${contract.startDate}'.substring(0,10));
  		
  		$("#endDate").val('${contract.endDate}'.substring(0,10));
  		
  		$("#signDate").val('${contract.signDate}'.substring(0,10));
  		
  		$("#backTime").val('${contract.backTime}'.substring(0,10));
  		
  		$("#everyRecvFee").val(parseFloat('${contract.everyRecvFee/100}').toFixed(2));
  		
  		$("#depositFee").val(parseFloat('${contract.depositFee/100}').toFixed(2));
  		
  		$("#monthTotalFee").val();
  		
  		
		
	});
    function showPic(){
        var srcStr = $('#voucher_pic').attr('src');
        menu.create_pic_dialog_identy(api,W,'getSitePic','图片预览',srcStr,true);
    }
</script>
	<link rel="stylesheet" type="text/css" href="/sso/static/css/overui.css" />
</head>
<body>



<div class="over-content">
	<form id="my_form">
		<div class="over-cell">
			<label>场地区域列表</label>
		</div>
		<div class="over-cell">
			<table class="over-table" name="contractAreas" id="contractAreas">
				<tr>
					<th>区域名称</th>
					<th>租用情况</th>
				</tr>
				<s:iterator value="contractAreas">
					<tr>
						<td >${siteArea.areaName}</td>
						<s:if test="siteArea.rentType==0">
							<td>${leaseCount}平方米(${carCount}个车位),月租金:${monthTotalFee/100}元,场地编号:${areaNo}</td>
						</s:if>
						<s:else>
							<td > ${leaseCount}个车位,月租金:${monthTotalFee/100}元,车位号：${areaNo}</td>
						</s:else>

					</tr>
				</s:iterator>
			</table>
		</div>
		<div class="over-cell">
			<label>合同有效期</label>
			<input type="text"  id="startDate" name="contractBean.startDate"  class="over-date"  readonly="readonly" />
			<span class="poz">~</span>
			<input type="text"  id="endDate" name="contractBean.endDate" value="${contract.endDate}"  class="over-date"  readonly="readonly" />
		</div>
		<%--<div class="over-cell">--%>
			<%--<label>凭证截图</label>--%>
		<%--</div>--%>
		<%--<div class="over-cell">--%>
			<%--<label></label>--%>
			<%--<c:if test="${not empty pic.smallPicUrl}">--%>
				<%--<img src="${pic.smallPicUrl}"  width="136" height="130" id="voucher_pic" onclick="showPic()"/>--%>
			<%--</c:if>--%>
			<%--<c:if test="${empty pic.smallPicUrl}">--%>
				<%--<img src="${ctx}/img/noimg.jpg" width="136" height="130" id="voucher_pic" onclick="showPic()"/>--%>
			<%--</c:if>--%>
		<%--</div>--%>
		<c:if test="${flag=='1'}">
			<div class="over-cell">
				<label>退回时间</label>
				<input type="text"  id="backTime"  class="over-input"  readonly="readonly" />
			</div>
			<div class="over-cell">
				<label>退回原因</label>
				<textarea id="backDesc" class="over-textarea" height="100px"   readonly="readonly">${contract.backDesc}</textarea>
			</div>
		</c:if>
		<div class="over-cell">
			<label>操作历史列表</label>
		</div>
		<div class="over-cell">
			<table class="over-table" name="opers" id="opers">
				<tr>
					<th>操作人</th>
					<th>操作时间</th>
					<th>操作</th>
				</tr>
				<s:iterator value="opers">
					<tr>
						<td>${staff.name}</td>
						<td>${operTime}</td>
						<td>${operDesc}</td>
					</tr>
				</s:iterator>
			</table>
		</div>
	</form>
</div>



	<%--<form id="my_form">--%>
	<%--<div id="tab">--%>
		<%--<div class="box">--%>
			<%--<table>	--%>
				<%--<tr>--%>
					<%--<td class="text-r" width="200px">场地区域列表：</td>--%>
					<%--<td width="400">&nbsp;</td>--%>
				<%--</tr>--%>
				<%--<tr>	--%>
					<%--<td colspan="2">--%>
						<%--<table style="margin:auto; width:95%;margin-top:15px;" border='1' name="contractAreas" id="contractAreas">--%>
							<%--<tr style="width:500px;">--%>
								<%--<td style="text-align:center;text-valign:center;width:50px;height:35px;"><font size="10px">区域名称</font></td>--%>
								<%--<td style="text-align:center;text-valign:center;width:200px;height:35px;"><font size="10px">租用情况</font></td>--%>
							<%--</tr>--%>
							<%--<s:iterator value="contractAreas">--%>
								<%--<tr>--%>
									<%--<td style="text-align:center;text-valign:center;width:50px;height:35px;"><font size="10px">${siteArea.areaName}</font></td>--%>
									<%--<s:if test="siteArea.rentType==0">--%>
									     <%--<td style="text-align:center;text-valign:center;width:200px;height:35px;"><font size="10px">${leaseCount}平方米(${carCount}个车位),月租金:${monthTotalFee/100}元,场地编号:${areaNo}</font></font></td>--%>
									<%--</s:if>--%>
									<%--<s:else>--%>
									    <%--<td style="text-align:center;text-valign:center;width:200px;height:35px;"><font size="10px"> ${leaseCount}个车位,月租金:${monthTotalFee/100}元,车位号：${areaNo}</font></td>--%>
									<%--</s:else>--%>
							 <%----%>
								<%--</tr>--%>
							<%--</s:iterator>--%>
						<%--</table>--%>
					<%--</td>--%>
				<%--</tr>--%>
				<%--<tr>--%>
					<%--<td class="text-r" width="200px">合同有效期：</td>--%>
					<%--<td width="400">--%>
						<%--<input type="text"  id="startDate" name="contractBean.startDate"  style="background-color:#F0F0F0;width:120"  readonly="readonly" />--%>
						<%-----%>
						<%--<input type="text"  id="endDate" name="contractBean.endDate" value="${contract.endDate}" style="background-color:#F0F0F0"  readonly="readonly" />--%>
					<%--</td>--%>
				<%--</tr>--%>
				<%--&lt;%&ndash;<tr>--%>
					<%--<td class="text-r" width="200px">合同收款周期：</td>--%>
					<%--<td width="400">--%>
						<%--<select class="input w120"  id="recvCycle" name="contractBean.recvCycle" onchange="getRecvCycle()">--%>
			   				<%--<option value="-1">请选择</option>--%>
                			<%--<option value="0">季度</option>--%>
                 			<%--<option value="1">半年</option>--%>
                   			<%--<option value="2">一年</option>--%>
                   		<%--</select>--%>
						<%--&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;--%>
						<%--每次收款金额：--%>
						<%--<input type="text"  id="everyRecvFee" name="contractBean.everyRecvFee"  style="background-color:#F0F0F0;width:120"  readonly="readonly"  />&nbsp;元--%>
					<%--</td>--%>
				<%--</tr>--%>
				<%----%>
				<%--<tr>--%>
					<%--<td class="text-r" width="200px">合同押金金额：</td>--%>
					<%--<td width="400">--%>
						<%--<input type="text" id="depositFee" name="contractBean.depositFee" value="${contract.depositFee/100}" style="background-color:#F0F0F0;width:120"  readonly="readonly" />&nbsp;元--%>
						<%--&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;--%>
						<%--合同签订日：--%>
						<%--<input type="text"  id="signDate" name="contractBean.signDate"  value="${contract.signDate}"  style="background-color:#F0F0F0"  readonly="readonly"  />--%>
					<%--</td>--%>
				<%--</tr>--%>
				<%--<tr>--%>
					<%--<td class="text-r" width="200px">市场签署人：</td>--%>
					<%--<td width="400">--%>
						<%--<input type="text"  id="marketSignName" name="contractBean.marketSignName" value="${contract.marketSignName}" style="background-color:#F0F0F0;width:120"  readonly="readonly" />--%>
						<%--&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;--%>
						<%--商户签署人：--%>
						<%--<input type="text"  id="agencySignName" name="contractBean.agencySignName" value="${contract.agencySignName}" style="background-color:#F0F0F0"  readonly="readonly" />--%>
					<%--</td>--%>
				<%--</tr>--%>
		<%----%>
				<%--<tr>--%>
					<%--<td class="text-r" width="200px">合同其他说明：</td>--%>
  					<%--<td width="400" >--%>
						<%--<textarea name="contractBean.remark" id="remark" style="width:380px;background-color:#F0F0F0" height="100px"   readonly="readonly">${contract.remark}</textarea>--%>
  					<%--</td>--%>
				<%--</tr>&ndash;%&gt;--%>
				<%--<tr>--%>
					<%--<td class="text-r" width="200px">凭证截图：</td>--%>
					<%--<td width="400">--%>
						<%--<div class="controls">--%>
                		<%--<c:if test="${not empty pic.smallPicUrl}">--%>
                 		   	<%--<img src="${pic.smallPicUrl}"  width="136" height="130" id="voucher_pic"/>--%>
                		<%--</c:if>--%>
                		<%--<c:if test="${empty pic.smallPicUrl}">--%>
                			<%--<img src="${ctx}/img/noimg.jpg" width="136" height="130" id="voucher_pic"/>--%>
                		<%--</c:if>                --%>
               <%----%>
               			<%--</div>--%>
					<%--</td>--%>
				<%--</tr>--%>
				<%----%>
				<%--<c:if test="${flag=='1'}">--%>
	  				<%--<tr >--%>
	  					<%--<td class="text-r" width="200px">退回时间：</td>--%>
	  					<%--<td width="400" >--%>
							<%--<input type="text"  id="backTime"  style="background-color:#F0F0F0"  readonly="readonly" />--%>
	  					<%--</td>--%>
	  				<%--</tr>--%>
	  				<%--<tr >--%>
	  					<%--<td class="text-r" width="200px">退回原因：</td>--%>
	  					<%--<td width="400" >--%>
							<%--<textarea id="backDesc" style="width:380px;background-color:#F0F0F0" height="100px"   readonly="readonly">${contract.backDesc}</textarea>--%>
	  					<%--</td>--%>
	  				<%--</tr>--%>
  				<%--</c:if>--%>
  				<%----%>
  				<%--<tr >--%>
					<%--<td class="text-r" width="200px">操作历史列表：</td>--%>
  					<%--<td width="400" >&nbsp;</td>--%>
				<%--</tr>--%>
  				<%--<tr>--%>
  					<%--<td colspan="2">--%>
  						<%--<table style="margin:auto; width:95%;margin-top:15px;" border='1' name="opers" id="opers">--%>
							<%--<tr style="width:500px;">--%>
								<%--<td style="text-align:center;text-valign:center;width:50px;height:35px;"><font size="10px">操作人</font></td>--%>
								<%--<td style="text-align:center;text-valign:center;width:50px;height:35px;"><font size="10px">操作时间</font></td>--%>
								<%--<td style="text-align:center;text-valign:center;width:50px;height:35px;"><font size="10px">操作</font></td>--%>
							<%--</tr>--%>
							<%--<s:iterator value="opers">--%>
								<%--<tr>--%>
									<%--<td style="text-align:center;text-valign:center;width:50px;height:35px;"><font size="10px">${staff.name}</font></td>--%>
									<%--<td style="text-align:center;text-valign:center;width:50px;height:35px;"><font size="10px">${operTime}</font></td>--%>
									<%--<td style="text-align:center;text-valign:center;width:50px;height:35px;"><font size="10px">${operDesc}</font></td>--%>
								<%--</tr>--%>
							<%--</s:iterator>--%>
						<%--</table>--%>
  					<%--</td>--%>
  				<%----%>
  				<%--</tr>--%>
  				<%----%>
		<%----%>
			<%----%>
			<%--</table>--%>
		<%--</div>--%>
  	<%--</div>--%>

	<%--</form>--%>

    <%----%>
</body>
</html>
