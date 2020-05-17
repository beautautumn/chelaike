package com.ct.erp.rent.web;

import java.io.PrintWriter;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import javax.servlet.http.HttpServletResponse;

import org.apache.struts2.ServletActionContext;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Controller;

import com.ct.erp.common.web.SimpleActionSupport;
import com.ct.erp.constants.sysconst.Const;
import com.ct.erp.core.security.SecurityUtils;
import com.ct.erp.lib.entity.Contract;
import com.ct.erp.lib.entity.CycleRecvFee;
import com.ct.erp.lib.entity.RecvFee;
import com.ct.erp.lib.entity.Staff;
import com.ct.erp.rent.dao.CycleRecvFeeDao;
import com.ct.erp.rent.model.ContractBean;
import com.ct.erp.rent.model.RecvFeeBean;
import com.ct.erp.rent.service.ContractService;
import com.ct.erp.rent.service.RecvFeeService;
import com.ct.erp.sys.service.base.StaffService;
import com.ct.erp.util.UcmsWebUtils;

//@SuppressWarnings("serial")
@Scope("prototype")
@Controller("rent.contractPaymentAction")
public class ContractPaymentAction extends SimpleActionSupport{

	private static final long serialVersionUID = -8855649155486119770L;
	private Long contractId;
	private Contract contract;
	private String recvEnddate;//收款截止日期
	private List<Staff> staffs;
	private RecvFee recvFee;
	private String recvDate;//收款日期/退回时间
	private ContractBean contractBean = new ContractBean();
	private RecvFeeBean recvFeeBean;
	private Long staffId;
	private Long cycleId;
	private CycleRecvFee cycleRecvFee;
	@Autowired
	private ContractService contractService;
	@Autowired
	private StaffService staffService;
	@Autowired
	private RecvFeeService recvFeeService;
	@Autowired
	private CycleRecvFeeDao cycleRecvFeeDao;
	/*
	 * 合同收款操作页面
	 */
	public String toRectFeePage() {
		if(contractId==null){
			return null;
		}
		recvDate = new SimpleDateFormat("yyyy-MM-dd").format(new Date());
		contract = contractService.findById(contractId);
		contractBean = new ContractBean(contract);
		recvEnddate = contractService.getAsOfDate(contract);
		staffs = staffService.findAll();
		staffId = SecurityUtils.getCurrentSessionInfo().getStaffId();
		this.cycleRecvFee = this.cycleRecvFeeDao.get(this.cycleId);
		return "toRectFeePage";
	}
	/**
	 * 合同收款/收其他款（暂弃）
	 * @return
	 */
	public String doRectFee(){
		PrintWriter out = null;
		HttpServletResponse response = ServletActionContext.getResponse();
		response.setContentType("text/html;charset=utf-8");
		try {
			out = response.getWriter();
			recvFeeService.save(recvFeeBean,contractId);
			
			out.print("success");
			out.close();
		} catch (Exception e) {
			e.printStackTrace();
			out.print("error");
		}
		return null;
	}
	/**
	 * 跳转到合同退回页面
	 * @return
	 */
	public String toContractBackPage(){
		recvDate = new SimpleDateFormat("yyyy-MM-dd").format(new Date());
		return "toContractBackPage";
	}
	
	public String doContractBack(){
		PrintWriter out = null;
		HttpServletResponse response = ServletActionContext.getResponse();
		response.setContentType("text/html;charset=utf-8");
		try {
			out = response.getWriter();
			contract = contractService.findById(contractId);
			//合同退回改变合同状态（作废106）
			contract.setState(Const.TERMINATED);
			contract.setBackDesc(contractBean.getBackDesc());
			contract.setEndReason(Const.ABOLISH);
			contract.setBackTime(UcmsWebUtils.striToTimestamp(contractBean.getBackTime()));
			String operDesc = "合同退回,退回原因："+contract.getBackDesc();
			contract.setUpdateTime(UcmsWebUtils.now());
			contractService.update(contract, operDesc,"1");
			out.print("success");
			out.close();
		} catch (Exception e) {
			e.printStackTrace();
			out.print("error");
		}
		return null;
	}
	
