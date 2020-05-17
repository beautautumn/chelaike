package com.ct.erp.common.spring;

import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;

import org.springframework.context.ApplicationContext;
import org.springframework.web.context.WebApplicationContext;
import org.springframework.web.context.support.WebApplicationContextUtils;

public class SpringContextInit implements ServletContextListener {

	private static WebApplicationContext context;

	public SpringContextInit() {
		super();
	}

	public void contextInitialized(ServletContextEvent event) {
		context = WebApplicationContextUtils.getRequiredWebApplicationContext(event.getServletContext());		
	}

	public void contextDestroyed(ServletContextEvent event) {
	}

	public static ApplicationContext getApplicationContext() {
		return context;
	}

}
