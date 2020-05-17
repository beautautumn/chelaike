package com.ct.erp.sys.dao;

import java.sql.Timestamp;
import java.util.Date;
import java.util.List;

import org.hibernate.Query;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.ct.erp.common.orm.hibernate3.BaseDaoImpl;
import com.ct.erp.common.orm.hibernate3.Finder;
import com.ct.erp.core.security.SecurityUtils;
import com.ct.erp.lib.entity.OperHis;

@Repository
public class OperHisDao extends BaseDaoImpl<OperHis> {
	@Autowired
	private StaffDao staffDao;
	/**
	 * 插入操作记录
	 * @param operObj 操作对象Id
	 * @param operTag 操作类型（0：合同；1：物业费；2：商户；3：场地区域）
	 * @param operDesc 操作说明
	 */
	public void createNewOperHis(Long operObj,String operTag,String operDesc){
		OperHis operHis = new OperHis();
		operHis.setStaff(staffDao.findById(SecurityUtils.getCurrentSessionInfo().getStaffId()));
		operHis.setOperTime(new Timestamp(new Date().getTime()));
		operHis.setOperObj(operObj);
		operHis.setOperTag(operTag);
		operHis.setOperDesc(operDesc);
		this.getSession().save(operHis);
	}
	
	public List<OperHis> findHisListByObj(Integer objId) {
		String hql = "from OperHis h where h.operObj =:objId and h.operTag=0"
				+ "and h.operDesc not like '%上传车辆照片%' and h.operDesc not like '%收购价格%'"
				+ "order by h.operTime desc";
		Finder finder = Finder.create(hql);
		finder.setParam("objId", objId);
		return this.find(finder);
	}

	public List<OperHis> findHisListByObjIdAndTag(Long objId, short operTag) {
		String hql = "from OperHis h where h.operObj =:objId and h.operTag=:operTag  order by h.operTime desc";
		Finder finder = Finder.create(hql);
		finder.setParam("objId", objId);
		finder.setParam("operTag", operTag);
		return this.find(finder);
	}
	public List<OperHis> findHisListByObjIdAndTag(Long objId, String operTag) {
		String hql = "from OperHis h where h.operObj =:objId and h.operTag=:operTag  order by h.operTime desc";
		Finder finder = Finder.create(hql);
		finder.setParam("objId", objId);
		finder.setParam("operTag", operTag);
		return this.find(finder);
	}

	public List<OperHis> findHisListByObjIdAndRightCode(Integer objId,
			Short operTag, String rightCode) {
		String hql = "from OperHis h where h.operObj =:objId and h.operTag=:operTag and h.sysright.rightCode=:rightCode order by h.operTime desc";
		Finder finder = Finder.create(hql);
		finder.setParam("objId", objId);
		finder.setParam("operTag", operTag);
		finder.setParam("rightCode", rightCode);
		return this.find(finder);
	}

	public int deleteOperHisByObj(Integer objId, Short operTag) {
		Query query = super
				.getSession()
				.createQuery(
						"delete from OperHis t where t.operObj =:objId and t.operTag=:operTag ");
		query.setParameter("objId", objId);
		query.setParameter("operTag", operTag);
		return query.executeUpdate();
	}

	public List<OperHis> findAcquHisListByObj(Integer objId) {
		String hql = "from OperHis h where h.operObj =:objId and h.operTag in(3,4) order by h.operTime desc";
		Finder finder = Finder.create(hql);
		finder.setParam("objId", objId);
		return this.find(finder);
	}

	public OperHis findHisListByObjAcquStaff(Integer objId, Short operTag) {
		String hql = "from OperHis h where h.operObj =:objId and h.operTag=:operTag and h.sysright.rightCode=131 order by h.operTime desc";
		Finder finder = Finder.create(hql);
		finder.setParam("objId", objId);
		finder.setParam("operTag", operTag);
		List<OperHis> operhis = this.find(finder);
		for (int i = 0; i < operhis.size(); i++) {
			return operhis.get(0);
		}
		return null;
	}

	public OperHis findHisListByObjSaleStaff(Integer objId, Short operTag) {
		String hql = "from OperHis h where h.operObj =:objId and h.operTag=:operTag and h.sysright.rightCode=401 order by h.operTime desc";
		Finder finder = Finder.create(hql);
		finder.setParam("objId", objId);
		finder.setParam("operTag", operTag);
		List<OperHis> operhis = this.find(finder);
		for (int i = 0; i < operhis.size(); i++) {
			return operhis.get(0);
		}
		return null;
	}

	public OperHis findLastBackOperBySaleId(Integer saleId) {
		String hql = "from OperHis h where h.operObj=:saleId and h.sysright.rightCode in ('252','262') order by h.operTime desc";
		Finder finder = Finder.create(hql);
		finder.setParam("saleId", saleId);
		if ((this.find(finder) != null) && (this.find(finder).size() > 0)) {
			return (OperHis) this.find(finder).get(0);
		} else {
			return null;

		}

	}

}
