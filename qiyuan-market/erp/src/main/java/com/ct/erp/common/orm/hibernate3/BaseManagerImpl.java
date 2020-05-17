package com.ct.erp.common.orm.hibernate3;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.transaction.annotation.Transactional;

import com.ct.erp.common.model.Pagination;

@Transactional
public class BaseManagerImpl<T extends Serializable> implements BaseManager<T> {
	protected Logger log = LoggerFactory.getLogger(getClass());
	private BaseDao<T> dao;

	public void setDao(BaseDao<T> dao) {
		this.dao = dao;
	}

	protected BaseDao<T> getDao() {
		return this.dao;
	}

	@Transactional(readOnly = true)
	public T findById(Serializable id) {
		return dao.get(id);
	}

	@Transactional(readOnly = true)
	public T load(Serializable id) {
		return dao.load(id);
	}

	@Transactional(readOnly = true)
	public List<T> findAll() {
		return dao.findAll();
	}

	@Transactional(readOnly = true)
	public Pagination findAll(int pageNo, int pageSize, OrderBy... orders) {
		return dao.findAll(pageNo, pageSize, orders);
	}

	/**
	 * ʵ����ҷ����б�
	 */

	@Transactional(readOnly = true)
	public List<T> findByEgList(T eg, boolean anywhere, Condition[] conds,
			String... exclude) {
		return dao.findByEgList(eg, anywhere, conds, exclude);
	}

	@Transactional(readOnly = true)
	public List<T> findByEgList(T eg, boolean anywhere, String... exclude) {
		return this.findByEgList(eg, anywhere, null, exclude);
	}

	@Transactional(readOnly = true)
	public List<T> findByEgList(T eg, Condition[] conds, String... exclude) {
		return this.findByEgList(eg, false, conds, exclude);
	}

	@Transactional(readOnly = true)
	public List<T> findByEgList(T eg, boolean anywhere, Condition[] conds,
			int firstResult, int maxResult, String... exclude) {
		return dao.findByEgList(eg, anywhere, conds, firstResult, maxResult,
				exclude);
	}

	@Transactional(readOnly = true)
	public List<T> findByEgList(T eg, boolean anywhere, int firstResult,
			int maxResult, String... exclude) {
		return this.findByEgList(eg, anywhere, null, firstResult, maxResult,
				exclude);
	}

	@Transactional(readOnly = true)
	public List<T> findByEgList(T eg, Condition[] conds, int firstResult,
			int maxResult, String... exclude) {
		return this.findByEgList(eg, false, conds, firstResult, maxResult,
				exclude);
	}

	@Transactional(readOnly = true)
	public List<T> findByEgList(T eg, String... exclude) {
		return this.findByEgList(eg, false, null, exclude);
	}

	@Transactional(readOnly = true)
	public Pagination findByEg(T eg, boolean anywhere, Condition[] conds,
			int pageNo, int pageSize, String... exclude) {
		return dao.findByEg(eg, anywhere, conds, pageNo, pageSize, exclude);
	}

	@Transactional(readOnly = true)
	public Pagination findByEg(T eg, boolean anywhere, int pageNo,
			int pageSize, String... exclude) {
		return this.findByEg(eg, anywhere, null, pageNo, pageSize, exclude);
	}

	@Transactional(readOnly = true)
	public Pagination findByEg(T eg, Condition[] conds, int pageNo,
			int pageSize, String... exclude) {
		return this.findByEg(eg, false, conds, pageNo, pageSize, exclude);
	}

	@Transactional(readOnly = true)
	public Pagination findByEg(T eg, int pageNo, int pageSize,
			String... exclude) {
		return this.findByEg(eg, false, null, pageNo, pageSize, exclude);
	}

	public Object updateByUpdater(Updater updater) {
		return dao.updateByUpdater(updater);
	}

	public Object updateDefault(Object entity) {
		return updateByUpdater(Updater.create(entity));
	}

	public T save(T entity) {
		return dao.save(entity);
	}

	public T saveAndRefresh(T entity) {
		this.save(entity);
		getDao().refresh(entity);
		return entity;
	}

	public Object saveOrUpdate(Object o) {
		return getDao().saveOrUpdate(o);
	}

	public void delete(Object o) {
		getDao().delete(o);
	}

	public Object update(Object o) {
		return getDao().update(o);
	}

	public Object merge(Object o) {
		return getDao().merge(o);
	}

	public T deleteById(Serializable id) {
		if (id == null) {
			return null;
		}
		return dao.deleteById(id);
	}

	public List<T> deleteById(Serializable[] ids) {
		List<T> dts = new ArrayList<T>();
		T del = null;
		if (ids != null && ids.length > 0) {
			for (Serializable id : ids) {
				del = deleteById(id);
				if (del != null) {
					dts.add(del);
				}
			}
		}
		return dts;
	}
}
