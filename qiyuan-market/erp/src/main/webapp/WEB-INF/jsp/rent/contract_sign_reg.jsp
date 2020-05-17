<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@taglib uri="/struts-tags" prefix="s"%>
<%@ include file="/common/taglibs.jsp"%>
<%@ include file="/common/meta.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>合同签订</title>
<link rel="stylesheet" type="text/css" href="${ctx}/css/style.css" />
<script type="text/javascript" src="${ctx}/js/common/syUtil.js"></script>
<script type="text/javascript" src="${ctx}/js/common/ctutil.js"></script>
<script type="text/javascript" src="${ctx}/js/common/menu.js"></script>
<script type="text/javascript" src="${ctx}/js/plugins/My97DatePicker/WdatePicker.js"></script>

<link rel="stylesheet" href="${ctx}/css/upload.css" />
<script src="${ctx}/js/plugins/jquery/uploadifive/jquery.uploadifive.js"></script> 
<style type="text/css">
.message_box{ width:300px;height:120px;overflow:hidden;}
.message_box_t{ width:25px; padding-left:275px; background:url(../img/message_box_top.png); height:20px; padding-top:10px;}
.message_box_m{ width:280px; padding:10px; background:url(../img/message_box_body.png);text-align:left; line-height:35px; font-size:14px;}
.message_box_b{ width:300px; background:url(../img/message_box_bottom.png); height:30px;}
</style>
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
	 var upload_type = ""; //上传操作类型  add:新传图片 edit:编辑图片
	var api = frameElement.api, W = api.opener;
	$(function(){
		$("#signDate").val(new Date().format('yyyy-MM-dd'));
		$("#depositFee").val('0.00');
		$("#everyRecvFee").val('0.00');
		
		$("#agencyId option").each(function(){
  			if($(this).val()=='${agencyId}'){
  				$(this).attr('selected','selected');
  			}
  		});
  		
		getRecvCycle();
		
		upload_type = '';        
        init_uploadifive();
        
        
        $('input[type="file"]').attr(
          'accept',
          'image/gif, image/jpeg, image/jpg, image/png, .gif, .jpeg, .jpg, .png'
        );
  	
  	});
  	
  	//初始化附件上传控件
    function init_uploadifive()
    {
      $('#file_upload').uploadifive({
        'multi' : false,   
        'fileType': [
          'image/png',
          'image/jpg',
          'image/jpeg'
        ],
        'onAddQueueItem' : function(file) {
          console.log("the file is %o",file);
          $('#file_upload').data('uploadifive').settings.formData = { 
            'localFileName' : file.name, 
            'corpConf.confId':'${corpConf.confId}',
            'localFileSize':1258287
          };
        },
        'onUploadComplete': function(file, data) 
        {
          console.log("onUploadComplete is called!%o",data);

          var pic = eval('(' + data + ')');
          console.log("the pic is %o",pic);
          if(pic){
          	
            $("#voucher_pic").attr("src",pic.smallPicAddr);
            $("#picId").val(pic.picId);

          }          
          $('#file_upload').uploadifive('clearQueue');
          hide_info();

        },              
        'fileSizeLimit' : '100MB',
        'auto'  : true,
        'fileObjName' : 'fileObj', 
        'buttonText'  : '点击选择图片',      
        'uploadScript' : '${ctx}/rent/contractListAction!upload.action?'
      });
     };     
	
	



    /*设置客户端的高和宽*/  
    function get_client_bounds(){   
      var clientWidth;   
      var clientHeight;  

      clientWidth = document.compatMode == "CSS1Compat" ? 
        document.documentElement.clientWidth : document.body.clientWidth;   
      clientHeight = document.compatMode == "CSS1Compat" ? 
        document.documentElement.clientHeight :   document.body.clientHeight;         
      return {width: clientWidth, height: clientHeight};   
    }  

    function get_mouse_pos(event) {
      var e = event || window.event;
      var scrollX = document.documentElement.scrollLeft || document.body.scrollLeft;
      var scrollY = document.documentElement.scrollTop || document.body.scrollTop;
      var x_coord = e.pageX || e.clientX + scrollX;
      var y_coord = e.pageY || e.clientY + scrollY;
      var p = new Object();
      p.x = x_coord;
      p.y = y_coord;
      return p;
    }


    /*显示上传附件对话框*/
    function show_info(event)
    { 
      $('input[type="file"]').attr(
          'accept',
          'image/jpeg, image/jpg, image/png, .jpeg, .jpg, .png'
      );
      var floatArea = document.getElementById("popup");
      var rr = get_client_bounds();
      var p = get_mouse_pos(event);
      var ileft = (rr.width - floatArea.clientWidth)/2 + document.body.scrollLeft;
      floatArea.style.display = "block";
      console.log("left is ",ileft);
      console.log("p.y is ",p.y);
      $("#popup").css({"z-index":"100", "position": "absolute", left : ileft-150, top: p.y-20}); 
    }  

    /*隐藏上传附件对话框*/   
    function hide_info() {       
       $("#showname").val("");
       document.getElementById("popup").style.display = "none";
    }      
  	
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
				$("#monthTotalFeeAll").val(monthTotalFeeAll);
			}
  		});
  	}

	var areaNoAll="";
	var currentSiteAreas="";
	function openSiteArea(){
		if($("#contractAreas tr").length>1){
				for(var i=1;i<$("#contractAreas tr").length;i++){
					if(i==$("#contractAreas tr").length-1){
						areaNoAll+=$("#contractAreas tr:eq("+i+") td:eq("+4+")").attr('areano')+",";
						currentSiteAreas+=$("#contractAreas tr:eq("+i+") td:eq("+0+")").attr('id')+",";
					}
				}
		}
		menu.create_child_dialog_identy(api,W,'getSitePage','选择场地区域',
    		'/rent/contractSignAction!toSelectSiteArea.action?areaNoAll='+areaNoAll+'&currentSiteAreas='+currentSiteAreas,
            350,430,true);
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
			$("#monthTotalFeeAll").val(all);
			$("#depositFee").val(all);
			$("#everyRecvFee").val('');
		}else if($("#recvCycle option:selected").val()=='0'){
			if($("#contractAreas tr").length>1){
				for(var i=1;i<$("#contractAreas tr").length;i++){
					all+=parseFloat(parseFloat($("#contractAreas tr:eq("+i+") td:eq("+3+")").attr('monthtotalfee')).toFixed(2));
				}
			}
			$("#monthTotalFeeAll").val(all);
			$("#depositFee").val(all);
			$("#everyRecvFee").val(parseFloat(all*3).toFixed(2));				
		}else if($("#recvCycle option:selected").val()=='1'){
			if($("#contractAreas tr").length>1){
				for(var i=1;i<$("#contractAreas tr").length;i++){
					all+=parseFloat(parseFloat($("#contractAreas tr:eq("+i+") td:eq("+3+")").attr('monthtotalfee')).toFixed(2));
				}
			}
			$("#monthTotalFeeAll").val(all);
			$("#depositFee").val(all);
			$("#everyRecvFee").val(parseFloat(all*6).toFixed(2));
		}else if ($("#recvCycle option:selected").val()=='2'){
			if($("#contractAreas tr").length>1){
				for(var i=1;i<$("#contractAreas tr").length;i++){
					all+=parseFloat(parseFloat($("#contractAreas tr:eq("+i+") td:eq("+3+")").attr('monthtotalfee')).toFixed(2));
				}
			}
			$("#monthTotalFeeAll").val(all);
			$("#depositFee").val(all);
			$("#everyRecvFee").val(parseFloat(all*12).toFixed(2));
		}
		
    
    }
    
    function setEndDate(){
    	if(!$("#startDate").val()==''){
    		var d=$("#startDate").val();
    		d=d.replace(/-/g, '/');
    		var now=new Date(d);
    		now.setDate(now.getDate()-1);
			$("#endDate").val(now.getFullYear()+1+"-"+(now.getMonth()+1)+"-"+now.getDate());
		}
	}
	/*function checkDepositFee(){
		if($("#depositFee").val()==''||$("#depositFee").val()=='0.00'){
			alert("请输入合同押金金额！");
			return;
		}else{
			if(!regFloat.test($("#depositFee").val())){
	            alert("合同押金金额必须是正整数或者小数，请重新输入");
	            return ;
	        }
	        $("#depositFee").val(parseFloat($("#depositFee").val()).toFixed(2));
		}
	}*/

    
	function deleteCurrentRow(obj){ 
		if(confirm("是否删除此条记录？")==true){
  			var tr=obj.parentNode.parentNode; 
			var tbody=tr.parentNode; 
			tbody.removeChild(tr); 
			currentSiteAreas=currentSiteAreas.replace(tr.childNodes[0].getAttribute("id"),"");
			areaNoAll=areaNoAll.replace(tr.childNodes[4].getAttribute("areano"),"");
			getMonthTotalFeeAll();
  		}else{
  			return;
  		}
		
	} 

	function do_submit(){
		
		if($("#agencyId").val()=='-1'){
			alert("请选择签订商户！");
			return;
		}
		if($("#contractAreas tr").length=='1'){
			alert("请添加场地区域");
			return;
		}
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
		/*if($("#recvCycle").val()=='-1'){
			alert("请选择合同收款周期！");
			return;
		}
		if($("#everyRecvFee").val()==''||$("#everyRecvFee").val()=='0.00'){
			alert("请输入每次收款金额！");
			return;
		}
		if($("#depositFee").val()==''||$("#depositFee").val()=='0.00'){
			alert("请输入合同押金金额！");
			return;
		}else{
			if(!regFloat.test($("#depositFee").val())){
	            alert("合同押金金额必须是正整数或者小数，请重新输入");
	            return ;
	        }
		}*/
		/*if($("#signDate").val()==''){
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
		}*/
		if(confirm("确认保存合同？")){
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
			var url1 =ctutil.bp()+"/rent/contractSignAction!contractSignReg.action";
			data = $("#myForm").serialize();
			$.ajax({
					cache: false,
					type: "POST",
					url:ctutil.bp()+"/rent/contractSignAction!contractSignReg.action",
					data:data,
					async: false,
					error: function() {
					html = "数据请求失败";
					},
					success: function(data) {
					  if(data=="success"){
						  alert("保存成功！");
						  api.get("contractSignPage", 1).close();
						  W.query1();  //刷新副页面
					  }else{
						  alert("保存失败！");
						  //api.get("contractSignPage", 1).close();
					  }
					}
				});
		}else{
			return;
		}
		
		
	}
    function inputFileChange(){
        console.log(event);
        var srcStr = getObjectURL(event.target.files[0]);
        console.log(srcStr);
        $('#voucher_pic').attr('src',srcStr);
    }
    function getObjectURL(file) {
        var url = null;
        if (window.createObjectURL != undefined) {
            url = window.createObjectURL(file)
        } else if (window.URL != undefined) {
            url = window.URL.createObjectURL(file)
        } else if (window.webkitURL != undefined) {
            url = window.webkitURL.createObjectURL(file)
        }
        return url
    }
    function showPic(){
        var srcStr = $('#voucher_pic').attr('src');
        menu.create_pic_dialog_identy(api,W,'getSitePic','图片预览',srcStr,true);
    }

