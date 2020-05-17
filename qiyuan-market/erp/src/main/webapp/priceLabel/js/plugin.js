/**
* name		:	promo
* version	:	1.0
*/
(function(a){a.fn.extend({promo:function(b){b=a.extend({thumbObj:null,botPrev:null,botNext:null,thumbNowClass:"hover",thumbOverEvent:true,slideTime:1000,autoChange:true,clickFalse:true,overStop:true,changeTime:5000,delayTime:300},b||{});var h=a(this);var i;var k=h.size();var e=0;var g;var c;var f;function d(){if(e!=g){if(b.thumbObj!=null){a(b.thumbObj).removeClass(b.thumbNowClass).eq(g).addClass(b.thumbNowClass)}if(b.slideTime<=0){h.eq(e).hide();h.eq(g).show()}else{h.eq(e).fadeOut(b.slideTime);h.eq(g).fadeIn(b.slideTime)}e=g;if(b.autoChange==true){clearInterval(c);c=setInterval(j,b.changeTime)}}}function j(){g=(e+1)%k;d()}h.hide().eq(0).show();if(b.thumbObj!=null){i=a(b.thumbObj);i.removeClass(b.thumbNowClass).eq(0).addClass(b.thumbNowClass);i.click(function(){g=i.index(a(this));d();if(b.clickFalse==true){return false}});if(b.thumbOverEvent==true){i.mouseenter(function(){g=i.index(a(this));f=setTimeout(d,b.delayTime)});i.mouseleave(function(){clearTimeout(f)})}}if(b.botNext!=null){a(b.botNext).click(function(){if(h.queue().length<1){j()}return false})}if(b.botPrev!=null){a(b.botPrev).click(function(){if(h.queue().length<1){g=(e+k-1)%k;d()}return false})}if(b.autoChange==true){c=setInterval(j,b.changeTime);if(b.overStop==true){h.mouseenter(function(){clearInterval(c)});h.mouseleave(function(){c=setInterval(j,b.changeTime)})}}}})})(jQuery);

// Author:LN
//Date:2011-06-09
//Update:2011-06-27 20:58
//Description:滑动选择范围 LN_slider

//后期需要添加功能：1.点击滑动 2.根据不同步数进行滑动前行




