package com.ct.erp.common.orm.hibernate3;

@SuppressWarnings("serial")
public class Nullable extends Condition {
	private boolean isNull;

	public Nullable(String field, boolean isNull) {
		this.field = field;
		this.isNull = isNull;
	}

	public static Nullable isNull(String field) {
		return new Nullable(field, true);
	}

	public static Nullable isNotNull(String field) {
		return new Nullable(field, false);
	}

	public boolean isNull() {
		return isNull;
	}
}
