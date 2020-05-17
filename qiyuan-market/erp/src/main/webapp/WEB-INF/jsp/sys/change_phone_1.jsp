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

    function verifyCodeFromServer() {
        var code = $("#verifyCode").val();
        if (code === null || code.length !== 6) {
            $(".input-info").html("验证码格式不正确");
        } else {
            $.ajax({
                cache: false,
                type: "POST",
                url: "${ctx}/sys/staff_verifyCode.action",
                data: { verifyCode: code },
                async: false,
                error: function () { },
                success: function (data) {
                    if (data.code === 1) {
                        window.location = "${ctx}/sys/staff_changePhone2.action"
                    } else {
                        $(".input-info").html("验证码不正确");
                    }
                }
            })
        }
    }
</script>

<div class="content" id="content">
    <div class="account-box">
        <div class="account-title">
            <span>账号信息</span>
        </div>
        <div class="step-bar">
            <span class="step1 on">原手机号验</span>
            <span class="step2">新手机号绑定</span>
            <span class="step3">绑定成功</span>
        </div>
        <div class="account-content">
            <p><label>验证手机号：</label><span class="label-text">${sessionScope.sessionInfo.phone}</span></p>
            <p>
                <label>验证码：</label>
                <input type="text" id="verifyCode" />
                <span id="sendCodeButton" onclick="sendVerifyCode()" class="account-btn">获取验证码</span>
            </p>
            <div class="input-info"></div>
            <p style="margin-top:50px;"><label></label><span onclick="verifyCodeFromServer()" class="account-btn">下一步</span></p>
        </div>
    </div>
</div>

</body>
</html>
