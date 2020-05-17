package com.ct.erp.common.service;

public class ContextStateDriver {

	public StateDriverService stateDriverService;

	public ContextStateDriver(StateDriverService stateDriverService) {
		this.stateDriverService = stateDriverService;
	}

	public void doHandleDriver(Object entity,String rightCode,
			Integer staffId, boolean waitReply) throws Exception {
		if (stateDriverService != null)
			stateDriverService.changeDriverState(entity, rightCode, staffId,
					waitReply);
	}
}
