package com.ct.erp.task.service;

import java.sql.Timestamp;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.List;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.ct.erp.carin.dao.TradeDao;
import com.ct.erp.che3bao.dao.VehiclePicDao;
import com.ct.erp.common.exception.ServiceException;
import com.ct.erp.common.service.CommonService;
import com.ct.erp.common.utils.SysUtils;
import com.ct.erp.constants.sysconst.Const;
import com.ct.erp.lib.entity.Agency;
import com.ct.erp.lib.entity.AgencySync;
import com.ct.erp.lib.entity.Carport;
import com.ct.erp.lib.entity.Trade;
import com.ct.erp.lib.entity.Vehicle;
import com.ct.erp.lib.entity.VehiclePic;
import com.ct.erp.lib.entity.VehicleSync;
import com.ct.erp.loan.dao.VehicleDao;
import com.ct.erp.rent.dao.AgencyDao;
import com.ct.erp.rent.dao.CarportDao;
import com.ct.erp.sys.dao.BrandDao;
import com.ct.erp.sys.dao.KindDao;
import com.ct.erp.sys.dao.ParamsDao;
import com.ct.erp.sys.dao.SeriesDao;
import com.ct.erp.task.AutoGetTransferInfoJob;
import com.ct.erp.task.dao.AgencySyncDao;
import com.ct.erp.task.dao.VehicleSyncDao;
import com.ct.erp.util.HttpUtils;
import com.ct.erp.util.UcmsWebUtils;
import com.google.gson.JsonObject;

@Service
@Transactional(propagation = Propagation.SUPPORTS)
public class SyncVehicleServiceBack {
	private static final Logger log = LoggerFactory
			.getLogger(SyncVehicleServiceBack.class);

	@Autowired
	private VehicleSyncDao vehicleSyncDao;
	@Autowired
	private TradeDao tradeDao;
	@Autowired
	private AgencyDao agencyDao;
	@Autowired
	private BrandDao brandDao;
	@Autowired
	private SeriesDao seriesDao;
	@Autowired
	private KindDao kindDao;
	@Autowired
	private VehicleDao vehicleDao;
	@Autowired
	private VehiclePicDao vehiclePicDao;
	@Autowired
	private AgencySyncDao agencySyncDao;
	@Autowired
	private CarportDao carportDao;
	@Autowired
	private CommonService commonService;

