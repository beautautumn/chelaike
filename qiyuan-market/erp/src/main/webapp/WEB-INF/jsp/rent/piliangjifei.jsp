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
  		//打开新增商户页面
		function addShangHu(){
		menu.create_child_dialog_identy(api,W,'addShangHu','添加商户',
    	'/rent/feeBillsListAction!addShangHu.action',
    	500,200,true);
    	}
    	//打开按区域批量增加
    	function addShangHuByArea(){
		menu.create_child_dialog_identy(api,W,'addShangHuByArea','按区域增加',
    	'/rent/feeBillsListAction!addShangHuByArea.action',
    	400,90,true);
    	}	
    	//在页面上删除一行数据
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
		//替换重复
		function checkRepetition(agencyId){
			
			$("#table4 tr:not(:first)").each(function(){
			var id =$(this).find("td").eq(3).find("input").val();
			
			if(agencyId==id){
			$(this).remove();
			}
		});	
		}	
		//增加一行
		function do_get_agencybill(data){
		var agencyId=data[0].split(",")[0];
		checkRepetition(agencyId);
		var agencyName=data[0].split(",")[1];
		var feeValue=data[1];
		var remark=data[2];
		$("#table4").append(
		"<tr style='width:500px;'>"+
			"<td id='' style='text-align:center;text-valign:center;width:50px;height:30px;'>"+agencyName+"</td>"+
			"<td id='' style='text-align:center;text-valign:center;width:50px;height:30px;'><input type='text' value='"+feeValue+"'/></td>"+
			"<td id='' style='text-align:center;text-valign:center;width:50px;height:30px;'><input type='text' value='"+remark+"' /></td>"+		
			"<td id='' style='text-align:center;text-valign:center;width:50px;height:30px;'><input type='hidden' value='"+agencyId+"' />"+
			"<a onclick='deleteCurrentRow(this);'>删除</a></td>"+	
		"</tr>"
		);
		}
		//接收按区域增加数据
		function do_get_addShanghuByArea(data){
		var areaId = data[0];
		var feeValue=data[1];
		var data='data='+areaId;
		 $.ajax({    
              type:'post',        
              url:'${ctx}/rent/feeBillsListAction!findAgencyNamesByAreaId.action',    
              data:data,   
              cache:false,    
              async : false, //默认为true 异步     
              success:function(data){
                  	var arr = eval(data);
                  	if(arr.length==0){
                  	alert("该区域无商户,使用请重新选择区域");
              		return;
                  	}
                  	for(var i=0;i<arr.length;i++){
                  	var x = arr[i].agencyName;
                  	var y = arr[i].agencyId;
                 	checkRepetition(arr[i].agencyId);	
				$("#table4").append(
						"<tr style='width:500px;'>"+
							"<td id='' style='text-align:center;text-valign:center;width:50px;height:30px;'>"+x+"</td>"+
							"<td id='' style='text-align:center;text-valign:center;width:50px;height:30px;'><input type='text' value='"+feeValue+"'/></td>"+
							"<td id='' style='text-align:center;text-valign:center;width:50px;height:30px;'><input type='text' value='' /></td>"+		
							"<td id='' style='text-align:center;text-valign:center;width:50px;height:30px;'><input type='hidden' value='"+y+"'/>"+
							"<a onclick='deleteCurrentRow(this);'>删除</a></td>"+	
						"</tr>"
						);
                  	}
              }    
          });  
		}
		function do_submit(){
		var row = document.getElementById("table4").rows.length;
		if(row==1){
		if(window.confirm('无需要保存的数据，是否关闭窗口?')){
                 //alert("确定");
                 api.get("piLiangJiFei",1).close();
              }else{
                 //alert("取消");
                 return ;
             }
		}
		var data="";
		var itemId = $("#itemId").val();
		if(itemId==0){
		alert("请选择费用科目");
		return;
		}
		var staffId = $("#staffId").val();
		if(staffId==0){
		alert("请选择计费人");
		return;
		}
		var recvTime = $("#recvTime").val();
		if(recvTime==""){
		alert("请选择计费日期");
		return;
		}
		var table = new Array();
		var index=0;
		$("#table4 tr:not(:first)").each(function(){
			var arr = new Array();
			arr[0]=$(this).find("td").eq(1).find("input").eq(0).val();
			arr[1]=$(this).find("td").eq(2).find("input").eq(0).val();
			arr[2]=$(this).find("td").eq(3).find("input").eq(0).val();
			table[index]=arr;
			index+=1;
		});	
		var b = JSON.stringify(table);
		data='data='+b+'&itemIds='+itemId+'&staffId='+staffId+'&recvTime='+recvTime;
		 $.ajax({    
              type:'post',        
              url:'${ctx}/rent/feeBillsListAction!piLiangZengjia.action',    
              data: data,   
              cache:false,    
              async : false, //默认为true 异步     
              success:function(data){  
                     if(data=="success"){
                     	alert("增加成功");
                     	api.get("piLiangJiFei",1).close();
                    	W.query1();
                     }else{
                   		alert("增加失败");  
                   		api.get("piLiangJiFei",1).close();
                     }
              }    
          });  
		}
		
  	</script>
