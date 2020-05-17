<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"
         language="java" %>
<%@taglib uri="/struts-tags" prefix="s" %>
<%@ include file="/common/taglibs.jsp" %>
<%@ include file="/common/meta.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>初检审核</title>
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


    <script type="text/javascript">
        var api = frameElement.api, W = api.opener;

        function do_pass(){
            var data = $("#myForm").serialize();
            ajaxPost(data, '/cars/cars!firstCheckAuthPass.action');
        }
        function do_reject(){
            var data = $("#myForm").serialize();
            ajaxPost(data, '/cars/cars!firstCheckAuthReject.action');
        }
        function ajaxPost(data2, url) {
            var url1 = ctutil.bp() + url;
            $.ajax({
                cache: false,
                type: "POST",
                url: url1,
                data: data2,
                async: false,
                error: function () {
                    html = "请求失败";
                },
                success: function (data) {
                    var result = JSON.parse(data);
                    if (result.success) {
                        alert(result.message);
                        api.get("firstcheckAuth_dialog", 1).close();
                        W.query1();
                    } else if(result.success== false){
                        alert("审核失败,"+result.message);
                        api.get("firstcheckAuth_dialog", 1).close();
                        W.query1();
                    }else {
                        alert("审核失败,请重试！");
                        api.get("firstcheckAuth_dialog", 1).close();
                        W.query1();
                    }
                }
            });
        }
    </script>
    <link rel="stylesheet" type="text/css" href="/sso/static/css/overui.css" />
</head>
<body>
<form id="myForm">
    <input type="hidden" name="carId" value="${carId}"/>
</form>
确认后将无法更改，请谨慎操作。
</body>
</html>
