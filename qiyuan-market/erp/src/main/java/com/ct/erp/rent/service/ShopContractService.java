package com.ct.erp.rent.service;

import java.io.File;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;
import java.util.List;

import net.sf.json.JSONObject;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.aliyun.oss.OSSClient;
import com.ct.erp.common.exception.ServiceException;
import com.ct.erp.constants.sysconst.Const;
import com.ct.erp.core.security.SecurityUtils;
import com.ct.erp.lib.entity.Agency;
import com.ct.erp.lib.entity.ContractCollectionPlan;
import com.ct.erp.lib.entity.ContractShop;
import com.ct.erp.lib.entity.OperHis;
import com.ct.erp.lib.entity.Pic;
import com.ct.erp.lib.entity.ShopContract;
import com.ct.erp.lib.entity.SiteShop;
import com.ct.erp.lib.entity.Staff;
import com.ct.erp.rent.dao.AgencyDao;
import com.ct.erp.rent.dao.ClearingReasonDao;
import com.ct.erp.rent.dao.ContractCollectionPlanDao;
import com.ct.erp.rent.dao.ContractShopDao;
import com.ct.erp.rent.dao.PicDao;
import com.ct.erp.rent.dao.ShopContractDao;
import com.ct.erp.rent.dao.SiteShopDao;
import com.ct.erp.rent.model.ContractBean;
import com.ct.erp.rent.model.DepositBean;
import com.ct.erp.sys.dao.OperHisDao;
import com.ct.erp.sys.dao.StaffDao;
import com.ct.erp.sys.service.base.StaffService;
import com.ct.erp.util.UcmsWebUtils;
import com.tianche.common.AliUpload;

@Service
public class ShopContractService {
	@Autowired
	private AgencyDao agencyDao;
	@Autowired
	private StaffService staffService;
	@Autowired
	private ShopContractDao shopContractDao;
	@Autowired
	private ContractCollectionPlanDao contractCollectionPlanDao;
	@Autowired
	private ContractShopDao contractShopDao;
	@Autowired
	private SiteShopDao siteShopDao;
	@Autowired
	private OperHisDao operHisDao;
	@Autowired
	private PicService picService;
	@Autowired
	private PicDao picDao;
	@Autowired
	private ClearingReasonDao clearingReasonDao;
	@Autowired
	private StaffDao staffDao;
	
