<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"
         language="java" %>
<%@taglib uri="/struts-tags" prefix="s" %>
<%@ include file="/common/taglibs.jsp" %>
<%@ include file="/common/meta.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>打印二维码</title>
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
        $(document).ready(function () {
            var name="${gateInfoVO.name}";
            var urlCode="${urlCode}";
            $("#gate_name").html(name);
            document.getElementById("img").src=ctutil.bp() +"/gateInfo/gateInfo!getQRCodeStream.action?urlCode="+urlCode;
        })
        function printCode() {
            $("#printCode").css("display","none");
            window.print();
            $("#printCode").css("display","");
            return false;
        }

    </script>
    <link rel="stylesheet" type="text/css" href="/sso/static/css/overui.css" />

</head>
<body>
<div class="over-content">
    <!--startprint-->
        <form id="myForm" method="post" enctype ="multipart/form-data">

            <div class="" style="text-align: center;">
                <img src="" alt="读取二维码失败" id="img"/>
            </div>
            <div class="" style="margin-top: 20px;text-align: center;">
                <label id="gate_name" style="font-size: 14px;"></label>
            </div>
        </form>
    <!--endprint-->

        <input onclick="printCode()" id="printCode" type="button" style="margin-left:120px;font-size:14px;border:1px solid #539ffd; ; height: 30px;width: 80px;margin-top: 30px;background-color: #539ffd;border-radius: 5px;color: whitesmoke;display: block;" value="打印"/>
</div>
</body>
</html>
