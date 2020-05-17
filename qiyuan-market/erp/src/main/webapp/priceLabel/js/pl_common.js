// JavaScript Document
$(document).ready(function(){
 

	var print_tab_l = ($(document).width()-990)/2+1010
	$(".print_tab").css('left',print_tab_l);
	$(window).resize(function(){
		var print_tab_l = ($(document).width()-990)/2+1010
		$(".print_tab").css('left',print_tab_l);
	});
	
	
	
	$('.print_tab .yellow').click(function(){
		$(this).addClass('yellow_on').siblings('div').removeClass('green_on');
	});

	$('.print_tab .yellow').click(function(){
		$(this).addClass('yellow_on').siblings('div').removeClass('green_on');
		$('.print').addClass('print2');
	});

	$('.print_tab .green').click(function(){
		$(this).addClass('green_on').siblings('div').removeClass('yellow_on');
		$('.print').removeClass('print2');
	});

});