</script>
	<link rel="stylesheet" type="text/css" href="${ctx}/js/plugins/jquery/uploadifive/uploadifive.css">
	<link rel="stylesheet" type="text/css" href="/sso/static/css/overui.css" />
</head>
<body>
<div class="over-content">
	<form id="myForm">
		<input type="hidden" name="picId" id="picId" value="${pic.picId}"/>
		<input type="hidden" name="contractBean.monthTotalFeeAll" id="monthTotalFeeAll" value=""/>
		<div  class="over-cell">
			<label>签订商户</label>
			<select id="agencyId" class="over-select" name="contractBean.agencyId" >
				<option value='-1' >请选择</option>
				<s:iterator value="agencys">
					<option value="<s:property value='id'/>"  >
							${agencyName}
					</option>
				</s:iterator>
			</select>
		</div>
		<div class="over-cell">
			<label>场地区域列表</label>
			<span class="over-button" onclick="javascript:openSiteArea();">添加</span>
		</div>
		<div class="over-cell">
			<table class="over-table" name="contractAreas" id="contractAreas">
				<tr>
					<th>区域名称</th>
					<th>类型</th>
					<th>租用面积/单位</th>
					<th>月租金(元)</th>
					<th>场地编号</th>
					<th>车位数</th>
					<th>操作</th>
				</tr>
				<c:forEach items="${contractAreas}" var="contractArea">
					<tr >
						<td  contractAreaId = '${contractArea.id}' monthrentfee = '${contractArea.monthRentFee/100}' id = '${contractArea.siteArea.id }' areaname='${contractArea.siteArea.areaName }' >${contractArea.siteArea.areaName }</td>
						<td renttype = '${contractArea.siteArea.rentType }' >${contractArea.siteArea.rentType }</td>
						<td leasecount = '${contractArea.leaseCount}' >${contractArea.leaseCount}</td>
						<td monthtotalfee = '${contractArea.monthTotalFee/100}' >${contractArea.monthTotalFee/100}</td>
						<td areano = '${contractArea.areaNo}' >${contractArea.areaNo}</td>
						<td carcount = '${contractArea.carCount}' >${contractArea.carCount}</td>
						<td ><a onclick='deleteCurrentRow(this);'>删除</a></td>
					</tr>
				</c:forEach>
			</table>
		</div>
		<div class="over-cell">
			<label>合同有效期</label>
			<input type="text" class="over-date" id="startDate" name="contractBean.startDate"  onclick="WdatePicker()" onblur="setEndDate();"/>
			<span class="poz">~</span>
			<input type="text" class="over-date"  id="endDate" name="contractBean.endDate"  onclick="WdatePicker()" />
		</div>
		<%--<div class="over-cell">--%>

			<%--<label>凭证截图上传</label>--%>

			<%--<span class="over-button" id="corpLogo" style="position:relative">上传<input type="file" id="inputFile"  onchange="inputFileChange()"/></span>--%>
		<%--</div>--%>
		<%--<div class="over-cell">--%>
			<%--<label></label>--%>
			<%--<c:if test="${not empty wdPic.smallPicAddr}">--%>
				<%--<img src="${wdPic.smallPicAddr}"  width="136" height="130" id="voucher_pic" onclick="showPic()"/>--%>
			<%--</c:if>--%>
			<%--<c:if test="${empty wdPic.smallPicAddr}">--%>
				<%--<img src="${ctx}/img/noimg.jpg" width="136" height="130" id="voucher_pic" onclick="showPic()"/>--%>
			<%--</c:if>--%>
		<%--</div>--%>

		<input id="localFileName" type="hidden" name="localFileName" value=""/>

		<div id="popup" style="z-index:100;display:none" class="message_box" >
			<div class="message_box_t">
				<img src="${ctx}/img/message_box_close.png" onclick="javascript:hide_info();" />
			</div>
			<div class="message_box_m">
				<table>
					<tr>
						<td>
							<div id="queue"></div>完整文件名：
							<input id="showname" name ="showname" type="text" style ="width:100px" readonly="readonly"/>
						</td>
						<td>
							<input id="file_upload" name="file_upload" type="file"/>
						</td>
					</tr>
				</table>
			</div>
			<div class="message_box_b">
			</div>
		</div>
	</form>
