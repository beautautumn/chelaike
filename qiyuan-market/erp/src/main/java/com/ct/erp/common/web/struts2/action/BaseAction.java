package com.ct.erp.common.web.struts2.action;

import java.io.IOException;
import java.util.Collection;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletResponse;

import org.apache.struts2.ServletActionContext;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.ct.erp.common.model.Pagination;
import com.opensymphony.xwork2.Action;
import com.opensymphony.xwork2.Validateable;
import com.opensymphony.xwork2.ValidationAware;
import com.opensymphony.xwork2.ValidationAwareSupport;

@SuppressWarnings( { "serial", "unchecked" })
public class BaseAction implements Action, java.io.Serializable, Validateable,
		ValidationAware {
	private static final Logger log = LoggerFactory.getLogger(BaseAction.class);
	private final ValidationAwareSupport validationAware = new ValidationAwareSupport();
	protected Long[] ids;
	protected Pagination pagination;
	protected List list;
	protected int pageNo = 1;
	protected String errMsg = null;
	protected int errno = 0;
	protected HashMap errors = new HashMap<String, String>();
	public static final String LIST = "list";
	public static final String EDIT = "edit";
	public static final String ADD = "add";
	public static final String SELECT = "select";
	public static final String QUERY = "query";
	public static final String LEFT = "left";
	public static final String RIGHT = "right";
	public static final String INDEX = "index";
	public static final String MAIN = "main";
	public static final String JSON = "json";
	public static final String ERROR = "error";


	/**
	 * 绕过Template,直接输出内容的简便函数.
	 */
	protected String render(String text, String contentType) {
		try {
			HttpServletResponse response = ServletActionContext.getResponse();
			response.setContentType(contentType);
			response.getWriter().write(text);
		} catch (IOException e) {
			log.error(e.getMessage(), e);
		}
		return null;
	}

	/**
	 * 直接输出字符串.
	 */
	protected String renderText(String text) {
		return this.render(text, "text/plain;charset=UTF-8");
	}

	/**
	 * 直接输出字符串GBK编码.
	 */
	protected String renderHtmlGBK(String html) {
		return this.render(html, "text/html;charset=GBK");
	}

	/**
	 * 直接输出XML.
	 */
	protected String renderXML(String xml) {
		return this.render(xml, "text/xml;charset=UTF-8");
	}

	public String main() throws Exception {
		return MAIN;
	}

	public String change() throws Exception {
		return EDIT;
	}

	public String add() throws Exception {
		return ADD;
	}

	public String select() throws Exception {
		return SELECT;
	}

	public String execute() throws Exception {
		return SUCCESS;
	}

	public void setActionErrors(Collection errorMessages) {
		this.validationAware.setActionErrors(errorMessages);
	}

	public Collection getActionErrors() {
		return this.validationAware.getActionErrors();
	}

	public void setActionMessages(Collection messages) {
		this.validationAware.setActionMessages(messages);
	}

	public Collection getActionMessages() {
		return this.validationAware.getActionMessages();
	}

	public void setFieldErrors(Map errorMap) {
		this.validationAware.setFieldErrors(errorMap);
	}

	public Map getFieldErrors() {
		return this.validationAware.getFieldErrors();
	}

	public boolean hasActionErrors() {
		return this.validationAware.hasActionErrors();
	}

	public boolean hasActionMessages() {
		return this.validationAware.hasActionMessages();
	}

	public boolean hasErrors() {
		return this.validationAware.hasErrors();
	}

	public boolean hasFieldErrors() {
		return this.validationAware.hasFieldErrors();
	}

	public void addActionError(String anErrorMessage) {
		this.validationAware.addActionError(anErrorMessage);
	}

	public void addActionMessage(String aMessage) {
		this.validationAware.addActionMessage(aMessage);
	}

	public void addFieldError(String fieldName, String errorMessage) {
		this.validationAware.addFieldError(fieldName, errorMessage);
	}

	public void validate() {
	}

	public Long[] getIds() {
		return this.ids;
	}

	public void setIds(Long[] ids) {
		this.ids = ids;
	}

	public Pagination getPagination() {
		return this.pagination;
	}

	public void setPagination(Pagination pagination) {
		this.pagination = pagination;
	}

	public int getPageNo() {
		return this.pageNo;
	}

	public void setPageNo(int pageNo) {
		this.pageNo = pageNo;
	}

	public List getList() {
		return this.list;
	}

	public void setList(List list) {
		this.list = list;
	}

	public String getErrMsg() {
		return this.errMsg;
	}

	public void setErrMsg(String errMsg) {
		this.errMsg = errMsg;
	}

	public int getErrno() {
		return this.errno;
	}

	public void setErrno(int errno) {
		this.errno = errno;
	}

	public void putError(String name, String message) {
		this.errors.put(name, message);
	}

	public HashMap getErrors() {
		return this.errors;
	}
}
