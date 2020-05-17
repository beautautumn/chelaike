package com.ct.erp.rent.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.ct.erp.common.exception.ServiceException;
import com.ct.erp.lib.entity.Agency;
import com.ct.erp.lib.entity.Carport;
import com.ct.erp.rent.dao.AgencyDao;
import com.ct.erp.rent.dao.CarportDao;

@Service
public class CarportService  {
	@Autowired
	private AgencyDao agencyDao;

	@Autowired
	private CarportDao carportDao;
	
	/**
	 * 调整商户总车车位数（主要使用场景为调整合同的时候）
	 * 工具类
	 * @param agencyId 商户主键
	 * @param carPortNum 调整的车位数量：正数为新增，负数为减少
	 */
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = ServiceException.class)
	public Carport adjustTotalCarport(Long agencyId, Integer carPortNum){
		if(carPortNum == null){
			throw new ServiceException("adjustCarport 调整的车位数不能为null");
		}
		if(agencyId == null || agencyId == 0){
			throw new ServiceException("adjustCarport 调整的车位数车商的主键不能为null或者0；");
		}
		Carport carport = this.carportDao.findByAgencyId(agencyId);
		if(carport == null){
			Agency agency = this.agencyDao.findById(agencyId);
			carport = new Carport();
			carport.setAgency(agency);
			carport.setUsedNum(0);
			carport.setTotalNum(carPortNum);
			carport.setUnusedNum(carPortNum);
			this.carportDao.save(carport);
			return carport;
		}
		
		if(carport.getUnusedNum() + carPortNum < 0){
			throw new ServiceException("请先释放已占用车位再进行清算！");
		}
		carport.setTotalNum(carport.getTotalNum() + carPortNum);
		carport.setUnusedNum(carport.getUnusedNum() + carPortNum);
		this.carportDao.update(carport);
		return carport;
	}
	
	/**
	 * 调整商户总车车位数（主要使用场景为调整合同的时候）
	 * @param agencyId 商户主键
	 * @param carPortNum 调整的已使用车位数量：正数为占用车位数，负数为释放车位数
	 */
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = ServiceException.class)
	public Carport adjustCarport(Long agencyId, Integer carPortNum){
		if(carPortNum == null){
			throw new ServiceException("adjustCarport 调整的车位数不能为null");
		}
		if(agencyId == null || agencyId == 0){
			throw new ServiceException("adjustCarport 调整的车位数车商的主键不能为null或者0；");
		}
		Carport carport = this.carportDao.findByAgencyId(agencyId);
		if(carport == null){
			throw new ServiceException("adjustCarport 调整的车位数对象不能null；");
		}
		if(carport.getUnusedNum() - carPortNum < 0){
			throw new ServiceException("CarportService adjustCarport error：没有剩余车位数；");
		}
		carport.setUnusedNum(carport.getUnusedNum() - carPortNum);
		carport.setUsedNum(carport.getUsedNum() + carPortNum);
		this.carportDao.update(carport);
		return carport;
	}
	
	/**
	 * 占用车位数
	 * unusedNum - 1
	 * usedNum + 1
	 * @param agencyId
	 */
	public Carport occupyCarport(Long agencyId){
		return this.adjustCarport(agencyId, 1);
	}
	
	/**
	 * 释放车位数
	 * unusedNum + 1
	 * usedNum - 1
	 * @param agencyId
	 */
	public Carport releaseCarport(Long agencyId){
		return this.adjustCarport(agencyId, -1);
	}

	//更新车位数
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = ServiceException.class)
	public void updateCarport(Carport carport, int num) {
		carport.setTotalNum(carport.getTotalNum()+num);
		carport.setUnusedNum(carport.getUnusedNum()+num);
		carportDao.update(carport);
	}
}
