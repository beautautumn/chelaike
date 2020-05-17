package com.tianche.domain;

import java.io.Serializable;

public class UserRight  implements Serializable{
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private long id;
	private long staffId;
	private String rightCode;
	public long getId() {
		return id;
	}
	public void setId(long id) {
		this.id = id;
	}
	public long getStaffId() {
		return staffId;
	}
	public void setStaffId(long staffId) {
		this.staffId = staffId;
	}
	public String getRightCode() {
		return rightCode;
	}
	public void setRightCode(String rightCode) {
		this.rightCode = rightCode;
	}
}
