var validator = (function() {

    return {

        /**
         * 验证参数是否为数字
         *
         * return 如果为数字返回true, 否则返回false
         */
        validateNum : function(num)
        {
            if(num !== '')
            {
                var reg = /^([0-9]|[.]){1,50}$/gim;
                num = $.trim(num);
                if(reg.test(num))
                {
                    return true;
                }
                return false;
            }
            return false;
        }
    };
})();