	public ShopContract setUp(ShopContract shopContract,Agency agency,ContractBean contractBean) throws Exception{
		shopContract.setAgency(agency);
		shopContract.setEndDate(UcmsWebUtils.striToTimestamp(contractBean.getEndDate()));
		shopContract.setStartDate(UcmsWebUtils.striToTimestamp(contractBean.getStartDate()));
		shopContract.setRecvCycle(contractBean.getRecvCycle());
		shopContract.setEveryRecvFee(UcmsWebUtils.yuanTofen(contractBean.getEveryRecvFee()));
		shopContract.setDepositFee(UcmsWebUtils.yuanTofen(contractBean.getDepositFee()));
		shopContract.setSignDate(UcmsWebUtils.striToTimestamp(contractBean.getSignDate()));
		shopContract.setMarketSignName(contractBean.getMarketSignName());
		shopContract.setAgencySignName(contractBean.getAgencySignName());
		shopContract.setRemark(contractBean.getRemark());
		shopContract.setStaffByCreateStaff(staffService.findStaffById(SecurityUtils.getCurrentSessionInfo().getStaffId()));
		shopContract.setUpdateTime(UcmsWebUtils.now());
		shopContract.setState(Const.WAITFOR_WORK);
		return shopContract;
	}
	
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = ServiceException.class)
	public void addContract(ContractBean contractBean,List<ContractShop> contractShops,Long picId) throws Exception {
		Agency agency=this.agencyDao.findById(Long.valueOf(contractBean.getAgencyId()));
		ShopContract oldCon = this.shopContractDao.findById(contractBean.getId());
		ShopContract shopContract = new ShopContract();
		OperHis operHis=new OperHis();
		String operType = "";
		if(oldCon == null){
			operType = "0";
			/*shopContract=contractBean.getContract();*/
			shopContract.setCreateTime(UcmsWebUtils.now());
			shopContract = this.setUp(shopContract, agency, contractBean);
			shopContract=this.shopContractDao.save(shopContract);
			
			//生成收费记录
			int months = UcmsWebUtils.getMonths(contractBean.getStartDate(), contractBean.getEndDate());
			int cycle = 0;
			int cycleCount = 3;
			if(("0").equals(shopContract.getRecvCycle())){
				cycleCount = 3;
				cycle = UcmsWebUtils.getFeeNums(months,cycleCount);
			}else if(("1").equals(shopContract.getRecvCycle())){
				cycleCount = 6;
				cycle = UcmsWebUtils.getFeeNums(months,cycleCount);
			}else if(("2").equals(shopContract.getRecvCycle())){
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
				
				ContractCollectionPlan ccp = new ContractCollectionPlan();
				ccp.setShopContract(shopContract);//合同
				ccp.setCreateTime(UcmsWebUtils.now());//创建时间
				ccp.setPlanCollectionDate(shellRecvDate);//应收款日期
				ccp.setPlanCollectionFee(shellRecvFee);//应收金额
				ccp.setPlanCollectionDeposit(i == 0 ? UcmsWebUtils.yuanTofen(contractBean.getDepositFee()) : 0);//应收押金
				ccp.setState(Const.WAITFOR_COLLECT);
				this.contractCollectionPlanDao.save(ccp);
			}
		}else{
			operType = "1";
			shopContract=oldCon;
			shopContract = this.setUp(shopContract, agency, contractBean);
			this.shopContractDao.update(shopContract);
			
			List<ContractCollectionPlan> list = this.contractCollectionPlanDao.findByProperty("shopContract.id", shopContract.getId());
			for(ContractCollectionPlan c : list){
				this.contractCollectionPlanDao.delete(c);
			}
			
			//生成收费记录
			int months = UcmsWebUtils.getMonths(contractBean.getStartDate(), contractBean.getEndDate());
			int cycle = 0;
			int cycleCount = 3;
			if(("0").equals(shopContract.getRecvCycle())){
				cycleCount = 3;
				cycle = UcmsWebUtils.getFeeNums(months,cycleCount);
			}else if(("1").equals(shopContract.getRecvCycle())){
				cycleCount = 6;
				cycle = UcmsWebUtils.getFeeNums(months,cycleCount);
			}else if(("2").equals(shopContract.getRecvCycle())){
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
				
				ContractCollectionPlan ccp = new ContractCollectionPlan();
				ccp.setShopContract(shopContract);//合同
				ccp.setCreateTime(UcmsWebUtils.now());//创建时间
				ccp.setPlanCollectionDate(shellRecvDate);//应收款日期
				ccp.setPlanCollectionFee(shellRecvFee);//应收金额
				ccp.setPlanCollectionDeposit(i == 0 ? UcmsWebUtils.yuanTofen(contractBean.getDepositFee()) : 0);//应收押金
				ccp.setState(Const.WAITFOR_COLLECT);
				this.contractCollectionPlanDao.save(ccp);
			}
		}
		
		List<ContractShop> shops = this.contractShopDao.findByProperty("shopContract.id", shopContract.getId());
		
		for(ContractShop shop : shops){
			boolean flag = true;
			for(ContractShop cShop : contractShops){
				if(cShop.getId() != null && shop.getId().longValue() == cShop.getId().longValue()){
					flag = false;
					break;
				}
			}
			if(flag){
				SiteShop siteShop=this.siteShopDao.get(shop.getSiteShop().getId());
				siteShop.setFreeCount(siteShop.getFreeCount()+shop.getLeaseCount());
				this.siteShopDao.update(siteShop);
				this.contractShopDao.delete(shop);
			}
		}
		for(ContractShop contractShop:contractShops){
			
			if(contractShop.getId() == null){
				
				SiteShop siteShop=this.siteShopDao.get(contractShop.getSiteShop().getId());
				siteShop.setFreeCount(siteShop.getFreeCount()-contractShop.getLeaseCount());
				this.siteShopDao.update(siteShop);
				contractShop.setShopContract(shopContract);
				contractShop.setSiteShop(siteShop);
				contractShop.setMonthRentFee(siteShop.getMonthRentFee());
				contractShop.setLeaseCount(contractShop.getLeaseCount());		
		        int monthTotalFee =contractShop.getMonthRentFee()*contractShop.getLeaseCount();
		        contractShop.setMonthTotalFee(monthTotalFee);
		        contractShop.setAreaNo(contractShop.getAreaNo());
		        contractShop.setCreateTime(UcmsWebUtils.now());
		        contractShop.setUpdateTime(UcmsWebUtils.now());
		        contractShop.setStatus("1");
				this.contractShopDao.save(contractShop);
			}
			
		}
		operHis.setStaff(staffService.findStaffById(SecurityUtils.getCurrentSessionInfo().getStaffId()));
		operHis.setOperTag(Const.SHOP_CONTRACT);
		operHis.setOperTime(UcmsWebUtils.now());
		if(operType.equals("0")){
			operHis.setOperDesc("商户"+agency.getAgencyName()+"新签商铺合同");
		}else{
			operHis.setOperDesc("商户"+agency.getAgencyName()+"修改商铺合同");
		}
		
		/*switch(Integer.valueOf(agency.getState())){
			case 103: agency.setState("103");break;
			case 101: agency.setState("102");break;
			case 106: agency.setState("102");break;
		}
		
		this.agencyDao.update(agency);*/
		operHis.setOperObj(shopContract.getId());
		this.operHisDao.save(operHis);
		
		if(picId!=null){
			Pic pic =this.picDao.get(picId);
			pic.setObjId(shopContract.getId());
			this.picDao.update(pic);
		}
	}

	public ShopContract findById(Long contractId){
		return this.shopContractDao.findById(contractId);
	}

	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
	public String upload(Long objId, Staff staff, File fileObj, String localFileName) throws Exception {
		if (staff == null)
			return "{}";
		;
		/*String results[] = this.picService.doUploadFileStream(fileObj,
				localFileName, Const.IMAGE_TYPE_CONTRACT_PIC);
		if (results != null) {
			return doUploadFile(results, staff, objId);
		} */
		OSSClient client = AliUpload.getOSSClient(Const.endpoint, Const.accessKeyId, Const.accessKeySecret);
		String newFileName = AliUpload.easyPutObj(localFileName,Const.vehicleBucket,fileObj,client);
		String picUrl = "http://"+Const.vehicleBucket+Const.img_url+newFileName;
		String smallPicUrl = "http://"+Const.vehicleBucket+Const.img_url+newFileName+Const.img_agency_size;
		if (newFileName != null) {
			return doUploadFile(newFileName, staff,picUrl,smallPicUrl, objId);
		}else{
			return "{}";
		}
	}
	
	/*private String doUploadFile(String results[], Staff staff, Long objId)
		throws Exception {
		Pic pic = picService.doSaveUploadEntity(results[0],
				staff, results[1], results[2], objId,
				Const.IMAGE_TYPE_SHOP_CONTRACT_PIC,"4");
		JSONObject json = new JSONObject();
		json.put("picId", pic.getId());
		json.put("smallPicAddr", results[2]);
		return json.toString();
	}*/
	
	private String doUploadFile(String newFileName, Staff staff,String picUrl,String smallPicUrl, Long objId)
			throws Exception {
		Pic pic = picService.doSaveUploadEntity(newFileName,
				staff, picUrl, smallPicUrl, objId,
				Const.IMAGE_TYPE_SHOP_CONTRACT_PIC,"4");
		JSONObject json = new JSONObject();
		json.put("picId", pic.getId());
		json.put("smallPicAddr", smallPicUrl);
		return json.toString();
	}

	public String getAsOfDate(ShopContract shopContract) {
		Calendar cal=new GregorianCalendar();
		cal.setTime(shopContract.getStartDate());
		if(shopContract.getState().equals("102")){
			//合同状态-->待入场
			cal.add(Calendar.DAY_OF_YEAR, 3);
		}else if(shopContract.getState().equals("103")){
			
			//合同状态-->在场
			switch (shopContract.getRecvCycle().charAt(0)) {
			//按季度收费
			case '0':
				cal.add(Calendar.MONTH,2);
				while((new Date().getTime()-cal.getTimeInMillis())/1000/60/60/24>0){
					cal.add(Calendar.MONTH,3);
				}
				break;
			//按半年收费
			case '1':
				cal.add(Calendar.MONTH,5);
				while((new Date().getTime()-cal.getTimeInMillis())/1000/60/60/24>0){
					cal.add(Calendar.MONTH,6);
				}
				break;
			//按年收费
			case '2':
				cal.add(Calendar.MONTH,11);
				while((new Date().getTime()-cal.getTimeInMillis())/1000/60/60/24>0){
					cal.add(Calendar.MONTH,12);
				}
				break;
			}
		}
		return new SimpleDateFormat("yyyy-MM-dd").format(cal.getTime());
	}
	
	

	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
	public void contractBack(ShopContract shopContract, String operDesc,
			String string) {
		shopContract.setUpdateTime(new Timestamp(new Date().getTime()));
		shopContractDao.update(shopContract);
		//合同退回--》场地归还
		List<ContractShop> contractShops=new ArrayList<ContractShop>(shopContract.getContractShops());
		
		
		for(ContractShop contractShop:contractShops){
			SiteShop siteShop=this.siteShopDao.get(contractShop.getSiteShop().getId());
			siteShop.setFreeCount(siteShop.getFreeCount()+contractShop.getLeaseCount());
			this.siteShopDao.update(siteShop);
			contractShop.setUpdateTime(Timestamp.valueOf(new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date())));
			contractShop.setStatus("0");
			this.contractShopDao.update(contractShop);
		}
		
		operHisDao.createNewOperHis(shopContract.getId(), "0", operDesc);
	}

	@SuppressWarnings("unchecked")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = ServiceException.class)
	public void contractCount(Long shopContractId,ContractBean contractBean) throws Exception{
		ShopContract shopcontract=this.shopContractDao.get(shopContractId);
		shopcontract.setClearingReason(this.clearingReasonDao.get(contractBean.getClearingReason().getId()));
		shopcontract.setClearingStartDate(UcmsWebUtils.striToTimestamp(contractBean.getClearingStartDate()));
		shopcontract.setStaffByClearingStartStaff(this.staffDao.get(contractBean.getStaffByClearingStartStaff().getId()));
		shopcontract.setClearingDesc(contractBean.getClearingDesc());
		shopcontract.setState(Const.WAITFOR_END);//设置合同装填为待终止
		shopcontract.setEndReason(Const.ACTIVE_OUT);//设置终止原因为主动终止
		shopcontract.setEndReason(contractBean.getEndReason());
		this.shopContractDao.update(shopcontract);
		
		
		
		List<ContractShop> contractShops=new ArrayList<ContractShop>(shopcontract.getContractShops());
		for(ContractShop contractShop:contractShops){
			
			SiteShop siteShop=this.siteShopDao.get(contractShop.getSiteShop().getId());
			siteShop.setFreeCount(siteShop.getFreeCount()+contractShop.getLeaseCount());
			this.siteShopDao.update(siteShop);
			contractShop.setUpdateTime(UcmsWebUtils.now());
			//contractShop.setEndDate(UcmsWebUtils.now());
			contractShop.setStatus("0");
			this.contractShopDao.update(contractShop);
		}
		
		OperHis operHis=new OperHis();
		operHis.setStaff(staffService.findStaffById(SecurityUtils.getCurrentSessionInfo().getStaffId()));
		operHis.setOperTag(Const.SHOP_CONTRACT);
		operHis.setOperTime(UcmsWebUtils.now());
		
		Agency agency=shopcontract.getAgency();
		
		operHis.setOperDesc("商户"+agency.getAgencyName()+"主动发起清算合同," +
				"发起清算原因是："+shopcontract.getClearingReason().getName()+",发起清算的具体描述是："+shopcontract.getClearingDesc());
	
		operHis.setOperObj(shopContractId);
		this.operHisDao.save(operHis);
		
		/*this.toDoLogDao.delectTodoLog("rentmanager_contract_list",shopcontract.getId());
		this.toDoLogDao.delectTodoLog("rentmanager_contract_rec",shopcontract.getId());*/
	}

	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = ServiceException.class)
	public void clearContract(DepositBean depositBean,ShopContract shopContract) throws Exception{
		OperHis operHis=new OperHis();
		ShopContract ct = this.shopContractDao.findById(shopContract.getId());
		ct.setBackDepositFee(UcmsWebUtils.yuanTofen(depositBean.getBackDepositFee()));
		ct.setClearingEndDate(UcmsWebUtils.striToTimestamp(depositBean.getSettlementDate()));
		ct.setStaffByClearingStaff(staffDao.findById(depositBean.getSettlementStaffId()));
		ct.setClearedDesc(shopContract.getClearedDesc());
		ct.setState(Const.TERMINATED);
		ct.setUpdateTime(UcmsWebUtils.now());
		this.shopContractDao.update(ct);
		
		operHis.setStaff(staffService.findStaffById(SecurityUtils.getCurrentSessionInfo().getStaffId()));
		operHis.setOperTag(Const.SHOP_CONTRACT);
		operHis.setOperTime(UcmsWebUtils.now());
		operHis.setOperDesc(SecurityUtils.getCurrentSessionInfo().getUserName()+"清算了合同押金（合同编号："+shopContract.getId()+"）");
		operHis.setOperObj(ct.getId());
		this.operHisDao.save(operHis);
	}

}
