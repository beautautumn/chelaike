$(function() {
	loadBrand();

	var currYear = (new Date()).getFullYear();  
	//初始化日期控件
	var opt_ymd = {
			preset: 'date', //日期，可选：date\datetime\time\tree_list\image_text\select
			theme: 'ios', //皮肤样式，可选：default\android\android-ics light\android-ics\ios\jqm\sense-ui\wp light\wp
			display: 'top', //显示方式 ，可选：modal\inline\bubble\top\bottom
			mode: 'scroller', //日期选择模式，可选：scroller\clickpick\mixed
			lang:'zh',
			dateFormat: 'yyyy-mm', // 日期格式
			setText: '确定', //确认按钮名称
			cancelText: '取消',//取消按钮名籍我
			dateOrder: 'yyyymm', //面板中日期排列格式
			dayText: '日', monthText: '月', yearText: '年', //面板中年月日文字
			showNow: false,  
	   		nowText: "今",  
	    	startYear:currYear, //开始年份  
	    	endYear:currYear + 100 //结束年份  
	    	//endYear:2099 //结束年份
		};
	var opt_ym = {
			preset: 'date', //日期，可选：date\datetime\time\tree_list\image_text\select
			theme: 'default', //皮肤样式，可选：default\android\android-ics light\android-ics\ios\jqm\sense-ui\wp light\wp
			display: 'modal', //显示方式 ，可选：modal\inline\bubble\top\bottom
			mode: 'scroller', //日期选择模式，可选：scroller\clickpick\mixed
			lang:'zh',
			dateFormat: 'yyyy-mm', // 日期格式
			setText: '确定', //确认按钮名称
			cancelText: '取消',//取消按钮名籍我
			dateOrder: 'yyyymm', //面板中日期排列格式
			dayText: '日', monthText: '月', yearText: '年', //面板中年月日文字
			showNow: false,  
			nowText: "今",  
			startYear:currYear - 20, //开始年份  
			endYear:currYear + 1 //结束年份  
			//endYear:2099 //结束年份
	};
	
	$("#registMonth").mobiscroll().date();
	$("#registMonth").mobiscroll(opt_ym);
	$("#factoryDate").mobiscroll().date();
	$("#factoryDate").mobiscroll(opt_ym);
	$("#issurValidDate").mobiscroll().date();
	$("#issurValidDate").mobiscroll(opt_ym);
	$("#checkValidMonth").mobiscroll().date();
	$("#checkValidMonth").mobiscroll(opt_ym);
	$("#commIssurValidDate").mobiscroll().date();
	$("#commIssurValidDate").mobiscroll(opt_ym);
	
	$('#carColorSelect').bind('change', function () {
		var o = $(this);
	    var color = o.val();
	    $('#carColorText').text(color);
	});
	$('#upholsteryColorSelect').bind('change', function () {
		var o = $(this);
		var color = o.val();
		$('#upholsteryColorText').text(color);
	});
	$('#gear_typeSelect').bind('change', function () {
		var o = $(this);
		var color = o.find("option:selected").text();
		$('#gear_typeText').text(color);
	});
	$('#usedTypeSelect').bind('change', function () {
		var o = $(this);
		var color = o.find("option:selected").text();
		$('#usedTypeText').text(color);
	});
	
	/**
	 * 渲染上传图片
	 */
	$('#companyCodeImgLi').append(imageNode(1));
	
	var uploadClick = function() {
		var $tradeId = $('#tradeId');
		var $vehicleId = $('#vehicleId');
		var tradeId = $tradeId.val() || '';
		var vehicleId = $vehicleId.val() || '';
		if(!tradeId){
			alert('先提交车辆基本信息！');
			return;
		}
		if(!vehicleId){
			alert('先提交车辆基本信息！');
			return;
		}
		
		var o = $(this);
		var index = o.attr('target_index');
		var maxImage = 8;
		var mrpic_spans = $('.mrpic');
		if(mrpic_spans.length > maxImage){
			alert('上传图片不能超过' + maxImage + '张！');
			return;
		}
		var idd = "fileInput_" + index;
		var viewCanvas = document.getElementById('viewCanvas_' + index);
		var resCanvas = document.getElementById('resultCanvas_' + index);
		var fileInput = document.getElementById(idd);
		fileInput.onchange = function() {
			var file = fileInput.files[0];
			var mpImg = new MegaPixImage(file);
			mpImg.render(resCanvas, {
				maxWidth : 1024,
				maxHeight : 768,
				height : 500
			},function(){
				ajaxSendImagePost(tradeId, vehicleId, index);
			});
			mpImg.render(viewCanvas, {
				maxWidth : 300,
				maxHeight : 300,
				width : 157,
				height : 125
			});
	        
			document.getElementById('nopic_' + index).style.display = "none";
			document.getElementById('btn-upload_' + index).style.display = "none";
			sleep(1000);
			$('#companyCodeImgLi').append(imageNode(parseInt(index) + 1));
			$(".btn-upload").on('click', uploadClick);
			$(".closeNode").on('click', closeClick);
		};
		$("#" + idd).click();
		
		
	};
	$(".btn-upload").bind('click', uploadClick);

	
	
	var closeClick = function(){
		var o = $(this);
		var index = o.attr('target_index');
		var $tradeId = $('#tradeId');
		var tradeId = $tradeId.val() || '';
		if(!tradeId){
			alert('先提交车辆基本信息！');
			return;
		}
		if(!confirm("请您确认删除车辆图片？")){
			return;
		}
		var $mrpic_span = $('#mrpic_' + index);
		var picId = $mrpic_span.attr('picId');
		var url = ctutil.bp() + '/carin/vehicleInput!doDelVehiclePic.action';
		var params = {};
		params['tradeId'] = tradeId;
		params['picIds'] = picId;
		$.post(url, params, function(data) {
				if (data == "success") {
					$mrpic_span.remove();
					return;
				} else {
					alert("图片删除失败,请重试！");
				}
			});
		
	}
	
});


