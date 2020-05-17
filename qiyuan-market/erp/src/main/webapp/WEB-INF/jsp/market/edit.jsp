<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"
         language="java" %>
<%@taglib uri="/struts-tags" prefix="s" %>
<%@ include file="/common/taglibs.jsp" %>
<%@ include file="/common/meta.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>编辑车场账号</title>
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
    <link rel="stylesheet" type="text/css" href="/sso/static/css/overui.css" />


    <script type="text/javascript">
        var api = frameElement.api, W = api.opener;

        $(document).ready(function () {
            $("#agencyId option[value='${agencyId}']").attr("selected", true);
            $("input[name='trade.consignTag'][value='0']").attr('checked', 'checked');
            /* $("#aId").val($("#agencyId option[selected]").html()); */
            /* getBarCode(); */
            $(".barCode").blur(function () {
                var value = $(this).val();
                if (value != "") {
                    $.ajax({
                        type: "get",
                        url: ctutil.bp() + "/carin/vehicleInput!checkBarCode.action",
                        data: {barCode: value},
                        dataType: "json",
                        success: function (data) {
                            if (data) {
                                alert("条码编号重复，请重新录入");
                                $(".barCode").focus();
                            }
                        }
                    });
                }
            });

            $('#brand').combobox({
                panelHeight: 400,
                editable: false,
                url: ctutil.bp() + "/sys/comm!getBrandList.action",
                valueField: 'id',
                textField: 'name',
                groupField: 'group',
                onSelect:
                    function (rec) {
                        $('#series').combobox('clear');
                        $('#kind').combobox('clear');
                        var url = ctutil.bp() + "/sys/comm!getSeriesList.action?brandId=" + rec.id;
                        $('#series').combobox('reload', url);
                        $('#brandName').val(rec.name);
                    }
            });

            $('#series').combobox({
                panelHeight: 400,
                editable: false,
                url: ctutil.bp() + "/sys/comm!getSeriesList.action?brand=0",
                valueField: 'id',
                textField: 'name',
                onLoadSuccess: function () {
                    $('#series').combobox('setValue', '');
                },
                onSelect:
                    function (rec) {
                        $('#kind').combobox('clear');
                        var url = ctutil.bp() + "/sys/comm!getKindList.action?seriesId=" + rec.id;
                        $('#kind').combobox('reload', url);
                        $('#seriesName').val(rec.name);
                    }
            });

            $('#kind').combobox({
                panelHeight: 400,
                editable: false,
                onLoadSuccess: function () {
                    $('#kind').combobox('setValue', '');
                },
                onSelect:
                    function (rec) {
                        $('#kindName').val(rec.name);
                    }
            });
            /*
            //车辆数据回显到界面
            $('#brand').combobox('setValue','
            ${vehicle.brand.id}');

        var url = ctutil.bp()+"/sys/comm!getSeriesList.action?brandId=
            ${vehicle.brand.id}";
        $('#series').combobox('reload', url);
        $('#series').combobox('setValue','
            ${vehicle.series.id}');

        var url1 = ctutil.bp()+"/sys/comm!getKindList.action?seriesId=
            ${vehicle.series.id}";
        $('#kind').combobox('reload', url1);
        $('#kind').combobox('setValue','
            ${vehicle.kind.id}');
        $('#brandName').val('
            ${vehicle.brandName}');
        $('#seriesName').val('
            ${vehicle.seriesName}');
        $('#kindName').val('
            ${vehicle.kindName}');

        $('#carColor').combobox('setValue','
            ${vehicle.carColor}');
        $('#upholsteryColor').combobox('setValue','
            ${vehicle.upholsteryColor}');
        $('#outputVolume').combobox('setValue','
            ${vehicle.outputVolume}');
        */
        });

        function onChk(a) {
            if (a.checked) {
                a.value = 1;
            }
            else {
                a.value = 0;
            }
        }

        var carColorA = [{"label": "黑色", "value": "黑色"}, {"label": "白色", "value": "白色"}
            , {"label": "红色", "value": "红色"}, {"label": "紫色", "value": "紫色"}
            , {"label": "灰色", "value": "灰色"}, {"label": "蓝色", "value": "蓝色"}
            , {"label": "橙色", "value": "橙色"}, {"label": "银色", "value": "银色"}
            , {"label": "绿色", "value": "绿色"}, {"label": "黄色", "value": "黄色"}
            , {"label": "棕色", "value": "棕色"}, {"label": "米色", "value": "米色"}
            , {"label": "金色", "value": "金色"}, {"label": "褐色", "value": "褐色"}
            , {"label": "其它", "value": "其它"}
        ];
        var upholsteryColorA = [{"label": "双色", "value": "双色"}, {"label": "米黄", "value": "米黄"}
            , {"label": "米灰", "value": "米灰"}, {"label": "红色", "value": "红色"}
            , {"label": "黑色", "value": "黑色"}, {"label": "棕色", "value": "棕色"}
        ];
        var outputVolumeA = [{"label": "1.0", "value": "1.0"}, {"label": "1.2", "value": "1.2"},
            {"label": "1.4", "value": "1.4"}, {"label": "1.6", "value": "1.6"},
            {"label": "1.8", "value": "1.8"}, {"label": "2.0", "value": "2.0"},
            {"label": "2.2", "value": "2.2"}, {"label": "2.4", "value": "2.4"},
            {"label": "3.0", "value": "3.0"}, {"label": "4.0", "value": "4.0"}
        ];

        function do_submit() {
            var data = $("#myForm").serialize();
            ajaxPost(data);
        }

        function ajaxPost(data2) {
            var url1 = ctutil.bp() + "/market/market!doManage.action";
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
                        alert("编辑成功！");
                        api.get("dialog_market_edit", 1).close();
                        W.query1();
                    } else {
                        alert("保存失败,请重试！");
                    }
                }
            });
        }

        function getBarCode() {
            $.ajax({
                url: ctutil.bp() + "/carin/vehicleInput!getBarcode.action",
                type: "get",
                success: function (data) {
                    if (data == "error") {
                        alert("条码获取失败");
                    } else {
                        $("#barCode").val(data);
                    }
                }
            });
        }

        function checkPort() {
            var id = $("#agencyId").val();
            $.ajax({
                url: ctutil.bp() + "/carin/vehicleInput!getUnusedPort.action",
                data: {agencyId: id},
                type: "post",
                success: function (data) {
                    if (data == "error") {
                        alert("获取商户车位数失败");
                        $("#agencyId option[value='-1']").attr("selected", true);
                    } else if (data == 0) {
                        alert("该商户车位已满，请重新选择！");
                        $("#agencyId option[value='-1']").attr("selected", true);
                    }
                }
            });
        }

        function checkShelfCode() {
            var shelfCode = $("#shelfCode").val();
            $.ajax({
                url: ctutil.bp() + "/carin/vehicleInput!checkShelfCode.action",
                data: {shelfCode: shelfCode, type: "input"},
                type: "post",
                success: function (data) {
                    if (data == 'true') {
                        alert("车架号重复，请重新录入");
                        $("#shelfCode").val('');
                        $("#shelfCode").focus();
                    }
                }
            });
        }

        function expressInfo() {
            var info = $("#info").val();
            var infos = info.split("#");
            $("#shelfCode").val(infos[1]);
            $("#engineNumber").val(infos[2]);
            $("#registMonth").val(infos[3]);
            $("#oldLicenseCode").val(infos[4]);
            checkShelfCode();
        }

        function dCodeInfo() {
            var $info = $("#info");
            if ($info.val()) {
                $info.val(utf8to16(base64decode($info.val())));
            }
        }


    </script>