//利用$,以及undefined加快页面搜索这个js
(function( $, undefined ) {
		  
	//提示框
	$.fn.LN_tips=function(){}
	$.fn.extend({
	LN_slider:function(options){
	var  default_options={
		  <!--是否显示选项范围框,就是页面中的文本框-->
		  Ln_show_Num:true,
		  //每次移动的步数(一步一步地移动（相对而言，滑块每次移动的距离）)——理解步数的含义
		  Ln_move_step:10,
		  //用户可以自己设置步数（数组的值是可以随便设置的），如果设置了这个值，那么Ln_move_step的值就会失效（注意）（改功能还未实现）
		  Ln_move_steyarray:[10,40,50],
		  //是否显示范围标记
		  Ln_Range:true,
		  //尺度范围
		  Ln_slider_range:[6,300],
		  //用户自定义计量单位(可有，也可无，暂时去掉了这个参数，因为在显示的时候一般都是设计好的，计量单位的长度是不定的，在后面进行截取的时候会出问题，因此这个参数暂时不用)
		  Ln_show_unit:"元"
		  }
	  settings=$.fn.extend({},default_options,options)
	  //用于范围标记
	  handles=[]//用于保存handles操作柄
	  var rang_mark="<div></div>"
	 if(settings.Ln_Range)
	 {
	$(rang_mark).appendTo($(".Js_main_slider")).addClass("Ln_slider_range").css({"width":"100%"})
	 }
	   
	  <!--用于后期添加 更多的操作柄-->
	  var add_handle="<span></span>"
	  //储存滑动块
	 $(".Js_main_slider").find("span").each(
				function(){
					handles.push($(this));
					}
				)
		
			if(handles.length<=0)
			return;						
	<!--填从两个selects控件的options选项(以备后期update使用)-->
		 select_options=""
		 options_temp=[]//用户存储option中的选项值来与滑动条绑定
		 settings.Ln_Max_steps=settings.Ln_Max_steps?settings.Ln_Max_steps:1;
		for(var i=0,j=0; i<=settings.Ln_slider_range[1],j<=settings.Ln_Max_steps-1;i+=Math.round(settings.Ln_slider_range[1]/settings.Ln_Max_steps),j++)
		{
			select_options+='<option value="'+j+'">'+i+'</option>'	
			options_temp.push(i)
		}
		select_options+='<option value="'+settings.Ln_Max_steps+'">'+settings.Ln_slider_range[1]+'</option>'					
		options_temp[settings.Ln_Max_steps]=settings.Ln_slider_range[1]
		$(".LN_select_L,.LN_select_R").each(function(){$(this).html(select_options)})
		
		
		//初始化左侧初选项 以及右侧出选项，以及滑动块的初始索引
		if(!settings.Ln_show_Num)
		{
		$(".min_value_L,.max_value_R").hide();
			}
		$(".value_0").val(settings.Ln_slider_range[0]);
		$(".value_1").val(settings.Ln_slider_range[1]);
		
	<!--以上是通过select控件进行选择的  以备后期使用-->							

	<!--开始控制滑动块的滑动操作-->
	if(!settings.Ln_show_Num)
	{
		$("input:text").hide();
		
		}
	$(".Js_hander_L,.Js_hander_R").css({"top":($(".Js_hander_L").height()-$(".Js_main_slider").height())>0?($(".Js_main_slider").height()-$(".Js_hander_L").height())/2																																																							 :($(".Js_main_slider").height()-$(".Js_hander_L").height())/2})
	$(".Js_hander_L").css({"left":parseFloat(0-($(".Js_hander_L").width()/2).toFixed(1))+parseFloat((settings.Ln_slider_range[0]/settings.Ln_slider_range[1])*($(".Js_main_slider").width()))+"px"})
	$(".Js_hander_R").css({"left":($(".Js_main_slider").width()-($(".Js_hander_R").width()/2).toFixed(1)+"px")})
	if(settings.Ln_Range)
		{
			
				$(".Ln_slider_range").css({"left":parseFloat(handles[0].css("left").slice(0,-2))+parseFloat(handles[0].width()/2)+"px","width":parseFloat(handles[1].css("left").slice(0,-2))-parseFloat(handles[0].css("left").slice(0,-2))+"px"} )}
								
	//slider上点击移动	
	$(".Js_main_slider").click(
			function(event){
				var click_point,click_handle,click_to_align
			if($(event.target).attr("class")=="Js_hander_L"||$(event.target).attr("class")=="Js_hander_R")
			{
				event.stopImmediatePropagation()
				return false;}
			else
			{
				
				
				if(Math.abs(parseFloat(event.pageX-$(this).offset().left)-parseFloat(handles[0].css("left").slice(0,-2)))<Math.abs(parseFloat(event.pageX-$(this).offset().left)-parseFloat(handles[1].css("left").slice(0,-2))))
				{
					//handles[0]移动

					
					click_point=event.pageX-$(".Js_main_slider").offset().left;
					click_handle=_is_move(click_point)
					click_to_align=_test_align(click_handle)
					$(".value_0").val(click_to_align);
					handles[0].css("left",(($(".value_0").val()/settings.Ln_slider_range[1])*$(".Js_main_slider").width()-handles[0].width()/2).toFixed(1)+"px")
					
					
				}
				else 	if(Math.abs(parseFloat(event.pageX-$(this).offset().left)-parseFloat(handles[0].css("left").slice(0,-2)))>Math.abs(parseFloat(event.pageX-$(this).offset().left)-parseFloat(handles[1].css("left").slice(0,-2))))
				{
				click_point=event.pageX-$(".Js_main_slider").offset().left;
				click_handle=_is_move(click_point)
				click_to_align=_test_align(click_handle)
					$(".value_1").val(click_to_align);
					handles[1].css("left",(($(".value_1").val()/settings.Ln_slider_range[1])*$(".Js_main_slider").width()-handles[1].width()/2).toFixed(1)+"px")

				}
				else 
					{
				event.stopImmediatePropagation()
				return false;}
		if(settings.Ln_Range)
				{
					
						$(".Ln_slider_range").css({"left":parseFloat(handles[0].css("left").slice(0,-2))+parseFloat(handles[0].width()/2)+"px","width":parseFloat(handles[1].css("left").slice(0,-2))-parseFloat(handles[0].css("left").slice(0,-2))+"px"} )}
				
			}
			
			} )

							
		//滑块移动拖曳	
		$("span[class^='Js_hander_']").each(function(index){
		//开始控制鼠标的滑动以及text控件中值的改变
		//滑动当前的滑块
		//this:当前滑块
		//index:当前滑块的索引
		<!--开始操作滑块，并记录当前的滑块对象-->
		Ln_drag_Handle(this,index)
	});
}
})
	 //拖曳效果函数开始(针对的是滑动块)
	var Ln_drag_Handle=function(element,index){
		var mousehandle=false;
		//（注意下面这个是全局的相当于window对象的属性，注意最后要进行删除，以防IE下的内存泄漏）
		$(element).mousedown(function(event){
			
			//鼠标所在的位置
			//获取当前的鼠标点击对象
			cur_handle=handles[index]
			//用于保存数组步数中当前的索引,以及移动之前当前对象的left值
			
			cur_step=0;
			cur_step_cssleft=handles[index].css("left")
			cur_handle.addClass("ln_slider_move")
			x=event.clientX-element.offsetLeft
			down_Event=event;
			//IE下捕捉焦点
			element.setCapture && element.setCapture();
			//绑定事件(2级DOM模型)
			$(element).bind('mousemove',moveHandle).bind('mouseup',upHandle);
			$(document).bind('mousemove',moveHandle).bind('mouseup',upHandle);
	})
					
	function moveHandle(e){
		//步数，根据步数去定滑动的距离(注意下面的计算)
		settings.Ln_move_step=settings.Ln_move_step>0?settings.Ln_move_step:1;						
		var e=e||window.event;
		//滑块移动的时候控制不能超过总slider滑动条的宽度
		mousehandle=true;
		//控制鼠标当前所在的位置
		//计算相对于移动一步，在固定长度的滑动条上需要移动的距离
		click_to_handlecenter=mousehandle?e.clientX-cur_handle.offset().left-Math.round(cur_handle.width()/2):"0"
		var curent_X=e.clientX-cur_handle.parent().offset().left//当前鼠标所在的位置
		var mouse_value=_is_move(curent_X);
		value_align=_test_align(mouse_value)
		//console.log(value_align)					
		//控制滑块不超过slider的长度范围内
		if(e.clientX-x>=(0-Math.round($(".Js_hander_R").width()/2)) && e.clientX-x<=($(".Js_main_slider").width()-parseInt(Math.round($(".Js_hander_R").width()/2))))
		{	
		//alert(e.clientX-x>=(0-Math.round($("#Js_hander_R").width()/2)))
			var clickoffset;
			if(cur_handle.hasClass("ln_slider_move"))
			{
				clickoffset=((e.clientX-cur_handle.parent().offset().left-click_to_handlecenter)*(parseFloat(settings.Ln_slider_range[1]/$(element).parent().width().toFixed(10))))+"px";
			}
			else
			{
			clickoffset="0px"
			}
				//alert(clickoffset)
				//滑块的总长度,用户可以在样式表中根据个人需要进行宽度的设置
				var totalbar=cur_handle.parent("div").width();
				if(clickoffset.slice(0,-2)<0){clickoffset="0px"}
				//将下一步的值重新被赋值之前，将其当前的值进行保存
				//测试显示
				//$("#text_val").text($("#Js_hander_R").css("left"))
				//控制操作柄不超过他们自己应有的滑动范围
	
				if((index==0 && e.clientX-x>$(".Js_hander_R").css("left").slice(0,-2))||(index==1 && e.clientX-x<$(".Js_hander_L").css("left").slice(0,-2)))
				{
					
					if(index==0)
					{
					var left_distance=$(".Js_hander_R").css("left");
					$(".Js_hander_L").css("left",left_distance)
					}
					else
					{
	
						var right_distance=$(".Js_hander_L").css("left")
						$(".Js_hander_R").css("left",right_distance);
					}
				}
				else
				{
				$(".value_"+index).val(value_align)
				cur_handle.css("left",(($(".value_"+index).val()/settings.Ln_slider_range[1])*totalbar-cur_handle.width()/2).toFixed(1)+"px")
				if(settings.Ln_Range)
				{
					
						$(".Ln_slider_range").css({"left":parseFloat(handles[0].css("left").slice(0,-2))+parseFloat(handles[0].width()/2)+"px","width":parseFloat(handles[1].css("left").slice(0,-2))-parseFloat(handles[0].css("left").slice(0,-2))+"px"} )}
				}
	
		}
		else return ;
		}
		
		
	//释放鼠标，解除所有的绑定事件
	function upHandle(e){
			//IE下释放焦点
			element.releaseCapture && element.releaseCapture();
			//卸载事件
			$(element).unbind('mousemove',moveHandle).unbind('mouseup',upHandle);
			//删除样式，以确保当前滑块不可以移动
			$(element).removeClass("ln_slider_move")
			$(document).unbind('mousemove',moveHandle).unbind('mouseup',upHandle);
		}
	//以控制当前的滑块是否进行移动
	}
				//返回移动的新值，并控制鼠标的回调值
	var _is_move=function(val){
			var mouse_percent=(val/$(".Js_main_slider").width());
			//$("#text_val").text(mouse_percent)
			if(mouse_percent>1)
			mouse_percent=1
			if(mouse_percent<0)
			mouse_percent=0
			var mouse_value=mouse_percent*settings.Ln_slider_range[1];
			return _test_align(mouse_value);
		}
	
	//计算滑块的滑动距离，以及鼠标与滑块的距离关系
	var _test_align=function(value){
			if(value<settings.Ln_slider_range[0])
			return settings.Ln_slider_range[0];
			if(value>settings.Ln_slider_range[1])
			return settings.Ln_slider_range[1]
			var step;
			step=settings.Ln_move_step>0?settings.Ln_move_step:1;
			mouse_mod_step=(value-settings.Ln_slider_range[0])%step
			mouse_align=value-mouse_mod_step;
			if(Math.abs(mouse_mod_step*2)>=step)
			{
				mouse_align+=(mouse_mod_step>0)?step:(-step)
			}
			return Math.floor(mouse_align);
	}
	
	})(jQuery);
