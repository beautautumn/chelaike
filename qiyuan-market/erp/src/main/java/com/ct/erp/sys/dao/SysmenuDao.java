package com.ct.erp.sys.dao;

import java.util.List;

import org.springframework.stereotype.Repository;

import com.ct.erp.common.orm.hibernate3.BaseDaoImpl;
import com.ct.erp.common.orm.hibernate3.Finder;
import com.ct.erp.lib.entity.LogParam;
import com.ct.erp.lib.entity.Sysmenu;

@Repository
public class SysmenuDao extends BaseDaoImpl<Sysmenu> {

	@SuppressWarnings("unchecked")
	public List<Sysmenu> findByStaffId(Long staffId) {
		String hql = "select distinct {t.*} from td_s_sysmenu t  "
				+ "	INNER JOIN td_s_sysright s ON t.right_code=s.right_code "
				+ " INNER JOIN tf_m_staff_right sr ON sr.right_code=t.right_code AND sr.staff_id=:staffId and status='1' "
				+ " order by t.order_no";
		return this.getSession().createSQLQuery(hql).addEntity("t",
				Sysmenu.class).setParameter("staffId", staffId).list();
	}

	@SuppressWarnings("unchecked")
	public List<Sysmenu> findFirstLevelMenusByStaffId(Long staffId) {
		String hql = "select distinct {t.*} from td_s_sysmenu t  "
				+ "	INNER JOIN td_s_sysright s ON t.right_code=s.right_code "
				+ " INNER JOIN tf_m_staff_right sr ON sr.right_code=t.right_code AND sr.staff_id=:staffId where t.parent_id is  null or t.parent_id =0 and status='1'"
				+ " order by t.order_no";
		return this.getSession().createSQLQuery(hql).addEntity("t",
				Sysmenu.class).setParameter("staffId", staffId).list();
	}


	/**
	 * 获取所有一级菜单
	 * 
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public List<Sysmenu> findAllAMenu() {
		String hql = "select menu from Sysmenu menu where menu.parentSysmenu.menuId=0 order by menu.showOrder";
		return this.getSession().createQuery(hql).list();
	}

	/**
	 * 根据viewId获得Sysmenu
	 * @param viewId
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public Sysmenu findSysmenuByViewId(String viewId) {
		String hql = "from Sysmenu s where s.url like :viewId";
		Finder finder = Finder.create(hql);
		finder.setParam("viewId", "%="+viewId);
		List<Sysmenu> list = this.find(finder);
		if ((list != null) && (list.size() > 0)) {
			return list.get(0);
		}
		return null;
	}
}
