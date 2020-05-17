package com.ct.erp.common.service;

/**
 * 新的状态流程驱动接口
 * @author jieketao
 *
 */
public interface StateDriverService {

	/**
	 * 状态流程驱动修改
	 * @param entity      操作实体
	 * @param typeTag     操作类型
	 * @param rightCode   权限编码
	 * @param staffId     员工id
	 * @param waitReply   
	 * @throws Exception
	 */
	public void changeDriverState(Object entity,
			String rightCode, Integer staffId, boolean waitReply)
			throws Exception;

}