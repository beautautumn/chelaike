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



            /* var repVal =  $("input[type='radio']").val();
             if(repVal=='url'){
                 $("#uploadBtn").remove();
             }*/



            var report_type= "${check.report_type}";
            //alert(report_type);
            test(report_type);
        })
        var address= "${check.report_url}";
        //alert(address);

        function aCheck1(){

              $("#uploadBtn").hide();
            // $("#report").textbox('clear');


        }

        function bCheck2(){

            $("#uploadBtn").show();
            // $("#report").textbox('clear');
            //$("#report").textbox('setValue',address);
        }

        function cCheck3(){

            $("#uploadBtn").show();
        }


        function test(report_type) {
            if(report_type=='url'){

                $("input[type='radio'][value='url']").prop("checked","checked" );
                $("#uploadBtn").hide();
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

        function uploadPic(){
            //alert("1");
            $.ajaxFileUpload({
                url:ctutil.bp() + '/report/report!simpleFileupload.action?check.taskId=${check.taskId}',
                fileElementId:'file',
                dataType:'json',
                success :function (data) {
                    if(data.resultCode=='200'){

                        $("#report").textbox('clear');
                       /* var url ="${check.report_url}";
                        alert(data.url);*/
                        $("#report").textbox('setValue',data.url);

                        $.messager.alert('提示','上传成功');
                    }
                    else if(data.resultCode=='600'){
                        $.messager.alert('提示','上传失败');
                    }
                }
            })

        }



        var api = frameElement.api, W = api.opener;

        function do_submit() {
            //var report_type = $("input[name='report_type']").val();

            if (!$("#myForm").form('enableValidation').form('validate')) {
                $.messager.alert('提示','表单未填写完整');
                return;
            }

            var data = $("#myForm").serialize();
           // alert(data);
            ajaxPost(data);
        }

        function ajaxPost(data2) {
            var url1 = ctutil.bp() + '/report/report!edit.action';

            //alert(url1);
            $.ajax({
                cache: false,
                type: "POST",
                url: url1,
                data: data2,
                async: false,
                error: function () {
                    html = "数据请求失败";
                },
                success: function (data) {
                    if (data == "success") {
                        //alert("编辑成功！");
                        api.get("edit_report", 1).close();
                        W.query1();
                    } else {
                        alert('编辑失败!' + data);
                        api.get("edit_report", 1).close();
                        W.query1();
                    }
                }
            });
        }


        function getCarValue(){
            $.ajax({
                type: "POST",
                url:ctutil.bp() + '/report/report!getCarValuation.action?check.carId=${check.carId}',
                //data: $('#edtEventForm ').serialize(),
                dataType : "json",
                success: function(data){

                    if(data.resultCode=='200'){

                        alert(data.carValue);
                        $("#valuation").textbox("setValue",data.carValue);
                    }
                    else if(data.resultCode=='600'){
                        $.messager.alert('提示','获取数据失败');
                    }
                }


            });
        }







    </script>
    <link rel="stylesheet" type="text/css" href="/sso/static/css/overui.css"/>

</head>
<body>
<div class="over-content">
    <form id="myForm" method="post" enctype="multipart/form-data">

        <div class="over-cell">
            <label >车辆名称：</label>

            <input class="over-input easyui-textbox"
                   data-options="required:true,missingMessage:'请输入车辆名称'"
                   id="car_name" name="cars.name"
                   value="${cars.name}"/>
        </div>

        <div class="over-cell">
            <label>报告类型：</label>


            <input type="radio" name="check.report_type" value="url" id="ok1" checked="checked" onclick="aCheck1()" /> URL全路径
            <input type="radio" name="check.report_type" value="pdf" id="ok2" checked="" onclick="bCheck2()" /> PDF报告
            <input type="radio" name="check.report_type" value="img" id="ok3" checked="" onclick="cCheck3()" />图片报告

        </div>
        <%--<c:if test=""></c:if>--%>
        <div class="over-cell" id="uploadBtn">
            <label>请选择：</label>

            <span class="over-button" style="position:relative">选择
                    <input id="file" type="file" name="fileFileName" onchange="uploadPic()"/>
                </span>

        </div>
        <div class="over-cell">
            <label>上传地址：</label>
            <input name="check.report_url" id ="report" class="easyui-textbox" data-options="multiline:true" value="${check.report_url}" style="width:300px;height:70px">
        </div>


        <div class="over-cell">
            <label>车辆估值：</label>

            <input class="over-input easyui-textbox"
                   data-options="required:true,missingMessage:'请输入车辆估值'"
                   id="valuation" name="check.valuation"
                   value="${check.valuation}"/>万元

            <span id="carValuation" class="over-button" onclick="getCarValue()" style="margin-left: 100px;margin-top:10px">车300估值</span>
        </div>



        <input type="hidden" name="check.taskId" id="checkId" value="${check.taskId}"/>
        <input type="hidden" name="check.carId" id="carId" value="${check.carId}"/>
    </form>
</div>
</body>
</html>
