<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@taglib uri="/struts-tags" prefix="s"%>
<%@ include file="/common/taglibs.jsp"%>
<%@ include file="/common/meta.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>新增场地</title>
<link rel="stylesheet" type="text/css" href="${ctx}/css/style.css" />
<script type="text/javascript" src="${ctx}/js/common/syUtil.js"></script>
<script type="text/javascript" src="${ctx}/js/common/ctutil.js"></script>
<script type="text/javascript" src="${ctx}/js/common/menu.js"></script>
<script type="text/javascript" src="${ctx}/js/common/select.js"></script>
<script type="text/javascript" src="${ctx}/js/common/jquery.json-2.4.js"></script>
<script type="text/javascript" src="${ctx}/js/business/vehicle/vehicle_vin.js"></script>
<script type="text/javascript" src="${ctx}/js/pages/catalogue/catalogue.js"></script>
<script type="text/javascript" src="${ctx}/js/pages/region/region.js"></script>
<script type="text/javascript" src="${ctx}/js/common/validator/validator.js"></script>

<script>
  var coutReg = /^[0-9]+(\.[0-9]+)?$/;
  var numReg = /^[1-9]\d{0,20}$/;
  
  var nameCheckResult = "";
  var areaTotalResult = "";
  var monthMeterResult = "";
  var unitTotalResult = "";
  var monthUnitResult = "";
  var carPortResult = "";
  var api = frameElement.api, W = api.opener;
  function changeType(i){
    $("#totalCount").val("");
    $("#monthRentFee").val("");
    $("#totalUnitCount").val("");
    $("#monthUnitRentFee").val("");
    $("#carCount").val("");
      if(i==0){
        $("#siteTotal").attr("style", "display:''");
        $("#monthMeterFee").attr("style", "display:''");
        $("#areaTotal").attr("style", "display:''");
        $("#areaTotalSite").attr("style", "display:''");
        $("#feeMeter").attr("style", "display:''");
        $("#feeMonthMeter").attr("style", "display:''");
        
        $("#totalUnit").attr("style", "display:none");
        $("#monthUnitFee").attr("style", "display:none");
        $("#unitCarPort").attr("style", "display:none");
        $("#unitTotal").attr("style", "display:none");
        $("#unitTotalStandard").attr("style", "display:none");
        $("#feeUnit").attr("style", "display:none");
        $("#feeMonthUnit").attr("style", "display:none");
        $("#carport").attr("style", "display:none");
        $("#allowCarport").attr("style", "display:none");
      }
      if(i==1){
        $("#siteTotal").attr("style", "display:none");
        $("#monthMeterFee").attr("style", "display:none");
        $("#areaTotal").attr("style", "display:none");
        $("#areaTotalSite").attr("style", "display:none");
        $("#feeMeter").attr("style", "display:none");
        $("#feeMonthMeter").attr("style", "display:none");
        
        $("#totalUnit").attr("style", "display:''");
        $("#monthUnitFee").attr("style", "display:''");
        $("#unitCarPort").attr("style", "display:''");
        $("#unitTotal").attr("style", "display:''");
        $("#unitTotalStandard").attr("style", "display:''");
        $("#feeUnit").attr("style", "display:''");
        $("#feeMonthUnit").attr("style", "display:''");
        $("#carport").attr("style", "display:''");
        $("#allowCarport").attr("style", "display:''");
      }
  }
  
  function checkAreaTotal(inputValue){
    areaTotalResult = "ok";
    var val = $(inputValue).val()
            if(!numReg.test(val)){
              alert("输入的数值不正确！");
              areaTotalResult = "fail";
              return ;
            }else{
        return ;
      }
  }
  
  function checkMonthMeter(inputValue){
    monthMeterResult = "ok";
    var val = $(inputValue).val()
            if(!coutReg.test(val)){
              alert("输入的数值不正确！");
              monthMeterResult = "fail";
              return ;
            }else{
        return ;
      }
  }
  
  function checkUnitTotal(inputValue){
    unitTotalResult = "ok";
    var val = $(inputValue).val()
            if(!numReg.test(val)){
              alert("输入的数值不正确！");
              unitTotalResult = "fail";
              return ;
            }else{
        return ;
      }
  }
  
  function checkMonthUnit(inputValue){
    monthUnitResult = "ok";
    $(inputValue).parent().next("td").text("");
    var val = $(inputValue).val()
            if(!coutReg.test(val)){
              alert("输入的数值不正确！");
              monthUnitResult = "fail";
              return ;
            }else{
        return ;
      }
  }
  
  function checkCarPort(inputValue){
    carPortResult = "ok";
    var val = $(inputValue).val()
            if(!numReg.test(val)){
              alert("输入的数值不正确！");
              carPortResult = "fail";
              return ;
            }else{
        return ;
      }
  }
  
  function checkName(siteName){
    nameCheckResult = "ok";
    var val = $(siteName).val();
    if(val == null || val == ""){
                alert("场地区域名称不能为空！");
                nameCheckResult = "fail";
                return;
              }
              var reg = /^[\u4E00-\u9FA5A-Za-z0-9_]{1,20}$/;
              if(!reg.test(val)){
                alert("场地区域名称格式不正确！");
                nameCheckResult = "fail";
                return;
              }
  }
  
  
  function do_submit(){
    var data ="";
    var areaName = $("#areaName").val();
    if(areaName ==null ||areaName =="")
    {
        alert("请填写区域名称！");
        $("#areaName").focus();
        return;
    }
    var remark = $("#remark").val();
    var totalCount = $("#totalCount").val();
    if(totalCount ==null || totalCount =="")
    {
        alert("请填写总车位数!");
        $("#totalCount").focus();
        return;
    }      
    var monthRentFee = $("#monthRentFee").val();
    if(monthRentFee ==null || monthRentFee =="")
    {
       alert("请填写月租金!");
       $("#monthRentFee").focus();
       return;
    }else{
    	$("#monthRentFee").val(Number(monthRentFee).toFixed(0));
    }
      
    var carCount = $("#carCount").val();
    
    data = $("#myForm").serialize();
    ajaxPost(data);
  }
  
  function ajaxPost(data){
    $.ajax({
        cache: false,
        type: "POST",
        url:ctutil.bp()+"/rent/siteShop_add.action",
        data:data,
        async: false,
        error: function() {
        html = "数据请求失败";
        },
        success: function(data) {
          if(data=="success"){
            alert("保存成功！");
            api.get("new_shop",1).close();
            W.query1();  
          }else{
            alert("保存失败！");
            api.get("new_shop",1).close();
            W.query1();
          }
        }
      });
  }
  
