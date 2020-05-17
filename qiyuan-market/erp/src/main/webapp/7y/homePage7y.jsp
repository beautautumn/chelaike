<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/common/taglibs.jsp" %>
<link rel="stylesheet" type="text/css" href="/sso/static/css/index-center.css" />
<style>
    .index-box{
        width: 960px;
        height: 236px;
        position: absolute;
        top: 50%;
        left: 50%;
        margin-top: -118px;
        margin-left:-480px;
    }
</style>
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
//        setTimeout(()=>{this.getNowDate()},1000);
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