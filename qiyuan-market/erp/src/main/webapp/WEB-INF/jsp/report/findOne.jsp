<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"
         language="java" %>
<%@taglib uri="/struts-tags" prefix="s" %>
<%@ include file="/common/taglibs.jsp" %>
<%@ include file="/common/meta.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>图片详情</title>
    <link rel="stylesheet" type="text/css" href="${ctx}/css/style.css"/>
    <script type="text/javascript" src="${ctx}/js/common/syUtil.js"></script>
    <script type="text/javascript" src="${ctx}/js/common/ctutil.js"></script>
    <script type="text/javascript" src="${ctx}/js/common/jquery.json-2.4.js"></script>
    <script type="text/javascript" src="${ctx}/js/plugins/jquery/jquery.js"></script>
    <script type="text/javascript" src="${ctx}/js/plugins/jquery/base64.js"></script>
    <script type="text/javascript" src="${ctx}/js/plugins/bootstrap-3.0.3/js/bootstrap.min.js"></script>
    <script type="text/javascript" src="${ctx}/js/plugins/jstree/_lib/jquery.cookie.js"></script>
    <script type="text/javascript" src="${ctx}/js/plugins/jstree/_lib/jquery.hotkeys.js"></script>

    <link rel="stylesheet" type="text/css" href="${ctx}/js/plugins/jquery/uploadifive/uploadifive.css"/>
    <link rel="stylesheet" type="text/css" href="${ctx}/js/plugins/jquery-easyui/themes/default/easyui.css"/>
    <link rel="stylesheet" type="text/css" href="${ctx}/js/plugins/jquery-easyui/themes/icon.css"/>
    <link rel="stylesheet" type="text/css" href="${ctx}/js/plugins/jquery-easyui/demo/demo.css"/>

    <script type="text/javascript" src="${ctx}/js/plugins/jquery-easyui/jquery-1.6.min.js"></script>
    <script type="text/javascript" src="${ctx}/js/plugins/jquery-easyui/jquery.easyui.min.js"></script>
    <script type="text/javascript" src="${ctx}/js/common/menu.js"></script>
    <script type="text/javascript" src="${ctx}/js/plugins/jquery/jquery-form.js"></script>

    <script type="text/javascript" src="${ctx}/js/plugins/jquery/ajaxfileupload.js"></script>


    <script type="text/javascript">

        $(document).ready(function(){

            $(function(){
                $("input").attr("disabled",true);
                $("#carValuation").remove();
                $("#report").textbox('disable');
            });

            var report_type= "${check.report_type}";
            //alert(report_type);
            test(report_type);
        })
        var address= "${check.report_url}";
        function test(report_type) {
            if(report_type=='url'){

                $("input[type='radio'][value='url']").prop("checked","checked" );
                $("#report").textbox('clear');
                $("#report").textbox('setValue',address);
            }
            else if(report_type=='pdf'){

                $("input[type='radio'][value='pdf']").prop("checked","checked" );

                $("#report").textbox('clear');
                $("#report").textbox('setValue',address);
            }
            else if(report_type=='img'){

                $("input[type='radio'][value='img']").prop("checked","checked" );
                $("#report").textbox('clear');
                $("#report").textbox('setValue',address);
            }
        }


    </script>

    <script type="text/javascript">





        var api = frameElement.api, W = api.opener;









    </script>
    <link rel="stylesheet" type="text/css" href="/sso/static/css/overui.css"/>

</head>
<body>
<div class="over-content">
    <form id="myForm" method="post" enctype="multipart/form-data">

        <div class="over-cell">
            <label >车辆名称：</label>

            <input class="over-input"
                   data-options="required:true,missingMessage:'请输入车辆名称'"
                   id="cars.name" name="cars.name"
                   value="${cars.name}"/>
        </div>

        <div class="over-cell">
            <label>报告类型：</label>


            <input type="radio" name="report_type" value="url" id="ok1" checked="" onclick="aCheck1()" /> URL全路径
            <input type="radio" name="report_type" value="pdf" id="ok2" checked="" onclick="bCheck2()" /> PDF报告
            <input type="radio" name="report_type" value="img" id="ok3" checked="" onclick="cCheck3()" />图片报告

        </div>
        <%--<c:if test=""></c:if>--%>
        <span id="span" style="display:block">
                <label>上传地址：</label>
                <input name="check.report_url" id ="report" class="easyui-textbox" data-options="multiline:true" value="" style="width:300px;height:70px">

        </span>

        <div class="over-cell">
            <label>车辆估值：</label>

            <input class="over-input"
                   data-options="required:true,missingMessage:'请输入车辆估值'"
                   id="valuation" name="check.valuation"
                   value="${check.valuation}"/>万元

            <span id="carValuation" class="over-button" style="margin-left: 100px;margin-top:10px">车300估值</span>
        </div>



        <input type="hidden" name="check.id" id="checkId" value="${check.taskId}"/>
    </form>
</div>
</body>
</html>
