package com.ct.erp.loan.web;

import java.io.File;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletResponse;

import org.apache.struts2.ServletActionContext;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Controller;

import com.ct.erp.api.che300.Che300Api;
import com.ct.erp.api.che300.Che300Brand;
import com.ct.erp.api.che300.Che300Model;
import com.ct.erp.api.che300.Che300Series;
import com.ct.erp.api.che300.UsedCarPrice;
import com.ct.erp.carin.dao.CheckOutDao;
import com.ct.erp.carin.service.TradeInfoService;
import com.ct.erp.common.utils.Struts2Utils;
import com.ct.erp.common.web.SimpleActionSupport;
import com.ct.erp.constants.sysconst.Const;
import com.ct.erp.core.security.SecurityUtils;
import com.ct.erp.core.security.SessionInfo;
import com.ct.erp.lib.entity.CheckOut;
import com.ct.erp.lib.entity.Financing;
import com.ct.erp.lib.entity.PayAgencyHis;
import com.ct.erp.lib.entity.PayOwnerHis;
import com.ct.erp.lib.entity.Pic;
import com.ct.erp.lib.entity.RecvCustHis;
import com.ct.erp.lib.entity.RecvDisposalHis;
import com.ct.erp.lib.entity.RefundAgencyHis;
import com.ct.erp.lib.entity.Staff;
import com.ct.erp.lib.entity.Trade;
import com.ct.erp.loan.model.ResultParam;
import com.ct.erp.loan.service.LoanEvalService;
import com.ct.erp.rent.service.AgencyService;
import com.ct.erp.sys.dao.ParamsDao;
import com.ct.erp.sys.service.base.StaffService;
import com.ct.erp.util.UcmsWebUtils;

@Scope("prototype")
@Controller("loan.loanEvalAction")
public class LoanEvalAction extends SimpleActionSupport {

	private static final Logger log = LoggerFactory
			.getLogger(LoanEvalAction.class);
	private static final long serialVersionUID = 3636934746937027213L;
	@Autowired
	private LoanEvalService loanEvalService;
	@Autowired
	private StaffService staffService;
	@Autowired
	private AgencyService agencyService;
	@Autowired
	private TradeInfoService tradeInfoService;
	@Autowired
	private ParamsDao paramsDao;
	@Autowired
	private CheckOutDao checkOutDao;
	
	private File fileObj;
	private String localFileName;
	private Pic pic;
	private Long tradeId;
	private List<Staff> staffs = new ArrayList<Staff>();
	private Trade trade;
	private Financing financing;
	private Long staffId;
	private String valuationFee;// 估值金额
	private String financingMax;// 融资上限
	private String financingFee;// 融资金额
	private String acquPrice;// 收购价格
	private String salePrice;// 销售价格

	private String prepareFee;// 商户预收款
	private String payedOwnerFee;// 已付车主款
	private String remainingFee;// 剩余应付款
	private String recvSaleFee;// 已收车款

	private String curPayFee;// 本次付款
	private String curGatheringFee;// 本次收款

	private String payAgencyTotalFee;// 应付商户款
	private String payedgencyFee;// 已付商户款
	private String transferFee;// 过户费用
	private String repayBaseFee;// 应还款本金
	private String repayInterest;// 应还款利息
	private String disposalPrice;// 车辆处置价格
	private String recvDisposalFee;// 已收处置款
	private String recvDisposalOverTag;// 处置款是否收完

	private String refundFee;// 应退商户款
	private String refundedFee;// 已退商户款
	private String recvInterest;// 应还款利息
	private String refundOverTag;// 是否退完
	private Long picId;
	private PayOwnerHis payOwnerHis; // 付款车主历史
	private List<PayOwnerHis> payOwnerHises = new ArrayList<PayOwnerHis>();
	private RecvCustHis recvCustHis; // 收买主款历史
	private List<RecvCustHis> recvCustHises = new ArrayList<RecvCustHis>();
	private PayAgencyHis payAgencyHis; // 付商户款历史
	private List<PayAgencyHis> payAgencyHises = new ArrayList<PayAgencyHis>();
	private RecvDisposalHis recvDisposalHis;// 收处置款历史
	private List<RecvDisposalHis> recvDisposalHises = new ArrayList<RecvDisposalHis>();
	private RefundAgencyHis refundAgencyHis;// 退商户款历史
	private List<RefundAgencyHis> refundAgencyHises = new ArrayList<RefundAgencyHis>();

