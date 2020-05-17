package com.ct.erp.firstcheck.web;

import com.alibaba.fastjson.JSON;
import com.ct.erp.common.web.SimpleActionSupport;
import com.ct.erp.core.security.SecurityUtils;
import com.ct.erp.core.security.SessionInfo;
import com.ct.erp.firstcheck.dao.FirstCheckDao;
import com.ct.erp.firstcheck.service.FirstCheckService;
import com.ct.erp.lib.entity.FirstCheck;
import com.ct.erp.lib.entity.Staff;
import com.ct.erp.lib.entity.User;
import com.ct.erp.sys.dao.StaffDao;
import com.ct.erp.sys.dao.UserDao;
import com.ct.erp.util.DataSync;
import com.ct.erp.util.UcmsWebUtils;
import org.apache.struts2.ServletActionContext;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Controller;
import sun.plugin.dom.html.ns4.HTMLFormCollection;
import sun.plugin2.message.JavaScriptBaseMessage;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.xml.ws.spi.http.HttpContext;
import java.util.List;
import java.util.Map;


@SuppressWarnings("serial")
@Scope("prototype")
@Controller("qiyuan.firstCheckAction")
public class FirstCheckAction extends SimpleActionSupport {

    private Long firstCheckId;
    private FirstCheck firstCheck;
    private Long marketId;
    private List<User> userList;

    @Autowired
    private FirstCheckService firstCheckService;
    @Autowired
    private UserDao userDao;
    @Autowired
    private FirstCheckDao firstCheckDao;

    @Autowired
    private DataSync dataSync;

    public String initDispach(){

       firstCheck = firstCheckDao.get(firstCheckId);

       HttpServletRequest request = ServletActionContext.getRequest();
       HttpSession session = request.getSession();

       session.setAttribute("firstcheck",firstCheck);
       session.setAttribute("firstCheckId",firstCheckId);

       this.userList=userDao.findAll();

        return "init";
    }
    public String add(){

        HttpServletRequest request=ServletActionContext.getRequest();
        HttpSession session = request.getSession();
        HttpServletResponse response = ServletActionContext.getResponse();
        SessionInfo sessionInfo = SecurityUtils.getCurrentSessionInfo();


        firstCheck = (FirstCheck)session.getAttribute("firstcheck");
        firstCheckId = (Long)session.getAttribute("firstCheckId");
        String stringCheckId = request.getParameter("checkerId");
        Long checkId = Long.parseLong(stringCheckId);



        try {
            firstCheck.setCheckerId(checkId);
            firstCheck.setStatus("unprocessed");
            firstCheck.setOperatorId(sessionInfo.getStaffId());
            firstCheckDao.update(firstCheck);
            firstCheckDao.getSession().flush();

            dataSync.publishFirstCheckMessageToRuby(firstCheck);

            UcmsWebUtils.ajaxOutPut(response, "success");
        } catch (Exception e) {
            e.printStackTrace();
            UcmsWebUtils.ajaxOutPut(response, "false");
        }
        return null;
    }
    public Long getFirstCheckId() {
        return firstCheckId;
    }

    public void setFirstCheckId(Long firstCheckId) {
        this.firstCheckId = firstCheckId;
    }

    public FirstCheck getFirstCheck() {
        return firstCheck;
    }

    public void setFirstCheck(FirstCheck firstCheck) {
        this.firstCheck = firstCheck;
    }

    public Long getMarketId() {
        return marketId;
    }

    public void setMarketId(Long marketId) {
        this.marketId = marketId;
    }

    public List<User> getUserList() {
        return userList;
    }

    public void setUserList(List<User> userList) {
        this.userList = userList;
    }




}
