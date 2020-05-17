package com.ct.erp.checker.web;

import com.ct.erp.common.web.SimpleActionSupport;
import com.ct.erp.lib.entity.Staff;
import com.ct.erp.sys.dao.StaffDao;
import com.ct.erp.util.UcmsWebUtils;
import com.qiyuan.dao.CheckerDao;
import org.apache.struts2.ServletActionContext;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Controller;

import javax.servlet.http.HttpServletResponse;

/**
 *
 */
@SuppressWarnings("serial")
@Scope("prototype")
@Controller("qiyuan.checkerAction")
public class CheckerAction extends SimpleActionSupport{

    private Staff checker;
    private Long checkerId;
    private Integer checkerCnt;
    private Integer reCheckerCnt;
    @Autowired
    private StaffDao staffDao;

    @Autowired
    private CheckerDao checkerDao;

    public String toEditChecker7y(){
        checker = staffDao.findById(checkerId);
        checkerCnt = checkerDao.countCheck(checker.getId(), "acquisition_check");
        reCheckerCnt = checkerDao.countCheck(checker.getId(), "sold_check");
        return "toEditChecker7y";
    }

    public void editChecker7y(){
        Staff staff = staffDao.load(checker.getId());
        /*staff.setTel(checker.getTel());
        staff.setName(checker.getName());*/
        staff.setIdNo(checker.getIdNo());
        staffDao.getSession().flush();
        HttpServletResponse response = ServletActionContext.getResponse();
        UcmsWebUtils.ajaxOutPut(response, "success");
    }

    public String toCancelChecker7y(){
        return "toCancelChecker7y";
    }

    public void cancelChecker7y(){
        Staff staff = staffDao.load(checkerId);
        staff.setStatus("0");
        staffDao.getSession().flush();
        HttpServletResponse response = ServletActionContext.getResponse();
        UcmsWebUtils.ajaxOutPut(response, "success");
    }

    public Staff getChecker() {
        return checker;
    }

    public void setChecker(Staff checker) {
        this.checker = checker;
    }

    public Long getCheckerId() {
        return checkerId;
    }

    public void setCheckerId(Long checkerId) {
        this.checkerId = checkerId;
    }

    public Integer getCheckerCnt() {
        return checkerCnt;
    }

    public void setCheckerCnt(Integer checkerCnt) {
        this.checkerCnt = checkerCnt;
    }

    public Integer getReCheckerCnt() {
        return reCheckerCnt;
    }

    public void setReCheckerCnt(Integer reCheckerCnt) {
        this.reCheckerCnt = reCheckerCnt;
    }
}
