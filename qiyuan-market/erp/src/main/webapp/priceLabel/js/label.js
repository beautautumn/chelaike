function setTab(name){
  document.getElementById("lv_main").className=name;
}
function printme()
{
var div1 = document.getElementById('lv_mian2'); 
div1.style.display="none";
window.print();
}
function printLabel(){
	$.ajax({
	      type: 'post',
	            url:'vehicle_changLabelPrintTag.action?vehicleId=' +$("#vehicleId").val(),
	            data: "",
	            async : false //默认为true 异步
	    });
	      window.print();

}