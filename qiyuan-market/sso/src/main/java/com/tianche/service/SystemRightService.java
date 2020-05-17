package com.tianche.service;

import java.util.List;

import com.tianche.domain.SystemRight;

public interface SystemRightService {

	List<SystemRight> findByStaffId(Long id);

}
