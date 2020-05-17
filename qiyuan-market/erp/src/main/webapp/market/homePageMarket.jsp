<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/common/taglibs.jsp" %>
<link rel="stylesheet" type="text/css" href="/sso/static/css/index-center.css" />
<link rel="stylesheet" type="text/css" href="/sso/static/css/overui.css" />
<div class="content" id="content">
    <div class="index-box" id="contentCenter">
        <div class="index-center clearfix" >
            <div class="index-center-left">
                <div class="pick1">
                    <p class="title">今日交易量</p>
                    <p class="num">
                        28<span>台</span>
                    </p>
                </div>
                <div class="pick2">
                    <p class="title">本月交易量</p>
                    <p class="num">
                        128<span>台</span>
                    </p>
                </div>
                <div class="pick3">
                    <p class="title">今日入库数</p>
                    <p class="num">
                        18<span>台</span>
                    </p>
                </div>
                <div class="pick4">
                    <p class="title">本月入库数</p>
                    <p class="num">
                        118<span>台</span>
                    </p>
                </div>
            </div>
            <div class="index-center-center">
                <h2 class="time" id="time"></h2>
                <p class="date" id="date"></p>
            </div>
            <div class="index-center-right">
                <p class="user-name">李俊杰</p>
                <p class="user-type">销售</p>
                <p class="ago-text">上次登录时间</p>
                <p class="ago-time">2017-09-09 12:00:35</p>
            </div>
        </div>
        <div class="index-bottom clearfix">
            <div class="index-bottom-login">
                <div class="title">创建商户</div>
                <div class="box">
                    <%--<p class="over-cell"><label>商户类型</label>--%>
                        <%--<select class="over-select" style="margin-left:-4px;">--%>
                            <%--<option>车商</option>--%>
                            <%--<option>车场</option>--%>
                            <%--<option>呵呵哒</option>--%>
                            <%--<option>啦啦啦</option>--%>
                        <%--</select>--%>
                    <%--</p>--%>
                    <p class="over-cell"><label>联系人</label><input type="" name="" class="over-input"></p>
                    <p class="over-cell"><label>手机号</label><input type="" name="" class="over-input"></p>
                    <p style="text-align: right;margin-top:40px;">
                        <span class="index-bottom-btn">确定</span>
                        <span class="index-bottom-btn">重置</span>
                    </p>
                </div>
            </div>
            <div class="index-bottom-news">
                <div class="title">消息</div>
                <div class="box">
                    <ul>
                        <li><strong>[库存消息]</strong>奥迪A6 2016款 运的的的动改... </li>
                        <li><strong>[库存消息]</strong>奥迪A6 2016款 运的的的动改... </li>
                        <li><strong>[库存消息]</strong>奥迪A6 2016款 运的的的动改... </li>
                        <li><strong>[库存消息]</strong>奥迪A6 2016款 运的的的动改... </li>
                        <li><strong>[库存消息]</strong>奥迪A6 2016款 运的的的动改... </li>
                        <li><strong>[库存消息]</strong>奥迪A6 2016款 运的的的动改... </li>
                        <li><strong>[库存消息]</strong>奥迪A6 2016款 运的的的动改... </li>
                    </ul>
                </div>
            </div>
            <div class="index-bottom-notice">
                <div class="title">公告</div>
                <div class="box">
                    <ul>
                        <li><label><strong>[置顶]</strong>奥迪A6 2016款 运动 运动运动 改... </label><span>12-12</span></li>
                        <li><label>奥迪A6 2016款 运动 运动运动 改... </label><span>12-12</span></li>
                        <li><label>奥迪A6 2016款 运动 运动运动 改... </label><span>12-12</span></li>
                        <li><label>奥迪A6 2016款 运动 运动运动 改... </label><span>12-12</span></li>
                        <li><label>奥迪A6 2016款 运动 运动运动 改... </label><span>12-12</span></li>
                        <li><label>奥迪A6 2016款 运动 运动运动 改... </label><span>12-12</span></li>
                        <li><label>奥迪A6 2016款 运动 运动运动 改... </label><span>12-12</span></li>
                    </ul>
                </div>
            </div>
        </div>
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
            + NowDate.getMonth() + '月'
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