<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ include file="/common/taglibs.jsp"%>
<%@ include file="/common/meta.jsp"%>
<%@taglib uri="/struts-tags" prefix="s" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
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
  	<script type="text/javascript">
  		var api = frameElement.api, W = api.opener;
  		//打开新增子页面
		function openAdd(){
		menu.create_child_dialog_identy(api,W,'addFee','新增',
    	'/rent/feeBillsListAction!toAddFee.action',
    	700,300,true);
    	}
    	//删除某一行
    	function deleteCurrentRow(obj){ 
		var msg="是否删除此项费用？";
		if(confirm(msg)==true){
		var tr=obj.parentNode.parentNode; 
		var tbody=tr.parentNode; 
		tbody.removeChild(tr); 
		}else{
		return;
		}
		}
		//增加一行
		function do_get_agencybill(data){
		var row = document.getElementById("giveTable").rows.length;
		var item=data[0].split(",");
		var itemid=item[0];
		var itemName=item[1];
		var value=data[1];
		var staff=data[2].split(",");
		var staffid=staff[0];
		var staffname=staff[1];
		var date=data[3];
		var stafftime=staffname+"/"+date;
		var remark=data[4];
		var itemNameId="itemName"+row;
		var feeValueId="feeValue"+row;
		var staffId="staffId"+row;
		var remarkId="remark"+row;
		var itemId="itemId"+row;
		var dateId="dateId"+row;
		var id="id"+row;
		var StaffAndTimeId ="StaffAndTimeId"+row;
		$("#giveTable").append(
		"<tr style='width:500px;'>"+
			"<td id='"+itemNameId+"' style='text-align:center;text-valign:center;width:50px;height:30px;'>"+itemName+"</td>"+
			"<td id='"+feeValueId+"'style='text-align:center;text-valign:center;width:50px;height:30px;'>"+value+"</td>"+
			"<td id='"+StaffAndTimeId+"' style='text-align:center;text-valign:center;width:100px;height:30px;'>"+stafftime+"</td>"+
			"<td id='"+remarkId+"' style='text-align:center;text-valign:center;width:100px;height:30px;'>"+remark+"</td>"+		
			"<td style='text-align:center;text-valign:center;width:50px;height:30px;'><input type='hidden' value='${id}' id='"+id+"'/>"+
			"<input type='hidden' value='' id='"+itemId+"'/><input type='hidden' value='' id='"+staffId+"'/>"+
			"<input type='hidden' value='' id='"+dateId+"'/>"+
			"<a onclick='deleteCurrentRow(this);'>删除</a>&nbsp; &nbsp; <a onclick='edit("+row+");'>编辑</a></td>"+	
		"</tr>"
		);
		document.getElementById("itemId"+row).value=item[0];
		document.getElementById("staffId"+row).value=staffid;	
		document.getElementById("dateId"+row).value=date;	
		}
		//编辑
		function edit(count){
		var itemId = $("#itemId"+count).attr("value");
		var staffId = $("#staffId"+count).attr("value");
		var date = $("#dateId"+count).attr("value");
		var item = document.getElementById("itemName"+count).innerHTML;
		var feeValue=document.getElementById("feeValue"+count).innerHTML;
		var remark=document.getElementById("remark"+count).innerHTML;
			menu.create_child_dialog_identy(api,W,'editFee','修改',
    	'/rent/feeBillsListAction!toEdit.action?feeValue='+feeValue+'&remark='+remark+'&itemIds='+itemId+'&row='+count+'&staffId='+staffId+
    	'&date='+date,
    	700,300,true);
		}
		//回显编辑后的数据
		function do_get_edit(data){
		var result=data.split("|");
		var item = result[1].split(",");
		var itemid=item[0];
		var itemname=item[1];
		var value=result[2];
		var remark= result[5];
		var staff = result[3].split(",");
		var staffid=staff[0];
		var staffname=staff[1];
		var date=result[4];
		var staffAndTime=staffname+"/"+date;
		var itemNameId ="itemName"+result[0];
		var feeValueId="feeValue"+result[0];
		var remarkId = "remark"+result[0];
		$("#"+itemNameId)[0].innerHTML=itemname;
		$("#"+feeValueId)[0].innerHTML=value;
		$("#"+remarkId)[0].innerHTML=remark;
		document.getElementById("staffId"+result[0]).value=staffid;
		document.getElementById("itemId"+result[0]).value=itemid;
		document.getElementById("dateId"+result[0]).value=date;
		document.getElementById("StaffAndTimeId1").value=staffAndTime;
		}
		//确认按钮
		function do_submit(){
		var rows = document.getElementById("giveTable").rows.length;
		if(rows==1){
		alert("无需要添加的费用");
		return;
		}
		$("#table1 tr").each(function(){
			agencyId=$(this).find("td").eq(0).find("input").eq(1).val();
			agencyBillsId=$(this).find("td").eq(0).find("input").eq(2).val();
		});	
		var agencyBills = new Array(rows-1);
		var index=0;
		var data="";
		$("#giveTable tr:not(:first)").each(function(){
			data+=$(this).find("td").eq(1).html()+",";//计费数额
			data+=$(this).find("td").eq(3).html()+",";//备注
			data+=$(this).find("td").eq(4).find("input").eq(1).val()+",";//费用科目
			data+=$(this).find("td").eq(4).find("input").eq(2).val()+",";//计费人
			data+=$(this).find("td").eq(4).find("input").eq(3).val();//计费日期
		});	
		data='data='+data+'&agencyid='+agencyId+'&AgencyBillsId='+agencyBillsId;	
		 $.ajax({    
              type:'post',        
              url:'${ctx}/rent/feeBillsListAction!addOrUpdate.action',    
              data:data,   
              cache:false,    
              async : false, //默认为true 异步     
              success:function(data){  
                     if(data=="success"){
                     	alert("操作成功");
                     	api.get("rectFeePage",1).close();
                    	W.query1(); 
                     }else{
                   		alert("操作失败");  
                   		api.get("rectFeePage",1).close();
                     }
                 
              }    
          });  
		}	 
  	</script>
