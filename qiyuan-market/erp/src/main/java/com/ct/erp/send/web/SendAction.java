package com.ct.erp.send.web;


import com.ct.erp.common.web.SimpleActionSupport;
import com.ct.erp.lib.entity.Staff;
import com.ct.erp.sys.dao.StaffDao;
import com.ct.erp.util.UcmsWebUtils;
import org.apache.struts2.ServletActionContext;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Controller;

import javax.servlet.http.HttpServletResponse;
import java.util.List;


/**
 * Created by Administrator on 2017/9/15.
 */
@SuppressWarnings("serial")
@Scope("prototype")
@Controller("qiyuan.sendAction")
public class SendAction extends SimpleActionSupport{

    //设置对象备用：
    private Staff staff;
    private Long checkerId;

    //注入dao
    @Autowired
    private StaffDao staffDao;

    //执行业务：派单页面跳转：
    public String toSend7y(){
        List<Staff> checkers = staffDao.findUseStaff();
        return "toEditChecker7y";
    }


  /*  public void editChecker7y(){
        Staff staff = staffDao.load(checker.getId());
        staff.setIdNo(checker.getIdNo());
        staffDao.getSession().flush();
        HttpServletResponse response = ServletActionContext.getResponse();
        UcmsWebUtils.ajaxOutPut(response, "success");
    }*/

    //执行业务：派单页面提交：post请求带下拉列表的参数过来了
    public void Send7y(){
        //post请求获取参数
        //设置派单的取派员

        staffDao.getSession().flush();
        HttpServletResponse response = ServletActionContext.getResponse();
        UcmsWebUtils.ajaxOutPut(response, "success");
    }

}
