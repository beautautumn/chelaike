package com.ct.erp.loan.service;

import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.ct.erp.carin.dao.TradeDao;
import com.ct.erp.common.exception.ServiceException;
import com.ct.erp.constants.sysconst.Const;
import com.ct.erp.core.security.SecurityUtils;
import com.ct.erp.lib.entity.Financing;
import com.ct.erp.lib.entity.OperHis;
import com.ct.erp.lib.entity.PayAgencyHis;
import com.ct.erp.lib.entity.PayOwnerHis;
import com.ct.erp.lib.entity.Pic;
import com.ct.erp.lib.entity.RecvCustHis;
import com.ct.erp.lib.entity.RecvDisposalHis;
import com.ct.erp.lib.entity.RefundAgencyHis;
import com.ct.erp.lib.entity.Staff;
import com.ct.erp.lib.entity.Trade;
import com.ct.erp.lib.entity.Vehicle;
import com.ct.erp.loan.dao.FinancingDao;
import com.ct.erp.loan.dao.PayAgencyHisDao;
import com.ct.erp.loan.dao.PayOwnerHisDao;
import com.ct.erp.loan.dao.RecvCustHisDao;
import com.ct.erp.loan.dao.RecvDisposalHisDao;
import com.ct.erp.loan.dao.RefundAgencyHisDao;
import com.ct.erp.loan.dao.VehicleDao;
import com.ct.erp.rent.dao.PicDao;
import com.ct.erp.sys.dao.OperHisDao;
import com.ct.erp.sys.service.base.StaffService;
import com.ct.erp.util.UcmsWebUtils;

@Service
public class LoanEvalService {
   @Autowired
   private VehicleDao vehicleDao;
   @Autowired
   private TradeDao tradeDao;
   @Autowired
   private PicDao picDao;
   @Autowired
   private FinancingDao financingDao;
   @Autowired
   private StaffService staffService;
   @Autowired
   private OperHisDao operHisDao;
   @Autowired
   private PayOwnerHisDao payOwnerHisDao;
   @Autowired
   private RecvCustHisDao recvCustHisDao;
   @Autowired
   private PayAgencyHisDao payAgencyHisDao;
   @Autowired
   private RecvDisposalHisDao recvDisposalHisDao;
   @Autowired
   private RefundAgencyHisDao refundAgencyHisDao;
            
