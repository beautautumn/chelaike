package com.ct.erp.aop.model;

/**
 * @author shiqingwen
 */

public class FeeItemJson  {

	// Fields

	private Long id;
	private String itemName;
	private String itemDesc;
	private String status;
	private String itemGroup;
	
	public FeeItemJson(com.ct.erp.lib.entity.FeeItem feeItem){
		if(feeItem != null){
			this.id = feeItem.getId();
			this.itemName = feeItem.getItemName();
			this.itemDesc = feeItem.getItemDesc();
			this.status = feeItem.getStatus();
			this.itemGroup = feeItem.getItemGroup();
		}
	}
	
	
	public Long getId() {
		return id;
	}
	public void setId(Long id) {
		this.id = id;
	}
	public String getItemName() {
		return itemName;
	}
	public void setItemName(String itemName) {
		this.itemName = itemName;
	}
	public String getItemDesc() {
		return itemDesc;
	}
	public void setItemDesc(String itemDesc) {
		this.itemDesc = itemDesc;
	}
	public String getStatus() {
		return status;
	}
	public void setStatus(String status) {
		this.status = status;
	}
	public String getItemGroup() {
		return itemGroup;
	}
	public void setItemGroup(String itemGroup) {
		this.itemGroup = itemGroup;
	}


}