</head>
<body>
	<table style="margin:auto; width:90%;margin-top:10px;" id="table1">
		<tr style="width:500px;height:25px;">
			<td style="text-valign:center;height:25px;width:500px;">商户名称：<input type="text" value="<s:property value="agencyName"/>" style="background-color:#F0F0F0;width:120px;" readonly="readonly" /><input type="hidden" value="<s:property value="agencyId"/>" style="background-color:#F0F0F0;width:120px;" readonly="readonly" /><input type="hidden" value="<s:property value="AgencyBillsId"/>"/></td>
			<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
			<td><input type="button" style="width:80px;" onclick="javascript:openAdd();" value="新增" /></td>
		</tr>
	</table>
	<table  style="margin:auto; width:90%;margin-top:10px;" border='1' name="giveTable" id="giveTable">
		<tr style="width:500px;">
			<td style="text-align:center;text-valign:center;width:50px;height:30px;"><b>费用名称<b/></td>
			<td style="text-align:center;text-valign:center;width:50px;height:30px;"><b>计费数额(元)</b></td>
			<td style="text-align:center;text-valign:center;width:100px;height:30px;"><b>计费人/计费日期</b></td>
			<td style="text-align:center;text-valign:center;width:100px;height:30px;"><b>计费备注</b></td>
			<td style="text-align:center;text-valign:center;width:50px;height:30px;"><b>操作</b></td>
		</tr>
<!--		<s:iterator value="agencyBills" status="stat">-->
<!--		<tr style="width:500px;">-->
<!--			<td id="itemName${stat.count}"  style="text-align:center;text-valign:center;width:50px;height:30px;"><s:property value="feeItem.itemName"/></td>-->
<!--			<td id="feeValue${stat.count}" style="text-align:center;text-valign:center;width:50px;height:30px;"><s:property value="feeValue"/></td>-->
<!--			<td id="remark${stat.count}" style="text-align:center;text-valign:center;width:100px;height:30px;"><s:property value="remark"/></td>-->
<!--			<td style="text-align:center;text-valign:center;width:100px;height:30px;">-->
<!--			<input type="hidden" value="${id}" id="id${stat.count}"/>-->
<!--			<input type="hidden" value="${feeItem.id}" id="itemId${stat.count}"/>-->
<!--			<a href="javascript:Goto();" onclick='deleteCurrentRow(this);'>删除</a><a onclick='edit(${stat.count});'>编辑</a></td>-->
<!--		</tr>-->
<!--		</s:iterator>-->
	</table>
<!--	<table style="margin:auto; width:90%;height:45px">-->
<!--		<tr style="width:500px;height:15px;">-->
<!--			<td style="text-valign:center;height:15px;width:500px;">计费人：-->
<!--				<select id="staffId"  name="staffId" style="width:130px;">-->
<!--								<option value='0'>请选择</option>-->
<!--							<s:iterator value="staffs">-->
<!--								<option value="<s:property value='id'/>"><s:property value="name"/></option>-->
<!--							</s:iterator>-->
<!--				</select>-->
<!--			</td>-->
<!--			<td class="text-r" width="100px;">合同起始日：<span class="red">*</span></td>-->
<!--  			<td width="150px;">-->
<!--  				<input type="text"  id="startDate" name="startDate"  onclick="WdatePicker()" onblur="setEndDate();"/>-->
<!--  			</td>-->
<!--		</tr>-->
<!--	</table>		-->
</body>
</html>
