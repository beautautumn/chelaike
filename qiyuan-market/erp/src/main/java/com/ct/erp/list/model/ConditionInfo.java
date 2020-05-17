package com.ct.erp.list.model;

import java.util.List;
import java.util.Map;

public class ConditionInfo {


	private List<Input> inputList;
	private Select secondSelect;
	private Option option;
	private String defaultFlag;
	private String nodeType;
	private String condSql;
	private List<SearchInputCondtion> searchInputCondtionList;
	private List<SelectBean> selectList;
	
	private boolean isVersible;
	
	public String getCondSql() {
		return condSql;
	}
	public void setCondSql(String condSql) {
		this.condSql = condSql;
	}
	public String getNodeType() {
		return nodeType;
	}
	public void setNodeType(String nodeType) {
		this.nodeType = nodeType;
	}
	public String getDefaultFlag() {
		return defaultFlag;
	}
	public void setDefaultFlag(String defaultFlag) {
		this.defaultFlag = defaultFlag;
	}
	public Option getOption() {
		return option;
	}
	public void setOption(Option option) {
		this.option = option;
	}
	public List<Input> getInputList() {
		return inputList;
	}
	public void setInputList(List<Input> inputList) {
		this.inputList = inputList;
	}
	public Select getSecondSelect() {
		return secondSelect;
	}
	public void setSecondSelect(Select secondSelect) {
		this.secondSelect = secondSelect;
	}
	public boolean isVersible(Map<String, String> formMap){
		//如果类型为下拉框
		if(this.nodeType.equals("select")){
			if(this.secondSelect!=null&&formMap!=null&&formMap.get(this.secondSelect.getName())!=null){
				return true;
			}
		}else if(this.nodeType.equals("input")){//如果类型为文本框
			for(Input input:this.getInputList()){
				if(input!=null&&formMap!=null&&formMap.get(input.getName())!=null){
					return true;
				}
			}
		}
		return false;
	}
	
	public void setVersible(boolean isVersible) {
		this.isVersible = isVersible;
	}
	public List<SearchInputCondtion> getSearchInputCondtionList() {
		return searchInputCondtionList;
	}
	public void setSearchInputCondtionList(
			List<SearchInputCondtion> searchInputCondtionList) {
		this.searchInputCondtionList = searchInputCondtionList;
	}
	public List<SelectBean> getSelectList() {
		return selectList;
	}
	public void setSelectList(List<SelectBean> selectList) {
		this.selectList = selectList;
	}
	
	
}
