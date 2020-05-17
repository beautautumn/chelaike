package com.ct.erp.rent.service;

import java.sql.Timestamp;
import java.util.Date;
import java.util.Set;

import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.ct.erp.common.exception.ServiceException;
import com.ct.erp.constants.sysconst.Const;
import com.ct.erp.lib.entity.Agency;
import com.ct.erp.lib.entity.AgencyBills;
import com.ct.erp.lib.entity.Carport;
import com.ct.erp.lib.entity.Contract;
import com.ct.erp.lib.entity.ContractArea;
import com.ct.erp.lib.entity.CycleRecvFee;
import com.ct.erp.lib.entity.CycleRecvFeeRecord;
import com.ct.erp.lib.entity.RecvFee;
import com.ct.erp.rent.dao.AgencyBillsDao;
import com.ct.erp.rent.dao.AgencyDao;
import com.ct.erp.rent.dao.CarportDao;
import com.ct.erp.rent.dao.ContractAreaDao;
import com.ct.erp.rent.dao.ContractDao;
import com.ct.erp.rent.dao.CycleRecvFeeDao;
import com.ct.erp.rent.dao.CycleRecvFeeRecordDao;
import com.ct.erp.rent.dao.RecvFeeDao;
import com.ct.erp.rent.model.RecvFeeBean;
import com.ct.erp.sys.dao.OperHisDao;
import com.ct.erp.sys.dao.StaffDao;
import com.ct.erp.sys.dao.TodoLogDao;
import com.ct.erp.util.UcmsWebUtils;

