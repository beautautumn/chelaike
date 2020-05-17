package com.ct.erp.rent.service;

import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.ct.erp.common.exception.ServiceException;
import com.ct.erp.core.security.SecurityUtils;
import com.ct.erp.lib.entity.ContractArea;
import com.ct.erp.lib.entity.OperHis;
import com.ct.erp.lib.entity.SiteArea;
import com.ct.erp.rent.dao.ContractAreaDao;
import com.ct.erp.rent.dao.ContractDao;
import com.ct.erp.rent.dao.SiteAreaDao;
import com.ct.erp.rent.model.SiteAreaBean;
import com.ct.erp.sys.dao.OperHisDao;
import com.ct.erp.sys.service.base.StaffService;
import com.ct.erp.util.UcmsWebUtils;


@Service
public class SiteAreaService {
	@Autowired
	private SiteAreaDao siteAreaDao;
	@Autowired
	private StaffService staffService;
	@Autowired
	private OperHisDao operHisDao;
	@Autowired
	private ContractAreaDao contractAreaDao;
	
	public SiteArea findById(Long id){
		return this.siteAreaDao.findById(id);
	}
	
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = ServiceException.class)
	public void save(SiteArea siteArea,SiteAreaBean siteAreaBean){
		OperHis operHis=new OperHis();
		siteArea.setStatus("1");
		if("0".equals(siteArea.getRentType())){
			siteArea.setMonthRentFee(UcmsWebUtils.yuanTofen(siteAreaBean.getMonthRentFee()));
			siteArea.setTotalCount(siteAreaBean.getTotalCount());
			siteArea.setFreeCount(siteAreaBean.getTotalCount());
		}else{
			siteArea.setMonthRentFee(UcmsWebUtils.yuanTofen(siteAreaBean.getUnitMonthRentFee()));
			siteArea.setTotalCount(siteAreaBean.getUnitTotalCount());
			siteArea.setFreeCount(siteAreaBean.getUnitTotalCount());
		}
		this.siteAreaDao.save(siteArea);
		operHis.setStaff(staffService.findStaffById(SecurityUtils.getCurrentSessionInfo().getStaffId()));
		operHis.setOperTag("3");
		operHis.setOperTime(Timestamp.valueOf(new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date())));
		operHis.setOperDesc(SecurityUtils.getCurrentSessionInfo().getUserName()+"添加了场地:"+siteArea.getAreaName());
		operHis.setOperObj(siteArea.getId());
		this.operHisDao.save(operHis);
	}
	
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = ServiceException.class)
	public void update(SiteArea siteArea,SiteAreaBean siteAreaBean,Long siteAreaId){ OperHis operHis=new OperHis();
		SiteArea s = this.findById(siteAreaId);
		s.setAreaName(siteArea.getAreaName());
		s.setRemark(siteArea.getRemark());
		s.setRentType(siteArea.getRentType());
		if("0".equals(siteArea.getRentType())){
			Double difference = siteAreaBean.getTotalCount() - s.getTotalCount();
			if(difference + s.getFreeCount() < 0){
				throw new ServiceException("闲置车位数量小于调整车位数量！");
			}
			s.setMonthRentFee(UcmsWebUtils.yuanTofen(siteAreaBean.getMonthRentFee()));
			s.setTotalCount(siteAreaBean.getTotalCount());
			s.setFreeCount(s.getFreeCount() + difference);
		}else{
			Double difference = siteAreaBean.getUnitTotalCount() - s.getTotalCount();
			if(difference + s.getFreeCount() < 0){
				throw new ServiceException("闲置车位数量小于调整车位数量！");
			}
			s.setMonthRentFee(UcmsWebUtils.yuanTofen(siteAreaBean.getUnitMonthRentFee()));
			s.setTotalCount(siteAreaBean.getUnitTotalCount());
			s.setFreeCount(s.getFreeCount() + difference);
		}
		this.siteAreaDao.update(s);
		operHis.setStaff(staffService.findStaffById(SecurityUtils.getCurrentSessionInfo().getStaffId()));
		operHis.setOperTag("3");
		operHis.setOperTime(Timestamp.valueOf(new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date())));
		operHis.setOperDesc(SecurityUtils.getCurrentSessionInfo().getUserName()+"修改了场地:"+siteArea.getAreaName());
		operHis.setOperObj(siteAreaId);
		this.operHisDao.save(operHis);
	}
	
	public boolean hasContract(Long siteAreaId) throws Exception{
		List<ContractArea> list =contractAreaDao.findConractBysiteAreaId(siteAreaId);
		return (list==null ||list.size()==0)?false:true;
	}
	
	
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = ServiceException.class)
	public void delete(Long siteAreaId){
		OperHis operHis=new OperHis();
		SiteArea siteDel = this.findById(siteAreaId);
		siteDel.setStatus("0");
		this.siteAreaDao.update(siteDel);
		operHis.setStaff(staffService.findStaffById(SecurityUtils.getCurrentSessionInfo().getStaffId()));
		operHis.setOperTag("3");
		operHis.setOperTime(Timestamp.valueOf(new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date())));
		operHis.setOperDesc(SecurityUtils.getCurrentSessionInfo().getUserName()+"删除了场地:"+siteDel.getAreaName());
		operHis.setOperObj(siteAreaId);
		this.operHisDao.save(operHis);
	}
	
	public List<SiteArea> findAll(){
		return this.siteAreaDao.findByStatus("1");
	}
	public List<SiteArea> findRentingArea(){
		return this.siteAreaDao.findRentingArea();
	}

	public SiteAreaDao getSiteAreaDao() {
		return siteAreaDao;
	}

	public void setSiteAreaDao(SiteAreaDao siteAreaDao) {
		this.siteAreaDao = siteAreaDao;
	}

	public StaffService getStaffService() {
		return staffService;
	}

	public void setStaffService(StaffService staffService) {
		this.staffService = staffService;
	}

	public OperHisDao getOperHisDao() {
		return operHisDao;
	}

	public void setOperHisDao(OperHisDao operHisDao) {
		this.operHisDao = operHisDao;
	}


	public List<SiteArea> listByMarketId(Long marketId) {
		return siteAreaDao.findByMarketId(marketId);
	}
}