</head>
<body>
<div class="over-content">
    <form id="myForm">
        <input type="hidden" name="market.marketId" value="${market.marketId}"/>
        <div class="over-cell"><label>车场UID:${market.marketUid}</label></div>
        <div class="over-title">负责人信息</div>
        <div class="over-cell">
            <label>姓名:</label><input class="over-input" data-options="required:true,missingMessage:'请输入姓名'" id="marketLinkmanName" name="market.marketLinkmanName" value="${market.marketLinkmanName}"/>
            <label>联系方式:</label><input class="over-input" data-options="required:true,missingMessage:'请输入联系方式'" id="marketLinkmanMobile" name="market.marketLinkmanMobile" value="${market.marketLinkmanMobile}"/>
        </div>
        <div class="over-cell"><label>身份证号:</label><input class="over-input" data-options="required:true,missingMessage:'请输入身份证号'" id="marketLinkmanCode" name="market.marketLinkmanCode" value="${market.marketLinkmanCode}"/></div>
        <div class="over-title">公司信息</div>
        <div class="over-cell">
            <label>公司名称:</label><input class="over-input" data-options="required:true,missingMessage:'请输入公司名称'" id="marketName" name="market.marketName" value="${market.marketName}"/>
            <label>法人:</label><input class="over-input" data-options="required:true,missingMessage:'请输入法人'" id="marketLegalName" name="market.marketLegalName" value="${market.marketLegalName}"/>
        </div>
        <div class="over-cell"><label>法人联系方式:</label><input class="over-input" data-options="required:true,missingMessage:'请输入法人联系方式'" id="marketLegalMobile" name="market.marketLegalMobile" value="${market.marketLegalMobile}"/></div>
        <div class="over-title">车场信息</div>
        <div class="over-cell"><label>车场面积:</label><input class="over-input" data-options="required:true,missingMessage:'请输入车场面积'" id="marketArea" name="market.marketArea" value="${market.marketArea}"/></div>
        <div class="over-title">合作信息</div>
        <div class="over-cell">
            <label>合同有效期:</label>
            <input class="over-date" style="margin-left:-3px" value="<fmt:formatDate value="${market.marketContractBeginDate}"
							pattern="yyyy-MM-dd"/>" id="marketContractBeginDate" name="market.marketContractBeginDate"
                   onclick="WdatePicker({lang:'zh-cn'});"
                   data-options="validType:['minLength[1]']"/>
            <span class="poz">~</span>
            <input class="over-date" value="<fmt:formatDate value="${market.marketContractEndDate}"
							pattern="yyyy-MM-dd"/>" id="marketContractEndDate" name="market.marketContractEndDate"
                   onclick="WdatePicker({lang:'zh-cn'});"
                   data-options="validType:['minLength[1]']"/>
        </div>

    </form>
