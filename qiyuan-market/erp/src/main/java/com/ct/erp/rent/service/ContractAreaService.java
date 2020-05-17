package com.ct.erp.rent.service;

import java.sql.Timestamp;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.ct.erp.lib.entity.ContractArea;
import com.ct.erp.rent.dao.ContractAreaDao;

@Service
public class ContractAreaService {
	@Autowired
	private ContractAreaDao contractAreaDao;
	
	public List<String> findAreaNo(){
		return this.contractAreaDao.findAreaNo();
	}
	
	public List<String> findAreaNoBeforeContinueEndDate(Timestamp continueEndDate){
		return this.contractAreaDao.findAreaNoBeforeContinueEndDate(continueEndDate);
	}
	
	

	public void save(ContractArea contractArea){
		this.contractAreaDao.save(contractArea);
	}

	

	
	public List<ContractArea> findContractAreaByAreaId(Long id){
		return this.contractAreaDao.findContractAreaByAreaId(id);
	}

	public List<String> findCurrentAreas() {
		
		return this.contractAreaDao.findCurrentAreas();
	}

	public List<ContractArea> findAll() {
		return this.contractAreaDao.findAll();
	}

	public List<ContractArea> findContractAreasByContractId(Long id) {
		
		return this.contractAreaDao.findContractAreasByContractId(id);
	}

	public List<ContractArea> findByAgencyId(Long id) {
		return this.contractAreaDao.findByAgencyId(id);
	}

}
