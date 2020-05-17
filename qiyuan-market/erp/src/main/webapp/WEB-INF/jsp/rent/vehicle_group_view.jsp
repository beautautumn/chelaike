<!DOCTYPE html>
<%@ page language="java" pageEncoding="UTF-8"
	contentType="text/html; charset=UTF-8"%>
<%@ include file="/common/taglibs.jsp"%>
<%@ include file="/common/meta.jsp"%>
<%@taglib uri="/struts-tags" prefix="s"%>
<html>
<head>
<meta charset="utf-8">
<title>车辆分级设置</title>
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta name="description" content="">
<meta name="author" content="Muhammad Usman">

<link rel="stylesheet"
	href="${ctx}/js/plugins/kindeditor-4.1.10/themes/default/default.css" />
<script charset="utf-8"
	src="${ctx}/js/plugins/kindeditor-4.1.10/kindeditor-min.js"></script>
<script charset="utf-8"
	src="${ctx}/js/plugins/kindeditor-4.1.10/lang/zh_CN.js"></script>


<style type="text/css">
body {
	padding-bottom: 40px;
}

.sidebar-nav {
	padding: 9px 0;
}
</style>

<script>
	function do_submit() {
		var flag =true;
		if(check(flag)==false){
			alert("表单未填写完整，请填写完整！");
		}else{
			var trList = document.getElementsByTagName("tr");
			var valList = new Array();
			$("#super_table tr:not(:last)").each(function(i)
			{
				var inputList = this.getElementsByTagName('input');
				var objStr = '';
				for ( var j = 0; j < inputList.length; j++) {
					objStr += inputList[j].value+ ',';
				}
					objStr = objStr.substr(0,objStr.length - 1);
					valList[i] = objStr;
			});
			var itemIndex = 0;
			var html1 = "";
			for ( var i = 0; i < valList.length; i++) {
				if (i % 3 == 0) {
					html1 = "<input type='hidden' name='confBeanList["+itemIndex+"].id' value='"+valList[i]+"'/>";
				}
				if (i % 3 == 1) {
					html1 = "<input type='hidden' name='confBeanList["+itemIndex+"].name' value='"+valList[i]+"'/>";
				}
				if (i % 3 == 2) {
					html1 = "<input type='hidden' name='confBeanList["+itemIndex+"].desc' value='"+valList[i]+"'/>";
					itemIndex++;
				}
				$("#hiddenDiv").append(html1);
			}
				var data = "";
				data = $("#userform").serialize();
				alert("data:"+data);
				return;
				$.ajax({
					type : 'post',
					url : '${ctx}/sys/vehicle_group_save.action',
					data : data,
					cache : false,
					async : false, //默认为true 异步     
					success : function(result) {
						console.log("the result is %o",result);
						if (result == "0001") {
							alert("操作成功");
							location.reload(true);
						} else if (result == "1004") {
							alert("操作失败");
							location.reload(true);
						}
					}
				});
		}
	}
	
	function check(flag){
	$(".input-xlarge").each(
			function() {
				if (this.value == "" || this.value == null) {
					flag = false;
				}
			});
			return flag;
	}

	function vehicle_group_add() {
		var length = $('#super_table tr').length;
		var super_html = create_super_html((length - 1) / 3 + 1);

		console.log("the create_super_html is %o", super_html);
		$("#insert_super_tr").before(super_html);

	}

	function create_super_html(length) {
		var result = "";
		var i = 2 * length - 1;
		console.log("the creeat i is :%o", i);
		result += "<tr id=\"group_"+i+"\"><td><input id=\"confId\"  name=\"catalogueGroup.confId\" value=\"${catalogueGroup.confId}\"  type=\"hidden\" ></td></tr><tr  id=\"tr_super_"+i+"\"><td rowspan=\"2\"><i class=\"icon-ban-cirle icon-white\">"
				+ length
				+ "</i></td><td align=\"left\">分级名称：<span style=\"color:red\">*</span></td><td><input class=\"input-xlarge\" id=\"groupName\"  name=\"catagroupConf.catalogueGroup.groupName\" value=\"${catagroupConf.catalogueGroup.groupName}\"  type=\"text\" ></td><td rowspan=\"2\" valign=\"center\"><a class=\"btn btn-danger\"  href=\"javascript:delete_node('super',"
				+ length
				+ ");\"><i class=\"icon-trash icon-white\"></i>删除</a></td></tr><tr  id=\"tr_super_"
				+ (i + 1)
				+ "\"><td align=\"left\">描述：<span style=\"color:red\">*</span></td><td><input class=\"input-xlarge\" id=\"groupDesc\"  name=\"catagroupConf.groupDesc\" value=\"${catagroupConf.groupDesc}\"  type=\"text\" ></td></tr>";
		return result;
	}

	function delete_node(nodeType, id) {
		var length = $('#super_table tr').length;
		var i = 2 * id - 1;
		var j = i + 1;
		console.log("the i is %o", i);
		var confId;
		confId = document.getElementById("group_" + i).getElementsByTagName(
				"input")[0].value;
		$("#group_" + i).remove();
		$("#tr_" + nodeType + "_" + i).remove();
		$("#tr_" + nodeType + "_" + j).remove();
		if (confId == '') {
			return;
		}
		$.ajax({
			type : 'POST',
			url : '${ctx}/sys/vehicle_group_delete.action',
			data : {
				"confId" : confId
			},
			cache : false,
			async : false, //默认为true 异步     
			success : function(result) {
				console.log("the result is %o", result);
				if (result == "0001") {
					alert("操作成功");
					location.reload(true);
				} else if (result == "1004") {
					alert("操作失败");
					location.reload(true);
				}
			}
		});
	}
