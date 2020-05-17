<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"
         language="java" %>
<%@taglib uri="/struts-tags" prefix="s" %>
<%@ include file="/common/taglibs.jsp" %>
<%@ include file="/common/meta.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>编辑车商信息</title>
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
    <link rel="stylesheet" type="text/css" href="/sso/static/css/overui.css" />

    <script type="text/javascript">
        var api = frameElement.api, W = api.opener;

        function do_submit() {
            var data = $("#myForm").serialize();
            ajaxPost(data);
        }

        function ajaxPost(data2) {
            var url1 = ctutil.bp() + "/rent/agencyListAction!doUpdateAction.action";
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
                        alert("编辑成功！");
                        api.get("dialog_agency_edit", 1).close();
                        W.query1();
                    } else {
                        alert(data);
//                        alert("保存失败,请重试！");
                    }
                }
            });
        }
    </script>

</head>
<body>
<div class="over-content">
    <form id="myForm">
        <input type="hidden" name="agency.id" value="${agency.id}"/>
        <div class="over-cell"><label>车商UID:${agency.id}</label></div>
        <div class="over-title">负责人信息</div>
        <div class="over-cell">
            <label>姓名:</label><input class="over-input" data-options="required:true,missingMessage:'请输入姓名'" id="agencyUserName" name="agency.userName" value="${agency.userName}" readonly="readonly"/>
            <label>联系方式:</label><input class="over-input" data-options="required:true,missingMessage:'请输入联系方式'" id="agencyUserPhone" name="agency.userPhone" value="${agency.userPhone}" readonly="readonly"/>
        </div>
        <div class="over-cell"><label>身份证号:</label><input class="over-input" data-options="required:true,missingMessage:'请输入身份证号'" id="agencyUserIdCard" name="agency.userIdCard" value="${agency.userIdCard}"/></div>
        <div class="over-title">公司信息</div>
        <div class="over-cell">
            <label>公司名称:</label><input class="over-input" data-options="required:true,missingMessage:'请输入公司名称'" id="agencyAgencyName" name="agency.agencyName" value="${agency.agencyName}"/>
            <label>法人:</label><input class="over-input" data-options="required:true,missingMessage:'请输入法人'" id="agencyLegalPersonName" name="agency.legalPersonName" value="${agency.legalPersonName}"/>
        </div>
        <div class="over-cell"><label>法人联系方式:</label><input class="over-input" data-options="required:true,missingMessage:'请输入法人联系方式'" id="agencyLegalPersonPhone" name="agency.legalPersonPhone" value="${agency.legalPersonPhone}"/></div>
    </form>
</div>
</body>
</html>
