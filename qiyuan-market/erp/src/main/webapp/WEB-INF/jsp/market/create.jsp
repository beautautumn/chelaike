<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"
         language="java" %>
<%@taglib uri="/struts-tags" prefix="s" %>
<%@ include file="/common/taglibs.jsp" %>
<%@ include file="/common/meta.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>创建车场账号</title>
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
            var success = true;
            $('[required]').each(function(){
                if($(this).val() == '' || $(this).val() == null){
                    success = false
                    alert($(this).attr('data-msg'));
                    $(this).focus();
                    return false
                }else if($(this).attr('id') == 'marketLinkmanCode'){
                    if(isCardID($(this).val()) != 'true'){
                        alert(isCardID($(this).val()));
                        success = false;
                        $(this).focus();
                        return false;
                    }

                }else if($(this).attr('id') == 'marketMobile'){
                    if(!(/^1[34578]\d{9}$/.test($(this).val()))){
                        alert("手机号码有误，请重填");
                        success = false;
                        $(this).focus();
                        return false;
                    }
                }else if($(this).attr('id') == 'marketArea'){
                    if(!(/^[1-9]\d*$/.test($(this).val()))){
                        alert("您输入的面积格式有误，请输入整数！");
                        success = false;
                        $(this).focus();
                        return false;
                    }
                }
            });

            if(success){
                var data = $("#myForm").serialize();
                ajaxPost(data);
            }



        }
        function checkPhone(){
            var phone = document.getElementById('phone').value;
            if(!(/^1[34578]\d{9}$/.test(phone))){
                alert("手机号码有误，请重填");
                return false;
            }
        }
        function isCardID(sId){
            var iSum=0 ;
            var info="" ;
            if(!/^\d{17}(\d|x)$/i.test(sId)) return "你输入的身份证长度或格式错误";
            sId=sId.replace(/x$/i,"a");
            sBirthday=sId.substr(6,4)+"-"+Number(sId.substr(10,2))+"-"+Number(sId.substr(12,2));
            var d=new Date(sBirthday.replace(/-/g,"/")) ;
            if(sBirthday!=(d.getFullYear()+"-"+ (d.getMonth()+1) + "-" + d.getDate()))return "身份证上的出生日期非法";
            for(var i = 17;i>=0;i --) iSum += (Math.pow(2,i) % 11) * parseInt(sId.charAt(17 - i),11) ;
            if(iSum%11!=1) return "你输入的身份证号非法";
            //aCity[parseInt(sId.substr(0,2))]+","+sBirthday+","+(sId.substr(16,1)%2?"男":"女");//此次还可以判断出输入的身份证号的人性别
            return 'true';
        }

        function ajaxPost(data2) {
            var url1 = ctutil.bp() + "/market/market!create.action";
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
                    var result = JSON.parse(data);
                    if (result.success == true) {
                        alert("保存成功！");
                        api.get("dialog_market_in", 1).close();
                        W.query1();
                    } else {
                        alert(result.message);
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
    <link rel="stylesheet" type="text/css" href="/sso/static/css/overui.css" />

</head>
<body>
<div class="over-content">
    <form  id="myForm">
        <input type="hidden" name="market.marketUid" value="${uid}"/>
        <div class="over-cell"><label>车场UID:${uid}</label></div>
        <div class="over-title">负责人信息</div>
        <div class="over-cell">
            <label><span class="red">*</span>姓名</label>
            <input class="over-input"  required="1"  data-msg="请输入姓名" id="marketLinkmanName" name="market.marketLinkmanName"/>
            <label><span class="red">*</span>联系方式</label>
            <input class="over-input" required="1"  data-msg="请输入联系方式" id="marketLinkmanMobile" name="market.marketLinkmanMobile"/>
        </div>
        <div class="over-cell">
            <label><span class="red">*</span>身份证号</label>
            <input class="over-input"  required="1"  data-msg="请输入身份证号" id="marketLinkmanCode" name="market.marketLinkmanCode"/>
        </div>

        <div class="over-title">公司信息</div>
        <div class="over-cell">
            <label><span class="red">*</span>公司名称</label>
            <input class="over-input"  required="1"  data-msg="请输入公司名称" id="marketName" name="market.marketName"/>
            <label><span class="red">*</span>法人</label>
            <input class="over-input"  required="1"  data-msg="请输入法人" id="marketLegalName" name="market.marketLegalName"/>
        </div>
        <div class="over-cell">
            <label><span class="red">*</span>法人联系方式</label>
            <input class="over-input"  required="1"  data-msg="请输入法人联系方式" id="marketLegalMobile" name="market.marketLegalMobile"/>
        </div>

        <div class="over-title">车场信息</div>
        <div class="over-cell">
            <label><span class="red">*</span>车场面积</label>
            <span class="over-span"><input  required="1"  data-msg="请输入车场面积" id="marketArea" name="market.marketArea"/><b>平米</b></span>

        </div>

        <div class="over-title">合作信息</div>
        <div class="over-cell">
            <label><span class="red">*</span>合同有效期</label>
            <input class="over-date" required="1"  data-msg="请选择合同起始日期" value="<fmt:formatDate value="${vehicle.factoryDate}"
							pattern="yyyy-MM-dd"/>" id="marketContractBeginDate" name="market.marketContractBeginDate"
                   onclick="WdatePicker({lang:'zh-cn'}); "
                   data-options="validType:['minLength[1]']"/>
            <span class="poz">~</span>
            <input class="over-date" required="1"  data-msg="请选择合同结束日期" value="<fmt:formatDate value="${vehicle.factoryDate}"
							pattern="yyyy-MM-dd"/>" id="marketContractEndDate" name="market.marketContractEndDate"
                   onclick="WdatePicker({lang:'zh-cn'});"
                   data-options="validType:['minLength[1]']"/>
        </div>

        <div class="over-title">账号信息</div>
        <div class="over-cell">
            <label><span class="red">*</span>手机号</label>
            <input class="over-input"  id="marketMobile" name="market.marketMobile" required="1"  data-msg="请输入手机号" />
        </div>
        <div style="color: #a6a6a6;margin-left: 93px;margin-top: -10px;">
            手机号作为管理员账号使用,密码默认为手机号后6位
        </div>
    </form>
</div>
<%--<form id="myForm">--%>
    <%--<input type="hidden" name="market.marketUid" value="${uid}"/>--%>
    <%--<div>车场UID:${uid}</div>--%>
    <%--<div>负责人信息</div>--%>
    <%--<div class="box">--%>
        <%--<table>--%>
            <%--<tr>--%>
                <%--<td class="text-r" width="100px">--%>
                    <%--姓名:--%>
                <%--</td>--%>
                <%--<td>--%>
                    <%--<input class="input w200 easyui-validatebox" data-options="required:true,missingMessage:'请输入姓名'" id="marketLinkmanName" name="market.marketLinkmanName"/>--%>
                <%--</td>--%>
            <%--</tr>--%>
            <%--<tr>--%>
                <%--<td class="text-r" width="100px">--%>
                    <%--联系方式:--%>
                <%--</td>--%>
                <%--<td>--%>
                    <%--<input class="input w200 easyui-validatebox" data-options="required:true,missingMessage:'请输入联系方式'" id="marketLinkmanMobile" name="market.marketLinkmanMobile"/>--%>
                <%--</td>--%>
            <%--</tr>--%>
            <%--<tr>--%>
                <%--<td class="text-r" width="100px">--%>
                    <%--身份证号:--%>
                <%--</td>--%>
                <%--<td>--%>
                    <%--<input class="input w200 easyui-validatebox" data-options="required:true,missingMessage:'请输入身份证号'" id="marketLinkmanCode" name="market.marketLinkmanCode"/>--%>
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
                    <%--<input class="input w200 easyui-validatebox" data-options="required:true,missingMessage:'请输入公司名称'" id="marketName" name="market.marketName"/>--%>
                <%--</td>--%>
            <%--</tr>--%>
            <%--<tr>--%>
                <%--<td class="text-r" width="100px" id="feeMeter">--%>
                    <%--法人:--%>
                <%--</td>--%>
                <%--<td>--%>
                    <%--<input class="input w200 easyui-validatebox" data-options="required:true,missingMessage:'请输入法人'" id="marketLegalName" name="market.marketLegalName"/>--%>
                <%--</td>--%>
            <%--</tr>--%>
            <%--<tr>--%>
                <%--<td class="text-r" width="100px" id="feeMeter">--%>
                    <%--法人联系方式:--%>
                <%--</td>--%>
                <%--<td>--%>
                    <%--<input class="input w200 easyui-validatebox" data-options="required:true,missingMessage:'请输入法人联系方式'" id="marketLegalMobile" name="market.marketLegalMobile"/>--%>
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
                    <%--<input class="input w200 easyui-validatebox" data-options="required:true,missingMessage:'请输入车场面积'" id="marketArea" name="market.marketArea"/>--%>
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
                    <%--<input class="date w200 easyui-validatebox" value="<fmt:formatDate value="${vehicle.factoryDate}"--%>
							<%--pattern="yyyy-MM-dd"/>" id="marketContractBeginDate" name="market.marketContractBeginDate"--%>
                           <%--onclick="WdatePicker({lang:'zh-cn'});"--%>
                           <%--data-options="validType:['minLength[1]']"/>—--%>
                    <%--<input class="date w200 easyui-validatebox" value="<fmt:formatDate value="${vehicle.factoryDate}"--%>
							<%--pattern="yyyy-MM-dd"/>" id="marketContractEndDate" name="market.marketContractEndDate"--%>
                           <%--onclick="WdatePicker({lang:'zh-cn'});"--%>
                           <%--data-options="validType:['minLength[1]']"/>--%>
                <%--</td>--%>
            <%--</tr>--%>
        <%--</table>--%>
    <%--</div>--%>
    <%--<div>账号信息</div>--%>
    <%--<div class="box">--%>
        <%--<table>--%>
            <%--<tr>--%>
                <%--<td class="text-r" width="100px">--%>
                   <%--手机号:--%>
                <%--</td>--%>
                <%--<td>--%>
                    <%--<input class="input w200 easyui-validatebox" data-options="required:true,missingMessage:'请输入手机号'" id="marketMobile" name="market.marketMobile" />--%>
                <%--</td>--%>
            <%--</tr>--%>
        <%--</table>--%>
    <%--</div>--%>
<%--</form>--%>
</body>
</html>