</script>

</head>
<body>
	<div class="container-fluid">
		<div class="row-fluid">

			<div id="content" class="span10">
				<div class="row-fluid sortable">
					<div class="box span12">
						<div class="box-header well" data-original-title>
							<h2>
								<i class="icon-edit"></i> 车辆分级
							</h2>
						</div>
						<div class="box-content">
							<form class="form-horizontal" name="userform" id="userform">
								<div id="hiddenDiv" style="display:none;"></div>
								<fieldset>
									<div class="control-group">
										<label class="control-label">车辆分级：</label>

										<div class="controls">
											<fieldset
												style=" border:1px solid #61B5CF;width:80%;padding:5px;">
												<table id="super_table">
														<tr id="group_1">
															<td><s:hidden name="catagroupConf.confId" /></td>
														</tr>
														<tr id="tr_super_1">
															<td rowspan="2" width="10%"><i
																class="icon-ban-cirle icon-white">1</i>
															</td>
															<td align="left">分级名称：<span style="color:red">*</span>
															</td>
															<td><input class="input-xlarge" id="groupName"
																name="catagroupConf.catalogueGroup.groupName"
																value="${catagroupConf.catalogueGroup.groupName}"
																type="text"></td>
															<td rowspan="2" valign="center"><a
																class="btn btn-danger"
																href="javascript:delete_node('super',1);"> <i
																	class="icon-trash icon-white"></i> 删除 </a></td>
														</tr>
														<tr id="tr_super_2">
															<td align="left">描述：<span style="color:red">*</span>
															</td>
															<td><input class="input-xlarge" id="groupDesc"
																name="catagroupConf.groupDesc"
																value="${catagroupConf.groupDesc}" type="text">
															</td>
														</tr>

													<tr id="insert_super_tr">
														<td colspan="4" style="padding-left:150px;"><a
															class="btn btn-success"
															href="javascript:vehicle_group_add();"> <i
																class="icon-plus icon-white"></i> 添加 </a></td>
													</tr>
												</table>
											</fieldset>
										</div>
									</div>
									<div class="form-actions">
										<button type="button" class="btn btn-primary"
											onclick="do_submit();">保存</button>
									</div>
								</fieldset>
							</form>

						</div>
					</div>
					<!--/span-->

				</div>
				<!--/row-->

			</div>
			<!--/#content.span10-->
		</div>
		<!--/fluid-row-->


	</div>
	<!--/.fluid-container-->



</body>
</html>
