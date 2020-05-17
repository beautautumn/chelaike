<%@ page language="java" pageEncoding="UTF-8"
  contentType="text/html; charset=UTF-8"%>
<%@ include file="/common/taglibs.jsp"%>
<!DOCTYPE html>
<html>
<head>
  <title>权限管理</title>
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link rel="stylesheet" type="text/css" href="${ctx}/js/plugins/bootstrap-3.0.3/css/bootstrap.min.css" />
  <link rel="stylesheet" type="text/css" href="/sso/static/css/overui.css" />
  <script type="text/javascript" src="${ctx}/js/plugins/jquery/jquery.js"></script>
  <script type="text/javascript" src="${ctx}/js/plugins/bootstrap-3.0.3/js/bootstrap.min.js"></script>
  <script type="text/javascript" src="${ctx}/js/plugins/jstree/_lib/jquery.cookie.js"></script>
  <script type="text/javascript" src="${ctx}/js/plugins/jstree/_lib/jquery.hotkeys.js"></script>
  <script type="text/javascript" src="${ctx}/js/plugins/jstree/jquery.jstree.js"></script>
  <script type="text/javascript" src="${ctx}/js/common/ctutil.js"></script>
  <style type="text/css">
    body {
      margin: 0;
      font-family: Verdana,"Helvetica Neue", Helvetica, Arial, sans-serif;
      color: #333333;
      background-color: #ffffff;
      font-weight:normal;
    }
    label{
        font-size: 14px;
        font-weight:normal;
    }
    .col-sm-8 {
      width: 50%;
    }
    .need-sms-notice {
        margin-top: 20px;
        border-top: 1px solid #ccc;
        padding-top: 10px;
    }
    .need-sms-notice input {
      margin-top: 12px;
    }
  </style>
  <script type="text/javascript" class="source">
    $(function () {
      $("#functions").jstree({ 
          "plugins" : [ "themes", "html_data", "checkbox", "sort", "ui" ],
          "core" : {
              "animation" : 100,
              "initially_open" : [${firstLevelFun} ]
          },
          "checkbox": { "two_state" : false }
      });
      $("#functions").jstree('open_all');
      $("input[name='staff.status'][value=${staff.status}]").attr("checked",true);

      
    });

    var api = frameElement.api, W = api.opener;    
    function checkAccount(){
      if($("#loginName").val() != "") {            
        $.ajax({
          url:'${ctx}/sys/accountInfo_checkAccount.action',
          type:'post',
          data:{'adminAccount' : $("#loginName").val()},
          success:function(data) {
            if(data == "0"){
              $("#gzdiv").css("display","block");
            }
            if(data == "1"){
              alert("该账户名称已被注册, 请重新输入!");
              $("#loginName").val("");
              $("#loginName").focus();
              $("#gzdiv").css("display","none");
            }
          },
          async:false
        });        
      } else {
        $("#gzdiv").css("display","none");
      }  
    }    

    function checkInputTel() {
      if($("#tel").val() != "") {    
        if($("#tel").val().length==11) {
          $("#telDiv").css("display","block");
        } else {
          alert("您输入的手机号码不正确, 请重新输入!");
          $("#tel").val("");
          $("#tel").focus();
          $("#telDiv").css("display","none");
        }
      } else {
        $("#telDiv").css("display","none");
      }  
    }

    function checkEnableAccount() {
        if('${editType}' == 'edit') 
        {
          var checkAccountRes = checkAccountNum();
          if (checkAccountRes == 0) {
            alert("对不起，您允许开通的最大账户数超额，不允许添加帐号，请联系云潮的客服人员。");
            $("input[name='staff.status'][value=0]").attr("checked",true);
            return;
          }
        }
    }

    function checkAccountNum() {
      var result = 0;
      $.ajax({    
        type:'post',        
        url:'${ctx}/sys/corp_getCorpMaxCount.action',    
        data:"",    
        cache:false,    
        dataType:'json',
        async : false, //默认为true 异步     
        success:function(data){
          if(data == 0){
             result = 0;
          }else{
             result = 1;
          }
        }    
      }); 
      return result;
    }

    function do_submit() { 
      var dialog_object=W.get_dialog_instance();
      dialog_object.button({id:'ok',disabled: true});         
         
      if($('#name').val() == ""){
        alert("请输入姓名！");
        $('#name').focus();
        dialog_object.button({id:'ok',disabled: false});
        return;
      }          
      if($('#loginName').val() == ""){
        alert("请输入账户名称！");
        $('#loginName').focus();
        dialog_object.button({id:'ok',disabled: false});
        return;
      }  
      if($('#tel').val() == ""){
        alert("请输入手机号码！");
        $('#tel').focus();
        dialog_object.button({id:'ok',disabled: false});
        return;
      } 
      
    

        
          
      var status=$("input[name='staff.status']:checked").val();       
      if(!status){
        alert("请选择是否启用！");
        dialog_object.button({id:'ok',disabled: false});           
        return;
      }            
      
	    var formData=$('#userform').serialize();
	    console.log("the formData is :%o",formData);  
	    var functionid = get_checked_right();
      console.log("the right is :%o",functionid);  
      formData += "&functionid="+functionid;
	    console.log("the after formData is :%o",formData)
	    $.ajax({    
	       type:'post',        
	       url:'${ctx}/sys/staff_save.action',    
	       data:formData,    
	       cache:false,    
	       dataType:'json',
	       async : false, //默认为true 异步     
	       success:function(data){
	         if(data.code==1){
	           alert('操作成功');
	           api.get("infosource_dialog",1).close();
	           W.query1();
	         }else{
	           alert('操作失败');
	           dialog_object.button({id:'ok',disabled:false});
	         }   
	       }    
      }); 
    }          

    function get_checked_right(){
      var checked_ids = []; 
      $("#functions").jstree("get_checked",null,true).each (function () { 
        checked_ids.push(this.id); 
      });  
      return checked_ids.toString();          
    }
        
    function showMacDiv(){
      $("#macDiv").css("display","block");
    }
    	
    function dismissMacDiv(){
      $("#macDiv").css("display","none");
    }
    	
  </script>
