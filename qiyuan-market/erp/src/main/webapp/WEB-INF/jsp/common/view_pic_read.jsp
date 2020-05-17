<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%@include file="/taglibs.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<base href="<%=basePath%>" />
		<title>上载附件</title>
		<meta http-equiv="pragma" content="no-cache" />
		<meta http-equiv="X-UA-Compatible" content="IE=7" />
		<meta http-equiv="cache-control" content="no-cache" />
		<meta http-equiv="expires" content="0" />
		<meta http-equiv="keywords" content="keyword1,keyword2,keyword3" />
		<meta http-equiv="description" content="This is my page" />
		<link href="${ctx }/common/css/public.css" rel="stylesheet"	type="text/css" />
		<link href="${ctx }/common/css/reset.css" rel="stylesheet"	type="text/css" />
		<script type="text/javascript" language="javascript" src="${path}/common/js/jquery-1.6.2.js"></script>
		<script type="text/javascript" src="${path}/common/js/attention/dialog/zDrag.js"></script>
		<script type="text/javascript" src="${path}/common/js/attention/dialog/zDialog.js"></script>
		<link rel="stylesheet" type="text/css" href="${ctx}/common/js/upload/uploadify.css"/> 
		<script type="text/javascript" language="javascript" src="${ctx}/common/js/upload/jquery.uploadify.js"></script>	
		
		
		<style>
