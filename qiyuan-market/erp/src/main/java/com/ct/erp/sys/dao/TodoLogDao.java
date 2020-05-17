package com.ct.erp.sys.dao;

import java.sql.Timestamp;
import java.util.Date;
import java.util.List;

import org.springframework.stereotype.Repository;

import com.ct.erp.common.orm.hibernate3.BaseDaoImpl;
import com.ct.erp.lib.entity.Staff;
import com.ct.erp.lib.entity.Sysmenu;
import com.ct.erp.lib.entity.TodoLog;
@Repository
public class TodoLogDao extends BaseDaoImpl<TodoLog> {

	@SuppressWarnings("unchecked")
	public List<TodoLog> findBystaffIdAndState(Long staffId,
			int pageNo, int pageSize) {
		return this.getSession()//
					.createQuery("select s from TodoLog s where s.staffByNotifyStaff.id=:staffId")//
					.setParameter("staffId", staffId)//
					.setFirstResult(pageNo)//
					.setMaxResults(pageSize)//
					.list();
	}

	@SuppressWarnings("unchecked")
	public List<TodoLog> findAllWaitSend() {
		String hql = "from TodoLog m where m.todoState=:todoState";
		return this.getSession().createQuery(hql).setParameter("todoState", '0').list();
	}
	
	@SuppressWarnings("unchecked")
	public Sysmenu findByRightCode(String rightCode){
		 List<Sysmenu> list = this.getSession()
		 						.createQuery("from Sysmenu s where s.sysright.rightCode=:rightCode")
		 						.setParameter("rightCode", rightCode)
		 						.list();
		 if(list!=null&&list.size()>0){
			 return list.get(0);
		 }else{
			 return null;
		 }
	}
	
	@SuppressWarnings("unchecked")
	public List<TodoLog> findByRightCodeandObjId(String rightCode,Long objId){
		return this.getSession()
				.createQuery("from TodoLog s where s.todoObjId=:objId and s.sysmenu.sysright.rightCode=:rightCode")
				.setParameter("objId", objId)
				.setParameter("rightCode", rightCode)
				.list();
	}
	/**
	 * 创建待办提醒
	 * @param rightCode
	 * @param objId
	 * @param todoTitle
	 * @param notifyStaff
	 */
	public void createTodoLog(String rightCode,Long objId,String todoTitle,Staff notifyStaff){
		TodoLog todoLog = new TodoLog();
		Sysmenu sysmenu = findByRightCode(rightCode);
		todoLog.setSysmenu(sysmenu);
		todoLog.setTodoObjId(objId);
		todoLog.setTodoTitle(todoTitle);
		todoLog.setStaffByNotifyStaff(notifyStaff);
		todoLog.setTodoState("0");
		todoLog.setSubmitRightCodes("");
		todoLog.setCreateTime(new Timestamp(new Date().getTime()));
		this.getSession().save(todoLog);
	}
	
	/**
	 * 删除待办提醒
	 * @param rightCode
	 * @param objId
	 */
	public void delectTodoLog(String rightCode,Long objId){
		List<TodoLog> list = findByRightCodeandObjId(rightCode,objId);
		if(list!=null&&list.size()>0){
			for(TodoLog todoLog:list){
				this.getSession().delete(todoLog);
			}
		}
	}
}
