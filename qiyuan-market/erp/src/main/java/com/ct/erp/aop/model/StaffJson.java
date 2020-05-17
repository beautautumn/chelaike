package com.ct.erp.aop.model;


/**
 * @author shiqingwen
 */

public class StaffJson {

	// Fields

	private Long id;
	private String loginName;
	private String loginPwd;
	private String name;
	private Integer sex;
	private String tel;
	private String status;
	
	public StaffJson(com.ct.erp.lib.entity.Staff staff){
		if(staff != null){
			this.id = staff.getId();
			this.loginName = staff.getLoginName();
			this.loginPwd = staff.getLoginPwd();
			this.name = staff.getName();
			this.sex = staff.getSex();
			this.tel = staff.getTel();
			this.status = staff.getStatus();
		}
	}
	
	public Long getId() {
		return id;
	}
	public void setId(Long id) {
		this.id = id;
	}
	public String getLoginName() {
		return loginName;
	}
	public void setLoginName(String loginName) {
		this.loginName = loginName;
	}
	public String getLoginPwd() {
		return loginPwd;
	}
	public void setLoginPwd(String loginPwd) {
		this.loginPwd = loginPwd;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public Integer getSex() {
		return sex;
	}
	public void setSex(Integer sex) {
		this.sex = sex;
	}
	public String getTel() {
		return tel;
	}
	public void setTel(String tel) {
		this.tel = tel;
	}
	public String getStatus() {
		return status;
	}
	public void setStatus(String status) {
		this.status = status;
	}

	
	

}