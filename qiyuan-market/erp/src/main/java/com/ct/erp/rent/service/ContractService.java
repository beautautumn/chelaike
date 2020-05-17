package com.ct.erp.rent.service;

import java.io.File;
import java.sql.Timestamp;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;
import java.util.List;

import com.ct.erp.common.utils.GlobalConfigUtil;
import net.sf.json.JSONObject;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.aliyun.oss.OSSClient;
import com.ct.erp.common.exception.ServiceException;
import com.ct.erp.constants.sysconst.Const;
import com.ct.erp.lib.entity.Agency;
import com.ct.erp.lib.entity.Contract;
import com.ct.erp.lib.entity.ContractArea;
import com.ct.erp.lib.entity.Pic;
import com.ct.erp.lib.entity.SiteArea;
import com.ct.erp.lib.entity.Staff;
import com.ct.erp.rent.dao.AgencyDao;
import com.ct.erp.rent.dao.ContractAreaDao;
import com.ct.erp.rent.dao.ContractDao;
import com.ct.erp.rent.dao.SiteAreaDao;
import com.ct.erp.rent.model.DepositBean;
import com.ct.erp.sys.dao.OperHisDao;
import com.ct.erp.sys.dao.StaffDao;
import com.ct.erp.util.UcmsWebUtils;
import com.tianche.common.AliUpload;

@Service
public class ContractService {
	@Autowired
	private ContractDao contractDao;
	@Autowired
	private OperHisDao operHisDao;
	@Autowired
	private StaffDao staffDao;
	@Autowired
	private AgencyDao agencyDao;
	@Autowired
	private SiteAreaDao siteAreaDao;
	@Autowired
	private ContractAreaDao contractAreaDao;
	@Autowired
	private PicService picService;
	
	public Contract findById(Long id){
		return contractDao.findById(id);
	}

	public List<Contract> findByAgencyId(Long AgencyId,String state){
		return contractDao.findByAgencyId(AgencyId,state);
	}
	
