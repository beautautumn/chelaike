package com.ct.erp.aop.service;

import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.util.Date;

import org.aspectj.lang.JoinPoint;
import org.aspectj.lang.annotation.AfterReturning;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.annotation.Pointcut;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.ct.erp.aop.dao.LogAspectDao;
import com.ct.erp.aop.dao.LogParamAspectDao;
import com.ct.erp.aop.model.AgencyJson;
import com.ct.erp.aop.model.FeeItemJson;
import com.ct.erp.aop.model.SiteAreaJSon;
import com.ct.erp.aop.model.StaffJson;
import com.ct.erp.aop.model.TradeJson;
import com.ct.erp.aop.model.VehicleJson;
import com.ct.erp.common.exception.ServiceException;
import com.ct.erp.core.security.SecurityUtils;
import com.ct.erp.core.security.SessionInfo;
import com.ct.erp.lib.entity.Agency;
import com.ct.erp.lib.entity.Agent;
import com.ct.erp.lib.entity.Contract;
import com.ct.erp.lib.entity.FeeItem;
import com.ct.erp.lib.entity.Log;
import com.ct.erp.lib.entity.LogParam;
import com.ct.erp.lib.entity.ManagerFee;
import com.ct.erp.lib.entity.Params;
import com.ct.erp.lib.entity.SiteArea;
import com.ct.erp.lib.entity.Staff;
import com.ct.erp.lib.entity.Sysmenu;
import com.ct.erp.lib.entity.Trade;
import com.ct.erp.lib.entity.Vehicle;
import com.ct.erp.rent.model.ContractBean;
import com.ct.erp.rent.model.ManagerFeeBean;
import com.ct.erp.sys.dao.SysmenuDao;
import com.ct.erp.sys.model.ParamsBean;
import com.ct.erp.util.UcmsWebUtils;


/**
 * AOP 日志记录
 * 
 * @author shiqingwen
 * 
 */

@Aspect
public class LogAspect {

	@Autowired
	private LogAspectDao logAspectDao;

	@Autowired
	private LogParamAspectDao logParamAspectDao;
	
	@Autowired
	private SysmenuDao sysmenuDao;
	
	//菜单项
	private static final  String businessHeadProcess = "com.ct.erp.list.service.DynamicViewShow.businessHeadProcess";

	/**
	 * 业务逻辑方法切入点
	 */
	@Pointcut(" ( execution(* com.ct.erp.carin.service.*.*(..)) ||" + " execution(* com.ct.erp.loan.service.*.*(..)) ||"
			+ " execution(* com.ct.erp.publish.service.*.*(..)) ||" + " execution(* com.ct.erp.rent.service.*.*(..)) ||"
			+ " execution(* com.ct.erp.sys.service.*.*(..))  ||"
			+ " execution(* com.ct.erp.list.service.DynamicViewShow.businessHeadProcess(..)) ||"
			+  "execution(* com.ct.erp.sys.service.base.*.*(..))) &&"
			+ " (!execution(* com.ct.erp.carin.service.*.find*(..)) &&"
			+ " !execution(* com.ct.erp.loan.service.*.find*(..)) &&"
			+ " !execution(* com.ct.erp.publish.service.*.find*(..)) &&"
			+ " !execution(* com.ct.erp.rent.service.*.find*(..)) &&"
			+ " !execution(* com.ct.erp.sys.service.*.find*(..)) &&"
			+ " !execution(* com.ct.erp.carin.service.*.get*(..)) &&"
			+ " !execution(* com.ct.erp.loan.service.*.get*(..)) &&"
			+ " !execution(* com.ct.erp.publish.service.*.get*(..)) &&"
			+ " !execution(* com.ct.erp.rent.service.*.get*(..)) &&"
			+ " !execution(* com.ct.erp.sys.service.*.get*(..)) &&"
			+ "!execution(* com.ct.erp.sys.service.base.*.find*(..)) &&"
			+ "!execution(* com.ct.erp.sys.service.base.*.get*(..)))")
	public void aspectPointCall() {
	}

