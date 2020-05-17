package com.ct.erp.wx.auth.model;

/**
 * 微信授权
 * @author mxy
 *
 */
public class MerchantAuthBean {

	private String id ;
	private String agencyId;
	private String authorizationCode ;
	private String tel;
	private String openid ;
	private String state ;
	private String isused ;
	private String createTime;
	private String updateTime ;
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public String getAgencyId() {
		return agencyId;
	}
	public void setAgencyId(String agencyId) {
		this.agencyId = agencyId;
	}
	public String getAuthorizationCode() {
		return authorizationCode;
	}
	public void setAuthorizationCode(String authorizationCode) {
		this.authorizationCode = authorizationCode;
	}
	public String getTel() {
		return tel;
	}
	public void setTel(String tel) {
		this.tel = tel;
	}
	public String getOpenid() {
		return openid;
	}
	public void setOpenid(String openid) {
		this.openid = openid;
	}
	public String getState() {
		return state;
	}
	public void setState(String state) {
		this.state = state;
	}
	public String getCreateTime() {
		return createTime;
	}
	public void setCreateTime(String createTime) {
		this.createTime = createTime;
	}
	public String getUpdateTime() {
		return updateTime;
	}
	public void setUpdateTime(String updateTime) {
		this.updateTime = updateTime;
	}
	public String getIsused() {
		return isused;
	}
	public void setIsused(String isused) {
		this.isused = isused;
	}
	

}
