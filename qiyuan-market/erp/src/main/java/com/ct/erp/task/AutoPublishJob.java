package com.ct.erp.task;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;

public class AutoPublishJob {
  private static final Logger log = LoggerFactory.getLogger(AutoPublishJob.class);

	public void autoPublish() {
		try {
		} catch (Exception e) {
			e.printStackTrace();
			log.error("error in AutoRefreshJob.autoRefresh.method", e);
		}
	}
}