	private List<Che300Brand> che300Brand = new ArrayList<Che300Brand>();
	private int brand_id;
	private int series_id;
	private int model_id;
	private String regist_month;
	private double mile_count;
	private static final String financePer = Const.FINANCING_PERCENT;
	private double finance;
	
	private CheckOut checkOut;

	public double getFinance() {
		return finance;
	}

	public void setFinance(double finance) {
		this.finance = finance;
	}

	// 显示融资车辆检测界面
	public String toLoanVehicleCheck() {
		try {
			this.finance = Double.parseDouble(this.paramsDao.findByParamName(
					"finance_percent").getStrValue());
		} catch (Exception e) {
			log.error("toLoanVehicleCheck", e);
		}
		return "toLoanVehicleCheck";
	}

	// 执行融资车辆检测
	public void doLoanVehicleCheck() {
		HttpServletResponse response = ServletActionContext.getResponse();
		try {
			loanEvalService.doLoanVehicleCheck(tradeId, picId);
			UcmsWebUtils.ajaxOutPut(response, "success");
		} catch (Exception e) {
			log.error("doLoanVehicleCheck", e);
			UcmsWebUtils.ajaxOutPut(response, "error");
		}
	}

	// 上传检测报告
	public void upload() throws Exception {
		HttpServletResponse response = ServletActionContext.getResponse();
		String resStr = "";
		try {
			SessionInfo sessionInfo = SecurityUtils.getCurrentSessionInfo();
			Long staffId = sessionInfo.getStaffId();
			Staff staff = staffService.findById(staffId);
			resStr = this.agencyService.upload(3L, staff, fileObj,
					this.localFileName);
		} catch (Exception ex) {
			log.error("upload", ex);
			resStr = "0";
		}
		UcmsWebUtils.ajaxOutPut(response, resStr);
	}

	// 显示融资车辆检测报告
	public String toLoanVehicleReport() {
		try {
			pic = this.loanEvalService.getLoanVehicleCheck(tradeId);
		} catch (Exception e) {
			log.error("toLoanVehicleReport", e);
		}
		return "toLoanVehicleReport";
	}

	// 删除质检报告
	public void deleterep() throws Exception {
		HttpServletResponse response = ServletActionContext.getResponse();
		try {
			this.pic = this.loanEvalService.getLoanVehicleCheck(tradeId);
			this.loanEvalService.deleteRep(this.pic);
			this.tradeInfoService.chgState(tradeId);
			UcmsWebUtils.ajaxOutPut(response, "success");
		} catch (Exception e) {
			log.error("LoanEvalAction deleterep()", e);
			UcmsWebUtils.ajaxOutPut(response, "error");
		}
	}

	// 显示融资估值页面
	public String toLoanEvaluate() {
		try {
			setStaffs(staffService.findAllValid());
			trade = loanEvalService.getTradeById(tradeId);
			SessionInfo sessionInfo = SecurityUtils.getCurrentSessionInfo();
			staffId = sessionInfo.getStaffId();
			Staff staff = staffService.findById(staffId);
			financing = trade.getFinancing();
			if (financing == null) {
				financing = new Financing();
			}
			financing.setStaffByValuationStaff(staff);
			this.finance = Double.parseDouble(this.financePer);
			this.che300Brand = Che300Api.getBrand();
		} catch (Exception e) {
			log.error("toLoanEvaluate", e);
		}
		return "toLoanEval";
	}
	
	// 显示手动估值页面
	public String toEvaluate() {
		try {
			trade = loanEvalService.getTradeById(tradeId);
			SessionInfo sessionInfo = SecurityUtils.getCurrentSessionInfo();
			staffId = sessionInfo.getStaffId();
		} catch (Exception e) {
			log.error("toEvaluate", e);
		}
		return "toEval";
	}
	
