// JavaScript Document
$(document).ready(function(){
	var roll;
	function showMessage(widht,height) {
	$("#mymessage").css("width",widht+"px").css("height",height+"px");//设置消息框的大小
	//$("#mymessage").slideDown(1000);//弹出
	}
	function close_tip(){
	$("#mymessage").slideUp(1000);//这里之所以用slideUp是为了兼用Firefox浏览器
	}
	$("#message_close").click(function() {//当点击关闭按钮的时候
		close_tip();
	});
 	$(function(){
          showMessage(420);
    });
 	/**
	roll=setTimeout(close_tip,500000);//五秒钟自动消失
	$("#mymessage").hover(function(){
		clearTimeout(roll)//停止定时器
	},function(){
	roll=setTimeout(close_tip,2000)//鼠标离开后两秒钟消失										
	})
	*/


});