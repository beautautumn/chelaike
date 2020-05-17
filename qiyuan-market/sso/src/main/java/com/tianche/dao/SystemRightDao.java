package com.tianche.dao;

import java.util.List;

import com.tianche.domain.SystemRight;

public interface SystemRightDao {

	public List<SystemRight> findByStaffId(Long id);

}
