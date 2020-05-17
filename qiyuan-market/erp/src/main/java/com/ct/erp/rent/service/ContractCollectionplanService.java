package com.ct.erp.rent.service;

import java.util.Date;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.ct.erp.common.exception.ServiceException;
import com.ct.erp.constants.sysconst.Const;
import com.ct.erp.core.security.SecurityUtils;
import com.ct.erp.lib.entity.ContractCollectionPlan;
import com.ct.erp.lib.entity.ContractCollectionRecord;
import com.ct.erp.lib.entity.OperHis;
import com.ct.erp.lib.entity.ShopContract;
import com.ct.erp.lib.entity.Staff;
import com.ct.erp.rent.dao.ContractCollectionPlanDao;
import com.ct.erp.rent.dao.ContractCollectionRecordDao;
import com.ct.erp.rent.dao.ShopContractDao;
import com.ct.erp.rent.model.ContractCollectionPlanBean;
import com.ct.erp.sys.dao.OperHisDao;
import com.ct.erp.sys.dao.StaffDao;
import com.ct.erp.util.UcmsWebUtils;

@Service
public class ContractCollectionplanService {
	
	@Autowired
	private ContractCollectionPlanDao contractCollectionPlanDao;
	@Autowired
	private ShopContractDao shopContractDao;
	@Autowired
	private StaffDao staffDao;
	@Autowired
	private ContractCollectionRecordDao collectionRecordDao;
	@Autowired
	private OperHisDao operHisDao;

	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = ServiceException.class)
	public void collection(
			ContractCollectionPlanBean contractCollectionPlanBean,
			Long shopContractId) {
		ShopContract shopContract = this.shopContractDao.get(shopContractId);
		Staff staff = this.staffDao.get(SecurityUtils.getCurrentSessionInfo().getStaffId());
		ContractCollectionPlan plan = this.contractCollectionPlanDao.get(contractCollectionPlanBean.getPlanId());
		//保存收款记录
		ContractCollectionRecord record = new ContractCollectionRecord();
		record.setCollectionDate(new Date());
		record.setContractCollectionPlan(plan);
		record.setCreateTime(UcmsWebUtils.now());
		record.setUpdateTime(UcmsWebUtils.now());
		record.setRecvDeposit(UcmsWebUtils.yuanTofen(contractCollectionPlanBean.getRecvDepositFee()));
		record.setRecvFee(UcmsWebUtils.yuanTofen(contractCollectionPlanBean.getRecvFee()));
		record.setRemark(contractCollectionPlanBean.getRemark());
		record.setShopContract(shopContract);
		record.setStaff(staff);
		this.collectionRecordDao.save(record);
		
		plan.setUpdateTime(UcmsWebUtils.now());
		plan.setRecvDeposit(plan.getRecvDeposit() == null ? record.getRecvDeposit() : 
			plan.getRecvDeposit()+record.getRecvDeposit());
		plan.setRecvFee(plan.getRecvFee() == null ? record.getRecvFee() : 
			plan.getRecvFee()+record.getRecvFee());
		if(plan.getRecvDeposit()>=plan.getPlanCollectionDeposit() && plan.getRecvFee()>=plan.getPlanCollectionFee()){
			plan.setState(Const.COLLECTED);
		}else{
			plan.setState(Const.COLLECTING);
		}
		this.contractCollectionPlanDao.update(plan);
		shopContract.setState(Const.WORKING);
		
		OperHis operHis=new OperHis();
		operHis.setStaff(staff);
		operHis.setOperTag(Const.SHOP_CONTRACT);
		operHis.setOperTime(UcmsWebUtils.now());
		operHis.setOperDesc("合同收款，实收款："+record.getRecvFee()/100+"，实收押金："+record.getRecvFee()/100);
		operHis.setOperObj(shopContract.getId());
		this.operHisDao.save(operHis);
		
	}

	public List<ContractCollectionPlan> findByShopContractId(Long shopContractId) {
		return this.contractCollectionPlanDao.findByProperty("shopContract.id", shopContractId);
	}
	
	

}
