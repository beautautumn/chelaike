package com.ct.erp.rent.web;

import java.text.SimpleDateFormat;
import java.util.Iterator;
import java.util.List;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.apache.struts2.ServletActionContext;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Controller;

import com.ct.erp.common.web.SimpleActionSupport;
import com.ct.erp.core.security.SecurityUtils;
import com.ct.erp.lib.entity.Contract;
import com.ct.erp.lib.entity.ContractArea;
import com.ct.erp.lib.entity.StaffRight;
import com.ct.erp.rent.service.ContractAreaService;
import com.ct.erp.rent.service.ContractService;
import com.ct.erp.sys.service.StaffRightService;
import com.ct.erp.util.UcmsWebUtils;

@Scope("prototype")
@Controller("rent.contractTableListAction")
public class ContractTableListAction extends SimpleActionSupport  {
	private static final long serialVersionUID = 4480201688892330227L;
	private Long agencyId;
	@Autowired
	private StaffRightService staffRightService;
	@Autowired
	private ContractService contractService;
	@Autowired
	private ContractAreaService contractAreaService;
	
	/**
	 * 获取合同区域列表
	 * @return
	 */
	public String getContractAreaTable(){
		List<Contract> contracts = contractService.findAvailByAgencyId(agencyId);
			if(contracts==null||contracts.size()==0){
				return null;
			}
			JSONArray jsonArr = new JSONArray();
			String jsonStr = "";
			for(Contract contract:contracts){
				List<ContractArea> contractAreas=this.contractAreaService.findContractAreasByContractId(contract.getId());
				Iterator<ContractArea> it = contractAreas.iterator();
				JSONArray jsonArr2 = new JSONArray();
				while (it.hasNext()) {
					ContractArea contractArea = it.next();
					JSONObject obj = new JSONObject();
					obj.put("area_name", contractArea.getSiteArea().getAreaName());
					obj.put("rent_type", contractArea.getSiteArea().getRentType());
					obj.put("lease_count", contractArea.getLeaseCount());
					obj.put("area_no", contractArea.getAreaNo());
					obj.put("car_count", contractArea.getCarCount());
					jsonArr2.add(obj);
				}
				jsonArr.add(jsonArr2);
			}
			jsonStr = jsonArr.toString();
			UcmsWebUtils.ajaxOutPut(ServletActionContext.getResponse(), jsonStr);
		return null;
	}

	/**
	 * 获取商户已缴押金
	 * @return
	 */
	public String getPayedDepositFee(){
		List<Contract> contracts =  contractService.findAvailByAgencyId(agencyId);
		if(contracts==null||contracts.size()==0){
			return null;
		}
		JSONArray jsonArr = new JSONArray();
		String jsonStr = "";
		for(Contract contract:contracts){
			JSONObject obj = new JSONObject();
			Integer fee = contract.getPayedDepositFee()==null ? 0:contract.getPayedDepositFee();
			obj.put("payed_deposit_fee", UcmsWebUtils.fenToYuan(fee));
			obj.put("colum", contract.getContractAreas().size());
			jsonArr.add(obj);
		}
		jsonStr = jsonArr.toString();
		UcmsWebUtils.ajaxOutPut(ServletActionContext.getResponse(), jsonStr);
		return null;
	}
	/**
	 * 获取商户本次应收款
	 * @return
	 */
	public String getEveryRecvFee(){
		List<Contract> contracts =  contractService.findAvailByAgencyId(agencyId);
		if(contracts==null||contracts.size()==0){
			return null;
		}
		JSONArray jsonArr = new JSONArray();
		String jsonStr = "";
		for(Contract contract:contracts){
			JSONObject obj = new JSONObject();
			obj.put("every_recv_fee", UcmsWebUtils.fenToYuan(contract.getEveryRecvFee()==null ? 0:contract.getEveryRecvFee()));
			obj.put("colum", contract.getContractAreas().size());
			jsonArr.add(obj);
		}
		jsonStr = jsonArr.toString();
		UcmsWebUtils.ajaxOutPut(ServletActionContext.getResponse(), jsonStr);
		return null;
	}
	/**
	 * 获取本次应缴押金
	 * @return
	 */
	public String getRecvDepositFee(){
		List<Contract> contracts =  contractService.findAvailByAgencyId(agencyId);
		if(contracts==null||contracts.size()==0){
			return null;
		}
		JSONArray jsonArr = new JSONArray();
		String jsonStr = "";
		for(Contract contract:contracts){
			JSONObject obj = new JSONObject();
			obj.put("recv_deposit_fee", UcmsWebUtils.fenToYuan((contract.getDepositFee()==null ? 0:contract.getDepositFee())-(contract.getPayedDepositFee()==null ? 0:contract.getPayedDepositFee())));
			obj.put("colum", contract.getContractAreas().size());
			jsonArr.add(obj);
		}
		jsonStr = jsonArr.toString();
		UcmsWebUtils.ajaxOutPut(ServletActionContext.getResponse(), jsonStr);
		return null;
	}
	
