package com.ct.erp.api.model;

import com.ct.erp.common.model.InterfaceResult;

public class Result extends InterfaceResult{
	private ResultParam data;

	public ResultParam getData() {
		return data;
	}

	public void setData(ResultParam data) {
		this.data = data;
	}

}
