package com.ct.erp.common.web.struts2.action;

import org.springframework.beans.factory.annotation.Autowired;

import com.ct.erp.common.web.struts2.ContextPvd;
import com.ct.erp.common.web.struts2.interceptor.ProcessingStartInterceptor;

public class CmmCoreAction extends BaseAction {

	
	private static final long serialVersionUID = 1L;

	/**
	 * 错误提示页面
	 */
	public static final String SHOW_ERROR = "showError";

	/**
	 * 默认记录数
	 */
	public static final int DEFAULT_COUNT = 20;
	
	public String id;


	/**
	 * 获得页面执行时间ms
	 * 
	 * @return 返回页面执行时间(s)。-1代表没有找到页面开始执行时间。
	 */
	public float getProcessedIn() {
		Long time = (Long) this.contextPvd
				.getRequestAttr(ProcessingStartInterceptor.PROCESSING_START);
		if (time != null) {
			return (System.nanoTime() - time) / 1000 / 1000000F;
		}
		return -1;
	}
	
	

	public String getId() {
		return id;
	}



	public void setId(String id) {
		this.id = id;
	}



	@Autowired
	protected ContextPvd contextPvd;
	
	
}
