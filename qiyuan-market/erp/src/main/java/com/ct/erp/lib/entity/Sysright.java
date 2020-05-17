package com.ct.erp.lib.entity;

import java.util.HashSet;
import java.util.Set;

/**
 * Sysright entity. @author MyEclipse Persistence Tools
 */

public class Sysright implements java.io.Serializable {

	// Fields

	private String rightCode;
	private com.ct.erp.lib.entity.Sysright parentSysright;
	private String rightName;
	private Short rightType;
	private String rightDesc;
	private Short showOrder;
	private Short ownerSystem;
	private Set staffRights = new HashSet(0);
	private Set subSysrights = new HashSet(0);
	private Set sysmenus = new HashSet(0);

	// Constructors

	/** default constructor */
	public Sysright() {
	}

	/** minimal constructor */
	public Sysright(String rightName, Short rightType) {
		this.rightName = rightName;
		this.rightType = rightType;
	}

	/** full constructor */
	public Sysright(com.ct.erp.lib.entity.Sysright parentSysright, String rightName, Short rightType,
                    String rightDesc, Short showOrder, Short ownerSystem,
                    Set staffRights, Set subSysrights, Set sysmenus) {
		this.parentSysright = parentSysright;
		this.rightName = rightName;
		this.rightType = rightType;
		this.rightDesc = rightDesc;
		this.showOrder = showOrder;
		this.ownerSystem = ownerSystem;
		this.staffRights = staffRights;
		this.subSysrights = subSysrights;
		this.sysmenus = sysmenus;
	}

	// Property accessors

	public String getRightCode() {
		return this.rightCode;
	}

	public void setRightCode(String rightCode) {
		this.rightCode = rightCode;
	}

	public com.ct.erp.lib.entity.Sysright getParentSysright() {
		return this.parentSysright;
	}

	public void setParentSysright(com.ct.erp.lib.entity.Sysright parentSysright) {
		this.parentSysright = parentSysright;
	}

	public String getRightName() {
		return this.rightName;
	}

	public void setRightName(String rightName) {
		this.rightName = rightName;
	}

	public Short getRightType() {
		return this.rightType;
	}

	public void setRightType(Short rightType) {
		this.rightType = rightType;
	}

	public String getRightDesc() {
		return this.rightDesc;
	}

	public void setRightDesc(String rightDesc) {
		this.rightDesc = rightDesc;
	}

	public Short getShowOrder() {
		return this.showOrder;
	}

	public void setShowOrder(Short showOrder) {
		this.showOrder = showOrder;
	}

	public Short getOwnerSystem() {
		return this.ownerSystem;
	}

	public void setOwnerSystem(Short ownerSystem) {
		this.ownerSystem = ownerSystem;
	}

	public Set getStaffRights() {
		return this.staffRights;
	}

	public void setStaffRights(Set staffRights) {
		this.staffRights = staffRights;
	}

	public Set getSubSysrights() {
		return this.subSysrights;
	}

	public void setSubSysrights(Set subSysrights) {
		this.subSysrights = subSysrights;
	}

	public Set getSysmenus() {
		return this.sysmenus;
	}

	public void setSysmenus(Set sysmenus) {
		this.sysmenus = sysmenus;
	}

}