	public List<Contract> findByAgencyId(Long AgencyId){
		return contractDao.findByAgencyId(AgencyId);
	}
	/**
	 * 查询本次收款截止日期
	 * @param contract 
	 * @param operDesc 操作说明
	 * @param type '0'为合同修改，'1'为合同退回
	 * @return
	 */
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = ServiceException.class)
	public void update(Contract contract,String operDesc,String type){
		contract.setUpdateTime(new Timestamp(new Date().getTime()));
		contractDao.update(contract);
		//合同退回--》场地归还
		List<ContractArea> contractAreas=new ArrayList<ContractArea>(contract.getContractAreas());
		for(ContractArea contractArea:contractAreas){
			SiteArea siteArea=this.siteAreaDao.get(contractArea.getSiteArea().getId());
			siteArea.setFreeCount(siteArea.getFreeCount()+contractArea.getLeaseCount());
			this.siteAreaDao.update(siteArea);
			contractArea.setUpdateTime(Timestamp.valueOf(new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date())));
			contractArea.setEndDate(Timestamp.valueOf(new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date())));
			contractArea.setStatus("0");
			this.contractAreaDao.update(contractArea);
		}
		
		operHisDao.createNewOperHis(contract.getId(), "0", operDesc);
		if(type.equals("1")){
			//如果商户只有这一个合同，则改变商户状态-->待签
			if(!contract.getAgency().getState().equals("103")){
				Agency agency = contract.getAgency();
				agency.setState("101");
				agency.setUpdateTime(new Timestamp(new Date().getTime()));
				agencyDao.update(agency);
			}
		}
	}
	
	public String getAsOfDate(Contract contract){
		Calendar cal=new GregorianCalendar();
		cal.setTime(contract.getStartDate());
		if(contract.getState().equals("102")){
			//合同状态-->待入场
			cal.add(Calendar.DAY_OF_YEAR, 3);
		}else if(contract.getState().equals("103")){
			
			//合同状态-->在场
			switch (contract.getRecvCycle().charAt(0)) {
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

	public void save(Contract contract){
		contractDao.save(contract);
	}

	public List<Contract> findContractBeforeContinueEndDate(
			Timestamp continueEndDate) {
		return this.contractDao.findContractBeforeContinueEndDate(continueEndDate);
	}

	public List<Contract> findByEndDate(Timestamp endDate) {
		return this.contractDao.finByEndDate(endDate);
	}

	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = ServiceException.class)
	public void clearAgency (String contractId,String staffId,
			String endDate,String clearingDesc)throws Exception{
		try {
			Contract contract = contractDao.get(Long.parseLong(contractId));
			contract.setClearingEndDate(new Timestamp(new SimpleDateFormat("yyyy-MM-dd").parse(endDate).getTime()));
			contract.setClearingDesc(clearingDesc);
			contract.setStaffByClearingStaff(staffDao.findById(Long.parseLong(staffId)));
			contract.setState("105");
			contractDao.update(contract);
		} catch (ParseException e) {
			e.printStackTrace();
		}
	}
	
	/**
	 * 通过agencyName找到的商户的所有合同List
	 * @param agencyname
	 * @return
	 */
	public List<Contract> findByAgencyname(String agencyname,String state){
		return this.contractDao.findByAgencyname(agencyname,state);
	}

	public List<Contract> findAll() {
		
		return this.contractDao.findAll();
	}

	public List<Contract> findByCondition(String agencyName, Long contractAreaId,
			String startBeginDate,String startEndDate,String endBeginDate, String endFinalDate) throws Exception {
		
		return this.contractDao.findByCondition(agencyName,contractAreaId,
				new Timestamp(new SimpleDateFormat("yyyy-MM-dd").parse(startBeginDate).getTime()),
				new Timestamp(new SimpleDateFormat("yyyy-MM-dd").parse(startEndDate).getTime()),
				new Timestamp(new SimpleDateFormat("yyyy-MM-dd").parse(endBeginDate).getTime()),
				new Timestamp(new SimpleDateFormat("yyyy-MM-dd").parse(endFinalDate).getTime())
		
		);
	}

	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = ServiceException.class)
	public void dealOtherFee(Long contractId, String otherRecvFee,
			String otherFeeDesc) {
		Contract contract=this.contractDao.get(contractId);
		contract.setOtherRecvFee(UcmsWebUtils.yuanTofen(otherRecvFee));
		contract.setOtherFeeDesc(otherFeeDesc);
		this.contractDao.update(contract);
		
	}

	public List<Contract> findAvaByAgencyId(Long agencyId) {
		return this.contractDao.findAvaByAgencyId(agencyId) ;
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
		String endpoint = GlobalConfigUtil.get("endpoint");
		String accessKeyId =  GlobalConfigUtil
				.get("accessKeyId");
		String accessKeySecret =  GlobalConfigUtil
				.get("accessKeySecret");
		String vehicleBucket = GlobalConfigUtil
				.get("vehicleBucket");
		OSSClient client = AliUpload.getOSSClient(endpoint, accessKeyId, accessKeySecret);
		String newFileName = AliUpload.easyPutObj(localFileName,vehicleBucket,fileObj,client);
		String picUrl = "http://"+Const.vehicleBucket+Const.img_url+newFileName;
		String smallPicUrl = "http://"+Const.vehicleBucket+Const.img_url+newFileName+Const.img_agency_size;
		if (newFileName != null) {
			return doUploadFile(newFileName, staff,picUrl,smallPicUrl, objId);
		}else{
			return "{}";
		}
	}
	
	private String doUploadFile(String newFileName, Staff staff,String picUrl,String smallPicUrl, Long objId)
			throws Exception {
		Pic pic = picService.doSaveUploadEntity(newFileName,
				staff, picUrl, smallPicUrl, objId,
				Const.IMAGE_TYPE_CONTRACT_PIC,"1");
		JSONObject json = new JSONObject();
		json.put("picId", pic.getId());
		json.put("smallPicAddr", smallPicUrl);
		return json.toString();
	}
	
	/*private String doUploadFile(String results[], Staff staff, Long objId)
	throws Exception {
	Pic pic = picService.doSaveUploadEntity(results[0],
			staff, results[1], results[2], objId,
			Const.IMAGE_TYPE_CONTRACT_PIC,"1");
	JSONObject json = new JSONObject();
	json.put("picId", pic.getId());
	json.put("smallPicAddr", results[2]);
	return json.toString();
}*/

	public List<Contract> findAvailByAgencyId(Long agencyId) {
		
		return this.contractDao.findAvailByAgencyId(agencyId);
	}

	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
	public void passWorking(Contract contract) {
		this.contractDao.update(contract);
		operHisDao.createNewOperHis(contract.getId(), "0", "合同通过临时审核");
	}

	
	
	
}
