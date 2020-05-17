/**
 * 云潮网络Javascript工具函数
 *
 * @author xueyufish
 */

var ctutil = (function() {

    return {
    	
    	/**
    	 * 获得项目根路径
    	 * @returns
    	 */
    	bp :function() {
    		var curWwwPath = window.document.location.href;
    		var pathName = window.document.location.pathname;
    		var pos = curWwwPath.indexOf(pathName);
    		var localhostPaht = curWwwPath.substring(0, pos);
    		var projectName = pathName.substring(0, pathName.substr(1).indexOf('/') + 1);
    		return (localhostPaht + projectName);
    	},

        /**
         * 阿拉伯数字转化为汉字大写金额
         *
         * @param Num 阿拉伯数字
         * @return 成功时返回汉字大写金额
         *      如果传入不是数字，返回错误码0001
         *      如果数字超过十亿单位，返回错误码0002
         */
        num_to_cny: function(Num)
        {
            if(Num == "" || Num == "0" || Num == undefined || isNaN(Num)){
                return "零圆整";
            }

            for(i=Num.length-1;i>=0;i--)
            {
                Num = Num.replace(",","")//替换tomoney()中的“,”
                Num = Num.replace(" ","")//替换tomoney()中的空格
            }
    
            Num = Num.replace("￥","")//替换掉可能出现的￥字符
            if(isNaN(Num))    
            {
                //验证输入的字符是否为数字
                return "0001";
            }

            part = String(Num).split(".");
            newchar = "";    
            //小数点前进行转化
            for(i=part[0].length-1;i>=0;i--)
            {
                if(part[0].length > 10){ 
                    //alert("位数过大，无法计算");return "";
                    return "0002";
                }
                tmpnewchar = ""
                perchar = part[0].charAt(i);
                switch(perchar) {
                    case "0": tmpnewchar="零" + tmpnewchar ;break;
                    case "1": tmpnewchar="壹" + tmpnewchar ;break;
                    case "2": tmpnewchar="贰" + tmpnewchar ;break;
                    case "3": tmpnewchar="叁" + tmpnewchar ;break;
                    case "4": tmpnewchar="肆" + tmpnewchar ;break;
                    case "5": tmpnewchar="伍" + tmpnewchar ;break;
                    case "6": tmpnewchar="陆" + tmpnewchar ;break;
                    case "7": tmpnewchar="柒" + tmpnewchar ;break;
                    case "8": tmpnewchar="捌" + tmpnewchar ;break;
                    case "9": tmpnewchar="玖" + tmpnewchar ;break;
                }
                switch(part[0].length-i-1)
                {
                    case 0: tmpnewchar = tmpnewchar +"元" ;break;
                    case 1: if(perchar!=0)tmpnewchar= tmpnewchar +"拾" ;break;
                    case 2: if(perchar!=0)tmpnewchar= tmpnewchar +"佰" ;break;
                    case 3: if(perchar!=0)tmpnewchar= tmpnewchar +"仟" ;break;    
                    case 4: tmpnewchar= tmpnewchar +"万" ;break;
                    case 5: if(perchar!=0)tmpnewchar= tmpnewchar +"拾" ;break;
                    case 6: if(perchar!=0)tmpnewchar= tmpnewchar +"佰" ;break;
                    case 7: if(perchar!=0)tmpnewchar= tmpnewchar +"仟" ;break;
                    case 8: tmpnewchar= tmpnewchar +"亿" ;break;
                    case 9: tmpnewchar= tmpnewchar +"拾" ;break;
                }
                newchar = tmpnewchar + newchar;
            }
            //小数点之后进行转化
            if(Num.indexOf(".")!=-1)
            {
                if(part[1].length > 2)
                {
                    //alert("小数点之后只能保留两位,系统将自动截段");
                    part[1] = part[1].substr(0,2)
                }
                for(i=0;i<part[1].length;i++)
                {
                    tmpnewchar = ""
                    perchar = part[1].charAt(i)
                    switch(perchar) 
                    {
                        case "0": tmpnewchar="零" + tmpnewchar ;break;
                        case "1": tmpnewchar="壹" + tmpnewchar ;break;
                        case "2": tmpnewchar="贰" + tmpnewchar ;break;
                        case "3": tmpnewchar="叁" + tmpnewchar ;break;
                        case "4": tmpnewchar="肆" + tmpnewchar ;break;
                        case "5": tmpnewchar="伍" + tmpnewchar ;break;
                        case "6": tmpnewchar="陆" + tmpnewchar ;break;
                        case "7": tmpnewchar="柒" + tmpnewchar ;break;
                        case "8": tmpnewchar="捌" + tmpnewchar ;break;
                        case "9": tmpnewchar="玖" + tmpnewchar ;break;
                    }
                    if(i==0)
                        tmpnewchar =tmpnewchar + "角";
                    if(i==1)
                        tmpnewchar = tmpnewchar + "分";
                    newchar = newchar + tmpnewchar;
                }
            }

            //替换所有无用汉字
            while(newchar.search("零零") != -1)
                newchar = newchar.replace("零零", "零");
            newchar = newchar.replace("零亿", "亿");
            newchar = newchar.replace("亿万", "亿");
            newchar = newchar.replace("零万", "万");    
            newchar = newchar.replace("零元", "元");
            newchar = newchar.replace("零角", "");
            newchar = newchar.replace("零分", "");
    
            if (newchar.charAt(newchar.length-1) == "元" || newchar.charAt(newchar.length-1) == "角")
                newchar = newchar+"整"

            return newchar;
        },
        get_browse:function()
        {        
			var NV = {};
			var UA = navigator.userAgent.toLowerCase();
			try
			{
    			NV.name=!-[1,]?'ie':
    			(UA.indexOf("firefox")>0)?'firefox':
    			(UA.indexOf("chrome")>0)?'chrome':
    			window.opera?'opera':
    			window.openDatabase?'safari':
    			'unkonw';
			}catch(e){};  
			return NV.name;  
        },
        /**
        * 获取鼠标在页面上的位置
        * @param ev        触发的事件
        * @return          x:鼠标在页面上的横向位置, y:鼠标在页面上的纵向位置
        */
        get_mouse_point:function (ev) {
            // 定义鼠标在视窗中的位置
            var point = {
                x:0,
                y:0
            };
 
            // 如果浏览器支持 pageYOffset, 通过 pageXOffset 和 pageYOffset 获取页面和视窗之间的距离
            if(typeof window.pageYOffset != 'undefined') {
                point.x = window.pageXOffset;
                point.y = window.pageYOffset;
            }
            // 如果浏览器支持 compatMode, 并且指定了 DOCTYPE, 通过 documentElement 获取滚动距离作为页面和视窗间的距离
            // IE 中, 当页面指定 DOCTYPE, compatMode 的值是 CSS1Compat, 否则 compatMode 的值是 BackCompat
            else if(typeof document.compatMode != 'undefined' && document.compatMode != 'BackCompat') {
                point.x = document.documentElement.scrollLeft;
                point.y = document.documentElement.scrollTop;
            }
            // 如果浏览器支持 document.body, 可以通过 document.body 来获取滚动高度
            else if(typeof document.body != 'undefined') {
                point.x = document.body.scrollLeft;
                point.y = document.body.scrollTop;
            }
 
            // 加上鼠标在视窗中的位置
            point.x += ev.clientX;
            point.y += ev.clientY; 
            // 返回鼠标在视窗中的位置
            return point;
        },
        //获取x绝对位置
        get_page_x:function (elem){
            return elem.offsetParent?(elem.offsetLeft+this.get_page_x(elem.offsetParent)):elem.offsetLeft;
        },
        //获取y绝对位置
        get_page_y:function(elem){
            return elem.offsetParent?(elem.offsetTop+this.get_page_y(elem.offsetParent)):elem.offsetTop;
        },
        get_current_time:function () {
            var currentTime = "";    
            var myDate = new Date();    
            var year = myDate.getFullYear();    
            var month = parseInt(myDate.getMonth().toString()) + 1; //month是从0开始计数的，因此要 + 1    
            if (month < 10) {        
            	month = "0" + month.toString();    
            }   
            var date = myDate.getDate();   
            if (date < 10) {        
               date = "0" + date.toString();    
            }    
            currentTime = year.toString() +"-"+ month.toString() +"-"+ date.toString();
            return currentTime;
        },
        trim:function(str){ 
        	if(str){
        		return str.replace(/(^\s*)|(\s*$)/g, "");
        	}
        },
        ltrim:function (str){ 
        	if(str){
        		return str.replace(/(^\s*)/g, ""); 
        	}
        },
        check_phone:function(phone)   
        {
            //验证电话号码手机号码，包含至今所有号段   
            var ab=/^(13[0-9]|15[0-9]|18[8|9|2|6|7|0|5])\d{8}$/;
            if(ab.test(phone) == false)
            {
                alert("您输入的手机号码不正确, 请重新输入!");
                return false;
            }return true;
        }
    };
})();