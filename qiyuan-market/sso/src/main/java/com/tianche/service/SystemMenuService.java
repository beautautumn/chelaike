package com.tianche.service;

import java.util.List;

import com.tianche.domain.SystemMenu;

public interface SystemMenuService {

	List<SystemMenu> findByStaffId(Long id);

}
