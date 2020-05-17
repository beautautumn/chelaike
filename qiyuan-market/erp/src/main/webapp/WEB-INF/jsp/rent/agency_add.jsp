<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@taglib uri="/struts-tags" prefix="s"%>
<%@ include file="/common/taglibs.jsp"%>
<%@ include file="/common/meta.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>新增商户</title>
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
<link rel="stylesheet" type="text/css" href="${ctx}/js/plugins/jquery/uploadifive/uploadifive.css"/>
<script src="${ctx}/js/plugins/jquery/uploadifive/jquery.uploadifive.js"></script>
 
<style type="text/css">
.message_box{ width:300px;height:120px;overflow:hidden;}
.message_box_t{ width:25px; padding-left:275px; background:url(../img/message_box_top.png); height:20px; padding-top:10px;}
.message_box_m{ width:280px; padding:10px; background:url(../img/message_box_body.png);text-align:left; line-height:35px; font-size:14px;}
.message_box_b{ width:300px; background:url(../img/message_box_bottom.png); height:30px;}
</style>

<script>
	var picIndex = 0;
	var nameCheckResult = "";
	var phoneCheckResult = "";
	var userCheckResult = "";
	var api = frameElement.api, W = api.opener;
	
	function checkUserPhone(userPhone){
		phoneCheckResult = "ok";
		var val = $(userPhone).val();
		if(val == null || val == ""){
			alert("手机号不能为空！");
			phoneCheckResult = "fail";
            return;
        }
        var reg = /^(13[0-9]|14[5|7]|15[0|1|2|3|5|6|7|8|9]|18[0|1|2|3|5|6|7|8|9])\d{8}$/;
        if(!reg.test(val)){
			alert("手机号码格式不正确！");
            phoneCheckResult = "fail";
            return;
        }
	}
	
	function checkUserName(userName){
		userCheckResult = "ok";
		var val = $(userName).val();
		if(val == null || val == ""){
            		return;
        }
        var reg = /^[\u4E00-\u9FA5A-Za-z0-9_]{1,20}$/;
        if(!reg.test(val)){
			alert("商户负责人格式不正确！");
            userCheckResult = "fail";
            return;
        }
	}
	
	function checkAgencyName(agencyName){
		nameCheckResult = "ok";
		var val = $(agencyName).val();
		if(val == null || val == ""){
			$(".anameerror").html("商户名称不能为空！").show();
            nameCheckResult = "fail";
            return;
        }
        var reg = /^[\u4E00-\u9FA5A-Za-z0-9_]{1,20}$/;
        if(!reg.test(val)){
        	$(".anameerror").html("商户名称格式不正确！").show();
            nameCheckResult = "fail";
            return;
        }
        var data ="agencyName="+val;
        $.ajax({
				cache: false,
				type: "POST",
				url:ctutil.bp()+"/rent/agency_checkName.action",
				data:{"agencyName":val,"agencyId":'0'},
				async: false,
				error: function() {
				html = "数据请求失败";
				},
				success: function(data) {
				  if(data=="fail"){
					$(".anameerror").html("商户名称重复！").show();
           			nameCheckResult = "fail";
            		return;  
				  }else{
					  $(".anameerror").html("").hide();
				  }
				}
			});
	}
	
	
	
	function checkAccount(account){
		var val = $(account).val();
		var myReg = /^[\u4e00-\u9fa5]+$/;
		if (myReg.test(val)) {
	        if(val.length<2){
	        	$(".nameerror").html("中文账号不得少于2位，请重新输入").show();
				return;
		    }
        }else{
        	if(val.length==0){
         		$(".nameerror").html("请输入账号").show();
				return;
		     }else if(val.length<4){
         		$(".nameerror").html("英文账号不得少于4位，请重新输入").show();
				return;
		     }
        }
		$.ajax({
			url:ctutil.bp()+"/rent/agency_checkAccount.action",
			type:"post",
			data:{account:val},
			success:function(data){
				if(data=="false"){
					$(".nameerror").html("用户名重复，请重新输入").show();
					return;
				}else{
					$(".nameerror").html("").hide();
				}
			}
		});
	}
	
	function checkPwd(pwd){
		var val = $(pwd).val();
		var val1 = $("#confPwd").val();
		if(val == null || val == ""){
			$(".pwd1error").html("密码不能为空").show();
			return;
		}else if(val != val1){
			$(".pwd1error").html("两次输入密码不一致，请重新输入").show();
			return;
		}else{
			$(".pwd1error").html("").hide();
			$(".pwd2error").html("").hide();
		}
		/* var val = $(pwd).val();
		if(val == null || val == ""){
			$(".pwd1error").html("密码不能为空").show();
			return;
		}else{
			$(".pwd1error").html("").hide();
		} */
	}
	
	function checkConfPwd(pwd){
		var val = $(pwd).val();
		var val1 = $("#pwd").val();
		if(val == null || val == ""){
			$(".pwd2error").html("密码不能为空").show();
			return;
		}else if(val != val1){
			$(".pwd2error").html("两次输入密码不一致，请重新输入").show();
			return;
		}else{
			$(".pwd1error").html("").hide();
			$(".pwd2error").html("").hide();
		}
	}
	
	var upload_type = ""; //上传操作类型  add:新传图片 edit:编辑图片
    $(document).ready(function() {
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
            //'corpConf.confId':'${corpConf.confId}',
            'localFileSize':1258287
          };
        },
        'onUploadComplete': function(file, data) 
        {
          console.log("onUploadComplete is called!%o",data);

          var pic = eval('(' + data + ')');
          console.log("the pic is %o",pic);
          if(pic){
          	var html = rebuild_display_html(pic.smallPicAddr, pic.picId);
            $("#mainLogo_img").before(html);
          }          
          $('#file_upload').uploadifive('clearQueue');
          hide_info();

        },              
        'fileSizeLimit' : '5MB',
        'auto'  : true,
        'fileObjName' : 'fileObj', 
        'buttonText'  : '点击选择图片',        
        'uploadScript' : '${ctx}/rent/agency_upload.action?'
      });
     };     

	function rebuild_display_html(pic_url, pic_id) 
    { 
      var html = "";
        html +="&nbsp;&nbsp;<img src='"+pic_url+"' width='100' height='100' '/>"+
			   "<input type='hidden' name='picIdList["+picIndex+"]' value='"+pic_id+"'/>";
	  picIndex++;
      return html;
    }

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
      var ileft = (rr.width - floatArea.clientWidth)/4 + document.body.scrollLeft;
      floatArea.style.display = "block";
      $("#popup").css({"z-index":"100", "position": "absolute", left : ileft-50, top: p.y-50}); 
    }  

    /*隐藏上传附件对话框*/   
    function hide_info() {       
       $("#showname").val("");
       document.getElementById("popup").style.display = "none";
    }    
	
    var flag = false;
    
	function do_submit(){
		if(flag){
			return;
		}
		/* if($(".nameerror").html()!="" || $(".pwd1error").html()!="" || $(".pwd2error").html()!=""){
			alert("表单填写不正确！");
			return;
		} */
		var data ="";
		if(nameCheckResult=="" || nameCheckResult==null || phoneCheckResult=="fail"){
			alert("表单未填写完整！");
			return;
		}/* else if(nameCheckResult=="fail" || userCheckResult=="fail" || phoneCheckResult=="fail") {
			alert("表单填写不正确！");
			return;
		} */else{
			data = $("#myForm").serialize();
			ajaxPost(data);
		}
	
	}
	
	function ajaxPost(data){
		$.ajax({
				cache: false,
				type: "POST",
				url:ctutil.bp()+"/rent/agency_add.action",
				data:data,
				async: false,
				error: function() {
				html = "数据请求失败";
				},
				success: function(data) {
				  if(data=="success"){
					  flag = true;
					  alert("保存成功！");
					  api.get("new_agency",1).close();
					  W.query1();  
				  }else if(data=="overlap"){
					  alert("重复提交数据！");
					  api.get("new_agency",1).close();
					  W.query1();
				  }else if(data == "error"){
					  alert("保存失败！");
					  // api.get("new_agency",1).close();
					  // W.query1();
				  }else{
					  alert(data);
				  }
				}
			});
	}
	
