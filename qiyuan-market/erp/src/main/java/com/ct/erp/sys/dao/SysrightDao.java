package com.ct.erp.sys.dao;

import java.util.List;

import org.springframework.stereotype.Repository;

import com.ct.erp.common.orm.hibernate3.BaseDaoImpl;
import com.ct.erp.common.orm.hibernate3.Finder;
import com.ct.erp.lib.entity.Sysright;

@Repository
public class SysrightDao extends BaseDaoImpl<Sysright> {

	public List<Sysright> findSysrightByRightCode(Integer staffId) {
		Finder finder = Finder
				.create("select s from Sysright s where s.rightCode in(select rr.sysright.rightCode from Roleright rr where rr.role.roleCode in(select sr.role.roleCode from Staffrole sr where sr.staff.staffId =:staffId))");
		finder.setParam("staffId", staffId);
		return this.find(finder);
	}
	
	public List<Sysright> findSysrightListByStaffId(Long staffId)throws Exception{
		Finder finder = Finder
				.create("select distinct s from Sysright s where s.rightCode in" +
						
						"		(select sr.sysright.rightCode from StaffRight sr where sr.staff.id =:staffId)   ORDER BY s.parentSysright.rightCode ,s.showOrder");
		finder.setParam("staffId", staffId);
		return this.find(finder);
	}

	public List<Sysright> findSysrightByRoleCode(Integer roleCode) {
		Finder finder = Finder
				.create("select s from Sysright s where s.rightCode in(select r.sysright.rightCode from Roleright r where r.role.roleCode =:roleCode)");
		finder.setParam("roleCode", roleCode);
		return this.find(finder);
	}

	@SuppressWarnings("unchecked")
	public List<Sysright> findSysrightByRoleCode() {
		Finder finder = Finder
				.create("select s from Sysright s where s.rightType=0");
		// where s.rightCode in(select r.sysright.rightCode from Roleright r
		// where r.role.roleCode =:roleCode)
		// finder.setParam("roleCode", roleCode);
		return this.find(finder);
	}
	
	public List<Sysright> findSysrightByRightCodes(List rightCodes) {
		Finder finder = Finder
				.create("select s from Sysright s where s.rightCode in (:rightCodes) ");		
		finder.setParamList("rightCodes", rightCodes);
		return this.find(finder);
	}

	/**
	 * 查找所有一级权限列表
	 * 
	 * @return 所有一级权限列表
	 */
	@SuppressWarnings("unchecked")
	public List<Sysright> getAllASysright() {
		Finder finder = Finder.create("select s from Sysright s "
				+ "where (parentRightCode is null or parentRightCode='') "
				+ "and (s.rightType=0 or s.rightType=1) order by s.showOrder");
		return this.find(finder);
	}

	/**
	 * 根据上级权限编码查找下级权限列表
	 * 
	 * @param parentCode 上级权限编码
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public List<Sysright> getAllSubSysright(String parentCode) {
		Finder finder = Finder
				.create("select s from Sysright s where parentRightCode=:parentRightCode "
						+ "and (s.rightType=0 or s.rightType=1) order by s.showOrder");
		finder.setParam("parentRightCode", parentCode);
		return this.find(finder);
	}

	/**
	 * 根据权限编码获取上级权限
	 * 
	 * @param rightCode 权限编码
	 * @return 上级权限
	 */
	@SuppressWarnings("unchecked")
	public Sysright findParentSysright(String rightCode) {
		Finder finder = Finder
				.create("select parent from Sysright parent, Sysright sub "
						+ "where sub.parentRightCode=parent.rightCode "
						+ "and sub.rightCode=:rightCode");
		finder.setParam("rightCode", rightCode);
		List<Sysright> rights = this.find(finder);
		if ((rights != null) && (rights.size() > 0)) {
			return rights.get(0);
		}
		return null;
	}
}