.tab {
	font-weight: bold;
	background: url(${ctx}/common/images/tab_list_bg.png);
	height: 30px;
	line-height: 30px;
	text-align: center;
	color: #313f52;
	font-size: 13px
}
</style>
		<script type="text/javascript">
			var api = frameElement.api, W = api.opener;
			function doSomething(id){
				//console.log("the W is %o",W);
				//W.doSomething(id);
				var operateType=$("#operateType").val();
				if(operateType==0){
					W.doSomething(id);
					api.get('the_list_dialog',1).close();
				}else if(operateType==1){
					api.get('the_list_dialog').doSomething(id);
					api.get('the_wdg_dialog',1).close();
				}
			}
			function deleteButton(id){
				W.deleteButton(id);
			}
			
			
			
			function do_submit(){
				api.get('the_list_dialog',1).close();
	    	}
	    	
	    	$(document).ready(function() {
				initUpload();
			});
			/*设置客户端的高和宽*/  
			function getClientBounds(){   
				var clientWidth;   
				var clientHeight;   
				   
				clientWidth = document.compatMode == "CSS1Compat" ? document.documentElement.clientWidth : document.body.clientWidth;   
				clientHeight = document.compatMode == "CSS1Compat" ? document.documentElement.clientHeight :   document.body.clientHeight;   
					   
				return {width: clientWidth, height: clientHeight};   
			}  
			/*显示上传附件对话框*/
			function showInfo()
			{
				floatArea=document.getElementById("popup");      
				var rr=new getClientBounds();  			
		 		floatArea.style.display="block";
				var ileft = (rr.width-floatArea.clientWidth)/2+document.body.scrollLeft;
				var itop =(rr.height-floatArea.clientHeight)/2+document.body.scrollTop;
			    $("#popup").css({"z-index":"100", "position": "absolute",left :ileft, top: itop}); 
		   	}
			/*隐藏上传附件对话框*/		
			function hideInfo()
			{
			   document.getElementById("showname").value ="";
			   floatArea=document.getElementById("popup");
			   floatArea.style.display="none";
			}  
		     //初始化附件上传控件
		     function initUpload()
		     {
				$('#file_upload').uploadify(
				{
						'formData': 
						{
							 'vehicleId':'${vehicleId}',
							 'localFileName':'',
							 'displayOrder':0,
							 'localFileSize':0,
							 'attachType':'${attachType}'
						},
						'onUploadStart' : function(file) 
						{
		                     $('#file_upload').uploadify('settings', 'formData', 
		                         {'localFileName':document.getElementById('localFileName').value,
		                          'displayOrder':0,
		                          'localFileSize':file.size,
		                          'attachType':'${attachType}'  //1-上传车辆图片，2上传销售附件
		                         });
		                },
		                'onSelect': function(file) {
		                    document.getElementById("localFileName").value =file.name;
		                    document.getElementById("showname").value = file.name;
		                    if(file.size > 1024*1024) 
		                    {
		                      alert("上传文件大小不能超过1MB, 您当前选择的文件 "+file.name+" 大小为"+Math.floor(file.size/1024)+"KB");
		                      return false; 
		                    }
		                },
		                'onUploadSuccess':
				        function(file, data, response) {
		 		           var attach =  eval('(' + data + ')');
		 		           var pic = eval('(' + data + ')');
		 		           var html ="";
				           var uploadType =attach.uploadType;
				           if(uploadType =="pic")
			               {
			                  //html =" <div><img class='imgShow' src="+pic.picAddr+" id="+pic.displayOrder +" /></div>";
			                  html ="<div ><img class='imgShow' src="+pic.picAddr+" id="+pic.displayOrder +" /></div>"
				                  +" <div class='img-delect-btn'>"
				                  +" <img src='${path}/common/images/delect-btn.png' id="+pic.picId+"  onclick='delPic(event);' />"
				                  +"</div> ";
				               jQuery("input[name='evalPicId']").val(pic.picId);
				              $("#imgDiv").html(html);
			               }
			               $('#file_upload').uploadify('cancel');
			               hideInfo();
			            } ,
			            'fileDesc'       : '支持格式:jpg/gif/jpeg/png.', //如果配置了以下的'fileExt'属性，那么这个属性是必须的 
			            'fileExt'        : '*.jpg;*.gif;*.jpeg;*.png',//允许的格式
			            'sizeLimit'      : 1024 * 1024,  //文件大小为500KB
			            'auto'           : true,
			            'fileObjName'    : 'localFile', 
			            'buttonText'     : '点击选择图片',
						'swf'            : '${ctx}/common/js/upload/uploadify.swf',
					    'uploader'       : '${path}/commMgr/comm!uploadFile.action'
					});	 
		     };
	    	//添加图片
			function addPic(event)
			{
			
		       var e = event || window.event;
		       var element = e.srcElement || e.target;
		       //记录图片的显示位置
		       //弹出选择文件对话框
		       showInfo();
			}
			function delPic(event)
		    {
		       if(!confirm("确定删除该图片吗?")) return;
		       var e = event || window.event;
		       var element = e.srcElement || e.target;
		       var params = {"attachId":element.id,"vehicleId":${vehicleId}};
		       jQuery.post("${path}/commMgr/comm!doDelPic.action",params,function(data){
		           if (data<0)
		           {
		             alert("图片删除失败,请稍后重试!");
		             return;
		           }
			       var html ='<a href="javascript:void(0);" id="alink" class="add_img"  style="margin-top:180px"><img name="resImg" id="resImg" src="${path }/common/images/jia.png" onclick="addPic(event);"/></a>';
			       jQuery("input[name='evalPicId']").val("");
				   $("#imgDiv").html(html);
			       alert("图片删除成功!");    
			        deleteButton(element.id);
		       api.get('the_list_dialog',1).close();
		       });
		      
		    }
		    
		   
    </script>
	</head>
	<body>
		<!--top_right-->
		<div>
			<input type="hidden" name="evalPicId" value="${attachId }"/>
			<input type="hidden" name="operateType" id="operateType" value="${operateType }"/>
			<input id="localFileName" type="hidden" name="localFileName" value=""/>
			<div id="popup"  style="z-index:100;display:none" class="message_box" >
		        <div class="message_box_t"><img src="${path}/common/images/message_box_close.png" onclick="javascript:hideInfo();" /></div>
			    <div class="message_box_m">
			         <table>
			         <tr>
			         <td>
					     <div id="queue"></div>
					             完整文件名：
					     <input id="showname" name ="showname" type="text" style ="width:300px" />
				     </td>
				     <td>
				          <input id="file_upload" name="file_upload" type="file" multiple="true" />
				     </td>
			 
			    	 </tr>
			    	 </table> 
				</div>
			   <div class="message_box_b"> </div>
			</div>
			<div class="tc_bottom-img">
				<div class="tabtop-import-img">

					<div id="imgDiv" style="height:450px; overflow:auto; width:790px;">
						 <c:if test="${type == 1}">
						 	<a href="javascript:void(0);" id="alink" class="add_img"  style="margin-top:180px"><img name="resImg" id="resImg" src="${path }${attachment.attachAddr}" onclick="addPic(event);"/></a>
						 </c:if>
						 <c:if test="${type == 2}">
						 	<c:if test="${empty attachId}">
						 		<a href="javascript:void(0);" id="alink" class="add_img"  style="margin-top:180px"><img name="resImg" id="resImg" src="${path }${attachment.attachAddr}" onclick="addPic(event);"/></a>
						 	</c:if>
						 	<c:if test="${not empty attachId}">
						 		<div >
						 			<img class='imgShow' src="${attachment.attachAddr }"  />
						 		</div>
				                <div class='img-delect-btn'>
				               	 	<img src='${path}/common/images/delect-btn.png' id="${attachId}" value="${attachment.attachName}"  onclick='delPic(event);' />
				                </div>
						 	</c:if>
						 </c:if>
					</div>
					
				</div>
			</div>
		</div>
		<!--top_right over-->
		<script type="text/javascript" language="javascript"
			src="${ctx}/common/js/My97DatePicker/WdatePicker.js" defer="defer"></script>
	</body>
</html>