	public void doEvalute() throws Exception{
		HttpServletResponse response = ServletActionContext.getResponse();
		try{
			this.trade = this.tradeInfoService.getTradeById(this.tradeId);
			this.trade.setValuationFee(UcmsWebUtils.wanToyuan(this.valuationFee).longValue());
			this.tradeInfoService.updateTrade(this.trade);
			UcmsWebUtils.ajaxOutPut(response, "success");
		}catch (Exception e){
			log.error("doEvalute", e);
			UcmsWebUtils.ajaxOutPut(response, "error");
		}
	}

	// 查询车300车系
	public void getSeries() {
		ResultParam result = new ResultParam();
		try {
			List<Che300Series> seriesList = Che300Api.getSeries(this.brand_id);
			result.setSeriesList(seriesList);
			result.setResultCode("0000");
			Struts2Utils.renderJson(result);
		} catch (Exception e) {
			result.setResultCode("0001");
			Struts2Utils.renderJson(result);
			log.error("getSeries", e);
		}
	}

	// 查询车300车型
	public void getModel() {
		ResultParam result = new ResultParam();
		try {
			List<Che300Model> modelList = Che300Api.getModel(this.series_id);
			result.setModelList(modelList);
			result.setResultCode("0000");
			Struts2Utils.renderJson(result);
		} catch (Exception e) {
			result.setResultCode("0001");
			Struts2Utils.renderJson(result);
			log.error("getModel", e);
		}
	}

	// 在线评估
	public void eval() {
		ResultParam result = new ResultParam();
		try {
			UsedCarPrice usedCarPrice = Che300Api.getUsedCarPrice(
					this.model_id, this.regist_month, this.mile_count, 11, "",
					(Double) null);
			result.setUsedCarPrice(usedCarPrice);
			result.setResultCode("0000");
			Struts2Utils.renderJson(result);
		} catch (Exception e) {
			e.printStackTrace();
			result.setResultCode("0001");
			Struts2Utils.renderJson(result);
			log.error("eval", e);
		}
	}

	// 保存融资估值
	public void doLoanEvaluate() {
		HttpServletResponse response = ServletActionContext.getResponse();
		try {

			financing.setFinancingMax(UcmsWebUtils.wanToyuan(financingMax));
			financing.setValuationFee(UcmsWebUtils.wanToyuan(valuationFee));
			loanEvalService.doLoanEval(tradeId, financing);
			UcmsWebUtils.ajaxOutPut(response, "success");
		} catch (Exception e) {
			log.error("doLoanEvaluate", e);
			UcmsWebUtils.ajaxOutPut(response, "error");
		}
	}

	// 显示商户预收界面
	public String toGatheringAgency() {
		try {
			trade = loanEvalService.getTradeById(tradeId);
			SessionInfo sessionInfo = SecurityUtils.getCurrentSessionInfo();
			staffId = sessionInfo.getStaffId();
			staffs = staffService.findAllValid();
			trade = loanEvalService.getTradeById(tradeId);
			financing = trade.getFinancing();
			financing.setStaffByPrepareStaff(new Staff());
			financingMax = UcmsWebUtils.yuanTowan(financing.getFinancingMax());
			valuationFee = UcmsWebUtils.yuanTowan(financing.getValuationFee());
			acquPrice = UcmsWebUtils.yuanTowan(trade.getAcquPrice());
		} catch (Exception e) {
			log.error("toGatheringAgency", e);
		}
		return "toGatheringAgency";
	}

	// 保存商户预收
	public void doGatheringAgency() {
		HttpServletResponse response = ServletActionContext.getResponse();
		try {

			financing.setFinancingFee(UcmsWebUtils.wanToyuan(financingFee));
			financing.setPrepareFee(UcmsWebUtils.wanToyuan(prepareFee));
			loanEvalService.doGatheringAgency(tradeId, acquPrice, financing);
			UcmsWebUtils.ajaxOutPut(response, "success");
		} catch (Exception e) {
			log.error("doGatheringAgency", e);
			UcmsWebUtils.ajaxOutPut(response, "error");
		}
	}

