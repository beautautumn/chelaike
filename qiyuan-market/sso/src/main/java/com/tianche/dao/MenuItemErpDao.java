package com.tianche.dao;

import com.tianche.domain.MenuItemErp;
import com.tianche.domain.SystemMenu;

import java.util.List;

public interface MenuItemErpDao {

	public List<MenuItemErp> findByStaffId(Long id);

}
