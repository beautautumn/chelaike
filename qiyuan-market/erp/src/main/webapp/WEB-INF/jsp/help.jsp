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
</head>

<body>

<div id="wrap">

 <%@ include file="top.jsp" %>
  
  <div id="mainer">
    <div class="box">
      <div class="mainl">
        <div class="lnav"><a href="#" class="ltit">帮助与反馈</a></div>
      </div>
      <div class="mainr">
        <div class="rnav"><a href="${ctx}/fileRedirect.action?toPage=questions.jsp">常见FAQ</a><a href="${ctx}/fileRedirect.action?toPage=feedback.jsp">我要反馈</a></div>
        <div class="faqb">
          <a href="${ctx}/fileRedirect.action?toPage=questions.jsp" class="faqb1"><img src="${ctx}/img/faqb1.png" />常见问题</a>
          <a href="#" class="faqb2"><img src="${ctx}/img/faqb2.png" />入库问题</a>
          <a href="#" class="faqb3"><img src="${ctx}/img/faqb3.png" />权限分配问题</a>
          <a href="#" class="faqb4"><img src="${ctx}/img/faqb4.png" />收益分析问题</a>
          <a href="#" class="faqb5"><img src="${ctx}/img/faqb1.png" />常见问题</a>
          <a href="#" class="faqb6"><img src="${ctx}/img/faqb2.png" />入库问题</a>
          <a href="#" class="faqb7"><img src="${ctx}/img/faqb3.png" />权限分配问题</a>
          <a href="#" class="faqb8"><img src="${ctx}/img/faqb4.png" />收益分析问题</a>
          <div class="clear"></div>
        </div>
      </div>
      <div class="clear"></div>
    </div>
    <div class="clear"></div>
  </div>

  <%@ include file="footer.jsp" %>
</div>

</body>
</html>