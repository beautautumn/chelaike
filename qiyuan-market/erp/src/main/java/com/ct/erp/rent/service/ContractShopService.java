package com.ct.erp.rent.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.ct.erp.lib.entity.ContractShop;
import com.ct.erp.rent.dao.AgencyDao;
import com.ct.erp.rent.dao.ContractShopDao;
import com.ct.erp.sys.service.base.StaffService;

@Service
public class ContractShopService {
	@Autowired
	private ContractShopDao contractShopDao;

	public List<ContractShop> findContractShopsByContractId(Long id) {
		return this.contractShopDao.findContractShopsByContractId(id);
	}
	
}
