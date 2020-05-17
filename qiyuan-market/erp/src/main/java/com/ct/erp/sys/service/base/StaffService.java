package com.ct.erp.sys.service.base;

import java.util.ArrayList;
import java.util.List;

import com.ct.erp.util.DataSync;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.ct.erp.common.exception.ServiceException;
import com.ct.erp.common.utils.reflection.MyBeanUtils;
import com.ct.erp.constants.BiConst;
import com.ct.erp.core.security.SecurityUtils;
import com.ct.erp.core.security.SessionInfo;
import com.ct.erp.lib.entity.Staff;
import com.ct.erp.lib.entity.StaffRight;
import com.ct.erp.lib.entity.Sysmenu;
import com.ct.erp.lib.entity.Sysright;
import com.ct.erp.sys.dao.StaffDao;
import com.ct.erp.sys.dao.StaffRightDao;
import com.ct.erp.sys.dao.SysmenuDao;
import com.ct.erp.sys.dao.SysrightDao;
import com.ct.erp.util.UcmsWebUtils;

@Service
public class StaffService {

	@Autowired
	private StaffDao staffDao;
	@Autowired
	private StaffRightDao staffRightDao;
	@Autowired
	private SysmenuDao sysmenuDao;
	@Autowired
	private SysrightDao sysrightDao;
	@Autowired
	SysrightService sysrightService;

	@Autowired
	private DataSync dataSync;
	public List<Staff> findAll(){
		return staffDao.findAll();
	}
    
	//获取有效的用户
	public List<Staff> findAllValid(){
		return staffDao.findAllValid();
	}
	
	/**
	 * 根据用户名密码查找有效用户
	 * 
	 * @param userName 用户名
	 * @param password 密码
	 * @return 有效用户
	 * @throws Exception
	 */
	public Staff findValidStaffByNP(String userName, String password)
			throws Exception {
		List<Staff> staffs = this.staffDao.findStaffByNPS(userName, password,
				BiConst.VALID_STAFF_TAG);
		if ((null != staffs) && (staffs.size() > 0)) {
			return staffs.get(0);
		}
		return null;
	}

	public List<Sysright> findStaffRightByStaffId(Long staffId)
			throws ServiceException {
		List<StaffRight> staffRightList = this.staffRightDao
				.findStaffRightListByStaffId(staffId);
		if (staffRightList == null) {
			return null;
		}
		List<Sysright> sysrightList = new ArrayList<Sysright>();
		for (StaffRight right : staffRightList) {
			sysrightList.add(right.getSysright());
		}
		return sysrightList;
	}

	public List<String> findSysrightCodeByList(List<Sysright> sysrightList) {
		if (sysrightList == null) {
			return null;
		}
		List<String> result = new ArrayList<String>();
		for (Sysright sysright : sysrightList) {
			result.add(sysright.getRightCode());
		}
		return result;
	}


	public List<Sysmenu> findSysmenuListByStaffId(Long staffId) {
		return this.sysmenuDao.findByStaffId(staffId);
	}

	public Staff findStaffById(Long staffId) {
		return this.staffDao.get(staffId);
	}
	