	// 显示支付车主界面
	public String toPayCarOwner() {
		try {
			SessionInfo sessionInfo = SecurityUtils.getCurrentSessionInfo();
			staffId = sessionInfo.getStaffId();
			staffs = staffService.findAllValid();
			trade = loanEvalService.getTradeById(tradeId);

			financing = trade.getFinancing();
			financingFee = UcmsWebUtils.yuanTowan(financing.getFinancingFee());
			prepareFee = UcmsWebUtils.yuanTowan(financing.getPrepareFee());
			payedOwnerFee = UcmsWebUtils
					.yuanTowan(financing.getPayedOwnerFee());
			acquPrice = UcmsWebUtils.yuanTowan(trade.getAcquPrice());

			payOwnerHises = this.loanEvalService.getPayOwnerHisList(financing
					.getId());
			payOwnerHis = new PayOwnerHis();
			payOwnerHis.setStaff(new Staff());
		} catch (Exception e) {
			log.error("toPayCarOwner", e);
		}
		return "toPayCarOwner";
	}

	// 保存支付车主
	public void doPayCarOwner() {
		HttpServletResponse response = ServletActionContext.getResponse();
		try {

			financing.setRemainingFee(UcmsWebUtils.wanToyuan(remainingFee)); // 剩余应付商户款
			financing.setPayedOwnerFee(UcmsWebUtils.wanToyuan(payedOwnerFee));// 已付商户款
			payOwnerHis.setPayFee(UcmsWebUtils.wanToyuan(curPayFee));
			loanEvalService.doPayOwner(tradeId, financing, payOwnerHis);
			UcmsWebUtils.ajaxOutPut(response, "success");
		} catch (Exception e) {
			log.error("doPayCarOwner", e);
			UcmsWebUtils.ajaxOutPut(response, "error");
		}
	}

	// 显示销售收款界面
	public String toGatheringBuyer() {
		try {

			SessionInfo sessionInfo = SecurityUtils.getCurrentSessionInfo();
			staffId = sessionInfo.getStaffId();
			staffs = staffService.findAllValid();
			trade = loanEvalService.getTradeById(tradeId);
			financing = trade.getFinancing();
			salePrice = UcmsWebUtils.yuanTowan(trade.getSalePrice());
			financingFee = UcmsWebUtils.yuanTowan(financing.getFinancingFee());
			prepareFee = UcmsWebUtils.yuanTowan(financing.getPrepareFee());
			recvSaleFee = UcmsWebUtils.yuanTowan(financing.getRecvSaleFee());
			recvCustHises = this.loanEvalService.getRecvCustHisList(financing
					.getId());
			recvCustHis = new RecvCustHis();
			recvCustHis.setStaff(new Staff());
		} catch (Exception e) {
			log.error("toGatheringBuyer", e);
		}
		return "toGatheringBuyer";
	}

	// 保存销售收款
	public void doGatheringBuyer() {
		HttpServletResponse response = ServletActionContext.getResponse();
		try {
			recvCustHis.setRecvFee(UcmsWebUtils.wanToyuan(curGatheringFee));
			loanEvalService.doGatheringBuyer(tradeId, salePrice, financing,
					recvCustHis);
			UcmsWebUtils.ajaxOutPut(response, "success");
		} catch (Exception e) {
			log.error("doGatheringBuyer", e);
			UcmsWebUtils.ajaxOutPut(response, "error");
		}
	}

	// 显示商户提款界面
	public String toPayAgency() {
		try {

			trade = loanEvalService.getTradeById(tradeId);
			SessionInfo sessionInfo = SecurityUtils.getCurrentSessionInfo();
			staffId = sessionInfo.getStaffId();
			staffs = staffService.findAllValid();
			trade = loanEvalService.getTradeById(tradeId);
			financing = trade.getFinancing();
			// 贷款天数等于第一次收客户款减去第一次付款给车主
			Integer days = UcmsWebUtils.getDateValues(
					financing.getFirstPayDate(),
					financing.getFirstGatheringDate()) + 1;
			financing.setUsedDays(days);
			// 应还利息等于贷款金额*贷款利率(数据库保存的是百分之)*贷款天数
			if (financing.getRecvInterest() == null) {
				double rate = financing.getLoanRate() == null ? 0 : financing
						.getLoanRate();
				double fee = financing.getFinancingFee() == null ? 0
						: financing.getFinancingFee();
				Double d = fee * rate / 100 * days;
				financing.setRecvInterest(d.intValue());
			}
			salePrice = UcmsWebUtils.yuanTowan(trade.getSalePrice());
			financingFee = UcmsWebUtils.yuanTowan(financing.getFinancingFee());
			recvSaleFee = UcmsWebUtils.yuanTowan(financing.getRecvSaleFee());
			prepareFee = UcmsWebUtils.yuanTowan(financing.getPrepareFee());
			repayBaseFee = UcmsWebUtils.yuanTowan(financing.getFinancingFee());// 应还本金等于融资金额
			payAgencyHises = this.loanEvalService.getPayAgencyHisList(financing
					.getId());
			payAgencyHis = new PayAgencyHis();
			payAgencyHis.setStaff(new Staff());
		} catch (Exception e) {
			log.error("toPayAgency", e);
		}
		return "toPayAgency";
	}

