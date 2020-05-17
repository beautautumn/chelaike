package com.ct.erp.api.che300;

/**
 * 车三百车型信息 
 * @author admin
 *
 */
public class ModelInfo {

	/**
	 * 品牌编码
	 */
	private Integer brand_id;
	
	/**
	 * 车系编码
	 */
	private Integer series_id;
	
	/**
	 * 车型编码
	 */
	private Integer model_id;

	public Integer getBrand_id() {
		return brand_id;
	}

	public void setBrand_id(Integer brand_id) {
		this.brand_id = brand_id;
	}

	public Integer getSeries_id() {
		return series_id;
	}

	public void setSeries_id(Integer series_id) {
		this.series_id = series_id;
	}

	public Integer getModel_id() {
		return model_id;
	}

	public void setModel_id(Integer model_id) {
		this.model_id = model_id;
	}

	
	
}
