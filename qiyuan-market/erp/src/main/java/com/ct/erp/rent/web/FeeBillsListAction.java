package com.ct.erp.rent.web;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.List;
import javax.servlet.http.HttpServletResponse;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import org.apache.struts2.ServletActionContext;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Controller;

import com.ct.erp.common.web.SimpleActionSupport;
import com.ct.erp.core.security.SecurityUtils;
import com.ct.erp.lib.entity.Agency;
import com.ct.erp.lib.entity.AgencyBills;
import com.ct.erp.lib.entity.AgencyDetailBills;
import com.ct.erp.lib.entity.ContractArea;
import com.ct.erp.lib.entity.FeeItem;
import com.ct.erp.lib.entity.SiteArea;
import com.ct.erp.lib.entity.Staff;
import com.ct.erp.rent.service.AgencyBillsService;
import com.ct.erp.rent.service.AgencyDetailBillsService;
import com.ct.erp.rent.service.AgencyService;
import com.ct.erp.rent.service.ContractAreaService;
import com.ct.erp.rent.service.FeeItemService;
import com.ct.erp.rent.service.ManagerFeeService;
import com.ct.erp.rent.service.SiteAreaService;
import com.ct.erp.sys.service.base.StaffService;
import com.ct.erp.util.UcmsWebUtils;


@SuppressWarnings("serial")
@Scope("prototype")
@Controller("rent.feeBillsListAction")
public class FeeBillsListAction extends SimpleActionSupport {
	private Long agencyId;
	private String state;
	private String areaName;
	private List<AgencyBills> agencyBills=new ArrayList<AgencyBills>();
	private List<AgencyDetailBills> agencyDetailBills = new ArrayList<AgencyDetailBills>();
	private List<Staff> staffs=new ArrayList<Staff>();
	private List<FeeItem> feeItems = new ArrayList<FeeItem>();
	private List<Agency> agencys = new ArrayList<Agency>(); 
	private	List<SiteArea> siteAreas = new ArrayList<SiteArea>();
	private Agency agency;
	private String agencyName;
	private String name;
	private String itemIds;
	private String remark;
	private String feeValue;
	private String row;
	private String data;
	private String agencyid;
	private String staffId;
	private String recvTime;
	private String date;
	private String totalFees;
	private Staff staff;
	private String feeType;
	private String AgencyBillsId;
	private String totalDepositFee;
	@Autowired
	private AgencyBillsService agencyBillsService;
	@Autowired
	private StaffService staffService;
	@Autowired
	private FeeItemService feeItemService;
	@Autowired
	private AgencyService agencyService;
	@Autowired
	private SiteAreaService siteAreaService;
	@Autowired
	private ContractAreaService contractAreaService;
	@Autowired
	private ManagerFeeService managerFeeService;
	@Autowired
	private AgencyDetailBillsService agencyDetialService;
	/**
	 * “独立计费”按钮
	 * @return
	 * @throws Exception
	 */
	public String independentOfFee() throws Exception{
		try {
			agencyName = agencyService.findById(agencyId).getAgencyName();
			staffs = staffService.findAll();
			return "toIndependenOfFee";
		} catch (Exception e) {
			throw e;
		}
	}
	/**
	 * 独立计费页面“新增”按钮
	 * @return
	 * @throws Exception
	 */
	public String toAddFee() throws Exception{
		try {
			date = new SimpleDateFormat("yyyy-MM-dd").format(new Date());
			name=staffService.findStaffById(SecurityUtils.getCurrentSessionInfo().getStaffId()).getName();
			feeItems = feeItemService.findByStatus("1");
			staffs = staffService.findByStatus("1");
		} catch (Exception e) {
			throw e;
		}
		return "toAddFee";
	}
	/**
	 * “编辑”按钮
	 * @return
	 * @throws Exception
	 */
	public String toEdit() throws Exception{
		try{
		feeItems = feeItemService.findByStatus("1");
		staffs = staffService.findByStatus("1");
		}catch(Exception e){
			throw e;
		}
		return "toEdit";
	}
	public String addOrUpdate() throws Exception{
		HttpServletResponse response = ServletActionContext.getResponse();
		try {
			String[] a = data.split(",");
//			List<AgencyBills> agencyBills = new ArrayList<AgencyBills>();
			Integer[] feeValue = new Integer[a.length / 5];
			String[] remark = new String[a.length / 5];
			Long[] itemId = new Long[a.length / 5];
			Long[] staffId = new Long[a.length / 5];
			String[] recvTime= new String[a.length / 5];
//			Long[] id = new Long[a.length / 5];
			for (int i = 0; i< a.length/5; i++) {
				feeValue[i] = UcmsWebUtils.yuanTofen(a[5*i]);
				remark[i] = a[5*i+1];
				itemId[i] = Long.parseLong(a[5*i+2]);
				staffId[i]=Long.parseLong(a[5*i+3]);
				recvTime[i]=a[5*i+4];
//				if (a[5 * i + 2].equals("")) {
//					id[i] = (long) 0;
//				} else {
//					id[i] = Long.parseLong(a[5 * i + 2]);
//				}
				
			}
//			agencyBills = agencyBillsService.findByIdAndState(Long.parseLong(agencyid),"1");
			//数据库内的主键
//			Long[] oldId = new Long[agencyBills.size()];
//			for (int i = 0; i < oldId.length; i++) {
//				oldId[i] = agencyBills.get(i).getId();
//			}
//			agencyBillsService.delete(id, oldId);
			agencyBillsService.addOrUpdate(feeValue, remark, itemId, staffId,recvTime,
					agencyid,AgencyBillsId);
			UcmsWebUtils.ajaxOutPut(response, "success");
		} catch (Exception e) {
			e.printStackTrace();	
			UcmsWebUtils.ajaxOutPut(response, "error");
		}
		return null;
		
	}
	public String piLiangZengjia() throws Exception {
		HttpServletResponse response = ServletActionContext.getResponse();
		try {
			agencyBillsService.addBills(data, itemIds, staffId, recvTime);
			UcmsWebUtils.ajaxOutPut(response, "success");
		} catch (Exception e) {
			e.printStackTrace();
			UcmsWebUtils.ajaxOutPut(response, "error");
		}
				return null;
	}
	
	
	/**
	 * 主页面打开“批量计费”页面
	 * @return
	 * @throws Exception
	 */
	public String piLiangJiFei() throws Exception{
		try {
			date = new SimpleDateFormat("yyyy-MM-dd").format(new Date());
			feeItems = feeItemService.findByStatus("1");
			staffs = staffService.findByStatus("1");
		} catch (Exception e) {
			throw e;
		}
		return "toPiLiangJiFei";
	}
	
