<%@ page language="java" pageEncoding="UTF-8" contentType="text/html; charset=UTF-8"%>
<script type="text/javascript" src="${ctx}/js/common/ctutil.js"></script>
 <script type="text/javascript" src="${ctx}/js/common/menu.js"></script>
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
    menu.create_dialog_identy('change_pwd_dialog','修改密码','/sys/accountInfo_toChangePwd.action',500,150,true);
 }


   function create_dialog(title,url){
      //menu.create_model_max_dialog_identy("id",title,url);
      window.location.href='${ctx}'+url;
   }

   function change_first_level_menu(url,obj){
      var click_text=obj.getAttribute("text");
      //console.log(click_text);
      //$(".t").text(click_text);
      window.location.href=url;
   }
</script>
<div class="header">
  <div class="logo">LOGO</div>
  <div class="title">启辕官方管理平台</div>
  <div class="header-right">
    <div class="top-bar">
      <span style="color:#989898;margin-right:20px;">您好，${sessionScope.sessionInfo.userName}</span>
      <div class="attention">
        <span>关注启辕</span>
        <div class="erweima">
          <img src="/sso/static/img/erweima.png">
          <p>扫一扫，即刻关注！</p>
        </div>
      </div>
    </div>
    <ul class="top-nav">
      <li>
        <p>
          <span>消息</span>
          <span class="nav-top-msg"></span>

        </p>
      </li>
      <li>
        <p>
          <span>公告</span>
          <span class="nav-top-notice"></span>

        </p>
      </li>
      <li>
        <p>
          <span>账户</span>
          <span class="nav-top-user"></span>

        </p>
      </li>
      <li class="contact-us">
        <p>
          <span>关于我们</span>
          <span class="nav-top-us"></span>

        </p>
      </li>
      <li onclick="logout()">
        <p>
          <span>退出</span>
          <span class="nav-top-out"></span>
        </p>
      </li>
    </ul>
  </div>
</div>

 <%--<div id="header">--%>
    <%--<div class="box">--%>
      <%--<div class="logo"><a href="#"><img src="${ctx}/img/logo.png" /></a></div>--%>
      <%--<div class="nav">--%>
        <%--<div class="homenav"><a href="${ctx}/login!index7y.action">主页</a></div>--%>
        <%--<div class="helpnav">--%>
          <%--<a href="${ctx}/fileRedirect.action?toPage=help.jsp" class="t" id="chickMenuText">--%>
            <%--<c:if test="${empty menuText}">--%>
              <%--帮助与反馈--%>
            <%--</c:if>--%>
            <%--<c:if test="${ not empty menuText}">--%>
              <%--${menuText}--%>
            <%--</c:if>--%>
          <%--</a>--%>
          <%--<div class="navb">--%>
            <%--<a href="#" onclick="change_first_level_menu('${ctx}/login!main.action?menuId=33',this);"><b class="nb3"></b>车辆管理</a>--%>
            <%--<a href="#" onclick="change_first_level_menu('${ctx}/login!main.action?menuId=18',this);"><b class="nb2"></b>库存融资</a>--%>
            <%--<a href="#" onclick="change_first_level_menu('${ctx}/login!main.action?menuId=3',this);"><b class="nb1"></b>场租物业</a>--%>
            <%--<a href="#" onclick="change_first_level_menu('${ctx}/login!main.action?menuId=36',this);"><b class="nb3"></b>官网发布</a>--%>
            <%--<a href="#" onclick="change_first_level_menu('${ctx}/login!main.action?menuId=45',this);"><b style="background-image:url('${ctx}/img/nb2.png');"></b>统计报表</a>--%>
            <%--<a href="${ctx}/login!main.action?menuId=1"><b class="nb5" ></b>系统设置</a>--%>
            <%--<a href="#"><b class="nb6"></b>XXXXX</a>--%>
          <%--</div>--%>
        <%--</div>--%>
        <%--<div class="clear"></div>--%>
      <%--</div>--%>
      <%--<div class="ttool">欢迎：${sessionScope.sessionInfo.userName} <a href="#" onclick="logout()" class="tb1">退出</a> <a href="javascript:void(0);"  onclick="editLoginUserPassword();"class="tb2">修改密码</a></div>--%>
      <%--<div class="clear"></div>--%>
    <%--</div>--%>
  <%--</div>--%>

  