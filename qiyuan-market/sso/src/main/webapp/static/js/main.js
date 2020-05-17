$(function(){

  $(".helpnav").hover(function(){
	  $(this).parent().addClass('hover');
  },function(){
	  $(this).parent().removeClass('hover');
  });
  
  $(".ibox").hover(function(){
	  $(this).addClass('hover');
  },function(){
	  $(this).removeClass('hover');
  });
 
  $("#rybtn").click(function(){
	  $("#tanchuang").show();
  });
 
  $("#ttcbtn").click(function(){
	  $("#tanchuang").hide();
  });
 
  $("#viewall").click(function(){
	  $(".viewallbox").show();
	  $(this).hide();
	  $("#viewallc").show();
  });
 
  $("#viewls").click(function(){
	  $(".viewallbox").show();
	  $("#viewall").hide();
	  $("#viewallc").show();
  });
  
  $("#viewallc").click(function(){
	  $(".viewallbox").hide();
	  $(this).hide();
	  $("#viewall").show();
  });
  
});

$(document).ready(function(){
	$(window).scroll(function(){
		nowtop = parseInt($(document).scrollTop());	
		$('#cleft_box').css('top', nowtop + 230 + 'px')
	})
	$('#cleft_box').hover(function(){
		$(this).css('width','54px');
	},function(){
		$(this).css('width','21px');
	})
})


function setTab(name,cursel,n){
 for(i=1;i<=n;i++){
  var menu=document.getElementById(name+i);
  var con=document.getElementById("tab_"+name+"_"+i);
  menu.className=i==cursel?"hover":"";
  con.style.display=i==cursel?"block":"none";
 }
}


$(document).ready(function () {
	var mainh = (document.documentElement.clientHeight)-164;
	if($('#mainer').height() < mainh){
	$('#mainer').height(mainh);
	$('.imain').height(mainh-46);
	$('.imain .box').css('margin-top', ((mainh)-$('.imain .box').height()-56)/2)
	$('.mainr').height(mainh-60);
	$('.faqb').css('margin-top', ((mainh)-$('.faqb').height()-124)/2)
	$('.loginmain').height(mainh-52);
	$('.loginmain .box').css('margin-top', ((mainh)-$('.loginmain .box').height()-62)/2)
	}
});
	  
$(window).resize(function () {
	var mainh = (document.documentElement.clientHeight)-164;
	if($('#mainer').height() < mainh){
	$('#mainer').height(mainh);
	$('.imain').height(mainh-46);
	$('.imain .box').css('margin-top', ((mainh)-$('.imain .box').height()-56)/2)
	$('.mainr').height(mainh-60);
	$('.faqb').css('margin-top', ((mainh)-$('.faqb').height()-124)/2)
	$('.loginmain').height(mainh-52);
	$('.loginmain .box').css('margin-top', ((mainh)-$('.loginmain .box').height()-62)/2)
	}
}).resize();