	//打开“新增商户”页面
	public String addShangHu() throws Exception{
		try {
			agencys=agencyService.findExistAgency();
		} catch (Exception e) {
			throw e;
		}
		return "toAddShangHu";
	}
	
	/**
	 * 打开“按区域增加”页面
	 * @return
	 * @throws Exception
	 */
	public String addShangHuByArea( ) throws Exception{
		try {
			siteAreas = siteAreaService.findRentingArea();
		} catch (Exception e) {
			throw e;
		}
		return "toAddShangHuByArea";
	}
	
	public String findAgencyNamesByAreaId(){
		HttpServletResponse response = ServletActionContext.getResponse();
		List<ContractArea> contractAreas = contractAreaService.findContractAreaByAreaId(Long.parseLong(data));
//		data="";
//		for(int i=0;i<contractAreas.size();i++){
//			data+=contractAreas.get(i).getContract().getAgency().getId()+","+contractAreas.get(i).getContract().getAgency().getAgencyName()+",";
//		
//		}
		//将	
		//JSONArray contractAreaList = JSONArray.fromObject(contractAreas);
		JSONArray jsonArr= new JSONArray();
		 for(int i=0;i<contractAreas.size();i++){
			 JSONObject obj = new JSONObject();
			 obj.put("agencyId", contractAreas.get(i).getContract().getAgency().getId());
			 obj.put("agencyName",contractAreas.get(i).getContract().getAgency().getAgencyName());
			 jsonArr.add(obj);
		 }
		 String jsonStr = jsonArr.toString();
		UcmsWebUtils.ajaxOutPut(response, jsonStr);
		return null;
	}
			