@Service
public class RecvFeeService {
	@Autowired
	private RecvFeeDao recvFeeDao;
	@Autowired
	private StaffDao staffDao;
	@Autowired
	private OperHisDao operHisDao;
	@Autowired
	private ContractDao contractDao;
	@Autowired
	private AgencyDao agencyDao;
	@Autowired
	private ContractAreaDao contractAreaDao;
	@Autowired
	private AgencyBillsDao agencyBillsDao;
	@Autowired
	private TodoLogDao todoLogDao;
	@Autowired
	private CycleRecvFeeDao cycleRecvFeeDao;
	@Autowired
	private CycleRecvFeeRecordDao cycleRecvFeeRecordDao;
	@Autowired
	private CarportDao carportDao;
	@Autowired
	private CarportService carportService;
	
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = ServiceException.class)
	public void save(RecvFeeBean recvFeeBean,Long contractId) throws Exception{
		RecvFee recvFee = recvFeeBean.getRecvFeeb();
		recvFee.setStaff(staffDao.findById(recvFeeBean.getStaffId()));
		recvFee.setContract(contractDao.findById(contractId));
		recvFee.setCreateTime(new Timestamp(new Date().getTime()));
		recvFee.setUpdateTime(recvFee.getCreateTime());
		//设置收款类型0-普通收费，1-为其他收费
		if(recvFee.getRecvDepositFee()==null){
			recvFee.setRecvType("1");
		}else{
			recvFee.setRecvType("0");
		}
		recvFee = recvFeeDao.save(recvFee);
		//收款后更改合同状态
		Contract contract = recvFee.getContract();
		if(!contract.getState().equals("102")){
			contract.setState("102");
		}
		//累加押金
		if(recvFee.getRecvType().equals("0")&&recvFee.getRecvDepositFee()!=null&&recvFee.getRecvDepositFee()>0){
			contract.setPayedDepositFee((contract.getPayedDepositFee()==null? 0:contract.getPayedDepositFee()) +recvFee.getRecvDepositFee());
		}
		contract.setUpdateTime(new Timestamp(new Date().getTime()));
		contractDao.update(contract);
		//更改合同区域状态
		Set<ContractArea> contractAreas = contract.getContractAreas();
		for(ContractArea cas : contractAreas){
			cas.setStatus("1");
			contractAreaDao.update(cas);
		}
		//新商户收款后更改状态
		Agency agency = contract.getAgency();
		//合同收款--->若商户不是在场状态，则改变商户状态（在场（103）
		if(!agency.getState().equals("103")){
			agency.setState("103");
		}
		if(recvFee.getRecvDepositFee()!=null){
/*			agency.setTotalDepositFee((agency.getTotalDepositFee()==null ? 0:agency.getTotalDepositFee())+recvFee.getRecvDepositFee());*/
			//合同收款删除待办提醒
			todoLogDao.delectTodoLog("rentmanager_contract_rec", contract.getId());
		}
		agency.setUpdateTime(new Timestamp(new Date().getTime()));
		agencyDao.update(agency);
		//添加一条商户总账单
		AgencyBills agencyBills = agencyBillsDao.findByAgencyId(agency.getId(), "0");
		if(agencyBills==null){
			agencyBills = new AgencyBills();
			agencyBills.setAgency(agency);
			agencyBills.setFeeValue(0);
			agencyBills.setShareTotalFee(0);
			agencyBills.setIndependentTotalFee(0);
			agencyBills.setState("0");
			agencyBillsDao.save(agencyBills);
		}
		//插入操作记录
		String operDesc = "";
		if(recvFee.getRecvType().equals("0")){
			operDesc = "合同收款，实收款："+recvFeeBean.getRecvFee()+",实收押金："+recvFeeBean.getRecvDepositFee();
		}else{
			operDesc = "收其他费用，实收款："+recvFeeBean.getRecvFee();
			contract.setOtherRecvFee(0);
			contract.setOtherFeeDesc("");
			contractDao.update(contract);
		}
		operHisDao.createNewOperHis(recvFee.getContract().getId(),"0",operDesc);
	}

	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = ServiceException.class)
	public void saveCycleRecvFee(RecvFeeBean recvFeeBean, Long contractId) {
		CycleRecvFee cycle = this.cycleRecvFeeDao.get(recvFeeBean.getCycleId());
		cycle.setUpdateTime(UcmsWebUtils.now());
		cycle.setRecvFee(cycle.getRecvFee() == null ? UcmsWebUtils.yuanTofen(recvFeeBean.getRecvFee()) : 
		cycle.getRecvFee()+UcmsWebUtils.yuanTofen(recvFeeBean.getRecvFee()));
		if(cycle.getRecvFee()<cycle.getPlanCollectionFee()){
			cycle.setState(Const.COLLECTING);
		}else{
			cycle.setState(Const.COLLECTED);
		}
		//累加押金
		cycle.setRecvDeposit(cycle.getRecvDeposit() == null ? UcmsWebUtils.yuanTofen(recvFeeBean.getRecvDepositFee()) : 
			cycle.getRecvDeposit()+UcmsWebUtils.yuanTofen(recvFeeBean.getRecvDepositFee()));
		//设置收款类型0-普通收费，1-为其他收费
		this.cycleRecvFeeDao.update(cycle);
		
		
				
		Contract contract = cycle.getContract();
		/*if(!contract.getState().equals(Const.WORKING)){
			contract.setState(Const.WORKING);
		}*/
		//累加押金
		if(StringUtils.isNotEmpty(recvFeeBean.getRecvDepositFee())){
			contract.setPayedDepositFee(contract.getPayedDepositFee() == null ? UcmsWebUtils.yuanTofen(recvFeeBean.getRecvDepositFee()) : contract.getPayedDepositFee()+UcmsWebUtils.yuanTofen(recvFeeBean.getRecvDepositFee()));
		}
		contract.setUpdateTime(new Timestamp(new Date().getTime()));
		/*contractDao.update(contract);*/
		
		
		//保存收款记录
		CycleRecvFeeRecord record = new CycleRecvFeeRecord();
		record.setStaff(this.staffDao.get(recvFeeBean.getStaffId()));
		record.setCollectionDate(new Date());
		record.setContract(cycle.getContract());
		record.setCreateTime(UcmsWebUtils.now());
		record.setCycleRecvFee(cycle);
		record.setRecvDeposit(UcmsWebUtils.yuanTofen(recvFeeBean.getRecvDepositFee()));
		record.setRecvFee(UcmsWebUtils.yuanTofen(recvFeeBean.getRecvFee()));
		record.setRemark(recvFeeBean.getRemark());
		record.setUpdateTime(UcmsWebUtils.now());
		this.cycleRecvFeeRecordDao.save(record);
		
		//新商户收款后更改状态
		Agency agency = contract.getAgency();
		//合同收款--->若商户不是在场状态，则改变商户状态（在场（103）
		if(!agency.getState().equals(Const.ALREADY_IN)){
			agency.setState(Const.ALREADY_IN);
		}
		if(StringUtils.isNotEmpty(recvFeeBean.getRecvDepositFee())){
			//合同收款删除待办提醒
			todoLogDao.delectTodoLog("rentmanager_contract_rec", contract.getId());
		}
		agency.setUpdateTime(new Timestamp(new Date().getTime()));
		agencyDao.update(agency);
		//添加一条商户总账单
		AgencyBills agencyBills = agencyBillsDao.findByAgencyId(agency.getId(), "0");
		if(agencyBills==null){
			agencyBills = new AgencyBills();
			agencyBills.setAgency(agency);
			agencyBills.setFeeValue(0);
			agencyBills.setShareTotalFee(0);
			agencyBills.setIndependentTotalFee(0);
			agencyBills.setState("0");
			agencyBillsDao.save(agencyBills);
		}
		
		
		//更改合同区域状态
		Integer num = 0;
		if((contract.getWorkingTag() == null || !contract.getWorkingTag().equals("1")) && !contract.getState().equals(Const.WORKING)){
			Set<ContractArea> contractAreas = contract.getContractAreas();
			for(ContractArea cas : contractAreas){
				num += cas.getCarCount()==null?0:cas.getCarCount();
				cas.setStatus("1");
				contractAreaDao.update(cas);
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
			
			this.carportService.updateCarport(carport, num);
		}
		//收款后更改合同状态
		if(!contract.getState().equals(Const.WORKING)){
			contract.setState(Const.WORKING);
		}
		contractDao.update(contract);
		
		
		//插入操作记录
		String operDesc = "";
		operDesc = "合同收款，实收款："+recvFeeBean.getRecvFee()+",实收押金："+recvFeeBean.getRecvDepositFee();
		operHisDao.createNewOperHis(contract.getId(),"0",operDesc);
		
	}
}
