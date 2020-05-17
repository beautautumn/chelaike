<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@taglib uri="/struts-tags" prefix="s"%>
<%@ include file="/common/taglibs.jsp"%>
<%@ include file="/common/meta.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>选择场地区域</title>
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
<script type="text/javascript" src="${ctx}/js/plugins/My97DatePicker/WdatePicker.js"></script>
<script>
  var api = frameElement.api, W = api.opener;
  var reg = /^[0-9]+(\.[0-9]+)?$/; 
  var regFloat=/^[0-9]+(\.[0-9]+)?$/; 
  
  $(function(){
       $("#areaNoAll").val('+${shopNoAll}+');
       getChange();
    
    });
    
  function getChange(){
       
        var renttype =$("select option:selected").attr('renttype');
        var monthrentfee =$("select option:selected").attr('monthrentfee');
        var totalcount =$("select option:selected").attr('totalcount');
        var freecount =$("select option:selected").attr('freecount');
        var area = $("select option:selected").val();
        $('#carCountTxt').attr("style","display:none;");
        $('#carCountRow').attr("style","display:none;");  
         
        if(area=='-1'){
          $("#totalCountText").html("商铺总数：");
            $("#freeCountText").html("可租商铺数：");
            $("#monthRentFeeText").html("月单位租金：<span class='red'>*</span>");
            $("#leaseCountText").html("租用间数：<span class='red'>*</span>");
            $("#portName").html("场地编号：<span class='red'>*</span>");
            $("#totalCount").val('');
            $("#freeCount").val('');
            $("#monthRentFee").val('').prop("readonly", true).attr("disabled", "disabled").css("background-color","F0F0F0");
            $("#leaseCount").val('');
            $("#monthTotalFee").val('');
            $("#areaNo").val('');
            $('#carCountTxt').removeAttr("style");
            $('#carCountRow').removeAttr("style");
        }else{
              $("#totalCountText").html("商铺总数：");
              $("#freeCountText").html("可租商铺数：");
              $("#monthRentFeeText").html("月单位租金：<span class='red'>*</span>");
              $("#leaseCountText").html("租用间数：<span class='red'>*</span>");
              $("#portName").html("场地编号：<span class='red'>*</span>");
              $("#totalCount").val(totalcount);
              $("#freeCount").val(freecount);
              
              $("#monthRentFee").val(monthrentfee).prop("readonly", true).attr("disabled", "disabled").css("background-color","F0F0F0");
              $("#leaseCount").val('');
              $("#monthTotalFee").val('');
              $("#areaNo").val('');
              $('#carCountTxt').removeAttr("style");
              $('#carCountRow').removeAttr("style");
        }
  
  }
  
  function calc(){
    var leaseCount = $("#leaseCount").val();
    var freecount =$("select option:selected").attr('freecount');
    if(leaseCount =="")
    {
      leaseCount =0;
    }
    var carCount = $("#carCount").val();
    if(carCount =="")
    {
      carCount =0;
    }    
    var monthTotalFee = $("#monthTotalFee").val();
    if(monthTotalFee =="")
    {
       monthTotalFee =0;
    }  
    var renttype =$("select option:selected").attr('renttype');  
    var monthRentFee = $("#monthRentFee").val();
    //按面积
    if(renttype ==0)
    {
       monthTotalFee=monthRentFee * leaseCount;
       $("#monthTotalFee").val(monthTotalFee.toFixed(2));
    }
    else
    {
       if(leaseCount-freecount>0)
       {
         alert("该区域剩余车位数"+freecount+",租用车位数不能大于"+freecount);
         $("#leaseCount").focus();
         return;
       }
       /* freecount =freecount -carCount;
       $("select option:selected").attr('freecount',freecount); */
       carCount =leaseCount;
       $("#carCount").val(carCount);    
       monthTotalFee=monthRentFee * leaseCount;
       $("#monthTotalFee").val(monthTotalFee.toFixed(2));
    }
    
  }
  
 

  function checkAreaNo(){
    return;
    var flag=false;
    var areaNoList= $("#areaNoAll").val().split(",");
    for(var i=0;i<areaNoList.length;i++){
      if($("#areaNo").val()==areaNoList[i]){
        flag = true;
      }
    }
    return flag;
  }
  
  
  function do_submit(){
    var areaNoList= $("#areaNoAll").val().split(",");
    if($("#siteArea option:selected").val()=='-1'){
      alert("请选择场地区域");
      return;
    }
      if($("#totalCount").val()==''){
        alert("商铺总数不能为空");
        $("#totalCount").focus();
        return;
      }else{
        if(!reg.test($("#totalCount").val())){
                alert("商铺总数必须是整数，请重新输入");
                $("#totalCount").focus();
                return ;
              }
      }
      if($("#monthRentFee").val()==''){
        alert("月单位租金不能为空");
        $("#monthRentFee").focus();
        return;
      }else{
        if(!regFloat.test($("#monthRentFee").val())){
                alert("月单位租金必须是整数或者小数，请重新输入");
                $("#monthRentFee").focus();
                return ;
              }
      }
      if($("#leaseCount").val()==''){
        $("#leaseCount").focus();
        alert("租用车位不能为空");
        return;
      }else{
        if(!reg.test($("#leaseCount").val())){
                alert("租用数量必须是整数，请重新输入");
                $("#leaseCount").focus();
                return ;
              }else{
                if(parseInt($("#leaseCount").val())>parseInt($("#freeCount").val())){
                  alert("租用数量超过可租用车位，请重新输入");
                  $("#leaseCount").focus();
                  return ;
                }
              }
      }
    if($("#monthTotalFee").val()==''){
      alert("月租金不能为空");
      return;
    }
    if($("#areaNo").val()==''){
      alert("场地编号不能为空");
      return;
    }else{
          if(checkAreaNo()){
            alert("场地编号与之前操作的场地编号有重复，请重新输入");
              return ;
          }
    }
    
    var freecount =$("select option:selected").attr('freecount');
    var carCount = $("#carCount").val(carCount);
    freecount =freecount -carCount;
    $("select option:selected").attr('freecount',freecount);
    var date=$("#siteArea option:selected").attr('areaname')+";"+
         $("#siteArea option:selected").attr('renttype')+";"+
         $("#totalCount").val()+";"+
         $("#monthRentFee").val()+";"+
         $("#leaseCount").val()+";"+
         $("#monthTotalFee").val()+";"+
         $("#areaNo").val()+";"+
         $("#carCount").val()+";"+$("#siteArea").val();
    
    api.get('addContractPage').doGetSitePage(date);
    api.get("getAddSitePage",1).close();
     
  }
