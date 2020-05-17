<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="/struts-tags" prefix="s"%>
<%@ include file="/common/taglibs.jsp"%>
<%@ include file="/common/meta.jsp" %>
<html>
<head>
    <title>首页</title>
    <link rel="stylesheet" type="text/css" href="/sso/static/css/index-center.css" />
    <link rel="stylesheet" type="text/css" href="/sso/static/css/overui.css" />
</head>
<body>
<style>
    .input-info {
        color: #ff0000;
        margin-left: 83px;
    }
</style>

<script type="text/javascript">
    function resetShop() {
        $("#shopBossName").val("")
        $("#shopBossPhone").val("")
    }

    function submitShop() {
        $(".phone.input-info").html("")
        $(".name.input-info").html("")
        var regex = /^1[3|4|5|7|8][0-9]\d{4,8}$/
        var phone = $("#shopBossPhone").val()
        var name = $("#shopBossName").val()
        if (!name) {
            $(".name.input-info").html("联系人不能为空")
            return
        }
        if (!regex.test(phone)) {
            $(".phone.input-info").html("请输入正确的手机号")
            return
        }
        $.ajax({
            cache: false,
            type: "POST",
            url: "${ctx}/rent/agency_quickAdd.action",
            data: { name: name, phone: phone },
            async: false,
            error: function () { },
            success: function (data) {
                window.alert(data.msg)
            }
        })
    }
</script>

<div class="content" id="content">
    <div class="index-box" id="contentCenter">
        <div class="index-center clearfix" >
            <div class="index-center-left">
                <div class="pick1">
                    <p class="title">今日交易量</p>
                    <p class="num">
                        ${todayTradeCount}<span>台</span>
                    </p>
                </div>
                <div class="pick2">
                    <p class="title">本月交易量</p>
                    <p class="num">
                        ${monthTradeCount}<span>台</span>
                    </p>
                </div>
                <s:if test="marketId != null">
                    <div class="pick3">
                        <p class="title">待初审车辆</p>
                        <p class="num">
                                ${waitingFirstCheckCount}<span>台</span>
                        </p>
                    </div>
                    <div class="pick4">
                        <p class="title">待复审车辆</p>
                        <p class="num">
                                ${waitingSecondCheckCount}<span>台</span>
                        </p>
                    </div>
                </s:if>
                <s:if test="marketId == null">
                    <div class="pick3">
                        <p class="title">今日入库数</p>
                        <p class="num">
                            ${todayInStockCount}<span>台</span>
                        </p>
                    </div>
                    <div class="pick4">
                        <p class="title">本月入库数</p>
                        <p class="num">
                            ${monthInStockCount}<span>台</span>
                        </p>
                    </div>
                </s:if>
            </div>
            <div class="index-center-center">
                <h2 class="time" id="time"></h2>
                <p class="date" id="date"></p>
            </div>
            <div class="index-center-right">
                <p class="user-name">${sessionScope.sessionInfo.userName}</p>
                <p class="user-type">${sessionScope.sessionInfo.roleName}</p>
                <p class="ago-text">上次登录时间</p>
                <p class="ago-time"><fmt:formatDate value="${sessionScope.sessionInfo.loginTime}" pattern="yyyy-MM-dd HH:mm"/></p>
            </div>
        </div>
        <s:if test="marketId != null">
            <div class="index-bottom clearfix">
                <div class="index-bottom-login">
                    <div class="title">创建车商</div>
                    <div class="box">
                        <p class="over-cell">
                            <label>联系人</label>
                            <input type="" id="shopBossName" class="over-input">
                        </p>
                        <div class="name input-info"></div>
                        <p class="over-cell">
                            <label>手机号</label>
                            <input type="" id="shopBossPhone" class="over-input">
                        </p>
                        <div class="phone input-info"></div>
                        <p style="text-align: right;margin-top:40px;">
                            <span onclick="submitShop()" class="index-bottom-btn">确定</span>
                            <span onclick="resetShop()" class="index-bottom-btn">重置</span>
                        </p>
                    </div>
                </div>
                <div class="index-bottom-notice">
                    <div class="title">公告</div>
                    <div class="box">
                        <ul>
                            <s:iterator value="latestAnnouncements" var="annou">
                                <li>
                                    <label title="${content}">
                                        ${content}
                                    </label>
                                    <span><fmt:formatDate value="${createdAt}" pattern="MM-dd"/></span>
                                </li>
                            </s:iterator>
                        </ul>
                    </div>
                </div>
            </div>
        </s:if>
    </div>
</div>
<script>



    window.onload = function(){
//        setContentHeight();
        setContentWeight();
        getNowDate();
    }
    window.onresize = function () {
//        setContentHeight();
        setContentWeight();
    }

    function setContentWeight(){
        var proNum = window.innerWidth/1366;
        if (window.innerWidth >= 1366) {
            document.getElementById('contentCenter').style.WebkitTransform = 'scale('+proNum+','+proNum+')';
            document.getElementById('contentCenter').style.transform = 'scale('+proNum+','+proNum+')';
            document.getElementById('contentCenter').style.MozTransform = 'scale('+proNum+','+proNum+')';
            document.getElementById('contentCenter').style.WebkitTransform = 'scale('+proNum+','+proNum+')';
            document.getElementById('contentCenter').style.OTransform = 'scale('+proNum+','+proNum+')';
        }
    }

    function getNowDate(){
        var timeText = document.getElementById('time');
        var dateText = document.getElementById('date');
        var NowDate = new Date();
        var myHours = NowDate.getHours()>9?NowDate.getHours().toString():'0' + NowDate.getHours();
        var myMinutes = NowDate.getMinutes()>9?NowDate.getMinutes().toString():'0' + NowDate.getMinutes();
        var mySeconds = NowDate.getSeconds()>9?NowDate.getSeconds().toString():'0' + NowDate.getSeconds();
        timeText.innerHTML = myHours +':'+ myMinutes +':'+ mySeconds
        dateText.innerHTML = NowDate.getFullYear() +'年'
            + (NowDate.getMonth()+1) + '月'
            + NowDate.getDate() +'日  '
            + turnWeek(NowDate.getDay());
//        setTimeout(()=>{this.getNowDate()},1000)
        setTimeout(function(){
            getNowDate();
        },1000)
    }
    function turnWeek(n){
        switch(n){
            case 0:
                return '星期日'
                break;
            case 1:
                return '星期一'
                break;
            case 2:
                return '星期二'
                break;
            case 3:
                return '星期三'
                break;
            case 4:
                return '星期四'
                break;
            case 5:
                return '星期五'
                break;
            case 6:
                return '星期六'
                break;
        }
    }
</script>

</body>
</html>
