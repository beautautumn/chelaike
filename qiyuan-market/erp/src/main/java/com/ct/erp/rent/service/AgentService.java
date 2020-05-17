package com.ct.erp.rent.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.ct.erp.common.exception.ServiceException;
import com.ct.erp.lib.entity.Agency;
import com.ct.erp.lib.entity.Agent;
import com.ct.erp.rent.dao.AgentDao;
import com.ct.erp.util.UcmsWebUtils;

@Service
public class AgentService {
	@Autowired
	private AgentDao AgentDao;
	@Autowired
	private AgencyService agencyService;

	public Agent findById(Long AgentId) {
		return AgentDao.findById(AgentId);
	}
	
	public List<Agent> findByAgencyId(Long agencyId){
		return AgentDao.findByAgencyId(agencyId);
	}
	
	public List<Agent> findByAgentName(Long agencyId,String agentName){
		return AgentDao.findByAgentName(agencyId,agentName);
	}

	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = ServiceException.class)
	public void update(Agent agent) {
		AgentDao.update(agent);
	}
	
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = ServiceException.class)
	public void delete(Long agentId) {
		Agent agent = this.AgentDao.findById(agentId);
		agent.setStatus("0");
		agent.setUpdateTime(UcmsWebUtils.now());
		this.AgentDao.update(agent);
	}
	
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = ServiceException.class)
	public void singleUpdate(Long agentId, String agentIdCard, String agentName) {
		Agent agent = this.AgentDao.findById(agentId);
		if(agent.getName().equals(agentName) && agent.getIdCard().equals(agentIdCard)){
			return ;
		}
		agent.setName(agentName);
		agent.setIdCard(agentIdCard);
		agent.setUpdateTime(UcmsWebUtils.now());
		this.AgentDao.update(agent);
	}
	
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = ServiceException.class)
	public void save(Agent agent,Long agencyId) {
		Agency agency = this.agencyService.findById(agencyId);
		agent.setAgency(agency);
		agent.setStatus("1");
		agent.setCreateTime(UcmsWebUtils.now());
		agent.setUpdateTime(UcmsWebUtils.now());
		this.AgentDao.save(agent);
	}

	public AgentDao getAgentDao() {
		return AgentDao;
	}

	public void setAgentDao(AgentDao agentDao) {
		AgentDao = agentDao;
	}
	
	
}
