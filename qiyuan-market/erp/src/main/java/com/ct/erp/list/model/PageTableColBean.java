package com.ct.erp.list.model;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.ct.util.json.JsonUtils;

public class PageTableColBean {

	private List<PageTableColInfo> colInfos;

	public List<PageTableColInfo> getColInfos() {
		return colInfos;
	}

	public void setColInfos(List<PageTableColInfo> colInfos) {
		this.colInfos = colInfos;
	}
	
	
	public static void main(String args[]){
		PageTableColBean bean=new PageTableColBean();
		 List<PageTableColInfo> colInfos=new ArrayList<PageTableColInfo>();
		 bean.setColInfos(colInfos);
	    for(int i=0;i<10;i++){
			PageTableColInfo info=new PageTableColInfo();
			Map<String,String> coloptions=new HashMap<String,String>();
			coloptions.put("0", "是");
			coloptions.put("1", "否");
			info.setColName("信息编号");
			info.setColField("siteId");
			info.setColFormat("String");
			info.setColWidth("10%");
			info.setColOptions(coloptions);
			info.setColNumber(i+1+"");
			bean.getColInfos().add(info);
	    }
	    
	}
	
	
}