	// 保存商户提款
	public void doPayAgency() {
		HttpServletResponse response = ServletActionContext.getResponse();
		try {
			payAgencyHis.setPayFee(Integer.parseInt(curPayFee));
			financing.setRepayBaseFee(UcmsWebUtils.wanToyuan(repayBaseFee));
			financing.setRepayInterest(Integer.parseInt(repayInterest));
			financing.setTransferFee(transferFee == null ? 0 : Integer.parseInt(transferFee));
			financing.setPayAgencyTotalFee(Integer.parseInt(payAgencyTotalFee));
			loanEvalService.doPayAgency(tradeId, financing, payAgencyHis);
			UcmsWebUtils.ajaxOutPut(response, "success");
		} catch (Exception e) {
			log.error("doPayAgency", e);
			UcmsWebUtils.ajaxOutPut(response, "error");
		}
	}

	// 跳转到处置融资界面
	public String toDisposalFinancingCar() {
		try {
			trade = loanEvalService.getTradeById(tradeId);
			SessionInfo sessionInfo = SecurityUtils.getCurrentSessionInfo();
			staffId = sessionInfo.getStaffId();
			staffs = staffService.findAllValid();
			trade = loanEvalService.getTradeById(tradeId);
			financing = trade.getFinancing();
			disposalPrice = UcmsWebUtils
					.yuanTowan(financing.getDisposalPrice());
			financingFee = UcmsWebUtils.yuanTowan(financing.getFinancingFee());
			prepareFee = UcmsWebUtils.yuanTowan(financing.getPrepareFee());
			recvDisposalFee = UcmsWebUtils.yuanTowan(financing
					.getRecvDisposalFee());
			recvDisposalHises = this.loanEvalService
					.getPayDisposalHisList(financing.getId());
			recvDisposalHis = new RecvDisposalHis();
			recvDisposalHis.setStaff(new Staff());
		} catch (Exception e) {
			log.error("toDisposalFinancingCar", e);
			return "error";
		}
		return "toDisposalFinancingCar";
	}

	// 保存处置融资界面
	public void doDisposalFinancingCar() {
		HttpServletResponse response = ServletActionContext.getResponse();
		try {
			recvDisposalHis.setRecvFee(UcmsWebUtils.wanToyuan(curGatheringFee));
			financing.setDisposalPrice(UcmsWebUtils.wanToyuan(disposalPrice));

			financing.setRepayBaseFee(financing.getFinancingFee());// 应还本金等于融资金额

			loanEvalService.doDisposalFinancing(tradeId, financing,
					recvDisposalHis);
			UcmsWebUtils.ajaxOutPut(response, "success");
		} catch (Exception e) {
			log.error("doDisposalFinancingCar", e);
			UcmsWebUtils.ajaxOutPut(response, "error");
		}
	}

