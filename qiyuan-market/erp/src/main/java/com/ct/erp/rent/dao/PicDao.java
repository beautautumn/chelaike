package com.ct.erp.rent.dao;

import java.util.List;

import org.hibernate.Query;
import org.springframework.stereotype.Repository;

import com.ct.erp.common.orm.hibernate3.BaseDaoImpl;
import com.ct.erp.common.orm.hibernate3.Finder;
import com.ct.erp.lib.entity.Pic;
@Repository
public class PicDao extends BaseDaoImpl<Pic>{
  
	@SuppressWarnings("unchecked")
	public List<Pic> findPicByObjId(Long objId){
		String hql = "select p from Pic p " +
				"where p.objId=:objId and p.picType = '0' ";
		Query query = super.getSession().createQuery(hql);
		query.setParameter("objId", objId);
		List<Pic> PicList =query.list();
		if ((PicList != null) && (PicList.size() > 0)) {
			return PicList;
		}
		return null;
	}	
	
	@SuppressWarnings("unchecked")
	public Pic findPicById(Long picId){
		String hql = "select p from Pic p where p.id=:picId";
		Query query = super.getSession().createQuery(hql);
		query.setParameter("picId", picId);
		List<Pic> PicList =query.list();
		if ((PicList != null) && (PicList.size() > 0)) {
			return PicList.get(0);
		}
		return null;
	}

	 @SuppressWarnings("unchecked")
	 public Pic findVehicleCheckPic(Long tradeId){
	    String hql = "  from Pic p where p.objId=:tradeId and p.picType=3";
	    
	    Finder finder =Finder.create(hql);
	    finder.setParam("tradeId", tradeId);
	    List<Pic> PicList =this.find(finder);
	    if ((PicList != null) && (PicList.size() > 0)) {
	      return PicList.get(0);
	    }
	    return null;
	 }
	
	@SuppressWarnings("unchecked")
	public Pic findByContractId(Long contractId) {
		List<Pic> list=this.getSession().createQuery("from Pic p where p.objId=:objId " +
				"and p.picType = '1' ").setParameter("objId", contractId).list();
		if(list!=null&&list.size()!=0){
			return list.get(0);
		}
		return null;
	}

	@SuppressWarnings("unchecked")
	public Pic findPicByTradeId(Long tradeId) {
		List<Pic> list=this.getSession().createQuery("from Pic p where p.objId=:objId " +
				"and p.picType = '2' ").setParameter("objId", tradeId).list();
		if(list!=null&&list.size()!=0){
			return list.get(0);
		}
		return null;
	}

	@SuppressWarnings("unchecked")
	public Pic findByShopContractId(Long shopContractId) {
		List<Pic> list=this.getSession().createQuery("from Pic p where p.objId=:objId " +
				"and p.picType = '4' ").setParameter("objId", shopContractId).list();
		if(list!=null&&list.size()!=0){
			return list.get(0);
		}
		return null;
	}
	
	
}
