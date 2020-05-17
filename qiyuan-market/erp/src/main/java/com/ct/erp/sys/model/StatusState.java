package com.ct.erp.sys.model;

public enum StatusState {
	/** 正常(0) */ 
	normal("1", "正常"),
	/** 已删除(1) */
	delete("0", "已删除"),
	/** 待审核(2) */
	audit("2", "待审核"), 
	/** 锁定(3) */
	lock("3", "已锁定");

	/**
	 * 值 Integer型
	 */
	private final String value;
	/**
	 * 描述 String型
	 */
	private final String description;

	StatusState(String value, String description) {
		this.value = value;
		this.description = description;
	}

	
	public String getValue() {
		return value;
	}


	/**
     * 获取描述信息
     * @return description
     */
	public String getDescription() {
		return description;
	}

	public static StatusState getStatusState(String value) {
		if (null == value)
			return null;
		for (StatusState _enum : StatusState.values()) {
			if (value.equals(_enum.getValue()))
				return _enum;
		}
		return null;
	}
	
	public static StatusState getStatusDesc(String description) {
		if (null == description)
			return null;
		for (StatusState _enum : StatusState.values()) {
			if (description.equals(_enum.getDescription()))
				return _enum;
		}
		return null;
	}
}


