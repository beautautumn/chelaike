<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/common/taglibs.jsp" %>
<%@ include file="/common/meta.jsp" %>
<html>
<head>
    <title>修改电话</title>
    <link rel="stylesheet" type="text/css" href="/sso/static/css/account.css" />
</head>
<body>

<script type="text/javascript">
    var intervalId

    function sendVerifyCode() {
        if (intervalId) return;
        $.ajax({
            cache: false,
            type: "POST",
            url: "${ctx}/sys/staff_sendVerifyCode.action",
            async: false,
            error: function () { },
            success: function (data) {
                if (data.code === 1) {
                    var timeout = 60;
                    $("#sendCodeButton").addClass("disable")
                    callBack = function () {
                        $("#sendCodeButton").html(timeout + "秒后重新获取");
                        timeout -= 1;
                        if (timeout == 0) {
                            clearInterval(intervalId);
                            $("#sendCodeButton").removeClass("disable")
                            $("#sendCodeButton").html("获取验证码");
                            intervalId = null;
                        }
                    }
                    intervalId = window.setInterval(callBack, 1000);
                } else { }
            }
        });
    }

    function changePhone() {
        $(".phone.input-info").html("")
        $(".code.input-info").html("")
        var regex = /^1[3|4|5|7|8][0-9]\d{4,8}$/
        var phone = $("#phone").val()
        if (!regex.test(phone)) {
            $(".phone.input-info").html("请输入正确的手机号")
            return
        }
        var code = $("#verifyCode").val()
        if (code === null || code.length !== 6) {
            $(".code.input-info").html("验证码格式不正确");
            return
        }
        $.ajax({
            cache: false,
            type: "POST",
            url: "${ctx}/sys/staff_changePhone.action",
            data: { phone: phone, verifyCode: code },
            async: false,
            error: function () { },
            success: function (data) {
                if (data.code === 1) {
                    window.location = "${ctx}/sys/staff_changePhone3.action"
                } else {
                    $(".code.input-info").html(data.msg)
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
            <span class="step1 on">原手机号验</span>
            <span class="step2 on">新手机号绑定</span>
            <span class="step3">绑定成功</span>
        </div>
        <div class="account-content">
            <p><label>手机号：</label><input type="password" id="phone"></p>
            <div class="phone input-info"></div>
            <p>
                <label>验证码：</label>
                <input type="number" id="verifyCode">
                <span id="sendCodeButton" onclick="sendVerifyCode()" class="account-btn">获取验证码</span>
            </p>
            <div class="code input-info"></div>
            <p style="margin-top:50px;"><label></label><span onclick="changePhone()" class="account-btn">下一步</span></p>
        </div>
    </div>
</div>

</body>
</html>
