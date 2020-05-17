<%@ page import="com.ct.erp.core.security.SessionInfo" %>
<%@ page import="com.ct.erp.core.security.SecurityUtils" %>
<%@ page import="com.sun.org.apache.xpath.internal.operations.Bool" %><%--
  Created by IntelliJ IDEA.
  User: hww
  Date: 2017/9/12
  Time: 18:27
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@taglib uri="/struts-tags" prefix="s"%>
<%@ include file="/common/taglibs.jsp"%>
<%@ include file="/common/meta.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">

<%
    SessionInfo sessionInfo = SecurityUtils.getCurrentSessionInfo();
    String userType = sessionInfo.getUserType();
    Boolean isPlatform = (userType!= null && userType.equals("platform"));
    Boolean canCrossCompany =  isPlatform && (sessionInfo.getMarketId() == null);
%>

<html>
<head>
    <title>新增公告</title>
    <link rel="stylesheet" type="text/css" href="${ctx}/css/style.css" />
    <script type="text/javascript" src="${ctx}/js/common/syUtil.js"></script>
    <script type="text/javascript" src="${ctx}/js/common/ctutil.js"></script>
    <script type="text/javascript" src="${ctx}/js/common/menu.js"></script>
    <script type="text/javascript" src="${ctx}/js/plugins/My97DatePicker/WdatePicker.js"></script>


    <link rel="stylesheet" type="text/css" href="${ctx}/js/plugins/jquery-easyui/themes/default/easyui.css" />
    <link rel="stylesheet" type="text/css" href="${ctx}/js/plugins/jquery-easyui/themes/icon.css" />

    <style type="text/css">
        .message_box{ width:300px;height:120px;overflow:hidden;}
        .message_box_t{ width:25px; padding-left:275px; background:url(../img/message_box_top.png); height:20px; padding-top:10px;}
        .message_box_m{ width:280px; padding:10px; background:url(../img/message_box_body.png);text-align:left; line-height:35px; font-size:14px;}
        .message_box_b{ width:300px; background:url(../img/message_box_bottom.png); height:30px;}
    </style>

    <script>
        $(function(){
            $("#signDate").val(new Date().format('yyyy-MM-dd'));
            $("#depositFee").val('0.00');
            $("#everyRecvFee").val('0.00');
            getRecvCycle();
            getMonthTotalFeeAll();

            upload_type = '';
            init_uploadifive();

            $('input[type="file"]').attr(
                'accept',
                'image/gif, image/jpeg, image/jpg, image/png, .gif, .jpeg, .jpg, .png'
            );

            $("#recvCycle option").each(function(){
                if($(this).val()=='${contract.recvCycle}'){
                    $(this).attr('selected',true);
                }
            });

            $("#everyRecvFee").val(parseFloat('${contract.everyRecvFee/100}').toFixed(2));
            $("#depositFee").val(parseFloat('${contract.depositFee/100}').toFixed(2));

            var contractView = '${contractView}' || '';
            if(contractView == 'CONTINUE'){
                $("#startDate").attr("readonly",true);
                $("#signDate").attr("readonly",true);
            }else{
                $("#startDate").click(function(){
                    WdatePicker();
                });
            }
        });

        var api = frameElement.api, W = api.opener;
        var isPlatform = <%=isPlatform%>;
        var canCrossCompany = <%=canCrossCompany%>;

        function do_submit(){
            if(isPlatform) {
                if ($("select[name='announcement.announcementType']").val() == "") {
                    alert("请选择发送范围！");
                    $("select[name='announcement.announcementType']").focus();
                    return;
                }
                if (canCrossCompany && ($("select[name='announcement.marketId']").val() == "")) {
                    alert("请选择交易市场！");
                    $("select[name='announcement.marketId']").focus();
                    return;
                }
            }
            var title = $("input[name='announcement.title']").attr("value").trim();
            $("input[name='announcement.title']").attr({value: title});
            if (title =="")
            {
                alert("请输入公告标题!");
                $("input[name='announcement.title']").focus();
                return;
            }
            var content = $("textarea[name='announcement.content']").attr("value").trim();
            $("textarea[name='announcement.content']").attr({value: content});
            if (content =="")
            {
                alert("请输入公告内容!");
                $("textarea[name='announcement.content']").focus();
                return;
            }
            if(!confirm("确认发送公告 ["+title+"] 么？")){
                return;
            }

            var data = $("#myForm").serialize();

            $.ajax({
                cache: false,
                type: "POST",
                url:ctutil.bp()+"/announcement/announcement!create.action",
                data:data,
                async: false,
                error: function() {
                    html = "数据请求失败";
                },
                success: function(data) {
                    if(data=="success"){
                        alert("保存成功！");
                        api.get("new_announcement", 1).close();
                        W.query1();  //刷新副页面
                    }else{
                        alert("保存失败！");
                    }
                }
            });
        }
    </script>
    <link rel="stylesheet" type="text/css" href="/sso/static/css/overui.css" />
</head>
<body>
<div class="over-content">
    <form id="myForm">
        <div class="over-cell">
            <label>发送范围：</label>
            <%
                if (isPlatform){
            %>
            <select class="over-select" name="announcement.announcementType">
                <option value="">选择发送范围</option>
                <option value="all">全部</option>
                <option value="shop">车商</option>
                <option value="market">交易市场</option>
                <option value="company">经营公司</option>
            </select>
            <%
                if (canCrossCompany){
            %>
                <select class="over-select" name="announcement.marketId" >
                    <option value="" >选择发送市场</option>
                    <option value="-1">所有交易市场</option>
                    <s:iterator value="markets">
                        <option value="<s:property value='marketId'/>"  >
                                ${marketName}
                        </option>
                    </s:iterator>
                </select>
            <% } %>
            <%}else{ %>
                <span>车商</span>
            <%}%>
        </div>
        <div class="over-cell">
            <label></label>
            <input type="checkbox" name="announcement.top" id="announcement_top"/>
            <label for="announcement_top">置顶</label>
        </div>
        <div class="over-cell">
            <label>公告标题:</label><input class="over-input" style="width: 360px" maxlength="20" data-options="required:true,missingMessage:'请输入公告标题'"  name="announcement.title" value=""/><span>请输入20字以内的消息标题</span>
        </div>
        <div class="over-cell">
            <label style="float: left;margin-right: 0px;">公告内容:</label>
            <textarea class="over-textarea"  name="announcement.content" style="width:524px; height:260px;"  onkeyup="if(/[;]/.test(this.value)){var str = this.value;this.value =str.substring(0,str.length-1)}" ></textarea>
        </div>
    </form>
</div>
</body>
</html>