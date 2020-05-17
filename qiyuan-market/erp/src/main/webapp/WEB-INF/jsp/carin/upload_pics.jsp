<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"	language="java"%>
<%@taglib uri="/struts-tags" prefix="s"%>
<%@ include file="/common/taglibs.jsp"%>
<%@ include file="/common/meta.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<title>上传图片</title>
		<link rel="stylesheet" type="text/css" href="${ctx}/css/style.css" />
		<link rel="stylesheet" type="text/css" href="${ctx}/js/plugins/uploadify/uploadify.css" />
		<script	src="${ctx}/js/plugins/uploadify/jquery.uploadify.js"></script>
    <script type="text/javascript">
      var api;
      try{
        api = frameElement.api, W = api.opener;
      } catch(err) {}

      var pic_show_tags = ""; //当前页面已选中的"设为首页"标记
      var upload_type = ""; //上传操作类型  add:新传图片 edit:编辑图片
      var curr_upload_ids = "";  //当次上传图片ID
      var img_id = "";  //上传图片id
      var img_li_id = ""; //包含当次上传图片的li元素的id
      var display_order = 0;  //显示顺序
      var pic_kind = -1;  //图片类型

      $(document).ready(function() {
        upload_type = '${uploadType}';
        size = '${length}';
        init_attaches();

        $('input[type="file"]').attr(
          'accept',
          'image/gif, image/jpeg, image/jpg, image/png, .gif, .jpeg, .jpg, .png'
        );

      });

    function init_attaches() {
      var picList = eval('${pics}');   
      if(picList != undefined) {
        for(i=0; i < picList.length; i++) {
          var pic = picList[i];
          var html = rebuild_display_html(pic.showOrder, pic.picAddr, "", pic.picId, pic.showOrder,pic.publishTag,pic.isFront);
          $("#li_new").before(html);
          $("input[name='delePic']:checkbox").click(function(){
        	  var flag=false;
        	  var flag2=false;
        	  $("input[name='delePic']:checkbox").each(function(){
        	  	if($(this).is(":checked")){
        	  		flag=true;
        	  	}else{
        	  		flag2=true;
        	  	}
        	  });
        	  if(flag && !flag2){
        		  $("#selall").prop("checked",true);
        	  }else{
        		  $("#selall").prop("checked",false);
        	  }
        	  /* if($(this).is(":checked")){}else{
	       	  	$("#selall").prop("checked",$(this).is(":checked"));
        	  } */
       	  });
          $("#"+pic.picId).val(pic.picKind);
        }
      }
    }

    function rebuild_display_html(show_order, pic_addr, display_name, pic_id, show_tag, pub_tag,isFront)
    {
        var html = "";
        html += "<li id='li_"+ pic_id +"'><div class='t'>" +
                  "<span>" +
                    "<img src='"+ pic_addr +"'/>" +
                  "</span>" + display_name + "</div>" +
                  "<div class='fl'>";
        var first_pic_id = "setFirstPic_" + pic_id;

        html += "<input type='checkbox' name='delePic' id='delePic_"+ pic_id +"'" +
            " />" +
            "<label for='delePic'>删除</label>";
        if(pub_tag=="1"){
	        html += "<input type='checkbox' name='publishPic' id='publishPic_"+ pic_id +"' checked='checked'" +
	        " onclick=\"publishPic(\'publishPic_"+ pic_id +"\')\" />" +
	        "<label for='publishPic'>网站显示</label>";
        }else{
        	html += "<input type='checkbox' name='publishPic' id='publishPic_"+ pic_id +"'" +
	        " onclick='publishPic(\"publishPic_"+ pic_id +"\")' />" +
	        "<label for='publishPic'>网站显示</label>";
        }
        if(isFront=="1"){
        	html += "<input type='radio' name='isFrontPic' id='isFrontPic_"+ pic_id +"' checked='checked'" +
	        " onclick=\"setFront(\'isFrontPic_"+ pic_id +"\')\" />" +
	        "<label for='publishPic'>首图</label>";
        }else{
        	html += "<input type='radio' name='isFrontPic' id='isFrontPic_"+ pic_id +"'" +
	        " onclick=\"setFront(\'isFrontPic_"+ pic_id +"\')\" />" +
	        "<label for='publishPic'>首图</label>";
        }
        return html;
    }
    
    function publishPic(id){
    	var obj = $("#"+id);
    	var pubTag;
    	if(obj.attr("checked")=="checked"){
    		pubTag="1";
    	}else{
    		pubTag="0";
    	}
    	
        var pic_id = id;
        var id = pic_id.substr(pic_id.indexOf("_")+1, pic_id.length);
    	
    	var params = {"picIds": id, 'tradeId':'${tradeId}', 'pubTag':pubTag};
        
        $.post("${ctx}/carin/vehicleInput!doPublishPic.action", params, function(data){
          console.log("the data is %o",data);
          if(data == "error") {
            alert('图片发布失败');
            return;
          }
        });
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
          'image/gif, image/jpeg, image/jpg, image/png, .gif, .jpeg, .jpg, .png'
      );

      var floatArea = document.getElementById("popup");
      var rr = get_client_bounds();
      var p = get_mouse_pos(event);
      var ileft = (rr.width - floatArea.clientWidth)/2 + document.body.scrollLeft-100;
      floatArea.style.display = "block";
      $("#popup").css({"z-index":"9999", "position": "absolute", left : ileft, top: p.y});
    }

    function set_show_tags(first_pic_chk) {
      $("input[name='setFirstPic']:checkbox").each(function() {
        if($(this)[0].id != first_pic_chk.id)
        {
          $(this).attr("checked", false);
        }
      })
      $("#" + first_pic_chk.id).attr("checked", true);
    }

    function add_pic(event)
    {
      var e = event || window.event;
      var img_element = e.srcElement || e.target;
      img_id = img_element.id;
      show_info(event);
    }

    function del_pic(pic_id) {
      if(!confirm("确定删除该图片吗?")) return;

      var params = {"vehiclePicId": pic_id, 'vehicleId':'${tradeId}'};
      $.post("${ctx}/stock/vehiclePic_doSingleDelete.action", params, function(data){
        if(data == "1000") {
          alert('图片删除失败');
          return;
        } else {
          var deleteImg = $("img[src='" + data + "']");
          var li_emelent = deleteImg.parent().parent().parent();
          var li_emelent_id = li_emelent[0].id;
          var int_li_emelent_id = parseInt(li_emelent_id.substr(li_emelent_id.indexOf("_")+1, li_emelent_id.length));
          if(int_li_emelent_id > 17)
          {
            li_emelent.remove();
          } else {
            var del_html = rebuild_del_html(li_emelent_id);
            li_emelent.html(del_html);
          }
           
        }
      });
    }
            
    /*隐藏上传附件对话框*/
    function hide_info() {
       $("#showname").val("");
       document.getElementById("popup").style.display = "none";
    }

    function rebuild_del_html(li_id) {
      var html = "";
      var img_src_subfix = '';
      var img_src = '';
      var img_title = '';
      var update_img_id = '';

      img_src =  '${ctx}/img/upload_img/' + img_src_subfix;
      html += "<div class='t'>" +
                "<span>" +
                  "<img id='"+update_img_id+"' class='upload_img' src='"+img_src+"' onclick='javascript:add_pic(event);'/>" +
                "</span>" +
                "<span id='img_tit_'>"+img_title+"<span>"+
              "</div>" +
              "<div class='clear'></div>";
      return html;
    }

    function rebuild_add_html(pic_id, pic_addr, display_name, show_tag) {
      var html = "";
      html += "<li id='li_"+ pic_id +"'><div class='t'>" +
                "<span>" +
                  "<img src='"+ pic_addr +"'/>" +
                "</span>" + display_name + "</div>" +
                "<div class='fl'>";
      var first_pic_id = "setFirstPic_" + pic_id;
 


      html += "<input type='checkbox' name='delePic' id='delePic_"+ pic_id +"'" +
            " />" +
            "<label for='delePic'>删除</label>";
      html += "<input type='checkbox' name='publishPic' id='publishPic_"+ pic_id +"' checked='checked'" +
      " onclick='publishPic()' />" +
      "<label for='publishPic'>网站显示</label>";
      html += "<input type='radio' name='isFrontPic' id='isFrontPic_"+ pic_id +"'" +
      " onclick=\"setFront(\'isFrontPic_"+ pic_id +"\')\" />" +
      "<label for='publishPic'>首图</label>";
 
	    size++;
      return html;
    }
    
    function setFront(id){
    	var obj = $("#"+id);
    	var isFront;
    	if(obj.attr("checked")=="checked"){
    		isFront="1";
    	}else{
    		isFront="0";
    	}
    	
        var pic_id = id;
        var id = pic_id.substr(pic_id.indexOf("_")+1, pic_id.length);
    	
    	var params = {"picId": id, 'tradeId':'${tradeId}', 'isFront':isFront};
        
        $.post("${ctx}/carin/vehicleInput!doSetFront.action", params, function(data){
          console.log("the data is %o",data);
          if(data == "error") {
            alert('设置首图失败');
            return;
          }
        });
    }
    
    function sleep1(n) {
      var start = new Date().getTime();
      while(true)  if(new Date().getTime()-start > n) break;
    }

     var fin_pic=[];
     $(function() {
      $('#file_upload').uploadify({
        'formData'     : {
          'tradeId':'${tradeId}'
        },
        'swf'      : '${ctx}/js/plugins/uploadify/uploadify.swf',
        'uploader' : '${ctx}/carin/vehicleInput!doUploadVehiclePic.action?',
        'multi' : true,
        'removeCompleted' : true,
        'fileType': ['image/png', 'image/jpg', 'image/jpeg', 'image/gif'],
        'onUploadStart' : function(file) {
            display_order++;       
            var formData ={} ;
            formData.showOrder =display_order;
            formData.localFileName =file.name;
            formData.localFileSize =file.size;
            $("#file_upload").uploadify("settings", "formData", formData);
         
        },
        'onUploadSuccess' : function(file, data, response) {
          sleep1(1000);
          console.log("onUploadComplete, data is: %o", data);   
          var pic = eval('(' + data + ')');
          fin_pic[fin_pic.length]=pic;      
        },
        'onUploadComplete': function(file, data)
        {
        
         
        },
        'onQueueComplete' : function(uploads) {
           // console.log("onQueueComplete is called! uploads is: %o", uploads);
            //$('#file_upload').uploadify('clearQueue');
            hide_info();
            for(var i=0;i<fin_pic.length;i++){
              var pic=fin_pic[i];
              var rebuilded_html = rebuild_add_html(pic.picId, pic.smallPicAddr, "", pic.showOrder);
              console.log("onUploadComplete, rebuilded_html is: %s", rebuilded_html);
              $("#li_new").before(rebuilded_html);

            }
            fin_pic=[];
        },
        'fileSizeLimit' : '100MB',
        'auto'  : true,
        'simUploadLimit' : 1,
        'fileObjName' : 'fileObj',
        'buttonText'  : '点击选择图片',
        'uploadScript' : '${ctx}/carin/vehicleInput!doUploadVehiclePic.action?'
      });
    });
 

 	 function do_submit()
	 {
		  api.get("uploadVehiclePic",1).close();
		  W.query1();  
	 }

    function delete_checked_pic(){
      var idx="";
      $("input[name='delePic']:checked").each(function(){
    	  var a =1;
    	  size--;
        var pic_id = this.id;
        idx += pic_id.substr(pic_id.indexOf("_")+1, pic_id.length);
        idx+=",";
      });
      
      if(idx!=""&&idx.length>0){
        idx=idx.substring(0,idx.length-1);
      }
      console.log("the idx is %o",idx);

      if(idx==""){
        alert("请选择要删除的图片！");
        return ;
      }
      if(!confirm("确定删除该图片吗?")) return;      
      var params = {"picIds": idx, 'tradeId':'${tradeId}'};
      console.log("the params is %o",params);
      
      $.post("${ctx}/carin/vehicleInput!doDelVehiclePic.action", params, function(data){
        console.log("the data is %o",data);
        if(data == "error") {
          alert('图片删除失败');
          return;
        } else {
          var ids=idx.split(",");
          for(var id in ids){
            $("#li_"+ids[id]).remove();
          }
          $("#selall").attr("checked",false);
        }
      });
    }
    
    
    function publish_checked_pic(){
        var idx="";
        $("input[name='publishPic']:checked").each(function(){
      	  var a =1;
      	  size--;
          var pic_id = this.id;
          idx += pic_id.substr(pic_id.indexOf("_")+1, pic_id.length);
          idx+=",";
        });
        
        if(idx!=""&&idx.length>0){
          idx=idx.substring(0,idx.length-1);
        }
        console.log("the idx is %o",idx);

        if(idx==""){
          alert("请选择要发布的图片！");
          return ;
        }
        /* if(!confirm("确定删除该图片吗?")) return;   */    
        var params = {"picIds": idx, 'tradeId':'${tradeId}'};
        console.log("the params is %o",params);
        
        $.post("${ctx}/carin/vehicleInput!doPublishPic.action", params, function(data){
          console.log("the data is %o",data);
          if(data == "error") {
            alert('图片删除失败');
            return;
          } else {
            var ids=idx.split(",");
            $("#selall").attr("checked",false);
          }
        });
      }

    function selall(){
    	$("input[name='delePic']:checkbox").prop("checked",$("#selall").is(":checked"));
    }
  </script>
  
  
