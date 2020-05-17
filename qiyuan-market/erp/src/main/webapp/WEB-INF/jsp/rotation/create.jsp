<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"
         language="java" %>
<%@taglib uri="/struts-tags" prefix="s" %>
<%@ include file="/common/taglibs.jsp" %>
<%@ include file="/common/meta.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>新建图片</title>
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
        var base64Str = null;
        function uploadPic(){
            var srcStr = getObjectURL(event.target.files[0]);
            $('#voucher_pic').attr('src',srcStr);
            var _thisTarget = event.target;
            var picNameArr = $('#rotationFileInput').val().split('\\');
            var picNameLength = picNameArr.length;
            var picName = picNameArr[picNameLength-1];
            $('#uploadBox').html(picName);

            var _thisLength = _thisTarget.files.length;
            if(_thisLength > 0) {
                var oFReader = new FileReader();
                oFReader.readAsDataURL(_thisTarget.files[0]);
                oFReader.onload = function (oFREvent) {
                    base64Str = oFREvent.target.result.split(",")[1];
                    $('#rotationFileBase64').val(base64Str);
                }
            }
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
        function do_submit() {
            var data = $("#myForm").serialize();
            console.log(data)
            ajaxPost(data);
        }
        function ajaxPost(data2) {
            var url1 = ctutil.bp() + "/rotation/rotation!create.action";
            $.ajax({
                cache: false,
                type: "POST",
                url: url1,
                data: data2,
                async: false,
                error: function () {
                    html = "数据请求失败";
                },
                success: function (data) {
                    if (data == "success") {
                        alert("保存成功！");
                        api.get("create_rotations", 1).close();
                        W.query1();
                    } else {
                        alert('创建失败!'+data);
                    }
                }
            });
        }
        function showPic(){
            var srcStr = $('#voucher_pic').attr('src');
            menu.create_pic_dialog_identy(api,W,'getSitePic','图片预览',srcStr,true);
        }
    </script>
    <link rel="stylesheet" type="text/css" href="/sso/static/css/overui.css" />

</head>
<body>
<div class="over-content">
    <form id="myForm" method="post" enctype ="multipart/form-data">
        <div class="over-cell">
            <label>图片名称</label>
            <input class="over-input" data-options="required:true,missingMessage:'请输入图片名称'" id="rotationName" name="rotation.name"/>
        </div>
        <div class="over-cell">
            <label>图片类型</label><label>轮播图</label>
        </div>
        <div class="over-cell">
            <label>图片链接</label>
            <input class="over-input" data-options="required:true,missingMessage:'请输入图片链接'" id="rotationReirectUrl" name="rotation.redirectUrl"/>
        </div>

        <div class="over-cell">
            <label>客户端</label>
            <select class="over-select" name="rotation.rotationType">
                <option value="">请选择</option>
                <option value="shop">车商APP</option>
                <option value="company">经营公司APP</option>
            </select>
        </div>
        <div class="over-cell">
            <label>图片上传</label>
            <span class="over-button" style="position:relative">选择<input id="rotationFileInput"  type="file" name="rotationFile"  onchange="uploadPic()"/></span>
        </div>
        <div class="over-cell">
            <label></label>
            <img src="${ctx}/img/noimg.png" style="max-width:140px;" id="voucher_pic" onclick="showPic()"/>
        </div>
        <div class="over-cell">
            <label>图片排序</label>
            <select class="over-select" name="rotation.sorting">
                <option value="1">1</option>
                <option value="2">2</option>
                <option value="3">3</option>
                <option value="4">4</option>
                <option value="5">5</option>
            </select>
        </div>
        <input type="hidden" name="rotationFileBase64" id="rotationFileBase64"/>
    </form>
</div>
</body>
</html>
