package com.ct.erp.api.che300;

/**
 * 车型识别
 * 
 * @author admin
 *
 */
public class IdentifyModel {

	/**
	 * 状态 1/0 1 表示成功/0 表示失败
	 */
	private String status;

	/**
	 * 车三百车型信息
	 */
	private ModelInfo modelInfo;

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public ModelInfo getModelInfo() {
		return modelInfo;
	}

	public void setModelInfo(ModelInfo modelInfo) {
		this.modelInfo = modelInfo;
	}

}