	// 跳转到退商户款界面
	public String toRefundAgency() {
		try {
			trade = loanEvalService.getTradeById(tradeId);
			SessionInfo sessionInfo = SecurityUtils.getCurrentSessionInfo();
			staffId = sessionInfo.getStaffId();
			staffs = staffService.findAllValid();
			trade = loanEvalService.getTradeById(tradeId);
			financing = trade.getFinancing();
			// 贷款天数等于第一次收客户款减去第一次付款给车主
			Integer days = UcmsWebUtils.getDateValues(
					financing.getFirstPayDate(),
					financing.getFirstGatheringDate()) + 1;
			financing.setUsedDays(days);
			// 应还利息等于贷款金额*贷款利率(数据库保存的是百分之)*贷款天数
			if (financing.getRecvInterest() == null) {
				double rate = financing.getLoanRate() == null ? 0 : financing
						.getLoanRate();
				double fee = financing.getFinancingFee() == null ? 0
						: financing.getFinancingFee();
				Double d = fee * rate / 100 * days;
				financing.setRepayInterest(d.intValue());
			}

			disposalPrice = UcmsWebUtils
					.yuanTowan(financing.getDisposalPrice());
			recvDisposalFee = UcmsWebUtils.yuanTowan(financing
					.getRecvDisposalFee());
			financingFee = UcmsWebUtils.yuanTowan(financing.getFinancingFee());
			prepareFee = UcmsWebUtils.yuanTowan(financing.getPrepareFee());
			repayBaseFee = UcmsWebUtils.yuanTowan(financing.getRepayBaseFee());

			// 应退商户款=处置价格-应还款本金-应还款利息-过户费用；
			if (financing.getRefundFee() == null) {
				Integer fee = financing.getDisposalPrice()
						- financing.getRepayBaseFee()
						- financing.getRepayInterest();
						/*- financing.getTransferFee();*/
				financing.setRefundFee(fee);
			}

			if (financing.getRecvInterest() == null) {
				financing.setRecvInterest(financing.getRepayInterest());// 应还款利息=应收款利息
			}

			refundAgencyHises = this.loanEvalService
					.getRefundAgencyHisList(financing.getId());
			refundAgencyHis = new RefundAgencyHis();
			refundAgencyHis.setStaff(new Staff());
		} catch (Exception e) {
			e.printStackTrace();
			log.error("toRefundAgency", e);
			return "error";
		}
		return "toRefundAgency";
	}

	// 保存商户退款信息
	public void doRefundAgency() {
		HttpServletResponse response = ServletActionContext.getResponse();
		try {
			refundAgencyHis.setRefundFee(Integer.parseInt(curPayFee));
			financing.setDisposalPrice(UcmsWebUtils.wanToyuan(disposalPrice));
			financing.setRefundFee(Integer.parseInt(refundFee));
			financing.setRefundedFee(Integer.parseInt(refundedFee));
			financing.setRecvInterest(Integer.parseInt(recvInterest));
			loanEvalService.doRefundAgency(tradeId, financing, refundAgencyHis);
			UcmsWebUtils.ajaxOutPut(response, "success");
		} catch (Exception e) {
			log.error("doRefundAgency", e);
			UcmsWebUtils.ajaxOutPut(response, "error");
		}
	}
	
	
	 /**
     * 车辆审核页面
     */
    public String toAuditInfo(){
      
      try{
         this.trade =tradeInfoService.getTradeById(tradeId);
      }catch(Exception e) {
         log.error("toAuditInfo",e);
         return "error";
      }
      return "toAuditInfo";     
    }
    
    
    /**
     *  车辆审核
     */
    public void doAuditInfo(){
    	HttpServletResponse response = ServletActionContext.getResponse();
    	try {
    		Trade t = tradeInfoService.getTradeById(tradeId);
    		/*if(t.getCheckOut() != null){
    			UcmsWebUtils.ajaxOutPut(response, "again");
    			return;
    		}*/
    		this.checkOut.setTrade(t);
			CheckOut co = tradeInfoService.doCheckOut(checkOut,t);
			
			/*t.setCheckId(co.getId());
			tradeInfoService.updateTrade(t);*/
			UcmsWebUtils.ajaxOutPut(response, "success");
		} catch (Exception e) {
			log.error("doAuditInfo",e);
			UcmsWebUtils.ajaxOutPut(response, "error");
		}
    }

	public Financing getFinancing() {
		return financing;
	}

	public void setFinancing(Financing financing) {
		this.financing = financing;
	}

	public Long getTradeId() {
		return tradeId;
	}

	public void setTradeId(Long tradeId) {
		this.tradeId = tradeId;
	}

	public void setTrade(Trade trade) {
		this.trade = trade;
	}

	public Trade getTrade() {
		return trade;
	}

	public void setStaffs(List<Staff> staffs) {
		this.staffs = staffs;
	}