function selectBrand() {
	$(".vInfo").hide();
	$(".bAndS").show();
}

function colorSelect() {
	var val = $("#selectColor").val().split(" ");
	var text = val[2];
	var color = val[1];
	$("#colorText").html(text).show();
	$("#showColor").css("background-color", color).show();
}

function loadBrand() {
	$.ajax({
		url : ctutil.bp() + "/sys/comm!getBrandList.action",
		type : "post",
		data : {},
		success : function(data) {
			var firstLetter = "";
			var htmlStr = "";
			var dataObj = eval('(' + data + ')');
			$.each(dataObj, function(i, obj) {
				var letter = obj.group;
				if (firstLetter != letter) {
					if (i > 0) {
						htmlStr += '</ul>';
					}
					htmlStr += '<div class="w-title01"><h3>' + letter
							+ '</h3></div><ul class="w-sift-brand">';
					firstLetter = letter;
				}
				htmlStr += '<li class="item"><a href="javascript:putBrand(\''
						+ obj.id + '\',\'' + obj.name + '\');" brandId="'
						+ obj.id + '">' + obj.name + '</a></li>';
			});
			$(".w-main").html(htmlStr);
		}
	});
}


function goBack() {
	$(".vInfo").show();
	$(".bAndS").hide();
}

/**
 * 清空车系信息，加载车系，
 * @param id
 * @param name
 */
function putBrand(id, name) {
	$("#seriesVal").val("");
	$("#seriesName").val("");
	$("#seriesNameText").text("");
	$("#kindVal").val("");
	$("#kindName").val("");
	$("#kindNameText").text("");
	loadSeries(id);
	loadKind(-1);
	$("#carName").html(name);
	$("#brandId").val(id);
	$("#brandName").val(name);
	$(".vInfo").show();
	$(".bAndS").hide();
}

/**
 * 加载车系
 * @param id
 */
function loadSeries(id) {
	$.ajax({
		url : ctutil.bp() + "/sys/comm!getSeriesList.action",
		type : "post",
		data : {
			brandId : id
		},
		success : function(data) {
			var firstLetter = "";
			var htmlStr = "<option value=''>--选择--</option>";
			var dataObj = eval("(" + data + ")");
			$.each(dataObj, function(i, obj) {
				htmlStr += '<option value="' + obj.name + ' , ' + obj.id + '">'
						+ obj.name + '</option>';
			});
			$("#seriesId").html(htmlStr);
		}
	});
}

/**
 * 加载车型
 * @param id
 */
function loadKind(id) {
	$.ajax({
		url : ctutil.bp() + "/sys/comm!getKindList.action",
		type : "post",
		data : {
			seriesId : id
		},
		success : function(data) {	
			var firstLetter = "";
			var htmlStr = "<option value=''>--选择--</option>";
			var dataObj = eval("(" + data + ")");
			$.each(dataObj, function(i, obj) {
				htmlStr += '<option value="' + obj.name + ' , ' + obj.id + '">'
				+ obj.name + '</option>';
			});
			$("#kindId").html(htmlStr);
		}
	});
}

function seriesSelect() {
	var obj = $("#seriesId").val().split(' , ');
	
	$("#kindVal").val("");
	$("#kindName").val("");
	$("#kindNameText").text("");
	loadKind(obj[1]);
	$("#seriesVal").val(obj[1]);
	$("#seriesName").val(obj[0]);
	$("#seriesNameText").text(obj[0]);
}

