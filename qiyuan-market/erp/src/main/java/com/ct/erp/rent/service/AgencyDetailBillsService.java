package com.ct.erp.rent.service;

import java.sql.Timestamp;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.ct.erp.common.exception.ServiceException;
import com.ct.erp.lib.entity.AgencyBills;
import com.ct.erp.lib.entity.AgencyDetailBills;
import com.ct.erp.rent.dao.AgencyBillsDao;
import com.ct.erp.rent.dao.AgencyDetailBillsDao;
import com.ct.erp.sys.dao.StaffDao;
import com.ct.erp.util.UcmsWebUtils;
@Service
public class AgencyDetailBillsService {
	@Autowired
	private AgencyDetailBillsDao agencyDetailBillsDao;
	@Autowired
	private AgencyBillsDao agencyBillsdao;
	@Autowired
	private StaffDao staffDao;
	/**
	 * 查看
	 * @param AgencyBillsId
	 * @param feeType
	 * @return
	 */
	public List<AgencyDetailBills> findAgencyDetailBillsByAgencyBillsId(
						String AgencyBillsId,String feeType){
		return this.agencyDetailBillsDao.findAgencyDetailBillsByAgencyBillsId(AgencyBillsId,feeType);
	}
	
	public List<AgencyDetailBills> findAgencyDetailBillsByAgencyId(String agencyId){
		return this.agencyDetailBillsDao.findAgencyDetailBillsByAgencyId(agencyId);
	}
	
	/**
	 * 修改账单
	 * @param AgencyBillsId
	 */
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = ServiceException.class)
	public void collectFees (String AgencyBillsId,String recvFee,
							String recvTime,String staffId,String remark/*,String deduction*/) throws Exception{
		try {
			String operDesc = "";
			AgencyBills agencyBill = agencyBillsdao.get(Long.parseLong(AgencyBillsId));
			/*if(deduction.equals("true")){
				Integer  totalDepositFee  = agencyBill.getAgency().getTotalDepositFee();//剩余押金
				Integer feeValue = agencyBill.getFeeValue();//应收款
				//剩余押金小于等于应收款,实际收款=被抵扣的押金+recvFee
				if(totalDepositFee<=feeValue){
					agencyBill.setRecvFee(UcmsWebUtils.yuanTofen(recvFee)+totalDepositFee);
				}
				//押金大于应收款,实际收款=应收款+recvFee
				else{
					agencyBill.setRecvFee(UcmsWebUtils.yuanTofen(recvFee)+agencyBill.getFeeValue());
				}
			}else{*/
			agencyBill.setRecvFee(UcmsWebUtils.yuanTofen(recvFee));
			/*}*/
			agencyBill.setStaff(staffDao.get(Long.parseLong(staffId)));
			agencyBill.setRecvDesc(remark);
			agencyBill.setState("1");
			agencyBill.setRecvTime(new Timestamp(new SimpleDateFormat("yyyy-MM-dd").parse(recvTime).getTime()));
			agencyBillsdao.update(agencyBill);
			operDesc+="收取物业费商户账单"+",费用总额:"+agencyBill.getFeeValue()+",收费日期"+recvTime+",收费备注："+remark+",收费人："+staffDao.get(Long.parseLong(staffId)).getName();
		} catch (ParseException e) {
			e.printStackTrace();
		}
	}
	/**
	 * 根据账单表主键查询账单
	 * @param AgencyBillsId
	 * @return
	 */
	public AgencyDetailBills findById(String AgencyBillsId){
		return this.agencyDetailBillsDao.get(Long.parseLong(AgencyBillsId));
	}
	/**
	 * 修改账单明细表
	 * @param agencyDetailBills
	 */
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = ServiceException.class)
	public void changeAgencyDetailBillsState(List<AgencyDetailBills> agencyDetailBills){
		agencyDetailBillsDao.changeState(agencyDetailBills);
	}

	/**
	 * 根据分摊总账单id和state查询明细账单
	 * @param managerId
	 * @param state
	 * @return
	 */
	public List<AgencyDetailBills> findAgencyDetailBillsBymanagerFeeIdAndState(Long managerId,String state){
		return agencyDetailBillsDao.findAgencyDetailBillsBymanagerFeeIdAndState(managerId,state);
	}

	/**
	 * 根据物业费Id查询账单明细
	 * @param managerFeeId
	 * @return List
	 */
	public List<AgencyDetailBills> findByManagerFeeId(Long managerFeeId){
		return agencyDetailBillsDao.findByProperty("managerFee.id", managerFeeId);
	}

}
