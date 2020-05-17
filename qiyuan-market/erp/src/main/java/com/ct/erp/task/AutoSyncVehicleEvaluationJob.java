package com.ct.erp.task;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import com.ct.erp.task.service.VehicleEvaluationService;

/**
 * 车辆评估定时器
 * 
 * @author chenqiushi
 *
 */
@Component(value="autoSyncVehicleEvaluation")
public class AutoSyncVehicleEvaluationJob {
	private static final Logger log = LoggerFactory.getLogger(AutoSyncVehicleEvaluationJob.class);

	@Autowired
	private VehicleEvaluationService vehicleEvaluationService;
	
	/**
	 * 自动同步che300估值系统
	 */
	public void autoSyncVehicleEvaluation() {
		try {
			log.error("自动同步che300估值系统开始");
			this.vehicleEvaluationService.vehicleEvaluation();
			log.error("自动同步che300估值系统结束");
		} catch (Exception e) {
			log.error("自动同步che300估值系统异常", e);
		}
	}
}