	public String toRectFeeOtherPage(){
		staffs = staffService.findAll();
		if(contractId!=null&&contractId>0){
			contract = contractService.findById(contractId);
		}
		return "toRectFeeOtherPage";
	}
	
	/**
	 * 合同收款
	 * @return
	 */
	public String doRecvFee(){
		PrintWriter out = null;
		HttpServletResponse response = ServletActionContext.getResponse();
		response.setContentType("text/html;charset=utf-8");
		try {
			out = response.getWriter();
			recvFeeService.saveCycleRecvFee(recvFeeBean,contractId);
			
			out.print("success");
			out.close();
		} catch (Exception e) {
			e.printStackTrace();
			out.print("error");
		}
		return null;
	}
	
//	public String doRectFeeOther(){
//		PrintWriter out = null;
//		HttpServletResponse response = ServletActionContext.getResponse();
//		response.setContentType("text/html;charset=utf-8");
//		try {
//			out = response.getWriter();
//			recvFee = recvFeeBean.getRecvFeeb();
//			recvFee.setRecvType("1");
//			recvFee.setStaff(staffService.findStaffById(recvFeeBean.getStaffId()));
//			
//			contract = contractService.findById(contractId);
//			if(!contract.getState().equals("103")){
//				contract.setState("103");
//			}
//			recvFee.setContract(contract);
//			OperHis operHis = new OperHis();
//			operHis.setOperTag("0");
//			operHis.setOperDesc("收其他费用，实收款："+recvFeeBean.getRecvFee());
//			recvFeeService.save(recvFee,operHis);
//			recvFeeService.save(recvFeeBean,contractId);
//			
//			out.print("success");
//			out.close();
//		} catch (Exception e) {
//			e.printStackTrace();
//			out.print("error");
//		}
//		return null;
//	}
	public Long getContractId() {
		return contractId;
	}

	public void setContractId(Long contractId) {
		this.contractId = contractId;
	}

	public Contract getContract() {
		return contract;
	}

	public void setContract(Contract contract) {
		this.contract = contract;
	}

	public String getRecvEnddate() {
		return recvEnddate;
	}

	public void setRecvEnddate(String recvEnddate) {
		this.recvEnddate = recvEnddate;
	}

	public List<Staff> getStaffs() {
		return staffs;
	}

	public void setStaffs(List<Staff> staffs) {
		this.staffs = staffs;
	}

	public RecvFee getRecvFee() {
		return recvFee;
	}

	public void setRecvFee(RecvFee recvFee) {
		this.recvFee = recvFee;
	}

	public String getRecvDate() {
		return recvDate;
	}

	public void setRecvDate(String recvDate) {
		this.recvDate = recvDate;
	}

	public ContractBean getContractBean() {
		return contractBean;
	}

	public void setContractBean(ContractBean contractBean) {
		this.contractBean = contractBean;
	}

	public RecvFeeBean getRecvFeeBean() {
		return recvFeeBean;
	}

	public void setRecvFeeBean(RecvFeeBean recvFeeBean) {
		this.recvFeeBean = recvFeeBean;
	}
	
	public Long getStaffId() {
		return staffId;
	}
	public void setStaffId(Long staffId) {
		this.staffId = staffId;
	}
	public CycleRecvFee getCycleRecvFee() {
		return cycleRecvFee;
	}
	public void setCycleRecvFee(CycleRecvFee cycleRecvFee) {
		this.cycleRecvFee = cycleRecvFee;
	}
	public Long getCycleId() {
		return cycleId;
	}
	public void setCycleId(Long cycleId) {
		this.cycleId = cycleId;
	}
	
}
