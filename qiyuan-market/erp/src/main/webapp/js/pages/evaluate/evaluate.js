/***********************************************/
/*评估单
/*Author : xueyufish
/***********************************************/
evaluate = (function() {

	/**
	 * 热点DIV操作对象
	 * [
	 *      {"itemCode" : 1},
	 *      {"itemCode" : 2}
	 * ]
	 */
	var HOTAREA_DIV_OPT_OBJ = [];

	/**
	 * 热点对话框模板, 用于选择热点后生成对话框DIV
	 * 模板中的替换字段应被每个热点替换成相对应的值字段
	 */
	var _hotarea_dialog_div_template =
		"<div id='@item_div_id@' style='display:none' class='quick-choose'>" +
		"<div class='choose-t'>" +
		"<div class='choose-b'>" +
		"<div class='choose-box'>" +
		"<div class='choose-box-t'>" +
		"<div class='choose-tit'>@item_name@损伤选择</div>" +
		"<div class='choose-close'>" +
		"<a href='javascript:void(0);' onclick='javascript:$(\"#@item_div_id@\").dialog(\"close\");'>" +
		"<img src='../common/images/pgd-tanchu-close.png' /></a>" +
		"</div>" +
		"</div>" +
		"<div class='choose-box-b'>" +
		"<div class='injury-type'>" +
		"<p class='injury-title'>损伤类型</p> " +
		"<table cellspacing='0px' class='type-tab'>" +
		"@project_damage_items@" + //损伤类型占位符 
	"</table>" +
		"</div>" +
		"<div class='injury-degree'>" +
		"<p class='injury-title'>损伤程度：</p>" +
		"<table cellspacing='0px' class='type-tab'>" +
		"@project_damage_level@" + //损伤程度占位符 
	"</table>" +
		"</div>" +
		"<div class='injury-photo'>" +
		"<p class='injury-title'>损伤照片：</p>" +
		"<div class='injury-img'>@injure_image@</div>" +
		"</div>" +
		"</div>" +
		"<div class='choose-box-f'>" +
		"<a href='javascript:void(0);' " +
		"onclick='javascript:if(eval_state_save.save_hotarea_state(" +
		"\"@item_id@\", \"@item_name@\", \"@item_type@\", \"@hotarea_type@\", " +
		"\"@hotarea_coord@\", \"@damage_items@\", \"@damage_level@\")) " +
		"$(\"#@item_div_id@\").dialog(\"close\");' class='btn'>保存</a>" +
		"<a href='javascript:void(0);' " +
		"onclick='javascript:if(eval_state_save.cancel_hotarea_state(" +
		"\"@item_id@\", \"@item_name@\", \"@item_type@\", \"@hotarea_type@\", " +
		"\"@hotarea_coord@\", \"@damage_items@\", \"@damage_level@\")) " +
		"$(\"#@item_div_id@\").dialog(\"close\");' class='btn'>无损伤</a>";
	"</div>" +
		"</div>" +
		"</div>" +
		"</div>";

	/**
	 * 漆面检查对话框模板, 用于选择热点后生成漆面检查对话框DIV
	 * 模板中的替换字段应被每个热点替换成相对应的值字段
	 */
	var _paint_dialog_div_template =
		"<div id='@item_div_id@' style='display:none' class='quick-choose'>" +
		"<div class='choose-t'>" +
		"<div class='choose-b'>" +
		"<div class='choose-box'>" +
		"<div class='choose-box-t'>" +
		"<div class='choose-tit'>@item_name@漆面选择</div>" +
		"<div class='choose-close'>" +
		"<a href='javascript:void(0);' onclick='javascript:$(\"#@item_div_id@\").dialog(\"close\");'>" +
		"<img src='../common/images/pgd-tanchu-close.png' /></a>" +
		"</div>" +
		"</div>" +
		"<div class='choose-box-b'>" +
		"<div class='injury-type'>" +
		"<table cellspacing='0px' class='type-tab'>" +
		"@project_damage_items@" +
		"</table>" +
		"</div>" +
		"</div>" +
		"<div class='choose-box-f'>" +
		"<a href='javascript:void(0);' " +
		"onclick='javascript:if(eval_state_save.save_hotarea_state(" +
		"\"@item_id@\", \"@item_name@\", \"@item_type@\", \"@hotarea_type@\", " +
		"\"@hotarea_coord@\", \"@damage_items@\", \"@damage_level@\")) " +
		"$(\"#@item_div_id@\").dialog(\"close\");' class='btn'>保存</a>" +
		"<a href='javascript:void(0);' " +
		"onclick='javascript:if(eval_state_save.cancel_hotarea_state(" +
		"\"@item_id@\", \"@item_name@\", \"@item_type@\", \"@hotarea_type@\", " +
		"\"@hotarea_coord@\", \"@damage_items@\", \"@damage_level@\")) " +
		"$(\"#@item_div_id@\").dialog(\"close\");' class='btn'>无损伤</a>";
	"</div>" +
		"</div>" +
		"</div>" +
		"</div>";

	/**
	 * 工况快速选择对话框模板
	 */
	var _conditions_dialog_div_template =
		"<div id=\"@item_div_id@\" style='display:none' class=\"quick-choose\">" +
		"<div class=\"choose-t\">" +
		"<div class=\"choose-b\">" +
		"<div class=\"choose-box\">" +
		"<div class=\"choose-box-t\">" +
		"<div class=\"choose-tit\">问题</div>" +
		"<div class=\"choose-close\">" +
		"<a href=\"javascript:void(0);\" onclick='javascript:$(\"#@item_div_id@\").dialog(\"close\");'>" +
		"<img src=\"../common/images/pgd-tanchu-close.png\" />" +
		"</a>" +
		"</div>" +
		"</div>" +
		"<div class=\"choose-box-b\" style=\"padding-top:5px;\"> " +
		"<p>@other_desc@</p>" + //其他说明占位符
	"<table cellspacing=\"0px\" class=\"type-tab\">@damage_items@</table>" + //损伤项目占位符
	"</div>" +
		"<div class=\"choose-box-f\">" +
		"<a href=\"javascript:void(0);\" onclick='javascript:if(eval_state_save.save_conditions_state(\"@item_code@\")) $(\"#@item_div_id@\").dialog(\"close\");' class=\"btn\">确定</a>" +
		"<a href=\"javascript:void(0);\" onclick='javascript:$(\"#@item_div_id@\").dialog(\"close\");' class=\"btn\">取消</a>" +
		"</div>" +
		"</div>" +
		"</div>" +
		"</div>" +
		"</div>";

	/**
	 * 初始化工况检查DIV
	 */
	var _init_conditions_dialog_div = function(conditionsItem, conditions_state) {
		console.group("_init_conditions_dialog_div");

		console.log("_init_conditions_dialog_div, conditionsItem is: %o, conditions_state is: %s",
			conditionsItem, conditions_state);

		var item_div_id = "divConditionsDialog_" + conditionsItem.itemCode;

		var conditionsResult;
		if (conditions_state == evaluate_comm.get_conditions_state_update()) {
			//如果当前热点状态为更新，获取当前热点之前的评估结果
			conditionsResult = evaluate_comm.get_cur_conditions_result(conditionsItem);
		}

		var other_desc;
		if (conditions_state == evaluate_comm.get_conditions_state_update()) {
			if (conditionsResult.otherItemDesc.length == 0) { //如果其他说明为空，显示默认值
				other_desc = "<input type=\"text\" id=\"txtOtherDesc_" + conditionsItem.itemCode +
					"\" class=\"input100\" style=\"width:480px;\" value=\"其它说明填写\" onfocus=\"javascript:$(this).val('');\"/>";
			} else { //如果其他说明不空，显示已有的值
				other_desc = "<input type=\"text\" id=\"txtOtherDesc_" + conditionsItem.itemCode +
					"\" class=\"input100\" style=\"width:480px;\" value=\"" + conditionsResult.otherItemDesc.join() + "\" onfocus=\"javascript:$(this).val('');\"/>";
			}
		} else if (conditions_state == evaluate_comm.get_conditions_state_new()) {
			other_desc = "<input type=\"text\" id=\"txtOtherDesc_" + conditionsItem.itemCode +
				"\" class=\"input100\" style=\"width:480px;\" value=\"其它说明填写\" onfocus=\"javascript:$(this).val('');\"/>";
		}


		var arr_damage_items = conditionsItem.damageItems.split(",");
		var str_damage_items = "<tr>";

		for (var i = 0; i < arr_damage_items.length; i++) {
			if ((i + 1) % 3 == 1) { //对于编号为1,4,7...的项前增加<tr>元素
				str_damage_items += "<tr>";
			}

			if (conditions_state == evaluate_comm.get_conditions_state_update()) {
				//如果当前检查状态为更新，构建checkbox并选中已选择的值
				var is_damage_items_exist = false; //参数中的评估项在结果中是否已经存在
				for (var j = 0; j < conditionsResult.damageItems.length; j++) {
					if (conditionsResult.damageItems[j] == arr_damage_items[i]) {
						is_damage_items_exist = true;
						break;
					}
				}
				if (is_damage_items_exist) { //如果某个具体损伤类型已选中过，标记选择状态为true
					str_damage_items += "<td width='165px'>" +
						"<input name='chxConditionDamageItem_" + conditionsItem.itemCode + "' type='checkbox' value='" + arr_damage_items[i] + "' checked='true'/>" +
						"&nbsp;" + arr_damage_items[i] + "</td>";
				} else {
					str_damage_items += "<td width='165px'>" +
						"<input name='chxConditionDamageItem_" + conditionsItem.itemCode + "' type='checkbox' value='" + arr_damage_items[i] + "' />" +
						"&nbsp;" + arr_damage_items[i] + "</td>";
				}
			} else if (conditions_state == evaluate_comm.get_conditions_state_new()) {
				//如果当前热点状态为新增，直接创建损伤类型标签
				str_damage_items += "<td width='165px'>" +
					"<input name='chxConditionDamageItem_" + conditionsItem.itemCode + "' type='checkbox' value='" + arr_damage_items[i] + "' />" +
					"&nbsp;" + arr_damage_items[i] + "</td>";
			}
			if (((i + 1) % 3 == 0) || (i == arr_damage_items.length - 1)) {
				str_damage_items += "</tr>"; //对于编号为3,6,9,...结尾增加</tr>
			}
		}
		console.log("str_damage_items is: %s", str_damage_items);


		var str_div = _conditions_dialog_div_template.replace(/\@item_div_id\@/g, item_div_id)
			.replace(/\@other_desc\@/g, other_desc)
			.replace(/\@damage_items\@/g, str_damage_items)
			.replace(/\@item_code\@/, conditionsItem.itemCode);

		console.log("after replace, str_div is: %s", str_div);

		if (!_is_div_opt_exist(conditionsItem.itemCode)) {
			var div_opt_json = {
				"itemCode": "" + conditionsItem.itemCode + ""
			};
			var save_div_json = _save_div_opt(div_opt_json);
			console.log("_init_conditions_dialog_div, save_div_json is: %o", save_div_json);
			$("#conditions_container").append(str_div);
		}

		console.groupEnd();
	}

	/**
	 * 保存DIV操作
	 */
	var _save_div_opt = function(opt_json) {
		HOTAREA_DIV_OPT_OBJ[HOTAREA_DIV_OPT_OBJ.length] = opt_json;
		return HOTAREA_DIV_OPT_OBJ;
	}

	var _is_div_opt_exist = function(item_code) {
		for (var i = 0; i < HOTAREA_DIV_OPT_OBJ.length; i++) {
			if (HOTAREA_DIV_OPT_OBJ[i].itemCode == item_code) {
				return true;
			}
		}
		return false;
	}

	/**
	 * 检查热点当前状态
	 * 算法：1、判断热点状态对象中是否包含当前评估项；
	 *       2、如果不包含当前选中评估项，状态返回HOTAREA_STATE_NEW(新增热点)；
	 *       3、如果不包含当前选中评估项，状态返回HOTAREA_STATE_UPDATE(修改热点)；
	 */
	var _check_hotarea_state = function(evalItem) {
		console.group("_check_hotarea_state");
		var hotarea_obj = evaluate_comm.get_hotarea_state_obj();
		console.log("_check_hotarea_state, hotarea_obj is: %o, evalItem is: %o",
			hotarea_obj, evalItem);

		if (evaluate_comm.is_eval_result_exists(evalItem.itemCode)) {
			console.log("_check_hotarea_state, eval result is exists, status is " +
				"HOTAREA_STATE_UPDATE");
			return evaluate_comm.get_hotarea_state_update();
		} else {
			console.log("_check_hotarea_state, eval result is not exists, status is " +
				"HOTAREA_STATE_NEW");
			return evaluate_comm.get_hotarea_state_new();
		}
		console.groupEnd();
	}

	/**
	 * 初始化热点对话框DIV
	 *
	 * 算法:
	 * 1、根据评估项参数中ID组装对话框DIV的ID标识，
	 *       格式为："divHotareaDialog_ + 评估项类型 + 评估项编码"
	 * 2、根据评估项参数中损伤类型选项组装对话框DIV中损伤类型checkbox;
	 * 3、如果当前热点状态参数为HOTAREA_STATE_UPDATE(修改热点)，则从热点状态对象
	 *       中读取当前所有热点数据值并找到ID=评估项参数ID的条目，修改损伤类型checkbox状态为选中；
	 * 4、根据评估项参数中损伤类型选项组装对话框DIV中损伤级别checkbox;
	 * 5、如果当前热点状态参数为HOTAREA_STATE_UPDATE(修改热点)，则从热点状态对象
	 *       中读取当前所有热点数据值并找到ID=评估项参数ID的条目，修改损伤级别checkbox状态为选中；
	 * 6、最后，如果页面中当前热点对话框DIV不存在，则在容器中添加热点对话框DIV；
	 *
	 * @param eval_item 评估项
	 * @param hotarea_state 当前热点状态
	 *
	 */
	var _init_hotarea_dialog_div = function(evalItem, hotarea_state) {
		console.group("_init_hotarea_dialog_div");

		console.log("_init_hotarea_dialog_div, evalItem is: %o, hotarea_state is: %s",
			evalItem, hotarea_state);

		var item_div_id = "divHotareaDialog_" + evalItem.itemType + "_" + evalItem.itemCode;
		console.log("item_div_id is: %s", item_div_id);

		var evalResult;
		if (hotarea_state == evaluate_comm.get_hotarea_state_update()) {
			//如果当前热点状态为更新，获取当前热点之前的评估结果
			evalResult = evaluate_comm.get_cur_eval_result(evalItem.itemCode);
		}

		var arr_damage_items = evalItem.projectDamageItems.split(","); //当前评估项参数
		var str_damage_items = "";
		for (var i = 0; i < arr_damage_items.length; i++) {
			if ((i + 1) % 4 == 1) { //对于编号为1,5,9...的项前增加<tr>元素
				str_damage_items += "<tr>";
			}

			if (hotarea_state == evaluate_comm.get_hotarea_state_update()) {
				//如果当前热点状态为更新，构建损伤类型checkbox并选择评估结果中已选择的值	            
				var is_damage_items_exist = false; //参数中的评估项在结果中是否已经存在	            
				arr_result_damage_items = evalResult.evalKind.split(",");
				for (var j = 0; j < arr_result_damage_items.length; j++) {
					if (arr_result_damage_items[j] == arr_damage_items[i]) {
						is_damage_items_exist = true;
						break;
					}
				}
				if (is_damage_items_exist) { //如果某个具体损伤类型已选中过，标记选择状态为true
					str_damage_items += "<td width='110px'><label>" +
						"<input name='chxDamageItem_" + evalItem.itemCode + "' type='checkbox' value='" + arr_damage_items[i] + "' checked='true'/>" +
						"&nbsp;" + arr_damage_items[i] + "</label></td>";
				} else {
					str_damage_items += "<td width='110px'><label>" +
						"<input name='chxDamageItem_" + evalItem.itemCode + "' type='checkbox' value='" + arr_damage_items[i] + "' />" +
						"&nbsp;" + arr_damage_items[i] + "</label></td>";
				}
			} else if (hotarea_state == evaluate_comm.get_hotarea_state_new()) {
				//如果当前热点状态为新增，直接创建损伤类型标签
				str_damage_items += "<td width='110px'><label>" +
					"<input name='chxDamageItem_" + evalItem.itemCode + "' type='checkbox' value='" + arr_damage_items[i] + "' />" +
					"&nbsp;" + arr_damage_items[i] + "</label></td>";
			}
			if (((i + 1) % 4 == 0) || (i == arr_damage_items.length - 1)) {
				str_damage_items += "</tr>"; //对于编号为4,8,12,...结尾增加</tr>
			}
		}
		console.log("str_damage_items is: %s", str_damage_items);

		var arr_damage_level = evalItem.projectDamageLevel.split(",");
		var str_damage_level = "<tr>";

		for (var i = 0; i < arr_damage_level.length; i++) {
			if (hotarea_state == evaluate_comm.get_hotarea_state_update()) {
				var is_damage_level_exist = false; //参数中的评估级别在结果中是否已经存在
				arr_result_damage_level = evalResult.evalDesc.split(",");
				for (var j = 0; j < arr_result_damage_level.length; j++) {
					if (arr_result_damage_level[j] == arr_damage_level[i]) {
						is_damage_level_exist = true;
						break;
					}
				}
				if (is_damage_level_exist) {
					str_damage_level += "<td width='70px'>" +
						"<label>" +
						"<input type='radio' name='rdDamageLevel_" + evalItem.itemCode + "' value='" + arr_damage_level[i] + "' checked='true' />" + arr_damage_level[i] +
						"</label></td>";
				} else {
					str_damage_level += "<td width='70px'>" +
						"<label>" +
						"<input type='radio' name='rdDamageLevel_" + evalItem.itemCode + "' value='" + arr_damage_level[i] + "' />" + arr_damage_level[i] +
						"</label></td>";
				}
			} else if (hotarea_state == evaluate_comm.get_hotarea_state_new()) {
				str_damage_level += "<td width='70px'>" +
					"<label>" +
					"<input type='radio' name='rdDamageLevel_" + evalItem.itemCode + "' value='" + arr_damage_level[i] + "' />" + arr_damage_level[i] +
					"</label></td>";
			}
		}
		str_damage_level += "</tr>";
		console.log("str_damage_level is: %s", str_damage_level);

		var injure_image_div = "";
		if (hotarea_state == evaluate_comm.get_hotarea_state_update()) {
			injure_image_div += "<img id=\"image_" + evalItem.itemCode + "\" src=\"" + evalResult.imgUrl + "\" />";
		} else if (hotarea_state == evaluate_comm.get_hotarea_state_new()) {
			injure_image_div += "<img id=\"image_" + evalItem.itemCode + "\" src=\"\" />";
		}
		injure_image_div += "<div id=\"queue\"></div>" +
			"<input id=\"file_upload_" + evalItem.itemCode + "\" name=\"file_upload_" + evalItem.itemCode + "\" type=\"file\" multiple=\"false\"> " +
			"<script type=\"text/javascript\">" +
			"$(function() {" +
			"$('#file_upload_" + evalItem.itemCode + "').uploadify({ " +
			"'formData': " +
			"{ " +
			" 'localFileName':'', " +
			" 'localFileSize':0 " +
			"}," +
			"'onUploadStart' : function(file) " +
			"{ " +
			" $('#file_upload_" + evalItem.itemCode + "').uploadify('settings', 'formData', " +
			"{'localFileName' : file.name, " +
			" 'localFileSize' : file.size " +
			"});" +
			"}," +
			" 'onSelect': function(file) { " +
			" if(file.size > 1024 * 1024 * 3) " +
			"{" +
			" alert(\"上传文件大小不能超过3MB!\"); " +
			" return false;" +
			"}" +
			"}," +
			"'swf' : '../common/js/upload/uploadify.swf', " +
			"'uploader' : 'evaluate_uploadEvalImages.action', " +
			"'buttonImage' : '../common/images/add-btn.png', " +
			"'width' : '100', " +
			"'height' : '110'," +
			"'fileTypeDesc' : '支持的格式：', " +
			"'fileTypeExts' : '*.jpg;*.jpge;*.gif;*.png'," +
			"'fileSizeLimit' : '3MB'," +
			"'fileObjName' : 'localFile', " +
			"'onUploadSuccess':function(file, data, response){ " +
			"    $(\"#image_" + evalItem.itemCode + "\").attr(\"src\", data); " +
			"}" +
			"});" +
			"}); " +
			"</script>";
		console.log("injure_image_div is: %s", injure_image_div);

		var str_div = _hotarea_dialog_div_template.replace(/\@item_div_id\@/g, item_div_id)
			.replace(/\@project_damage_items\@/g, str_damage_items)
			.replace(/\@project_damage_level\@/g, str_damage_level)
			.replace(/\@item_id\@/g, evalItem.itemCode)
			.replace(/\@item_name\@/g, evalItem.itemName)
			.replace(/\@item_type\@/g, evalItem.itemType)
			.replace(/\@hotarea_type\@/g, evalItem.hotAreaType)
			.replace(/\@hotarea_coord\@/g, evalItem.hotAreaCoord)
			.replace(/\@damage_items\@/g, evalItem.projectDamageItems)
			.replace(/\@damage_level\@/g, evalItem.projectDamageLevel)
			.replace(/\@injure_image\@/g, injure_image_div);
		console.log("after replace, str_div is: %s", str_div);

		if (!_is_div_opt_exist(evalItem.itemCode)) {
			var div_opt_json = {
				"itemCode": "" + evalItem.itemCode + ""
			};
			var save_div_json = _save_div_opt(div_opt_json);
			console.log("_init_hotarea_dialog_div, save_div_json is: %o", save_div_json);
			$("#hotarea_container").append(str_div);
		}

		console.groupEnd();
	}

	/**
	 * 初始化漆面损伤对话框DIV
	 *
	 * 算法:
	 * 1、根据评估项参数中ID组装对话框DIV的ID标识，
	 *       格式为："divHotareaDialog_ + 评估项类型 + 评估项编码"
	 * 2、根据评估项参数中损伤类型选项组装对话框DIV中损伤类型radiobutton;
	 * 3、如果当前热点状态参数为HOTAREA_STATE_UPDATE(修改热点)，则从热点状态对象
	 *       中读取当前所有热点数据值并找到ID=评估项参数ID的条目，修改radiobutton状态为选中
	 * 4、最后，如果页面中当前热点对话框DIV不存在，则在容器中添加热点对话框DIV；
	 *
	 * @param eval_item 评估项
	 * @param hotarea_state 当前热点状态
	 *
	 */
	var _init_paint_dialog_div = function(evalItem, hotarea_state) {
		console.group("_init_paint_dialog_div");

		console.log("_init_paint_dialog_div, evalItem is: %o, hotarea_state is: %s",
			evalItem, hotarea_state);

		var item_div_id = "divHotareaDialog_" + evalItem.itemType + "_" + evalItem.itemCode;
		console.log("item_div_id is: %s", item_div_id);

		var evalResult;
		if (hotarea_state == evaluate_comm.get_hotarea_state_update()) {
			//如果当前热点状态为更新，获取当前热点之前的评估结果
			evalResult = evaluate_comm.get_cur_eval_result(evalItem.itemCode);
		}

		var arr_damage_items = evalItem.projectDamageItems.split(",");
		var str_damage_items = "<tr>";

		for (var i = 0; i < arr_damage_items.length; i++) {
			if (hotarea_state == evaluate_comm.get_hotarea_state_update()) {
				var is_damage_items_exist = false; //参数中的评估级别在结果中是否已经存在
				var arr_result_damage_items = evalResult.evalKind.split(",");
				for (var j = 0; j < arr_result_damage_items.length; j++) {
					if (arr_result_damage_items[j] == arr_damage_items[i]) {
						is_damage_items_exist = true;
						break;
					}
				}
				if (is_damage_items_exist) {
					str_damage_items += "<td width='150px'>" +
						"<label>" +
						"<input type='radio' name='rdDamageItem_" + evalItem.itemCode + "' value='" + arr_damage_items[i] + "' checked='true' />" + arr_damage_items[i] +
						"</label></td>";
				} else {
					str_damage_items += "<td width='150px'>" +
						"<label>" +
						"<input type='radio' name='rdDamageItem_" + evalItem.itemCode + "' value='" + arr_damage_items[i] + "' />" + arr_damage_items[i] +
						"</label></td>";
				}
			} else if (hotarea_state == evaluate_comm.get_hotarea_state_new()) {
				str_damage_items += "<td width='150px'>" +
					"<label>" +
					"<input type='radio' name='rdDamageItem_" + evalItem.itemCode + "' value='" + arr_damage_items[i] + "' />" + arr_damage_items[i] +
					"</label></td>";
			}
		}
		str_damage_items += "</tr>";
		console.log("str_damage_items is: %s", str_damage_items);

		var str_div = _paint_dialog_div_template.replace(/\@item_div_id\@/g, item_div_id)
			.replace(/\@project_damage_items\@/g, str_damage_items)
			.replace(/\@item_id\@/g, evalItem.itemCode)
			.replace(/\@item_name\@/g, evalItem.itemName)
			.replace(/\@item_type\@/g, evalItem.itemType)
			.replace(/\@hotarea_type\@/g, evalItem.hotAreaType)
			.replace(/\@hotarea_coord\@/g, evalItem.hotAreaCoord)
			.replace(/\@damage_items\@/g, evalItem.projectDamageItems)
			.replace(/\@damage_level\@/g, evalItem.projectDamageLevel)
		console.log("after replace, str_div is: %s", str_div);

		if (!_is_div_opt_exist(evalItem.itemCode)) {
			var div_opt_json = {
				"itemCode": "" + evalItem.itemCode + ""
			};
			var save_div_json = _save_div_opt(div_opt_json);
			console.log("_init_hotarea_dialog_div, save_div_json is: %o", save_div_json);
			$("#hotarea_container").append(str_div);
		}

		console.groupEnd();
	}

	/**
	 * 初始化热点和工况对话框JS
	 */
	var _init_dialog_js = function(evalItem) {
		var item_div_id;
		if (evalItem.itemType != undefined) {
			item_div_id = "divHotareaDialog_" + evalItem.itemType + "_" + evalItem.itemCode;
		} else {
			item_div_id = "divConditionsDialog_" + evalItem.itemCode;
		}

		console.group("_init_dialog_js");
		console.log("begin init...");
		$("#" + item_div_id + "").dialog({
			dialogClass: "no-close"
		});
		console.log("end of init...");
		console.groupEnd();
	}

	/**
	 * 修改状态时初始化改变已选中的热点颜色
	 */
	var _init_hotarea_color = function(hotareaItems) {
		console.group("_init_hotarea_color");
		for (var i = 0; i < hotareaItems.length; i++) {
			var selected_item_code = hotareaItems[i].itemCode;
			var selected_item = $("#area_" + selected_item_code);

			var areaHtml = "";
			if (hotareaItems[i].itemKind == '4' || hotareaItems[i].itemKind == '5') {
				//对于漆面需根据选项着色
				if (hotareaItems[i].checkKind == '重新喷漆') {
					areaHtml += " <area id='area_" + selected_item_code + "' shape='" + selected_item.attr("shape") + "'" + " href='javascript:void(0);' name='" + selected_item.attr("name") + "' coords='" + selected_item.attr("coords") + "'" + " title='" + selected_item.attr("title") + "' data-maphilight='{\"fillColor\":\"F00056\",\"fillOpacity\":0.6,\"alwaysOn\":true}'" + " onclick=\"" + selected_item.attr("onclick") + "\"/>";
				} else {
					areaHtml += " <area id='area_" + selected_item_code + "' shape='" + selected_item.attr("shape") + "'" + " href='javascript:void(0);' name='" + selected_item.attr("name") + "' coords='" + selected_item.attr("coords") + "'" + " title='" + selected_item.attr("title") + "' data-maphilight='{\"fillColor\":\"FFF143\",\"fillOpacity\":0.6,\"alwaysOn\":true}'" + " onclick=\"" + selected_item.attr("onclick") + "\"/>";
				}
			} else {
				areaHtml += " <area id='area_" + selected_item_code + "' shape='" + selected_item.attr("shape") + "'" + " href='javascript:void(0);' name='" + selected_item.attr("name") + "' coords='" + selected_item.attr("coords") + "'" + " title='" + selected_item.attr("title") + "' data-maphilight='{\"fillColor\":\"F00056\",\"fillOpacity\":0.6,\"alwaysOn\":true}'" + " onclick=\"" + selected_item.attr("onclick") + "\"/>";
			}
			console.log("_init_hotarea_color, areaHtml is: %s", areaHtml);

			selected_item.remove();

			if (hotareaItems[i].itemKind == "0") { //左前45度热点
				$("#Map1").append(areaHtml);
			} else if (hotareaItems[i].itemKind == "1") { //右后45度热点
				$("#Map2").append(areaHtml);
			} else if (hotareaItems[i].itemKind == "2") { //外观
				$("#Map3").append(areaHtml);
			} else if (hotareaItems[i].itemKind == "3") { //内饰
				$("#Map4").append(areaHtml);
			} else if (hotareaItems[i].itemKind == "4") { //左侧漆面
				$("#Map5").append(areaHtml);
			} else if (hotareaItems[i].itemKind == "5") { //右侧漆面
				$("#Map6").append(areaHtml);
			}
		}
		console.groupEnd();
	}

	return {

		new_hotarea_state_obj: function() {
			evaluate_comm.new_hotarea_state_obj();
		},

		/**
		 * 填充已有数据入热点状态对象（适用于修改情况）
		 */
		load_hotarea_state_obj: function(items) {
			var hotareaItems = items.hotareaItems;
			evaluate_comm.new_hotarea_state_obj(); //新建热点状态对象
			for (var i = 0; i < hotareaItems.length; i++) {
				var result_json = {
					"itemCode": "" + hotareaItems[i].itemCode + "",
					"evalKind": "" + hotareaItems[i].checkKind + "",
					"evalDesc": "" + hotareaItems[i].checkDesc + "",
					"imgUrl": "" + hotareaItems[i].imgUrl
				};
				evaluate_comm.save_eval_result(result_json);
			}
			_init_hotarea_color(hotareaItems);
		},

		/**
		 * 填充已有数据入工况对象（适用于修改情况）
		 */
		load_conditions_obj: function(items) {
			var conditions = items.conditions;
			//console.log("load_conditions_obj, conditionItems is %o", conditions);
			for (var i = 0; i < conditions.length; i++) {
				//console.log("load_conditions_obj, conditions[%d] is %o", i, conditions[i]);
				$("#txtCondition_" + conditions[i].itemCode).val(conditions[i].checkDesc);
				$("input[type='checkbox'][name='chkConditionsLevel_" + conditions[i].itemCode + "'][value='" + conditions[i].checkKind + "']").attr("checked", true)
				$("input[type='radio'][name='rdConditionsExcp_" + conditions[i].itemCode + "']").attr("checked", false);
			}
		},

		/**
		 * 初始化热点对话框
		 */
		init_hotarea_dialog: function(evalItem) {
			console.group("init_hotarea_dialog");
			console.log("init_hotarea_dialog, evalItem is: %o", evalItem);

			var hotarea_state = _check_hotarea_state(evalItem);
			console.log("init_hotarea_dialog, hotarea_state is: %d", hotarea_state);

			if (evalItem.itemType == "0" || evalItem.itemType == "1" ||
				evalItem.itemType == "2" || evalItem.itemType == "3") {
				_init_hotarea_dialog_div(evalItem, hotarea_state);

			} else if (evalItem.itemType == "4" || evalItem.itemType == "5") {
				_init_paint_dialog_div(evalItem, hotarea_state);
			}
			_init_dialog_js(evalItem);
			console.groupEnd();
		},

		init_quick_select_dialog: function() {
			//初始化个性配置选择框
			$("#divPersonalConfig").dialog({
				autoOpen: false,
				dialogClass: "no-close",
				position: [250, 250]
			});

			//初始化标准配置选择框
			$("#divStandConfig").dialog({
				autoOpen: false,
				dialogClass: "no-close",
				position: [-500, 0]
			});

			//初始化老客户选择对话框
			$("#divOldCustDialog").dialog({
				autoOpen: false,
				dialogClass: "no-close"
			});
		},

		/**
		 * 初始化工况对话框
		 */
		init_conditions_dialog: function(conditionsItem) {
			console.group("init_conditions_dialog");
			console.log("init_conditions_dialog, conditionsItem is: %o", conditionsItem);

			var cur_state = evaluate_comm.get_cur_conditions_state(conditionsItem.itemCode);
			console.log("init_conditions_dialog, cur_state is: %s", cur_state);

			_init_conditions_dialog_div(conditionsItem, cur_state);
			_init_dialog_js(conditionsItem);
			console.groupEnd();
		},

		change_paint_all: function() {
			//选中全车重新做漆        
			if ($("#needPaintTag").attr("checked") == "checked") {
				//TODO : 标注现有页面    
			}
		},

		/**
		 * 修改时设置页面元素值
		 */
		set_update_value: function(jsonString) {
			var jsonObj = $.evalJSON(jsonString);
			$("#hdAcquSourceId").val(jsonObj.acquSourceId);
			$("#selInfoSource").val(jsonObj.infoSource);
			$("#custName").val(jsonObj.custName);
			$("#phoneNumber").val(jsonObj.phoneNumber);
			if (jsonObj.regularCustTag == 1) {
				$("#regularCustTag").attr("checked", true);
			}
			$("#brandCode").val(jsonObj.brandCode)
			$("#seriesCode").val(jsonObj.seriesCode),
			$("#styleCode").val(jsonObj.modelCode),
			$("#carColor").val(jsonObj.carColor);
			if (jsonObj.colorChgTag == 1) {
				$("#colorChgTag").attr("checked", true);
			}
			$("#oldColor").val(jsonObj.oldColor);
			if (jsonObj.gearsTypeTag != -1) {
				$("input[name=gearsTypeTag][value=" + jsonObj.gearsTypeTag + "]").attr("checked", true);
			}
			//内饰颜色
			$("#upholsteryColor").val(jsonObj.upholsteryColor);
			
			if(jsonObj.obdTag==1){
				$("#obdTag").attr('checked',true);
			}
			
			
			
			//核定载客人数
			$("#passengerNum").val(jsonObj.passengerNum);
			if (jsonObj.outputVolume == 0) {
				$("#outputVolume").val("");
			} else {
				$("#outputVolume").val(jsonObj.outputVolume);
			}
			if (jsonObj.turbocharger == 1) {
				$("#turboCharger").attr("checked", true);
			}
			if (jsonObj.carType != -1) {
				$("input[name=carType][value=" + jsonObj.carType + "]").attr("checked", true);
			}
			$("#oldLicenseCode").val(jsonObj.oldLicenseCode);
			$("#motorCode").val(jsonObj.motorCode);
			$("#shelfCode").val(jsonObj.shelfCode);
			$("#registMonth").val(jsonObj.registMonth);
			$("#factoryMonth").val(jsonObj.factoryMonth);
			
			$("#vinCheckTag").combobox('select',jsonObj.vinCheckTag);
			if (jsonObj.usedType != -1) {
				$("input[name=usedType][value=" + jsonObj.usedType + "]").attr("checked", true);
			}
			$("#transferTag").val(jsonObj.transferTag);
			
			$("#driverKind").combobox('select',jsonObj.driverKind);
			
			$("#carDoorNum").val(jsonObj.carDoorNum);
			if (jsonObj.environmentalLevel != -1) {
				$("input[name=environmentalLevel][value=" + jsonObj.environmentalLevel + "]").attr("checked", true);
			}
			if (jsonObj.mileageCount == 0) {
				$("#mileageCount").val("");
			} else {
				$("#mileageCount").val(jsonObj.mileageCount);
			}
			if (jsonObj.actualMileage == 0) {
				$("#actualMileage").val("");
			} else {
				$("#actualMileage").val(jsonObj.actualMileage);
			}
			if (jsonObj.credenteBean.maintRecordTag != -1) {
				$("input[name=maintRecordTag][value=" + jsonObj.credenteBean.maintRecordTag + "]").attr("checked", true);
			}
			
			if (jsonObj.credenteBean.warrantyTag != -1) {
				$("input[name=warrantyTag][value=" + jsonObj.credenteBean.warrantyTag + "]").attr("checked", true);
			}
			if (jsonObj.fuelType != -1) {
				$("input[name=fuelType][value=" + jsonObj.fuelType + "]").attr("checked", true);
			}
			if (jsonObj.credenteBean.issurValidTag != -1) {
				$("input[name=issurValidTag][value=" + jsonObj.credenteBean.issurValidTag + "]").attr("checked", true);
			}
			$("#issurValidDate").val(jsonObj.credenteBean.issurValidDate);
			if (jsonObj.credenteBean.commIssurValidTag != -1) {
				$("input[name=commIssurValidTag][value=" + jsonObj.credenteBean.commIssurValidTag + "]").attr("checked", true);
			}
			$("#commIssurValidDate").val(jsonObj.credenteBean.commIssurValidDate);
			if (jsonObj.credenteBean.commIssurFee == 0) {
				$("#commIssurFee").val("");
			} else {
				$("#commIssurFee").val(jsonObj.credenteBean.commIssurFee);
			}
			$("#checkValidMonth").val(jsonObj.credenteBean.checkValidMonth);
			if (jsonObj.credenteBean.drivingLicenseTag != -1) {
				$("input[name=drivingLicenseTag][value=" + jsonObj.credenteBean.drivingLicenseTag + "]").attr("checked", true);
			}
			if (jsonObj.credenteBean.registrationCertTag != -1) {
				$("input[name=registrationCertTag][value=" + jsonObj.credenteBean.registrationCertTag + "]").attr("checked", true);
			}
			if (jsonObj.credenteBean.licenseCodeTag != -1) {
				$("input[name=licenseCodeTag][value=" + jsonObj.credenteBean.licenseCodeTag + "]").attr("checked", true);
			}
			
			if (jsonObj.credenteBean.carKeys != -1) {
				$("input[name=carKeys][value=" + jsonObj.credenteBean.carKeys + "]").attr("checked", true);
			}
			if (jsonObj.credenteBean.purchaseTaxTag != -1) {
				$("input[name=purchaseTaxTag][value=" + jsonObj.credenteBean.purchaseTaxTag + "]").attr("checked", true);
			}
			if (jsonObj.credenteBean.environmentTag != -1) {
				$("input[name=environmentTag][value=" + jsonObj.credenteBean.environmentTag + "]").attr("checked", true);
			}
			if (jsonObj.credenteBean.invoiceTag != -1) {
				$("input[name=invoiceTag][value=" + jsonObj.credenteBean.invoiceTag + "]").attr("checked", true);
			}
			if (jsonObj.credenteBean.newcarPrice == 0) {
				$("#newcarPrice").val("");
			} else {
				$("#newcarPrice").val(jsonObj.credenteBean.newcarPrice);
			}
			if (jsonObj.credenteBean.originalManualTag == 1) {
				$("#originalManualTag").attr("checked", true);
			}
			if (jsonObj.credenteBean.maintManualTag == 1) {
				$("#maintManualTag").attr("checked", true);
			}
			if (jsonObj.credenteBean.triangleTag == 1) {
				$("#triangleTag").attr("checked", true);
			}
			if (jsonObj.credenteBean.spareWheelTag == 1) {
				$("#spareWheelTag").attr("checked", true);
			}
			if (jsonObj.credenteBean.extinguisherTag == 1) {
				$("#extinguisherTag").attr("checked", true);
			}
			if (jsonObj.credenteBean.aidKitTag == 1) {
				$("#aidKitTag").attr("checked", true);
			}
			if (jsonObj.credenteBean.ashtrayTag == 1) {
				$("#ashtrayTag").attr("checked", true);
			}
			if (jsonObj.credenteBean.cigarLighterTag == 1) {
				$("#cigarLighterTag").attr("checked", true);
			}
			if (jsonObj.credenteBean.antennaTag == 1) {
				$("#antennaTag").attr("checked", true);
			}
			if (jsonObj.credenteBean.toolBoxTag == 1) {
				$("#toolBoxTag").attr("checked", true);
			}
			if (jsonObj.credenteBean.navigateDiskTag == 1) {
				$("#navigateDiskTag").attr("checked", true);
			}
			$("#otherAttachment").val(jsonObj.credenteBean.otherAttachment);
			var standardConfig = jsonObj.credenteBean.standardEquip;
			//if (standardConfig.indexOf("$") > 0) {
				//standardConfig = standardConfig.replace(/\$/g, "&");
			//}
			$("#standardEquip").val(standardConfig);
			$("#custEquip").val(jsonObj.credenteBean.custEquip);
			$("#comprehensiveGrade").combobox('select',jsonObj.comprehensiveGrade);
			$("#surfaceGrade").combobox('select',jsonObj.surfaceGrade);
			$("#upholsteryGrade").combobox('select',jsonObj.upholsteryGrade);
			$("#shelfGrade").combobox('select',jsonObj.shelfGrade);
			$("#machineGrade").combobox('select',jsonObj.machineGrade);
		},
		//入库质检页面初始值
		set_instock_check_default_value:function(jsonString){
			var jsonObj = $.evalJSON(jsonString);
			$("#hdAcquSourceId").val(jsonObj.acquSourceId);
			$("#selInfoSource").val(jsonObj.infoSource);
			$("#custName").val(jsonObj.custName);
			$("#phoneNumber").val(jsonObj.phoneNumber);
			if (jsonObj.regularCustTag == 1) {
				$("#regularCustTag").attr("checked", true);
			}
			$("#brandCode").val(jsonObj.brandCode)
			$("#seriesCode").val(jsonObj.seriesCode),
			$("#styleCode").val(jsonObj.modelCode),
			$("#carColor").val(jsonObj.carColor);
			if (jsonObj.colorChgTag == 1) {
				$("#colorChgTag").attr("checked", true);
			}
			$("#oldColor").val(jsonObj.oldColor);
			if (jsonObj.gearsTypeTag != -1) {
				$("input[name=gearsTypeTag][value=" + jsonObj.gearsTypeTag + "]").attr("checked", true);
			}
			//内饰颜色
			$("#upholsteryColor").val(jsonObj.upholsteryColor);
			
			if(jsonObj.obdTag==1){
				$("#obdTag").attr('checked',true);
			}
			
			
			
			//核定载客人数
			$("#passengerNum").val(jsonObj.passengerNum);
			if (jsonObj.outputVolume == 0) {
				$("#outputVolume").val("");
			} else {
				$("#outputVolume").val(jsonObj.outputVolume);
			}
			if (jsonObj.turbocharger == 1) {
				$("#turboCharger").attr("checked", true);
			}
			if (jsonObj.carType != -1) {
				$("input[name=carType][value=" + jsonObj.carType + "]").attr("checked", true);
			}
			$("#oldLicenseCode").val(jsonObj.oldLicenseCode);
			$("#motorCode").val(jsonObj.motorCode);
			$("#shelfCode").val(jsonObj.shelfCode);
			$("#registMonth").val(jsonObj.registMonth);
			$("#factoryMonth").val(jsonObj.factoryMonth);
			
			$("#vinCheckTag").combobox('select',jsonObj.vinCheckTag);
			if (jsonObj.usedType != -1) {
				$("input[name=usedType][value=" + jsonObj.usedType + "]").attr("checked", true);
			}
			$("#transferTag").val(jsonObj.transferTag);
			
			$("#driverKind").combobox('select',jsonObj.driverKind);
			
			$("#carDoorNum").val(jsonObj.carDoorNum);
			if (jsonObj.environmentalLevel != -1) {
				$("input[name=environmentalLevel][value=" + jsonObj.environmentalLevel + "]").attr("checked", true);
			}
			if (jsonObj.mileageCount == 0) {
				$("#mileageCount").val("");
			} else {
				$("#mileageCount").val(jsonObj.mileageCount);
			}
			if (jsonObj.actualMileage == 0) {
				$("#actualMileage").val("");
			} else {
				$("#actualMileage").val(jsonObj.actualMileage);
			}
			if (jsonObj.credenteBean.maintRecordTag != -1) {
				$("input[name=maintRecordTag][value=" + jsonObj.credenteBean.maintRecordTag + "]").attr("checked", true);
			}
			
			if (jsonObj.credenteBean.warrantyTag != -1) {
				$("input[name=warrantyTag][value=" + jsonObj.credenteBean.warrantyTag + "]").attr("checked", true);
			}
			if (jsonObj.fuelType != -1) {
				$("input[name=fuelType][value=" + jsonObj.fuelType + "]").attr("checked", true);
			}
			if (jsonObj.credenteBean.issurValidTag != -1) {
				$("input[name=issurValidTag][value=" + jsonObj.credenteBean.issurValidTag + "]").attr("checked", true);
			}
			$("#issurValidDate").val(jsonObj.credenteBean.issurValidDate);
			if (jsonObj.credenteBean.commIssurValidTag != -1) {
				$("input[name=commIssurValidTag][value=" + jsonObj.credenteBean.commIssurValidTag + "]").attr("checked", true);
			}
			$("#commIssurValidDate").val(jsonObj.credenteBean.commIssurValidDate);
			if (jsonObj.credenteBean.commIssurFee == 0) {
				$("#commIssurFee").val("");
			} else {
				$("#commIssurFee").val(jsonObj.credenteBean.commIssurFee);
			}
			$("#checkValidMonth").val(jsonObj.credenteBean.checkValidMonth);
			if (jsonObj.credenteBean.drivingLicenseTag != -1) {
				$("input[name=drivingLicenseTag][value=" + jsonObj.credenteBean.drivingLicenseTag + "]").attr("checked", true);
			}
			if (jsonObj.credenteBean.registrationCertTag != -1) {
				$("input[name=registrationCertTag][value=" + jsonObj.credenteBean.registrationCertTag + "]").attr("checked", true);
			}
			if (jsonObj.credenteBean.licenseCodeTag != -1) {
				$("input[name=licenseCodeTag][value=" + jsonObj.credenteBean.licenseCodeTag + "]").attr("checked", true);
			}
			
			if (jsonObj.credenteBean.carKeys != -1) {
				$("input[name=carKeys][value=" + jsonObj.credenteBean.carKeys + "]").attr("checked", true);
			}
			if (jsonObj.credenteBean.purchaseTaxTag != -1) {
				$("input[name=purchaseTaxTag][value=" + jsonObj.credenteBean.purchaseTaxTag + "]").attr("checked", true);
			}
			if (jsonObj.credenteBean.environmentTag != -1) {
				$("input[name=environmentTag][value=" + jsonObj.credenteBean.environmentTag + "]").attr("checked", true);
			}
			if (jsonObj.credenteBean.invoiceTag != -1) {
				$("input[name=invoiceTag][value=" + jsonObj.credenteBean.invoiceTag + "]").attr("checked", true);
			}
			if (jsonObj.credenteBean.newcarPrice == 0) {
				$("#newcarPrice").val("");
			} else {
				$("#newcarPrice").val(jsonObj.credenteBean.newcarPrice);
			}
			if (jsonObj.credenteBean.originalManualTag == 1) {
				$("#originalManualTag").attr("checked", true);
			}
			if (jsonObj.credenteBean.maintManualTag == 1) {
				$("#maintManualTag").attr("checked", true);
			}
			if (jsonObj.credenteBean.triangleTag == 1) {
				$("#triangleTag").attr("checked", true);
			}
			if (jsonObj.credenteBean.spareWheelTag == 1) {
				$("#spareWheelTag").attr("checked", true);
			}
			if (jsonObj.credenteBean.extinguisherTag == 1) {
				$("#extinguisherTag").attr("checked", true);
			}
			if (jsonObj.credenteBean.aidKitTag == 1) {
				$("#aidKitTag").attr("checked", true);
			}
			if (jsonObj.credenteBean.ashtrayTag == 1) {
				$("#ashtrayTag").attr("checked", true);
			}
			if (jsonObj.credenteBean.cigarLighterTag == 1) {
				$("#cigarLighterTag").attr("checked", true);
			}
			if (jsonObj.credenteBean.antennaTag == 1) {
				$("#antennaTag").attr("checked", true);
			}
			if (jsonObj.credenteBean.toolBoxTag == 1) {
				$("#toolBoxTag").attr("checked", true);
			}
			if (jsonObj.credenteBean.navigateDiskTag == 1) {
				$("#navigateDiskTag").attr("checked", true);
			}
			$("#otherAttachment").val(jsonObj.credenteBean.otherAttachment);
			var standardConfig = jsonObj.credenteBean.standardEquip;
			//if (standardConfig.indexOf("$") > 0) {
				//standardConfig = standardConfig.replace(/\$/g, "&");
			//}
			$("#standardEquip").val(standardConfig);
			$("#custEquip").val(jsonObj.credenteBean.custEquip);

			if(jsonObj.maintainInfo){
				$("#maintainHoursFee").val(jsonObj.maintainInfo.maintainHoursFee);
				$("#maintainMaterialFee").val(jsonObj.maintainInfo.maintainMaterialFee);
				$("#sumFee").val(jsonObj.maintainInfo.maintainHoursFee+jsonObj.maintainInfo.maintainMaterialFee);
				$("#planEndDate").val(jsonObj.maintainInfo.planEndDateStr);
				$("#repairHoursFee").val(jsonObj.maintainInfo.repairHoursFee);
				$("#repairMaterialFee").val(jsonObj.maintainInfo.repairMaterialFee);
				$("#sumRepairtFee").val(jsonObj.maintainInfo.repairMaterialFee+jsonObj.maintainInfo.repairHoursFee);
				$("#repairFinishDate").val(jsonObj.maintainInfo.repairFinishDateStr);
			}

			
			
		}
	};
})();