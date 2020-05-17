package com.ct.erp.list.model;

public class PageConfigBean {

	private Form form;
	private PageInfo page;
	private Session session;
	private String title;
	private String params;
	

	
	public String getParams() {
		return params;
	}
	public void setParams(String params) {
		this.params = params;
	}
	public String getTitle() {
		return title;
	}
	public void setTitle(String title) {
		this.title = title;
	}
	public Session getSession() {
		return session;
	}
	public void setSession(Session session) {
		this.session = session;
	}
	public Form getForm() {
		return form;
	}
	public void setForm(Form form) {
		this.form = form;
	}
	public PageInfo getPage() {
		return page;
	}
	public void setPage(PageInfo page) {
		this.page = page;
	}
	
}
