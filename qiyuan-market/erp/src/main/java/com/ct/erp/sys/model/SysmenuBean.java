package com.ct.erp.sys.model;

import java.util.List;

import com.ct.erp.lib.entity.Sysmenu;
import com.google.common.collect.Lists;

public class SysmenuBean {
	
	public SysmenuBean(Sysmenu sysmenu){
		this.sysmenu=sysmenu;
	}

	private Sysmenu sysmenu;
	
	private List<Sysmenu> subSysmenuList=Lists.newArrayList();

	public Sysmenu getSysmenu() {
		return sysmenu;
	}

	public void setSysmenu(Sysmenu sysmenu) {
		this.sysmenu = sysmenu;
	}

	public List<Sysmenu> getSubSysmenuList() {
		return subSysmenuList;
	}

	public void setSubSysmenuList(List<Sysmenu> subSysmenuList) {
		this.subSysmenuList = subSysmenuList;
	}
	
	
	
}
