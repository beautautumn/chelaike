package com.ct.erp.api.web;

import java.io.PrintWriter;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.List;

import org.apache.commons.httpclient.HttpClient;
import org.apache.commons.httpclient.HttpStatus;
import org.apache.commons.httpclient.NameValuePair;
import org.apache.commons.httpclient.methods.PostMethod;
import org.apache.commons.httpclient.params.HttpMethodParams;
import org.apache.struts2.ServletActionContext;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Controller;

import com.ct.erp.api.model.Result;
import com.ct.erp.api.model.ResultParam;
import com.ct.erp.api.model.TradeBean;
import com.ct.erp.api.model.VehicleBean;
import com.ct.erp.api.model.VehiclePicBean;
import com.ct.erp.carin.service.TradeInfoService;
import com.ct.erp.carin.web.VehicleAction;
import com.ct.erp.common.model.InterfaceRes;
import com.ct.erp.common.utils.Struts2Utils;
import com.ct.erp.common.web.SimpleActionSupport;
import com.ct.erp.constants.sysconst.Const;
import com.ct.erp.lib.entity.Agency;
import com.ct.erp.lib.entity.Brand;
import com.ct.erp.lib.entity.Kind;
import com.ct.erp.lib.entity.Series;
import com.ct.erp.lib.entity.Trade;
import com.ct.erp.lib.entity.Vehicle;
import com.ct.erp.lib.entity.VehiclePic;
import com.ct.erp.loan.dao.VehicleDao;
import com.ct.erp.rent.service.AgencyService;

@Scope("prototype")
@Controller("api.auctionInfoAction")
public class AuctionInfoAction extends SimpleActionSupport {
	private static final Logger log = LoggerFactory
			.getLogger(VehicleAction.class);
	private static final String push_url = Const.PUSH_URL;
	private List<Agency> agencys = new ArrayList<Agency>();
	private Trade trade;
	private Long tradeId;
	private Vehicle vehicle;
	private List<VehiclePic> vehiclePic = new ArrayList<VehiclePic>();
	private int length;
	private String title;
	private String content;
	private String source;
	private String addr;
	private String basePrice;
	private Long vehicleId;

	@Autowired
	private AgencyService agencyService;
	@Autowired
	private TradeInfoService tradeInfoService;
	@Autowired
	private VehicleDao vehicleDao;

	// to拍卖商品表单
	public String toAuctionInfo() throws Exception {
		String agent = ServletActionContext.getRequest()
				.getHeader("user-agent");
		try {
			setAgencys(agencyService.findValidAgencyList());
			if(tradeId!=null){
				trade = tradeInfoService.getTradeById(tradeId);
				this.vehiclePic = tradeInfoService.getPicListByTradeId(tradeId);
			}
			if(trade!=null){
				vehicle = trade.getVehicle();
			}else{
				vehicle = this.vehicleDao.get(vehicleId);
			}
			if (vehicle.getBrand() == null)
				vehicle.setBrand(new Brand());
			if (vehicle.getSeries() == null)
				vehicle.setSeries(new Series());
			if (vehicle.getKind() == null)
				vehicle.setKind(new Kind());

			

		} catch (Exception e) {
			log.error("toAuctionInfo", e);
		}
		if (checkRequestFrom(agent)) {
			return "auctionInfo";
		} else {
			return "auctionInfoPhone";
		}
	}
	
	
	