	/**
	 * 获取其他费用
	 * @return
	 */
	public String getOtherRecvFee (){
		List<Contract> contracts =  contractService.findAvailByAgencyId(agencyId);
		if(contracts==null||contracts.size()==0){
			return null;
		}
		JSONArray jsonArr = new JSONArray();
		String jsonStr = "";
		for(Contract contract:contracts){
			JSONObject obj = new JSONObject();
			obj.put("other_recv_fee", UcmsWebUtils.fenToYuan(contract.getOtherRecvFee()==null ? 0:contract.getOtherRecvFee()));
			obj.put("colum", contract.getContractAreas().size());
			jsonArr.add(obj);
		}
		jsonStr = jsonArr.toString();
		UcmsWebUtils.ajaxOutPut(ServletActionContext.getResponse(), jsonStr);
		return null;
	}
	
	public String getSignDate(){
		List<Contract> contracts =  contractService.findAvailByAgencyId(agencyId);
		if(contracts==null||contracts.size()==0){
			return null;
		}
		JSONArray jsonArr = new JSONArray();
		String jsonStr = "";
		for(Contract contract:contracts){
			JSONObject obj = new JSONObject();
			obj.put("sign_date", new SimpleDateFormat("yyyy-MM-dd").format(contract.getSignDate()));
			obj.put("columSign", contract.getContractAreas().size());
			jsonArr.add(obj);
		}
		jsonStr = jsonArr.toString();
		UcmsWebUtils.ajaxOutPut(ServletActionContext.getResponse(), jsonStr);
		return null;
	}
	
	
	public String getStartDate(){
		List<Contract> contracts =  contractService.findAvailByAgencyId(agencyId);
		if(contracts==null||contracts.size()==0){
			return null;
		}
		JSONArray jsonArr = new JSONArray();
		String jsonStr = "";
		for(Contract contract:contracts){
			JSONObject obj = new JSONObject();
			obj.put("start_date", new SimpleDateFormat("yyyy-MM-dd").format(contract.getStartDate()));
			obj.put("columStart", contract.getContractAreas().size());
			jsonArr.add(obj);
		}
		jsonStr = jsonArr.toString();
		UcmsWebUtils.ajaxOutPut(ServletActionContext.getResponse(), jsonStr);
		return null;
	}
	
	public String getEndDate(){
		List<Contract> contracts =  contractService.findAvailByAgencyId(agencyId);
		if(contracts==null||contracts.size()==0){
			return null;
		}
		JSONArray jsonArr = new JSONArray();
		String jsonStr = "";
		for(Contract contract:contracts){
			JSONObject obj = new JSONObject();
			obj.put("end_date", new SimpleDateFormat("yyyy-MM-dd").format(contract.getEndDate()));
			obj.put("columEnd", contract.getContractAreas().size());
			jsonArr.add(obj);
		}
		jsonStr = jsonArr.toString();
		UcmsWebUtils.ajaxOutPut(ServletActionContext.getResponse(), jsonStr);
		return null;
	}
	
	public String getState(){
		List<Contract> contracts =  contractService.findAvailByAgencyId(agencyId);
		if(contracts==null||contracts.size()==0){
			return null;
		}
		JSONArray jsonArr = new JSONArray();
		String jsonStr = "";
		for(Contract contract:contracts){
			JSONObject obj = new JSONObject();
			obj.put("contract_state", contract.getState());
			obj.put("colum", contract.getContractAreas().size());
			jsonArr.add(obj);
		}
		jsonStr = jsonArr.toString();
		UcmsWebUtils.ajaxOutPut(ServletActionContext.getResponse(), jsonStr);
		return null;
	}
	
