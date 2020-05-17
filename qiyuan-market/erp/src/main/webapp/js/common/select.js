// JavaScript Document
function $$$$$(_sId,v){
	var divname="";
	divname = _sId+v;
return document.getElementById(divname);
}
function hide(_sId,v)
{
	$$$$$(_sId,v).style.display = $$$$$(_sId,v).style.display == "none" ? "" : "none";}
function pick(v,i) {
document.getElementById('amdiv'+i).value=v;
hide('HMF',i)
}