</script>

</head>
<body>
<form id="myForm">  
<div style="text-align:center;margin-top:20px;margin-left:60px;">
      <input type="hidden" id="areaNoAll" name="areaNoAll"/>
        <table>
          
          <tr style="width:500px;">
            <td class="text-r" width="100px;">场地区域：<span class="red">*</span></td>
            <td width="150px;">
              <select id="siteArea" class="input w100" name="siteArea" onchange="getChange()">
                <option value='-1' >请选择</option>
              <s:iterator value="siteShops">
                <option value="<s:property value='id'/>" id="${id}"
                  areaname="${areaName}" renttype="${rentType}" 
                  totalcount="${totalCount}" monthrentfee="${monthRentFee/100}"  freecount="${freeCount}" >
                  ${areaName}
                </option>
              </s:iterator>
                      </select>
            </td>
            <s:iterator value="siteShops">
            <input type="hidden" id="${id}" value="0" />
            </s:iterator>
          </tr>
          <tr style="width:500px;">
            <td class="text-r" width="100px;">&nbsp;</td>
          </tr>
          <tr style="width:500px;">
            <td id="totalCountText" class="text-r" style="width:100px;" >区域总面积：</td>
            <td class="text-l" width="200px;">
              <input type="text" id="totalCount" name="totalCount" style="background-color:#F0F0F0"  readonly="readonly" disabled="disabled" ></input>
            </td>
          </tr>
          <tr style="width:500px;">
            <td class="text-r" width="100px;">&nbsp;</td>
          </tr>
          <tr style="width:500px;">
            <td id="freeCountText" class="text-r" style="width:100px;" >可租用面积：</td>
            <td class="text-l" width="200px;">
              <input type="text" id="freeCount" name="freeCount" style="background-color:#F0F0F0"  readonly="readonly" disabled="disabled" ></input>
            </td>
          </tr>
          <tr style="width:500px;">
            <td class="text-r" width="100px;">&nbsp;</td>
          </tr>
          <tr style="width:500px;">
            <td id="monthRentFeeText" class="text-r" style="width:100px;" >月平米租金：<span class="red">*</span></td>
            <td class="text-l" width="200px;">
              <input type="text" id="monthRentFee" name="monthRentFee"  style="background-color:#F0F0F0"  readonly="readonly" disabled="disabled"  >&nbsp;元</input>
            </td>
          </tr>
          <tr style="width:500px;">
            <td class="text-r" width="100px;">&nbsp;</td>
          </tr>
          <tr style="width:500px;">
            <td id="leaseCountText" class="text-r" style="width:100px;" >租用面积：<span class="red">*</span></td>
            <td class="text-l" width="200px;">
              <input type="text" id="leaseCount" name="leaseCount"  onblur="javascript:calc()"   ></input>
            </td>
          </tr>
          <tr style="width:500px;">
            <td class="text-r" width="100px;">&nbsp;</td>
          </tr>
          <tr style="width:500px;">
            <td class="text-r" style="width:100px;" >月租金：<span class="red">*</span></td>
            <td class="text-l" width="200px;">
              <input type="text" id="monthTotalFee"  name="monthTotalFee" >&nbsp;元</input>
            </td>
          </tr>
          <tr style="width:500px;">
            <td class="text-r" width="100px;">&nbsp;</td>
          </tr>
          <tr style="width:500px;">
            <td class="text-r" style="width:100px;" id='portName'>场地编号：<span class="red">*</span></td>
            <td class="text-l" width="200px;">
              <textarea style="width:135px;height:40px"  id="areaNo" name="areaNo"  onkeyup="if(/[;]/.test(this.value)){var str = this.value;this.value =str.substring(0,str.length-1)}" ></textarea>
            </td>
          </tr>
          <tr style="width:500px;">
            <td class="text-r" style="width:100px;" id='portName'></td>
            <td class="text-l" width="200px;">
              <!-- <font color="red">请输入正确的车位号/场地编号，如有多个编号请用英文逗号分隔！</font> -->  
            </td>
          </tr>
                    <tr style="width:500px;">
            <td class="text-r" width="100px;">&nbsp;</td>
          </tr>
          <tr style="width:500px;">
            <td class="text-r" width="100px;">&nbsp;</td>
          </tr>
          
        </table>
      </div>
  
</form>         
</body>
</html>
