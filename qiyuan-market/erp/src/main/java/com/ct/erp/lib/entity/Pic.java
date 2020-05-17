package com.ct.erp.lib.entity;

import com.ct.erp.lib.entity.Staff;

import java.sql.Timestamp;

/**
 * Pic entity. @author MyEclipse Persistence Tools
 */

public class Pic implements java.io.Serializable {

	// Fields

	private Long id;
	private Staff staff;
	private Long objId;
	private String picName;
	private String picUrl;
	private Timestamp uploadDate;
	private Short displayOrder;
	private String showTag;
	private String picType;
	private String smallPicUrl;

	// Constructors

	/** default constructor */
	public Pic() {
	}

	/** full constructor */
	public Pic(Staff staff, Long objId, String picName, String picUrl,
               Timestamp uploadDate, Short displayOrder, String showTag,
               String picType, String smallPicUrl) {
		this.staff = staff;
		this.objId = objId;
		this.picName = picName;
		this.picUrl = picUrl;
		this.uploadDate = uploadDate;
		this.displayOrder = displayOrder;
		this.showTag = showTag;
		this.picType = picType;
		this.smallPicUrl = smallPicUrl;
	}

	// Property accessors

	public Long getId() {
		return this.id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public Staff getStaff() {
		return this.staff;
	}

	public void setStaff(Staff staff) {
		this.staff = staff;
	}

	public Long getObjId() {
		return this.objId;
	}

	public void setObjId(Long objId) {
		this.objId = objId;
	}

	public String getPicName() {
		return this.picName;
	}

	public void setPicName(String picName) {
		this.picName = picName;
	}

	public String getPicUrl() {
		return this.picUrl;
	}

	public void setPicUrl(String picUrl) {
		this.picUrl = picUrl;
	}

	public Timestamp getUploadDate() {
		return this.uploadDate;
	}

	public void setUploadDate(Timestamp uploadDate) {
		this.uploadDate = uploadDate;
	}

	public Short getDisplayOrder() {
		return this.displayOrder;
	}

	public void setDisplayOrder(Short displayOrder) {
		this.displayOrder = displayOrder;
	}

	public String getShowTag() {
		return this.showTag;
	}

	public void setShowTag(String showTag) {
		this.showTag = showTag;
	}

	public String getPicType() {
		return this.picType;
	}

	public void setPicType(String picType) {
		this.picType = picType;
	}

	public String getSmallPicUrl() {
		return this.smallPicUrl;
	}

	public void setSmallPicUrl(String smallPicUrl) {
		this.smallPicUrl = smallPicUrl;
	}

}