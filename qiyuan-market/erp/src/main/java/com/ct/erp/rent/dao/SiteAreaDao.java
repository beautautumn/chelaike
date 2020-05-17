package com.ct.erp.rent.dao;

import java.util.ArrayList;
import java.util.List;

import com.ct.erp.common.orm.hibernate3.Finder;
import org.hibernate.Hibernate;
import org.springframework.stereotype.Repository;

import com.ct.erp.common.orm.hibernate3.BaseDaoImpl;
import com.ct.erp.lib.entity.SiteArea;

@Repository
public class SiteAreaDao extends BaseDaoImpl<SiteArea> {
	/**
	 * 根据id查找SiteArea对象
	 * @param id
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public SiteArea findById(Long id) {
		List<SiteArea> list = this.getSession()
				.createQuery("from SiteArea where id=:id")
				.setParameter("id", id).list();
		if ((list != null) && (list.size() > 0)) {
			return list.get(0);
		}
		return null;
	}

	@SuppressWarnings("unchecked")
	public List<SiteArea> findByCondition(List<String> current) {
		String hql = "from SiteArea s where s.status='1' and s.freeCount!= '0'";
		if((current!=null)&&(current.size()>0)){
			for(int i=0;i<current.size();i++){
				hql+=" and s.id <> "+current.get(i);
			}
		}
		List<SiteArea> list=this.getSession().createQuery(hql).list();
		return list;
	}
	@SuppressWarnings("unchecked")
	public List<SiteArea> findRentingArea(){
		return this.getSession()
				.createQuery("from SiteArea s where s.status='1' and s.totalCount!=s.freeCount")
				.list();
	}
	public List<SiteArea> findByStatus(String status){
		 List<SiteArea> list = this.getSession()
		.createQuery("from SiteArea s where s.status='"+status+"'")
		.list();
		 if(list!=null&&list.size()>0){
			 return list;
		 }else{
			 return null;
		 }
	}

	public List<SiteArea> findByMarketIdFull(Long marketId) {
		String hql = "from SiteArea s where s.marketId =:marketId";
		Finder finder = Finder.create(hql);
		finder.setParam("marketId", marketId);
		return this.find(finder);
	}

	public List<SiteArea> findByMarketId(Long marketId) {
		List<Object[]> list = this.getSession()
//				.createQuery("from SiteArea where market.marketId=:marketId")
				.createSQLQuery("select id, area_name from td_b_site_area where market_id = :marketId")
				.addScalar("id", Hibernate.LONG)
				.addScalar("area_name", Hibernate.STRING)
				.setParameter("marketId", marketId)
				.list();
		if(list == null){
			return new ArrayList<SiteArea>();
		}
		List<SiteArea> result = new ArrayList<SiteArea>();
		for(Object[] cols :list){
			SiteArea siteArea = new SiteArea();
			siteArea.setId((Long)cols[0]);
			siteArea.setAreaName(cols[1].toString());
			result.add(siteArea);
		}
		return result;
	}
}
