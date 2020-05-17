package com.ct.erp.rent.service;

import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.ct.erp.common.exception.ServiceException;
import com.ct.erp.core.security.SecurityUtils;
import com.ct.erp.lib.entity.Agency;
import com.ct.erp.lib.entity.Carport;
import com.ct.erp.lib.entity.Contract;
import com.ct.erp.lib.entity.ContractArea;
import com.ct.erp.lib.entity.CycleRecvFee;
import com.ct.erp.lib.entity.OperHis;
import com.ct.erp.lib.entity.Pic;
import com.ct.erp.lib.entity.SiteArea;
import com.ct.erp.rent.dao.AgencyDao;
import com.ct.erp.rent.dao.CarportDao;
import com.ct.erp.rent.dao.ContractAreaDao;
import com.ct.erp.rent.dao.ContractDao;
import com.ct.erp.rent.dao.CycleRecvFeeDao;
import com.ct.erp.rent.dao.PicDao;
import com.ct.erp.rent.dao.SiteAreaDao;
import com.ct.erp.rent.model.ContractBean;
import com.ct.erp.sys.dao.OperHisDao;
import com.ct.erp.sys.service.base.StaffService;
import com.ct.erp.util.UcmsWebUtils;

@Service
public class ContractSignService {
	
	@Autowired
	private AgencyDao agencyDao;
	@Autowired
	private StaffService staffService;
	@Autowired
	private SiteAreaDao siteAreaDao;
	@Autowired
	private ContractAreaDao contractAreaDao;
	@Autowired
	private ContractDao contractDao;
	@Autowired
	private OperHisDao operHisDao;
	@Autowired
	private PicDao picDao;
    @Autowired
    private CarportDao carportDao;
    @Autowired
    private CycleRecvFeeDao cycleRecvFeeDao;
	
	
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = ServiceException.class)
	public void contractSignReg(ContractBean contractBean,List<ContractArea> contractAreas,Long picId) throws Exception{
		
		Agency agency=this.agencyDao.findById(Long.valueOf(contractBean.getAgencyId()));
		Contract contract=contractBean.getContract();
		OperHis operHis=new OperHis();
		OperHis operHisAgency=new OperHis();
		contract.setAgency(agency);
		contract.setEndDate(UcmsWebUtils.striToTimestamp(contractBean.getEndDate()));
		contract.setStartDate(UcmsWebUtils.striToTimestamp(contractBean.getStartDate()));
		contract.setRecvCycle(contractBean.getRecvCycle());
		contract.setEveryRecvFee(UcmsWebUtils.yuanTofen(contractBean.getEveryRecvFee()));
		contract.setDepositFee(UcmsWebUtils.yuanTofen(contractBean.getDepositFee()));
//		contract.setSignDate(UcmsWebUtils.striToTimestamp(contractBean.getSignDate()));
		contract.setSignDate(new Timestamp(System.currentTimeMillis()));
		contract.setMarketSignName(contractBean.getMarketSignName());
		contract.setAgencySignName(contractBean.getAgencySignName());
		contract.setRemark(contractBean.getRemark());
		contract.setStaffByCreateStaff(staffService.findStaffById(SecurityUtils.getCurrentSessionInfo().getStaffId()));
		contract.setCreateTime(UcmsWebUtils.now());
		contract.setUpdateTime(UcmsWebUtils.now());
		contract.setPayedDepositFee(0);
		contract.setStatus("1");
		contract.setState("101");
		contract=this.contractDao.save(contract);
		
		
		int months = UcmsWebUtils.getMonths(contractBean.getStartDate(), contractBean.getEndDate());
		int cycle = 0;
		int cycleCount = 3;
		if(("0").equals(contract.getRecvCycle())){
			cycleCount = 3;
			cycle = UcmsWebUtils.getFeeNums(months,cycleCount);
		}else if(("1").equals(contract.getRecvCycle())){
			cycleCount = 6;
			cycle = UcmsWebUtils.getFeeNums(months,cycleCount);
		}else if(("2").equals(contract.getRecvCycle())){
			cycleCount = 12;
			cycle = UcmsWebUtils.getFeeNums(months,cycleCount);
		}
		
		for(int i = 0 ; i < cycle ; i++){
			Date shellRecvDate = null;
			Calendar cal = Calendar.getInstance();
			cal.setTime(UcmsWebUtils.stringToDate(contractBean.getStartDate()));
			cal.add(Calendar.MONTH, i*cycleCount);
			shellRecvDate = cal.getTime();//设定收款日期
			
			int shellRecvFee = 0;
			if(i<cycle-1){
				shellRecvFee = UcmsWebUtils.yuanTofen(contractBean.getMonthTotalFeeAll())*cycleCount;
			}else{
				int ms = UcmsWebUtils.getMonths(UcmsWebUtils.dateTOStr(shellRecvDate), contractBean.getEndDate());
				shellRecvFee = UcmsWebUtils.yuanTofen(contractBean.getMonthTotalFeeAll())*ms;
			}
			
			CycleRecvFee crf = new CycleRecvFee();
			crf.setContract(contract);//合同
			crf.setCreateTime(UcmsWebUtils.now());//创建时间
			crf.setPlanCollectionDate(shellRecvDate);//应收款日期
			crf.setPlanCollectionFee(shellRecvFee);//应收金额
			crf.setPlanCollectionDeposit(i == 0 ? UcmsWebUtils.yuanTofen(contractBean.getDepositFee()) : 0);//应收押金
			this.cycleRecvFeeDao.save(crf);
		}
		
		//获取商户现有车位数情况
		Carport carport =carportDao.findByAgencyId(agency.getId());
		//如果是新签订的客户就在商户车位表里初始化该商户的车位数据
		if(carport==null)
		{
			carport = new Carport();
			carport.setAgency(agency);
			carport.setTotalNum(0);
			carport.setUnusedNum(0);
			carport.setUsedNum(0);
			carport = carportDao.save(carport);
		}
		
		for(ContractArea contractArea:contractAreas){
			//更新商户车位表的车位数
			Integer num =contractArea.getCarCount()==null?0:contractArea.getCarCount();
			carport.setTotalNum(carport.getTotalNum()+num);
			carport.setUnusedNum(carport.getUnusedNum()+num);
			carportDao.update(carport);
			
			//更新合同去区域表的区域信息
			SiteArea siteArea=this.siteAreaDao.get(contractArea.getSiteArea().getId());
			siteArea.setFreeCount(siteArea.getFreeCount()-contractArea.getLeaseCount());
			this.siteAreaDao.update(siteArea);
			contractArea.setContract(contract);
			contractArea.setSiteArea(siteArea);
			contractArea.setMonthRentFee(siteArea.getMonthRentFee());
			contractArea.setLeaseCount(contractArea.getLeaseCount());
		    Double monthTotalFee =contractArea.getMonthRentFee()*contractArea.getLeaseCount();
		    contractArea.setMonthTotalFee(monthTotalFee.intValue());
		    contractArea.setAreaNo(contractArea.getAreaNo());
			contractArea.setCarCount(contractArea.getCarCount());
			contractArea.setCreateTime(UcmsWebUtils.now());
			contractArea.setStartDate(contract.getStartDate());
			contractArea.setEndDate(contract.getEndDate());
			contractArea.setStatus("0");
			contractArea.setUpdateTime(UcmsWebUtils.now());
			this.contractAreaDao.save(contractArea);
		}
		operHis.setStaff(staffService.findStaffById(SecurityUtils.getCurrentSessionInfo().getStaffId()));
		operHis.setOperTag("0");
		operHis.setOperTime(UcmsWebUtils.now());
		
		operHisAgency.setStaff(staffService.findStaffById(SecurityUtils.getCurrentSessionInfo().getStaffId()));
		operHisAgency.setOperTag("2");
		operHisAgency.setOperTime(UcmsWebUtils.now());
		operHis.setOperDesc("商户"+agency.getAgencyName()+"签订合同");
		
		switch(Integer.valueOf(agency.getState())){
		case 103: agency.setState("103");
				  operHisAgency.setOperDesc("商户"+agency.getAgencyName()+"签订合同，商户状态：在场状态");
				  break;
		case 101: agency.setState("102");
				  operHisAgency.setOperDesc("商户"+agency.getAgencyName()+"签订合同，商户状态由待签状态变为待入场状态");
				  break;
		case 106: agency.setState("102");
				  operHisAgency.setOperDesc("商户"+agency.getAgencyName()+"签订合同，商户状态由已离场状态变为待入场状态");
				  break;
		}
		
		this.agencyDao.update(agency);
		operHis.setOperObj(contract.getId());
		operHisAgency.setOperObj(agency.getId());
		this.operHisDao.save(operHis);
		this.operHisDao.save(operHisAgency);
		if(picId!=null){
			Pic pic=this.picDao.get(picId);
			pic.setObjId(contract.getId());
			this.picDao.update(pic);
		}
	}

	public List<SiteArea> getSiteArea(String currentSiteAreas) {
		if(!(currentSiteAreas==null||currentSiteAreas.trim().length()==0)){
			String[] arr=currentSiteAreas.split(",");
			List<String> current=new ArrayList<String>();
			for(String currentSiteAreaId:arr){
				if(!(currentSiteAreaId==null||currentSiteAreaId.trim().length()==0)){
					current.add(currentSiteAreaId);
				}
			}
			return this.siteAreaDao.findByCondition(current);
		}else{
			return this.siteAreaDao.findByCondition(null);
		}
	}


	public List<SiteArea> getSiteAreaByMarket(Long marketId) {
		return this.siteAreaDao.findByMarketIdFull(marketId);
	}
}