</script>

</head>
<body>
<form id="myForm">	
<div class="box">
	
			<table>	
				<%-- <tr>
					<td class="text-r" width="100px" ><span class="red">*</span>用户名：</td>
					<td width="400px"><input class="input w200" id="account" name="agency.account" value="${agency.account}" onblur="checkAccount(this);"/><font class="nameerror" color="red" style="display:none;"></font></td>
				</tr>
				<tr>
					<td class="text-r" width="100px" ><span class="red">*</span>密码：</td>
					<td width="400px"><input class="input w200" type="password" id="pwd" name="agency.pwd" value="${agency.pwd}" onblur="checkPwd(this);"/><font class="pwd1error" color="red" style="display:none;"></font></td>
				</tr>
				<tr>
					<td class="text-r" width="100px" ><span class="red">*</span>确认密码：</td>
					<td width="400px"><input class="input w200" type="password" id="confPwd" name="confPwd" value="${agency.pwd}" onblur="checkConfPwd(this);"/><font class="pwd2error" color="red" style="display:none;"></font></td>
				</tr> --%>
				<tr>
					<td class="text-r" width="100px" ><span class="red">*</span>商户名称：</td>
					<td width="400px"><input class="input w200" id="agencyName" name="agency.agencyName" value="${agency.agencyName}" onblur="checkAgencyName(this);"/><font class="anameerror" color="red" style="display:none;"></font></td>
				</tr>
			</table>
			<table>
				<tr>
					<td class="text-r" width="100px" >商户图片：</td>
					<td style="word-break:break-all" width="400px">
						<img src="${ctx}/images/upload.png"  width="100" height="100" id="mainLogo_img" onclick="show_info(event);"/>        
					</td>
				</tr>
			</table>
			<table>
				<tr>
					<td class="text-r" width="100px" id="areaTotal">商户负责人:</td>
					<td width="400px"><input class="input w200" id="userName" name="agency.userName" value="${agency.userName}" onblur="checkUserName(this);"/></td>
				</tr>
				<tr>		
					<td class="text-r" width="100px" id="feeMeter"><span class="red">*</span>联系电话:</td>
					<td width="400px"><input class="input w200" id="userPhone" name="agency.userPhone" value="${agency.userPhone}" onblur="checkUserPhone(this);"/></td>
				</tr>
				<tr> 
					<td class="text-r" width="100px">商户描述:</td>
					<td width="400px"><textarea id="remark" style="width:280px;height:120px" name="agency.remark" value="${agency.remark}"/></textarea></td>
				</tr>
		</table>
</div>	
	
</form>	

<input id="localFileName" type="hidden" name="localFileName" value=""/>


<div id="popup" style="z-index:1000;display:none" class="message_box" >
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
				
</body>
</html>
