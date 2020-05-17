package com.ct.erp.task.service;

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
import com.ct.erp.lib.entity.Agency;
import com.ct.erp.lib.entity.Contract;
import com.ct.erp.lib.entity.ContractArea;
import com.ct.erp.lib.entity.OperHis;
import com.ct.erp.lib.entity.RecvFee;
import com.ct.erp.lib.entity.SiteArea;
import com.ct.erp.rent.dao.AgencyDao;
import com.ct.erp.rent.dao.ContractAreaDao;
import com.ct.erp.rent.dao.ContractDao;
import com.ct.erp.rent.dao.RecvFeeDao;
import com.ct.erp.rent.dao.SiteAreaDao;
import com.ct.erp.sys.dao.OperHisDao;
import com.ct.erp.sys.dao.ParamsDao;
import com.ct.erp.sys.dao.StaffDao;
import com.ct.erp.sys.dao.TodoLogDao;
import com.ct.erp.util.UcmsWebUtils;

@Service
public class AutoConfigContractService {
	@Autowired
	private ContractDao contractDao;
	@Autowired
	private AgencyDao agencyDao;
	@Autowired
	private SiteAreaDao siteAreaDao;
	@Autowired
	private ContractAreaDao contractAreaDao;
	@Autowired
	private OperHisDao operHisDao;
	@Autowired
	private RecvFeeDao recvFeeDao;
	@Autowired
	private ParamsDao paramsDao;
	@Autowired
	private TodoLogDao toDoLogDao;
	@Autowired
	private StaffDao staffDao;
	
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = ServiceException.class)
	public void config(){
		List<Contract> contracts = this.contractDao.findCurrentAll();
		if(contracts==null||contracts.size()==0){
	
		}else{
			for(Contract contract:contracts){
				//对所有未生效合同进行判断
				if(contract.getState().equals("101")){
					dealContractFirstRecvOver(contract);
				}
				if(contract.getState().equals("102")){
					try {
						dealContractContinue(contract);
					} catch (Exception e) {
						e.printStackTrace();
					}
				}
			}
		}
		
		List<Agency> agencys=this.agencyDao.findByConditionTwoState("102", "103");//找出所有有合同的商户，也就是商户状态是带入场和入场状态
		dealAgency(agencys);
		
	}
	public void dealAgency(List<Agency> agencys)  {
		if(!(agencys==null||agencys.size()==0)){
			for(Agency agency:agencys){
				List<Contract> contractAgencys=this.contractDao.findCurrentByAgencyname(agency.getAgencyName());
				if(contractAgencys==null||contractAgencys.size()==0){
					OperHis operHisAgency=new OperHis();
					operHisAgency.setStaff(null);
					operHisAgency.setOperObj(agency.getId());
					operHisAgency.setOperTag("2");
					operHisAgency.setOperTime(Timestamp.valueOf(new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date())));
					switch(Integer.valueOf(agency.getState())){
						case 102:agency.setState("105");
								 operHisAgency.setOperDesc("系统自动把商户"+agency.getAgencyName()+"的状态从待入场变为待离场");
								 break;//待入场就变为待离场
/*						case 103:agency.setState("104");
								 agency.setClearingStartDate(Timestamp.valueOf(new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date())));
								 operHisAgency.setOperDesc("系统自动把商户"+agency.getAgencyName()+"的状态从在场状态变为待清算");
								 break;//在场状态变为待清算
*/					}
					try {
/*						agency.setStaffByClearingStaff(this.staffDao.findStaffByLoginName("系统", "1"));*/
					} catch (Exception e) {
						e.printStackTrace();
					}
/*					agency.setClearingStartDate(Timestamp.valueOf(new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date())));*/
					agency.setUpdateTime(Timestamp.valueOf(new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date())));
					this.agencyDao.update(agency);
					this.operHisDao.save(operHisAgency);
				}
			}
		}
	}
	@SuppressWarnings("unchecked")
	public void dealContractContinue(Contract contract) throws Exception {
		List<RecvFee> recvFeesTest=this.recvFeeDao.findBycontractIdandrecvType(contract.getId(), "0");
		int count=(recvFeesTest==null)?1:recvFeesTest.size();
		int addMonth=0;
		switch(Integer.valueOf(contract.getRecvCycle())){
			case 0: addMonth=3;break;
			case 1: addMonth=6;break;
			case 2: addMonth=12;break;
		}
		Calendar start = Calendar.getInstance();
		start.setTime(new Date(contract.getStartDate().getTime()));
		start.add(Calendar.MONTH, addMonth*count);
		Calendar now = Calendar.getInstance();
		now.setTime(new Date());
		Calendar end=Calendar.getInstance();
		end.setTime(new Date(contract.getEndDate().getTime()));
		int finalDay=UcmsWebUtils.getDateValues( Timestamp.valueOf(new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(end.getTime())),Timestamp.valueOf(new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(now.getTime())));
		int checkDay=UcmsWebUtils.getDateValues( Timestamp.valueOf(new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(start.getTime())),Timestamp.valueOf(new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(now.getTime())));
		if(checkDay>this.paramsDao.findByParamName("contract_continue_recv_over").getIntValue()){
			contract.setUpdateTime(Timestamp.valueOf(new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date())));
			contract.setState("104");//欠费终止104
			this.contractDao.update(contract);
			
			this.toDoLogDao.delectTodoLog("rentmanager_contract_list",contract.getId());
			this.toDoLogDao.delectTodoLog("rentmanager_contract_rec",contract.getId());
				
			List<ContractArea> contractAreas=new ArrayList<ContractArea>(contract.getContractAreas());
				//归还合同暂用的租用单位数
			dealReturnSiteArea(contractAreas);
			OperHis operHis=new OperHis();
			operHis.setStaff(this.staffDao.findStaffByLoginName("sys", "1"));
			operHis.setOperTag("0");
			operHis.setOperTime(Timestamp.valueOf(new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date())));
			operHis.setOperDesc("商户"+contract.getAgency().getAgencyName()+"中途合同收款超时，系统自动将合同状态改为欠费终止");
			
			operHis.setOperObj(contract.getId());
			this.operHisDao.save(operHis);
		}
		//合同正常到期
		//if(finalDay>this.paramsDao.findByParamName("contract_normal_recv_over").getIntValue()){
		if(new Date().getTime()>contract.getEndDate().getTime()){
			contract.setUpdateTime(Timestamp.valueOf(new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date())));
			contract.setState("103");//到期终止
			this.contractDao.update(contract);
			List<ContractArea> contractAreas=new ArrayList<ContractArea>(contract.getContractAreas());
			//归还合同暂用的租用单位数
			dealReturnSiteArea(contractAreas);
			OperHis operHis=new OperHis();
			operHis.setStaff(this.staffDao.findStaffByLoginName("sys", "1"));
			operHis.setOperTag("0");
			operHis.setOperTime(Timestamp.valueOf(new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date())));
			operHis.setOperDesc("商户"+contract.getAgency().getAgencyName()+"的合同到期，系统自动将合同状态改为到期终止");
			operHis.setOperObj(contract.getId());
			this.operHisDao.save(operHis);
				
		}
	}
		
	
	public void dealReturnSiteArea(List<ContractArea> contractAreas) {
		for(ContractArea contractArea:contractAreas){
			SiteArea siteArea=this.siteAreaDao.get(contractArea.getSiteArea().getId());
			siteArea.setFreeCount(siteArea.getFreeCount()+contractArea.getLeaseCount());
			this.siteAreaDao.update(siteArea);								
			contractArea.setUpdateTime(Timestamp.valueOf(new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date())));
			contractArea.setEndDate(Timestamp.valueOf(new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date())));
			contractArea.setStatus("0");
			this.contractAreaDao.update(contractArea);
		}
	}
	public Timestamp getTimestamp(Timestamp timestamp,int intValue) {
		Date date=new Date(timestamp.getTime());
		Calendar cal = Calendar.getInstance();
		cal.setTime(date);
		cal.add(Calendar.DATE, intValue);
		Timestamp firstRecEndDate = Timestamp.valueOf(new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(cal.getTime()));//获取未生效合同签订日开始后3天的日期
		return firstRecEndDate;
	}
	
	@SuppressWarnings("unchecked")
	public void dealContractFirstRecvOver(Contract contract){
		Timestamp firstRecEndDate = getTimestamp(contract.getSignDate(),this.paramsDao.findByParamName("contract_first_recv_over").getIntValue());
		Timestamp now=Timestamp.valueOf(new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date()));
		//如果未生效合同签订日3天没有收费也就是状态为改变，就意味着该合同签订之后3天未收费，自动转换为欠费终止
		if(firstRecEndDate.getTime()<=now.getTime()){
			contract.setUpdateTime(now);
			contract.setState("104");//欠费终止104
			this.contractDao.update(contract);
			List<ContractArea> contractAreas=new ArrayList<ContractArea>(contract.getContractAreas());
			//归还合同暂用的租用单位数
			dealReturnSiteArea(contractAreas);
			OperHis operHis=new OperHis();
			try {
				operHis.setStaff(this.staffDao.findStaffByLoginName("系统", "1"));
			} catch (Exception e) {
				e.printStackTrace();
			}
			operHis.setOperTag("0");
			operHis.setOperTime(Timestamp.valueOf(new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date())));
			operHis.setOperDesc("商户"+contract.getAgency().getAgencyName()+"首次合同收款超时，系统自动将合同状态改为欠费终止");
			operHis.setOperObj(contract.getId());
			this.operHisDao.save(operHis);
		}
	}
	
}
	
	



		
		
		
		
		
	



