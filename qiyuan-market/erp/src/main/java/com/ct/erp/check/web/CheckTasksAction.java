package com.ct.erp.check.web;

import com.ct.erp.check.dao.CheckTaskDao;
import com.ct.erp.common.web.SimpleActionSupport;
import com.ct.erp.core.security.SecurityUtils;
import com.ct.erp.core.security.SessionInfo;
import com.ct.erp.lib.entity.CheckTask;
import com.ct.erp.lib.entity.Staff;
import com.ct.erp.lib.entity.Market;
import com.ct.erp.sys.dao.StaffDao;
import com.ct.erp.check.dao.CheckTaskDao;
import com.ct.erp.market.dao.MarketDao;
import com.ct.erp.util.UcmsWebUtils;
import com.qiyuan.dao.CarsDao;
import org.apache.commons.lang3.StringUtils;
import org.apache.struts2.ServletActionContext;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Controller;
import sun.swing.StringUIClientPropertyKey;

import javax.servlet.http.HttpServletResponse;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * Created by peterzd on 9/15/17.
 */
@SuppressWarnings("serial")
@Scope("prototype")
@Controller("qiyuan.checkTasksAction")
public class CheckTasksAction extends SimpleActionSupport{
    private static final Logger logger = LoggerFactory.getLogger(CheckTasksAction.class);

    private Staff checker;
    private Long checkerId;
    private Long checkId;
    private Market market;

    public Market getMarket() {
        return this.market;
    }

    public void setMarket(Market market) {
        this.market = market;
    }

    private Long marketId;

    public Long getMarketId() {
        return this.marketId;
    }

    public void setMarketId(Long marketId) {
        this.marketId = marketId;
    }

    private List<Staff> checkers;
    private String reportCode;
    private CheckTask checkTask;

    //注入dao
    @Autowired
    private StaffDao staffDao;
    @Autowired
    private CheckTaskDao checkTaskDao;
    @Autowired
    private CarsDao carsDao;
    @Autowired
    private MarketDao marketDao;

    //执行业务：派单页面跳转：
    public String toSendPage(){
        checkTask = this.checkTaskDao.findCheckById(checkId);
        //this.checkers = staffDao.findUseStaff();
        market = marketDao.findById(marketId);
        this.checkers = staffDao.findUseStaffByMarket(market);
        return "toSendPage";
    }

    public String toEditPage() {
        checkTask = this.checkTaskDao.findCheckById(checkId);
        String h5Url = checkTask.getTaskReportH5Url();

        reportCode = "";
        if(h5Url != null && h5Url.length() > 0) {
            Pattern p = Pattern.compile("http://open\\.268v\\.com/Reportview/17/0724/(.*?)\\.html");
            Matcher m = p.matcher(h5Url);
            if (m.find()) {
                reportCode = m.group(1);
            }
        }

        return "toEditPage";
    }

    public void doEditPage() {
        // TODO: 把得到的 reportCode 更新到 task_report_h5_url 字段
        String baseUrl = "http://open.268v.com/ReportView/17/0502/";

        if (StringUtils.isBlank(this.reportCode)) {
            HttpServletResponse response = ServletActionContext.getResponse();
            UcmsWebUtils.ajaxOutPut(response, "编号不能为空");
        } else {
            String sanitizedCode = this.reportCode.toUpperCase().trim();

            String h5Url = baseUrl + sanitizedCode + ".html";

            Long checkId = checkTask.getTaskId();
            CheckTask checkTaskToUpdate = checkTaskDao.load(checkId);

            // 如果之前未填写地址
            String checkTaskH5Url = checkTaskToUpdate.getTaskReportH5Url();
            if (checkTaskH5Url != null && checkTaskH5Url.length() > 0) {
                checkTaskToUpdate.setTaskReportH5Url(h5Url);
                checkTaskDao.getSession().flush();
            } else {
                checkTaskToUpdate.setTaskReportH5Url(h5Url);
                checkTaskDao.getSession().flush();
                // 更新车辆检测状态
                // 调用同步操作 发送消息给申请者
                SessionInfo sessionInfo = SecurityUtils.getCurrentSessionInfo();
                Long staffId = sessionInfo.getStaffId();
                carsDao.updateCheckState(checkTaskToUpdate.getCarId(), "first_reported", null, staffId);
            }
            HttpServletResponse response = ServletActionContext.getResponse();
            UcmsWebUtils.ajaxOutPut(response, "success");
        }
    }

    public void editSendPage(){
        //post请求获取参数：checkId取派单id，设置该派单的检测师为下拉列表选择的参数；
        //设置派单的取派员:

        //获取取派单
        Long checkId = checkTask.getTaskId();
        CheckTask checkTaskToUpdate = checkTaskDao.load(checkId);
        //获取设置的检测员
        Staff staff = staffDao.findById(checkerId);
        //checkTask.setCheckStaff(staff);
        //最后把检测员设置到数据库；
        checkTaskToUpdate.setCheckerId(checkerId);
        String sended = "sended";
        checkTaskToUpdate.setTaskState(sended);

        checkTaskDao.getSession().flush();
        HttpServletResponse response = ServletActionContext.getResponse();
        UcmsWebUtils.ajaxOutPut(response, "success");
    }


    public Long getCheckerId() {
        return this.checkerId;
    }

    public void setCheckerId(Long checkerId) {
        this.checkerId = checkerId;
    }

    public Staff getChecker() {
        return checker;
    }

    public void setChecker(Staff checker) {
        this.checker = checker;
    }

    public Long getCheckId() {
        return checkId;
    }

    public void setCheckId(Long checkId) {
        this.checkId = checkId;
    }

    public StaffDao getStaffDao() {
        return staffDao;
    }

    public List<Staff> getCheckers() {
        return checkers;
    }

    public void setCheckers(List<Staff> checkers) {
        this.checkers = checkers;
    }

    public CheckTask getCheckTask() {
        return checkTask;
    }

    public String getReportCode() {
        return reportCode;
    }

    public void setReportCode(String reportCode) {
        this.reportCode = reportCode;
    }

    public void setStaffDao(StaffDao staffDao) {
        this.staffDao = staffDao;
    }

    public void setCheckTask(CheckTask checkTask) {
        this.checkTask = checkTask;
    }

    public CheckTaskDao getCheckTaskDao() {
        return checkTaskDao;
    }

    public void setCheckTaskDao(CheckTaskDao checkTaskDao) {
        this.checkTaskDao = checkTaskDao;
    }
}
