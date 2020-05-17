package com.ct.erp.sys.service;

import java.util.List;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.ct.erp.lib.entity.Agency;
import com.ct.erp.lib.entity.Brand;
import com.ct.erp.lib.entity.Kind;
import com.ct.erp.lib.entity.Series;
import com.ct.erp.lib.entity.TodoLog;
import com.ct.erp.rent.dao.AgencyDao;
import com.ct.erp.sys.dao.BrandDao;
import com.ct.erp.sys.dao.KindDao;
import com.ct.erp.sys.dao.SeriesDao;
import com.ct.erp.sys.dao.TodoLogDao;
import com.google.gson.JsonArray;
import com.google.gson.JsonObject;
@Service
public class CommService {
	
	@Autowired
	private BrandDao brandDao;
	@Autowired
	private SeriesDao seriesDao;
	@Autowired
	private KindDao kindDao;
	@Autowired
	private AgencyDao agencyDao;
		
	public String getBrandList() throws Exception
	{
		List<Brand> list =brandDao.findValidList();
		JSONArray arr = new JSONArray();
		for(int i=0;i<list.size();i++)
		{ 
		   Brand b = list.get(i);
		   JSONObject obj = new JSONObject();
           obj.accumulate("id", b.getId());
           obj.accumulate("name",b.getName());
           obj.accumulate("group",b.getFirstLetter());
           arr.add(obj);
		}
		return arr.toString();
	}
	
	public String getAgencyList() throws Exception{
		List<Agency> list = agencyDao.findValidAgencyList();
		JSONArray arr = new JSONArray();
		JSONObject jobj = new JSONObject();
		jobj.accumulate("id", "");
		jobj.accumulate("name", "请选择");
		arr.add(jobj);
		for(Agency a : list){
			JSONObject obj = new JSONObject();
			obj.accumulate("id", a.getId());
			obj.accumulate("name", a.getAgencyName());
			arr.add(obj);
		}
		return arr.toString();
	}
	
	public String getSeriesList(Long brandId)throws Exception
	{
		List<Series> list= seriesDao.getListByBrandId(brandId);
		JSONArray arr = new JSONArray();
		for(int i=0;i<list.size();i++)
		{ 
		   Series b = list.get(i);
		   JSONObject obj = new JSONObject();
           obj.accumulate("id", b.getId());
           obj.accumulate("name",b.getName());
           if(i==0)
           {
        	   obj.accumulate("selected",true);  
           }
           arr.add(obj);
		}
		return arr.toString();
		
		
	}
	
	public String getKindList(Long seriesId)throws Exception
	{
		List<Kind> list= kindDao.findListBySeriesId(seriesId);
		JSONArray arr = new JSONArray();
		for(int i=0;i<list.size();i++)
		{ 
		   Kind b = list.get(i);
		   JSONObject obj = new JSONObject();
           obj.accumulate("id", b.getId());
           obj.accumulate("name",b.getName());
           if(i==0)
           {
        	   obj.accumulate("selected",true);  
           }
           arr.add(obj);
		}
		return arr.toString();		
	}	 
}