	/**
	 * 跳转至“收费”子窗口
	 * @return
	 */
	
	public String toCollectFees(){
		date = new SimpleDateFormat("yyyy-MM-dd").format(new Date());
		agency=agencyService.findById(agencyId);
/*		totalDepositFee = UcmsWebUtils.fenToYuan(agency.getTotalDepositFee());*/
		staffs=staffService.findAll();
		AgencyBills agencyBills = this.agencyBillsService.findById(Long.parseLong(AgencyBillsId));
		totalFees=UcmsWebUtils.fenToYuan(agencyBills.getFeeValue());
		staffId = SecurityUtils.getCurrentSessionInfo().getStaffId().toString();
		return "toCollectFees";
	}
	
	public String toPrintList(){
		agencyDetailBills  = agencyDetialService.findAgencyDetailBillsByAgencyBillsId(AgencyBillsId,null);
		AgencyBills agencyBill = agencyBillsService.findById(Long.parseLong(AgencyBillsId));
		areaName ="";
		if (agencyDetailBills !=null && agencyDetailBills.size()>0)
		{
		  areaName = agencyDetailBills.get(0).getSiteArea() == null ? "" : agencyDetailBills.get(0).getSiteArea().getAreaName();        
		}
		Agency agency = agencyBill.getAgency();
		List<ContractArea> areas = this.contractAreaService.findByAgencyId(agency.getId());
		for(int i=0;i<areas.size();i++){
			SiteArea area = areas.get(i).getSiteArea();
			if(!areaName.contains(area.getAreaName())){
				if(i>0){
					areaName +=",";
				}
				areaName += area.getAreaName();
			}
		}
		agencyName=agency.getAgencyName();
		Integer totalFee=agencyBill.getFeeValue();
		totalFees=totalFee.toString();
		recvTime = UcmsWebUtils.timestampTOStr(agencyBill.getRecvTime());
		return "toPrintList";
	}
	public String  getTotalFeeByAgencyIdAndStateAndrecvTime() throws Exception {
		HttpServletResponse response = ServletActionContext.getResponse();
		try {
			agencyBills = agencyBillsService.
					getTotalFeeByAgencyIdAndStateAndrecvTime(agencyid,state,recvTime,feeType);
			Integer total=0;
			for(int i=0;i<agencyBills.size();i++){
				total+=agencyBills.get(i).getFeeValue();
			}
			JSONArray jsonArr= new JSONArray();
			jsonArr.add(total);
			String jsonStr = jsonArr.toString();
			UcmsWebUtils.ajaxOutPut(response, jsonStr);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		
		return null;
	}
	
	public String view() {
		return null;
	}

	public Long getAgencyId() {
		return agencyId;
	}

	public void setAgencyId(Long agencyId) {
		this.agencyId = agencyId;
	}

	public String getState() {
		return state;
	}

	public void setState(String state) {
		this.state = state;
	}

	public AgencyBillsService getAgencyBillsService() {
		return agencyBillsService;
	}

	public void setAgencyBillsService(AgencyBillsService agencyBillsService) {
		this.agencyBillsService = agencyBillsService;
	}


	public List<AgencyBills> getAgencyBills() {
		return agencyBills;
	}

	public void setAgencyBills(List<AgencyBills> agencyBills) {
		this.agencyBills = agencyBills;
	}
	public List<Staff> getStaffs() {
		return staffs;
	}
	public void setStaffs(List<Staff> staffs) {
		this.staffs = staffs;
	}
	public StaffService getStaffService() {
		return staffService;
	}
	public void setStaffService(StaffService staffService) {
		this.staffService = staffService;
	}
	public String getAgencyName() {
		return agencyName;
	}
	public void setAgencyName(String agencyName) {
		this.agencyName = agencyName;
	}
	public List<FeeItem> getFeeItems() {
		return feeItems;
	}
	public void setFeeItems(List<FeeItem> feeItems) {
		this.feeItems = feeItems;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public FeeItemService getFeeItemService() {
		return feeItemService;
	}
	public Agency getAgency() {
		return agency;
	}
	public void setAgency(Agency agency) {
		this.agency = agency;
	}
	public void setFeeItemService(FeeItemService feeItemService) {
		this.feeItemService = feeItemService;
	}
	public String getRemark() {
		return remark;
	}
	public void setRemark(String remark) {
		this.remark = remark;
	}
	public String getFeeValue() {
		return feeValue;
	}
	public void setFeeValue(String feeValue) {
		this.feeValue = feeValue;
	}
	public String getItemIds() {
		return itemIds;
	}
	public void setItemIds(String itemIds) {
		this.itemIds = itemIds;
	}
	public String getRow() {
		return row;
	}
	public void setRow(String row) {
		this.row = row;
	}
	public String getData() {
		return data;
	}
	public String getAgencyid() {
		return agencyid;
	}
	public void setAgencyid(String agencyid) {
		this.agencyid = agencyid;
	}
	public void setData(String data) {
		this.data = data;
	}
	public String getStaffId() {
		return staffId;
	}
	public void setStaffId(String staffId) {
		this.staffId = staffId;
	}
	public List<Agency> getAgencys() {
		return agencys;
	}
	public void setAgencys(List<Agency> agencys) {
		this.agencys = agencys;
	}
	public String getDate() {
		return date;
	}
	public void setDate(String date) {
		this.date = date;
	}
	public List<SiteArea> getSiteAreas() {
		return siteAreas;
	}
	public void setSiteAreas(List<SiteArea> siteAreas) {
		this.siteAreas = siteAreas;
	}
	public AgencyService getAgencyService() {
		return agencyService;
	}
	public void setAgencyService(AgencyService agencyService) {
		this.agencyService = agencyService;
	}
	public SiteAreaService getSiteAreaService() {
		return siteAreaService;
	}
	public ContractAreaService getContractAreaService() {
		return contractAreaService;
	}
	public void setContractAreaService(ContractAreaService contractAreaService) {
		this.contractAreaService = contractAreaService;
	}
	public String getRecvTime() {
		return recvTime;
	}
	public void setRecvTime(String recvTime) {
		this.recvTime = recvTime;
	}
	public void setSiteAreaService(SiteAreaService siteAreaService) {
		this.siteAreaService = siteAreaService;
	}
	public String getTotalFees() {
		return totalFees;
	}
	public void setTotalFees(String totalFees) {
		this.totalFees = totalFees;
	}
	public Staff getStaff() {
		return staff;
	}
	public void setStaff(Staff staff) {
		this.staff = staff;
	}
	public ManagerFeeService getManagerFeeService() {
		return managerFeeService;
	}
	public void setManagerFeeService(ManagerFeeService managerFeeService) {
		this.managerFeeService = managerFeeService;
	}
	public String getFeeType() {
		return feeType;
	}
	public void setFeeType(String feeType) {
		this.feeType = feeType;
		
	}
	public AgencyDetailBillsService getAgencyDetialService() {
		return agencyDetialService;
	}
	public void setAgencyDetialService(AgencyDetailBillsService agencyDetialService) {
		this.agencyDetialService = agencyDetialService;
	}
	public List<AgencyDetailBills> getAgencyDetailBills() {
		return agencyDetailBills;
	}
	public void setAgencyDetailBills(List<AgencyDetailBills> agencyDetailBills) {
		this.agencyDetailBills = agencyDetailBills;
	}
	public String getAgencyBillsId() {
		return AgencyBillsId;
	}
	public void setAgencyBillsId(String agencyBillsId) {
		AgencyBillsId = agencyBillsId;
	}
	public String getAreaName() {
		return areaName;
	}
	public void setAreaName(String areaName) {
		this.areaName = areaName;
	}
	public String getTotalDepositFee() {
		return totalDepositFee;
	}
	public void setTotalDepositFee(String totalDepositFee) {
		this.totalDepositFee = totalDepositFee;
	}
}