</head>
<body>
	<table style="margin:auto; width:100%;height:40px" id="table1">
		<tr style="width:900px;height:15px;">
			<td class="text-r" width="40px;" height="40px;">计费科目:&nbsp;&nbsp;&nbsp;</td>
			<td style="text-valign:center;height:40px;width:80px;">
				<select id="itemId"  name="itemId" style="width:150px;height:20px;">
								<option value='0'>请选择</option>
							<s:iterator value="feeItems">
								<option value="<s:property value='id'/>"><s:property value="itemName"/></option>
							</s:iterator>
				</select>
			</td>
			<td class="text-r" width="20px;"></td>
  			<td class="text-l" width="150px;">
  			</td>
		</tr>
	</table>	
	<table style="margin:auto; width:100%;height:40px" id="table2">
		<tr style="width:900px;height:15px;">
			<td class="text-r" width="40px;" height="40px;">计费人:&nbsp;&nbsp;&nbsp;</td>
			<td style="text-valign:center;height:40px;width:80px;">
				<select id="staffId"  name="staffId" style="width:150px;height:20px;">
								<option value='0'>请选择</option>
							<s:iterator value="staffs">
								<option value="<s:property value='id'/>"><s:property value="name"/></option>
							</s:iterator>
				</select>
			</td>
			<td class="text-r" width="30px;" height="40px;">计费日期:&nbsp;&nbsp;&nbsp;</td>
  			<td class="text-l" width="150px;" height="40px;">
  				<input type="text"  id="recvTime" name="startDate"  value="${date}" onclick="WdatePicker()" onblur="setEndDate();"/>
  			</td>
		</tr>
	</table>	
	<table style="margin:auto; width:100%;" id="table3">
		<tr style="width:900px;height:15px;">
			<td class="text-r" width="100px;" height="15px;"><b>商户名称:&nbsp;&nbsp;&nbsp;<b/></td>
			<td style="text-valign:center;height:15px;width:200px;"></td>
			<td class="text-center" width="300px;" height="15px;">
				<input type="button" style="width:80px;"  onclick="javascript:addShangHu();" value="新增商户" />
				<input type="button" style="width:100px;"  onclick="javascript:addShangHuByArea();" value="批量按区域增加" />
			</td>
  			<td class="text-l" width="300px;" height="15px;">
  			</td>
		</tr>
	</table>
	<table  style="margin:auto; width:90%;margin-top:10px;" border='1' name="giveTable" id="table4">
		<tr style="width:500px;">
			<td style="text-align:center;text-valign:center;width:50px;height:30px;"><b>商户名称<b/></td>
			<td style="text-align:center;text-valign:center;width:50px;height:30px;"><b>计费数额(元)</b></td>
			<td style="text-align:center;text-valign:center;width:100px;height:30px;"><b>分摊备注</b></td>
			<td style="text-align:center;text-valign:center;width:100px;height:30px;"><b>操作</b></td>
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
		
</body>
</html>
