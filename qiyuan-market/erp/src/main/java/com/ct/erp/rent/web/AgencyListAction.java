package com.ct.erp.rent.web;

import com.ct.erp.common.web.SimpleActionSupport;
import com.ct.erp.lib.entity.Agency;
import com.ct.erp.rent.dao.AgencyDao;
import com.ct.erp.rent.service.AgencyService;
import com.ct.erp.util.DataSync;
import com.ct.erp.util.UcmsWebUtils;
import org.apache.struts2.ServletActionContext;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Controller;

import javax.servlet.http.HttpServletResponse;

/**
 * Created by peterzd on 9/9/17.
 */

@SuppressWarnings("serial")
@Scope("prototype")
@Controller("rent.agencyListAction")
public class AgencyListAction extends SimpleActionSupport {
    private static final Logger log = LoggerFactory.getLogger(AgencyListAction.class);

    private Agency agency;
    private Long agencyId;

    @Autowired
    private AgencyService agencyService;
    @Autowired
    private AgencyDao agencyDao;
    @Autowired
    private DataSync dataSync;

    public String toFreezeAgencyPage() {
		return "toFreezeAgencyPage";
    }
    public void doFreezeAgency() {
        processAgencyStatus("2");
    }

    public String toUnfreezeAgencyPage() { return "toUnfreezeAgencyPage"; }
    public void doUnfreezeAgency() { processAgencyStatus("1"); }

    public String toCancelAgencyPage() { return "toCancelAgencyPage"; }
    public void doCancelAgency() {
        processAgencyStatus("0");
    }

    public String toEditPage() {
        this.agency = this.agencyService.findById(this.agencyId);
        return "toEditPage";
    }

    // 保存编辑
    public void doUpdateAction() {
        Long agencyId = agency.getId();
        Agency agencyToUpdate = agencyDao.load(agencyId);
        agencyToUpdate.setUserName(agency.getUserName());
        agencyToUpdate.setUserPhone(agency.getUserPhone());
        agencyToUpdate.setUserIdCard(agency.getUserIdCard());
        agencyToUpdate.setAgencyName(agency.getAgencyName());
        agencyToUpdate.setLegalPersonName(agency.getLegalPersonName());
        agencyToUpdate.setLegalPersonPhone(agency.getLegalPersonPhone());
        agencyDao.getSession().flush();
        HttpServletResponse response = ServletActionContext.getResponse();
        UcmsWebUtils.ajaxOutPut(response, "success");
    }

    private void processAgencyStatus(String newStatusValue) {
        this.agency = this.agencyService.findById(this.agencyId);
        agency.setStatus(newStatusValue);
        this.agencyService.update(agency);
        // TODO: 要把信息同步到车来客
//        DataSync dataSync = new DataSync();
        dataSync.publishToRuby("shop_sync", this.agency.getId().toString());
        HttpServletResponse response = ServletActionContext.getResponse();
        UcmsWebUtils.ajaxOutPut(response, "success");
    }

    // 自动生成的getter setter 方法
    public Agency getAgency() {
        return agency;
    }

    public void setAgency(Agency agency) {
        this.agency = agency;
    }

    public Long getAgencyId() {
        return agencyId;
    }

    public void setAgencyId(Long agencyId) {
        this.agencyId = agencyId;
    }

    public AgencyService getAgencyService() {
        return agencyService;
    }

    public void setAgencyService(AgencyService agencyService) {
        this.agencyService = agencyService;
    }

    public DataSync getDataSync() {
        return dataSync;
    }

    public void setDataSync(DataSync dataSync) {
        this.dataSync = dataSync;
    }
}
