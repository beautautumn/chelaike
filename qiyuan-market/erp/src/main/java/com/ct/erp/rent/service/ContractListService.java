package com.ct.erp.rent.service;

import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.ct.erp.common.exception.ServiceException;
import com.ct.erp.constants.sysconst.Const;
import com.ct.erp.core.security.SecurityUtils;
import com.ct.erp.lib.entity.Agency;
import com.ct.erp.lib.entity.Carport;
import com.ct.erp.lib.entity.ClearingReason;
import com.ct.erp.lib.entity.Contract;
import com.ct.erp.lib.entity.ContractArea;
import com.ct.erp.lib.entity.CycleRecvFee;
import com.ct.erp.lib.entity.OperHis;
import com.ct.erp.lib.entity.Pic;
import com.ct.erp.lib.entity.SiteArea;
import com.ct.erp.lib.entity.Staff;
import com.ct.erp.rent.dao.AgencyDao;
import com.ct.erp.rent.dao.CarportDao;
import com.ct.erp.rent.dao.ClearingReasonDao;
import com.ct.erp.rent.dao.ContractAreaDao;
import com.ct.erp.rent.dao.ContractDao;
import com.ct.erp.rent.dao.CycleRecvFeeDao;
import com.ct.erp.rent.dao.PicDao;
import com.ct.erp.rent.dao.SiteAreaDao;
import com.ct.erp.rent.model.ContractBean;
import com.ct.erp.sys.dao.OperHisDao;
import com.ct.erp.sys.dao.StaffDao;
import com.ct.erp.sys.dao.TodoLogDao;
import com.ct.erp.sys.service.base.StaffService;
import com.ct.erp.util.UcmsWebUtils;

@Service
public class ContractListService {
	@Autowired
	private TodoLogDao todoLogDao;
	@Autowired
	private StaffService staffService;
	@Autowired
	private ContractDao contractDao;
	@Autowired
	private ContractAreaDao contractAreaDao;
	@Autowired
	private SiteAreaDao siteAreaDao;
	@Autowired
	private OperHisDao operHisDao;
	@Autowired
	private AgencyDao agencyDao;
	@Autowired
	private StaffDao staffDao;
	@Autowired
	private ClearingReasonDao clearingReasonDao;
	@Autowired
	private TodoLogDao toDoLogDao;
	@Autowired
	private PicDao picDao;
	@Autowired
    private CarportDao carportDao;
	@Autowired
	private CycleRecvFeeDao cycleRecvFeeDao;
	
	public Contract findById(Long contractId){
		return this.contractDao.findById(contractId);
	}
	
	public List<Staff> findStaffAll(){
		return this.staffDao.findByStatus("1");
	}

	public List<ClearingReason> findReasonAll(){
		return this.clearingReasonDao.findAll();
		
	}
	