	public Staff findById(Long staffId){
		return this.staffDao.findById(staffId);
	}
	

	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = ServiceException.class)
	public void saveStaff(Staff entity) throws ServiceException {
		try {
			if (entity.getId() != null) {
				Staff staff = this.staffDao.get(entity.getId());
				MyBeanUtils.copyBeanNotNull2Bean(entity, staff);
				this.staffDao.update(staff);
			} else {
				this.staffDao.save(entity);
			}
		} catch (Exception e) {
			throw new ServiceException("Error in method saveStaff", e);
		}
	}

	/**
	 * MAC地址转换
	 * 负责把全角转换为半角，并且把-或：转换为$
	 * 
	 * @param input
	 * @return
	 */
	private String macConvert(String input) {
		char c[] = input.toCharArray();
		for (int i = 0; i < c.length; i++) {
			if (c[i] == '\u3000') {
				c[i] = ' ';
			} else if ((c[i] > '\uFF00') && (c[i] < '\uFF5F')) {
				c[i] = (char) (c[i] - 65248);
			}
			if ((c[i] == ':') || (c[i] == '-')) {
				c[i] = '$';
			}
		}
		String returnString = new String(c);
		return returnString;
	}

	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = ServiceException.class)
	public void saveStaffRight(Staff entity, String functionid)
			throws ServiceException {
		SessionInfo sessionInfo = SecurityUtils.getCurrentSessionInfo();
		try {
			if (entity.getId() != null) {
				Staff staff = this.staffDao.get(entity.getId());
				staff.setLoginName(entity.getLoginName());
				staff.setName(entity.getName());
				staff.setTel(entity.getTel());
				staff.setRemark(entity.getRemark());
				staff.setSex(entity.getSex());
				staff.setStatus(entity.getStatus());
				this.staffDao.update(staff);
				List<Sysright> sysrightList = this.sysrightDao
						.findSysrightListByStaffId(staff.getId());
				List<Sysright> manageSysrightList = this.sysrightDao
						.findSysrightListByStaffId(sessionInfo.getStaffId());
				String funcs[] = functionid.split(",");
				List<String> addFuns = new ArrayList<String>();
				List<String> delFuns = new ArrayList<String>();
				if (StringUtils.isNotBlank(functionid)) {
					addFuns = getRightAddList(funcs, sysrightList);
					List<String> parentFuns = getRightAddRecuiseList(
							addFuns, manageSysrightList);
					if ((parentFuns != null) && (parentFuns.size() > 0)) {
						addFuns.addAll(parentFuns);
					}
					delFuns = getRightDelList(funcs, sysrightList);
				} else {
					for (Sysright node : sysrightList) {
						delFuns.add(node.getRightCode());
					}
				}
				for (String fun : addFuns) {
					Sysright sysright = this.sysrightDao.get(fun);
					StaffRight right = new StaffRight();
					right.setStaff(entity);
					right.setSysright(sysright);
					staff.setCreateTime(UcmsWebUtils.now());
					this.staffRightDao.save(right);
				}
				for (String fun : delFuns) {
					List<StaffRight> rightList = this.staffRightDao
							.findByStaffAndRightCode(fun, staff.getId());
					for (StaffRight right : rightList) {
						this.staffRightDao.delete(right);
					}
				}
			} else {
				entity.setCreateTime(UcmsWebUtils.now());
				entity.setUpdateTime(UcmsWebUtils.now());
				entity = this.staffDao.save(entity);
				if ((entity.getId() != null)
						&& StringUtils.isNotBlank(functionid)) {
					String funcs[] = functionid.split(",");
					for (String fun : funcs) {
						Sysright sysright = this.sysrightDao.get(fun);
						StaffRight right = new StaffRight();
						right.setStaff(entity);
						right.setSysright(sysright);
						this.staffRightDao.save(right);
					}
				}
			}
		} catch (Exception e) {
			throw new ServiceException("Error in method saveStaffRight", e);
		}
	}

	private List<String> getRightAddList(String funcs[],
			List<Sysright> sysrightList) {
		List<String> result = new ArrayList<String>();
		for (String fun : funcs) {
			boolean existFlag = false;
			for (Sysright node : sysrightList) {
				if (node.getRightCode().equals(fun)) {
					existFlag = true;
					break;
				}
			}
			if (!existFlag) {
				result.add(fun);
			}
		}
		return result;
	}

	private List<String> getRightAddRecuiseList(List<String> funcs,
			List<Sysright> sysrightList) {
		List<String> result = new ArrayList<String>();
		for (String fun : funcs) {
			for (Sysright node : sysrightList) {
				if (node.getRightCode().equals(fun)) {
					if ((node.getParentSysright() != null)
							&& StringUtils.isNotBlank(node.getParentSysright()
									.getRightCode())) {
						if (!rightCodeExists(node.getParentSysright()
								.getRightCode(), funcs)) {
							result.add(node.getParentSysright().getRightCode());
							Sysright pright = this.sysrightDao.get(node
									.getParentSysright().getRightCode());
							if ((pright != null)
									&& (pright.getParentSysright() != null)
									&& !rightCodeExists(
											pright.getParentSysright()
													.getRightCode(), funcs)) {
								result.add(pright.getParentSysright()
										.getRightCode());
							}
						}
					}
				}
			}
		}
		return result;
	}

	private boolean rightCodeExists(String fun, List<String> funcs) {
		for (String f : funcs) {
			if (fun.equals(f)) {
				return true;
			}
		}
		return false;
	}

	private List<String> getRightDelList(String funcs[],
			List<Sysright> sysrightList) {
		List<String> result = new ArrayList<String>();
		for (Sysright node : sysrightList) {
			boolean existFlag = false;
			for (String fun : funcs) {
				if (fun.equals(node.getRightCode())) {
					existFlag = true;
					break;
				}
			}
			if (!existFlag) {
				result.add(node.getRightCode());
			}
		}
		return result;
	}

	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = ServiceException.class)
	public void changeStaffStatus(Long id, String status) {
		Staff entity = this.staffDao.get(id);
		entity.setStatus(status);
		this.staffDao.update(entity);
		dataSync.publishStaffToRuby(id.toString(), null);
	}

	public Staff findValidStaffByLoginName(String userName) throws Exception {
		Staff staff = this.staffDao.findStaffByLoginName(userName,
				BiConst.VALID_STAFF_TAG);
		return staff;
	}

	// 2014-04-15
	public List<Staff> findByLoginName(String loginName) {
		return this.staffDao.findByLoginName(loginName);
	}
		
	public List<Staff> findByStatus(String status){
		return this.staffDao.findByStatus(status);
	}

	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = ServiceException.class)
	public void doChangePwd(Staff staff, String newPwd) {
		staff.setLoginPwd(newPwd);
		this.staffDao.update(staff);
	}
	
}
