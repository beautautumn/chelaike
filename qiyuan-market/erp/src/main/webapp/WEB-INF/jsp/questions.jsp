<%@ page language="java" pageEncoding="UTF-8" contentType="text/html; charset=UTF-8"%>
<%@ include file="/common/taglibs.jsp"%>
<%@ include file="/common/meta.jsp"%>
<link rel="stylesheet" type="text/css" href="css/css.css" />
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>库存宝</title>
<meta name="keywords" content="关键词">
<meta name="description" content="描述">
<link rel="shortcut icon" href="favicon.ico">
<link rel="stylesheet" type="text/css" href="css.css" />
<script type="text/javascript" src="js/jquery-1.7.1.js"></script>
<script type="text/javascript" src="js/jquery.cycle.all.min.js"></script>
<script type="text/javascript" src="js/main.js"></script>
<!--[if IE 6]>
<script type="text/javascript" src="js/png.js"></script>
<script type="text/javascript" src="js/pngs.js"></script>
<![endif]-->
</head>

<body>

<div id="wrap">
 <%@ include file="top.jsp" %>
  
  <div id="mainer">
    <div class="box">
      <div class="mainl">
        <div class="lnav"><a href="#" class="ltit">意见反馈</a></div>
      </div>
      <div class="mainr">
        <div class="rnav"><a href="${ctx}/fileRedirect.action?toPage=questions.jsp" class="hover">常见FAQ</a><a href="${ctx}/fileRedirect.action?toPage=feedback.jsp">我要反馈</a></div>
        <div><a class="backbtn" href="${ctx}/fileRedirect.action?toPage=help.jsp">返回</a></div>
        <div class="faqlist">
          <ul>
            <li><a href="#" class="t">1.请问如何快速入库？</a><div class="m">答：方法1，通过车架号快速自动填写车辆信息<br />方法2：前期先完善车辆基本信息与图标信息，后期再完善其它信息</div></li>
            <li><a href="#" class="t">2.请问如何快速入库？</a><div class="m">答：方法1，通过车架号快速自动填写车辆信息<br />方法2：前期先完善车辆基本信息与图标信息，后期再完善其它信息</div></li>
            <li><a href="#" class="t">3.请问如何快速入库？</a><div class="m">答：方法1，通过车架号快速自动填写车辆信息<br />方法2：前期先完善车辆基本信息与图标信息，后期再完善其它信息</div></li>
            <li><a href="#" class="t">4.请问如何快速入库？</a><div class="m">答：方法1，通过车架号快速自动填写车辆信息<br />方法2：前期先完善车辆基本信息与图标信息，后期再完善其它信息</div></li>
            <li><a href="#" class="t">5.请问如何快速入库？</a><div class="m">答：方法1，通过车架号快速自动填写车辆信息<br />方法2：前期先完善车辆基本信息与图标信息，后期再完善其它信息</div></li>
            <li><a href="#" class="t">6.请问如何快速入库？</a><div class="m">答：方法1，通过车架号快速自动填写车辆信息<br />方法2：前期先完善车辆基本信息与图标信息，后期再完善其它信息</div></li>
            <div class="clear"></div>
          </ul>
        </div>
        <div class="clear"></div>
        <div id="pages"><a class="a1">1/14</a><a href="#">第一页</a><a href="#">上一页</a><span>1</span><a href="#">2</a><a href="#">3</a><a href="#">4</a><a href="#">5</a><a href="#">下一页</a><a href="#">最后一页</a></div>
        <div class="clear"></div>
      </div>
      <div class="clear"></div>
    </div>
    <div class="clear"></div>
  </div>

 <%@ include file="footer.jsp" %>
</div>

</body>
</html>