	/**
	 * 管理员操作日志(后置通知)
	 * 
	 * @param joinPoint
	 * @param rtv
	 *
	 */
	@AfterReturning(value = "aspectPointCall()", argNames = "rtv", returning = "rtv")
	public void aspectPointCallCalls(JoinPoint joinPoint, Object rtv) {
		//实体类类型
		String enType = "";
		//员工管理、费用科目、场地区域、商户、车辆  公用
		StringBuilder commonInfo = new StringBuilder();
		//存放json
		StringBuilder entityJson = new StringBuilder();
		try {
			SessionInfo sessionInfo = SecurityUtils.getCurrentSessionInfo();
			if (sessionInfo != null) {
				// 用户id
				Long userId = sessionInfo.getStaffId();
				// 获取类名方法名
				String[] method = joinPoint.getSignature().toString().split(" ");
				String methodPathName = method[1];
				if (joinPoint.getArgs().length > 0) {
					//菜单功能模块
					if(methodPathName.contains(businessHeadProcess)){
						String viewId = (String)joinPoint.getArgs()[0];
						Sysmenu menu = sysmenuDao.findSysmenuByViewId(viewId);
						if(menu != null){
							String menuText = menu.getMenuText();
							Log log = new Log();
							log.setUserId(userId);
							log.setLogDescription("查看的菜单为："+menuText);
							log.setCreateTime(Timestamp.valueOf(new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date())));
							this.saveLog(log);
						}
						return;
					}
					//非菜单项
					for (Object info : joinPoint.getArgs()) {
						// 获得员工信息
						if (info instanceof Staff) {
							enType = "Staff";
							Staff staff = (Staff) info;
							StaffJson staffJson= new StaffJson(staff);
							entityJson.append(enType+":"+UcmsWebUtils.getJsonString(staffJson));
							// 员工名称
							String name = staff.getName();
							// 电话号码
							String tel = staff.getTel();
							commonInfo.append("(员工名称："+name+",电话号码："+tel+")");
							//费用科目
						}else if(info instanceof FeeItem){
							enType = "FeeItem";
							FeeItem feeItem =(FeeItem) info;
							FeeItemJson feeItemJson= new FeeItemJson(feeItem);
							entityJson.append(enType+":"+UcmsWebUtils.getJsonString(feeItemJson));
							//科目名称
							String itemName = feeItem.getItemName();
							commonInfo.append("(科目名称："+itemName+")");
							//场地区域
						}else if(info instanceof SiteArea){
							enType = "SiteArea";
							SiteArea siteArea = (SiteArea) info;
							SiteAreaJSon siteAreaJSon= new SiteAreaJSon(siteArea);
							entityJson.append(enType+":"+UcmsWebUtils.getJsonString(siteAreaJSon));
							//区域名称
							String areName = siteArea.getAreaName();
							commonInfo.append("(区域名称："+areName+")");
							//商户
						}else if(info instanceof Agency){
							enType = "Agency";
							Agency agency = (Agency) info;
							AgencyJson agencyJson = new AgencyJson(agency);
							entityJson.append(enType+":"+UcmsWebUtils.getJsonString(agencyJson));
							String agencyName =  agency.getAgencyName();
							if(agencyName != null){
								commonInfo.append("(商户名称："+agencyName+")");
							}
							//车辆
						}else if(info instanceof Trade){
							enType = "Trade";
							Trade trade = (Trade) info;
							TradeJson tradeJson = new TradeJson(trade);
							entityJson.append(enType+":"+UcmsWebUtils.getJsonString(tradeJson));
							if(trade.getVehicle() == null){
								continue;
							}
							Vehicle vehicle = trade.getVehicle();
							String shelfCode = vehicle.getShelfCode();
							if(shelfCode !=null){
								if(!commonInfo.toString().contains("车架号")){
									commonInfo.append("(车架号："+shelfCode+")");
								}
							}
							
						}else if(info instanceof Vehicle){
							enType = "Vehicle";
							Vehicle vehicle = (Vehicle) info;
							VehicleJson vehicleJson = new VehicleJson(vehicle);
							entityJson.append(enType+":"+UcmsWebUtils.getJsonString(vehicleJson));
							String shelfCode = vehicle.getShelfCode();
							if(shelfCode !=null){
								if(!commonInfo.toString().contains("车架号")){
									commonInfo.append("(车架号："+shelfCode+")");
								}
							}
						}else if(info instanceof Params){//系统参数
							enType = "Param";
							Params param = (Params) info;
							entityJson.append(enType+":"+UcmsWebUtils.getJsonString(param));
							String name = param.getParamName();
							commonInfo.append("(参数名称："+name+")");
						}else if(info instanceof ParamsBean){//系统参数
							enType = "ParamsBean";
							ParamsBean param = (ParamsBean) info;
							entityJson.append(enType+":"+UcmsWebUtils.getJsonString(param));
							String name = param.getParamName();
							commonInfo.append("(参数名称："+name+")");
						}else if(info instanceof Agent){//经纪人管理
							enType = "Agent";
							Agent param = (Agent) info;
							entityJson.append(enType+":"+UcmsWebUtils.getJsonString(param));
							String name = param.getName();
							commonInfo.append("(经纪人名称："+name+")");
						}else if(info instanceof ContractBean){//合同管理
							enType = "ContractBean";
							ContractBean param = (ContractBean) info;
							entityJson.append(enType+":"+UcmsWebUtils.getJsonString(param));
						}else if(info instanceof Contract){//合同管理
							enType = "Contract";
							Contract param = (Contract) info;
							entityJson.append(enType+":"+UcmsWebUtils.getJsonString(param));
						}else if(info instanceof ManagerFeeBean){//总费用录入
							enType = "ManagerFeeBean";
							ManagerFeeBean param = (ManagerFeeBean) info;
							entityJson.append(enType+":"+UcmsWebUtils.getJsonString(param));
						}else if(info instanceof ManagerFee){//总费用录入
							enType = "ManagerFee";
							ManagerFee param = (ManagerFee) info;
							entityJson.append(enType+":"+UcmsWebUtils.getJsonString(param));
						}
					}
					// 根据methodName查询描述tf_c_log_param
					LogParam logParam = logParamAspectDao.findlogParamById(methodPathName);
					if (logParam != null) {
						if (logParam.getDescription() != null) {
							Log log = new Log();
							log.setUserId(userId);
							if(!"".equals(enType)){
								log.setLogDescription(logParam.getDescription()+commonInfo.toString());
							}else{
								log.setLogDescription(logParam.getDescription());
							}
							log.setOperObjMes(entityJson.toString());
							log.setCreateTime(
									Timestamp.valueOf(new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date())));
							this.saveLog(log);
						}
					}
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	/**
	 * 保存日志表
	 * 
	 * @param log
	 */
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = ServiceException.class)
	public void saveLog(Log log) {
		logAspectDao.save(log);
	}

}
