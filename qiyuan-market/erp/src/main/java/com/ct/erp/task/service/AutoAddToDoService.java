package com.ct.erp.task.service;

import java.util.Calendar;
import java.util.GregorianCalendar;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.ct.erp.common.exception.ServiceException;
import com.ct.erp.lib.entity.Contract;
import com.ct.erp.lib.entity.RecvFee;
import com.ct.erp.lib.entity.StaffRight;
import com.ct.erp.lib.entity.TodoLog;
import com.ct.erp.rent.dao.ContractDao;
import com.ct.erp.rent.dao.RecvFeeDao;
import com.ct.erp.sys.dao.StaffRightDao;
import com.ct.erp.sys.dao.TodoLogDao;
import com.ct.erp.util.UcmsWebUtils;

@Service
public class AutoAddToDoService {
	@Autowired
	private TodoLogDao todoLogDao;
	@Autowired
	private ContractDao contractDao;
	@Autowired
	private StaffRightDao staffRightDao;
	@Autowired
	private RecvFeeDao recvFeeDao;
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = ServiceException.class)
	public void scanfContracts() throws Exception{
		List<Contract> contracts = contractDao.findByProperty("state", "102");
		//扫描是否有需要提醒的合同收款
		scanfContractRecvFee(contracts);
		//扫描是否有合同到期需要提醒
		scanfContractExpire(contracts);
	}
	/**
	 * 扫描合同到期添加提醒
	 * @param contracts
	 * @throws Exception 
	 */
	private void scanfContractExpire(List<Contract> contracts) throws Exception{
		for(Contract contract : contracts){
			String rightCode = "rentmanager_contract_list";
			int data = UcmsWebUtils.getDateValues(UcmsWebUtils.today(),contract.getEndDate());
			if(data<90){
				String todoTitle = "商户："+contract.getAgency().getAgencyName()+" 合同快到期，需续签合同";
				insertTodoLog(contract,todoTitle,rightCode);
			}
		}
	}
	
	/**
	 * 扫描合同收款添加提醒
	 * @param contracts 
	 * @throws Exception 
	 */
	private void scanfContractRecvFee(List<Contract> contracts) throws Exception {
		 for(Contract contract:contracts){
			 //查询该合同收款的记录数
			 String rightCode = "rentmanager_contract_rec";
			 List<RecvFee> list = recvFeeDao.findBycontractIdandrecvType(contract.getId(), "0");
			 int count = (list==null ? 0:list.size());
			 Calendar cal = new GregorianCalendar();
			 cal.setTime(contract.getStartDate());
			 int monthAdd = 0;
			 switch (contract.getRecvCycle().charAt(0)) {
				case '0':monthAdd = 3;break;
				case '1':monthAdd = 6;break;
				case '2':monthAdd = 12;break;
			}
			cal.add(Calendar.MONTH, count*monthAdd);
			cal.add(Calendar.DAY_OF_YEAR, -30);
			int data = UcmsWebUtils.getDateValues(cal.getTime(),UcmsWebUtils.today());
			if(data>0){
				String todoTitle = "商户："+contract.getAgency().getAgencyName()+" 需缴纳下一周期租金";
				insertTodoLog(contract,todoTitle,rightCode);
			}
		 }
	}
	
	private void insertTodoLog(Contract contract,String todoTitle,String rightCode){
		List<TodoLog> todoLogs = todoLogDao.findByRightCodeandObjId(rightCode, contract.getId());
		if(todoLogs==null||todoLogs.size()<1){
			List<StaffRight> list2 = staffRightDao.findByProperty("sysright.rightCode", rightCode);
			if(list2!=null&&list2.size()>0){
				for(StaffRight staffRight:list2){
					todoLogDao.createTodoLog(rightCode, contract.getId(), todoTitle, staffRight.getStaff());
				}
			}
		}
	}
}