	public List<Staff> getStaffs() {
		return staffs;
	}

	public void setFinancingMax(String financingMax) {
		this.financingMax = financingMax;
	}

	public String getFinancingMax() {
		return financingMax;
	}

	public void setValuationFee(String valuationFee) {
		this.valuationFee = valuationFee;
	}

	public String getValuationFee() {
		return valuationFee;
	}

	public StaffService getStaffService() {
		return staffService;
	}

	public void setStaffService(StaffService staffService) {
		this.staffService = staffService;
	}

	public String getFinancingFee() {
		return financingFee;
	}

	public void setFinancingFee(String financingFee) {
		this.financingFee = financingFee;
	}

	public String getPrepareFee() {
		return prepareFee;
	}

	public void setPrepareFee(String prepareFee) {
		this.prepareFee = prepareFee;
	}

	public void setAcquPrice(String acquPrice) {
		this.acquPrice = acquPrice;
	}

	public String getAcquPrice() {
		return acquPrice;
	}

	public void setStaffId(Long staffId) {
		this.staffId = staffId;
	}

	public Long getStaffId() {
		return staffId;
	}

	public void setPayedOwnerFee(String payedOwnerFee) {
		this.payedOwnerFee = payedOwnerFee;
	}

	public String getPayedOwnerFee() {
		return payedOwnerFee;
	}

	public void setRemainingFee(String remainingFee) {
		this.remainingFee = remainingFee;
	}

	public String getRemainingFee() {
		return remainingFee;
	}

	public void setPayOwnerHises(List<PayOwnerHis> payOwnerHises) {
		this.payOwnerHises = payOwnerHises;
	}

	public List<PayOwnerHis> getPayOwnerHises() {
		return payOwnerHises;
	}

	public void setCurPayFee(String curPayFee) {
		this.curPayFee = curPayFee;
	}

	public String getCurPayFee() {
		return curPayFee;
	}

	public void setPayOwnerHis(PayOwnerHis payOwnerHis) {
		this.payOwnerHis = payOwnerHis;
	}

	public PayOwnerHis getPayOwnerHis() {
		return payOwnerHis;
	}

	public void setRecvCustHis(RecvCustHis recvCustHis) {
		this.recvCustHis = recvCustHis;
	}

	public RecvCustHis getRecvCustHis() {
		return recvCustHis;
	}

	public void setRecvCustHises(List<RecvCustHis> recvCustHises) {
		this.recvCustHises = recvCustHises;
	}

	public List<RecvCustHis> getRecvCustHises() {
		return recvCustHises;
	}

	public void setRecvSaleFee(String recvSaleFee) {
		this.recvSaleFee = recvSaleFee;
	}

	public String getRecvSaleFee() {
		return recvSaleFee;
	}

	public void setCurGatheringFee(String curGatheringFee) {
		this.curGatheringFee = curGatheringFee;
	}

	public String getCurGatheringFee() {
		return curGatheringFee;
	}

	public void setSalePrice(String salePrice) {
		this.salePrice = salePrice;
	}

	public String getSalePrice() {
		return salePrice;
	}

	public void setTransferFee(String transferFee) {
		this.transferFee = transferFee;
	}

	public String getTransferFee() {
		return transferFee;
	}

	public void setPayAgencyTotalFee(String payAgencyTotalFee) {
		this.payAgencyTotalFee = payAgencyTotalFee;
	}

	public String getPayAgencyTotalFee() {
		return payAgencyTotalFee;
	}

	public void setPayedgencyFee(String payedgencyFee) {
		this.payedgencyFee = payedgencyFee;
	}

	public String getPayedgencyFee() {
		return payedgencyFee;
	}

	public void setRepayBaseFee(String repayBaseFee) {
		this.repayBaseFee = repayBaseFee;
	}

	public String getRepayBaseFee() {
		return repayBaseFee;
	}

	public void setRepayInterest(String repayInterest) {
		this.repayInterest = repayInterest;
	}

	public String getRepayInterest() {
		return repayInterest;
	}

	public void setPayAgencyHis(PayAgencyHis payAgencyHis) {
		this.payAgencyHis = payAgencyHis;
	}

	public PayAgencyHis getPayAgencyHis() {
		return payAgencyHis;
	}

