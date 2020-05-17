<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"
	language="java"%>
<%@ include file="/common/taglibs.jsp"%>
<!DOCTYPE html>
<html>
<head>
<title>车辆信息录入</title>
<script type="text/javascript" charset="utf-8">
    var ctx = "${ctx}";
</script>
<!-- HTML5 Shim and Respond.js IE8 support of HTML5 elements and media queries -->
<!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
<!--[if lt IE 9]>
 <script src="https://oss.maxcdn.com/libs/html5shiv/3.7.0/html5shiv.js"></script>
 <script src="https://oss.maxcdn.com/libs/respond.js/1.3.0/respond.min.js"></script>
 <![endif]-->
<meta http-equiv="pragma" content="no-cache">
<meta http-equiv="cache-control" content="no-cache">
<meta http-equiv="expires" content="0">
<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
<meta http-equiv="description" content="This is my page">

<meta name="viewport" content="width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no">
<!-- <meta name="viewport" content="width=device-width, initial-scale=1.0, minimum-scale=0.5, maximum-scale=2.0, user-scalable=yes" /> -->
<meta name="apple-mobile-web-app-capable" content="yes" />
<meta name="apple-mobile-web-app-status-bar-style" content="black" />
<meta name="format-detection" content="telephone=no" />
<%-- <link rel="stylesheet" type="text/css" href="${ctx}/css/default.css" />
<link rel="stylesheet" type="text/css" href="${ctx}/phone/css/style.css" /> --%>
<link rel="stylesheet" type="text/css" href="${ctx}/phone/css/master.css" />
<script src="${ctx}/phone/mobiscroll/js/jquery-1.9.1.min.js"></script>
<%-- 
<script type="text/javascript" src="${ctx}/js/common/ctutil.js"></script>
<script type="text/javascript" src="${ctx}/phone/js/Zepto.js"></script> 
<script type="text/javascript" src="${ctx}/phone/js/ev.js"></script>
<script type="text/javascript" src="${ctx}/phone/js/SaleCar_V0.js"></script>
--%>
<script type="text/javascript" src="${ctx}/phone/js/megapix-image.js"></script>
<%-- <script type="text/javascript" src="${ctx}/phone/js/vehicle_input_phone.js"></script> --%>
    
<%-- <link rel="stylesheet" type="text/css" href="${ctx}/phone/mobiscroll/css/mobiscroll.custom-2.5.0.min.css" />
<script type="text/javascript" src="${ctx}/phone/mobiscroll/js/mobiscroll.custom-2.5.0.min.js" /> --%>
<script type="text/javascript" src="${ctx}/phone/js/receipt.js" />


<style>
span.closeNode{
    position: absolute;
    top:-60px;
    margin-left:110px;
    font-size: 1.5em;
    color: red;
}
</style>

</head>

<body>
    <header>
        回单上传
        <div class="btn-left">
            <a href="sign.html"><img src="images/icon-back.png" alt=""
                width="26" /></a>
        </div>
    </header>
    <div class="sign-detail">
        路线：杭州-南京<br>杭州天车科技
    </div>
    <div class="wrap">
        <div id="suibian" class="check-line1" style="padding-top: 10px;">
        </div>
    </div>
    <button type="button" class="btn-red" >确 认</button>
    
    <div id="fade" class="black_overlay"></div>
</body>
</html>