	@Transactional(propagation = Propagation.NOT_SUPPORTED, readOnly = true)
	List<Trade> getUnSyncVehicle() throws Exception {
		return tradeDao.getOnSaleList();
	}

	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = ServiceException.class)
	public void doSyncVehicleInfo() throws Exception {

		List<Trade> list = getUnSyncVehicle();
		if (list == null || list.size() == 0)
			return;
		for (int i = 0; i < list.size(); i++) {
			Trade trade = list.get(i);
			doGetVehicleInfo(trade);
		}

	}

	/**
	 * 获取过户信息
	 * 
	 * @throws Exception
	 */
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
	void doUpdateVehicle(Trade trade, String jsonStr) throws Exception {
		JSONObject obj = JSONObject.fromObject(jsonStr);

		if (!obj.getBoolean("success"))
			return;
		JSONObject stock = obj.getJSONObject("data").getJSONObject("result")
				.getJSONObject("stock");
		JSONObject vehicle1 = obj.getJSONObject("data").getJSONObject("result")
				.getJSONObject("vehicle");
		JSONObject buy = obj.getJSONObject("data").getJSONObject("result")
				.getJSONObject("buy");
		JSONObject sale = obj.getJSONObject("data").getJSONObject("result")
				.getJSONObject("sale");
		// todo 解析并保持车辆数据
		Vehicle vehicle = trade.getVehicle();
		if (!(vehicle1.getString("brandId").equals("null") || vehicle1
				.getString("brandId").equals("")))
			vehicle.setBrand(this.brandDao.get(vehicle1.getLong("brandId")));
		if (!(vehicle1.getString("brandName").equals("null") || vehicle1
				.getString("brandName").equals("")))
			vehicle.setBrandName(vehicle1.getString("brandName"));
		if (!(vehicle1.getString("seriesId").equals("null") || vehicle1
				.getString("seriesId").equals("")))
			vehicle.setSeries(this.seriesDao.get(vehicle1.getLong("seriesId")));
		if (!(vehicle1.getString("seriesName").equals("null") || vehicle1
				.getString("seriesName").equals("")))
			vehicle.setSeriesName(vehicle1.getString("seriesName"));
		if (!(vehicle1.getString("kindId").equals("null") || vehicle1
				.getString("kindId").equals("")))
			vehicle.setKind(this.kindDao.get(vehicle1.getLong("kindId")));
		if (!(vehicle1.getString("kindName").equals("null") || vehicle1
				.getString("kindName").equals("")))
			vehicle.setKindName(vehicle1.getString("kindName"));
		if (!(vehicle1.getString("shelfCode").equals("null") || vehicle1
				.getString("shelfCode").equals("")))
			vehicle.setShelfCode(vehicle1.getString("shelfCode"));
		if (!(vehicle1.getString("licenseCode").equals("null") || vehicle1
				.getString("licenseCode").equals("")))
			vehicle.setLicenseCode(vehicle1.getString("licenseCode"));
		if (!(vehicle1.getString("registMonth").equals("null") || vehicle1
				.getString("registMonth").equals("")))
			vehicle.setRegistMonth(vehicle1.getString("registMonth"));
		if (!(vehicle1.getString("outputVolume").equals("null") || vehicle1
				.getString("outputVolume").equals("")))
			vehicle.setOutputVolume(vehicle1.getString("outputVolume"));
		if (!(vehicle1.getString("gearType").equals("null") || vehicle1
				.getString("gearType").equals("")))
			vehicle.setGearType(vehicle1.getString("gearType"));
		if (!(vehicle1.getString("carColor").equals("null") || vehicle1
				.getString("carColor").equals("")))
			vehicle.setCarColor(vehicle1.getString("carColor"));
		if (!(vehicle1.getString("upholsteryColor").equals("null") || vehicle1
				.getString("upholsteryColor").equals("")))
			vehicle.setUpholsteryColor(vehicle1.getString("upholsteryColor"));
		if (!(vehicle1.getString("vehicleType").equals("null") || vehicle1
				.getString("vehicleType").equals("")))
			vehicle.setVehicleType(vehicle1.getString("vehicleType"));
		if (!(vehicle1.getString("usedType").equals("null") || vehicle1
				.getString("usedType").equals("")))
			vehicle.setUsedType(vehicle1.getString("usedType"));
		if (!(vehicle1.getString("engineNumber").equals("null") || vehicle1
				.getString("engineNumber").equals("")))
			vehicle.setEngineNumber(vehicle1.getString("engineNumber"));
		if (!(vehicle1.getString("oilType").equals("null") || vehicle1
				.getString("oilType").equals("")))
			vehicle.setOilType(vehicle1.getString("oilType"));
		if (!(vehicle1.getString("factoryDate").equals("null") || vehicle1
				.getString("factoryDate").equals("")))
			vehicle.setFactoryDate(new SimpleDateFormat("yyyy-MM")
					.parse(vehicle1.getString("factoryDate")));
		if (!(stock.getString("newcarPrice").equals("null") || stock.getString(
				"newcarPrice").equals("")))
			vehicle.setNewcarPrice(UcmsWebUtils.fenToYuan(stock.getLong("newcarPrice")).toString());
		if (!(vehicle1.getString("issurValidDate").equals("null") || vehicle1
				.getString("issurValidDate").equals("")))
			vehicle.setIssurValidDate(vehicle1.getString("issurValidDate"));
		if (!(vehicle1.getString("commIssurValidDate").equals("null") || vehicle1
				.getString("commIssurValidDate").equals("")))
			vehicle.setCommIssurValidDate(vehicle1
					.getString("commIssurValidDate"));
		if (!(vehicle1.getString("checkValidMonth").equals("null") || vehicle1
				.getString("checkValidMonth").equals("")))
			vehicle.setCheckValidMonth(vehicle1.getString("checkValidMonth"));
		if (!(vehicle1.getString("envLevel").equals("null") || vehicle1
				.getString("envLevel").equals("")))
			vehicle.setEnvLevel(vehicle1.getString("envLevel"));
		if (!(vehicle1.getString("condDesc").equals("null") || vehicle1
				.getString("condDesc").equals("")))
			vehicle.setCondDesc(vehicle1.getString("condDesc"));
		if (!(vehicle1.getString("mileageCount").equals("null") || vehicle1
				.getString("mileageCount").equals("")))
			vehicle.setMileageCount(vehicle1.getString("mileageCount"));
		if (!(vehicle1.getString("updateTime").equals("null") || vehicle1
				.getString("updateTime").equals("")))
			vehicle.setUpdateTime(Timestamp.valueOf(vehicle1
					.getString("updateTime")));
		if (!(vehicle1.getString("createTime").equals("null") || vehicle1
				.getString("createTime").equals("")))
			vehicle.setCreateTime(Timestamp.valueOf(vehicle1
					.getString("createTime")));
		this.vehicleDao.update(vehicle);

		/*Agency agency = this.agencyDao.getByOutId(stock.getLong("agencyId"));
		trade.setAgency(agency);*/
		Agency agency = trade.getAgency();
		trade.setVehicle(vehicle);
		if (!(vehicle1.getString("oldLicensecode").equals("null") || vehicle1
				.getString("oldLicensecode").equals("")))
			trade.setOldLicenseCode(vehicle1.getString("oldLicensecode"));
		if (!(vehicle1.getString("newLicensecode").equals("null") || vehicle1
				.getString("newLicensecode").equals("")))
			trade.setNewLicenseCode(vehicle1.getString("newLicensecode"));
		if (!(buy.toString().equals("null")
				|| buy.getString("acquPrice").equals("null") || buy.getString(
				"acquPrice").equals("")))
			trade.setAcquPrice(UcmsWebUtils.fenToYuan(buy.getLong("acquPrice")));
		if (!(stock.getString("showPrice").equals("null") || stock.getString(
				"showPrice").equals("")))
			trade.setShowPrice(UcmsWebUtils.fenToYuan(stock
					.getLong("showPrice")));
		if (!(sale.toString().equals("null")
				|| sale.getString("salePrice").equals("null") || sale
				.getString("salePrice").equals("")))
			trade.setSalePrice(UcmsWebUtils.fenToYuan(sale.getLong("salePrice")));
		if (!(stock.getString("comeDate").equals("null") || stock.getString(
				"comeDate").equals("")))
			trade.setComeDate(new SimpleDateFormat("yyyy-MM-dd").parse(stock
					.getString("comeDate")));
		if (!(stock.getString("goDate").equals("null") || stock.getString(
				"goDate").equals("")))
			trade.setGoDate(new SimpleDateFormat("yyyy-MM-dd").parse(stock
					.getString("goDate")));
		if (!(stock.getString("createTime").equals("null") || stock.getString(
				"createTime").equals("")))
			trade.setCreateTime(Timestamp.valueOf(stock.getString("createTime")));
		if (!(stock.getString("updateTime").equals("null") || stock.getString(
				"updateTime").equals("")))
			trade.setUpdateTime(Timestamp.valueOf(stock.getString("updateTime")));
		if(("0").equals(stock.getString("stockState"))){
			if(trade.getState()!= null && !trade.getState().equals("111") && !trade.getState().equals("112") && !trade.getState().equals("113")){
				Carport carport = this.carportDao.findByAgencyId(agency.getId());
				carport.setUnusedNum(carport.getUnusedNum()<carport.getTotalNum() ? carport.getUnusedNum()+1 : carport.getUnusedNum());
				carport.setUsedNum(carport.getUsedNum()>0 ? carport.getUsedNum()-1 :carport.getUsedNum());
				this.carportDao.update(carport);
			}
			trade.setState("113");
		}
		if (("1").equals(stock.getString("updateTime"))){
			trade.setConsignTag("1");
		}else{
			trade.setConsignTag("0");
		}
		this.tradeDao.update(trade);

		JSONArray picList = obj.getJSONObject("data").getJSONObject("result")
				.getJSONArray("vehiclePics");
		// 解析并保持图片数据
		/*if(picList.size()>0){
			this.vehiclePicDao.deleteByVId(vehicle.getId());
		}*/
		for (int i = 0; i<picList.size();i++) {
			Object o = picList.get(i);
			JSONObject pic = JSONObject.fromObject(o);
			VehiclePic vpic = this.vehiclePicDao.findUniqueByProperty("picUrl", pic.getString("picUrl"));
			if(vpic!=null){
				continue;
			}else{
				vpic = new VehiclePic();
			}
			vpic.setPicUrl(pic.getString("picUrl"));
			if(i==0){
				vpic.setShowOrder(0);
			}else{
				vpic.setShowOrder(pic.getInt("showOrder"));
			}
			vpic.setSmallPicUrl(pic.getString("smallPicUrl"));
			vpic.setTrade(trade);
			vpic.setVehicle(vehicle);
			this.vehiclePicDao.save(vpic);
		}

	}

	private void doGetVehicleInfo(Trade trade) throws Exception {
		try {
			/*Vehicle v = trade.getVehicle();
			Agency agency = trade.getAgency();*/

			String params = "stockId=@stockId";
			params = params.replaceAll("@stockId", trade.getOuterId()
					.toString());
			String resStr = HttpUtils.sendPost(Const.SYNC_VEHICLE_BACK_URL,
					params, "utf8");
			doUpdateVehicle(trade, resStr);
		} catch (Exception e) {
			log.error("doUpdateVehicle", e);
		}
	}

	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = ServiceException.class)
	public void doSyncVehicleInfoBack() throws Exception {

		List<Trade> list = getUnSyncVehicle();
		if (list == null || list.size() == 0)
			return;
		for (int i = 0; i < list.size(); i++) {
			Trade trade = list.get(i);
			doGetVehicleInfo(trade);
		}

	}

	
	
	
	public void doSyncAllVehicleBack() {
		List<AgencySync> list = this.agencySyncDao.getSyncedAgency();
		try {
			for(AgencySync as : list){
				Agency agency = as.getAgency();
				String params = "locateId=@locateId";
				params = params.replaceAll("@locateId", agency.getOuterId().toString());
				String resStr = HttpUtils.sendPost(Const.SYNC_ALL_VEHICLE_BACK_URL,
						params, "utf8");
				doAnalyVehicle(agency,resStr);
			}

		} catch (Exception e) {
			log.error("doAddVehicleInfo", e);
		}
	}
	
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
	void doAnalyVehicle(Agency agency, String jsonStr) throws Exception{
		JSONObject obj = JSONObject.fromObject(jsonStr);

		if (!obj.getBoolean("success"))
			return;
		JSONArray array = obj.getJSONObject("data").getJSONObject("result").getJSONArray("stockIdList");
		for(int i = 0;i<array.size();i++){
			Long stockId = array.getLong(i);
			String params = "stockId=@stockId";
			params = params.replaceAll("@stockId", stockId.toString());
			String resStr = HttpUtils.sendPost(Const.SYNC_VEHICLE_BACK_URL,
					params, "utf8");
			doAddVehicle(agency, resStr);
		}
	}

	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
	void doAddVehicle(Agency agency, String jsonStr) throws ParseException {
		JSONObject obj = JSONObject.fromObject(jsonStr);

		if (!obj.getBoolean("success"))
			return;
		JSONObject stock = obj.getJSONObject("data").getJSONObject("result")
				.getJSONObject("stock");
		JSONObject vehicle1 = obj.getJSONObject("data").getJSONObject("result")
				.getJSONObject("vehicle");
		JSONObject buy = obj.getJSONObject("data").getJSONObject("result")
				.getJSONObject("buy");
		JSONObject sale = obj.getJSONObject("data").getJSONObject("result")
				.getJSONObject("sale");
		if(!("0").equals(stock.getString("stockState")) && agency.getState().equals("103")){
			Carport carport = this.carportDao.findByAgencyId(agency.getId());
			int used = carport.getUsedNum();
			int unused = carport.getUnusedNum();
			if(unused>0){
				Trade t = this.tradeDao.findByOutId(stock.getLong("id"));
				if(t == null){
					Vehicle vehicle = new Vehicle();
					if (!(vehicle1.getString("brandId").equals("null") || vehicle1
							.getString("brandId").equals("")))
						vehicle.setBrand(this.brandDao.get(vehicle1.getLong("brandId")));
					if (!(vehicle1.getString("brandName").equals("null") || vehicle1
							.getString("brandName").equals("")))
						vehicle.setBrandName(vehicle1.getString("brandName"));
					if (!(vehicle1.getString("seriesId").equals("null") || vehicle1
							.getString("seriesId").equals("")))
						vehicle.setSeries(this.seriesDao.get(vehicle1.getLong("seriesId")));
					if (!(vehicle1.getString("seriesName").equals("null") || vehicle1
							.getString("seriesName").equals("")))
						vehicle.setSeriesName(vehicle1.getString("seriesName"));
					if (!(vehicle1.getString("kindId").equals("null") || vehicle1
							.getString("kindId").equals("")))
						vehicle.setKind(this.kindDao.get(vehicle1.getLong("kindId")));
					if (!(vehicle1.getString("kindName").equals("null") || vehicle1
							.getString("kindName").equals("")))
						vehicle.setKindName(vehicle1.getString("kindName"));
					if (!(vehicle1.getString("shelfCode").equals("null") || vehicle1
							.getString("shelfCode").equals("")))
						vehicle.setShelfCode(vehicle1.getString("shelfCode"));
					if (!(vehicle1.getString("licenseCode").equals("null") || vehicle1
							.getString("licenseCode").equals("")))
						vehicle.setLicenseCode(vehicle1.getString("licenseCode"));
					if (!(vehicle1.getString("registMonth").equals("null") || vehicle1
							.getString("registMonth").equals("")))
						vehicle.setRegistMonth(vehicle1.getString("registMonth"));
					if (!(vehicle1.getString("outputVolume").equals("null") || vehicle1
							.getString("outputVolume").equals("")))
						vehicle.setOutputVolume(vehicle1.getString("outputVolume"));
					if (!(vehicle1.getString("gearType").equals("null") || vehicle1
							.getString("gearType").equals("")))
						vehicle.setGearType(vehicle1.getString("gearType"));
					if (!(vehicle1.getString("carColor").equals("null") || vehicle1
							.getString("carColor").equals("")))
						vehicle.setCarColor(vehicle1.getString("carColor"));
					if (!(vehicle1.getString("upholsteryColor").equals("null") || vehicle1
							.getString("upholsteryColor").equals("")))
						vehicle.setUpholsteryColor(vehicle1.getString("upholsteryColor"));
					if (!(vehicle1.getString("vehicleType").equals("null") || vehicle1
							.getString("vehicleType").equals("")))
						vehicle.setVehicleType(vehicle1.getString("vehicleType"));
					if (!(vehicle1.getString("usedType").equals("null") || vehicle1
							.getString("usedType").equals("")))
						vehicle.setUsedType(vehicle1.getString("usedType"));
					if (!(vehicle1.getString("engineNumber").equals("null") || vehicle1
							.getString("engineNumber").equals("")))
						vehicle.setEngineNumber(vehicle1.getString("engineNumber"));
					if (!(vehicle1.getString("oilType").equals("null") || vehicle1
							.getString("oilType").equals("")))
						vehicle.setOilType(vehicle1.getString("oilType"));
					if (!(vehicle1.getString("factoryDate").equals("null") || vehicle1
							.getString("factoryDate").equals("")))
						vehicle.setFactoryDate(new SimpleDateFormat("yyyy-MM")
								.parse(vehicle1.getString("factoryDate")));
					if (!(stock.getString("newcarPrice").equals("null") || stock.getString(
							"newcarPrice").equals("")))
						vehicle.setNewcarPrice(UcmsWebUtils.fenToYuan(stock.getLong("newcarPrice")).toString());
					if (!(vehicle1.getString("issurValidDate").equals("null") || vehicle1
							.getString("issurValidDate").equals("")))
						vehicle.setIssurValidDate(vehicle1.getString("issurValidDate"));
					if (!(vehicle1.getString("commIssurValidDate").equals("null") || vehicle1
							.getString("commIssurValidDate").equals("")))
						vehicle.setCommIssurValidDate(vehicle1
								.getString("commIssurValidDate"));
					if (!(vehicle1.getString("checkValidMonth").equals("null") || vehicle1
							.getString("checkValidMonth").equals("")))
						vehicle.setCheckValidMonth(vehicle1.getString("checkValidMonth"));
					if (!(vehicle1.getString("envLevel").equals("null") || vehicle1
							.getString("envLevel").equals("")))
						vehicle.setEnvLevel(vehicle1.getString("envLevel"));
					if (!(vehicle1.getString("condDesc").equals("null") || vehicle1
							.getString("condDesc").equals("")))
						vehicle.setCondDesc(vehicle1.getString("condDesc"));
					if (!(vehicle1.getString("mileageCount").equals("null") || vehicle1
							.getString("mileageCount").equals("")))
						vehicle.setMileageCount(vehicle1.getString("mileageCount"));
					if (!(vehicle1.getString("updateTime").equals("null") || vehicle1
							.getString("updateTime").equals("")))
						vehicle.setUpdateTime(Timestamp.valueOf(vehicle1
								.getString("updateTime")));
					if (!(vehicle1.getString("createTime").equals("null") || vehicle1
							.getString("createTime").equals("")))
						vehicle.setCreateTime(Timestamp.valueOf(vehicle1
								.getString("createTime")));
					this.vehicleDao.save(vehicle);
		
					Trade trade = new Trade();
					trade.setAgency(agency);
					trade.setVehicle(vehicle);
					trade.setState(Const.WAITFOR_IN_STR);
					trade.setApproveTag("0");
					trade.setOuterId(stock.getLong("id"));
					if (!(vehicle1.getString("oldLicensecode").equals("null") || vehicle1
							.getString("oldLicensecode").equals("")))
						trade.setOldLicenseCode(vehicle1.getString("oldLicensecode"));
					if (!(vehicle1.getString("newLicensecode").equals("null") || vehicle1
							.getString("newLicensecode").equals("")))
						trade.setNewLicenseCode(vehicle1.getString("newLicensecode"));
					if (!(buy.toString().equals("null")
							|| buy.getString("acquPrice").equals("null") || buy.getString(
							"acquPrice").equals("")))
						trade.setAcquPrice(UcmsWebUtils.fenToYuan(buy.getLong("acquPrice")));
					if (!(stock.getString("showPrice").equals("null") || stock.getString(
							"showPrice").equals("")))
						trade.setShowPrice(UcmsWebUtils.fenToYuan(stock
								.getLong("showPrice")));
					if (!(sale.toString().equals("null")
							|| sale.getString("salePrice").equals("null") || sale
							.getString("salePrice").equals("")))
						trade.setSalePrice(UcmsWebUtils.fenToYuan(sale.getLong("salePrice")));
					if (!(stock.getString("comeDate").equals("null") || stock.getString(
							"comeDate").equals("")))
						trade.setComeDate(new SimpleDateFormat("yyyy-MM-dd").parse(stock
								.getString("comeDate")));
					if (!(stock.getString("goDate").equals("null") || stock.getString(
							"goDate").equals("")))
						trade.setGoDate(new SimpleDateFormat("yyyy-MM-dd").parse(stock
								.getString("goDate")));
					if (!(stock.getString("createTime").equals("null") || stock.getString(
							"createTime").equals("")))
						trade.setCreateTime(Timestamp.valueOf(stock.getString("createTime")));
					if (!(stock.getString("updateTime").equals("null") || stock.getString(
							"updateTime").equals("")))
						trade.setUpdateTime(Timestamp.valueOf(stock.getString("updateTime")));
					if (("1").equals(stock.getString("updateTime"))){
						trade.setConsignTag("1");
					}else{
						trade.setConsignTag("0");
					}
					Trade nTrade = this.tradeDao.save(trade);
					nTrade.setBarCode(SysUtils.createBarCode(nTrade.getId().toString()));
					this.tradeDao.update(nTrade);
					
					this.updateChe3bao(nTrade);
		
					JSONArray picList = obj.getJSONObject("data").getJSONObject("result")
							.getJSONArray("vehiclePics");
					// 解析并保持图片数据
					/*if(picList.size()>0){
						this.vehiclePicDao.deleteByVId(vehicle.getId());
					}*/
					for (Object o : picList) {
						JSONObject pic = JSONObject.fromObject(o);
						VehiclePic vpic = new VehiclePic();
						vpic.setPicUrl(pic.getString("picUrl"));
						vpic.setShowOrder(pic.getInt("showOrder"));
						vpic.setSmallPicUrl(pic.getString("smallPicUrl"));
						vpic.setTrade(trade);
						vpic.setVehicle(vehicle);
						this.vehiclePicDao.save(vpic);
					}
					
					used = carport.getUsedNum()+1;
					unused = carport.getUnusedNum()-1;
					carport.setUsedNum(used);
					carport.setUnusedNum(unused);
					this.carportDao.update(carport);
					this.commonService.barcodePic(nTrade.getBarCode());
				}
			}
		}
	}

	private void updateChe3bao(Trade nTrade) {
		try{
			String params = "stockId=@stockId&picAddr=@picAddr";
			params = params.replaceAll("@stockId", nTrade.getOuterId().toString());
			params = params.replaceAll("@picAddr", Const.BARCODE_URL+nTrade.getBarCode()+".png");
			String resStr = HttpUtils.sendPost(Const.SYNC_BARCODE_URL,
					params, "utf8");
		}catch (Exception e){
			log.error("updateChe3bao", e);
		}
	}


}