	public String getContinueStartDate(Contract contract){
		Date endDate=new Date(contract.getEndDate().getTime());
		Calendar cal = Calendar.getInstance();
		cal.setTime(endDate);
		cal.add(Calendar.DATE, 1);
		return new SimpleDateFormat("yyyy-MM-dd").format(cal.getTime());
	}
	
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = ServiceException.class)
	public void contractContinue(Long contractId,ContractBean contractBean,List<ContractArea> contractAreas,Long picId) throws Exception{
		Agency agency=this.contractDao.get(contractId).getAgency();
		Contract contract=new Contract();
		OperHis operHis=new OperHis();
		contract.setAgency(agency);
		contract.setStartDate(UcmsWebUtils.striToTimestamp(contractBean.getStartDate()));
		contract.setEndDate(UcmsWebUtils.striToTimestamp(contractBean.getEndDate()));
		contract.setRecvCycle(contractBean.getRecvCycle());
		contract.setEveryRecvFee(UcmsWebUtils.yuanTofen(contractBean.getEveryRecvFee()));
		contract.setDepositFee(UcmsWebUtils.yuanTofen(contractBean.getDepositFee()));
//		contract.setSignDate(UcmsWebUtils.striToTimestamp(contractBean.getSignDate()));
		contract.setSignDate(new Timestamp(System.currentTimeMillis()));
		contract.setMarketSignName(contractBean.getMarketSignName());
		contract.setAgencySignName(contractBean.getAgencySignName());
		contract.setRemark(contractBean.getRemark());
		contract.setStaffByCreateStaff(staffService.findStaffById(SecurityUtils.getCurrentSessionInfo().getStaffId()));
		contract.setSignDate(UcmsWebUtils.now());
		contract.setCreateTime(UcmsWebUtils.now());
		contract.setUpdateTime(UcmsWebUtils.now());
		contract.setPayedDepositFee(0);
		contract.setStatus("1");
		contract.setState("101");
		this.contractDao.save(contract);
		
		
		//生成收费记录
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
			
			SiteArea siteArea=this.siteAreaDao.get(contractArea.getSiteArea().getId());
			siteArea.setFreeCount(siteArea.getFreeCount()-contractArea.getLeaseCount());
			this.siteAreaDao.update(siteArea);
			contractArea.setContract(contract);
			contractArea.setSiteArea(siteArea);
			contractArea.setLeaseCount(contractArea.getLeaseCount());
			contractArea.setMonthRentFee(siteArea.getMonthRentFee());
			Double monthTotalFee =contractArea.getMonthRentFee()*contractArea.getLeaseCount();
			contractArea.setMonthTotalFee(monthTotalFee.intValue());
			contractArea.setAreaNo(contractArea.getAreaNo());
			contractArea.setCarCount(contractArea.getCarCount());
			contractArea.setCreateTime(Timestamp.valueOf(new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(contract.getStartDate())));
			contractArea.setUpdateTime(Timestamp.valueOf(new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date())));
			contractArea.setStartDate(contract.getStartDate());
			contractArea.setEndDate(contract.getEndDate());
			contractArea.setStatus("0");
			this.contractAreaDao.save(contractArea);
		}
		operHis.setStaff(staffService.findStaffById(SecurityUtils.getCurrentSessionInfo().getStaffId()));
		operHis.setOperTag("0");
		operHis.setOperTime(Timestamp.valueOf(new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date())));
		operHis.setOperDesc("商户"+agency.getAgencyName()+"续签合同");
		operHis.setOperObj(contract.getId());
		this.operHisDao.save(operHis);
		
		//代办
		todoLogDao.delectTodoLog("rentmanager_contract_list", contractId);
		
		if(picId!=null){
			Pic pic =this.picDao.get(picId);
			pic.setObjId(contractId);
			this.picDao.update(pic);
		}
	}
	

	@SuppressWarnings("unchecked")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = ServiceException.class)
	public void contractChange(Long contractId,ContractBean contractBean,List<ContractArea> contractAreas) throws Exception{
		Contract contract=this.contractDao.get(contractId);
		List<ContractArea> lastContractAreas=new ArrayList<ContractArea>(contract.getContractAreas());
		Agency agency=contract.getAgency();
		OperHis operHis=new OperHis();
		contract.setRecvCycle(contractBean.getRecvCycle());
		contract.setEveryRecvFee(UcmsWebUtils.yuanTofen(contractBean.getEveryRecvFee()));
		contract.setDepositFee(UcmsWebUtils.yuanTofen(contractBean.getDepositFee()));
		contract.setSignDate(new Timestamp(new SimpleDateFormat("yyyy-MM-dd").parse(contractBean.getSignDate()).getTime()));
		contract.setMarketSignName(contractBean.getMarketSignName());
		contract.setAgencySignName(contractBean.getAgencySignName());
		contract.setRemark(contractBean.getRemark());
		contract.setUpdateTime(Timestamp.valueOf(new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date())));
		this.contractDao.update(contract);
		for(ContractArea lastContractArea:lastContractAreas){
			if(!contractAreas.contains(lastContractArea)){
				SiteArea siteArea=this.siteAreaDao.get(lastContractArea.getSiteArea().getId());
				siteArea.setFreeCount(siteArea.getFreeCount()+lastContractArea.getLeaseCount());
				this.siteAreaDao.update(siteArea);
				lastContractArea.setUpdateTime(Timestamp.valueOf(new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date())));
				lastContractArea.setEndDate(Timestamp.valueOf(new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date())));
				this.contractAreaDao.delete(lastContractArea);
			}
			
		}
		for(ContractArea contractArea:contractAreas){
			SiteArea siteArea=this.siteAreaDao.get(contractArea.getSiteArea().getId());
			siteArea.setFreeCount(siteArea.getFreeCount()-contractArea.getLeaseCount());
			this.siteAreaDao.update(siteArea);
			contractArea.setContract(contract);
			contractArea.setSiteArea(siteArea);
			contractArea.setMonthRentFee(siteArea.getMonthRentFee());
			Double monthTotalFee =contractArea.getMonthRentFee()*contractArea.getLeaseCount();
			contractArea.setMonthTotalFee(monthTotalFee.intValue());
			contractArea.setAreaNo(contractArea.getAreaNo());
			contractArea.setCarCount(contractArea.getCarCount());
			contractArea.setCreateTime(Timestamp.valueOf(new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date())));
			contractArea.setUpdateTime(Timestamp.valueOf(new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date())));
			contractArea.setStartDate(contract.getStartDate());
			contractArea.setEndDate(contract.getEndDate());
			this.contractAreaDao.save(contractArea);
		}
		operHis.setStaff(staffService.findStaffById(SecurityUtils.getCurrentSessionInfo().getStaffId()));
		operHis.setOperTag("0");
		operHis.setOperTime(Timestamp.valueOf(new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date())));
		
		switch(Integer.valueOf(agency.getState())){
			case 100:operHis.setOperDesc("退回状态修改合同");break;
		    case 101: operHis.setOperDesc("新签状态修改合同");break;
			case 102: operHis.setOperDesc("待入场状态修改合同");break;
			case 103: operHis.setOperDesc("在场状态修改合同");break;
			case 104: operHis.setOperDesc("待清算状态修改合同");break;
			case 105: operHis.setOperDesc("待离场状态修改合同");break;
			case 106: operHis.setOperDesc("已离场状态修改合同");break;
		}
			
		
		operHis.setOperObj(contract.getId());
		this.operHisDao.save(operHis);
	}
	
	@SuppressWarnings("unchecked")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = ServiceException.class)
	public void contractCount(Long contractId,ContractBean contractBean) throws Exception{
		Contract contract=this.contractDao.get(contractId);
		contract.setClearingReason(this.clearingReasonDao.get(contractBean.getClearingReason().getId()));
		contract.setClearingStartDate(UcmsWebUtils.striToTimestamp(contractBean.getClearingStartDate()));
		contract.setStaffByClearingStartStaff(this.staffDao.get(contractBean.getStaffByClearingStartStaff().getId()));
		contract.setClearingDesc(contractBean.getClearingDesc());
		contract.setState(Const.WAITFOR_END);//设置合同装填为待终止
		contract.setEndReason(Const.ACTIVE_OUT);//设置终止原因为主动终止
		contract.setEndReason(contractBean.getEndReason());
		this.contractDao.update(contract);
		
		
		//获取商户现有车位数情况
		Carport carport =carportDao.findByAgencyId(contract.getAgency().getId());
		
		List<ContractArea> contractAreas=new ArrayList<ContractArea>(contract.getContractAreas());
		Integer num = 0;
		for(ContractArea contractArea:contractAreas){
			num +=contractArea.getCarCount()==null?0:contractArea.getCarCount();
			
			SiteArea siteArea=this.siteAreaDao.get(contractArea.getSiteArea().getId());
			siteArea.setFreeCount(siteArea.getFreeCount()+contractArea.getLeaseCount());
			this.siteAreaDao.update(siteArea);
			contractArea.setUpdateTime(UcmsWebUtils.now());
			contractArea.setEndDate(UcmsWebUtils.now());
			contractArea.setStatus("0");
			this.contractAreaDao.update(contractArea);
		}
		if(num <= (carport.getTotalNum()-carport.getUsedNum())){
			//更新商户车位表的车位数
			carport.setTotalNum(carport.getTotalNum()-num);
			carport.setUnusedNum(carport.getUnusedNum()-num);
			carportDao.update(carport);
		}else{
			throw new ServiceException("请先释放已占用车位再进行清算！");
		}
		
		OperHis operHis=new OperHis();
		operHis.setStaff(staffService.findStaffById(SecurityUtils.getCurrentSessionInfo().getStaffId()));
		operHis.setOperTag("0");
		operHis.setOperTime(UcmsWebUtils.now());
		
		Agency agency=contract.getAgency();
		
		operHis.setOperDesc("商户"+agency.getAgencyName()+"主动发起清算合同," +
				"发起清算原因是："+contract.getClearingReason().getName()+",发起清算的具体描述是："+contract.getClearingDesc());
	
		operHis.setOperObj(contractId);
		this.operHisDao.save(operHis);
		
		this.toDoLogDao.delectTodoLog("rentmanager_contract_list",contract.getId());
		this.toDoLogDao.delectTodoLog("rentmanager_contract_rec",contract.getId());
		
		
		/*List<Contract> contractAgencys=this.contractDao.findCurrentByAgencyname(agency.getAgencyName());
		if(contractAgencys==null||contractAgencys.size()==0){
			OperHis operHisAgency=new OperHis();
			operHisAgency.setStaff(staffService.findStaffById(SecurityUtils.getCurrentSessionInfo().getStaffId()));
			operHisAgency.setOperObj(agency.getId());
			operHisAgency.setOperTag("2");
			operHisAgency.setOperTime(UcmsWebUtils.now());
			switch(Integer.valueOf(agency.getState())){
				case 102:agency.setState("105");
						 operHisAgency.setOperDesc("商户"+agency.getAgencyName()+"主动发起清算后，由于该商户没有已生效合同或者待生效合同，商户状态由待入场变为待离场");
						 break;//待入场就变为待离场
				case 103:agency.setState("104");
						 operHisAgency.setOperDesc("由于商户"+agency.getAgencyName()+"主动发起清算后，由于该商户没有已生效合同或者待生效合同，商户状态由在场状态变为待清算");
						 break;//在场状态变为待清算
			}
			agency.setClearingStartDate(UcmsWebUtils.now());
			this.agencyDao.update(agency);
			this.operHisDao.save(operHisAgency);
		}*/
	}

	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = ServiceException.class)
	public void contractResign(Long contractId,ContractBean contractBean,List<ContractArea> contractAreas) throws Exception{
		Agency agency=this.contractDao.get(contractId).getAgency();
		Contract contract=new Contract();
		OperHis operHis=new OperHis();
		contract.setAgency(agency);
		contract.setEndDate(new Timestamp(new SimpleDateFormat("yyyy-MM-dd").parse(contractBean.getEndDate()).getTime()));
		contract.setStartDate(new Timestamp(new SimpleDateFormat("yyyy-MM-dd").parse(contractBean.getStartDate()).getTime()));
		contract.setRecvCycle(contractBean.getRecvCycle());
		contract.setEveryRecvFee(UcmsWebUtils.yuanTofen(contractBean.getEveryRecvFee()));
		contract.setDepositFee(UcmsWebUtils.yuanTofen(contractBean.getDepositFee()));
		contract.setSignDate(new Timestamp(new SimpleDateFormat("yyyy-MM-dd").parse(contractBean.getSignDate()).getTime()));
		contract.setMarketSignName(contractBean.getMarketSignName());
		contract.setAgencySignName(contractBean.getAgencySignName());
		contract.setRemark(contractBean.getRemark());
		contract.setStaffByCreateStaff(staffService.findStaffById(SecurityUtils.getCurrentSessionInfo().getStaffId()));
		contract.setCreateTime(Timestamp.valueOf(new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date())));
		contract.setUpdateTime(Timestamp.valueOf(new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date())));
		contract.setStatus("1");
		contract.setState("102");
		this.contractDao.save(contract);
		for(ContractArea contractArea:contractAreas){
			SiteArea siteArea=this.siteAreaDao.get(contractArea.getSiteArea().getId());
			siteArea.setFreeCount(siteArea.getFreeCount()-contractArea.getLeaseCount());
			this.siteAreaDao.update(siteArea);
			contractArea.setContract(contract);
			contractArea.setSiteArea(siteArea);
			contractArea.setMonthRentFee(siteArea.getMonthRentFee());
      Double monthTotalFee =contractArea.getMonthRentFee()*contractArea.getLeaseCount();
      contractArea.setMonthTotalFee(monthTotalFee.intValue());
			contractArea.setAreaNo(contractArea.getAreaNo());
			contractArea.setCarCount(contractArea.getCarCount());
			contractArea.setCreateTime(Timestamp.valueOf(new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date())));
			contractArea.setUpdateTime(Timestamp.valueOf(new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date())));
			contractArea.setStartDate(contract.getStartDate());
			contractArea.setEndDate(contract.getEndDate());
			this.contractAreaDao.save(contractArea);
		}
		operHis.setStaff(staffService.findStaffById(SecurityUtils.getCurrentSessionInfo().getStaffId()));
		operHis.setOperTag("0");
		operHis.setOperTime(Timestamp.valueOf(new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date())));
		switch(Integer.valueOf(agency.getState())){
			case 100:operHis.setOperDesc("退回状态重新签订合同");break;
		    case 101: operHis.setOperDesc("新签状态重新签订合同");break;
			case 102: operHis.setOperDesc("待入场状态重新签订合同");break;
			case 103: operHis.setOperDesc("在场状态重新签订合同");break;
			case 104: operHis.setOperDesc("待清算状态重新签订合同");break;
			case 105: operHis.setOperDesc("待离场状态重新签订合同");break;
			case 106: operHis.setOperDesc("已离场状态重新签订合同");break;
		}
		agency.setState("103");
		this.agencyDao.update(agency);
		operHis.setOperObj(contract.getId());
		this.operHisDao.save(operHis);
	}
	
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = ServiceException.class)
	public String addContract(ContractBean contractBean,List<ContractArea> contractAreas,Long picId) throws Exception {
		Agency agency=this.agencyDao.findByIdWithStatus(Long.valueOf(contractBean.getAgencyId()));
		if(!StringUtils.equals(agency.getState(),"1")){
			return "保存失败,该商户已经失效!";
		}
		Contract oldCon = this.contractDao.findById(contractBean.getId());
		Contract contract;
		OperHis operHis=new OperHis();
		String operType = "";
		if(oldCon == null){
			operType = "0";
			contract=contractBean.getContract();
			contract.setAgency(agency);
			contract.setEndDate(UcmsWebUtils.striToTimestamp(contractBean.getEndDate()));
			contract.setStartDate(UcmsWebUtils.striToTimestamp(contractBean.getStartDate()));
			contract.setRecvCycle(contractBean.getRecvCycle());
			contract.setEveryRecvFee(UcmsWebUtils.yuanTofen(contractBean.getEveryRecvFee()));
			contract.setDepositFee(UcmsWebUtils.yuanTofen(contractBean.getDepositFee()));
//			contract.setSignDate(UcmsWebUtils.striToTimestamp(contractBean.getSignDate()));
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
			
			//生成收费记录
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
		}else{
			operType = "1";
			contract=oldCon;
			contract.setAgency(agency);
			contract.setEndDate(UcmsWebUtils.striToTimestamp(contractBean.getEndDate()));
			contract.setStartDate(UcmsWebUtils.striToTimestamp(contractBean.getStartDate()));
			contract.setRecvCycle(contractBean.getRecvCycle());
			contract.setEveryRecvFee(UcmsWebUtils.yuanTofen(contractBean.getEveryRecvFee()));
			contract.setDepositFee(UcmsWebUtils.yuanTofen(contractBean.getDepositFee()));
			contract.setSignDate(UcmsWebUtils.striToTimestamp(contractBean.getSignDate()));
			contract.setMarketSignName(contractBean.getMarketSignName());
			contract.setAgencySignName(contractBean.getAgencySignName());
			contract.setRemark(contractBean.getRemark());
			contract.setStaffByCreateStaff(staffService.findStaffById(SecurityUtils.getCurrentSessionInfo().getStaffId()));
			contract.setUpdateTime(UcmsWebUtils.now());
			contract.setPayedDepositFee(0);
			contract.setEndReason("");
			contract.setStatus("1");
			contract.setState("101");
			this.contractDao.update(contract);
			
			List<CycleRecvFee> list = this.cycleRecvFeeDao.findByProperty("contract.id", contract.getId());
			for(CycleRecvFee c : list){
				this.cycleRecvFeeDao.delete(c);
			}
			
			//生成收费记录
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
		}
		
//		//获取商户现有车位数情况
//		Carport carport =carportDao.findByAgencyId(agency.getId());
//		//如果是新签订的客户就在商户车位表里初始化该商户的车位数据
//		if(carport==null)
//		{
//			carport = new Carport();
//			carport.setAgency(agency);
//			carport.setTotalNum(0);
//			carport.setUnusedNum(0);
//			carport.setUsedNum(0);
//			carport = carportDao.save(carport);
//		}
				
		List<ContractArea> areas = this.contractAreaDao.findByProperty("contract.id", contract.getId());
		
		for(ContractArea area : areas){
			boolean flag = true;
			for(ContractArea cArea : contractAreas){
				if(cArea.getId() != null && area.getId().longValue() == cArea.getId().longValue()){
					flag = false;
					break;
				}
			}
			if(flag){
				SiteArea siteArea=this.siteAreaDao.get(area.getSiteArea().getId());
				siteArea.setFreeCount(siteArea.getFreeCount()+area.getLeaseCount());
				this.siteAreaDao.update(siteArea);
				this.contractAreaDao.delete(area);
			}
		}
		for(ContractArea contractArea:contractAreas){
			/*boolean flag = false;
			for(ContractArea carea : areas){
				if(contractArea.getId() != null && carea.getId().longValue() == contractArea.getId()){
					flag = true;
					break;
				}
			}
			
			if(flag){
				continue;
			}*/
//			contractArea.setId(null);
			if(contractArea.getId() == null){
				//更新商户车位表的车位数
//				Integer num =contractArea.getCarCount()==null?0:contractArea.getCarCount();
//				carport.setTotalNum(carport.getTotalNum()+num);
//				carport.setUnusedNum(carport.getUnusedNum()+num);
//				carportDao.update(carport);
				
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
				contractArea.setStartDate(UcmsWebUtils.dateToTimestamp(contract.getStartDate()));
				contractArea.setEndDate(UcmsWebUtils.dateToTimestamp(contract.getEndDate()));
				contractArea.setStatus("0");
				contractArea.setUpdateTime(UcmsWebUtils.now());
				this.contractAreaDao.save(contractArea);
			}else{
				contractArea.setId(null);
				SiteArea siteArea=this.siteAreaDao.get(contractArea.getSiteArea().getId());
//				siteArea.setFreeCount(siteArea.getFreeCount()-contractArea.getLeaseCount());
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
				contractArea.setStartDate(UcmsWebUtils.dateToTimestamp(contract.getStartDate()));
				contractArea.setEndDate(UcmsWebUtils.dateToTimestamp(contract.getEndDate()));
				contractArea.setStatus("0");
				contractArea.setUpdateTime(UcmsWebUtils.now());
				this.contractAreaDao.save(contractArea);
			}
			
		}
		operHis.setStaff(staffService.findStaffById(SecurityUtils.getCurrentSessionInfo().getStaffId()));
		operHis.setOperTag("0");
		operHis.setOperTime(UcmsWebUtils.now());
		if(operType.equals("0")){
			operHis.setOperDesc("商户"+agency.getAgencyName()+"新签商铺合同");
		}else{
			operHis.setOperDesc("商户"+agency.getAgencyName()+"修改商铺合同");
		}
		
		switch(Integer.valueOf(agency.getState())){
			case 103: agency.setState("103");break;
			case 101: agency.setState("102");break;
			case 106: agency.setState("102");break;
		}
		
		this.agencyDao.update(agency);
		operHis.setOperObj(contract.getId());
		this.operHisDao.save(operHis);
		
		if(picId!=null){
			Pic pic =this.picDao.get(picId);
			pic.setObjId(contract.getId());
			this.picDao.update(pic);
		}

		return "success";
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

	public List<ClearingReason> findAgencyReason() {
		
		return this.clearingReasonDao.findAgencyReason();
	}
	
	
	
}
