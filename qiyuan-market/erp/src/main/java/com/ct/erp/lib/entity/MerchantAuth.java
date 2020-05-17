package com.ct.erp.lib.entity;

import java.sql.Timestamp;

public class MerchantAuth implements java.io.Serializable{
	// Fields

		private long id;
		private long agencyId;
		private String authorzationCode;
		private String tel;
		private String openid;
		/**
		 * 状态0:启用,1:禁用  
		 */
		private String state;
		/**
		 * 授权码是否被商户绑定
		 * 1:绑定
		 * 0:未绑定
		 */
		private String isused;
		private Timestamp createTime ;
		private Timestamp updateTime ;
		/** default constructor */
		public MerchantAuth() {
		}

		/** full constructor */
		public MerchantAuth(long id, long agencyId, String authorzationCode,
				String tel, String openid,String state,String isused,Timestamp createTime,Timestamp updateTime) {
			this.id = id;
			this.agencyId = agencyId;
			this.authorzationCode = authorzationCode;
			this.tel = tel;
			this.openid = openid; 
			this.state = state;
			this.isused=isused ;
			this.createTime = createTime;
			this.updateTime = updateTime;
		}
 

		public long getId() {
			return id;
		}

		public void setId(long id) {
			this.id = id;
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

		 
		public Timestamp getCreateTime() {
			return createTime;
		}

		public void setCreateTime(Timestamp createTime) {
			this.createTime = createTime;
		}

		public Timestamp getUpdateTime() {
			return updateTime;
		}

		public void setUpdateTime(Timestamp updateTime) {
			this.updateTime = updateTime;
		}

		public long getAgencyId() {
			return agencyId;
		}

		public void setAgencyId(long agencyId) {
			this.agencyId = agencyId;
		}

		public String getAuthorzationCode() {
			return authorzationCode;
		}

		public void setAuthorzationCode(String authorzationCode) {
			this.authorzationCode = authorzationCode;
		}

		public String getState() {
			return state;
		}

		public void setState(String state) {
			this.state = state;
		}
		
		public String getIsused() {
			return isused;
		}
		public void setIsused(String isused) {
			this.isused = isused;
		}
				 
		
}
