<%@ page language="java" pageEncoding="UTF-8" contentType="text/html; charset=UTF-8"%>
<%@ include file="/common/taglibs.jsp"%>
<%@ include file="/common/meta.jsp"%>
<link rel="stylesheet" type="text/css" href="css/css.css" />
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>意见反馈</title>

<link rel="stylesheet" type="text/css" href="css.css" />
<script type="text/javascript" src="js/main.js"></script>
<script type="text/javascript" src="${ctx}/js/common/syUtil.js"></script>
<script type="text/javascript" src="${ctx}/js/common/ctutil.js"></script>
<script type="text/javascript" src="${ctx}/js/common/menu.js"></script>
<script type="text/javascript" src="${ctx}/js/common/select.js"></script>
<script type="text/javascript" src="${ctx}/js/common/jquery.json-2.4.js"></script>
<script type="text/javascript" src="${ctx}/js/business/vehicle/vehicle_vin.js"></script>
<script type="text/javascript" src="${ctx}/js/pages/catalogue/catalogue.js"></script>
<script type="text/javascript" src="${ctx}/js/pages/region/region.js"></script>
<script type="text/javascript" src="${ctx}/js/common/validator/validator.js"></script>
<script type="text/javascript">
	function do_submit(){
    if($("#title").val()==''){
      alert("请填写标题");
      return;
    }
    if($("#content").val()==''){
      alert("请填写内容");
      return;
    }
    var param=$("#myForm").serialize();
    $.post('${ctx}/sys/feedOpinion_doSaveFeedOpinion.action',param,function(data){
    if(data=='0000'){
      alert("反馈成功，我们将及时和您联系，谢谢！");
      location="${ctx}/fileRedirect.action?toPage=help.jsp";
    }else{
      alert("反馈失败");
      return;
    }
  });

  }

</script>


</head>

<body>

<div id="wrap">

 <%@ include file="top.jsp" %>
  
  <div id="mainer">
    <div class="box">
      <div class="mainl">
        <div class="lnav"><a href="${ctx}/fileRedirect.action?toPage=help.jsp" class="ltit">帮助与反馈</a></div>
      </div>
      <div class="mainr">
        <div class="rnav"><a href="${ctx}/fileRedirect.action?toPage=questions.jsp">常见FAQ</a><a href="#" class="${ctx}/fileRedirect.action?toPage=feedback.jsp">我要反馈</a></div>
        <div class="fkbox">
          <div class="fkform">
            <ul>
            <form id="myForm">
              <li><span>标题：</span><input id="title" name="title" type="text" class="input" /></li>
              <li><span>内容：</span><textarea id="content" name="content" class="textarea"></textarea></li>
              <li><span>&nbsp;</span>&nbsp;&nbsp;&nbsp;<input name=""  onclick="do_submit();" class="btn" value="立即反馈" />
                <a href="${ctx}/fileRedirect.action?toPage=help.jsp" class="btn">我自己看FAQ</a></li>
              <div class="clear"></div>
            </form>  
            </ul>
          </div>
        </div>
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