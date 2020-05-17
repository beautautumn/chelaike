package com.ct.erp.common.model;

public abstract class InterfaceResult {

	private InterfaceReq req;
	private InterfaceRes res;

	public InterfaceReq getReq() {
		return this.req;
	}

	public void setReq(InterfaceReq req) {
		this.req = req;
	}

	public InterfaceRes getRes() {
		return this.res;
	}

	public void setRes(InterfaceRes res) {
		this.res = res;
	}

	public InterfaceRes sucess(String desc) {
		this.res = new InterfaceRes();
		this.res.setCode("0000");
		this.res.setType("0");
		this.res.setDesc(desc);
		this.res
				.setProcsTime(String.valueOf(System.currentTimeMillis() / 1000));
		return this.res;
	}

	public InterfaceRes fail(String code, String type, String desc) {
		this.res = new InterfaceRes();
		this.res.setCode(code);
		this.res.setType(type);
		this.res.setDesc(desc);
		this.res
				.setProcsTime(String.valueOf(System.currentTimeMillis() / 1000));
		return this.res;
	}

}
