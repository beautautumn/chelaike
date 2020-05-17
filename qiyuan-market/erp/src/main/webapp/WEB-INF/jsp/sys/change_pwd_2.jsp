<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/common/taglibs.jsp" %>
<%@ include file="/common/meta.jsp" %>
<html>
<head>
    <title>修改密码</title>
    <link rel="stylesheet" type="text/css" href="/sso/static/css/account.css" />
</head>
<body>

<script type="text/javascript">

    function changePwd() {
        $(".pwd.input-info").html("")
        $(".pwd-confirm.input-info").html("")
        var regex = /^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,12}$/
        var pwd = $("#pwd").val()
        if (!regex.test(pwd)) {
            $(".pwd.input-info").html("为了您的账号安全，密码必须同时包括字母和数字的8~12位字符")
            return
        }
        console.log(pwd, $("#pwd_confirm").val())
        if (pwd !== $("#pwd_confirm").val()) {
            $(".pwd-confirm.input-info").html("两次密码不一致，请重复输入")
            return
        }
        $.ajax({
            cache: false,
            type: "POST",
            url: "${ctx}/sys/staff_changePassword.action",
            data: { pwd: pwd },
            async: false,
            error: function () { },
            success: function (data) {
                if (data.code === 1) {
                    window.location = "${ctx}/sys/staff_changePwd3.action"
                } else {
                    $(".pwd-confirm.input-info").html(data.msg)
                }
            }
        })
    }

</script>

<div class="content" id="content">
    <div class="account-box">
        <div class="account-title">
            <span>账号信息</span>
        </div>
        <div class="step-bar">
            <span class="step1 on">手机号验证</span>
            <span class="step2 on">输入新登录密码</span>
            <span class="step3">修改成功</span>
        </div>
        <div class="account-content">
            <p><label>新登录密码：</label><input type="password" id="pwd"></p>
            <div class="pwd input-info"></div>
            <p><label>确认新登录密码：</label><input type="password" id="pwd_confirm"></p>
            <div class="pwd-confirm input-info"></div>
            <p style="margin-top:50px;"><label></label><span onclick="changePwd()" class="account-btn">下一步</span></p>
        </div>
    </div>
</div>

</body>
</html>
