<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib uri="/struts-tags" prefix="s"%>
<%@ include file="/common/taglibs.jsp"%>
<html>
<head>
    <title>账户信息</title>
    <link rel="stylesheet" type="text/css" href="/sso/static/css/account.css" />
    <style>
        a{
            display:inline-block;
        }
    </style>
</head>
<body>

<div class="content" id="content">
    <div class="account-box">
        <s:if test="market != null">
            <div class="account-title">
                <span>账号信息</span>
            </div>
            <div class="account-content text-left">
                <p>
                    <label>公司ID：${market.marketUid}</label>
                    <label>公司全称：${market.marketName}</label>
                </p>
                <p>
                    <label>创建时间：<fmt:formatDate value="${market.marketContractBeginDate}" pattern="yyyy-MM-dd"/></label>
                    <label>营业地址：</label>
                </p>
            </div>
        </s:if>

        <div class="account-title" style="padding-top:20px;">
            <span>账户安全</span>
        </div>
        <div class="account-content">
            <a href="${ctx}/sys/staff_changePwd1.action">
                <span class="account-btn">更改密码</span>
            </a>
            <a href="${ctx}/sys/staff_changePhone1.action">
                <span class="account-btn" style="margin-left:30px;">手机号换绑</span>
            </a>
        </div>

    </div>
</div>

</body>
</html>