	// to拍卖商品Json数据
	public void toAuctionJsonInfo() throws Exception {
		String agent = ServletActionContext.getRequest()
				.getHeader("user-agent");
		Result result = new Result();
		try {
			ResultParam resultParam = new ResultParam();
			setAgencys(agencyService.findValidAgencyList());
			TradeBean tradeBean = new TradeBean();
			trade = tradeInfoService.getTradeById(tradeId);
			if(trade!=null){
				tradeBean.setId(trade.getId());
				tradeBean.setAcquPrice(trade.getAcquPrice());
				tradeBean.setAgencyName(trade.getAgency().getAgencyName());
				tradeBean.setBarCode(trade.getBarCode());
				tradeBean.setOldLicenseCode(trade.getOldLicenseCode());
				tradeBean.setVehicleId(trade.getVehicle().getId());
				vehicle = trade.getVehicle();
			}else{
				vehicle = this.vehicleDao.get(this.vehicleId);
			}
			VehicleBean vehicleBean = new VehicleBean();
			vehicleBean.setId(vehicle.getId());
			vehicleBean.setBrandName(vehicle.getBrandName());
			vehicleBean.setCarColor(vehicle.getCarColor());
			vehicleBean.setCheckValidMonth(vehicle.getCheckValidMonth());
			vehicleBean.setCommIssurValidDate(vehicle.getCommIssurValidDate());
			vehicleBean.setCondDesc(vehicle.getCondDesc());
			vehicleBean.setEngineNumber(vehicle.getEngineNumber());
			if(("0").equals(vehicle.getEnvLevel())){
				vehicleBean.setEnvLevel("国I");
			}else if(("1").equals(vehicle.getEnvLevel())){
				vehicleBean.setEnvLevel("国II");
			}else if(("2").equals(vehicle.getEnvLevel())){
				vehicleBean.setEnvLevel("国III");
			}else if(("3").equals(vehicle.getEnvLevel())){
				vehicleBean.setEnvLevel("国V");
			}
			vehicleBean.setFactoryDate(vehicle.getFactoryDate() == null ? "" : new SimpleDateFormat("yyyy-MM-dd").format(vehicle.getFactoryDate()));
			if(("0").equals(vehicle.getGearType())){
				vehicleBean.setGearType("手动");
			}else if(("1").equals(vehicle.getGearType())){
				vehicleBean.setGearType("自动");
			}else if(("2").equals(vehicle.getGearType())){
				vehicleBean.setGearType("手自一体");
			}else if(("3").equals(vehicle.getGearType())){
				vehicleBean.setGearType("其它");
			}
			vehicleBean.setIssurValidDate(vehicle.getIssurValidDate());
			vehicleBean.setKindName(vehicle.getKindName());
			vehicleBean.setMileageCount(vehicle.getMileageCount());
			vehicleBean.setNewcarPrice(vehicle.getNewcarPrice());
			if(("1").equals(vehicle.getOutputVolumeU())){
				vehicleBean.setOutputVolume(vehicle.getOutputVolume()+"T");
			}else{
				vehicleBean.setOutputVolume(vehicle.getOutputVolume()+"L");
			}
			vehicleBean.setRegistMonth(vehicle.getRegistMonth());
			vehicleBean.setSeriesName(vehicle.getSeriesName());
			vehicleBean.setShelfCode(vehicle.getShelfCode());
			vehicleBean.setUpholsteryColor(vehicle.getUpholsteryColor());
			if(("0").equals(vehicle.getUsedType())){
				vehicleBean.setUsedType("非运营");
			}else if(("1").equals(vehicle.getUsedType())){
				vehicleBean.setUsedType("运营");
			}else if(("2").equals(vehicle.getUsedType())){
				vehicleBean.setUsedType("营转非");
			}
			if(("0").equals(vehicle.getVehicleType())){
				vehicleBean.setVehicleType("轿车");
			}else if(("1").equals(vehicle.getVehicleType())){
				vehicleBean.setVehicleType("跑车");
			}else if(("2").equals(vehicle.getVehicleType())){
				vehicleBean.setVehicleType("越野车");
			}else if(("3").equals(vehicle.getVehicleType())){
				vehicleBean.setVehicleType("商务车");
			}
			this.vehiclePic = tradeInfoService.getPicListByTradeId(tradeId);
			List<VehiclePicBean> vehiclePicBeanList = new ArrayList<VehiclePicBean>();
			for(VehiclePic pic : vehiclePic){
				VehiclePicBean picBean = new VehiclePicBean();
				picBean.setId(pic.getId());
				picBean.setPicUrl(pic.getPicUrl());
				vehiclePicBeanList.add(picBean);
			}
			resultParam.setTrade(tradeBean);
			resultParam.setVehicle(vehicleBean);
			resultParam.setVehiclePicList(vehiclePicBeanList);
			result.setData(resultParam);
			result.setRes(this.getInterfaceRes("0000", "成功", "0"));
			Struts2Utils.renderJson(result);
		} catch (Exception e) {
			log.error("toAuctionInfo", e);
			result.setRes(this.getInterfaceRes("0001", "失败", "2"));
			Struts2Utils.renderJson(result);
		}
	}
	
	
	