	public String getOperButton(){
		List<Contract> contracts =  contractService.findAvailByAgencyId(agencyId);
		if(contracts==null||contracts.size()==0){
			return null;
		}
		List<StaffRight> list = staffRightService.findByStaffAndRightCode("button_recv_fee_other", SecurityUtils.getCurrentSessionInfo().getStaffId());
		JSONArray jsonArr = new JSONArray();
		String jsonStr = "";
		for(Contract contract:contracts){
			JSONObject obj = new JSONObject();
			obj.put("contractId", contract.getId());
			obj.put("contract_state", contract.getState());
			obj.put("colum", contract.getContractAreas().size());
			obj.put("detailContractPage", 1);
			if(contract.getState().equals("101")){
				obj.put("rectFeePage", 1);
				obj.put("contractBackPage", 1);
			}else if(contract.getState().equals("102")){
				obj.put("rectFeePage", 1);
				obj.put("contractBackPage", 0);
			}else{
				obj.put("rectFeePage", 0);
				obj.put("contractBackPage", 0);
			}
			if(list!=null&&list.size()>0){
				obj.put("rectFeeOtherPage", 1);
			}else{
				obj.put("rectFeeOtherPage", 0);
			}
			jsonArr.add(obj);
		}
		jsonStr = jsonArr.toString();
		UcmsWebUtils.ajaxOutPut(ServletActionContext.getResponse(), jsonStr);
		return null;
	}
	
	public String getDepositFee(){
		List<Contract> contracts =  contractService.findAvailByAgencyId(agencyId);
		if(contracts==null||contracts.size()==0){
			return null;
		}
		JSONArray jsonArr = new JSONArray();
		String jsonStr = "";
		for(Contract contract:contracts){
			JSONObject obj = new JSONObject();
			Integer fee = contract.getDepositFee()==null ? 0:contract.getDepositFee();
			obj.put("deposit_fee", UcmsWebUtils.fenToYuan(fee));
			obj.put("colum", contract.getContractAreas().size());
			jsonArr.add(obj);
		}
		jsonStr = jsonArr.toString();
		UcmsWebUtils.ajaxOutPut(ServletActionContext.getResponse(), jsonStr);
		return null;
	}
	
	public String getRecv(){
		List<Contract> contracts =  contractService.findAvailByAgencyId(agencyId);
		if(contracts==null||contracts.size()==0){
			return null;
		}
		JSONArray jsonArr = new JSONArray();
		String jsonStr = "";
		for(Contract contract:contracts){
			JSONObject obj = new JSONObject();
			Integer recvCycle=Integer.valueOf(contract.getRecvCycle());
			Integer fee = contract.getEveryRecvFee()==null ? 0:contract.getEveryRecvFee();
			switch(recvCycle){
				case 0:obj.put("recv","季度/"+UcmsWebUtils.fenToYuan(fee));break;
				case 1:obj.put("recv","半年/"+UcmsWebUtils.fenToYuan(fee));break;
				case 2:obj.put("recv","一年/"+UcmsWebUtils.fenToYuan(fee));break;
			}
			obj.put("colum", contract.getContractAreas().size());
			jsonArr.add(obj);
		}
		jsonStr = jsonArr.toString();
		UcmsWebUtils.ajaxOutPut(ServletActionContext.getResponse(), jsonStr);
		return null;
	}
	
	public String getListOperButton(){
		List<Contract> contracts =  contractService.findAvailByAgencyId(agencyId);
		if(contracts==null||contracts.size()==0){
			return null;
		}
		JSONArray jsonArr = new JSONArray();
		String jsonStr = "";
		for(Contract contract:contracts){
			JSONObject obj = new JSONObject();
			obj.put("contractId", contract.getId());
			obj.put("contract_state", contract.getState());
			obj.put("colum", contract.getContractAreas().size());
			obj.put("detailContractPage", 1);
			if(contract.getState().equals("102")){
				obj.put("continueContractPage", 1);
				obj.put("countContractPage", 1);
			}else{
				obj.put("continueContractPage", 0);
				obj.put("countContractPage", 0);
			}
			jsonArr.add(obj);
		}
		jsonStr = jsonArr.toString();
		UcmsWebUtils.ajaxOutPut(ServletActionContext.getResponse(), jsonStr);
		return null;
	}
	
	


	public Long getAgencyId() {
		return agencyId;
	}
	public void setAgencyId(Long agencyId) {
		this.agencyId = agencyId;
	}
}
