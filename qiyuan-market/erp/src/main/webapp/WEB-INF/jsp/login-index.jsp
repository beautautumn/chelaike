<%-- <%@ page language="java" pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ include file="/common/taglibs.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>大公市场</title>
<meta name="keywords" content="关键词">
<meta name="description" content="描述">
<link rel="shortcut icon" href="favicon.ico">
<%@ include file="/common/meta.jsp"%>
<link rel="stylesheet" type="text/css" href="${ctx}/css/css.css" />
<script type="text/javascript" src="${ctx}/js/common/ctutil.js" charset="utf-8"></script>
<script type="text/javascript" src="${ctx}/js/common/menu.js" charset="utf-8"></script>

<script type="text/javascript">
//注销
function logout() {
	$.messager.confirm('确认提示！', '您确定要退出系统吗？', function(r) {
		if (r) {
			window.location.href = "${ctx}/login!logout.action";
		}
	});
}
 function editLoginUserPassword(){
    //弹出对话窗口
     menu.create_dialog_identy('change_pwd_dialog','修改密码','/sys/accountInfo_toChangePwd.action',500,300,true);
  }


   function create_dialog(title,url){
   		//menu.create_model_max_dialog_identy("id",title,url);
      window.location.href='${ctx}'+url;
   }
</script>


<script type="text/javascript">
  function do_submit(){
    if($("#title").val()==''){
      alert('请填写标题');
      // eu.showAlertMsg("请填写标题", "warning");
      return;
    }
    if($("#content").val()==''){
      alert('请填写内容');
      // eu.showAlertMsg("请填写内容", "warning");
      return;

    }
    var param=$("#myForm").serialize();
    $.post('${ctx}/sys/feedOpinion_doSaveFeedOpinion.action',param,function(data){
    if(data=='0000'){
      alert('反馈成功，我们将及时和您联系，谢谢！');
      // eu.showAlertMsgWithCallback('反馈成功，我们将及时和您联系，谢谢！', "info", redirect_page);      
      location="${ctx}/fileRedirect.action?toPage=help.jsp";
    }else{
      alert('反馈失败');
      // eu.showAlertMsg("反馈失败", "warning");
      return;
    }

  });

  }

</script>
</head>
<body>
<div id="wrap">

  <div id="header">
    <div class="box">
      <div class="logo"><a href="#"><img src="${ctx}/img/logo.png" /></a></div>
      <div class="ttool">欢迎：${sessionScope.sessionInfo.userName} <a href="#" onclick="logout()" class="tb1">退出</a> <a href="javascript:void(0);"  onclick="editLoginUserPassword();"class="tb2">修改密码</a></div>
      <div class="clear"></div>
    </div>
  </div>
  
  <div id="mainer">
    <div class="imain">
      <div class="box">
        <div class="ibox ibox3"><a href="javascript:create_dialog('车辆管理','/login!main.action?menuId=33');"><i class="ib3"></i>车辆管理<span class="m"><h2>车辆管理  </h2><p>对进出大公交易市场的车辆进行信息的录入、管理、发布等  </p><p><img src="${ctx}/img/b3.png" /></p></span></a></div>
        <div class="ibox ibox2"><a href="javascript:create_dialog('库存融资','/login!main.action?menuId=18');"><i class="ib2"></i>库存融资<span class="m"><h2>库存融资</h2><p>库存车辆的融资贷款等</p><p><img src="${ctx}/img/b3.png" /></p></span></a></div>        
        <div class="ibox ibox1"><a href="javascript:create_dialog('场租物业','/login!main.action?menuId=3');"><i class="ib1"></i>场租物业<span class="m"><h2>场租物业</h2><p>场地、商户等等日常操作。</p><p><img src="${ctx}/img/b3.png" /></p></span></a></div>        
        <div class="ibox ibox4"><a href="javascript:create_dialog('互联网发布','/login!main.action?menuId=36');"><i class="ib4"></i>官网发布<span class="m"><h2>官网发布 </h2><p>在库车辆一键发车到官网网站。 </p><p><img src="${ctx}/img/b3.png" /></p></span></a></div>
        <div class="ibox5">
          <h2>公告广告</h2>
          <ul id="igg">
            <li>
              <a href="#" class="t">
             “库存宝”软件开放公测
              </a><p>
             “库存宝”软件从4月21日起正式开放公测...
              <a href="http://help.nayouche.com/forum.php?mod=viewthread&tid=1" target="_blank">
             [详情]
              </a></p>
            </li>
            <li><a href="#" class="t">
           “客户宝”软件即将发布
            </a><p>
           “客户宝”软件即将发布，敬请期待...
              <a href="http://help.nayouche.com/forum.php?mod=viewthread&tid=2" target="_blank">
             [详情]
              </a></p>
            </li>
            <li><a href="#" class="t">
           “微店宝”软件即将发布
            </a><p>
           “微店宝”软件即将发布，敬请期待...
              <a href="http://help.nayouche.com/forum.php?mod=viewthread&tid=3" target="_blank">
             [详情]
              </a></p>
            </li>
          </ul>
          <div id="ggbtn1"></div>
          <div id="ggbtn2"></div>
        </div>
        <div class="ibox ibox6"><a href="${ctx}/fileRedirect.action?toPage=help.jsp"><i class="ib6"></i>
        XXXX
        <span class="m"><h2>
       帮助与反馈
        </h2><p>
       学习各类人员如何使用系统完成相应的操作。
        </p><p><img src="${ctx}/img/b3.png" /></p></span></a></div>
        <div class="ibox ibox7"><a href="javascript:create_dialog('系统设置','/login!main.action?menuId=1');"><i class="ib7"></i>系统设置<span class="m"><h2>系统设置</h2><p>帐号权限、发车网站帐号、企业信息、渠道类型等设置。</p><p><img src="${ctx}/img/b3.png" /></p></span></a></div>
        <div class="clear"></div>
      </div>
    </div>
    <div class="clear"></div>
  </div>

 <%@ include file="footer.jsp" %>
</div>

<div id="cleft_box"><span id="rybtn">意见反馈</span></div>

<div id="tanchuang">
  <div class="ttbox">
    <div class="ttboxt"><span id="ttcbtn">×</span>反馈详情</div>
    <div class="ttboxm">
      <div class="fkform">
        <ul>
            <form id="myForm">
              <li><span>标题：</span><input id="title" name="title" type="text" class="input" /></li>
              <li><span>内容：</span><textarea id="content" name="content" class="textarea"></textarea></li>
              <li><span>&nbsp;</span>&nbsp;&nbsp;&nbsp;<input name=""  onclick="do_submit();" class="btn" value="立即反馈" /><a href="${ctx}/fileRedirect.action?toPage=help.jsp" class="btn">我自己查看FAQ</a></li>
              <div class="clear"></div>
            </form>  
        </ul>
      </div>
    </div>
  </div>
</div>


</body>
</html> --%>
 <%@page import="com.ct.erp.constants.sysconst.Const"%>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/common/taglibs.jsp" %>
<%
String ssoServerIndex=Const.SSO_INDEX_URL;
request.setAttribute("ssoServerIndex",ssoServerIndex);
%>
<script type="text/javascript">
	var mac = "${mac}";
	top.location.href = "${ssoServerIndex}";
</script>