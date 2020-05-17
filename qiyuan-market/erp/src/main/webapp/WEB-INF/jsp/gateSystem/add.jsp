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
        function do_submit() {
            var data = $("#myForm").serialize();
            console.log(data);
            ajaxPost(data);
        }
        function ajaxPost(data2) {
            var url1 = ctutil.bp() + "/gateInfo/gateInfo!addGateInfo.action";
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
                        api.get("add_gateInfo", 1).close();
                        W.query1();
                    } else {
                        alert('创建失败!'+data);
                    }
                }
            });
        }
    </script>
    <link rel="stylesheet" type="text/css" href="/sso/static/css/overui.css" />

</head>
<body>
<div class="over-content">
    <form id="myForm" method="post" enctype ="multipart/form-data">
        <div class="over-cell">
            <label>道闸号</label>
            <input class="over-input" data-options="required:true,missingMessage:'请输入道闸号'" id="gateNum" name="gateInfoVO.no"/>
        </div>
        <div class="over-cell">
            <label>道闸名称</label><input class="over-input" style="width: 360px" maxlength="20" data-options="required:true,missingMessage:'请输入道闸名称'"  name="gateInfoVO.name" value=""/>
        </div>
        <div class="over-cell">
            <label>道闸名称</label>
            <select class="over-select" name="gateInfoVO.direction">
                <option value="">请选择</option>
                <option value="in">进场</option>
                <option value="out">出场</option>
            </select>
        </div>
    </form>
</div>
</body>
</html>
