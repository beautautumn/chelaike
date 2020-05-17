package com.ct.erp.core.tag;

import java.util.List;

import javax.servlet.jsp.JspException;
import javax.servlet.jsp.tagext.TagSupport;

import org.apache.commons.lang3.StringUtils;

import com.ct.erp.core.security.SecurityUtils;
import com.ct.erp.core.security.SessionInfo;
import com.ct.erp.lib.entity.Sysright;
import com.ct.util.lang.StrUtils;

@SuppressWarnings("serial")
public class AuthShareInfoTag extends TagSupport {

	//权限编码
	private String rightCode;
	//权限类型
	private Short rightType;
	
	private Integer userDepartId;
	
	private String subDepartId;
	
	private Integer infoDepartId;
	

	@Override
	public int doEndTag() throws JspException {
		// TODO Auto-generated method stub
		return super.doEndTag();
	}

	@Override
	public int doStartTag() throws JspException {
		boolean permitTag=false;
		boolean sysValuateTag=false;
		if(infoDepartId!=null&&infoDepartId==0){
			sysValuateTag=true;
		}else if(infoDepartId!=null&&userDepartId!=null&&StringUtils.isNotBlank(subDepartId)){
			//如果当前用户部门编码和信息部门编码属于同一个部门，或者子部门包含车辆编码，那么就校验是否拥有权限编码
			if(userDepartId==infoDepartId||StrUtils.contains(subDepartId, infoDepartId.toString())){
				sysValuateTag=true;
			}
		}else if(infoDepartId!=null&&userDepartId!=null){
			if(userDepartId==infoDepartId){
				sysValuateTag=true;
			}
		}
		if(sysValuateTag){
			//取权限列表
			SessionInfo sessionInfo = SecurityUtils.getCurrentSessionInfo();   		
			List<Sysright> sysrightList = sessionInfo.getSysrightList();	
			for(Sysright sys:sysrightList){			
				if(sys.getRightCode().equals(rightCode)&&sys.getRightType().equals(rightType)){
					permitTag=true;
					break;	
				}
			}
		}

		if(permitTag) { //包含权限，显示内容
			return TagSupport.EVAL_BODY_INCLUDE;
		}else {  //否则跳过
			return TagSupport.SKIP_BODY;
		}
	}
	public String getRightCode() {
		return rightCode;
	}

	public void setRightCode(String rightCode) {
		this.rightCode = rightCode;
	}

	public Short getRightType() {
		return rightType;
	}

	public void setRightType(Short rightType) {
		this.rightType = rightType;
	}

	public Integer getUserDepartId() {
		return userDepartId;
	}

	public void setUserDepartId(Integer userDepartId) {
		this.userDepartId = userDepartId;
	}

	public String getSubDepartId() {
		return subDepartId;
	}

	public void setSubDepartId(String subDepartId) {
		this.subDepartId = subDepartId;
	}

	public Integer getInfoDepartId() {
		return infoDepartId;
	}

	public void setInfoDepartId(Integer infoDepartId) {
		this.infoDepartId = infoDepartId;
	}
	
	
}