	public void setPayAgencyHises(List<PayAgencyHis> payAgencyHises) {
		this.payAgencyHises = payAgencyHises;
	}

	public List<PayAgencyHis> getPayAgencyHises() {
		return payAgencyHises;
	}

	public void setDisposalPrice(String disposalPrice) {
		this.disposalPrice = disposalPrice;
	}

	public String getDisposalPrice() {
		return disposalPrice;
	}

	public void setRecvDisposalFee(String recvDisposalFee) {
		this.recvDisposalFee = recvDisposalFee;
	}

	public String getRecvDisposalFee() {
		return recvDisposalFee;
	}

	public void setRecvDisposalOverTag(String recvDisposalOverTag) {
		this.recvDisposalOverTag = recvDisposalOverTag;
	}

	public String getRecvDisposalOverTag() {
		return recvDisposalOverTag;
	}

	public void setRecvDisposalHis(RecvDisposalHis recvDisposalHis) {
		this.recvDisposalHis = recvDisposalHis;
	}

	public RecvDisposalHis getRecvDisposalHis() {
		return recvDisposalHis;
	}

	public void setRecvDisposalHises(List<RecvDisposalHis> recvDisposalHises) {
		this.recvDisposalHises = recvDisposalHises;
	}

	public List<RecvDisposalHis> getRecvDisposalHises() {
		return recvDisposalHises;
	}

	public void setRefundAgencyHis(RefundAgencyHis refundAgencyHis) {
		this.refundAgencyHis = refundAgencyHis;
	}

	public RefundAgencyHis getRefundAgencyHis() {
		return refundAgencyHis;
	}

	public void setRefundAgencyHises(List<RefundAgencyHis> refundAgencyHises) {
		this.refundAgencyHises = refundAgencyHises;
	}

	public List<RefundAgencyHis> getRefundAgencyHises() {
		return refundAgencyHises;
	}

	public void setRefundFee(String refundFee) {
		this.refundFee = refundFee;
	}

	public String getRefundFee() {
		return refundFee;
	}

	public void setRefundedFee(String refundedFee) {
		this.refundedFee = refundedFee;
	}

	public String getRefundedFee() {
		return refundedFee;
	}

	public void setRefundOverTag(String refundOverTag) {
		this.refundOverTag = refundOverTag;
	}

	public String getRefundOverTag() {
		return refundOverTag;
	}

	public String getRecvInterest() {
		return recvInterest;
	}

	public void setRecvInterest(String recvInterest) {
		this.recvInterest = recvInterest;
	}

	public File getFileObj() {
		return fileObj;
	}

	public void setFileObj(File fileObj) {
		this.fileObj = fileObj;
	}

	public String getLocalFileName() {
		return localFileName;
	}

	public void setLocalFileName(String localFileName) {
		this.localFileName = localFileName;
	}

	public void setPicId(Long picId) {
		this.picId = picId;
	}

	public Long getPicId() {
		return picId;
	}

	public Pic getPic() {
		return pic;
	}

	public void setPic(Pic pic) {
		this.pic = pic;
	}

	public List<Che300Brand> getChe300Brand() {
		return che300Brand;
	}

	public void setChe300Brand(List<Che300Brand> che300Brand) {
		this.che300Brand = che300Brand;
	}

	public int getBrand_id() {
		return brand_id;
	}

	public void setBrand_id(int brand_id) {
		this.brand_id = brand_id;
	}

	public int getSeries_id() {
		return series_id;
	}

	public void setSeries_id(int series_id) {
		this.series_id = series_id;
	}

	public int getModel_id() {
		return model_id;
	}

	public void setModel_id(int model_id) {
		this.model_id = model_id;
	}

	public String getRegist_month() {
		return regist_month;
	}

	public void setRegist_month(String regist_month) {
		this.regist_month = regist_month;
	}

	public double getMile_count() {
		return mile_count;
	}

	public void setMile_count(double mile_count) {
		this.mile_count = mile_count;
	}

	public static String getFinanceper() {
		return financePer;
	}

	public CheckOut getCheckOut() {
		return checkOut;
	}

	public void setCheckOut(CheckOut checkOut) {
		this.checkOut = checkOut;
	}
	
	
}
