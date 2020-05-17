package com.ct.erp.list.model;

public class Session {

	private String currentUser;
	private String currentDepartment;
	private String currentOrganization;
	
	

	public String getCurrentOrganization() {
		return currentOrganization;
	}

	public void setCurrentOrganization(String currentOrganization) {
		this.currentOrganization = currentOrganization;
	}

	public String getCurrentUser() {
		return currentUser;
	}

	public void setCurrentUser(String currentUser) {
		this.currentUser = currentUser;
	}

	public void setCurrentDepartment(String currentDepartment) {
		this.currentDepartment = currentDepartment;
	}

	public String getCurrentDepartment() {
		return currentDepartment;
	}
	
	
}
