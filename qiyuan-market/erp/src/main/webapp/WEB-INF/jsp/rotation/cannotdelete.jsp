<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"
         language="java" %>
<%@taglib uri="/struts-tags" prefix="s" %>
<%@ include file="/common/taglibs.jsp" %>
<%@ include file="/common/meta.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>删除</title>
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

        function do_submit() {
            api.get("delete_rotation", 1).close();
            W.query1();
        }
    </script>

</head>
<body>
已删除4张轮播图，本次无法执行删除操作。
</body>
</html>