<style type="text/css">
.message_box {
	width: 600px;
	overflow: hidden;
}

.message_box_t {
	width: 25px;
	padding-left: 575px;
	background: url(../img/message_box_top.png);
	height: 20px;
	padding-top: 10px;
}

.message_box_m {
	width: 580px;
	padding: 10px;
	background: url(../img/message_box_body.png);
	text-align: left;
	line-height: 35px;
	font-size: 14px;
}

.message_box_b {
	width: 600px;
	background: url(../img/message_box_bottom.png);
	height: 30px;
}
</style>
  
</head>
<body>

<div id="wrap">
  <div id="mainer">
    <div class="box_wrap">
      <div class="postt">
        <h2>${trade.vehicle.brandName}${trade.vehicle.seriesName}${trade.vehicle.kindName}</h2>
                         图片要求：1.最大可上传5M图片；2.支持jpg/png/gif格式；3.最多可上传20张图。
        <input type="checkbox" name="selall" id="selall" onclick="selall()"/>&nbsp;全选&nbsp;&nbsp;
        <input type="button" value="删除" class="ui_state_highlight" onclick="delete_checked_pic();" />
        <!-- <input type="button" value="网站显示" class="ui_state_highlight" onclick="publish_checked_pic();" /> -->
      </div>
      <div class="clear"></div>
      <div class="postbox">
        <ul id="img_ul">
          <li id="li_new">
            <div class="t">
              <span>
                <img id="img_addnew" src="http://static.che3bao.com/kcb/images/add-btn.png" width="180" height="120" onclick="javascript:add_pic(event);" />
              </span>
              <span id="img_tit_">点击上传图片<span>
            </div>
            <div class="clear"></div>
          </li>
          <div id="clear1" class="clear"></div>
          <div class="clear"></div>
        </ul>
      </div>
      <div class="clear"></div>

      <div class="clear20"></div>
    </div>
    <!--//2014-04-15-->

    <div class="clear"></div>
  </div>
</div>

<input id="localFileName" type="hidden" name="localFileName" value=""/>
<input id="hd_showtag" type="hidden" name="hd_showtag"/>
<input id="tradeId" type="hidden" name="tradeId"/>

<div id="popup" style="z-index:100;display:none" class="message_box" >
<div class="message_box_t">
  <img src="http://static.che3bao.com/kcb/images/message_box_close.png" onclick="javascript:hide_info();" />
</div>
<div class="message_box_m">
  <table>
    <tr>
      <td>
        <div id="queue"></div>完整文件名：
        <input id="showname" name ="showname" type="text" style ="width:300px" readonly="readonly"/>
      </td>
      <td>
        <input id="file_upload" name="file_upload" type="file"  multiple="true"/>
      </td>
    </tr>
  </table>
</div>
<div class="message_box_b"> </div>
</div>
</body>
</html>