	// to拍卖商品Json数据
		public void toAuctionVechielJsonInfo() throws Exception {
			Result result = new Result();
			try {
				ResultParam resultParam = new ResultParam();
				setAgencys(agencyService.findValidAgencyList());
				TradeBean tradeBean = new TradeBean();
				trade = tradeInfoService.getTradeByVehicleId(this.vehicleId);
				if(trade!=null){
					tradeBean.setId(trade.getId());
					tradeBean.setAcquPrice(trade.getAcquPrice());
					tradeBean.setAgencyName(trade.getAgency().getAgencyName());
					tradeBean.setBarCode(trade.getBarCode());
					tradeBean.setOldLicenseCode(trade.getOldLicenseCode());
					tradeBean.setVehicleId(trade.getVehicle().getId());
					vehicle = trade.getVehicle();
				}else{
					vehicle = this.vehicleDao.get(this.vehicleId);
				}
				VehicleBean vehicleBean = new VehicleBean();
				vehicleBean.setId(vehicle.getId());
				vehicleBean.setBrandName(vehicle.getBrandName());
				vehicleBean.setCarColor(vehicle.getCarColor());
				vehicleBean.setCheckValidMonth(vehicle.getCheckValidMonth());
				vehicleBean.setCommIssurValidDate(vehicle.getCommIssurValidDate());
				vehicleBean.setCondDesc(vehicle.getCondDesc());
				vehicleBean.setEngineNumber(vehicle.getEngineNumber());
				if(("0").equals(vehicle.getEnvLevel())){
					vehicleBean.setEnvLevel("国I");
				}else if(("1").equals(vehicle.getEnvLevel())){
					vehicleBean.setEnvLevel("国II");
				}else if(("2").equals(vehicle.getEnvLevel())){
					vehicleBean.setEnvLevel("国III");
				}else if(("3").equals(vehicle.getEnvLevel())){
					vehicleBean.setEnvLevel("国V");
				}
				vehicleBean.setFactoryDate(vehicle.getFactoryDate() == null ? "" : new SimpleDateFormat("yyyy-MM-dd").format(vehicle.getFactoryDate()));
				if(("0").equals(vehicle.getGearType())){
					vehicleBean.setGearType("手动");
				}else if(("1").equals(vehicle.getGearType())){
					vehicleBean.setGearType("自动");
				}else if(("2").equals(vehicle.getGearType())){
					vehicleBean.setGearType("手自一体");
				}else if(("3").equals(vehicle.getGearType())){
					vehicleBean.setGearType("其它");
				}
				vehicleBean.setIssurValidDate(vehicle.getIssurValidDate());
				vehicleBean.setKindName(vehicle.getKindName());
				vehicleBean.setMileageCount(vehicle.getMileageCount());
				vehicleBean.setNewcarPrice(vehicle.getNewcarPrice());
				if(("1").equals(vehicle.getOutputVolumeU())){
					vehicleBean.setOutputVolume(vehicle.getOutputVolume()+"T");
				}else{
					vehicleBean.setOutputVolume(vehicle.getOutputVolume()+"L");
				}
				vehicleBean.setRegistMonth(vehicle.getRegistMonth());
				vehicleBean.setSeriesName(vehicle.getSeriesName());
				vehicleBean.setShelfCode(vehicle.getShelfCode());
				vehicleBean.setUpholsteryColor(vehicle.getUpholsteryColor());
				if(("0").equals(vehicle.getUsedType())){
					vehicleBean.setUsedType("非运营");
				}else if(("1").equals(vehicle.getUsedType())){
					vehicleBean.setUsedType("运营");
				}else if(("2").equals(vehicle.getUsedType())){
					vehicleBean.setUsedType("营转非");
				}
				if(("0").equals(vehicle.getVehicleType())){
					vehicleBean.setVehicleType("轿车");
				}else if(("1").equals(vehicle.getVehicleType())){
					vehicleBean.setVehicleType("跑车");
				}else if(("2").equals(vehicle.getVehicleType())){
					vehicleBean.setVehicleType("越野车");
				}else if(("3").equals(vehicle.getVehicleType())){
					vehicleBean.setVehicleType("商务车");
				}
				this.vehiclePic = tradeInfoService.getPicListByTradeId(tradeId);
				List<VehiclePicBean> vehiclePicBeanList = new ArrayList<VehiclePicBean>();
				for(VehiclePic pic : vehiclePic){
					VehiclePicBean picBean = new VehiclePicBean();
					picBean.setId(pic.getId());
					picBean.setPicUrl(pic.getPicUrl());
					vehiclePicBeanList.add(picBean);
				}
				resultParam.setTrade(tradeBean);
				resultParam.setVehicle(vehicleBean);
				resultParam.setVehiclePicList(vehiclePicBeanList);
				result.setData(resultParam);
				result.setRes(this.getInterfaceRes("0000", "成功", "0"));
				Struts2Utils.renderJson(result);
			} catch (Exception e) {
				e.printStackTrace();
				log.error("toAuctionInfo", e);
				result.setRes(this.getInterfaceRes("0001", "失败", "2"));
				Struts2Utils.renderJson(result);
			}
		}
	
	
	
	
	
	
	public void push() throws Exception{
		HttpClient httpClient = new HttpClient();
		this.trade = this.tradeInfoService.getTradeById(this.tradeId);
		this.vehicle = this.trade.getVehicle();
		String title = this.vehicle.getRegistMonth().substring(2,4)+"年 "+
				this.vehicle.getBrandName()+"-"+this.vehicle.getSeriesName()+" "
				+this.vehicle.getMileageCount()+"公里";
		String rJson = "";
		PrintWriter out = ServletActionContext.getResponse().getWriter();
  		PostMethod method = new PostMethod(push_url);
  		method.getParams().setParameter(HttpMethodParams.HTTP_CONTENT_CHARSET, "UTF-8");
  		NameValuePair[] data = {
  				new NameValuePair("title",title),
  				new NameValuePair("content","content"),
  				new NameValuePair("source","source"),
  				new NameValuePair("addr",Const.AUCTION),
  				new NameValuePair("basePrice",this.trade.getShowPrice()==null ? "0" : this.trade.getShowPrice().toString()),
  				new NameValuePair("vehicleId",this.vehicle.getId().toString())
  		};
  		method.setRequestBody(data);
  		try {
			int statusCode = httpClient.executeMethod(method);
			
			if (method.getStatusCode() == HttpStatus.SC_OK) { 
            	rJson = method.getResponseBodyAsString(); 
            	out.write(rJson);
            }
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}finally{
			out.flush();
			out.close();
		}
	}
	
