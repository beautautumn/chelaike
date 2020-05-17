package com.ct.erp.che3bao.service;

import org.springframework.beans.factory.annotation.Autowired;

import net.sf.json.JSONObject;

import com.ct.erp.carin.dao.TradeDao;
import com.ct.erp.che3bao.dao.VehiclePicDao;
import com.ct.erp.lib.entity.Brand;
import com.ct.erp.lib.entity.Kind;
import com.ct.erp.lib.entity.Series;
import com.ct.erp.lib.entity.Trade;
import com.ct.erp.lib.entity.Vehicle;
import com.ct.erp.lib.entity.VehiclePic;
import com.ct.erp.loan.dao.VehicleDao;
import com.ct.erp.sys.dao.BrandDao;
import com.ct.erp.sys.dao.KindDao;
import com.ct.erp.sys.dao.SeriesDao;

public class Che3baoService {

  @Autowired
  private VehiclePicDao vehiclePicDao;
  @Autowired
  private TradeDao tradeDao;
  @Autowired
  private VehicleDao vehicleDao;
  @Autowired
  private BrandDao brandDao;
  @Autowired
  private SeriesDao seriesDao;
  @Autowired
  private KindDao kindDao;
		
  
  public void doSaveVehicleInfo(String jsonString) throws Exception{
	  String str =null;
	  
	  JSONObject obj =JSONObject.fromObject(jsonString);
	  JSONObject row =obj.getJSONObject("result");
	  
	  Vehicle vehicle = new Vehicle();
	  
	  Brand nBrand =brandDao.get(row.getLong("brandCode"));
	  if (nBrand==null)
	  {
		 Brand brand = new Brand();
		 brand.setId(row.getLong("brandCode"));
		 brand.setName(row.getString("brandName"));
		 brand.setValidTag("1");
		 nBrand = brandDao.save(brand);
	  }
	  vehicle.setBrand(nBrand);
	  
	  Series nSeries=seriesDao.get(row.getLong("seriesCode"));
	  if(nSeries ==null)
	  {
		  Series series = new Series();
		  series.setBrand(nBrand);
		  series.setId(row.getLong("seriesCode"));
		  series.setName(row.getString("seriesName"));
		  series.setValidTag("1");
		  nSeries = seriesDao.save(series);  
	  }
	  vehicle.setSeries(nSeries);
	  
	  Kind nKind=kindDao.get(row.getLong("modelCode"));
	  if(nKind ==null)
	  {
		  Kind kind = new Kind();
		  kind.setSeries(nSeries);
		  kind.setId(row.getLong("modelCode"));
		  kind.setName(row.getString("modelName"));
		  kind.setValidTag("1");
		  nKind = kindDao.save(kind);  
	  }
	  vehicle.setKind(nKind);	  
	  
	  vehicle.setCarColor(row.getString("carColor"));
	  vehicle.setVehicleType(row.getString("carType"));
	  vehicle.setIssurValidDate(row.getString("issurValidDate"));
	  vehicle.setCheckValidMonth(row.getString("checkValidMonth"));
	  vehicle.setCommIssurValidDate(row.getString("commIssurValidDate"));
	  vehicle.setCondDesc(row.getString("condDesc"));
    //  vehicle.setDimCodeUrl(row.getString("dimCodeUrl"));
      vehicle.setOilType(row.getString("fuelType"));
      vehicle.setGearType(row.getString("gearsType"));
      vehicle.setMileageCount(row.getString("mileageNum"));
      
	  Trade trade = new Trade();
	  trade.setShowPrice(row.getLong("carPrice"));
	  
	  Vehicle nVehicle = vehicleDao.save(vehicle);
	  trade.setVehicle(nVehicle);
	  
	  Trade nTrade = tradeDao.save(trade);

//	  VehiclePic picf = new VehiclePic();
//	  picf.setPicType("1");
//	  picf.setPicUrl(row.getString("firstPic"));
//	  picf.setShowOrder(0);//表示首图
//	  picf.setVehicle(nVehicle);
//	  picf.setTrade(nTrade);
//	  vehiclePicDao.save(picf);  
//	  
//	  str =row.getString("bigPicAddr");
//	  String arrB[] = str.split(",");
//	  for(int i=0;i<arrB.length-1;i++)
//	  {
//	     VehiclePic pic = new VehiclePic();
//	     pic.setPicType("0");
//	     pic.setPicUrl(arrB[i]);
//	     pic.setShowOrder(i+1);
//	     pic.setVehicle(nVehicle);
//	     pic.setTrade(nTrade);
//	     vehiclePicDao.save(pic);
//	  }
//	  
//	  str =row.getString("mediumPicAddr");
//	  String arrD[] = str.split(",");
//	  for(int i=0;i<arrD.length-1;i++)
//	  {
//	     VehiclePic pic = new VehiclePic();
//	     pic.setPicType("1");
//	     pic.setPicUrl(arrD[i]);
//	     pic.setShowOrder(i+1);
//	     pic.setVehicle(nVehicle);
//	     pic.setTrade(nTrade);
//	     vehiclePicDao.save(pic);
//	  }
//	  
//	  str =row.getString("smallPicAddr");
//	  String arrS[] = str.split(",");
//	  for(int i=0;i<arrS.length-1;i++)
//	  {
//	     VehiclePic pic = new VehiclePic();
//	     pic.setPicType("1");
//	     pic.setPicUrl(arrS[i]);
//	     pic.setShowOrder(i+1);
//	     pic.setVehicle(nVehicle);
//	     pic.setTrade(nTrade);
//	     vehiclePicDao.save(pic);
//	  }	  
	  
	  
  }
}
