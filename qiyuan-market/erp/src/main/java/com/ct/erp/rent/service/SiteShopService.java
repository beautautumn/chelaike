package com.ct.erp.rent.service;

import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.ct.erp.common.exception.ServiceException;
import com.ct.erp.constants.sysconst.Const;
import com.ct.erp.core.security.SecurityUtils;
import com.ct.erp.lib.entity.ContractArea;
import com.ct.erp.lib.entity.ContractShop;
import com.ct.erp.lib.entity.OperHis;
import com.ct.erp.lib.entity.SiteArea;
import com.ct.erp.lib.entity.SiteShop;
import com.ct.erp.rent.dao.ContractShopDao;
import com.ct.erp.rent.dao.SiteShopDao;
import com.ct.erp.sys.dao.OperHisDao;
import com.ct.erp.sys.service.base.StaffService;
import com.ct.erp.util.UcmsWebUtils;

@Service
public class SiteShopService {
	
	@Autowired
	private SiteShopDao siteShopDao;
	@Autowired
	private ContractShopDao contractShopDao;
	@Autowired
	private OperHisDao operHisDao;
	@Autowired
	private StaffService staffService;

	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = ServiceException.class)
	public void saveSiteShop(SiteShop siteShop) {
		this.siteShopDao.save(siteShop);
		OperHis operHis=new OperHis();
		operHis.setStaff(staffService.findStaffById(SecurityUtils.getCurrentSessionInfo().getStaffId()));
		operHis.setOperTag(Const.SITESHOP);
		operHis.setOperTime(UcmsWebUtils.now());
		operHis.setOperDesc(SecurityUtils.getCurrentSessionInfo().getUserName()+"添加了商铺:"+siteShop.getAreaName());
		operHis.setOperObj(siteShop.getId());
		this.operHisDao.save(operHis);
	}
	
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = ServiceException.class)
	public void updateSiteShop(SiteShop siteShop) {
		this.siteShopDao.update(siteShop);
		OperHis operHis=new OperHis();
		operHis.setStaff(staffService.findStaffById(SecurityUtils.getCurrentSessionInfo().getStaffId()));
		operHis.setOperTag(Const.SITESHOP);
		operHis.setOperTime(UcmsWebUtils.now());
		operHis.setOperDesc(SecurityUtils.getCurrentSessionInfo().getUserName()+"修改了商铺:"+siteShop.getAreaName());
		operHis.setOperObj(siteShop.getId());
		this.operHisDao.save(operHis);
	}
	
	public List<SiteShop> getSiteArea(String currentSiteAreas) {
		if(!(currentSiteAreas==null||currentSiteAreas.trim().length()==0)){
			String[] arr=currentSiteAreas.split(",");
			List<String> current=new ArrayList<String>();
			for(String currentSiteAreaId:arr){
				if(!(currentSiteAreaId==null||currentSiteAreaId.trim().length()==0)){
					current.add(currentSiteAreaId);
				}
			}
			return this.siteShopDao.findByCondition(current);
		}else{
			return this.siteShopDao.findByCondition(null);
		}
	}

	public List<String> findCurrentAreas() {
		
		return this.contractShopDao.findCurrentAreas();
	}

	public boolean hasContract(Long siteShopId) throws Exception{
		List<ContractShop> list =contractShopDao.findConractBysiteShopId(siteShopId);
		return (list==null ||list.size()==0)?false:true;
	}
	
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = ServiceException.class)
	public void delete(Long siteShopId){
		OperHis operHis=new OperHis();
		SiteShop siteDel = this.siteShopDao.get(siteShopId);
		siteDel.setValidTag("0");
		this.siteShopDao.update(siteDel);
		operHis.setStaff(staffService.findStaffById(SecurityUtils.getCurrentSessionInfo().getStaffId()));
		operHis.setOperTag(Const.SITESHOP);
		operHis.setOperTime(Timestamp.valueOf(new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date())));
		operHis.setOperDesc(SecurityUtils.getCurrentSessionInfo().getUserName()+"删除了场地:"+siteDel.getAreaName());
		operHis.setOperObj(siteShopId);
		this.operHisDao.save(operHis);
	}

}
