package com.ct.erp.lib.entity;

import com.ct.erp.lib.entity.Staff;
import com.ct.erp.lib.entity.Sysmenu;

import java.sql.Timestamp;

/**
 * TodoLog entity. @author MyEclipse Persistence Tools
 */

public class TodoLog implements java.io.Serializable {

	// Fields

	private Long id;
	private Sysmenu sysmenu;
	private Staff staffByWaitStaff;
	private Staff staffByCreateStaff;
	private Staff staffByNotifyStaff;
	private Long todoObjId;
	private String submitRightCodes;
	private String todoTitle;
	private String todoState;
	private Timestamp createTime;

	// Constructors

	/** default constructor */
	public TodoLog() {
	}

	/** minimal constructor */
	public TodoLog(String submitRightCodes) {
		this.submitRightCodes = submitRightCodes;
	}

	/** full constructor */
	public TodoLog(Sysmenu sysmenu, Staff staffByWaitStaff,
                   Staff staffByCreateStaff, Staff staffByNotifyStaff, Long todoObjId,
                   String submitRightCodes, String todoTitle, String todoState,
                   Timestamp createTime) {
		this.sysmenu = sysmenu;
		this.staffByWaitStaff = staffByWaitStaff;
		this.staffByCreateStaff = staffByCreateStaff;
		this.staffByNotifyStaff = staffByNotifyStaff;
		this.todoObjId = todoObjId;
		this.submitRightCodes = submitRightCodes;
		this.todoTitle = todoTitle;
		this.todoState = todoState;
		this.createTime = createTime;
	}

	// Property accessors

	public Long getId() {
		return this.id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public Sysmenu getSysmenu() {
		return this.sysmenu;
	}

	public void setSysmenu(Sysmenu sysmenu) {
		this.sysmenu = sysmenu;
	}

	public Staff getStaffByWaitStaff() {
		return this.staffByWaitStaff;
	}

	public void setStaffByWaitStaff(Staff staffByWaitStaff) {
		this.staffByWaitStaff = staffByWaitStaff;
	}

	public Staff getStaffByCreateStaff() {
		return this.staffByCreateStaff;
	}

	public void setStaffByCreateStaff(Staff staffByCreateStaff) {
		this.staffByCreateStaff = staffByCreateStaff;
	}

	public Staff getStaffByNotifyStaff() {
		return this.staffByNotifyStaff;
	}

	public void setStaffByNotifyStaff(Staff staffByNotifyStaff) {
		this.staffByNotifyStaff = staffByNotifyStaff;
	}

	public Long getTodoObjId() {
		return this.todoObjId;
	}

	public void setTodoObjId(Long todoObjId) {
		this.todoObjId = todoObjId;
	}

	public String getSubmitRightCodes() {
		return this.submitRightCodes;
	}

	public void setSubmitRightCodes(String submitRightCodes) {
		this.submitRightCodes = submitRightCodes;
	}

	public String getTodoTitle() {
		return this.todoTitle;
	}

	public void setTodoTitle(String todoTitle) {
		this.todoTitle = todoTitle;
	}

	public String getTodoState() {
		return this.todoState;
	}

	public void setTodoState(String todoState) {
		this.todoState = todoState;
	}

	public Timestamp getCreateTime() {
		return this.createTime;
	}

	public void setCreateTime(Timestamp createTime) {
		this.createTime = createTime;
	}

}