function kindSelect() {
	var obj = $("#kindId").val().split(' , ');
	$("#kindVal").val(obj[1]);
	$("#kindName").val(obj[0]);
	$("#kindNameText").text(obj[0]);
}

//定时事件
function Interval_handler(index){
	
	var $objPro = $('#proDownFile_' + index);
	var $objTip =  $('#pTip_' + index);
	var intValue = $objPro.attr('value');
	intValue ++;
	$objPro.attr('value', intValue);
	if(intValue >= 100){
		clearInterval(Interval_handler);
		$objTip.innerHTML="下载完成";
	}else{
		$objTip.innerHTML="正在下载"+intValue+"%";
	}
}

function imageNode(index) {
	var n = '<span class="mrpic" target_index="' + index + '" id="mrpic_' + index + '"><a class="closeNode" id="cn_' + index + '" target_index="' + index + '" style="display: none; cursor:hand;">X</a>' 
			+ '<img id="nopic_' + index
			+ '" target_index="' + index + '" src="' + ctutil.bp() +  '/phone/images/mrpic.png" width="157" height="125" alt="" />'
			+ '<i target_index="' + index + '" class="upload" id="btn-upload_' + index + '">'
			+ '<button target_index="' + index + '" class="btn-upload" id="upl_' + index + '">上传</button>'
			+ '<input target_index="' + index + '" style="display: none;" type="file" id="fileInput_'
			+ index + '">' + '</i>'
			+ '<canvas target_index="' + index + '" class="viewCanvas" id="viewCanvas_' + index + '"></canvas>' 
			+ '<p id="pTip_' + index + '">开始上传</p>'
			+ '<progress value="0" max="100" id="proDownFile_' + index + '"></progress>'
//			+ '<img style="display: none;" class="viewCanvas" id="viewCanvas_' + index + '" src=""/>' 
			+ '<canvas target_index="' + index + '" style="display: none;" class="resultCanvas" id="resultCanvas_' + index + '"></canvas>' 
			+ '</span>';
	return n;
}

function sleep(numberMillis) {
	var now = new Date();
	var exitTime = now.getTime() + numberMillis;
	while (true) {
		now = new Date();
		if (now.getTime() > exitTime)
			return;
	}
}

function do_submit() {
//	var data = strToObj(decodeURIComponent($("#myForm").serialize(), true));
	var data = decodeURIComponent($("#myForm").serialize(), true);
	var $brandId = $('#brandId');
	if(!$brandId.val()){
		alert("请选择车辆品牌！");
		return;
	}
	if(!confirm("请您确认车辆信息后再提交,因为暂无修改车辆信息的入口！")){
		return;
	}
	ajaxPost(data);
}

function ajaxPost(data2) {
	var url1 = ctutil.bp() + "/carin/vehicleInput!doVehicleInputPhone.action";
	$.post(url1,data2, 
		function(data) {
			data = eval('('+data+')');
			if (data.success == "success") {
				$('#tradeId').val(data.tradeId);
				$('#vehicleId').val(data.vehicleId);
				alert("车辆信息保存成功！");
				$('#a_step1').hide();
				// window.location.reload();
			} else {
				alert("车辆信息保存失败,请重试！");
			}
		});
}

/**
 * 上传图片
 * @param tradeId
 * @param imgStr
 */
function ajaxSendImagePost(tradeId, vehicleId, index) {
	var idd = "fileInput_" + index;
	var fileInput = document.getElementById(idd);
	var ff = $(fileInput).val();
	ff = ff.substring(ff.lastIndexOf("."));
	if(ff == '.jpg' || ff == '.jpeg' || ff == '.png'){
	}else{
		alert('请选择jpg、jpeg或者png图片格式');
		return;
	}
	
	var imagedata = document.getElementById('resultCanvas_' + index).toDataURL("image/png", 1 || 0.8 );
	var url1 = ctutil.bp() + "/carin/vehicleInput!doUploadImage.action";
	var params = {};
	params['trade.id'] = tradeId;
	params['vehicle.id'] = vehicleId;
	params['pics'] = imagedata;
	
	$.post(url1,params,function(data) {
		data = eval('('+data+')');
		if (data.success == "success") {
			var $mrpic_span = $('#mrpic_' + index);
			$mrpic_span.attr('picId', data.picId);
			document.getElementById('cn_' + index).style.display = "block";
			// alert("图片上传成功！");
			return;
		} else {
			alert("图片上传失败,请重试！");
		}
	});
}
