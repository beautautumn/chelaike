<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java"%>
<%@taglib uri="/struts-tags" prefix="s"%>
<%@ include file="/common/taglibs.jsp"%>
<%@ include file="/common/meta.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
  <head>
    <title>融资车辆检测</title>
    <link rel="stylesheet" type="text/css" href="${ctx}/css/style.css" />
    <script type="text/javascript" src="${ctx}/js/common/syUtil.js"></script>
    <script type="text/javascript" src="${ctx}/js/common/ctutil.js"></script>
    <script type="text/javascript" src="${ctx}/js/common/jquery.json-2.4.js"></script>
    <script type="text/javascript" src="${ctx}/js/plugins/jquery/jquery.js"></script>
    <script type="text/javascript" src="${ctx}/js/plugins/bootstrap-3.0.3/js/bootstrap.min.js"></script>
    <script type="text/javascript" src="${ctx}/js/plugins/jstree/_lib/jquery.cookie.js"></script>
    <script type="text/javascript" src="${ctx}/js/plugins/jstree/_lib/jquery.hotkeys.js"></script>
    <link rel="stylesheet" type="text/css"  href="${ctx}/js/plugins/jquery/uploadifive/uploadifive.css" />
    <script src="${ctx}/js/plugins/jquery/uploadifive/jquery.uploadifive.js"></script>

<style type="text/css">
.message_box {
  width: 300px;
  height: 120px;
  overflow: hidden;
}

.message_box_t {
  width: 25px;
  padding-left: 275px;
  background: url(../img/message_box_top.png);
  height: 20px;
  padding-top: 10px;
}

.message_box_m {
  width: 280px;
  padding: 10px;
  background: url(../img/message_box_body.png);
  text-align: left;
  line-height: 35px;
  font-size: 14px;
}

.message_box_b {
  width: 300px;
  background: url(../img/message_box_bottom.png);
  height: 30px;
}
</style>

<script>
  var picIndex = 0;
  var nameCheckResult = "";
  var phoneCheckResult = "";
  var userCheckResult = "";
  var api = frameElement.api, W = api.opener;

 
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
            $("#img").html(html);
          }          
          $('#file_upload').uploadifive('clearQueue');
          hide_info();

        },              
        'fileSizeLimit' : '5MB',
        'auto'  : true,
        'fileObjName' : 'fileObj', 
        'buttonText'  : '点击选择质检报告图片',        
        'uploadScript' : '${ctx}/carin/vehicleInput!upload.action?'
      });
     };     

    function rebuild_display_html(pic_url, pic_id) 
    { 
      var html = "";
      html +="&nbsp;&nbsp;<img id='checkPic' src='"+pic_url+"' width='400' height='400' '/>"
           +"<input type='hidden' name='picId' value='"+pic_id+"'/>";
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
  
 
  
  function do_submit()
  {
    var data = $("#myForm").serialize();
    var cPic = $("#checkPic").attr("src");
    if(typeof(cPic)=="undefined"){
    	alert("请等待图片上传完成！");
    	return;
    }
    ajaxPost(data);
  }
  
  function ajaxPost(data){
    var url =ctutil.bp()+"/loan/loanEval!doLoanVehicleCheck.action";
    $.ajax({
        cache: false,
        type: "POST",
        url:url,
        data:data,
        async: false,
        error: function() {
          html = "数据请求失败";
        },
        success: function(data) {
          if(data=="success"){
            alert("保存成功！");
            api.get("loanVehicleCheck",1).close();
            W.query1();  
          }else{
            alert("保存失败,请重试！");
          }
        }
      });
  }
  
</script>

</head>
<body>
    <form id="myForm">
      <input type="hidden" name="tradeId" id="tradeId" value="${tradeId}" />
      <div class="box">

        <table>
          <tr>
            <td class="text-r" width="50px">
               &nbsp;                  
            </td>
            <td style="word-break: break-all" width="400px">
              <div id="img">
                <img src="${ctx}/images/upload.png" width="400" height="400"   id="mainLogo_img" onclick="show_info(event);" />
              </div>
            </td>
          </tr>
        </table>
        
      </div>

    </form>

    <input id="localFileName" type="hidden" name="localFileName" value="" />
     <div id="popup" style="z-index: 1000; display: none"
      class="message_box">
      <div class="message_box_t">
        <img src="${ctx}/img/message_box_close.png"
          onclick="javascript:hide_info();" />
      </div>
      <div class="message_box_m">
        <table>
          <tr>
            <td>
              <div id="queue"></div>
                                        完整文件名：
              <input id="showname" name="showname" type="text" style="width: 100px" readonly="readonly" />
            </td>
            <td>
              <input id="file_upload" name="file_upload" type="file" />
            </td>
          </tr>
        </table>
      </div>
      <div class="message_box_b">
      </div>
    </div>

  </body>
</html>
