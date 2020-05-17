package com.ct.erp.rent.service;

import java.sql.Timestamp;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;
import java.util.Iterator;
import java.util.List;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.ct.erp.common.exception.ServiceException;
import com.ct.erp.core.security.SecurityUtils;
import com.ct.erp.lib.entity.Agency;
import com.ct.erp.lib.entity.AgencyBills;
import com.ct.erp.lib.entity.AgencyDetailBills;
import com.ct.erp.lib.entity.Contract;
import com.ct.erp.lib.entity.FeeItem;
import com.ct.erp.lib.entity.ManagerFee;
import com.ct.erp.lib.entity.Staff;
import com.ct.erp.rent.dao.AgencyBillsDao;
import com.ct.erp.rent.dao.AgencyDao;
import com.ct.erp.rent.dao.AgencyDetailBillsDao;
import com.ct.erp.rent.dao.ContractAreaDao;
import com.ct.erp.rent.dao.ContractDao;
import com.ct.erp.rent.dao.FeeItemDao;
import com.ct.erp.rent.dao.ManagerFeeDao;
import com.ct.erp.rent.dao.SiteAreaDao;
import com.ct.erp.sys.dao.OperHisDao;
import com.ct.erp.sys.dao.StaffDao;
import com.ct.erp.util.UcmsWebUtils;


@Service
public class AgencyBillsService {
	@Autowired
	private AgencyBillsDao agencyBillsdao;
	@Autowired
	private AgencyDetailBillsDao agencyDetailBillsDao;
	@Autowired
	private AgencyDao agencyDao;
	@Autowired
	private FeeItemDao feeItemDao;
	@Autowired
	private StaffDao staffDao;
	@Autowired
	private OperHisDao operHisDao;
	@Autowired
	private ManagerFeeDao managerFeeDao;
	@Autowired
	private AgencyBillsDao agencyBillsDao;
	@Autowired
	private ContractDao contractDao;
	@Autowired
	private SiteAreaDao siteAreaDao;

	@Autowired
	private ContractAreaDao contractAreaDao;

	public List<AgencyBills> findByIdAndState(Long agencyId,String state){
		return agencyBillsdao.findByIdAndState(agencyId,state);
	}  
	
