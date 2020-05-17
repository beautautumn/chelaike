<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"
         language="java" %>
<%@taglib uri="/struts-tags" prefix="s" %>
<%@ include file="/common/taglibs.jsp" %>
<%@ include file="/common/meta.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>派单</title>
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
            var url1 = ctutil.bp() + "/cars/cars!speciallyAuthorize.action?grantor_id="+$("#grantor_id").val()+"&note="+$("#note").val();
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
                        api.get("edit_dialog", 1).close();
                        W.query1();
                    } else {
                        alert("保存失败,请重试！");
                    }
                }
            });
        }

    </script>


</head>
<body>
<div class="over-content">
    <form id="myForm">
        <input type="hidden" name="Authorization.CarId" value="${carId}"/>
        <div class="over-cell">
            <label>授权人:</label>
            <select id="grantor_id" name="grantorId">
                <option>--请选择--</option>
                <c:forEach  items="${userList}" var="user">
                    <option  value="${user.id}">${user.name}</option>
                </c:forEach>
            </select>

        </div>
        <div>
            <label>授权说明：</label>
            <textarea class="over-textarea" id="note"  name="parkingCard.note" style="width:250px; height:50px;"  onkeyup="if(/[;]/.test(this.value)){var str = this.value;this.value =str.substring(0,str.length-1)}" ></textarea>
        </div>
    </form>
</div>
</body>
</html>