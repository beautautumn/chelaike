<%--
  Created by IntelliJ IDEA.
  User: lihm
  Date: 2017/12/19
  Time: 11:05
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"
         language="java" %>
<%@taglib uri="/struts-tags" prefix="s" %>
<%@ include file="/common/taglibs.jsp" %>
<%@ include file="/common/meta.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>修改停车卡信息</title>
    <style type="text/css">
        input{
            height: 30px;
            border-color: rgb(149,184,231);
        }
        textarea{
            border-color: rgb(149,184,231);
        }
    </style>
    <link rel="stylesheet" type="text/css" href="${ctx}/css/style.css"/>
    <script type="text/javascript" src="${ctx}/js/common/syUtil.js"></script>
    <script type="text/javascript" src="${ctx}/js/common/ctutil.js"></script>
    <script type="text/javascript" src="${ctx}/js/common/jquery.json-2.4.js"></script>
    <script type="text/javascript" src="${ctx}/js/plugins/jquery/jquery.js"></script>
    <script type="text/javascript" src="${ctx}/js/plugins/jquery/base64.js"></script>
    <script type="text/javascript" src="${ctx}/js/plugins/bootstrap-3.0.3/js/bootstrap.min.js"></script>
    <script type="text/javascript" src="${ctx}/js/plugins/jstree/_lib/jquery.cookie.js"></script>
    <script type="text/javascript" src="${ctx}/js/plugins/jstree/_lib/jquery.hotkeys.js"></script>

    <link rel="stylesheet" type="text/css" href="${ctx}/js/plugins/jquery/uploadifive/uploadifive.css"/>
    <link rel="stylesheet" type="text/css" href="${ctx}/js/plugins/jquery-easyui/themes/default/easyui.css"/>
    <link rel="stylesheet" type="text/css" href="${ctx}/js/plugins/jquery-easyui/themes/icon.css"/>
    <link rel="stylesheet" type="text/css" href="${ctx}/js/plugins/jquery-easyui/demo/demo.css"/>

    <script type="text/javascript" src="${ctx}/js/plugins/jquery-easyui/jquery-1.6.min.js"></script>
    <script type="text/javascript" src="${ctx}/js/plugins/jquery-easyui/jquery.easyui.min.js"></script>
    <script type="text/javascript" src="${ctx}/js/common/menu.js"></script>
    <script type="text/javascript">
         var api = frameElement.api, W = api.opener;
        function do_submit() {
            var data = $("#myForm").serialize();
            ajaxPost(data);
        }
        function xycheckNo(){
        var no = $("#no").val();
            if(no != ${parkingCard.no}){
                checkNo();
            }
        }
        function checkNo(){
            var no = $("#no").val();
            $.ajax({
                url:ctutil.bp() + "/parkingCard/parkingcard!checkNo.action",
                type:"POST",
                data:{nos:no},
                timeout: 60000,
                async: false,
                error: function () {
                    html = "数据请求失败";
                },
                success: function(data){
                    if(data == "success"){
                        alert("该卡号已存在,请重新输入");
                        $("#no").css("border-color","red");
                    }
                }
            });
        }
        function ajaxPost(data2) {
            var url1 = ctutil.bp() + "/parkingCard/parkingcard!edit.action";
            $.ajax({
                cache: false,
                type: "POST",
                url: url1,
                data:data2,
                async: false,
                error: function () {
                    html = "数据请求失败";
                },
                success: function (data) {
                    if (data == "success") {
                        alert("修改成功！");
                        api.get("edit_parkingcard", 1).close();
                        W.query1();
                    } else {
                        alert('创建失败!'+data);
                    }
                }
            });
        }
        $(function(){
            $("#operator_id").combobox({
                url:ctutil.bp() + "/parkingCard/parkingcard!inputSelectByUsersName.action",
                editable:true,
                valueField:'id',
                textField:'name',
            });
            $("#shop_id").combobox({
                url:ctutil.bp() + "/parkingCard/parkingcard!inputSelectByShopsName.action",
                editable:true,
                valueField:'id',
                textField:'name',
            });
        });
    </script>
    <link rel="stylesheet" type="text/css" href="/sso/static/css/overui.css" />
</head>
<body>
<div class="over-content">
    <form id="myForm">
        <input type="hidden" name="parkingCard.id" value="${parkingCard.id}"/>
        <div class="over-cell">
            <label>归属车商：</label>
            <input name="parkingCard.shop_id" style=" height: 30px;" id="shop_id" class="easyui-combobox" value="${parkingCard.shop_id}" />
        </div>
        <div class="over-cell">
            <label>卡号：</label>
            <input class="over-input" style="width: 250px; border-color: rgb(149,184,231);" onblur="xycheckNo();"  id="no" name="parkingCard.no" value="${parkingCard.no}" />
        </div>
        <div class="over-cell">
            <label>操作人：</label>
            <input name="parkingCard.operator_id" id="operator_id" class="easyui-combobox" style=" height: 30px;"  value="${parkingCard.operator_id}" />
        </div>
        <div class="over-cell">
            <label>备注：</label>
            <textarea class="over-textarea" id="note"  name="parkingCard.note" style="width:250px; border-color: rgb(149,184,231); height:50px; "  onkeyup="if(/[;]/.test(this.value)){var str = this.value;this.value =str.substring(0,str.length-1)}" >${parkingCard.note}</textarea>
        </div>
    </form>
</div>
</body>
</html>