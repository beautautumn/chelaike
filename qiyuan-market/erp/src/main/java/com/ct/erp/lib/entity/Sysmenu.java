package com.ct.erp.lib.entity;

import com.ct.erp.lib.entity.Sysright;

import java.util.HashSet;
import java.util.Set;

/**
 * Sysmenu entity. @author MyEclipse Persistence Tools
 */

public class Sysmenu implements java.io.Serializable {

	// Fields

	private Long id;
	private Sysright sysright;
	private com.ct.erp.lib.entity.Sysmenu parentSysmenu;
	private String menuText;
	private String url;
	private Short orderNo;
	private String iconCls;
	private String icon;
	private String markUrl;
	private String status;
	private Set todoLogs = new HashSet(0);
	private Set subSysmenus = new HashSet(0);

	// Constructors

	/** default constructor */
	public Sysmenu() {
	}

	/** minimal constructor */
	public Sysmenu(String menuText, Short orderNo) {
		this.menuText = menuText;
		this.orderNo = orderNo;
	}

	/** full constructor */
	public Sysmenu(Sysright sysright, com.ct.erp.lib.entity.Sysmenu parentSysmenu, String menuText,
                   String url, Short orderNo, String iconCls, String icon,
                   String markUrl, String status, Set todoLogs, Set subSysmenus) {
		this.sysright = sysright;
		this.parentSysmenu = parentSysmenu;
		this.menuText = menuText;
		this.url = url;
		this.orderNo = orderNo;
		this.iconCls = iconCls;
		this.icon = icon;
		this.markUrl = markUrl;
		this.status = status;
		this.todoLogs = todoLogs;
		this.subSysmenus = subSysmenus;
	}

	// Property accessors

	public Long getId() {
		return this.id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public Sysright getSysright() {
		return this.sysright;
	}

	public void setSysright(Sysright sysright) {
		this.sysright = sysright;
	}

	public com.ct.erp.lib.entity.Sysmenu getParentSysmenu() {
		return this.parentSysmenu;
	}

	public void setParentSysmenu(com.ct.erp.lib.entity.Sysmenu parentSysmenu) {
		this.parentSysmenu = parentSysmenu;
	}

	public String getMenuText() {
		return this.menuText;
	}

	public void setMenuText(String menuText) {
		this.menuText = menuText;
	}

	public String getUrl() {
		return this.url;
	}

	public void setUrl(String url) {
		this.url = url;
	}

	public Short getOrderNo() {
		return this.orderNo;
	}

	public void setOrderNo(Short orderNo) {
		this.orderNo = orderNo;
	}

	public String getIconCls() {
		return this.iconCls;
	}

	public void setIconCls(String iconCls) {
		this.iconCls = iconCls;
	}

	public String getIcon() {
		return this.icon;
	}

	public void setIcon(String icon) {
		this.icon = icon;
	}

	public String getMarkUrl() {
		return this.markUrl;
	}

	public void setMarkUrl(String markUrl) {
		this.markUrl = markUrl;
	}

	public String getStatus() {
		return this.status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public Set getTodoLogs() {
		return this.todoLogs;
	}

	public void setTodoLogs(Set todoLogs) {
		this.todoLogs = todoLogs;
	}

	public Set getSubSysmenus() {
		return this.subSysmenus;
	}

	public void setSubSysmenus(Set subSysmenus) {
		this.subSysmenus = subSysmenus;
	}

}