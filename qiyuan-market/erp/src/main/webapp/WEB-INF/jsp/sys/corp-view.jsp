<%@ page language="java" pageEncoding="UTF-8"
  contentType="text/html; charset=UTF-8"%>
 <%@ include file="/common/taglibs.jsp"%>
<%@ include file="/common/meta.jsp"%> 
<link rel="stylesheet" type="text/css" href="${ctx}/css/style.css" />
<link rel="stylesheet" type="text/css" href="${ctx}/js/plugins/bootstrap-3.0.3/css/bootstrap.min.css" />
<script type="text/javascript" src="${ctx}/js/plugins/jquery/jquery.js"></script>
<script type="text/javascript" src="${ctx}/js/plugins/bootstrap-3.0.3/js/bootstrap.min.js"></script>
<script type="text/javascript" src="${ctx}/js/common/ctutil.js"></script>
<script type="text/javascript" src="${ctx}/js/pages/region/region.js"></script>
<script type="text/javascript" src="http://api.map.baidu.com/api?v=2.0&ak=dtKHw89n9CAbG8EorQAIMHPx"></script>
<style>
<!--
.btn5{ display:inline-block; width:104px; text-align:center; border:none; height:38px; line-height:38px; cursor:pointer; font-size:16px; color:#fff; margin-right:10px; background:#0670d6; font-family:"Microsoft YaHei"; -webkit-border-radius: 4px; -moz-border-radius: 4px; border-radius: 4px; }
.btn5:hover{ background:#0964bb; color:#fff; }
.postbtn { text-align:center;}
-->
</style>
<!DOCTYPE html>
<html>
    <head>
        <title>库存位置设置</title>
        <meta name="viewport" content="width=device-width, initial-scale=1">
         <script type="text/javascript" >
         	var proText;
         	var cityText;
         	var countyText;
         	var addressText;
            $(function () {          
              $("#provinceCode").change(function(){
                  load_city_options();
              });
              $("#cityCode").change(function(){
                  load_county_options();
              });             
			
              
			 
             // if(${regionType}==-1){
             //   load_province_options();
             // }else if(${regionType}==0){
             ////   load_province_options();
             //   $("#provinceCode ").val(${provinceCode});
             // }else if(${regionType}==1){
             //   load_province_options();
             //   $("#provinceCode ").val(${provinceCode});
             //   load_city_options();                
             //   $("#cityCode ").val(${cityCode});
            ///  }else if(${regionType}==2){
                load_province_options();
                $("#provinceCode ").val(${provinceCode});
                load_city_options();
                $("#cityCode ").val(${cityCode});   
                load_county_options();                                            
                $("#countyCode ").val(${countyCode});   
            //  }

              function load_province_options(){
                $.ajax({    
                  type:'post',        
                  url:'${ctx}/core/region_provinceLoad.action?status=1',    
                  data:"",    
                  cache:false,    
                  dataType:'json',
                  async : false, //默认为true 异步     
                  success:function(data){
                    var options=create_body_option(data);
                    console.log("the province is :",options);
                    $("#provinceCode").html(options);
                  }    
                }); 
              }

              function load_city_options(){
                var code=$("#provinceCode").val();
                $.ajax({    
                  type:'post',        
                  url:'${ctx}/core/region_cityLoad.action?status=1&code='+code,    
                  data:"",    
                  cache:false,    
                  dataType:'json',
                  async : false, //默认为true 异步     
                  success:function(data){
                    var options=create_body_option(data);
                    $("#cityCode").html(options);
                  }    
                }); 
              }

              function load_county_options(){
                var code=$("#cityCode").val();
                $.ajax({    
                  type:'post',        
                  url:'${ctx}/core/region_cityLoad.action?status=1&code='+code,    
                  data:"",    
                  cache:false,    
                  dataType:'json',
                  async : false, //默认为true 异步     
                  success:function(data){
                    var options=create_body_option(data);
                    $("#countyCode").html(options);
                  }    
                }); 
              }             

              function create_option(data,value,name){
                var result=create_head_option(value,name);
                 result+=create_body_option(data);
                return result;
              }

              function create_body_option(data){
                var result="";
                for(var i=0;i<data.length;i++){
                  result+="<option value=\""+data[i].id+"\">"+data[i].name+"</option>";
                }                
                return result;
              }
              
              
              
	              proText=$('#provinceCode').find("option:selected").text();  
	              cityText=$('#cityCode').find("option:selected").text();  
	              countyText=$('#countyCode').find("option:selected").text();  
	              addressText=$("#address").val();
               
               var lng=${lng};
               var lat=${lat};
               if(lng!=0 && lat!=0){
				// 百度地图API功能
				var map = new BMap.Map("container"); // 创建Map实例
				var point = new BMap.Point(lng,lat); // 创建点坐标
				map.centerAndZoom(point,15); // 初始化地图,设置中心点坐标和地图级别。
				map.addControl(new BMap.NavigationControl()); // 添加平移缩放控件
				map.addControl(new BMap.ScaleControl()); // 添加比例尺控件
				map.addControl(new BMap.OverviewMapControl()); //添加缩略地图控件
				var opts = {
				  width : 100,     // 信息窗口宽度
				  height: 40,     // 信息窗口高度
				  title : "" , // 信息窗口标题
				  enableMessage:false,//设置允许信息窗发送短息
				  message:""
				}
				var addr=addressText;
				var infoWindow = new BMap.InfoWindow(addr, opts);  // 创建信息窗口对象
				map.openInfoWindow(infoWindow,point); //开启信息窗口
               }else{
               		 $(container).hide(1000);
               }
            });

       
        function do_submit() { 
          var name=$('#name').val();
          console.log("the name is ",name);
          if(name==""){
            alert("请填写公司名称！");
            $('#name').focus();
            return;
          }
                      
          var formData=$('#userform').serialize();
          console.log("the formData is :%o",formData);     
          $.ajax({    
              type:'post',        
              url:'${ctx}/sys/corp_save.action',    
              data:formData,    
              cache:false,    
              dataType:'json',
              async : false, //默认为true 异步     
              success:function(data){
                if(data.code==1){
                  alert('操作成功');
	                  $.ajax({    
			              type:'post',        
			              url:'${ctx}/sys/corp_getXY.action',    
			              data:'',    
			              cache:false,    
			              dataType:'json',
			              async : false, //默认为true 异步     
			              success:function(data){
			                  var lng=data.x;
				               var lat=data.y;
				               if(lng!=0 && lat!=0){
								// 百度地图API功能
								var map = new BMap.Map("container"); // 创建Map实例
								var point = new BMap.Point(lng,lat); // 创建点坐标
								map.centerAndZoom(point,15); // 初始化地图,设置中心点坐标和地图级别。
								map.addControl(new BMap.NavigationControl()); // 添加平移缩放控件
								map.addControl(new BMap.ScaleControl()); // 添加比例尺控件
								map.addControl(new BMap.OverviewMapControl()); //添加缩略地图控件
								var opts = {
								  width : 100,     // 信息窗口宽度
								  height: 40,     // 信息窗口高度
								  title : "" , // 信息窗口标题
								  enableMessage:false,//设置允许信息窗发送短息
								  message:""
								}
								var addr=data.addr;
								var infoWindow = new BMap.InfoWindow(addr, opts);  // 创建信息窗口对象
								map.openInfoWindow(infoWindow,point); //开启信息窗口
				               }else{
				               		 $(container).hide(1000);
				               }
	          			}    
	          		}); 
                }else{
                  alert('操作失败');
                }   
              }    
          });           
          
        }
        </script>
    </head>
    <body>
<div class="box">
  <form role="form" id="userform" name="userform">
   <input type="hidden" name="corp.id" id="id" value="${corp.id}"/>
  <table>
    			<tr>
					<td class="text-r" width="158">公司名称：</td>
					<td width="430"><input type="input" class="input w200" name="corp.name" id="name"  value="${corp.name}"></td>
				</tr>
				<tr>
					<td class="text-r" width="158">联系人：</td>
					<td width="430">
						<input type="input" class="input w200" name="corp.contact" id="contact"  value="${corp.contact}">
					</td>
				</tr>
				<tr>
					<td class="text-r" width="158">公司电话：</td>
					<td width="430">
						<input type="input" class="input w200" name="corp.phone" id="phone"  value="${corp.phone}">
					</td>
				</tr>
        <tr>
          <td class="text-r" width="158">最大允许账户数：</td>
          <td width="430">
            <input type="input" class="input w200" readonl="true" disabled="true" value="${corp.authCnt}">
            <a href="#">如何申请更多？</a>
          </td>

        </tr>
				<tr>
					<td class="text-r" width="158">选择地区：</td>
					<td>
						<select id="provinceCode" class="input w200" name="provinceCode"></select>
                        <select id="cityCode"  class="input w200" name="cityCode">
                        </select> 
                        <select name="countyCode" id="countyCode"  class="input w200">
                        </select> 
					</td>
				</tr>
    	    	<tr>
					<td class="text-r" width="158"></td>
					<td width="430">
						<textarea class="area" rows="3" id="address"  name="corp.address"  >${corp.address}</textarea>
					</td>
				</tr>		
				<tr>
					<td class="text-r" width="158">地图：</td>
					<td width="430">
					<div style="width:620px;height:340px;border:1px solid gray;" id="container"></div>
						
					</td>
				</tr>			
				<tr>
					<td colspan="2" align="center">
					<div class="postbtn">		
						<input type="button" id="btn_load_ok"  class="btn5" onclick="javascript:do_submit();" value="确定"/>
						</div>
					</td>
				</tr>	
			</table>
			</form>
  

        
</div>
    </body>
</html>