</script>

</head>
<body>
<form id="myForm">  
<input type="hidden" name="siteShop.id" value="${siteShop.id }"/>
<div class="box">
      <table> 
        <tr>
          <td class="text-r" width="100px" ><span class="red">*</span>区域名称：</td>
          <td width="400px"><input class="input w200" id="areaName" name="siteShop.areaName" value="${siteShop.areaName }" /></td>
        </tr>
        <tr id="siteTotal">
          <td class="text-r" id="areaTotal" ><span class="red">*</span>区域商铺总数:</td>
          <td id="areaTotalSite"><input class="input w200" id="totalCount" name="siteShop.totalCount" value="${siteShop.totalCount }"  /> 间</td>
        </tr>
        <tr id="monthMeterFee">
          <td class="text-r" id="feeMeter"><span class="red">*</span>月单位租金:</td>
          <td id="feeMonthMeter"><input class="input w200" id="monthRentFee" name="siteShop.monthRentFee" value="<fmt:formatNumber type="number" value="${siteShop.monthRentFee/100 }" maxFractionDigits="0"/>" /> 元</td>
        </tr>
        <tr> 
          <td class="text-r">备注:</td>
          <td><textarea id="remark" style="width:280px;height:120px" name="siteShop.remark" />${siteShop.remark }</textarea></td>
        </tr>
    </table>
</div>    
</form>         
</body>
</html>
