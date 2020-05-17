package com.tianche.dao;

import java.util.List;

import com.tianche.domain.SystemMenu;

public interface SystemMenuDao {

	public List<SystemMenu> findByStaffId(Long id);

}
