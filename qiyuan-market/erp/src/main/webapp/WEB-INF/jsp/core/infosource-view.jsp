<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ include file="/common/taglibs.jsp"%>
<%@ include file="/common/meta.jsp"%>
<!DOCTYPE html>
<html>
	<head>
		<title>渠道设置</title>
		<meta name="viewport" content="width=device-width, initial-scale=1">
    <script type="text/javascript" src="${ctx}/js/common/syUtil.js"></script>
    <script type="text/javascript" src="${ctx}/js/common/ctutil.js"></script>
    <script type="text/javascript" src="${ctx}/js/common/menu.js"></script>
    <script type="text/javascript" src="${ctx}/js/common/select.js"></script>
    <script type="text/javascript" src="${ctx}/js/common/jquery.json-2.4.js"></script>
    <script type="text/javascript" src="${ctx}/js/business/vehicle/vehicle_vin.js"></script>
    <script type="text/javascript" src="${ctx}/js/pages/catalogue/catalogue.js"></script>
    <script type="text/javascript" src="${ctx}/js/pages/region/region.js"></script>
    <script type="text/javascript" src="${ctx}/js/common/validator/validator.js"></script>
    <link rel="stylesheet" type="text/css" href="${ctx}/css/style.css" />
    <!--
    <link rel="stylesheet" type="text/css" href="${ctx}/js/plugins/bootstrap-3.0.3/css/bootstrap.min.css" />
    <script type="text/javascript" src="${ctx}/js/plugins/jquery/jquery.js"></script>
    <script type="text/javascript" src="${ctx}/js/plugins/bootstrap-3.0.3/js/bootstrap.min.js"></script>
  -->
    
    <script type="text/javascript">
    var api = frameElement.api, W = api.opener;
      function do_submit() { 
       
          var name=$('#name').val();
          if(name==""){
            alert("请填写渠道名称！");
            // eu.showAlertMsg("请填写渠道名称！", "warning");
            $('#name').focus();
            return;
          }
                
          var param=$('#form').serialize();
           var dialog_object=W.get_dialog_instance();
dialog_object.button({id:'ok',disabled: true});
          $.post('${ctx}/core/infosource_edit.action',param,function(data){
            if(data=='0000'){
              alert("编辑信息成功");
              api.get("infosource_dialog",1).close();
              W.query1();
            }else{
              alert("编辑信息失败");
              dialog_object.button({id:'ok',disabled:false});
              return;
            }
          });          
      }

    </script>
	</head>
	<body>
	<form class="form-horizontal" role="form" id="form" name="form">
    <input type="hidden" name="sysParamBean.id" value="${sysParamBean.id}" />
    <input type="hidden" name="sysParamBean.sourceType" value="${sourceType}" />
    <div class="box">
			<table>
				<tr>
					<td class="text-r" width="158"><font color="red">*</font>&nbsp;&nbsp;渠道名称：</td>
					<td width="430">
						<input type="email" class="input w200" name="sysParamBean.name" 
     					 id="name" placeholder="渠道名称" value="${sysParamBean.name}">
					</td>
				</tr>
    	    	<tr>
					<td class="text-r" width="158">备注：</td>
					<td width="430">
						<textarea class="area" rows="3" id="remark" name="sysParamBean.remark" placeholder="备注">${sysParamBean.remark}</textarea>
					</td>
				</tr>				
			</table>		
		</div>
</form>
</body>
</html>