</div>
<%--<form id="myForm">--%>
    <%--<input type="hidden" name="market.marketId" value="${market.marketId}"/>--%>
    <%--<div>车场UID:${market.marketUid}</div>--%>
    <%--<div>负责人信息</div>--%>
    <%--<div class="box">--%>
        <%--<table>--%>
            <%--<tr>--%>
                <%--<td class="text-r" width="100px">--%>
                    <%--姓名:--%>
                <%--</td>--%>
                <%--<td>--%>
                    <%--<input class="input w200 easyui-validatebox" data-options="required:true,missingMessage:'请输入姓名'" id="marketLinkmanName" name="market.marketLinkmanName" value="${market.marketLinkmanName}"/>--%>
                <%--</td>--%>
            <%--</tr>--%>
            <%--<tr>--%>
                <%--<td class="text-r" width="100px">--%>
                    <%--联系方式:--%>
                <%--</td>--%>
                <%--<td>--%>
                    <%--<input class="input w200 easyui-validatebox" data-options="required:true,missingMessage:'请输入联系方式'" id="marketLinkmanMobile" name="market.marketLinkmanMobile" value="${market.marketLinkmanMobile}"/>--%>
                <%--</td>--%>
            <%--</tr>--%>
            <%--<tr>--%>
                <%--<td class="text-r" width="100px">--%>
                    <%--身份证号:--%>
                <%--</td>--%>
                <%--<td>--%>
                    <%--<input class="input w200 easyui-validatebox" data-options="required:true,missingMessage:'请输入身份证号'" id="marketLinkmanCode" name="market.marketLinkmanCode" value="${market.marketLinkmanCode}"/>--%>
                <%--</td>--%>
            <%--</tr>--%>
        <%--</table>--%>
    <%--</div>--%>

    <%--<div>公司信息</div>--%>
    <%--<div class="box">--%>
        <%--<table>--%>
            <%--<tr>--%>
                <%--<td class="text-r" width="100px">--%>
                    <%--公司名称:--%>
                <%--</td>--%>
                <%--<td>--%>
                    <%--<input class="input w200 easyui-validatebox" data-options="required:true,missingMessage:'请输入公司名称'" id="marketName" name="market.marketName" value="${market.marketName}"/>--%>
                <%--</td>--%>
            <%--</tr>--%>
            <%--<tr>--%>
                <%--<td class="text-r" width="100px" id="feeMeter">--%>
                    <%--法人:--%>
                <%--</td>--%>
                <%--<td>--%>
                    <%--<input class="input w200 easyui-validatebox" data-options="required:true,missingMessage:'请输入法人'" id="marketLegalName" name="market.marketLegalName" value="${market.marketLegalName}"/>--%>
                <%--</td>--%>
            <%--</tr>--%>
            <%--<tr>--%>
                <%--<td class="text-r" width="100px" id="feeMeter">--%>
                    <%--法人联系方式:--%>
                <%--</td>--%>
                <%--<td>--%>
                    <%--<input class="input w200 easyui-validatebox" data-options="required:true,missingMessage:'请输入法人联系方式'" id="marketLegalMobile" name="market.marketLegalMobile" value="${market.marketLegalMobile}"/>--%>
                <%--</td>--%>
            <%--</tr>--%>
        <%--</table>--%>
    <%--</div>--%>
    <%--<div>车场信息</div>--%>
    <%--<div class="box">--%>
        <%--<table>--%>
            <%--<tr>--%>
                <%--<td class="text-r" width="100px">--%>
                    <%--车场面积:--%>
                <%--</td>--%>
                <%--<td>--%>
                    <%--<input class="input w200 easyui-validatebox" data-options="required:true,missingMessage:'请输入车场面积'" id="marketArea" name="market.marketArea" value="${market.marketArea}"/>--%>
                <%--</td>--%>
            <%--</tr>--%>
        <%--</table>--%>
    <%--</div>--%>
    <%--<div>合作信息</div>--%>
    <%--<div class="box">--%>
        <%--<table>--%>
            <%--<tr>--%>
                <%--<td class="text-r" width="100px">--%>
                    <%--合同有效期:--%>
                <%--</td>--%>
                <%--<td>--%>
                    <%--<input class="date w200 easyui-validatebox" value="<fmt:formatDate value="${market.marketContractBeginDate}"--%>
							<%--pattern="yyyy-MM-dd"/>" id="marketContractBeginDate" name="market.marketContractBeginDate"--%>
                           <%--onclick="WdatePicker({lang:'zh-cn'});"--%>
                           <%--data-options="validType:['minLength[1]']"/>—--%>
                    <%--<input class="date w200 easyui-validatebox" value="<fmt:formatDate value="${market.marketContractEndDate}"--%>
							<%--pattern="yyyy-MM-dd"/>" id="marketContractEndDate" name="market.marketContractEndDate"--%>
                           <%--onclick="WdatePicker({lang:'zh-cn'});"--%>
                           <%--data-options="validType:['minLength[1]']"/>--%>
                <%--</td>--%>
            <%--</tr>--%>
        <%--</table>--%>
    <%--</div>--%>
<%--</form>--%>
</body>
</html>