</div>






	<%--<form id="myForm">--%>
	<%--<div id="tab">--%>
		<%--<div class="box">--%>
			<%--<input type="hidden" name="picId" id="picId" value="${pic.picId}"/>--%>
			<%--<input type="hidden" name="contractBean.monthTotalFeeAll" id="monthTotalFeeAll" value=""/>--%>
			<%--<table>--%>
				<%--<tr>--%>
					<%--<td class="text-r" width="200px">签订商户：<span class="red">*</span></td>--%>
					<%--<td width="400">--%>
						<%--<select id="agencyId" class="input w100" name="contractBean.agencyId" >--%>
			   				<%--<option value='-1' >请选择</option>--%>
							<%--<s:iterator value="agencys">--%>
								<%--<option value="<s:property value='id'/>"  >--%>
									<%--${agencyName}--%>
								<%--</option>--%>
							<%--</s:iterator>--%>
               		<%--</select>--%>
					<%--</td>--%>
				<%--</tr>--%>
				<%----%>
				<%--<tr>--%>
					<%--<td class="text-r" width="200px">场地区域列表：<span class="red">*</span></td>--%>
					<%--<td width="400">--%>
						<%--<input type="button"  style="margin-left:350px;width:90px;" onclick="javascript:openSiteArea();"  value="添加" />--%>
					<%--</td>--%>
				<%--</tr>--%>
				<%--<tr>	--%>
					<%--<td colspan="2">--%>
						<%--<table style="margin:auto; width:95%;margin-top:15px;" border='1' name="contractAreas" id="contractAreas">--%>
							<%--<tr style="width:500px;">--%>
								<%--<td style="text-align:center;text-valign:center;width:50px;height:35px;"><font size="10px">区域名称</font></td>--%>
								<%--<td style="text-align:center;text-valign:center;width:50px;height:35px;"><font size="10px">类型</font></td>--%>
								<%--<td style="text-align:center;text-valign:center;width:80px;height:35px;"><font size="10px">租用面积/单位</font></td>--%>
								<%--<td style="text-align:center;text-valign:center;width:50px;height:35px;"><font size="10px">月租金(元)</font></td>--%>
								<%--<td style="text-align:center;text-valign:center;width:50px;height:35px;"><font size="10px">场地编号</font></td>--%>
								<%--<td style="text-align:center;text-valign:center;width:50px;height:35px;"><font size="10px">车位数</font></td>--%>
								<%--<td style="text-align:center;text-valign:center;width:50px;height:35px;"><font size="10px">操作</font></td>--%>
							<%--</tr>--%>
						<%--</table>--%>
					<%--</td>--%>
				<%--</tr>--%>
				<%--<tr>--%>
					<%--<td class="text-r" width="200px">合同有效期：<span class="red">*</span></td>--%>
					<%--<td width="400">--%>
						<%--<input type="text" style="width:120" id="startDate" name="contractBean.startDate"  onclick="WdatePicker()" onblur="setEndDate();"/>--%>
						<%---<span class="red">*</span>--%>
						<%--<input type="text"  id="endDate" name="contractBean.endDate"  onclick="WdatePicker()" />--%>
					<%--</td>--%>
				<%--</tr>--%>
				<%--&lt;%&ndash;<tr>--%>
					<%--<td class="text-r" width="200px">合同收款周期：<span class="red">*</span></td>--%>
					<%--<td width="400">--%>
						<%--<select class="input w120"  id="recvCycle" name="contractBean.recvCycle" onchange="getRecvCycle()">--%>
			   				<%--<option value="-1">请选择</option>--%>
                			<%--<option value="0">季度</option>--%>
                 			<%--<option value="1">半年</option>--%>
                   			<%--<option value="2">一年</option>--%>
                   		<%--</select>--%>
						<%--&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;--%>
						<%--每次收款金额：<span class="red">*</span>--%>
						<%--<input type="text"  id="everyRecvFee" name="contractBean.everyRecvFee" style="background-color:#F0F0F0"  readonly="readonly"  />&nbsp;元--%>
					<%--</td>--%>
				<%--</tr>--%>
				<%----%>
				<%--<tr>--%>
					<%--<td class="text-r" width="200px">合同押金金额：<span class="red">*</span></td>--%>
					<%--<td width="400">--%>
						<%--<input type="text" id="depositFee" style="width:120" name="contractBean.depositFee"  onblur="checkDepositFee();" />&nbsp;元--%>
						<%--&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;--%>
						<%--合同签订日：<span class="red">*</span>--%>
						<%--<input type="text"  id="signDate" name="contractBean.signDate"   style="background-color:#F0F0F0"  readonly="readonly"  />--%>
					<%--</td>--%>
				<%--</tr>--%>
				<%--<tr>--%>
					<%--<td class="text-r" width="200px">市场签署人：<span class="red">*</span></td>--%>
					<%--<td width="400">--%>
						<%--<input type="text"  id="marketSignName" style="width:120" name="contractBean.marketSignName"  />--%>
						<%--&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;--%>
						<%--商户签署人： <span class="red">*</span>--%>
						<%--<input type="text"  id="agencySignName" name="contractBean.agencySignName"/>--%>
					<%--</td>--%>
				<%--</tr>--%>
		<%----%>
				<%--<tr>--%>
					<%--<td class="text-r" width="200px">合同其他说明：</td>--%>
  					<%--<td width="400" >--%>
						<%--<textarea name="contractBean.remark" id="remark" style="width:380px" height="100px"></textarea>--%>
  					<%--</td>--%>
				<%--</tr>&ndash;%&gt;--%>
				<%--<tr>--%>
					<%--<td class="text-r" width="208px">凭证截图上传：</td>--%>
					<%--<td width="400">--%>
						<%--<div class="controls">--%>
                		<%--<c:if test="${not empty wdPic.smallPicAddr}">--%>
                 		   	<%--<img src="${wdPic.smallPicAddr}"  width="136" height="130" id="voucher_pic"/>--%>
                		<%--</c:if>--%>
                		<%--<c:if test="${empty wdPic.smallPicAddr}">--%>
                			<%--<img src="${ctx}/img/noimg.jpg" width="136" height="130" id="voucher_pic"/>--%>
                		<%--</c:if>                --%>
                  		<%--<br>--%>
                  		<%--<a class="btn btn-success" id="corpLogo" href="#" onclick="show_info(event);">--%>
                    		<%--<i class="icon-file icon-white"></i>  --%>
                    		<%--上传                                      --%>
                  		<%--</a>                --%>
               			<%--</div>--%>
					<%--</td>--%>
				<%--</tr>--%>
			<%----%>
			<%--</table>--%>
		<%--</div>--%>
  	<%--</div>--%>

	<%--</form>--%>
	<%--<input id="localFileName" type="hidden" name="localFileName" value=""/>--%>


<%--<div id="popup" style="z-index:100;display:none" class="message_box" >--%>
<%--<div class="message_box_t">--%>
  <%--<img src="${ctx}/img/message_box_close.png" onclick="javascript:hide_info();" />--%>
<%--</div>--%>
<%--<div class="message_box_m">--%>
  <%--<table>--%>
    <%--<tr>--%>
      <%--<td>--%>
        <%--<div id="queue"></div>完整文件名：--%>
        <%--<input id="showname" name ="showname" type="text" style ="width:100px" readonly="readonly"/>--%>
      <%--</td>--%>
      <%--<td>--%>
        <%--<input id="file_upload" name="file_upload" type="file"/>--%>
      <%--</td>--%>
    <%--</tr>--%>
  <%--</table> --%>
<%--</div>--%>
<%--<div class="message_box_b">--%>
<%--</div>--%>
    
</body>
</html>
  <%--<link rel="stylesheet" type="text/css" href="${ctx}/js/plugins/jquery/uploadifive/uploadifive.css">--%>
<%--</body>--%>