</head>
    <body>
<div class="panel panel-default">  
        <table class="table">
            <tr>
                <td width="50%">
                    <form  class="form-horizontal"  role="form" id="userform" name="userform">
                        <input id="marketId" name="staff.market.marketId" type="hidden" value="${marketId}"/>
                        <input type="hidden" name="staff.id" id="id" value="${staff.id}"/>
                    <input type="hidden" name="staff.loginPwd" id="staff.loginPwd" value="123"/> 
                    <fieldset>
                        <legend>1.基本信息</legend>
                            <div class="form-group">
                                <label for="name" class="col-sm-4 control-label" style="font-weight:normal;">姓名<span style="color:red">*</span></label>
                                <div class="col-sm-8">
                                <input type="input" class="form-control input-sm" name="staff.name" id="name" placeholder="请输入姓名" value="${staff.name}">
                                </div>
                            </div>                                            
                            <div class="form-group">
                              <label for="name" class="col-sm-4 control-label" style="font-weight:normal;">账户名称<span style="color:red">*</span></label>
                              <div class="col-sm-8" >
                                <input type="input" class="form-control  input-sm" name="staff.loginName" id="loginName" 
                                  placeholder="请输入账户名称" value="${staff.loginName}" onchange="javascript:checkAccount();">
                                </div>
                                <div id="gzdiv" style="position: relative;display: none;">
                                  <img alt="" src="${ctx}/img/tick.png" style="position: absolute;top: 50%;height: 15px;margin-top: 7px;">
                                </div>
                            </div>
                            <div class="form-group">
                            </div>
                            <div class="form-group">
                              <label for="tel" class="col-sm-4 control-label" style="font-weight:normal;">手机号码
                                <span style="color:red">*</span>
                              </label>
                              <div class="col-sm-8">
                                <input type="tel" class="form-control input-sm" id="tel"  name="staff.tel" 
                                  placeholder="请输入手机号码" value="${staff.tel}" onchange="javascript:checkInputTel();">
                                </div>
                                <div id="telDiv" style="position: relative;display: none;">
                                  <img alt="" src="${ctx}/img/tick.png" style="position: absolute;top: 50%;height: 15px;margin-top: 7px;">
                                </div>
                            </div>

                            <div class="form-group">
                                <label for="marketId" class="col-sm-4 control-label" style="font-weight:normal;">所属公司
                                    <span style="color:red"></span>
                                </label>
                                <div class="col-sm-8">
                                    <select id="marketId" class="over-select" name="staff.marketId" >
                                        <option value='-1' >请选择</option>
                                        <s:iterator value="markets">
                                            <option value="<s:property value='marketId'/>"  >
                                                    ${marketName}
                                            </option>
                                        </s:iterator>
                                    </select>
                                </div>
                            </div>

                            <div class="form-group"> 
                                <label for="radio-1" class="col-sm-4 control-label" style="font-weight:normal;">是否启用
                                  <span style="color:red"></span>
                                </label> 
                                <div class="form-inline">
                                    <label class="radio-inline" style="margin-left:12px;">
                                        <input type="radio" name="staff.status" id="statusTrue" value="1"  >启用
                                    </label>
                                    <label class="radio-inline">
                                        <input type="radio" name="staff.status" id="statusFalse" value="0">停用
                                    </label>
                                </div>
                            </div>
                                                                                       
                            <div class="form-group">
                              <label for="name" class="col-sm-4 control-label" style="font-weight:normal;">备注</label>
                              <div class="col-sm-8">
                                <textarea class="form-control" rows="3" id="remark"  name="staff.remark"  placeholder="备注">${staff.remark}</textarea>
                                </div>
                            </div>
                            <div class="need-sms-notice">
                              <label for="name" class="col-sm-4 control-label" style="font-weight:normal;">短信提醒</label>
                              <div class="col-sm-8">
                                <input type="checkbox" id="needSmsNotice" name="staff.needSmsNotice">
                              </div>
                            </div>
                        </fieldset>
                    </form>
                </td>
                <td width="50%">
                    <form role="form"  id="funform" name="funform">
                        <fieldset>
                            <legend>2.请选择权限</legend>
                              <div class="form-group">
                                <div id="functions">
                                <ul>                                   
                                    ${funcTreeStr}                           
                                </ul>
                            </div>                           
                        </div>
                    </fieldset>
                </form>
            </td>
        <tr>
       
    </table>
</div>
    </body>
</html>