   @Transactional(propagation = Propagation.REQUIRED, rollbackFor = ServiceException.class)
   public void doLoanVehicleCheck(Long tradeId,Long picId) throws Exception{
     //更新业务主表
     Trade trade = tradeDao.get(tradeId);
     trade.setState(Const.EVALUATED_STR);
     Trade nTrade = (Trade) tradeDao.update(trade);

     //操作历史
     OperHis operHis=new OperHis();    
     operHis.setStaff(staffService.findStaffById(SecurityUtils.getCurrentSessionInfo().getStaffId()));
     operHis.setOperTag("1");
     operHis.setOperTime(Timestamp.valueOf(new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date())));
     operHis.setOperDesc(SecurityUtils.getCurrentSessionInfo().getUserName()+" 进行了融资检测。 " );
     operHis.setOperObj(nTrade.getId());
     operHisDao.save(operHis);  
     //如果上传了行驶证照片
     if(picId!=null){
        Pic pic=this.picDao.get(picId);
        pic.setPicType(Const.FINANCING_PIC);
        pic.setObjId(nTrade.getId());
        this.picDao.update(pic);
     }
   }   
      
   
   @Transactional(propagation = Propagation.REQUIRED, rollbackFor = ServiceException.class)
   public void doLoanEval(Long tradeId,Financing financing) throws Exception{
	   Financing nFinancing =null;	  
	   if(financing.getId()!=null)
	   {
		  Financing eFinancing =financingDao.get(financing.getId());
		  eFinancing.setFinancingMax(financing.getFinancingMax());
		  eFinancing.setValuationFee(financing.getValuationFee());
		  eFinancing.setValuationDate(financing.getValuationDate());
		  eFinancing.setValuationDesc(financing.getValuationDesc());
		  eFinancing.setUpdateTime(UcmsWebUtils.now());
		  eFinancing.setStaffByValuationStaff(financing.getStaffByValuationStaff());
		  nFinancing =(Financing)financingDao.update(eFinancing);
	   }else
	   {
	      //更新融资表
	      financing.setCreateTime(UcmsWebUtils.now());
	      financing.setUpdateTime(UcmsWebUtils.now());
	      nFinancing = financingDao.save(financing);
	   }
	    //更新业务主表
	   Trade trade = tradeDao.get(tradeId);
	   trade.setFinancingTag("1");//库存融资车辆
	   trade.setFinancing(nFinancing);
	   trade.setState(Const.EVALUATED_STR);
	   trade.setValuationFee(nFinancing.getValuationFee().longValue());
	   Trade nTrade = (Trade) tradeDao.update(trade);

	   //操作历史
	   OperHis operHis=new OperHis();	   
	   operHis.setStaff(staffService.findStaffById(SecurityUtils.getCurrentSessionInfo().getStaffId()));
	   operHis.setOperTag("1");
	   operHis.setOperTime(Timestamp.valueOf(new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date())));
	   operHis.setOperDesc(SecurityUtils.getCurrentSessionInfo().getUserName()+" 设置了融资上限： "+UcmsWebUtils.yuanTowan(nFinancing.getFinancingMax())+" 万");
	   operHis.setOperObj(nTrade.getId());
	   operHisDao.save(operHis); 	
	
   }
   
 
   
  @Transactional(propagation = Propagation.REQUIRED, rollbackFor = ServiceException.class)
  public void doGatheringAgency(Long tradeId,String acquPrice,Financing financing) throws Exception{
    //更新融资表
    Financing eFinancing =financingDao.get(financing.getId());
    eFinancing.setFinancingFee(financing.getFinancingFee());
    eFinancing.setUpdateTime(UcmsWebUtils.now());
    eFinancing.setPrepareFee(financing.getPrepareFee());
    eFinancing.setLoanRate(financing.getLoanRate());
    eFinancing.setPrepareDate(financing.getPrepareDate());
    Staff staff= staffService.findById(financing.getStaffByPrepareStaff().getId());
    eFinancing.setStaffByPrepareStaff(staff);
    eFinancing.setPrepareDesc(financing.getPrepareDesc());
    Financing nFinancing =(Financing)financingDao.update(eFinancing);

       //更新业务主表
	   Trade trade = tradeDao.get(tradeId);
	   trade.setAcquPrice(UcmsWebUtils.wanToyuan(acquPrice).longValue());
	   trade.setState(Const.GATHERING_AGENCY_STR);
	   Trade nTrade = (Trade) tradeDao.update(trade);

	   //操作历史
	   OperHis operHis=new OperHis();	   
	   operHis.setStaff(staffService.findStaffById(SecurityUtils.getCurrentSessionInfo().getStaffId()));
	   operHis.setOperTag("1");
	   operHis.setOperTime(Timestamp.valueOf(new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date())));
	   operHis.setOperDesc(SecurityUtils.getCurrentSessionInfo().getUserName()+" 进行了商户预收操作： 设置预收人"+staff.getName()+" 预收款"+UcmsWebUtils.yuanTowan(nFinancing.getPrepareFee())+" 万");
	   operHis.setOperObj(nTrade.getId());
	   operHisDao.save(operHis);      
   }	
	
   
   @Transactional(propagation = Propagation.REQUIRED, rollbackFor = ServiceException.class)
   public void doPayOwner(Long tradeId,Financing financing,PayOwnerHis payOwnerHis) throws Exception{
	
	   //更新融资表 
	   Financing nFinancing =null;
	   Financing eFinancing =financingDao.get(financing.getId());
	   eFinancing.setPayedOwnerFee((eFinancing.getPayedOwnerFee()==null?0:eFinancing.getPayedOwnerFee())+payOwnerHis.getPayFee());
	   eFinancing.setRemainingFee((eFinancing.getRemainingFee()==null?0:eFinancing.getRemainingFee())-payOwnerHis.getPayFee());
	   eFinancing.setPayOverTag(financing.getPayOverTag());
	   eFinancing.setUpdateTime(UcmsWebUtils.now());
	   
	   if(eFinancing.getFirstPayDate()==null)
	   {
		   eFinancing.setFirstPayDate(payOwnerHis.getPayDate());
	   }
	   eFinancing.setStaffByValuationStaff(financing.getStaffByValuationStaff());
	   nFinancing = (Financing)financingDao.update(eFinancing);
	   
	   //更新业务主表
	   Trade trade = tradeDao.get(tradeId);
	   trade.setFinancingTag("1");//库存融资车辆
	   
	   String payOvertag =nFinancing.getPayOverTag();
	   if(payOvertag!=null && payOvertag.equals("1"))//付款完成记录状态才变化
	   {
 	       trade.setState(Const.PAID_CUST_STR);
	   }
	   Trade nTrade = (Trade) tradeDao.update(trade);

	   //付车主款历史
	   payOwnerHis.setFinancing(nFinancing);
	   payOwnerHisDao.save(payOwnerHis);
	   
	   //操作历史
	   OperHis operHis=new OperHis();	   
	   operHis.setStaff(staffService.findStaffById(SecurityUtils.getCurrentSessionInfo().getStaffId()));
	   operHis.setOperTag("1");
	   operHis.setOperTime(UcmsWebUtils.now());
	   operHis.setOperDesc(SecurityUtils.getCurrentSessionInfo().getUserName()+" 本次付款："+UcmsWebUtils.yuanTowan(payOwnerHis.getPayFee())+"万，总共付款车主： "+UcmsWebUtils.yuanTowan(nFinancing.getPayedOwnerFee())+" 万");
	   operHis.setOperObj(nTrade.getId());
	   operHisDao.save(operHis); 	
	
   } 
   
   @Transactional(propagation = Propagation.REQUIRED, rollbackFor = ServiceException.class)
   public void doGatheringBuyer(Long tradeId,String salePrice,Financing financing,RecvCustHis recvCustHis) throws Exception{
	
	   //更新融资表 
	   Financing nFinancing =null;
	   Financing eFinancing =financingDao.get(financing.getId());
	   eFinancing.setRecvSaleFee((eFinancing.getRecvSaleFee()==null?0:eFinancing.getRecvSaleFee())+recvCustHis.getRecvFee());
	   eFinancing.setRecvOverTag(financing.getRecvOverTag());
	   if(eFinancing.getFirstGatheringDate()==null)
	   {
		    eFinancing.setFirstGatheringDate(recvCustHis.getRecvDate());
	   }	   
	   eFinancing.setUpdateTime(UcmsWebUtils.now());
	   nFinancing = (Financing)financingDao.update(eFinancing);
	   
	   //更新业务主表
	   Trade trade = tradeDao.get(tradeId);
	   trade.setSalePrice(UcmsWebUtils.wanToyuan(salePrice).longValue());
	   String recvOvertag =nFinancing.getRecvOverTag();
	   if(recvOvertag!=null && recvOvertag.equals("1"))//收款完成才改变记录状态
	   {
	 	   trade.setState(Const.GATHERING_CUST_STR);
	   }

	   Trade nTrade = (Trade) tradeDao.update(trade);

	   //收销售款历史
	   recvCustHis.setFinancing(nFinancing);
	   recvCustHisDao.save(recvCustHis);
	   
	   //操作历史
	   OperHis operHis=new OperHis();	   
	   operHis.setStaff(staffService.findStaffById(SecurityUtils.getCurrentSessionInfo().getStaffId()));
	   operHis.setOperTag("1");
	   operHis.setOperTime(UcmsWebUtils.now());
	   operHis.setOperDesc(SecurityUtils.getCurrentSessionInfo().getUserName()+" 本次收款："+UcmsWebUtils.yuanTowan(recvCustHis.getRecvFee())+"万，收款合计： "+UcmsWebUtils.yuanTowan(nFinancing.getRecvSaleFee())+" 万");
	   operHis.setOperObj(nTrade.getId());
	   operHisDao.save(operHis); 	
	
   } 
   
   
   @Transactional(propagation = Propagation.REQUIRED, rollbackFor = ServiceException.class)
   public void doPayAgency(Long tradeId,Financing financing,PayAgencyHis payAgencyHis) throws Exception{
	   //更新业务主表
	   Trade trade = tradeDao.get(tradeId);
	   String payOvertag =financing.getPayAgencyOverTag()==null?"0":financing.getPayAgencyOverTag();
	   /*if(payOvertag.equals("1"))//付款完成记录状态才变化
	   {
 	       trade.setState(Const.PAID_AGENCY);
	   }
	   Trade nTrade = (Trade) tradeDao.update(trade);*/
	   
	   //更新融资表 
	   Financing nFinancing =null;
	   Financing eFinancing =financingDao.get(financing.getId());
	   eFinancing.setUsedDays(financing.getUsedDays());
	   eFinancing.setRepayBaseFee(financing.getRepayBaseFee());
	   eFinancing.setRepayInterest(financing.getRepayInterest());
	   eFinancing.setTransferFee(financing.getTransferFee());
	   //应付商户款=销售价格-应还款本金-应还款利息-过户费用；  
	   eFinancing.setPayAgencyTotalFee(financing.getPayAgencyTotalFee());
	   eFinancing.setPayedAgencyFee((eFinancing.getPayedAgencyFee()==null?0:eFinancing.getPayedAgencyFee())+payAgencyHis.getPayFee());
	   eFinancing.setPayAgencyOverTag(financing.getPayAgencyOverTag());
	   eFinancing.setUpdateTime(UcmsWebUtils.now());
	   eFinancing.setStaffByValuationStaff(financing.getStaffByValuationStaff());
	   nFinancing = (Financing)financingDao.update(eFinancing);
	  
	   //付车主款历史
	   payAgencyHis.setFinancing(nFinancing);
	   payAgencyHisDao.save(payAgencyHis);
	   
	   //操作历史
	   OperHis operHis=new OperHis();	   
	   operHis.setStaff(staffService.findStaffById(SecurityUtils.getCurrentSessionInfo().getStaffId()));
	   operHis.setOperTag("1");
	   operHis.setOperTime(UcmsWebUtils.now());
	   operHis.setOperDesc(SecurityUtils.getCurrentSessionInfo().getUserName()+" 本次付款给商户："+UcmsWebUtils.yuanTowan(payAgencyHis.getPayFee())+"万，总共付款给商户： "+UcmsWebUtils.yuanTowan(nFinancing.getPayedAgencyFee())+" 万");
	   operHis.setOperObj(trade.getId());
	   operHisDao.save(operHis); 	
	
   } 
   
   @Transactional(propagation = Propagation.REQUIRED, rollbackFor = ServiceException.class)
   public void doDisposalFinancing(Long tradeId,Financing financing,RecvDisposalHis recvDisposalHis) throws Exception{
	
	   //更新融资表 
	   Financing nFinancing =null;
	   Financing eFinancing =financingDao.get(financing.getId());
	   eFinancing.setDisposalPrice(financing.getDisposalPrice());
	   eFinancing.setRecvDisposalFee((eFinancing.getRecvDisposalFee()==null?0:eFinancing.getRecvDisposalFee())+recvDisposalHis.getRecvFee());
	   eFinancing.setRecvDisposalOverTag(financing.getRecvDisposalOverTag());
	   eFinancing.setRepayBaseFee(financing.getRepayBaseFee());
	   if(eFinancing.getFirstGatheringDate()==null)
	   {
		  eFinancing.setFirstGatheringDate(UcmsWebUtils.now());
	   }
	   eFinancing.setUpdateTime(UcmsWebUtils.now());
	   nFinancing = (Financing)financingDao.update(eFinancing);
	   
	   //更新业务主表
	   Trade trade = tradeDao.get(tradeId);
	   trade.setSalePrice(eFinancing.getDisposalPrice().longValue());
	   String tag =eFinancing.getRecvDisposalOverTag()==null?"0":eFinancing.getRecvDisposalOverTag();
	   if(tag.equals("1"))//收款完成才改变记录状态
	   {
	 	   trade.setState(Const.GATHERING_DISPOSAL_STR);
	   }
	   Trade nTrade = (Trade) tradeDao.update(trade);

	   //收处置款历史
	   recvDisposalHis.setFinancing(nFinancing);
	   recvDisposalHisDao.save(recvDisposalHis);
	   
	   //操作历史
	   OperHis operHis=new OperHis();	   
	   operHis.setStaff(staffService.findStaffById(SecurityUtils.getCurrentSessionInfo().getStaffId()));
	   operHis.setOperTag("1");
	   operHis.setOperTime(UcmsWebUtils.now());
	   operHis.setOperDesc(SecurityUtils.getCurrentSessionInfo().getUserName()+" 本次收处置款："+UcmsWebUtils.yuanTowan(recvDisposalHis.getRecvFee())+"万，收处置款合计： "+UcmsWebUtils.yuanTowan(nFinancing.getRecvDisposalFee())+" 万");
	   operHis.setOperObj(nTrade.getId());
	   operHisDao.save(operHis); 	
	
   }    

   
   @Transactional(propagation = Propagation.REQUIRED, rollbackFor = ServiceException.class)
   public void doRefundAgency(Long tradeId,Financing financing,RefundAgencyHis refundAgencyHis) throws Exception{
	
	   //更新融资表 
	   Financing nFinancing =null;
	   Financing eFinancing =financingDao.get(financing.getId());
	   eFinancing.setRefundFee(financing.getRefundFee());
	   eFinancing.setRefundedFee((eFinancing.getRefundedFee()==null?0:eFinancing.getRefundedFee())+refundAgencyHis.getRefundFee());
	   
	   eFinancing.setRefundOverTag(financing.getRefundOverTag());
	   eFinancing.setUpdateTime(UcmsWebUtils.now());
	   nFinancing = (Financing)financingDao.update(eFinancing);
	   
	   //更新业务主表
	   Trade trade = tradeDao.get(tradeId);
	   //trade.setSalePrice(eFinancing.getDisposalPrice().longValue());
	   String tag =eFinancing.getRefundOverTag()==null?"0":eFinancing.getRefundOverTag();
	   /*if(tag.equals("1"))//收款完成才改变记录状态
	   {
	 	   trade.setState(Const.REFUND_AGENCY);
	   }
	   Trade nTrade = (Trade) tradeDao.update(trade);*/

	   //退商户款历史
	   refundAgencyHis.setFinancing(nFinancing);
	   refundAgencyHisDao.save(refundAgencyHis);
	   
	   //操作历史
	   OperHis operHis=new OperHis();	   
	   operHis.setStaff(staffService.findStaffById(SecurityUtils.getCurrentSessionInfo().getStaffId()));
	   operHis.setOperTag("1");
	   operHis.setOperTime(UcmsWebUtils.now());
	   operHis.setOperDesc(SecurityUtils.getCurrentSessionInfo().getUserName()+" 本次退款款："+UcmsWebUtils.yuanTowan(refundAgencyHis.getRefundFee())+"万，已退款总额： "+UcmsWebUtils.yuanTowan(nFinancing.getRefundedFee())+" 万");
	   operHis.setOperObj(trade.getId());
	   operHisDao.save(operHis); 		
   }      
   
   
   public List<PayOwnerHis> getPayOwnerHisList(Long financingId) throws Exception{
	   return payOwnerHisDao.findListByFinancingId(financingId);
   }

   public List<RecvCustHis> getRecvCustHisList(Long financingId) throws Exception{
	   return recvCustHisDao.findListByFinancingId(financingId);
   }   
   
   public List<PayAgencyHis> getPayAgencyHisList(Long financingId) throws Exception{
	   return payAgencyHisDao.findListByFinancingId(financingId);
   }
   
   public List<RecvDisposalHis> getPayDisposalHisList(Long financingId) throws Exception{
	   return recvDisposalHisDao.findListByFinancingId(financingId);
   }
     
   public List<RefundAgencyHis> getRefundAgencyHisList(Long financingId) throws Exception{
	   return refundAgencyHisDao.findListByFinancingId(financingId);
   }  
   public Vehicle  getVehicleInfo(Long tradeId) throws Exception{
	   return  vehicleDao.findVehicleByTradeId(tradeId);
   }
      
   public Trade getTradeById(Long tradeId) throws Exception{
	   return tradeDao.get(tradeId);
   }
   
   public Pic getLoanVehicleCheck(Long tradeId) throws Exception{
     return picDao.findVehicleCheckPic(tradeId);
   }

   @Transactional(propagation = Propagation.REQUIRED, rollbackFor = ServiceException.class)
	public void deleteRep(Pic pic) {
		this.picDao.delete(pic);
	}
   
   
   
}