	public AgencyBills findById(Long id){
		return agencyBillsdao.get(id);
	}

	
	public void deleteById(Long id){
		agencyBillsdao.deleteById(id);
	}
	/**
	 * 押金抵扣物业费
	 * @param AgencyBillsId
	 */
	/*@Transactional(propagation = Propagation.REQUIRED, rollbackFor = ServiceException.class)
	public void deductionFees(String AgencyBillsId){
		AgencyBills agencyBill = agencyBillsdao.get(Long.parseLong(AgencyBillsId));
		Integer feeValue=agencyBill.getFeeValue();
		Agency agency = agencyDao.findById(agencyBill.getAgency().getId());
		agency.setTotalDepositFee(agency.getTotalDepositFee()-feeValue);
		agencyDao.update(agency);
	}*/

	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = ServiceException.class)
	//删除
	public void delete(Long[] id,Long[] oldId){
		for(int j=0;j<oldId.length;j++){
			Long x  = oldId[j];
			int sum = 0;
			for(int i=0;i<id.length;i++){
				Long y = id[i];
				if(x==y){
					sum+=1;
				}else{
					sum+=0;
				}
				
			}
			if(sum==0){
				agencyBillsdao.delete(agencyBillsdao.get(x));	
			}
			
		}
	}
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = ServiceException.class)
	public void  addOrUpdate(Integer[] feeValue,String[] remark ,Long[] itemId,
							 Long[] staffId,String[] recvTime, String agencyid,String AgencyBillsId) throws Exception{
		Integer total=0;
		for(int i=0;i<feeValue.length;i++){
				String operDesc="新增独立收费明细账单";
				//新增
				AgencyDetailBills agencyDetailBill = new AgencyDetailBills();
				//设置属性
				agencyDetailBill.setAgencyBills(agencyBillsdao.get(Long.parseLong(AgencyBillsId)));
				agencyDetailBill.setAgency(agencyDao.get(Long.parseLong(agencyid)));
				agencyDetailBill.setFeeValue(feeValue[i]);
				agencyDetailBill.setRemark(remark[i]);
				agencyDetailBill.setState("0");
				agencyDetailBill.setFeeType("1");	
				agencyDetailBill.setStaff(staffDao.findById(staffId[i]));
				agencyDetailBill.setOperTime(new Timestamp(new SimpleDateFormat("yyyy-MM-dd").parse(recvTime[i]).getTime()));
				agencyDetailBill.setFeeItem(feeItemDao.get(itemId[i]));
				//save
				agencyDetailBillsDao.save(agencyDetailBill);
				operHisDao.createNewOperHis(agencyDetailBill.getId(),"1", operDesc);
				total+=feeValue[i];
		}
		AgencyBills agencyBill = agencyBillsdao.get(Long.parseLong(AgencyBillsId));
		Integer independce= agencyBill.getIndependentTotalFee();
		Integer valueFee=agencyBill.getFeeValue();
		valueFee+=total;
		independce+=total;
		agencyBill.setFeeValue(valueFee);
		agencyBill.setIndependentTotalFee(independce);
		agencyBillsdao.update(agencyBill);
	}
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = ServiceException.class)
	public void addBills(String data,String itemId,String staffId,String recvTime) throws Exception{
			JSONArray jsonArr = JSONArray.fromObject(data);
			Timestamp recvtime=  new Timestamp(new SimpleDateFormat("yyyy-MM-dd").parse(recvTime).getTime());
			FeeItem feeItem = feeItemDao.get(Long.parseLong(itemId));//费用科目
			Staff staff = staffDao.get(Long.parseLong(staffId));//计费人
			
			for(int i=0;i<jsonArr.size();i++){
				String operDesc="新增独立收费明细账单";
				JSONArray arr = (JSONArray)jsonArr.get(i);
				AgencyDetailBills agencyDetailBill = new AgencyDetailBills();
				agencyDetailBill.setFeeItem(feeItem);
				agencyDetailBill.setState("0");
				agencyDetailBill.setFeeType("1");
				agencyDetailBill.setStaff(staff);
				agencyDetailBill.setOperTime(recvtime);
				agencyDetailBill.setAgency(agencyDao.get(Long.parseLong((String)arr.get(2))));
				List<AgencyBills> agencyBills = agencyBillsDao.findListByAgencyId(Long.parseLong((String)arr.get(2)),"0");
				AgencyBills agencyBill = null;
				if(agencyBills.size()>0){
					for(int n = 0 ; n< agencyBills.size() ; n++){
						if(this.agencyDetailBillsDao.checkItem(agencyBills.get(n).getId(),feeItem)){
							agencyBill = agencyBills.get(n);
							break;
			   			}
					}
					if(agencyBill == null){
						agencyBill = createAgencyBill(agencyDetailBill);
						agencyBill = agencyBillsDao.save(agencyBill);
					}
				}else{
					agencyBill = createAgencyBill(agencyDetailBill);
					agencyBill = agencyBillsDao.save(agencyBill);
				}

				//给独立计费总额赋值
				Integer independce=agencyBill.getIndependentTotalFee();
				independce+=UcmsWebUtils.yuanTofen((String)arr.get(0));
				agencyBill.setIndependentTotalFee(independce);
				//给费用总额赋值
				Integer valueFee=agencyBill.getFeeValue();
				valueFee+=UcmsWebUtils.yuanTofen((String)arr.get(0));
				agencyBill.setFeeValue(valueFee);
				agencyDetailBill.setAgencyBills(agencyBill);
				agencyDetailBill.setFeeValue(UcmsWebUtils.yuanTofen((String)arr.get(0)));
				agencyDetailBill.setRemark((String)arr.get(1));
				agencyBillsdao.update(agencyBill);
				agencyDetailBill=agencyDetailBillsDao.save(agencyDetailBill);
				operHisDao.createNewOperHis(agencyDetailBill.getId(),"1", operDesc);
			}
	}
	public Integer findSumFeeByAgencyIdAndState(Long agencyId){
		return agencyBillsdao.findTotalFeeByAgencyIdAndState(agencyId);
		
	}
	
	public Double findAgencyTotalFeeByAgencyId(Long agencyId){
		return agencyBillsdao.findAgencyTotalFeeByAgencyId(agencyId);
	}
	
	public List<AgencyBills> getCollectFees(String agencyId,Long managerFeeId,String state,String feeType){
		return agencyBillsdao.getCollectFees(agencyId,managerFeeId,state,feeType);
	}
	
	/**
	 * 物业费用分摊保存
	 * @param jsonStr：json字符串
	 * @throws Exception
	 */
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = ServiceException.class)
	public void save(String jsonStr) throws Exception{
		JSONArray jsonArr = JSONArray.fromObject(jsonStr);
		String operDesc = "";
		ManagerFee managerFee = null;
		Staff staff = null;
		for(Object obj :jsonArr){
           JSONArray arr = (JSONArray)obj;
           AgencyDetailBills agencyDetailBills = new AgencyDetailBills();
           agencyDetailBills.setState("0");
           agencyDetailBills.setFeeType("0");
           for(int i = 0 ; i < arr.size() ; i++){
        	   String s = (String)arr.get(i);
        	   switch (i) {
	        	   case 0:	agencyDetailBills.setSiteArea(siteAreaDao.findById(Long.parseLong(s))); break;//区域Id
	        	   case 1:	agencyDetailBills.setAgency(agencyDao.findById(Long.parseLong(s)));	break;//商户Id
	        	   case 2:	managerFee = (managerFee == null ? managerFeeDao.findById(Long.parseLong(s)):managerFee) ;
	        	   			agencyDetailBills.setManagerFee(managerFee); break;//物业总Id
	        	   case 3:	staff = (staff == null ? staffDao.findById(Long.parseLong(s)):staff);
	        		   		agencyDetailBills.setStaff(staff);break;//分摊人Id
	        	   case 4:	agencyDetailBills.setFeeValue(UcmsWebUtils.yuanTofen(s)); break;//分摊金额
	        	   case 5:	agencyDetailBills.setRemark(s); break;//分摊备注
	        	   case 6:	agencyDetailBills.setOperTime(new Timestamp(new SimpleDateFormat("yyyy-MM-dd").parse(s).getTime()));break;//分摊时间
	        	   case 7:	agencyDetailBills.setFeeItem(feeItemDao.findById(Long.valueOf(s))); break;//费用科目Id
	        	   case 8:  agencyDetailBills.setContractArea(contractAreaDao.findUniqueByProperty("id", Long.parseLong(s)));
        	   }
           }
           //查找商户未收款的账单
           List<AgencyBills> list = agencyBillsDao.findListByAgencyId(agencyDetailBills.getAgency().getId(),"0");
			AgencyBills agencyBills = null;
			if(list.size()>0){
				for(int n = 0 ; n< list.size() ; n++){
					if(this.agencyDetailBillsDao.checkItem(list.get(n).getId(),agencyDetailBills.getFeeItem())){
						agencyBills = list.get(n);
						break;
		   			}
				}
				if(agencyBills == null){
					agencyBills = createAgencyBill(agencyDetailBills);
					agencyBills = agencyBillsDao.save(agencyBills);
				}
			}else{
				agencyBills = createAgencyBill(agencyDetailBills);
				agencyBills = agencyBillsDao.save(agencyBills);
			}
   		   agencyDetailBills.setAgencyBills(agencyBills);
   		   agencyDetailBills = agencyDetailBillsDao.save(agencyDetailBills);
	   	   agencyBills.setShareTotalFee(agencyBills.getShareTotalFee()+agencyDetailBills.getFeeValue());
	   	   agencyBills.setFeeValue(agencyBills.getFeeValue()+agencyDetailBills.getFeeValue());
	   	   agencyBillsDao.update(agencyBills);
	   	   operDesc = "分摊物业总费用，物业费科目："+agencyDetailBills.getFeeItem().getItemName()+",分摊商户：" +
	   	   		""+agencyDetailBills.getAgency().getAgencyName()+",分摊金额："+agencyDetailBills.getFeeValue();
	   	   operHisDao.createNewOperHis(agencyDetailBills.getId(), "1", operDesc);
		}
		if(managerFee != null){
			managerFee.setState("1");
			managerFee.setStaffByOperStaff(staff);
			managerFee.setOperTime(new Timestamp(new Date().getTime()));
			managerFee.setUpdateTime(managerFee.getOperTime());
			managerFeeDao.update(managerFee);
			operDesc = "物业总费用分摊，物业费科目："+managerFee.getFeeItem().getItemName();
			operHisDao.createNewOperHis(managerFee.getId(), "1", operDesc);
		}
	}
	

	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = ServiceException.class)
	public void collect(List<AgencyBills> list,String recvTime,String staffId,String remark) throws Exception {
		
		try {
			for(int i=0;i<list.size();i++){
				String operDesc = "";
				AgencyBills agencyBills = list.get(i);
				agencyBills.setRecvFee(agencyBills.getFeeValue());
				agencyBills.setRecvTime(new Timestamp(new SimpleDateFormat("yyyy-MM-dd").parse(recvTime).getTime()));
				agencyBills.setRecvDesc(remark);	
				agencyBills.setStaff(staffDao.get(Long.parseLong(staffId)));
				operDesc+="收取物业费商户账单"+",费用总额:"+agencyBills.getFeeValue()+",收费日期"+recvTime+",收费备注："+remark+",收费人："+staffDao.get(Long.parseLong(staffId)).getName();
				agencyBillsdao.update(agencyBills);
				operHisDao.createNewOperHis(agencyBills.getId(),"1",operDesc);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	/**
	 * 上月同科目复制
	 * @param managerFeeId
	 * @return
	 */

	public String sameItemAdd(Long managerFeeId) {
		ManagerFee managerFee = managerFeeDao.findById(managerFeeId);
		FeeItem feeItem = managerFee.getFeeItem();
		Calendar cal = new GregorianCalendar();
		cal.setTime(managerFee.getBeginDate());
		cal.add(Calendar.MONTH, -1);
		List<AgencyDetailBills> list = agencyDetailBillsDao.findByProperty("feeItem.id", feeItem.getId());
		Iterator<AgencyDetailBills> it = list.iterator();
		JSONArray jsonArr = new JSONArray();
		while(it.hasNext()){
			AgencyDetailBills abs  = it.next();
			if(abs.getFeeType().equals("0")&&abs.getAgency().getState().equals("103")&&abs.getContractArea().getStatus().equals("1")){
				JSONObject obj = new JSONObject();
				Calendar cals = new GregorianCalendar();
				cals.setTime(abs.getManagerFee().getBeginDate());
				if(cal.get(Calendar.YEAR)==cals.get(Calendar.YEAR)&&cal.get(Calendar.MONTH)==cals.get(Calendar.MONTH)){
					obj.put("areaId", abs.getContractArea().getSiteArea().getId());
					obj.put("agencyId", abs.getAgency().getId());
					obj.put("agencyName", abs.getAgency().getAgencyName());
					obj.put("contractAreaId", abs.getContractArea().getId());
					obj.put("contractArea", abs.getContractArea().getSiteArea().getAreaName()+"-"+abs.getContractArea().getAreaNo());
					obj.put("date", new SimpleDateFormat("yyyy-MM-dd").format(abs.getContractArea().getContract().getStartDate())+"-"+ new SimpleDateFormat("yyyy-MM-dd").format(abs.getContractArea().getContract().getEndDate()));
					obj.put("feeValue", UcmsWebUtils.fenToYuan(abs.getFeeValue()));
					jsonArr.add(obj);
				}
			}
		}
		if(jsonArr.size()==0){
			return "null";
		}else{
			return jsonArr.toString();
		}
	}
	
	public List<AgencyBills>  getTotalFeeByAgencyIdAndStateAndrecvTime(String agencyid,String state,String recvTime,String feeType) throws Exception{
		return agencyBillsdao.getTotalFeeByAgencyIdAndStateAndrecvTime(agencyid,state,recvTime,feeType);
	}
	/**
	 * 押金抵扣物业费
	 * @param agency
	 * @param feeValue
	 * @param totalDepositFee
	 */
	/*@Transactional(propagation = Propagation.REQUIRED, rollbackFor = ServiceException.class)
	public void deductionFees(Agency agency,Integer feeValue,Integer totalDepositFee) throws Exception{
		try {
			if (totalDepositFee >= feeValue) {
				agency.setTotalDepositFee(totalDepositFee - feeValue);
				agencyDao.update(agency);
			}
			if (totalDepositFee < feeValue) {
				agency.setTotalDepositFee(0);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}*/

	public Integer findAvgFeeByAgencyIdAndState(Long agencyId) {
		return agencyBillsdao.findAvgFeeByAgencyIdAndState(agencyId);
	}
	
	public static AgencyBills createAgencyBill(AgencyDetailBills agencyDetailBill){
		AgencyBills agencyBill = new AgencyBills();
		agencyBill.setAgency(agencyDetailBill.getAgency());
		agencyBill.setShareTotalFee(0);
		agencyBill.setFeeValue(0);
		agencyBill.setIndependentTotalFee(0);
		agencyBill.setState("0");
		return agencyBill;
	}

}