	public InterfaceRes getInterfaceRes(String code, String desc, String type) {
		InterfaceRes res = new InterfaceRes();
		res.setCode(code);
		res.setDesc(desc);
		res.setProcsTime(String.valueOf(System.currentTimeMillis() / 1000));
		res.setType(type);
		return res;
	}

	private boolean checkRequestFrom(String agent) {
		// 排除 苹果桌面系统
		if (agent.contains("Windows NT") || agent.contains("Macintosh")) {
			return true;
		} else {
			return false;
		}
	}

	public List<Agency> getAgencys() {
		return agencys;
	}

	public void setAgencys(List<Agency> agencys) {
		this.agencys = agencys;
	}

	public Trade getTrade() {
		return trade;
	}

	public void setTrade(Trade trade) {
		this.trade = trade;
	}

	public Long getTradeId() {
		return tradeId;
	}

	public void setTradeId(Long tradeId) {
		this.tradeId = tradeId;
	}

	public Vehicle getVehicle() {
		return vehicle;
	}

	public void setVehicle(Vehicle vehicle) {
		this.vehicle = vehicle;
	}

	public int getLength() {
		return length;
	}

	public void setLength(int length) {
		this.length = length;
	}

	public List<VehiclePic> getVehiclePic() {
		return vehiclePic;
	}

	public void setVehiclePic(List<VehiclePic> vehiclePic) {
		this.vehiclePic = vehiclePic;
	}

	public String getTitle() {
		return title;
	}

	public void setTitle(String title) {
		this.title = title;
	}

	public String getContent() {
		return content;
	}

	public void setContent(String content) {
		this.content = content;
	}

	public String getSource() {
		return source;
	}

	public void setSource(String source) {
		this.source = source;
	}

	public String getAddr() {
		return addr;
	}

	public void setAddr(String addr) {
		this.addr = addr;
	}

	public String getBasePrice() {
		return basePrice;
	}

	public void setBasePrice(String basePrice) {
		this.basePrice = basePrice;
	}



	public Long getVehicleId() {
		return vehicleId;
	}



	public void setVehicleId(Long vehicleId) {
		this.vehicleId = vehicleId;
	}

}
