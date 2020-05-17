package com.ct.erp.core.tag;

import java.util.List;

import javax.servlet.jsp.JspException;
import javax.servlet.jsp.tagext.TagSupport;

import com.ct.erp.core.security.SecurityUtils;
import com.ct.erp.core.security.SessionInfo;
import com.ct.erp.lib.entity.Sysright;

/**
 * 通用的判断是否有权限权操作，从登陆是保存在session中的
 * 权限编码以及权限类型继续判断，如果存在那么展现里面的内容
 * 如果不存在就跳过里面的内容
 * @author jieketao
 *
 */
@SuppressWarnings("serial")
public class AuthenticationTag extends TagSupport {

	//权限编码
	private String rightCode;
	//权限类型
	private Short rightType;
	

	@Override
	public int doEndTag() throws JspException {
		// TODO Auto-generated method stub
		return super.doEndTag();
	}

	@Override
	public int doStartTag() throws JspException {
		//取权限列表
		SessionInfo sessionInfo = SecurityUtils.getCurrentSessionInfo();   		
		List<Sysright> sysrightList = sessionInfo.getSysrightList();
		boolean permitTag=false;
		for(Sysright sys:sysrightList){			
			if(sys.getRightCode().equals(rightCode)){
				permitTag=true;
				break;	
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
	
	

}
