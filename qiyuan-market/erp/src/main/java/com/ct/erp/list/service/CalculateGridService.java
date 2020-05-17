package com.ct.erp.list.service;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import com.ct.erp.list.model.PageTableColInfo;

public class CalculateGridService {
	
	public static boolean isXsum(Map<String,PageTableColInfo> colFields){
		Iterator it=colFields.entrySet().iterator();
		while(it.hasNext()){
			Map.Entry<String,PageTableColInfo> entry = (Map.Entry<String,PageTableColInfo>) it.next();
			if(entry.getValue().isXsum()){
				return true;
			}
		}
		return false;
	}

	/**
	 * 获得y轴的需要求和的列
	 * @param colFields
	 * @return
	 */
	public static  List<String> getColumnYsumField(Map<String,PageTableColInfo> colFields){
		List<String> filedList=new ArrayList<String>();
		Iterator it=colFields.entrySet().iterator();
		while(it.hasNext()){
			Map.Entry<String,PageTableColInfo> entry = (Map.Entry<String,PageTableColInfo>) it.next();
			if(entry.getValue().isYsum()){
				filedList.add(entry.getValue().getColField());
			}
		}
		return filedList;		
	}
	/**
	 * 获得x轴需要求和的列
	 * @param colFields
	 * @return
	 */
	public static   List<String> getColumnXsumField(Map<String,PageTableColInfo> colFields){
		List<String> filedList=new ArrayList<String>();
		Iterator it=colFields.entrySet().iterator();
		while(it.hasNext()){
			Map.Entry<String,PageTableColInfo> entry = (Map.Entry<String,PageTableColInfo>) it.next();
			if(entry.getValue().isXsum()){
				filedList.add(entry.getValue().getColField());
			}
		}
		return filedList;		
	}
	/**
	 * 计算x轴求和的列值
	 * @param pageInfo
	 * @param composeQueryBean
	 */
	public static  void calculateXsum(List rows,Map<String,PageTableColInfo> colFields){
		List<String> xsumFieldList=getColumnXsumField(colFields);
		if(xsumFieldList.size()>0){
			if(rows!=null){
				for(Map<String,Object> rowMap:(List<Map<String,Object>>)rows){
					double sum=calculateSumMap(rowMap, xsumFieldList);
					rowMap.put("xsum", String.valueOf(sum));
				}
			}
		}
	}

	/**
	 * 行数据求和
	 * @param rowMap
	 * @param ysumFieldList
	 * @return
	 */
	public static   double calculateSumMap(Map<String,Object> rowMap,List<String> ysumFieldList){
		double sum=0.f;
		for(String field:ysumFieldList){
			if(rowMap.get(field)!=null){
				sum+=Double.valueOf(rowMap.get(field).toString());
			}
		}
		return sum;
	}
}
