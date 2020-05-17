<%@ page language="java" pageEncoding="UTF-8" contentType="text/html; charset=UTF-8"%>
<%@ include file="/common/taglibs.jsp"%>
<%

        String menuId = request.getParameter("menuId") == null ? (String) request
                .getAttribute("menuId"):request.getParameter("menuId");
%>

<style type="text/css">

</style>
<script type="text/javascript">

    var first_child_menu=null;

    $(function() {
        setMenu();
        setTimeout(function () {
            setTab('首页','/erp/sys/home!home.action')
        }, 600);
        <%--init_menu();    --%>
        <%--setTimeout(function () { --%>
        <%--if(first_child_menu!=null){--%>
        <%--eu.addTab('layout_center_tabs',first_child_menu.text,'${ctx}' + first_child_menu.attributes.url,true, first_child_menu.iconCls);--%>
        <%--}  --%>
        <%--}, 600);    --%>
    });

    <%--function init_menu(){--%>
    <%--$.ajax ({--%>
    <%--type: "POST",--%>
    <%--url: "${ctx}/login!navTreeListByMenu.action?menuId=<%=menuId%>" ,--%>
    <%--data: "", --%>
    <%--async: false,--%>
    <%--success: function(data) {    //提交成功后的回调    --%>
    <%--$.each(data, function(i, n) {--%>
    <%--var menulist = "<div class='easyui-panel' data-options='fit:true,border:false' style='overflow-y:auto;overflow-X: hidden;' id='navsite'><ul>";--%>
    <%--$.each(n.children, function(j, o) {//依赖于center界面选项卡layout_center_tabs对象--%>
    <%--if(j==0){--%>
    <%--first_child_menu=o;--%>
    <%--}--%>
    <%--menulist += "<li><div><strong><a onClick='javascript:eu.addTab(layout_center_tabs,\""--%>
    <%--+ o.text+"\",\"${ctx}" + o.attributes.url+ "\",true,\""+o.iconCls+"\")' style='font-size:14px;' > " + o.text + "</a></strong></div></li> ";--%>
    <%--});--%>
    <%--menulist += '</ul></div></br>';--%>
    <%----%>
    <%--document.getElementById("page_nav").innerHTML=menulist;--%>
    <%----%>
    <%--});--%>
    <%----%>
    <%--$('.easyui-accordion div li div strong a').click(function(){--%>
    <%--$('.easyui-accordion li div').removeClass("selected");--%>
    <%--$(this).parent().parent().addClass("selected");--%>
    <%--}).hover(function(){--%>
    <%--$(this).parent().parent().addClass("hover");--%>
    <%--},function(){--%>
    <%--$(this).parent().parent().removeClass("hover");--%>
    <%--});--%>

    <%--}--%>
    <%--}); --%>
    <%--}--%>
    function setMenu(){
        $.post('/sso/listMenus', {}, function (data) {
            console.log(data);
            var menuTreeArr = data
            for (var i = 0; i < menuTreeArr.length; i++) {
                var htmlStr = "";
                console.log(menuTreeArr[i].isLeaf);
                if(menuTreeArr[i].isLeaf){
                    htmlStr += '<div class="nav-first menu-item" id="menu'+menuTreeArr[i].id+'" onClick="setTab(\''+menuTreeArr[i].name+'\',\'${ctx}'+menuTreeArr[i].url+'\',this.id)">'
                        + '<p> '
                        + '<i><img src="'+menuTreeArr[i].icon+'" /></i>'+menuTreeArr[i].name+'</p>'
                        +'</div> '
                }else{
                    var listStr = "";
                    var listTreeArr = menuTreeArr[i].leavies;
                    for (var j = 0; j < listTreeArr.length; j++) {
                        listStr += "<li class=\"menu-item\" onClick='setTab(\""
                            + listTreeArr[j].name+"\",\"${ctx}" + listTreeArr[j].url+ "\",this.id)' style='font-size:14px;' id='menu"+listTreeArr[j].id+"' > " + listTreeArr[j].name + "</li> ";
                    }

                    htmlStr +=  '<div class="nav-first menu-box is-open">'
                        + '<p><i><img src="'+menuTreeArr[i].icon+'" /></i>'+menuTreeArr[i].name+'</p>'
                        +  '<ul>'+listStr+'</ul>'
                        +'</div>'
                }
                $('.left-nav').append(htmlStr);

            }
            $('.menu-item').click(function(event){
                event.stopPropagation();
                $('.menu-item').removeClass('is-active')
                $(this).addClass('is-active')

            })

//            $('.menu-box').click(function(){
//                if ($(this).hasClass('is-open')) {
//                    $(this).removeClass('is-open');
//                }else{
//                    $('.menu-box').removeClass('is-open');
//                    $(this).addClass('is-open');
//                }
//            });
        });
    }
    function setTab(title,url,id) {
        eu.addTab('layout_center_tabs', title, url, true, 'undefined');
        $('.tabs-title').each(function(){
            if($(this).html() == title){
                $(this).parents('a').attr('onclick','getMenu('+'"'+id+'"'+')');
            }
        })
    }
    function getMenu(id){
        var thisTab = $('#'+id+'');
        $('.menu-item').removeClass('is-active');
        thisTab.addClass('is-active');
//        $('.menu-box').removeClass('is-open');
//        console.log(thisTab.parent('menu-box'));
//        thisTab.parents('.menu-box').addClass('is-open');
    }


</script>

<div class="left-nav theme1">

</div>
<%--<div id="page_nav" data-options="animate:false,fit:true,border:true" >--%>

<%--</div>--%>